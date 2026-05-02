"""抓取雙北食品抽驗資料，清洗後輸出 2023-2025 合格與不合格業者 CSV。"""
import sys
from pathlib import Path

import pandas as pd
import requests

DE_DIR = Path(__file__).resolve().parents[2]
DAGS_DIR = DE_DIR / "dags"
if str(DAGS_DIR) not in sys.path:
    sys.path.insert(0, str(DAGS_DIR))

from utils.transform_time import convert_str_to_time_format  # noqa: E402

BASE_DIR = Path(__file__).parent
OUTPUT_CSV = BASE_DIR / "food_inspection.csv"

TAIPEI_API_URL = "https://foodtracer.health.gov.taipei/Front/Inspection/SearchData"
NEW_TAIPEI_API_URL = (
    "https://fsmc.ntpc.gov.tw/DigitalMap/PublicWebsite/"
    "GetFilteredAnalysisStoresWithCoordinates"
)

START_DATE = "2023-01-01"
END_DATE = "2025-12-31"
FAILED_PATTERN = "不符合規定|不合格"
CREATED_AT = "2026-05-02T00:00:00Z"

TAIPEI_COLUMNS = [
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

DETAIL_COLUMNS = [
    "city",
    "record_id",
    "inspection_date",
    "inspection_item",
    "food_category",
    "product_name",
    "vendor_name",
    "district",
    "address",
    "lng",
    "lat",
    "result",
    "inspection_status",
    "violation_detail",
    "sampled_place",
]


def normalize_text(value):
    if not isinstance(value, str):
        return value
    return " ".join(value.split())


def split_sampled_place(value):
    """Split values like 'vendor/address' while preserving the original field."""
    if not isinstance(value, str) or "/" not in value:
        return value, ""
    vendor, address = value.split("/", 1)
    return vendor.strip(), address.strip()


def filter_inspection_date(data, from_format):
    data = data.copy()
    data["inspection_date"] = convert_str_to_time_format(
        data["inspection_date"],
        from_format=from_format,
        output_level="date",
        output_type="str",
        errors="coerce",
    )
    return data[
        pd.to_datetime(data["inspection_date"], errors="coerce").between(
            pd.Timestamp(START_DATE),
            pd.Timestamp(END_DATE),
            inclusive="both",
        )
    ].copy()


def add_inspection_status(data):
    data = data.copy()
    failed = data["result"].astype(str).str.contains(FAILED_PATTERN, na=False)
    data["inspection_status"] = failed.map({True: "不合格", False: "合格"})
    return data


def get_taipei_data():
    response = requests.post(
        TAIPEI_API_URL,
        headers={"Content-Length": "0"},
        data=b"",
        timeout=60,
    )
    response.raise_for_status()
    raw_data = pd.DataFrame(response.json(), columns=TAIPEI_COLUMNS)

    data = filter_inspection_date(raw_data, "%Y%m%d")
    data[["vendor_name", "address"]] = data["sampled_place"].apply(
        lambda value: pd.Series(split_sampled_place(value))
    )
    data = data.rename(
        columns={
            "source_id": "record_id",
            "inspection_topic": "inspection_item",
        }
    )
    data["city"] = "臺北市"
    data["lng"] = ""
    data["lat"] = ""
    data["violation_detail"] = data["violation_detail"].fillna("")
    data = add_inspection_status(data)

    text_columns = [
        "record_id",
        "inspection_item",
        "food_category",
        "product_name",
        "district",
        "vendor_name",
        "address",
        "sampled_place",
        "result",
        "inspection_status",
        "violation_detail",
    ]
    for column in text_columns:
        data[column] = data[column].map(normalize_text)

    return data[DETAIL_COLUMNS]


def get_new_taipei_data():
    response = requests.post(
        NEW_TAIPEI_API_URL,
        headers={"Content-Length": "0"},
        data=b"",
        timeout=60,
    )
    response.raise_for_status()
    payload = response.json()
    if not payload.get("success"):
        raise RuntimeError(f"API 回傳失敗: {payload}")

    raw_data = pd.DataFrame(payload["data"])
    data = raw_data.rename(
        columns={
            "SD_StoreID": "record_id",
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

    data = filter_inspection_date(data, "%Y.%m.%d")
    data["city"] = "新北市"
    data["food_category"] = ""
    data["product_name"] = ""
    data["violation_detail"] = ""
    data["sampled_place"] = (
        data["vendor_name"].fillna("") + "/" + data["address"].fillna("")
    )
    data = add_inspection_status(data)

    text_columns = [
        "record_id",
        "inspection_item",
        "vendor_name",
        "district",
        "address",
        "result",
        "inspection_status",
        "sampled_place",
    ]
    for column in text_columns:
        data[column] = data[column].map(normalize_text)

    return data[DETAIL_COLUMNS]


def main():
    taipei = get_taipei_data()
    new_taipei = get_new_taipei_data()
    food_inspection = pd.concat([taipei, new_taipei], ignore_index=True)
    food_inspection.insert(0, "id", range(1, len(food_inspection) + 1))
    food_inspection.insert(1, "created_at", CREATED_AT)

    food_inspection.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")

    print(f"{OUTPUT_CSV}: {len(food_inspection)}")
    print(f"臺北市: {len(taipei)}")
    print(f"新北市: {len(new_taipei)}")
    print(food_inspection.groupby(["city", "inspection_status"]).size())


if __name__ == "__main__":
    main()
