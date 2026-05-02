"""抓取臺北市食品抽驗資料，清洗後輸出 CSV。"""
from pathlib import Path

import pandas as pd
import requests

API_URL = "https://foodtracer.health.gov.taipei/Front/Inspection/SearchData"
OUTPUT_CSV = Path(__file__).parent / "taipei_food_inspection.csv"
START_DATE = "2023-01-01"
END_DATE = "2025-12-31"

COLUMNS = [
    "source_id",
    "inspection_date",
    "inspection_topic",
    "food_category",
    "product_name",
    "district",
    "sampled_place",
    "result",
    "violation_detail",
]


def split_sampled_place(value):
    """Split values like 'vendor/address' while preserving the original field."""
    if not isinstance(value, str) or "/" not in value:
        return value, ""
    vendor, address = value.split("/", 1)
    return vendor.strip(), address.strip()


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
raw_data = pd.DataFrame(response.json(), columns=COLUMNS)

# Transform
data = raw_data.copy()
data["inspection_date"] = pd.to_datetime(
    data["inspection_date"],
    format="%Y%m%d",
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
data[["sampled_vendor", "sampled_address"]] = data["sampled_place"].apply(
    lambda value: pd.Series(split_sampled_place(value))
)
data["violation_detail"] = data["violation_detail"].fillna("")
text_columns = [
    "inspection_topic",
    "food_category",
    "product_name",
    "district",
    "sampled_vendor",
    "sampled_address",
    "sampled_place",
    "result",
    "violation_detail",
]
for column in text_columns:
    data[column] = data[column].map(normalize_text)

keep = [
    "source_id",
    "inspection_date",
    "inspection_topic",
    "food_category",
    "product_name",
    "district",
    "sampled_vendor",
    "sampled_address",
    "sampled_place",
    "result",
    "violation_detail",
]
data = data[keep]

# Export
data.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
print(f"完成！共 {len(data)} 筆，輸出至 {OUTPUT_CSV}")
