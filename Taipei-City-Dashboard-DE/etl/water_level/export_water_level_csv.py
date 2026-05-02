"""抓取臺北市河川水位 API，清洗後輸出 CSV。"""
import sys
from pathlib import Path

import requests
import pandas as pd

sys.path.insert(0, str(Path(__file__).parent.parent.parent / "Taipei-City-Dashboard" / "Taipei-City-Dashboard-DE" / "dags"))

from utils.transform_time import convert_str_to_time_format  # noqa: E402

API_URL = "https://wic.gov.taipei/OpenData/API/Water/Get?stationNo=&loginId=river&dataKey=9E2648AA"
OUTPUT_CSV = Path(__file__).parent / "water_level.csv"

# Extract
response = requests.get(API_URL, timeout=30)
response.raise_for_status()
raw_data = pd.DataFrame(response.json()["data"])

# Transform
data = raw_data.rename(columns={
    "stationNo":   "station_id",
    "stationName": "station_name",
    "recTime":     "data_time",
    "levelOut":    "water_level",
})
data["data_time"] = convert_str_to_time_format(data["data_time"])
# 後端讀出 timestamptz 後會直接加 +08:00 標籤（不做時區轉換），
# 所以存入 naive 時間讓 postgres 以 UTC 儲存台北當地時刻，補償後端行為。
data["data_time"] = pd.to_datetime(data["data_time"]).apply(lambda x: x.replace(tzinfo=None))

# Export
data.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
print(f"完成！共 {len(data)} 筆，輸出至 {OUTPUT_CSV}")
