package ai

import (
	"TaipeiCityDashboardBE/app/models"
	"TaipeiCityDashboardBE/app/services/ai/providers/twcc"
	"TaipeiCityDashboardBE/app/services/ai/tools"
	"TaipeiCityDashboardBE/global"
	"TaipeiCityDashboardBE/logs"
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/tmc/langchaingo/llms"
	"golang.org/x/sync/semaphore"
)

var (
	// aiSemaphore limits the number of concurrent AI requests
	aiSemaphore *semaphore.Weighted
	twccModel   llms.Model
)

func init() {
	aiSemaphore = semaphore.NewWeighted(int64(global.TWCC.MaxConcurrent))
	twccModel = twcc.New(
		global.TWCC.ApiKey,
		global.TWCC.ApiUrl,
		global.TWCC.Model,
		global.TWCC.Timeout,
	)
}

type AIChatRequest struct {
	SessionID string                 `json:"session"`
	UserID    string                 `json:"user_id"`
	IPAddress string                 `json:"ip_address"`
	Messages  []llms.MessageContent  `json:"messages"`
	Params    map[string]interface{} `json:"params"`
}

// ChatWithTWCC handles the AI conversation logic including retries, tool calling loop, and logging.
func ChatWithTWCC(ctx context.Context, req AIChatRequest, options ...llms.CallOption) (*models.AIChatLog, error) {
	if err := aiSemaphore.Acquire(ctx, 1); err != nil {
		return nil, fmt.Errorf("server too busy: %v", err)
	}
	defer aiSemaphore.Release(1)

	session := newSession(req, options...)
	return session.run(ctx)
}

func newSession(req AIChatRequest, options ...llms.CallOption) *aiSession {
	s := &aiSession{
		req:             req,
		options:         options,
		currentMessages: make([]llms.MessageContent, 0),
		startTime:       time.Now(),
	}
	for _, opt := range options {
		opt(&s.callOpts)
	}
	s.forcedToolName = extractForcedToolName(s.callOpts.ToolChoice)
	s.injectInstructions()
	return s
}

type aiSession struct {
	req             AIChatRequest
	options         []llms.CallOption
	callOpts        llms.CallOptions
	currentMessages []llms.MessageContent
	totalInput      int
	totalOutput     int
	toolUsed        bool
	executedTools   []string
	lastResp        *llms.ContentResponse
	lastErr         error
	startTime       time.Time
	forcedToolName  string
	forcedToolDone  bool
	disableTools    bool
}

func (s *aiSession) run(ctx context.Context) (*models.AIChatLog, error) {
	maxLoops := 5
	s.executedTools = make([]string, 0)
	for i := 0; i < maxLoops; i++ {
		s.sendHeartbeat(ctx)

		if err := s.generate(ctx); err != nil {
			break
		}

		toolCalls := s.extractToolCalls()
		if len(toolCalls) == 0 {
			if s.forcedToolName != "" && !s.forcedToolDone {
				toolCalls = []llms.ToolCall{{
					ID:   fmt.Sprintf("forced_%d", time.Now().UnixNano()),
					Type: "function",
					FunctionCall: &llms.FunctionCall{
						Name:      s.forcedToolName,
						Arguments: "{}",
					},
				}}
				logs.FInfo("Loop %d: Force-executing tool %s due to tool_choice", i, s.forcedToolName)
			} else {
				break
			}
		}

		s.toolUsed = true
		logs.FInfo("Loop %d: Processing %d tool calls", i, len(toolCalls))
		if err := s.executeTools(ctx, toolCalls); err != nil {
			break
		}

		if s.forcedToolName != "" && s.forcedToolDone && !s.disableTools {
			s.disableTools = true
			s.currentMessages = append(s.currentMessages, llms.MessageContent{
				Role: llms.ChatMessageTypeSystem,
				Parts: []llms.ContentPart{llms.TextContent{
					Text: "Tool result is ready. Now provide the final summary in Traditional Chinese. Do not call any tool again.",
				}},
			})
		}
	}
	return s.finalize()
}

func extractForcedToolName(toolChoice interface{}) string {
	if toolChoice == nil {
		return ""
	}

	switch v := toolChoice.(type) {
	case string:
		s := strings.TrimSpace(v)
		if s == "" || s == "auto" || s == "none" {
			return ""
		}
		return s
	case map[string]interface{}:
		typ, _ := v["type"].(string)
		if typ != "function" {
			return ""
		}
		fn, _ := v["function"].(map[string]interface{})
		name, _ := fn["name"].(string)
		return strings.TrimSpace(name)
	default:
		return ""
	}
}

func (s *aiSession) sendHeartbeat(ctx context.Context) {
	if s.callOpts.StreamingFunc != nil {
		s.callOpts.StreamingFunc(ctx, []byte(": heartbeat\n\n"))
	}
}

func (s *aiSession) generate(ctx context.Context) error {
	maxRetry := global.TWCC.MaxRetry
	if s.callOpts.StreamingFunc != nil {
		maxRetry = 0
	}

	for i := 0; i <= maxRetry; i++ {
		opts := s.options
		if s.disableTools {
			opts = append(opts, llms.WithTools([]llms.Tool{}), llms.WithToolChoice("none"))
		}

		s.lastResp, s.lastErr = twccModel.GenerateContent(ctx, s.currentMessages, opts...)
		if s.lastErr == nil {
			s.updateTokens()
			return nil
		}
		logs.FError("Attempt %d failed: %v", i+1, s.lastErr)
		if i < maxRetry {
			time.Sleep(500 * time.Millisecond)
		}
	}
	return s.lastErr
}

func (s *aiSession) extractToolCalls() []llms.ToolCall {
	if s.lastResp == nil || len(s.lastResp.Choices) == 0 {
		return nil
	}
	tc, _ := s.lastResp.Choices[0].GenerationInfo["tool_calls"].([]llms.ToolCall)
	return tc
}

func (s *aiSession) updateTokens() {
	if s.lastResp == nil || len(s.lastResp.Choices) == 0 {
		return
	}
	if usage, ok := s.lastResp.Choices[0].GenerationInfo["usage"].(map[string]interface{}); ok {
		s.totalInput += parseUsageInt(usage["input_tokens"])
		s.totalOutput += parseUsageInt(usage["output_tokens"])
	}
}

func (s *aiSession) executeTools(ctx context.Context, toolCalls []llms.ToolCall) error {
	choice := s.lastResp.Choices[0]

	// Add Assistant's intent
	s.currentMessages = append(s.currentMessages, llms.MessageContent{
		Role:  llms.ChatMessageTypeAI,
		Parts: append([]llms.ContentPart{llms.TextContent{Text: choice.Content}}, toolsToParts(toolCalls)...),
	})

	for _, tc := range toolCalls {
		if tc.FunctionCall == nil {
			continue
		}
		if s.forcedToolName != "" {
			// In forced tool mode, execute at most once and only that exact tool.
			if tc.FunctionCall.Name != s.forcedToolName || s.forcedToolDone {
				continue
			}
		}

		s.executedTools = append(s.executedTools, tc.FunctionCall.Name)
		result, err := tools.Execute(ctx, tc.FunctionCall.Name, tc.FunctionCall.Arguments)
		if err != nil {
			result = fmt.Sprintf("Error: %v. Please verify arguments.", err)
			logs.FError("Tool Error: %v", err)
		}
		result = formatToolResultForLLM(tc.FunctionCall.Name, result)
		toolCallID := normalizeToolCallID(tc.ID)

		s.currentMessages = append(s.currentMessages, llms.MessageContent{
			Role: llms.ChatMessageTypeTool,
			Parts: []llms.ContentPart{llms.ToolCallResponse{
				ToolCallID: toolCallID, Name: tc.FunctionCall.Name, Content: result,
			}},
		})

		if s.forcedToolName != "" && tc.FunctionCall.Name == s.forcedToolName {
			s.forcedToolDone = true
		}
	}
	return nil
}

func normalizeToolCallID(id string) string {
	v := strings.TrimSpace(strings.ToLower(id))
	if v == "" || v == "null" {
		return fmt.Sprintf("call_%d", time.Now().UnixNano())
	}
	return id
}

func (s *aiSession) injectInstructions() {
	toolNames := ""
	hasFoodSafetyTool := false
	for i, t := range s.callOpts.Tools {
		if i > 0 {
			toolNames += ", "
		}
		toolNames += t.Function.Name
		if t.Function != nil && t.Function.Name == "get_food_safety_risk_rank" {
			hasFoodSafetyTool = true
		}
	}

	instruction := fmt.Sprintf("\nSystem Instruction:\n1. Use ONLY: [%s].\n2. NEVER nest tool calls \n3. Arguments MUST be literal values (strings, integers, etc.), never function calls \n4. For dependent tasks, call tools sequentially in separate turns.\n5. If stuck, respond with text.\n6. Always provide a concise summary first, not a raw list dump.\n7. Do NOT output raw JSON, SQL, or full dashboard component catalog unless the user explicitly asks for raw data.\n8. For health-related questions, prioritize practical explanation and actionable advice.", toolNames)
	if hasFoodSafetyTool {
		instruction += "\n9. For food safety and health risk questions, call get_food_safety_risk_rank before giving final analysis."
	}

	s.currentMessages = make([]llms.MessageContent, 0)
	merged := false
	for _, m := range s.req.Messages {
		if m.Role == llms.ChatMessageTypeSystem && !merged {
			s.currentMessages = append(s.currentMessages, mergeSystemMsg(m, instruction))
			merged = true
		} else {
			s.currentMessages = append(s.currentMessages, m)
		}
	}

	if !merged {
		s.currentMessages = append([]llms.MessageContent{{
			Role:  llms.ChatMessageTypeSystem,
			Parts: []llms.ContentPart{llms.TextContent{Text: instruction}},
		}}, s.currentMessages...)
	}
}

func formatToolResultForLLM(toolName string, raw string) string {
	if toolName == "get_food_safety_risk_rank" {
		return "TOOL_RESULT:\n" + raw + "\n\nRESPONSE_RULE:\n請先摘要重點，再解釋風險意義與建議；除非使用者要求，不要逐項列完整清單。"
	}
	return raw
}

func (s *aiSession) finalize() (*models.AIChatLog, error) {
	log := &models.AIChatLog{
		SessionID: s.req.SessionID, UserID: s.req.UserID, IPAddress: s.req.IPAddress,
		Provider: "twcc", Model: global.TWCC.Model, LatencyMS: int(time.Since(s.startTime).Milliseconds()),
		Status: "success", Tools: "[]", CreatedAt: s.startTime,
	}

	if len(s.req.Messages) > 0 {
		log.Question = extractText(s.req.Messages[len(s.req.Messages)-1])
	}

	if s.lastErr != nil {
		log.Status, log.ErrorCode, log.ErrorMessage = "error", "MODEL_ERROR", s.lastErr.Error()
		models.CreateAIChatLog(log)
		return log, s.lastErr
	}

	if s.lastResp != nil && len(s.lastResp.Choices) > 0 {
		log.Answer = s.lastResp.Choices[0].Content
		log.InputTokens, log.OutputTokens = s.totalInput, s.totalOutput
		log.TotalTokens = s.totalInput + s.totalOutput
		if s.toolUsed {
			log.ToolUsed = true
			if toolJSON, err := json.Marshal(s.executedTools); err == nil {
				log.Tools = string(toolJSON)
			}
		}
	}

	if err := models.CreateAIChatLog(log); err != nil {
		logs.FError("DB Log Error: %v", err)
	}
	return log, nil
}

func toolsToParts(calls []llms.ToolCall) []llms.ContentPart {
	parts := make([]llms.ContentPart, len(calls))
	for i, c := range calls {
		parts[i] = c
	}
	return parts
}

func mergeSystemMsg(m llms.MessageContent, instruction string) llms.MessageContent {
	newParts := make([]llms.ContentPart, len(m.Parts))
	for i, p := range m.Parts {
		if tp, ok := p.(llms.TextContent); ok {
			newParts[i] = llms.TextContent{Text: tp.Text + instruction}
		} else {
			newParts[i] = p
		}
	}
	return llms.MessageContent{Role: m.Role, Parts: newParts}
}

func extractText(m llms.MessageContent) string {
	for _, p := range m.Parts {
		if t, ok := p.(llms.TextContent); ok {
			return t.Text
		}
	}
	return ""
}

func parseUsageInt(val interface{}) int {
	switch v := val.(type) {
	case int:
		return v
	case float64:
		return int(v)
	default:
		return 0
	}
}
