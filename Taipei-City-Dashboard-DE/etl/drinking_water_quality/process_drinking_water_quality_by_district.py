"""將臺北市飲用水水質檢驗資料補上雙北行政區並輸出彙總 CSV。"""
from __future__ import annotations

import csv
import re
from collections import defaultdict
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
SOURCE_CSV = BASE_DIR.parent / "臺北市飲用水水質檢驗資料.csv"
DETAIL_OUTPUT_CSV = BASE_DIR / "drinking_water_quality_by_district_detail.csv"
SUMMARY_OUTPUT_CSV = BASE_DIR / "drinking_water_quality_by_district_summary.csv"


def normalize_check_point(value: str) -> str:
    """Normalize small address variants that refer to the same check point."""
    value = value.strip().replace("\u3000", "")
    value = value.replace("臺北市", "")
    value = value.replace("台北市", "")
    value = value.replace("新北市", "")
    value = value.replace("１", "1")
    value = value.replace("２", "2")
    value = value.replace("３", "3")
    value = value.replace("４", "4")
    value = value.replace("５", "5")
    value = value.replace("６", "6")
    value = value.replace("７", "7")
    value = value.replace("８", "8")
    value = value.replace("９", "9")
    value = value.replace("０", "0")
    value = value.replace("一段", "1段")
    value = value.replace("二段", "2段")
    value = value.replace("三段", "3段")
    value = value.replace("四段", "4段")
    value = value.replace("五段", "5段")
    value = value.replace("六段", "6段")
    value = value.replace("七段", "7段")
    value = value.replace("敦化??199巷9號旁", "敦化北路199巷9號旁")
    value = re.sub(r"^(中正區|大同區|中山區|松山區|大安區|萬華區|信義區|士林區|北投區|內湖區|南港區|文山區|新店區)", "", value)
    return value


# The source does not include district or coordinates. This table maps the
# recurring check points to administrative districts after address cleanup.
CHECK_POINT_DISTRICTS = {
    "中坡南路51號": ("臺北市", "南港區"),
    "中山北路1段106-1號": ("臺北市", "中山區"),
    "中山北路1段110-7號": ("臺北市", "中山區"),
    "中山北路5段320號": ("臺北市", "士林區"),
    "中山北路5段460巷1號": ("臺北市", "士林區"),
    "內溝里康樂街206-4號旁附近": ("臺北市", "內湖區"),
    "八德路2段34巷28弄內": ("臺北市", "中山區"),
    "八德路2段146巷1弄8號對面": ("臺北市", "松山區"),
    "八德路2段364巷5弄29號對面": ("臺北市", "松山區"),
    "八德路2段366巷21-2號對面": ("臺北市", "松山區"),
    "八德路3段99巷12號前": ("臺北市", "松山區"),
    "公館淨水場思源街1號": ("臺北市", "中正區"),
    "南京東路4段52巷16弄口": ("臺北市", "松山區"),
    "和平東路3段308巷15弄涼亭旁": ("臺北市", "大安區"),
    "哈密街49巷口": ("臺北市", "大同區"),
    "哈密街59巷﹝龍塘綠地﹞": ("臺北市", "大同區"),
    "四維路52巷1號對面": ("臺北市", "大安區"),
    "大湖街116巷內": ("臺北市", "內湖區"),
    "大湖街166巷大湖公園入口旁": ("臺北市", "內湖區"),
    "大龍街126號": ("臺北市", "大同區"),
    "天母東路69巷30號": ("臺北市", "士林區"),
    "安東街40巷49號對面": ("臺北市", "中山區"),
    "富陽街底（廁所)": ("臺北市", "大安區"),
    "師大路105巷與師大路口": ("臺北市", "大安區"),
    "師大路107號": ("臺北市", "大安區"),
    "康寧路3段99巷17弄26號旁": ("臺北市", "內湖區"),
    "康樂街206號附近": ("臺北市", "內湖區"),
    "康樂街236-5號附近（公車站旁）": ("臺北市", "內湖區"),
    "延壽街373號": ("臺北市", "松山區"),
    "延平北路2段61巷16號": ("臺北市", "大同區"),
    "建國南路1段354號": ("臺北市", "大安區"),
    "後港街38巷臨5之1號": ("臺北市", "士林區"),
    "思源街1號": ("臺北市", "中正區"),
    "思源路1號": ("臺北市", "中正區"),
    "成功路5段152巷對面": ("臺北市", "內湖區"),
    "承德路4段5-1號": ("臺北市", "士林區"),
    "承德路7段388號對面﹝北投加壓站﹞": ("臺北市", "北投區"),
    "敦化北路199巷9號旁": ("臺北市", "松山區"),
    "新店區直潭路127號": ("新北市", "新店區"),
    "新生北路3段101號": ("臺北市", "中山區"),
    "昌吉街118號": ("臺北市", "大同區"),
    "景福街19號1樓": ("臺北市", "文山區"),
    "木新路3段13號": ("臺北市", "文山區"),
    "木新路3段55號": ("臺北市", "文山區"),
    "木柵路1段280號": ("臺北市", "文山區"),
    "健康路15巷交口": ("臺北市", "松山區"),
    "柳州街62號": ("臺北市", "萬華區"),
    "格致路198號": ("臺北市", "士林區"),
    "桂林路167巷14號（三清宮）": ("臺北市", "萬華區"),
    "民族東路765號對面公園": ("臺北市", "松山區"),
    "民族東路臨41號": ("臺北市", "中山區"),
    "民權東路5段41-1號": ("臺北市", "松山區"),
    "永吉路120巷92號": ("臺北市", "信義區"),
    "泉源路260號": ("臺北市", "北投區"),
    "直潭路127號": ("新北市", "新店區"),
    "直潭路127號(直潭淨水場)": ("新北市", "新店區"),
    "研究院路2段1號": ("臺北市", "南港區"),
    "羅斯福路3段197號": ("臺北市", "大安區"),
    "羅斯福路6段268號": ("臺北市", "文山區"),
    "至善路2段322巷口": ("臺北市", "士林區"),
    "至善路2段449號": ("臺北市", "士林區"),
    "至善路3段110號": ("臺北市", "士林區"),
    "興東街1號對面": ("臺北市", "北投區"),
    "興隆路2段234號": ("臺北市", "文山區"),
    "莊敬路393號": ("臺北市", "信義區"),
    "莒光路176號": ("臺北市", "萬華區"),
    "菁山路101巷79號": ("臺北市", "士林區"),
    "華齡街2巷口": ("臺北市", "士林區"),
    "萬大路423巷115號": ("臺北市", "萬華區"),
    "行義路1號": ("臺北市", "北投區"),
    "行義路1段五福宮旁": ("臺北市", "北投區"),
    "西園路1段127號": ("臺北市", "萬華區"),
    "西寧南路124號": ("臺北市", "萬華區"),
    "西藏路171號": ("臺北市", "萬華區"),
    "辛亥路2段171巷21號對面": ("臺北市", "大安區"),
    "迪化街1段268號": ("臺北市", "大同區"),
    "長安西路36號": ("臺北市", "中山區"),
    "長安西路38號": ("臺北市", "中山區"),
    "長泰街8號": ("臺北市", "萬華區"),
    "長興街131號": ("臺北市", "大安區"),
    "鹿角坑加壓站 竹子湖路75-1號對面": ("臺北市", "北投區"),
}


def parse_number(value: str) -> tuple[str, float | None, bool]:
    value = value.strip()
    if not value:
        return "missing", None, False

    match = re.search(r"\d+(?:\.\d+)?", value)
    if not match:
        return "unknown", None, False

    number = float(match.group())
    if value.startswith("<"):
        return "less_than", number, False

    return "number", number, number > 1


def read_source() -> list[dict[str, str]]:
    with SOURCE_CSV.open("r", encoding="cp950", newline="") as file:
        return list(csv.DictReader(file))


def write_detail(rows: list[dict[str, str]]) -> None:
    fieldnames = [
        "稽查日期",
        "city",
        "district",
        "檢驗點",
        "normalized_check_point",
        "大腸桿菌群",
        "ecoli_value_type",
        "ecoli_numeric_value",
        "ecoli_gt_1",
        "總菌落數",
        "自由有效餘氯（數值）",
        "氫離子濃度指數（數值）",
    ]
    with DETAIL_OUTPUT_CSV.open("w", encoding="utf-8-sig", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def write_summary(rows: list[dict[str, str]]) -> None:
    groups: dict[tuple[str, str], dict[str, int]] = defaultdict(lambda: {
        "sample_count": 0,
        "ecoli_gt_1_count": 0,
        "ecoli_less_than_count": 0,
        "ecoli_missing_count": 0,
    })

    for row in rows:
        key = (row["city"], row["district"])
        groups[key]["sample_count"] += 1
        groups[key]["ecoli_gt_1_count"] += int(row["ecoli_gt_1"] == "1")
        groups[key]["ecoli_less_than_count"] += int(row["ecoli_value_type"] == "less_than")
        groups[key]["ecoli_missing_count"] += int(row["ecoli_value_type"] == "missing")

    fieldnames = [
        "city",
        "district",
        "sample_count",
        "ecoli_gt_1_count",
        "ecoli_gt_1_rate",
        "ecoli_less_than_count",
        "ecoli_missing_count",
    ]
    with SUMMARY_OUTPUT_CSV.open("w", encoding="utf-8-sig", newline="") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        for (city, district), values in sorted(groups.items()):
            sample_count = values["sample_count"]
            writer.writerow({
                "city": city,
                "district": district,
                **values,
                "ecoli_gt_1_rate": round(values["ecoli_gt_1_count"] / sample_count, 6),
            })


def main() -> None:
    output_rows = []
    unmapped = set()

    for row in read_source():
        check_point = normalize_check_point(row["檢驗點"])
        city_district = CHECK_POINT_DISTRICTS.get(check_point)
        if city_district is None:
            unmapped.add(row["檢驗點"])
            city_district = ("", "")

        value_type, numeric_value, gt_1 = parse_number(row["大腸桿菌群"])
        output_rows.append({
            "稽查日期": row["稽查日期"],
            "city": city_district[0],
            "district": city_district[1],
            "檢驗點": row["檢驗點"],
            "normalized_check_point": check_point,
            "大腸桿菌群": row["大腸桿菌群"],
            "ecoli_value_type": value_type,
            "ecoli_numeric_value": "" if numeric_value is None else f"{numeric_value:g}",
            "ecoli_gt_1": "1" if gt_1 else "0",
            "總菌落數": row["總菌落數"],
            "自由有效餘氯（數值）": row["自由有效餘氯（數值）"],
            "氫離子濃度指數（數值）": row["氫離子濃度指數（數值）"],
        })

    write_detail(output_rows)
    write_summary(output_rows)

    print(f"完成明細：{DETAIL_OUTPUT_CSV}，共 {len(output_rows)} 筆")
    print(f"完成彙總：{SUMMARY_OUTPUT_CSV}")
    if unmapped:
        print("以下檢驗點尚未對應行政區：")
        for item in sorted(unmapped):
            print(f"- {item}")


if __name__ == "__main__":
    main()
