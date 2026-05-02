"""清洗雙北急救責任醫院名冊，補上經緯度後輸出 CSV。"""
import json
import os
import re
import unicodedata
from io import StringIO
from pathlib import Path
from urllib.parse import quote

import pandas as pd
import requests

BASE_DIR = Path(__file__).parent
REPO_DIR = BASE_DIR.parents[2]
ENV_FILE = BASE_DIR / ".env"
OUTPUT_CSV = BASE_DIR / "emergency_medical_services.csv"
OUTPUT_GEOJSON = (
    REPO_DIR
    / "Taipei-City-Dashboard-FE"
    / "public"
    / "mapData"
    / "emergency_medical_services.geojson"
)
CREATED_AT = "2026-05-02T00:00:00Z"

TAIPEI_API_URL = (
    "https://data.taipei/api/v1/dataset/"
    "3a4930ba-474f-497b-8916-4e9d342f5035?scope=resourceAquire"
)
NEW_TAIPEI_API_URL = (
    "https://data.ntpc.gov.tw/api/datasets/"
    "c2f23210-03c7-4461-b9d3-9ee4df24c3e9/csv?page=0&size=100"
)

MAPBOX_ACCESS_TOKEN_ENV = "MAPBOX_ACCESS_TOKEN"
MAPBOX_GEOCODING_URL = (
    "https://api.mapbox.com/geocoding/v5/mapbox.places/{location}.json"
)
MAPBOX_BBOX_TWIN_CITIES = "121.25,24.75,122.05,25.35"
MIN_GEOCODING_SCORE = 70
CHINESE_NUMBERS = {
    "1": "一",
    "2": "二",
    "3": "三",
    "4": "四",
    "5": "五",
    "6": "六",
    "7": "七",
    "8": "八",
    "9": "九",
    "10": "十",
}
ARABIC_NUMBERS = {value: key for key, value in CHINESE_NUMBERS.items()}

OUTPUT_COLUMNS = [
    "id",
    "created_at",
    "city",
    "seqno",
    "hosp_id",
    "district_code",
    "hosp_name",
    "district",
    "address",
    "tel",
    "yyyroc",
    "remark",
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
TWIN_CITIES_DISTRICTS = {
    "中正區",
    "大同區",
    "中山區",
    "松山區",
    "大安區",
    "萬華區",
    "信義區",
    "士林區",
    "北投區",
    "內湖區",
    "南港區",
    "文山區",
    "板橋區",
    "三重區",
    "中和區",
    "永和區",
    "新莊區",
    "新店區",
    "土城區",
    "蘆洲區",
    "樹林區",
    "汐止區",
    "鶯歌區",
    "三峽區",
    "淡水區",
    "瑞芳區",
    "五股區",
    "泰山區",
    "林口區",
    "深坑區",
    "石碇區",
    "坪林區",
    "三芝區",
    "石門區",
    "八里區",
    "平溪區",
    "雙溪區",
    "貢寮區",
    "金山區",
    "萬里區",
    "烏來區",
}
MANUAL_COORDINATES = {
    "醫療財團法人徐元智先生醫藥基金會亞東紀念醫院": (
        "121.451983",
        "24.997441",
    ),
    "國立臺灣大學醫學院附設醫院金山分院": (
        "121.628398",
        "25.219650",
    ),
}


def normalize_text(value):
    if not isinstance(value, str):
        return value
    return " ".join(value.split())


def load_env_file(env_file=ENV_FILE):
    if not env_file.exists():
        return

    for line in env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue

        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def get_mapbox_access_token():
    load_env_file()
    access_token = os.getenv(MAPBOX_ACCESS_TOKEN_ENV)
    if not access_token:
        raise RuntimeError(
            f"請在 {ENV_FILE} 或環境變數設定 {MAPBOX_ACCESS_TOKEN_ENV}"
        )
    return access_token


def normalize_for_match(value):
    value = normalize_text(value)
    if not isinstance(value, str):
        return ""
    value = unicodedata.normalize("NFKC", value)
    value = value.replace("台北市", "臺北市").replace("台灣", "臺灣")
    value = re.sub(
        r"(大道|路|街)([一二三四五六七八九十]+)段",
        lambda match: f"{match.group(1)}{ARABIC_NUMBERS.get(match.group(2), match.group(2))}段",
        value,
    )
    return re.sub(r"\s+", "", value)


def normalize_for_query(value):
    value = normalize_text(value)
    if not isinstance(value, str):
        return ""
    value = unicodedata.normalize("NFKC", value)
    value = value.replace("台北市", "臺北市").replace("台灣", "臺灣")
    return re.sub(r"\s+", "", value)


def clean_address_for_query(address):
    """Pure-Python subset of dags/utils/transform_address.py clean_data."""
    normalized = normalize_text(address)
    if not isinstance(normalized, str):
        return ""
    normalized = unicodedata.normalize("NFKC", normalized)
    normalized = normalized.replace("-", "之")
    normalized = re.sub(r"[（(].*?[）)]", "", normalized)
    normalized = normalized.replace("~", "至")
    normalized = normalized.replace("台北市", "臺北市").replace("台灣", "臺灣")
    normalized = normalized.replace("3民", "三民").replace("8德", "八德")
    normalized = normalized.replace("廈門街", "厦門街")
    normalized = re.sub("梧洲[路街]", "梧州街", normalized)
    normalized = re.sub("汀洲[路街]", "汀州街", normalized)
    normalized = re.sub("徐洲[路街]", "徐州路", normalized)
    normalized = normalized.replace("舊庄里", "舊莊里")
    normalized = re.sub("糖.{1}里", "糖廍里", normalized)
    normalized = normalized.replace("ㄧ", "一")
    for number, chinese_number in CHINESE_NUMBERS.items():
        normalized = normalized.replace(f"{number}路", f"{chinese_number}路")
        normalized = normalized.replace(f"{number}段", f"{chinese_number}段")
        normalized = normalized.replace(f"{number}小段", f"{chinese_number}小段")
    normalized = normalized.replace("一號", "1號")
    normalized = normalized.replace("二號", "2號")
    normalized = normalized.replace("三號", "3號")
    normalized = re.sub(r"[^\w\s]", "", normalized)
    return re.sub(r"\s+", "", normalized)


def extract_district(address):
    if not isinstance(address, str):
        return ""
    for city in ["臺北市", "台北市", "新北市"]:
        if address.startswith(city):
            district = address[len(city) : len(city) + 3]
            return district if district.endswith("區") else ""
    return ""


def extract_road(address):
    normalized = normalize_for_match(address)
    city = extract_city(normalized)
    district = extract_district(normalized)
    if city:
        normalized = normalized.removeprefix(city)
    if district:
        normalized = normalized.removeprefix(district)

    match = re.search(
        r"[^0-9,，]+?(?:大道|路|街)(?:[一二三四五六七八九十0-9]+段)?",
        normalized,
    )
    return match.group(0) if match else ""


def extract_house_number(address):
    normalized = normalize_for_match(address)
    matches = re.findall(r"\d+(?:之\d+)?號", normalized)
    return matches[-1] if matches else ""


def use_lane_or_alley(address):
    normalized = normalize_for_match(address)
    return "巷" in normalized or "弄" in normalized


def convert_section_numbers_to_chinese(address):
    normalized = normalize_text(address)
    if not isinstance(normalized, str):
        return ""
    normalized = unicodedata.normalize("NFKC", normalized)
    return re.sub(
        r"(大道|路|街)([0-9]+)段",
        lambda match: f"{match.group(1)}{CHINESE_NUMBERS.get(match.group(2), match.group(2))}段",
        normalized,
    )


def extract_candidate_districts(value):
    candidate_text = normalize_for_match(value)
    return {
        district
        for district in TWIN_CITIES_DISTRICTS
        if district in candidate_text
    }


def simplify_hospital_name(name):
    normalized = normalize_for_match(name)
    normalized = re.sub(r"[（(].*?[）)]", "", normalized)
    normalized = re.sub(r".*基金會", "", normalized)
    for prefix in [
        "臺灣基督長老教會馬偕醫療財團法人",
        "天主教耕莘醫療財團法人",
        "佛教慈濟醫療財團法人",
        "國泰醫療財團法人",
        "行天宮醫療志業醫療財團法人",
        "輔仁大學學校財團法人",
        "振興醫療財團法人",
        "新光醫療財團法人",
        "衛生福利部",
        "國立臺灣大學醫學院附設",
        "醫療財團法人",
        "財團法人",
    ]:
        normalized = normalized.replace(prefix, "")
    return normalized


def extract_city(address):
    normalized = normalize_for_match(address)
    for city in ["臺北市", "新北市"]:
        if city in normalized:
            return city
    return ""


def score_feature(
    feature,
    city,
    district,
    road,
    house_number,
    hospital_name,
    source_has_lane_or_alley,
):
    candidates = [
        feature.get("place_name", ""),
        feature.get("matching_place_name", ""),
        feature.get("text", ""),
        feature.get("matching_text", ""),
    ]
    candidate_text = normalize_for_match(" ".join(filter(None, candidates)))
    score = int(feature.get("relevance", 0) * 10)

    if city and city in candidate_text:
        score += 25
    if district and district in candidate_text:
        score += 25
    elif district and extract_candidate_districts(candidate_text):
        score -= 40
    if road and road in candidate_text:
        score += 30
    if house_number and house_number in candidate_text:
        score += 30
    if hospital_name and hospital_name in candidate_text:
        score += 50
    if not source_has_lane_or_alley and use_lane_or_alley(candidate_text):
        score -= 45

    place_types = set(feature.get("place_type", []))
    if "address" in place_types:
        score += 10
    if "poi" in place_types and road and road not in candidate_text:
        score -= 20

    return score


def request_geocoding_features(location):
    encoded_location = quote(location)
    response = requests.get(
        MAPBOX_GEOCODING_URL.format(location=encoded_location),
        params={
            "access_token": get_mapbox_access_token(),
            "bbox": MAPBOX_BBOX_TWIN_CITIES,
            "country": "tw",
            "language": "zh-Hant",
            "limit": 10,
            "autocomplete": "false",
        },
        timeout=30,
    )
    response.raise_for_status()
    return response.json().get("features", [])


def get_coordinates(row):
    manual_coordinates = MANUAL_COORDINATES.get(row["hosp_name"])
    if manual_coordinates:
        return manual_coordinates

    city = normalize_for_match(row["city"])
    district = normalize_for_match(row["district"])
    address = normalize_text(row["address"])
    road = extract_road(address)
    house_number = extract_house_number(address)
    source_has_lane_or_alley = use_lane_or_alley(address)
    hospital_name = simplify_hospital_name(row["hosp_name"])
    cleaned_address = clean_address_for_query(address)
    queries = [
        normalize_for_query(address),
        normalize_for_query(cleaned_address),
        normalize_for_query(convert_section_numbers_to_chinese(address)),
        hospital_name,
    ]

    scored_features = []
    for query in dict.fromkeys(query for query in queries if query):
        try:
            features = request_geocoding_features(query)
        except requests.HTTPError as error:
            print(f"Mapbox 查詢失敗: {query} / {error}")
            continue
        for feature in features:
            scored_features.append(
                (
                    score_feature(
                        feature,
                        city,
                        district,
                        road,
                        house_number,
                        hospital_name,
                        source_has_lane_or_alley,
                    ),
                    feature,
                    query,
                )
            )

    if not scored_features:
        print(f"找不到座標: {row['hosp_name']} / {address}")
        return "", ""

    score, feature, query = max(scored_features, key=lambda item: item[0])
    if score < MIN_GEOCODING_SCORE:
        place_name = feature.get("place_name", "")
        print(
            "座標候選不夠可信，略過: "
            f"{row['hosp_name']} / {address} / query={query} / "
            f"score={score} / candidate={place_name}"
        )
        return "", ""

    lng, lat = feature["center"]
    return f"{lng:.6f}", f"{lat:.6f}"


def add_coordinates(data):
    data = data.copy()
    cache = {}

    for index, row in data.iterrows():
        if (
            pd.notna(row["lng"])
            and pd.notna(row["lat"])
            and row["lng"] != ""
            and row["lat"] != ""
        ):
            continue

        address = normalize_text(row["address"])
        if not address:
            data.at[index, "lng"] = ""
            data.at[index, "lat"] = ""
            continue

        cache_key = (row["hosp_name"], address)
        if cache_key not in cache:
            cache[cache_key] = get_coordinates(row)

        data.at[index, "lng"], data.at[index, "lat"] = cache[cache_key]

    return data


def write_geojson(data):
    features = []
    for _, row in data.iterrows():
        lng = pd.to_numeric(row["lng"], errors="coerce")
        lat = pd.to_numeric(row["lat"], errors="coerce")
        if pd.isna(lng) or pd.isna(lat):
            continue

        properties = {
            column: (None if pd.isna(row[column]) else row[column])
            for column in OUTPUT_COLUMNS
            if column not in {"lng", "lat"}
        }
        properties["lng"] = float(lng)
        properties["lat"] = float(lat)

        features.append(
            {
                "type": "Feature",
                "id": int(row["id"]),
                "geometry": {
                    "type": "Point",
                    "coordinates": [float(lng), float(lat)],
                },
                "properties": properties,
            }
        )

    geojson = {
        "type": "FeatureCollection",
        "name": "emergency_medical_services",
        "features": features,
    }
    OUTPUT_GEOJSON.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_GEOJSON.write_text(
        json.dumps(geojson, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def get_taipei_data():
    response = requests.get(TAIPEI_API_URL, timeout=60)
    response.raise_for_status()
    raw_data = pd.DataFrame(response.json()["result"]["results"])
    data = raw_data.rename(
        columns={
            "序號": "seqno",
            "行政區": "district_code",
            "醫事機構名稱": "hosp_name",
            "地址": "address",
            "電話": "tel",
        }
    )
    data["city"] = "臺北市"
    data["hosp_id"] = ""
    data["district"] = data["district_code"].map(TAIPEI_DISTRICT_CODES).fillna("")
    data["yyyroc"] = ""
    data["remark"] = ""
    data["lng"] = ""
    data["lat"] = ""

    data = data.drop(columns=["_id", "_importdate"], errors="ignore")

    return data[[column for column in OUTPUT_COLUMNS if column in data.columns]]


def get_new_taipei_data():
    response = requests.get(NEW_TAIPEI_API_URL, timeout=60)
    response.raise_for_status()
    raw_data = pd.read_csv(StringIO(response.text), dtype=str)
    data = raw_data.rename(
        columns={
            "hosp_addr": "address",
            "wgs84ax": "lng",
            "wgs84ay": "lat",
        }
    )
    data["city"] = "新北市"
    data["district_code"] = ""
    data["district"] = data["address"].map(extract_district)

    return data[[column for column in OUTPUT_COLUMNS if column in data.columns]]


def main():
    taipei = get_taipei_data()
    new_taipei = get_new_taipei_data()
    emergency_medical_services = pd.concat([taipei, new_taipei], ignore_index=True)
    emergency_medical_services.insert(
        0, "id", range(1, len(emergency_medical_services) + 1)
    )
    emergency_medical_services.insert(1, "created_at", CREATED_AT)

    text_columns = [
        "seqno",
        "hosp_id",
        "district_code",
        "hosp_name",
        "district",
        "address",
        "tel",
        "yyyroc",
        "remark",
    ]
    for column in text_columns:
        emergency_medical_services[column] = emergency_medical_services[column].map(
            normalize_text
        )

    emergency_medical_services = add_coordinates(emergency_medical_services)
    emergency_medical_services.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
    write_geojson(emergency_medical_services)

    print(f"{OUTPUT_CSV}: {len(emergency_medical_services)}")
    print(f"{OUTPUT_GEOJSON}: {len(emergency_medical_services)}")
    print(f"臺北市: {len(taipei)}")
    print(f"新北市: {len(new_taipei)}")
    missing_coordinates = emergency_medical_services[
        (emergency_medical_services["lng"] == "")
        | (emergency_medical_services["lat"] == "")
    ]
    print(f"未取得經緯度: {len(missing_coordinates)}")


if __name__ == "__main__":
    main()
