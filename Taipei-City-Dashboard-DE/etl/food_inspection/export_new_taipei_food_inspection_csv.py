"""抓取新北市食品抽驗資料，清洗後輸出 CSV。"""
from pathlib import Path

import pandas as pd
import requests

API_URL = "https://fsmc.ntpc.gov.tw/DigitalMap/PublicWebsite/GetFilteredAnalysisStoresWithCoordinates"
OUTPUT_CSV = Path(__file__).parent / "new_taipei_food_inspection.csv"
START_DATE = "2023-01-01"
END_DATE = "2025-12-31"


def normalize_text(value):
    if not isinstance(value, str):
        return value
    return " ".join(value.split())


# Extract
response = requests.post(
    API_URL,
    headers={"Content-Length": "0"},
    data=b"",
    timeout=60,
)
response.raise_for_status()
payload = response.json()
if not payload.get("success"):
    raise RuntimeError(f"API 回傳失敗: {payload}")

raw_data = pd.DataFrame(payload["data"])

# Transform
data = raw_data.rename(
    columns={
        "SD_StoreID": "store_id",
        "業者名稱": "vendor_name",
        "行政區": "district",
        "地址": "address",
        "Longitude": "lng",
        "Latitude": "lat",
        "抽驗結果": "result",
        "抽驗日期": "inspection_date",
        "檢驗項目": "inspection_item",
    }
)

data["inspection_date"] = pd.to_datetime(
    data["inspection_date"],
    format="%Y.%m.%d",
    errors="coerce",
)
data = data[
    data["inspection_date"].between(
        pd.Timestamp(START_DATE),
        pd.Timestamp(END_DATE),
        inclusive="both",
    )
].copy()
data["inspection_date"] = data["inspection_date"].dt.strftime("%Y-%m-%d")

text_columns = [
    "store_id",
    "vendor_name",
    "district",
    "address",
    "result",
    "inspection_item",
]
for column in text_columns:
    data[column] = data[column].map(normalize_text)

keep = [
    "store_id",
    "inspection_date",
    "inspection_item",
    "vendor_name",
    "district",
    "address",
    "lng",
    "lat",
    "result",
]
data = data[keep]

# Export
data.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
print(f"完成！共 {len(data)} 筆，輸出至 {OUTPUT_CSV}")
