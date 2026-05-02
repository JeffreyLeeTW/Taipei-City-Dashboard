"""從雙北食品抽驗 CSV 產生 2023-2025 不合格業者明細與圖表統計資料。"""
from pathlib import Path

import pandas as pd

BASE_DIR = Path(__file__).parent
TAIPEI_SOURCE = BASE_DIR / "taipei_food_inspection.csv"
NEW_TAIPEI_SOURCE = BASE_DIR / "new_taipei_food_inspection.csv"

METRO_TAIPEI_FAILED_CSV = BASE_DIR / "metrotaipei_failed_food_inspection.csv"

FAILED_PATTERN = "不符合規定|不合格"
START_DATE = "2023-01-01"
END_DATE = "2025-12-31"

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
    "violation_detail",
    "sampled_place",
]


def get_failed_rows(data):
    filtered = data.copy()
    filtered["inspection_date"] = pd.to_datetime(filtered["inspection_date"], errors="coerce")
    filtered = filtered[
        filtered["inspection_date"].between(
            pd.Timestamp(START_DATE),
            pd.Timestamp(END_DATE),
            inclusive="both",
        )
    ].copy()
    filtered["inspection_date"] = filtered["inspection_date"].dt.strftime("%Y-%m-%d")
    return filtered[
        filtered["result"].astype(str).str.contains(FAILED_PATTERN, na=False)
    ].copy()


def normalize_failed_taipei(data):
    failed = get_failed_rows(data)
    failed.insert(0, "city", "臺北市")
    failed["record_id"] = failed["source_id"].astype(str)
    failed["inspection_item"] = failed["inspection_topic"]
    failed["vendor_name"] = failed["sampled_vendor"]
    failed["address"] = failed["sampled_address"]
    failed["lng"] = ""
    failed["lat"] = ""
    return failed[DETAIL_COLUMNS]


def normalize_failed_new_taipei(data):
    failed = get_failed_rows(data)
    failed.insert(0, "city", "新北市")
    failed["record_id"] = failed["store_id"].astype(str)
    failed["food_category"] = ""
    failed["product_name"] = ""
    failed["violation_detail"] = ""
    failed["sampled_place"] = failed["vendor_name"].fillna("") + "/" + failed["address"].fillna("")
    return failed[DETAIL_COLUMNS]


def main():
    taipei = pd.read_csv(TAIPEI_SOURCE)
    new_taipei = pd.read_csv(NEW_TAIPEI_SOURCE)

    taipei_failed = normalize_failed_taipei(taipei)
    new_taipei_failed = normalize_failed_new_taipei(new_taipei)
    metrotaipei_failed = pd.concat(
        [taipei_failed, new_taipei_failed],
        ignore_index=True,
    )

    metrotaipei_failed.to_csv(
        METRO_TAIPEI_FAILED_CSV,
        index=False,
        encoding="utf-8-sig",
    )

    print(f"{METRO_TAIPEI_FAILED_CSV}: {len(metrotaipei_failed)}")
    print(f"臺北市: {len(taipei_failed)}")
    print(f"新北市: {len(new_taipei_failed)}")


if __name__ == "__main__":
    main()
