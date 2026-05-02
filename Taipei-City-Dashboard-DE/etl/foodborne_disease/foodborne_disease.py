"""正規化雙北食因性疾病病例數 CSV。"""
import csv
from collections import OrderedDict
from pathlib import Path

BASE_DIR = Path(__file__).parent
OUTPUT_CSV = BASE_DIR / "foodborne_disease.csv"

OUTPUT_COLUMNS = ["city", "district", "year", "cases"]


def normalize_text(value):
    if value is None:
        return ""
    return " ".join(str(value).split())


def normalize_city(value):
    return normalize_text(value).replace("台北市", "臺北市")


def normalize_integer(value, column):
    value = normalize_text(value).replace(",", "")
    if not value:
        return 0
    try:
        return int(value)
    except ValueError as exc:
        raise ValueError(f"{column} 必須為整數: {value}") from exc


def clean_row(row):
    city = normalize_city(row.get("city"))
    district = normalize_text(row.get("district"))
    year = normalize_integer(row.get("year"), "year")
    cases = normalize_integer(row.get("cases"), "cases")

    if not city:
        raise ValueError("city 不可為空")
    if not district:
        raise ValueError("district 不可為空")
    if year <= 0:
        raise ValueError(f"year 必須大於 0: {year}")
    if cases < 0:
        raise ValueError(f"cases 不可為負數: {cases}")

    return {
        "city": city,
        "district": district,
        "year": year,
        "cases": cases,
    }


def aggregate_rows(rows):
    grouped = OrderedDict()
    for row in rows:
        key = (row["city"], row["district"], row["year"])
        if key not in grouped:
            grouped[key] = row.copy()
            grouped[key]["cases"] = 0
        grouped[key]["cases"] += row["cases"]
    return list(grouped.values())


def read_csv(path):
    with path.open("r", encoding="utf-8-sig", newline="") as csvfile:
        reader = csv.DictReader(csvfile)
        if reader.fieldnames != OUTPUT_COLUMNS:
            raise ValueError(
                f"CSV 欄位必須為 {OUTPUT_COLUMNS}, 實際為 {reader.fieldnames}"
            )
        return [clean_row(row) for row in reader]


def write_csv(path, rows):
    with path.open("w", encoding="utf-8-sig", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=OUTPUT_COLUMNS)
        writer.writeheader()
        writer.writerows(rows)


def main():
    rows = aggregate_rows(read_csv(OUTPUT_CSV))
    write_csv(OUTPUT_CSV, rows)

    taipei_count = sum(1 for row in rows if row["city"] == "臺北市")
    new_taipei_count = sum(1 for row in rows if row["city"] == "新北市")
    print(f"{OUTPUT_CSV}: {len(rows)}")
    print(f"臺北市: {taipei_count}")
    print(f"新北市: {new_taipei_count}")


if __name__ == "__main__":
    main()
