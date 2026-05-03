package tools

import "github.com/tmc/langchaingo/llms"

// DefaultLLMTools returns the built-in tool definitions for AI chat.
func DefaultLLMTools() []llms.Tool {
	return []llms.Tool{
		{
			Type: "function",
			Function: &llms.FunctionDefinition{
				Name:        "get_current_time",
				Description: "取得目前台北時間",
				Parameters: map[string]interface{}{
					"type":       "object",
					"properties": map[string]interface{}{},
				},
			},
		},
		{
			Type: "function",
			Function: &llms.FunctionDefinition{
				Name:        "get_population_summary",
				Description: "查詢台北市或新北市特定年度的人口結構摘要",
				Parameters: map[string]interface{}{
					"type": "object",
					"properties": map[string]interface{}{
						"city": map[string]interface{}{
							"type":        "string",
							"description": "城市，支援 taipei 或 new_taipei",
						},
						"year": map[string]interface{}{
							"type":        "integer",
							"description": "西元年份，例如 2025",
						},
					},
					"required": []string{"year"},
				},
			},
		},
		{
			Type: "function",
			Function: &llms.FunctionDefinition{
				Name:        "get_food_safety_risk_rank",
				Description: "查詢食安風險評估指數（對應 food_safety_risk_rank_map）",
				Parameters: map[string]interface{}{
					"type": "object",
					"properties": map[string]interface{}{
						"city": map[string]interface{}{
							"type":        "string",
							"description": "查詢範圍：taipei（臺北市）或 metrotaipei（雙北）",
							"enum":        []string{"taipei", "metrotaipei"},
						},
						"top_k": map[string]interface{}{
							"type":        "integer",
							"description": "回傳前 N 名，範圍 1~50，預設 10",
							"minimum":     1,
							"maximum":     50,
						},
						"district": map[string]interface{}{
							"type":        "string",
							"description": "可選，指定行政區名稱（例如 中正區）",
						},
					},
				},
			},
		},
	}
}
