"""Filter enterovirus severe complication cases to Taipei and New Taipei."""
import csv
from pathlib import Path

OUTPUT_CSV = Path(__file__).parent / "severe_complications_of_enterovirus_infection.csv"
TARGET_CITIES = {"台北市", "新北市"}


with OUTPUT_CSV.open(encoding="utf-8-sig", newline="") as file:
    reader = csv.DictReader(file)
    rows = [row for row in reader if row["縣市"] in TARGET_CITIES]
    fieldnames = reader.fieldnames

if fieldnames is None:
    raise ValueError(f"{OUTPUT_CSV} does not contain a CSV header")

with OUTPUT_CSV.open("w", encoding="utf-8-sig", newline="") as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print(f"完成！共 {len(rows)} 筆，輸出至 {OUTPUT_CSV}")
