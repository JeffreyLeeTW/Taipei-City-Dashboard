"""抓取新北市 YouBike 2.0 即時站點資料，清洗後輸出 CSV。"""
import sys
from pathlib import Path

import requests
import pandas as pd

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "Taipei-City-Dashboard" / "Taipei-City-Dashboard-DE" / "dags"))

API_URL = "https://data.ntpc.gov.tw/api/datasets/010e5b15-3823-4b20-b401-b1cf000550c5/csv?page=0&size=9999"
OUTPUT_CSV = Path(__file__).parent / "youbike_ntpc.csv"

# Extract
response = requests.get(API_URL, timeout=30)
response.raise_for_status()
raw_data = pd.read_csv(
    __import__("io").StringIO(response.text),
    dtype=str,
)

# Transform
data = raw_data.rename(columns={
    "sno":          "station_id",
    "sna":          "station_name",
    "sarea":        "district",
    "ar":           "address",
    "lat":          "lat",
    "lng":          "lng",
    "tot_quantity": "tot_quantity",
    "sbi_quantity": "sbi_quantity",
    "bemp":         "bemp",
    "act":          "act",
    "mday":         "data_time",
    "yb2_quantity": "yb2_quantity",
    "eyb_quantity": "eyb_quantity",
})

keep = ["station_id", "station_name", "district", "address",
        "lat", "lng", "tot_quantity", "sbi_quantity", "bemp",
        "act", "data_time", "yb2_quantity", "eyb_quantity"]
data = data[keep]

# mday 格式: "20260428T142302" → naive datetime (台北當地時間)
# 後端讀出 timestamptz 後直接貼 +08:00 標籤，不做時區轉換，
# 故存入 naive 本地時間讓標籤與實際時刻相符。
data["data_time"] = pd.to_datetime(data["data_time"], format="%Y%m%dT%H%M%S")

# Export
data.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
print(f"完成！共 {len(data)} 筆，輸出至 {OUTPUT_CSV}")
