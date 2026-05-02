"""從 API 取得雙北急救責任醫院名冊，輸出指定 CSV 格式與 GeoJSON。"""
import csv
import json
from io import StringIO
from pathlib import Path
from urllib.request import urlopen

BASE_DIR = Path(__file__).parent
REPO_DIR = BASE_DIR.parents[2]
OUTPUT_CSV = BASE_DIR / "emergency_medical_services.csv"
OUTPUT_GEOJSON = (
    REPO_DIR
    / "Taipei-City-Dashboard-FE"
    / "public"
    / "mapData"
    / "emergency_medical_services.geojson"
)
OUTPUT_TAIPEI_GEOJSON = (
    REPO_DIR
    / "Taipei-City-Dashboard-FE"
    / "public"
    / "mapData"
    / "emergency_medical_services_taipei.geojson"
)

TAIPEI_API_URL = (
    "https://data.taipei/api/v1/dataset/"
    "3a4930ba-474f-497b-8916-4e9d342f5035?scope=resourceAquire"
)
NEW_TAIPEI_API_URL = (
    "https://data.ntpc.gov.tw/api/datasets/"
    "c2f23210-03c7-4461-b9d3-9ee4df24c3e9/csv?page=0&size=100"
)

OUTPUT_COLUMNS = [
    "hospital_name",
    "city",
    "district",
    "address",
    "tel",
    "lng",
    "lat",
]

TAIPEI_DISTRICT_CODES = {
    "63000010": "松山區",
    "63000020": "信義區",
    "63000030": "大安區",
    "63000040": "中山區",
    "63000050": "中正區",
    "63000060": "大同區",
    "63000070": "萬華區",
    "63000080": "文山區",
    "63000090": "南港區",
    "63000100": "內湖區",
    "63000110": "士林區",
    "63000120": "北投區",
}

NEW_TAIPEI_COORDINATE_FALLBACKS = {
    "醫療財團法人徐元智先生醫藥基金會亞東紀念醫院": ("121.451983", "24.997441"),
    "台灣基督長老教會馬偕醫療財團法人淡水馬偕紀念醫院": (
        "121.460499",
        "25.139535",
    ),
    "衛生福利部雙和醫院（委託臺北醫學大學興建經營）": ("121.494040", "24.993751"),
    "佛教慈濟醫療財團法人台北慈濟醫院": ("121.535808", "24.985781"),
    "天主教耕莘醫療財團法人耕莘醫院": ("121.535551", "24.976120"),
    "輔仁大學學校財團法人輔仁大學附設醫院": ("121.430799", "25.039676"),
    "新北市立土城醫院（委託長庚醫療財團法人興建經營）": (
        "121.448730",
        "24.976437",
    ),
    "衛生福利部臺北醫院": ("121.459623", "25.043241"),
    "行天宮醫療志業醫療財團法人恩主公醫院": ("121.363008", "24.938386"),
    "國泰醫療財團法人汐止國泰綜合醫院": ("121.661084", "25.072872"),
    "新北市立聯合醫院（三重院區）": ("121.490202", "25.061139"),
    "天主教耕莘醫療財團法人永和耕莘醫院": ("121.518431", "25.012126"),
    "天主教耕莘醫療財團法人耕莘醫院安康院區": ("121.504537", "24.953977"),
    "國立臺灣大學醫學院附設醫院金山分院": ("121.628398", "25.219650"),
    "衛生福利部樂生醫院": ("121.409851", "25.021622"),
    "瑞芳礦工醫院": ("121.802170", "25.108602"),
    "仁愛醫院": ("121.420039", "24.987188"),
    "新泰綜合醫院": ("121.434313", "25.021504"),
    "宏仁醫院": ("121.483780", "25.053965"),
}


def normalize_text(value):
    if value is None:
        return ""
    return " ".join(str(value).split())


def normalize_city(value):
    return normalize_text(value).replace("台北市", "臺北市")


def request_json(url):
    with urlopen(url, timeout=60) as response:
        return json.loads(response.read().decode("utf-8-sig"))


def request_csv(url):
    with urlopen(url, timeout=60) as response:
        return response.read().decode("utf-8-sig")


def read_existing_coordinate_cache(path=OUTPUT_CSV):
    if not path.exists():
        return {}

    with path.open("r", encoding="utf-8-sig", newline="") as csvfile:
        rows = csv.DictReader(csvfile)
        coordinate_cache = {}
        for row in rows:
            hospital_name = normalize_text(
                row.get("hospital_name") or row.get("hosp_name")
            )
            address = normalize_city(row.get("address") or row.get("hosp_addr"))
            lng = normalize_text(row.get("lng") or row.get("wgs84ax"))
            lat = normalize_text(row.get("lat") or row.get("wgs84ay"))
            if hospital_name and address and lng and lat:
                coordinate_cache[(hospital_name, address)] = (lng, lat)
        return coordinate_cache


def extract_district(address):
    address = normalize_city(address)
    for city in ["臺北市", "新北市"]:
        if address.startswith(city):
            district = address[len(city) : len(city) + 3]
            return district if district.endswith("區") else ""
    return ""


def clean_row(row):
    cleaned = {column: normalize_text(row.get(column, "")) for column in OUTPUT_COLUMNS}
    cleaned["city"] = normalize_city(cleaned["city"])
    cleaned["address"] = normalize_city(cleaned["address"])
    return cleaned


def get_taipei_data(coordinate_cache):
    payload = request_json(TAIPEI_API_URL)
    rows = []
    for source in payload["result"]["results"]:
        hospital_name = normalize_text(source.get("醫事機構名稱"))
        address = normalize_city(source.get("地址"))
        lng, lat = coordinate_cache.get((hospital_name, address), ("", ""))
        rows.append(
            clean_row(
                {
                    "hospital_name": hospital_name,
                    "city": "臺北市",
                    "district": TAIPEI_DISTRICT_CODES.get(
                        normalize_text(source.get("行政區")), ""
                    ),
                    "address": address,
                    "tel": source.get("電話"),
                    "lng": lng,
                    "lat": lat,
                }
            )
        )
    return rows


def get_new_taipei_data():
    raw_csv = request_csv(NEW_TAIPEI_API_URL)
    rows = []
    for source in csv.DictReader(StringIO(raw_csv)):
        hospital_name = normalize_text(source.get("hosp_name"))
        address = normalize_city(source.get("hosp_addr"))
        lng = normalize_text(source.get("wgs84ax"))
        lat = normalize_text(source.get("wgs84ay"))
        if not lng or not lat:
            lng, lat = NEW_TAIPEI_COORDINATE_FALLBACKS.get(hospital_name, ("", ""))
        rows.append(
            clean_row(
                {
                    "hospital_name": hospital_name,
                    "city": "新北市",
                    "district": extract_district(address),
                    "address": address,
                    "tel": source.get("tel"),
                    "lng": lng,
                    "lat": lat,
                }
            )
        )
    return rows


def write_csv(path, rows):
    with path.open("w", encoding="utf-8-sig", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=OUTPUT_COLUMNS)
        writer.writeheader()
        writer.writerows(rows)


def parse_coordinate(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def write_geojson(rows, path=OUTPUT_GEOJSON, name="emergency_medical_services"):
    features = []
    for index, row in enumerate(rows, start=1):
        lng = parse_coordinate(row["lng"])
        lat = parse_coordinate(row["lat"])
        if lng is None or lat is None:
            continue

        properties = {column: row[column] for column in OUTPUT_COLUMNS}
        properties["lng"] = lng
        properties["lat"] = lat
        features.append(
            {
                "type": "Feature",
                "id": index,
                "geometry": {
                    "type": "Point",
                    "coordinates": [lng, lat],
                },
                "properties": properties,
            }
        )

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(
            {
                "type": "FeatureCollection",
                "name": name,
                "features": features,
            },
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )


def main():
    coordinate_cache = read_existing_coordinate_cache()
    taipei = get_taipei_data(coordinate_cache)
    new_taipei = get_new_taipei_data()
    rows = taipei + new_taipei

    write_csv(OUTPUT_CSV, rows)
    write_geojson(rows)
    write_geojson(taipei, OUTPUT_TAIPEI_GEOJSON, "emergency_medical_services_taipei")

    missing_coordinates = sum(1 for row in rows if not row["lng"] or not row["lat"])
    print(f"{OUTPUT_CSV}: {len(rows)}")
    print(f"{OUTPUT_GEOJSON}: {len(rows) - missing_coordinates}")
    print(f"{OUTPUT_TAIPEI_GEOJSON}: {len(taipei)}")
    print(f"臺北市: {len(taipei)}")
    print(f"新北市: {len(new_taipei)}")
    print(f"未取得經緯度: {missing_coordinates}")


if __name__ == "__main__":
    main()
