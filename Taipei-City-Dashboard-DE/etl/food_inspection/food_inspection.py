"""從 API 取得雙北食品抽驗資料，輸出指定 CSV 格式。"""
import csv
import json
from collections import OrderedDict
from datetime import datetime
from pathlib import Path
from urllib.request import Request, urlopen

BASE_DIR = Path(__file__).parent
OUTPUT_CSV = BASE_DIR / "food_inspection.csv"

TAIPEI_API_URL = "https://foodtracer.health.gov.taipei/Front/Inspection/SearchData"
NEW_TAIPEI_API_URL = (
    "https://fsmc.ntpc.gov.tw/DigitalMap/PublicWebsite/"
    "GetFilteredAnalysisStoresWithCoordinates"
)

START_DATE = "2023-01-01"
END_DATE = "2025-12-31"

TAIPEI_COLUMNS = [
    "record_id",
    "inspection_date",
    "inspection_item",
    "food_category",
    "product_name",
    "district",
    "sampled_place",
    "result",
    "violation_detail",
]

OUTPUT_COLUMNS = [
    "record_id",
    "count",
    "city",
    "district",
    "year",
    "inspection_date",
    "inspection_item",
    "vender_name",
    "address",
    "result",
    "inspection_status",
    "violation_detail",
    "sampled_place",
]

DATE_FORMATS = ("%Y-%m-%d", "%Y/%m/%d", "%Y.%m.%d", "%Y%m%d")


def normalize_text(value):
    if value is None:
        return ""
    return " ".join(str(value).split())


def normalize_city(value):
    return normalize_text(value).replace("台北市", "臺北市")


def request_post_json(url):
    request = Request(url, data=b"", method="POST")
    request.add_header("Content-Length", "0")
    with urlopen(request, timeout=60) as response:
        return json.loads(response.read().decode("utf-8-sig"))


def normalize_date(value):
    value = normalize_text(value)
    if not value:
        return ""
    for date_format in DATE_FORMATS:
        try:
            return datetime.strptime(value, date_format).strftime("%Y-%m-%d")
        except ValueError:
            continue
    return value


def within_date_range(value):
    try:
        date = datetime.strptime(value, "%Y-%m-%d").date()
        return (
            datetime.strptime(START_DATE, "%Y-%m-%d").date()
            <= date
            <= datetime.strptime(END_DATE, "%Y-%m-%d").date()
        )
    except ValueError:
        return False


def normalize_result(value):
    value = normalize_text(value)
    if value.upper() in {"TRUE", "T", "1"} or value == "合格" or ("符合規定" in value and "不符合" not in value):
        return "TRUE"
    if value.upper() in {"FALSE", "F", "0"} or "不符合" in value or "不合格" in value:
        return "FALSE"
    return value


def split_sampled_place(value):
    value = normalize_text(value)
    if "/" not in value:
        return value, ""
    vender_name, address = value.split("/", 1)
    return normalize_text(vender_name), normalize_city(address)


def clean_row(row):
    cleaned = {column: normalize_text(row.get(column, "")) for column in OUTPUT_COLUMNS}
    cleaned["city"] = normalize_city(cleaned["city"])
    cleaned["address"] = normalize_city(cleaned["address"])
    cleaned["inspection_date"] = normalize_date(cleaned["inspection_date"])
    cleaned["year"] = cleaned["inspection_date"][:4]
    cleaned["result"] = normalize_result(cleaned["result"])
    cleaned["inspection_status"] = (
        "合格" if cleaned["result"] == "TRUE" else
        "不合格" if cleaned["result"] == "FALSE" else ""
    )
    cleaned["sampled_place"] = cleaned["sampled_place"] or (
        f"{cleaned['vender_name']}/{cleaned['address']}"
    )
    return cleaned


def aggregate_rows(rows):
    grouped = OrderedDict()
    for row in rows:
        key = (
            row["city"],
            row["district"],
            row["inspection_date"],
            row["inspection_item"],
            row["vender_name"],
            row["address"],
            row["result"],
            row["violation_detail"],
            row["sampled_place"],
        )
        if key not in grouped:
            grouped[key] = row.copy()
            grouped[key]["count"] = 0
        grouped[key]["count"] += 1

    output = []
    for row in grouped.values():
        row["count"] = str(row["count"])
        output.append(row)
    return output


def get_taipei_data():
    payload = request_post_json(TAIPEI_API_URL)
    rows = []
    for source_values in payload:
        source = dict(zip(TAIPEI_COLUMNS, source_values))
        inspection_date = normalize_date(source.get("inspection_date"))
        if not within_date_range(inspection_date):
            continue

        vender_name, address = split_sampled_place(source.get("sampled_place"))
        rows.append(
            clean_row(
                {
                    "record_id": source.get("record_id"),
                    "city": "臺北市",
                    "district": source.get("district"),
                    "inspection_date": inspection_date,
                    "inspection_item": source.get("inspection_item"),
                    "vender_name": vender_name,
                    "address": address,
                    "result": source.get("result"),
                    "violation_detail": source.get("violation_detail"),
                    "sampled_place": source.get("sampled_place"),
                }
            )
        )
    return aggregate_rows(rows)


def get_new_taipei_data():
    payload = request_post_json(NEW_TAIPEI_API_URL)
    if not payload.get("success"):
        raise RuntimeError(f"API 回傳失敗: {payload}")

    rows = []
    for source in payload["data"]:
        inspection_date = normalize_date(source.get("抽驗日期"))
        if not within_date_range(inspection_date):
            continue

        vender_name = normalize_text(source.get("業者名稱"))
        address = normalize_city(source.get("地址"))
        rows.append(
            clean_row(
                {
                    "record_id": source.get("SD_StoreID"),
                    "city": "新北市",
                    "district": source.get("行政區"),
                    "inspection_date": inspection_date,
                    "inspection_item": source.get("檢驗項目"),
                    "vender_name": vender_name,
                    "address": address,
                    "result": source.get("抽驗結果"),
                    "violation_detail": "",
                    "sampled_place": f"{vender_name}/{address}",
                }
            )
        )
    return aggregate_rows(rows)


def write_csv(path, rows):
    with path.open("w", encoding="utf-8-sig", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=OUTPUT_COLUMNS)
        writer.writeheader()
        writer.writerows(rows)


def main():
    taipei = get_taipei_data()
    new_taipei = get_new_taipei_data()
    rows = taipei + new_taipei
    write_csv(OUTPUT_CSV, rows)

    print(f"{OUTPUT_CSV}: {len(rows)}")
    print(f"臺北市: {len(taipei)}")
    print(f"新北市: {len(new_taipei)}")


if __name__ == "__main__":
    main()
