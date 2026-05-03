package tools

import (
	"TaipeiCityDashboardBE/app/models"
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

const (
	foodSafetyRiskMapIndex = "food_safety_risk_rank_map"
	cityTaipei             = "taipei"
	cityMetroTaipei        = "metrotaipei"
)

type FoodSafetyRiskArgs struct {
	City     string `json:"city"`
	TopK     int    `json:"top_k"`
	District string `json:"district"`
}

type foodSafetyRiskRow struct {
	District string  `gorm:"column:x_axis" json:"district"`
	Score    float64 `gorm:"column:data" json:"score"`
}

type foodSafetyRiskResult struct {
	Metric  string              `json:"metric"`
	City    string              `json:"city"`
	Formula map[string]float64  `json:"formula"`
	Results []foodSafetyRiskRow `json:"results"`
}

// GetFoodSafetyRiskRank queries food safety risk ranking scores by district.
// It first tries query_charts.query_chart for food_safety_risk_rank_map, then falls back to built-in SQL.
func GetFoodSafetyRiskRank(ctx context.Context, args string) (string, error) {
	_ = ctx

	var params FoodSafetyRiskArgs
	if err := parseArgs(args, &params); err != nil {
		return "", fmt.Errorf("invalid arguments: %v", err)
	}

	city := normalizeFoodSafetyCity(params.City)
	topK := params.TopK
	if topK <= 0 {
		topK = 10
	}
	if topK > 50 {
		topK = 50
	}

	queryString, err := getFoodSafetyQueryFromConfig(city)
	if err != nil || strings.TrimSpace(queryString) == "" {
		queryString = fallbackFoodSafetyRiskSQL(city)
	}

	var rows []foodSafetyRiskRow
	if err := models.DBDashboard.Raw(queryString).Scan(&rows).Error; err != nil {
		return "", fmt.Errorf("failed to query food safety risk rank: %v", err)
	}
	if len(rows) == 0 {
		return "", fmt.Errorf("查無食安風險排行資料")
	}

	if district := strings.TrimSpace(params.District); district != "" {
		filtered := make([]foodSafetyRiskRow, 0, 1)
		for _, row := range rows {
			if strings.EqualFold(strings.TrimSpace(row.District), district) || strings.TrimSpace(row.District) == district {
				filtered = append(filtered, row)
			}
		}
		rows = filtered
		if len(rows) == 0 {
			return "", fmt.Errorf("查無行政區「%s」的食安風險分數", district)
		}
	}

	if len(rows) > topK {
		rows = rows[:topK]
	}

	payload := foodSafetyRiskResult{
		Metric: foodSafetyRiskMapIndex,
		City:   city,
		Formula: map[string]float64{
			"disease_weight":         0.50,
			"inspection_fail_weight": 0.35,
			"care_gap_weight":        0.15,
		},
		Results: rows,
	}

	out, err := json.Marshal(payload)
	if err != nil {
		return "", fmt.Errorf("failed to marshal food safety result: %v", err)
	}
	return string(out), nil
}

func getFoodSafetyQueryFromConfig(city string) (string, error) {
	var row struct {
		QueryChart string `gorm:"column:query_chart"`
	}

	err := models.DBManager.Table("query_charts").
		Select("query_chart").
		Where("\"index\" = ? AND city = ?", foodSafetyRiskMapIndex, city).
		Order("updated_at DESC").
		Limit(1).
		Scan(&row).Error
	if err != nil {
		return "", err
	}
	return row.QueryChart, nil
}

func normalizeFoodSafetyCity(input string) string {
	v := strings.TrimSpace(strings.ToLower(input))
	switch v {
	case "", "taipei", "tpe", "台北", "臺北", "台北市", "臺北市":
		return cityTaipei
	case "metrotaipei", "metro_taipei", "newtaipei", "new_taipei", "雙北", "双北":
		return cityMetroTaipei
	default:
		return cityTaipei
	}
}

func fallbackFoodSafetyRiskSQL(city string) string {
	if city == cityMetroTaipei {
		return "WITH districts AS (" +
			"SELECT DISTINCT city, district FROM public.foodborne_disease WHERE trim(year)::int BETWEEN 112 AND 114 AND district <> '其他' " +
			"UNION SELECT DISTINCT city, district FROM public.food_inspection " +
			"UNION SELECT DISTINCT city, district FROM public.emergency_medical_service" +
			"), disease AS (" +
			"SELECT city, district, SUM(cases)::float AS disease_cases FROM public.foodborne_disease WHERE trim(year)::int BETWEEN 112 AND 114 GROUP BY city, district" +
			"), inspection AS (" +
			"SELECT city, district, SUM(count)::float AS inspections, SUM(CASE WHEN result THEN 0 ELSE count END)::float AS failed_inspections FROM public.food_inspection GROUP BY city, district" +
			"), hospital AS (" +
			"SELECT city, district, COUNT(*)::float AS hospitals FROM public.emergency_medical_service GROUP BY city, district" +
			"), metrics AS (" +
			"SELECT districts.district, COALESCE(disease.disease_cases, 0) AS disease_cases, COALESCE(inspection.inspections, 0) AS inspections, COALESCE(inspection.failed_inspections, 0) AS failed_inspections, COALESCE(hospital.hospitals, 0) AS hospitals " +
			"FROM districts " +
			"LEFT JOIN disease ON disease.city = districts.city AND disease.district = districts.district " +
			"LEFT JOIN inspection ON inspection.city = districts.city AND inspection.district = districts.district " +
			"LEFT JOIN hospital ON hospital.city = districts.city AND hospital.district = districts.district" +
			"), scored AS (" +
			"SELECT metrics.*, CASE WHEN SUM(inspections) OVER () > 0 THEN SUM(failed_inspections) OVER () / SUM(inspections) OVER () ELSE 0 END AS avg_fail_rate FROM metrics" +
			"), indexed AS (" +
			"SELECT district, disease_cases / NULLIF(MAX(disease_cases) OVER (), 0) AS disease_index, " +
			"((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0)) / NULLIF(MAX((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0)) OVER (), 0) AS fail_index, " +
			"1 - hospitals / NULLIF(MAX(hospitals) OVER (), 0) AS care_gap FROM scored" +
			") " +
			"SELECT district AS x_axis, ROUND((100 * (0.50 * COALESCE(disease_index, 0) + 0.35 * COALESCE(fail_index, 0) + 0.15 * COALESCE(care_gap, 1)))::numeric, 1)::float AS data " +
			"FROM indexed ORDER BY data DESC, district"
	}

	return "WITH districts AS (" +
		"SELECT DISTINCT city, district FROM public.foodborne_disease WHERE city = '臺北市' AND trim(year)::int BETWEEN 112 AND 114 " +
		"UNION SELECT DISTINCT city, district FROM public.food_inspection WHERE city = '臺北市' " +
		"UNION SELECT DISTINCT city, district FROM public.emergency_medical_service WHERE city = '臺北市'" +
		"), disease AS (" +
		"SELECT city, district, SUM(cases)::float AS disease_cases FROM public.foodborne_disease WHERE city = '臺北市' AND trim(year)::int BETWEEN 112 AND 114 GROUP BY city, district" +
		"), inspection AS (" +
		"SELECT city, district, SUM(count)::float AS inspections, SUM(CASE WHEN result THEN 0 ELSE count END)::float AS failed_inspections FROM public.food_inspection WHERE city = '臺北市' GROUP BY city, district" +
		"), hospital AS (" +
		"SELECT city, district, COUNT(*)::float AS hospitals FROM public.emergency_medical_service WHERE city = '臺北市' GROUP BY city, district" +
		"), metrics AS (" +
		"SELECT districts.district, COALESCE(disease.disease_cases, 0) AS disease_cases, COALESCE(inspection.inspections, 0) AS inspections, COALESCE(inspection.failed_inspections, 0) AS failed_inspections, COALESCE(hospital.hospitals, 0) AS hospitals " +
		"FROM districts " +
		"LEFT JOIN disease ON disease.city = districts.city AND disease.district = districts.district " +
		"LEFT JOIN inspection ON inspection.city = districts.city AND inspection.district = districts.district " +
		"LEFT JOIN hospital ON hospital.city = districts.city AND hospital.district = districts.district" +
		"), scored AS (" +
		"SELECT metrics.*, CASE WHEN SUM(inspections) OVER () > 0 THEN SUM(failed_inspections) OVER () / SUM(inspections) OVER () ELSE 0 END AS avg_fail_rate FROM metrics" +
		"), indexed AS (" +
		"SELECT district, disease_cases / NULLIF(MAX(disease_cases) OVER (), 0) AS disease_index, " +
		"((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0)) / NULLIF(MAX((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0)) OVER (), 0) AS fail_index, " +
		"1 - hospitals / NULLIF(MAX(hospitals) OVER (), 0) AS care_gap FROM scored" +
		") " +
		"SELECT district AS x_axis, ROUND((100 * (0.50 * COALESCE(disease_index, 0) + 0.35 * COALESCE(fail_index, 0) + 0.15 * COALESCE(care_gap, 1)))::numeric, 1)::float AS data " +
		"FROM indexed ORDER BY data DESC, district"
}
