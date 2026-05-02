"""Aggregate NHI enteroviral infection visits by year for Taipei and New Taipei."""
import csv
from collections import defaultdict
from pathlib import Path

INPUT_CSV = Path(__file__).parent / "NHI_EnteroviralInfection.csv"
OUTPUT_CSV = Path(__file__).parent / "enterovirus.csv"
TARGET_CITIES = {"台北市", "新北市"}

totals = defaultdict(int)

with INPUT_CSV.open(encoding="utf-8-sig", newline="") as file:
    reader = csv.DictReader(file)
    required_fields = {"年", "縣市", "腸病毒健保就診人次"}
    if reader.fieldnames is None:
        raise ValueError(f"{INPUT_CSV} does not contain a CSV header")

    missing_fields = required_fields - set(reader.fieldnames)
    if missing_fields:
        raise ValueError(f"{INPUT_CSV} missing columns: {', '.join(sorted(missing_fields))}")

    for row in reader:
        city = row["縣市"]
        if city not in TARGET_CITIES:
            continue

        year = row["年"]
        visits = int(row["腸病毒健保就診人次"] or 0)
        totals[(year, city)] += visits

rows = [
    {
        "year": year,
        "city": city,
        "enterovirus_visits": visits,
    }
    for (year, city), visits in sorted(totals.items())
]

with OUTPUT_CSV.open("w", encoding="utf-8-sig", newline="") as file:
    writer = csv.DictWriter(file, fieldnames=["year", "city", "enterovirus_visits"])
    writer.writeheader()
    writer.writerows(rows)

print(f"完成！共 {len(rows)} 筆，輸出至 {OUTPUT_CSV}")
