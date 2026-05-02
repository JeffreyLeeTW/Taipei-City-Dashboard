--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.8 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;



--
-- Data for Name: component_charts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_charts (index, color, types, unit) FROM stdin;
youbike_availability	{#9DC56E,#356340,#9DC56E}	{GuageChart,BarPercentChart}	輛
ebus_percent	{#9DC56E,#356340,#9DC56E}	{IconPercentChart,BarPercentChart}	輛
city_age_distribution	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}	{DistrictChart,ColumnChart}	仟人
dependency_aging	{#67baca,#fbf3ac}	{ColumnLineChart,TimelineSeparateChart}	%
aging_kpi	{#F65658,#F49F36,#F5C860,#9AC17C,#4CB495,#569C9A,#60819C,#2F8AB1}	{TextUnitChart}	\N
aging_workforce_trend	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A}	{BarPercentChart,RadarChart,ColumnChart}	%
bike_network	{#a0b8e8,#b7ff98}	{DonutChart,BarChart}	公里
bike_map	{#a0b8e8,#b7ff98}	{MapLegend}	條
foodborne_disease_three_d_district_year	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D}	{ColumnChart}	件
foodborne_disease_three_d_year_district	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D}	{ColumnChart}	件
foodborne_disease_two_d_district	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D}	{BarChart,ColumnChart}	件
foodborne_disease_two_d_year	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D}	{ColumnChart,BarChart}	件
foodborne_disease_percent_district	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D}	{DonutChart,BarPercentChart}	件
foodborne_disease_time_year	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D}	{TimelineSeparateChart,TimelineStackedChart}	件
foodborne_disease_map_legend	{#24B0DD,#56B96D,#F8CF58,#F5AD4A,#E170A6,#ED6A45,#AF4137,#10294A,#7B61FF,#00A6A6,#B9822B,#6C757D,#8DD3C7,#BEBADA,#FB8072,#80B1D3,#FDB462,#B3DE69,#FCCDE5,#D9D9D9,#BC80BD,#CCEBC5,#FFED6F,#1B9E77,#D95F02,#7570B3,#E7298A,#66A61E,#E6AB02,#A6761D,#666666}	{MapLegend}	件
food_inspection_three_d_district_year	{#2B8CBE,#7BCCC4,#A8DDB5,#FDD49E,#FDBB84,#FC8D59,#D7301F,#7F0000,#756BB1,#31A354,#636363,#9E9AC8}	{ColumnChart}	件
food_inspection_three_d_year_district	{#2B8CBE,#7BCCC4,#A8DDB5,#FDD49E,#FDBB84,#FC8D59,#D7301F,#7F0000,#756BB1,#31A354,#636363,#9E9AC8}	{ColumnChart}	件
food_inspection_two_d_district	{#2B8CBE,#7BCCC4,#A8DDB5,#FDD49E,#FDBB84,#FC8D59,#D7301F,#7F0000,#756BB1,#31A354,#636363,#9E9AC8}	{BarChart,ColumnChart}	件
food_inspection_two_d_year	{#2B8CBE,#7BCCC4,#A8DDB5,#FDD49E,#FDBB84,#FC8D59,#D7301F,#7F0000,#756BB1,#31A354,#636363,#9E9AC8}	{ColumnChart,BarChart}	件
food_inspection_percent_result	{#56B96D,#ED6A45}	{DonutChart,BarPercentChart}	件
food_inspection_time_daily	{#2B8CBE,#7BCCC4,#A8DDB5,#FDD49E,#FDBB84,#FC8D59,#D7301F,#7F0000,#756BB1,#31A354,#636363,#9E9AC8}	{TimelineSeparateChart,TimelineStackedChart}	件
food_inspection_map_legend	{#2B8CBE,#7BCCC4,#A8DDB5,#FDD49E,#FDBB84,#FC8D59,#D7301F,#7F0000,#756BB1,#31A354,#636363,#9E9AC8,#8DD3C7,#BEBADA,#FB8072,#80B1D3,#FDB462,#B3DE69,#FCCDE5,#D9D9D9,#BC80BD,#CCEBC5,#FFED6F,#1B9E77,#D95F02,#7570B3,#E7298A,#66A61E,#E6AB02,#A6761D,#666666}	{MapLegend}	件
emergency_medical_service_three_d_district_city	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2}	{ColumnChart}	家
emergency_medical_service_three_d_city_district	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2}	{ColumnChart}	家
emergency_medical_service_two_d_district	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2}	{BarChart,ColumnChart}	家
emergency_medical_service_two_d_city	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2}	{DonutChart,BarChart}	家
emergency_medical_service_percent_city	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2}	{DonutChart,BarPercentChart}	家
emergency_medical_service_time_created	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2}	{TimelineSeparateChart,TimelineStackedChart}	家
emergency_medical_service_map_legend	{#D84A4A,#3E8E7E,#F2C14E,#6D5DF2,#4B6F44,#8C564B,#4C78A8,#F58518,#54A24B,#E45756,#72B7B2,#B279A2,#8DD3C7,#BEBADA,#FB8072,#80B1D3,#FDB462,#B3DE69,#FCCDE5,#D9D9D9,#BC80BD,#CCEBC5,#FFED6F,#1B9E77,#D95F02,#7570B3,#E7298A,#66A61E,#E6AB02,#A6761D,#666666}	{MapLegend}	家
\.


--
-- Data for Name: component_maps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_maps (id, index, title, type, source, size, icon, paint, property) FROM stdin;
70	youbike_realtime	youbike站點	symbol	geojson	\N	youbike	{}	[{"key":"sna","name":"場站名稱"},{"key":"sno","name":"場站ID"},{"key":"available_return_bikes","name":"可還車位"},{"key":"available_rent_general_bikes","name":"剩餘車輛"}]
99	youbike_realtime_metrotaipei	youbike站點	symbol	geojson	\N	youbike	{}	[{"key":"sna","name":"場站名稱"},{"key":"sno","name":"場站ID"},{"key":"available_return_bikes","name":"可還車位"},{"key":"available_rent_general_bikes","name":"剩餘車輛"}]
100	bike_network_tpe	自行車路網	line	geojson	\N	\N	{"line-color":["match",["get","direction"],"雙向","#097138","單向","#007BFF","#808080"]}	[\r\n  {"key": "data_time", "name": "數據時間"},\r\n  {"key": "route_name", "name": "路線名稱"},\r\n  {"key": "city_code", "name": "城市代碼"},\r\n  {"key": "city", "name": "城市"},\r\n  {"key": "road_section_start", "name": "起點路段"},\r\n  {"key": "road_section_end", "name": "終點路段"},\r\n  {"key": "direction", "name": "方向"},\r\n  {"key": "cycling_length", "name": "自行車道長度"},\r\n  {"key": "finished_time", "name": "完工時間"},\r\n  {"key": "update_time", "name": "更新時間"}\r\n]
101	bike_network_metrotaipei	自行車路網	line	geojson	\N	\N	{"line-color":["match",["get","direction"],"雙向","#097138","單向","#007BFF","#808080"]}	[\r\n  {"key": "data_time", "name": "數據時間"},\r\n  {"key": "route_name", "name": "路線名稱"},\r\n  {"key": "city_code", "name": "城市代碼"},\r\n  {"key": "city", "name": "城市"},\r\n  {"key": "road_section_start", "name": "起點路段"},\r\n  {"key": "road_section_end", "name": "終點路段"},\r\n  {"key": "direction", "name": "方向"},\r\n  {"key": "cycling_length", "name": "自行車道長度"},\r\n  {"key": "finished_time", "name": "完工時間"},\r\n  {"key": "update_time", "name": "更新時間"}\r\n]
102	emergency_medical_services_taipei	急救責任醫院	circle	geojson	\N	\N	{"circle-color":"#D84A4A","circle-radius":6,"circle-stroke-color":"#FFFFFF","circle-stroke-width":1}	[{"key":"hospital_name","name":"醫院名稱"},{"key":"city","name":"城市"},{"key":"district","name":"行政區"},{"key":"address","name":"地址"},{"key":"tel","name":"電話"}]
103	emergency_medical_services	急救責任醫院	circle	geojson	\N	\N	{"circle-color":["match",["get","city"],"臺北市","#D84A4A","新北市","#3E8E7E","#D84A4A"],"circle-radius":6,"circle-stroke-color":"#FFFFFF","circle-stroke-width":1}	[{"key":"hospital_name","name":"醫院名稱"},{"key":"city","name":"城市"},{"key":"district","name":"行政區"},{"key":"address","name":"地址"},{"key":"tel","name":"電話"}]
\.


--
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.components (id, index, name) FROM stdin;
60	youbike_availability	YouBike使用情況
213	bike_network	自行車道路統計資料
212	ebus_percent	電動巴士比例
214	dependency_aging	扶養比及老化指數
216	city_age_distribution	全市年齡分區
218	aging_kpi	長照指標
215	aging_workforce_trend	高齡就業人口之年增結構
217	bike_map	自行車道路網圖資
219	foodborne_disease_three_d_district_year	食品相關疾病案件（2023~2025 行政區 x 年度）
220	foodborne_disease_three_d_year_district	食品相關疾病案件（2023~2025 年度 x 行政區）
221	foodborne_disease_two_d_district	食品相關疾病案件（2023~2025 行政區總覽）
222	foodborne_disease_two_d_year	食品相關疾病案件（2023~2025 年度總覽）
223	foodborne_disease_percent_district	食品相關疾病案件（2023~2025 行政區占比）
224	foodborne_disease_time_year	食品相關疾病案件（2023~2025 年度趨勢）
225	foodborne_disease_map_legend	食品相關疾病案件圖例（2023~2025）
226	food_inspection_three_d_district_year	食品抽驗量（行政區 x 年度）
227	food_inspection_three_d_year_district	食品抽驗量（年度 x 行政區）
228	food_inspection_two_d_district	食品抽驗量（行政區總覽）
229	food_inspection_two_d_year	食品抽驗量（年度總覽）
230	food_inspection_percent_result	食品抽驗結果占比
231	food_inspection_time_daily	食品抽驗量（日趨勢）
232	food_inspection_map_legend	食品抽驗圖例
233	emergency_medical_service_three_d_district_city	急救責任醫院數（行政區 x 城市）
234	emergency_medical_service_three_d_city_district	急救責任醫院數（城市 x 行政區）
235	emergency_medical_service_two_d_district	急救責任醫院數（行政區總覽）
236	emergency_medical_service_two_d_city	急救責任醫院數（城市總覽）
237	emergency_medical_service_percent_city	急救責任醫院占比
238	emergency_medical_service_time_created	急救責任醫院數（時間序列）
239	emergency_medical_service_map_legend	急救責任醫院圖例
\.


--
-- Data for Name: contributors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contributors (id, user_id, user_name, image, link, identity, description, include, created_at, updated_at) FROM stdin;
1	doit	臺北市政府資訊局	doit.png	https://doit.gov.taipei/	\N	\N	f	2024-05-09 01:58:47.164185+00	2024-05-09 01:58:47.164185+00
2	ntpc	新北市政府資訊中心	ntpc.png	https://www.imc.ntpc.gov.tw/	\N	\N	f	2024-05-09 01:58:47.164185+00	2024-05-09 01:58:47.164185+00
\.

--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboards (id, index, name, components, icon, updated_at, created_at) FROM stdin;
106	map-layers-taipei	圖資資訊	{217,239}	public	2025-03-12 01:59:00.512775+00	2024-03-21 10:04:24.928533+00
356	ltc_care_tpe	長照關懷	{214,215,216,218}	elderly	2025-02-26 08:43:42.86017+00	2024-03-21 09:38:37.66+00
355	ltc_care_newtpe	長照關懷	{214,215,216,218}	elderly	2025-02-27 06:42:21.705931+00	2024-03-21 09:38:37.66+00
359	map-layers-metrotaipei	圖資資訊	{217,239}	public	2024-05-16 03:56:12.76016+00	2024-03-21 10:04:24.928533+00
358	practical_transportation_newtpe	務實交通	{60,212,213}	directions_car	2025-03-12 08:00:38.75842+00	2024-03-21 09:38:37.66+00
360	health_food_medical_tpe	食安醫療	{219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239}	local_hospital	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00
361	health_food_medical_metrotaipei	食安醫療	{219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239}	local_hospital	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00
1	09a25cd9cb7d	收藏組件	\N	favorite	2025-03-14 07:34:22.247753+00	2025-03-14 07:34:22.247753+00
2	3245d9eace5f	我的新儀表板	{215,218,216,213,212,214,60,146}	star	2025-03-14 14:55:11.732116+00	2025-03-14 14:55:11.732116+00
\.


COPY public.groups (id, name, is_personal, create_by) FROM stdin;
1	public	f	\N
2	taipei	f	\N
3	metrotaipei	f	\N
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issues (id, title, user_name, user_id, context, description, decision_desc, status, updated_by, created_at, updated_at) FROM stdin;
4	test	Drew	1	test	test	測試	不處理	doit	2024-03-15 07:33:39.695288+00	2024-07-26 06:37:55.038985+00
\.


ALTER TABLE public.query_charts OWNER TO postgres;
\.
TRUNCATE TABLE public.query_charts RESTART IDENTITY CASCADE;
COPY public.query_charts (index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city) FROM stdin;
aging_kpi	\N	{}	{}	static	\N	0	\N	主計處	此圖顯示雙北長照關懷各項指標。	此圖表呈現雙北長照關懷相關指標，包括 扶老比、扶幼比、扶養比 及 老化指數。扶老比代表每百名勞動人口需扶養的老年人口數，扶幼比則是需扶養的兒童人口數，而扶養比則合計這兩者，反映整體社會負擔程度。老化指數則比較老年人口與兒童人口比例，顯示人口結構的高齡化趨勢。這些數據可用於評估長照需求，並規劃資源分配與政策方向，以因應人口老化帶來的挑戰。	在制定長照政策時，政府可運用 扶老比、扶幼比、扶養比 及 老化指數 來評估未來照護需求。例如，某城市發現扶老比上升且老化指數超過 100，代表老年人口已多於兒童，預示長照需求將持續增加。政府可據此增設長照機構、強化居家照護服務，並鼓勵社區共融計畫，以減輕勞動人口的扶養壓力，確保高齡者獲得適切照顧。	{https://data.taipei/dataset/detail?id=64c8a3a0-3b9a-4f49-a13a-fb1eb2ffa4b1,https://data.ntpc.gov.tw/datasets/8308ab58-62d1-424e-8314-24b65b7ab492}	{doit,ntpc}	2023-12-20 05:56:00+00	2024-06-12 06:02:41.642+00	three_d	select y_axis,icon ,round(avg(data))data  \r\nfrom(\r\nselect '扶老比' as y_axis, percent30 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '扶幼比' as y_axis, percent31 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '扶養比' as y_axis, percent32 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '老化指數' as y_axis, percent33 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '扶老比' as y_axis, avg(percent30) as data ,'%' as icon \r\nfrom public.city_age_distribution_newtaipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_newtaipei )  and 統計類型='計'\r\nunion all\r\nselect '扶幼比' as y_axis, avg(percent31) as data ,'%' as icon \r\nfrom public.city_age_distribution_newtaipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_newtaipei ) and 統計類型='計'\r\nunion all\r\nselect '扶養比' as y_axis, avg(percent32) as data ,'%' as icon \r\nfrom public.city_age_distribution_newtaipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_newtaipei )  and 統計類型='計'\r\nunion all\r\nselect '老化指數' as y_axis, avg(percent33) as data ,'%' as icon \r\nfrom public.city_age_distribution_newtaipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_newtaipei )  and 統計類型='計'\r\n)d\r\ngroup by y_axis,icon	\N	metrotaipei
aging_kpi	\N	{}	{}	static	\N	0	\N	主計處	此圖顯示臺北長照關懷各項指標。	此圖表呈現臺北長照關懷相關指標，包括 扶老比、扶幼比、扶養比 及 老化指數。扶老比代表每百名勞動人口需扶養的老年人口數，扶幼比則是需扶養的兒童人口數，而扶養比則合計這兩者，反映整體社會負擔程度。老化指數則比較老年人口與兒童人口比例，顯示人口結構的高齡化趨勢。這些數據可用於評估長照需求，並規劃資源分配與政策方向，以因應人口老化帶來的挑戰。	在制定長照政策時，政府可運用 扶老比、扶幼比、扶養比 及 老化指數 來評估未來照護需求。例如，某城市發現扶老比上升且老化指數超過 100，代表老年人口已多於兒童，預示長照需求將持續增加。政府可據此增設長照機構、強化居家照護服務，並鼓勵社區共融計畫，以減輕勞動人口的扶養壓力，確保高齡者獲得適切照顧。	{https://data.taipei/dataset/detail?id=64c8a3a0-3b9a-4f49-a13a-fb1eb2ffa4b1}	{doit}	2023-12-20 05:56:00+00	2024-06-12 06:02:41.642+00	three_d	select y_axis,icon ,round(avg(data))data  \r\nfrom(\r\nselect '扶老比' as y_axis, percent30 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '扶幼比' as y_axis, percent31 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '扶養比' as y_axis, percent32 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\nunion all\r\nselect '老化指數' as y_axis, percent33 as data ,'%' as icon \r\nfrom public.city_age_distribution_taipei \r\nwhere 年份= (select max(年份) from public.city_age_distribution_taipei ) and  區域別='總計' and 統計類型='計'\r\n)d\r\ngroup by y_axis,icon	\N	taipei
aging_workforce_trend	\N	\N	\N	static	\N	\N	\N	主計處	顯示雙北就業人口之年齡結構時間數列統計資料	雙北地區人口年齡分配按月別時間數列統計資料，記錄臺北市與新北市各年齡層人口數的月度變化，涵蓋從0歲至65歲以上等多個年齡區間。該資料反映雙北地區人口在不同年齡層之分布情形，具備連續性與時間性，可作為分析區域人口結構、行政規劃及社會資源配置的重要參考。透過長期追蹤，亦能協助了解人口構成在不同時間點的變化狀況與組成比例，有助於支持各項人口相關研究與實務應用。	適用於跨域分析或探討都市群體共通趨勢，涵蓋臺北市與新北市兩地，常見於區域整體發展、通勤流動、就業市場整合、住宅與交通規劃等議題。亦可用於比較兩市人口結構差異、公共資源分布或整合性施政評估。例如：雙北地區勞動參與率變化、雙北通勤族群結構分析、雙北教育資源均衡程度探討等。	{https://data.taipei/dataset/detail?id=df320c78-f66b-4504-92b4-cf2a2eb46f1b,https://data.ntpc.gov.tw/datasets/c285509a-7fb2-434f-8542-0b4986c337a8}	{doit,ntpc}	2024-11-28 05:56:00+00	2024-12-10 02:59:39.341+00	three_d	select x_axis,y_axis,round(avg(percentage)) as data\r\nfrom (select year as x_axis,'1.非高齡就業人口' as y_axis,sum(percentage) as percentage  from employment_age_structure_tpe\r\nwhere  gender ='總計' and age_structure not in ('就業人口','就業人口按年齡別/45-49歲','就業人口按年齡別/50-54歲','就業人口按年齡別/55-59歲','就業人口按年齡別/60-64歲','就業人口按年齡別/65歲以上')\r\ngroup by year \r\nunion all \r\nselect year as x_axis,'2.中高齡就業人口' as y_axis,percentage as data  from employment_age_structure_tpe\r\nwhere  gender ='總計' and age_structure  in ('就業人口按年齡別/45-49歲','就業人口按年齡別/50-54歲','就業人口按年齡別/55-59歲','就業人口按年齡別/60-64歲')\r\nunion all \r\nselect year as x_axis,'3.高齡就業人口' as y_axis,percentage as data  from employment_age_structure_tpe\r\nwhere  gender ='總計' and age_structure  in ('就業人口按年齡別/65歲以上')\r\nunion all \r\nselect year as x_axis,'1.非高齡就業人口' as y_axis,sum(percentage) as data  from employment_age_structure_new_tpe\r\nwhere  gender ='總計' and age_structure not in ('就業人口','就業人口按年齡別/45-49歲','就業人口按年齡別/50-54歲','就業人口按年齡別/55-59歲','就業人口按年齡別/60-64歲','就業人口按年齡別/65歲以上')\r\ngroup by year \r\nunion all \r\nselect year as x_axis,'2.中高齡就業人口' as y_axis,percentage as data  from employment_age_structure_new_tpe\r\nwhere  gender ='總計' and age_structure  in ('就業人口按年齡別/45-49歲','就業人口按年齡別/50-54歲','就業人口按年齡別/55-59歲','就業人口按年齡別/60-64歲')\r\nunion all \r\nselect year as x_axis,'3.高齡就業人口' as y_axis,percentage as data  from employment_age_structure_new_tpe\r\nwhere  gender ='總計' and age_structure  in ('就業人口按年齡別/65歲以上'))d\r\nwhere x_axis >'2016'\r\ngroup by x_axis,y_axis \r\norder by 1,2	\N	metrotaipei
aging_workforce_trend	\N	\N	\N	static	\N	\N	\N	主計處	顯示臺北就業人口之年齡結構時間數列統計資料	臺北市人口年齡分配按月別時間數列統計資料，提供各年齡層人口數的定期統計結果，依月別呈現，涵蓋從幼年、青壯年至高齡等不同年齡區間。此資料可作為觀察人口結構組成的重要依據，反映各年齡層在人口總數中的分布情形。透過持續的月別紀錄，可供相關單位進行人口結構分析、資源分配規劃及政策評估等多元應用。資料內容具體、連續，適合用於進行長期與跨時比較之研究分析。	適用於聚焦單一行政區之人口、就業、教育、社會福利、都市規劃等議題。多用於市政層級的政策分析、市內人口結構觀察、社會服務配置研究，以及針對臺北市特定區域（如中正區、大安區等）的細部分析。例如：臺北市高齡人口比例變化、臺北市各區幼兒園分布狀況等。	{https://data.taipei/dataset/detail?id=df320c78-f66b-4504-92b4-cf2a2eb46f1b}	{doit}	2024-11-28 05:56:00+00	2025-03-19 10:25:55.340887+00	three_d	select x_axis,y_axis,round(avg(percentage)) as data\r\nfrom (select year as x_axis,'1.非高齡就業人口' as y_axis,sum(percentage) as percentage  from employment_age_structure_tpe\r\nwhere  gender ='總計' and age_structure not in ('就業人口','就業人口按年齡別/45-49歲','就業人口按年齡別/50-54歲','就業人口按年齡別/55-59歲','就業人口按年齡別/60-64歲','就業人口按年齡別/65歲以上')\r\ngroup by year \r\nunion all \r\nselect year as x_axis,'2.中高齡就業人口' as y_axis,percentage as data  from employment_age_structure_tpe\r\nwhere  gender ='總計' and age_structure  in ('就業人口按年齡別/45-49歲','就業人口按年齡別/50-54歲','就業人口按年齡別/55-59歲','就業人口按年齡別/60-64歲')\r\nunion all \r\nselect year as x_axis,'3.高齡就業人口' as y_axis,percentage as data  from employment_age_structure_tpe\r\nwhere  gender ='總計' and age_structure  in ('就業人口按年齡別/65歲以上')\r\n)d\r\nwhere x_axis >'2016'\r\ngroup by x_axis,y_axis \r\norder by 1,2	\N	taipei
bike_map	\N	{100,101}	{}	static	\N	\N	\N	交通局交工處	顯示雙北當前自行車路網分布。	顯示雙北當前自行車路網分布。雙北擁有完善的自行車路網，主要包括河濱自行車道和市區自行車道。河濱自行車道沿淡水河、基隆河、新店溪和景美溪等河岸建設，提供連續且風景優美的騎行路線。市區自行車道則遍布於主要道路，如敦化南北路、成功路、承德路、松隆路、松德路、和平西路、民生東路、北安路、金湖路、八德路、大道路、光復南路和永吉路等，方便市民在城市中安全騎行。此外，雙北政府持續推動「自行車道願景計畫」，以串聯既有路網、銜接跨市及河濱自行車道，並優化現有自行車道，提升騎行環境的便利性與安全性。	使用於地圖分析、交通規劃與旅遊建議，雙北的自行車路網可與其他圖資套疊，提供更深入的洞察。透過將自行車道與人口密度、交通流量或公車捷運路線交叉比對，可優化城市規劃，提高自行車友善程度。對於旅遊應用，可將自行車道與景點、商圈、飯店位置結合，推薦最佳騎行路線，提升遊憩體驗。此外，政府與企業可藉由數據分析發掘需求熱點，進一步優化自行車基礎設施與共享單車系統。	{https://tdx.transportdata.tw/api/basic/v2/Cycling/Shape/City/Taipei?%24top=30&%24format=JSON,https://tdx.transportdata.tw/api/basic/v2/Cycling/Shape/City/NewTaipei?%24top=30&%24format=JSON}	{doit,ntpc}	2023-12-20 05:56:00+00	2024-01-11 06:26:02.069+00	map_legend	SELECT unnest(array['自行車路網']) as name, 'line' as type	\N	metrotaipei
bike_map	\N	{100}	{}	static	\N	\N	\N	交通局交工處	顯示臺北當前自行車路網分布。	顯示臺北市當前自行車路網分布。臺北市擁有完善的自行車路網，主要由河濱自行車道與市區自行車道組成。河濱自行車道沿淡水河、基隆河、新店溪與景美溪等河岸規劃，提供連續、寬敞且景觀良好的騎行空間，深受市民與遊客喜愛。市區自行車道則分布於市內多條主要幹道，包括敦化南北路、承德路、松隆路、松德路、和平西路、民生東路、八德路、光復南路、永吉路等，串聯重要商圈、學區與轉運點，提升日常通勤與短程移動的便利性。臺北市政府持續推動「自行車道願景計畫」，整合市區與河濱車道系統、銜接捷運與轉乘據點，並優化既有路線與設施，致力打造友善、安全的騎乘環境。	使用於地圖分析、交通規劃與旅遊建議，雙北的自行車路網可與其他圖資套疊，提供更深入的洞察。透過將自行車道與人口密度、交通流量或公車捷運路線交叉比對，可優化城市規劃，提高自行車友善程度。對於旅遊應用，可將自行車道與景點、商圈、飯店位置結合，推薦最佳騎行路線，提升遊憩體驗。此外，政府與企業可藉由數據分析發掘需求熱點，進一步優化自行車基礎設施與共享單車系統。	{https://tdx.transportdata.tw/api/basic/v2/Cycling/Shape/City/Taipei?%24top=30&%24format=JSON}	{doit}	2023-12-20 05:56:00+00	2024-01-11 06:26:02.069+00	map_legend	SELECT unnest(array['自行車路網']) as name, 'line' as type	\N	taipei
bike_network	\N	{100,101}	{"mode":"byParam","byParam":{"xParam":"direction"}}	static	\N	\N	\N	交通局交工處	顯示雙北當前自行車路網分布。	顯示雙北當前自行車路網分布。雙北擁有完善的自行車路網，主要包括河濱自行車道和市區自行車道。河濱自行車道沿淡水河、基隆河、新店溪和景美溪等河岸建設，提供連續且風景優美的騎行路線。市區自行車道則遍布於主要道路，如敦化南北路、成功路、承德路、松隆路、松德路、和平西路、民生東路、北安路、金湖路、八德路、大道路、光復南路和永吉路等，方便市民在城市中安全騎行。此外，雙北政府持續推動「自行車道願景計畫」，以串聯既有路網、銜接跨市及河濱自行車道，並優化現有自行車道，提升騎行環境的便利性與安全性。	使用於地圖分析、交通規劃與旅遊建議，雙北的自行車路網可與其他圖資套疊，提供更深入的洞察。透過將自行車道與人口密度、交通流量或公車捷運路線交叉比對，可優化城市規劃，提高自行車友善程度。對於旅遊應用，可將自行車道與景點、商圈、飯店位置結合，推薦最佳騎行路線，提升遊憩體驗。此外，政府與企業可藉由數據分析發掘需求熱點，進一步優化自行車基礎設施與共享單車系統。	{https://tdx.transportdata.tw/api/basic/v2/Cycling/Shape/City/Taipei?%24top=30&%24format=JSON,https://tdx.transportdata.tw/api/basic/v2/Cycling/Shape/City/NewTaipei?%24top=30&%24format=JSON}	{doit,ntpc}	2023-12-20 05:56:00+00	2024-01-11 06:26:02.069+00	two_d	select x_axis,sum(data)data from (select  direction as x_axis ,round(sum(cycling_length)/1000) as data\r\nfrom public.bike_network_tpe  \r\ngroup by direction\r\nunion all\r\nselect  direction as x_axis ,round(sum(cycling_length)/1000) as data\r\nfrom public.bike_network_new_tpe  \r\ngroup by direction\r\n)d\r\nwhere x_axis !=''\r\ngroup by x_axis	\N	metrotaipei
bike_network	\N	{100}	{"mode":"byParam","byParam":{"xParam":"direction"}}	static	\N	\N	\N	交通局交工處	顯示臺北市當前自行車路網分布。	顯示臺北市當前自行車路網分布。臺北市擁有完善的自行車路網，主要包括河濱自行車道和市區自行車道。河濱自行車道沿淡水河、基隆河、新店溪和景美溪等河岸建設，提供連續且風景優美的騎行路線。市區自行車道則遍布於主要道路，如敦化南北路、成功路、承德路、松隆路、松德路、和平西路、民生東路、北安路、金湖路、八德路、大道路、光復南路和永吉路等，方便市民在城市中安全騎行。此外，臺北市政府持續推動「自行車道願景計畫」，以串聯既有路網、銜接跨市及河濱自行車道，並優化現有自行車道，提升騎行環境的便利性與安全性。	使用於地圖分析、交通規劃與旅遊建議，臺北市的自行車路網可與其他圖資套疊，提供更深入的洞察。透過將自行車道與人口密度、交通流量或公車捷運路線交叉比對，可優化城市規劃，提高自行車友善程度。對於旅遊應用，可將自行車道與景點、商圈、飯店位置結合，推薦最佳騎行路線，提升遊憩體驗。此外，政府與企業可藉由數據分析發掘需求熱點，進一步優化自行車基礎設施與共享單車系統。	{https://tdx.transportdata.tw/api/basic/v2/Cycling/Shape/City/Taipei?%24top=30&%24format=JSON}	{doit}	2023-12-20 05:56:00+00	2024-01-11 06:26:02.069+00	two_d	select  direction as x_axis ,round(sum(cycling_length)/1000) as data\r\nfrom public.bike_network_tpe  \r\nwhere direction !=''\r\ngroup by direction	\N	taipei
city_age_distribution	\N	\N	\N	static	\N	\N	\N	主計處	顯示雙北年齡分區	顯示雙北地區年齡分區，將人口依年齡群體劃分至不同城市區域。此分區有助於了解臺北市與新北市在人口結構上的差異與分布情形，包括各行政區的老化程度、青壯年與幼年人口比例，為政策制定者、城市規劃者及研究人員提供精確的分析依據。透過此資料，可進行跨區域的公共資源配置、社區規劃與長期照護服務設計，確保雙北地區在教育、交通、醫療與社福等層面能因應不同年齡層需求，促進整體都市發展的均衡與永續。	使用於城市規劃、社會政策制定及人口統計分析，雙北地區年齡分區數據可協助政府與研究機構掌握人口結構的變化情形。此指標適用於評估各年齡層在臺北市與新北市的區域分布，有助於規劃教育資源配置、醫療設施布建及長照服務佈點。除此之外，企業亦可依據此數據進行市場分析，針對不同年齡族群設計產品與服務，強化區域經營策略的精準度與效益。此資料為雙北區域在政策與產業發展上的重要基礎依據。	{https://data.taipei/dataset/detail?id=1e0c58e9-6aa5-4acb-a5a1-f60bacad60f3,https://data.ntpc.gov.tw/datasets/8308ab58-62d1-424e-8314-24b65b7ab492}	{doit,ntpc}	2024-11-28 05:56:00+00	2025-03-20 01:33:28.634747+00	three_d	select x_axis,y_axis,round(sum(data)/1000) data\r\nfrom(select 區域別 as x_axis,'0_14歲人口數' as y_axis,percent24 as data\r\nfrom \r\npublic.city_age_distribution_taipei \r\nwhere 區域別 != '總計' and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_taipei)\r\nunion all\r\nselect 區域別 as x_axis,'15_64歲人口數' as y_axis,percent26 as data\r\nfrom \r\npublic.city_age_distribution_taipei \r\nwhere 區域別 != '總計' and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_taipei)\r\nunion all\r\nselect 區域別 as x_axis,'65歲以上人口數' as y_axis,percent28 as data\r\nfrom \r\npublic.city_age_distribution_taipei \r\nwhere 區域別 != '總計' and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_taipei)\r\nunion all\r\nselect 區域別 as x_axis,'0_14歲人口數' as y_axis,percent24 as data\r\nfrom \r\npublic.city_age_distribution_newtaipei \r\nwhere 區域別 not in ('總計','新北市') and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_newtaipei)\r\nunion all\r\nselect 區域別 as x_axis,'15_64歲人口數' as y_axis,percent26 as data\r\nfrom \r\npublic.city_age_distribution_newtaipei \r\nwhere 區域別 not in ('總計','新北市') and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_newtaipei)  \r\nunion all\r\nselect 區域別 as x_axis,'65歲以上人口數' as y_axis,percent28 as data\r\nfrom \r\npublic.city_age_distribution_newtaipei \r\nwhere 區域別 not in ('總計','新北市') and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_newtaipei)\r\n)d\r\ngroup by x_axis,y_axis\r\n	\N	metrotaipei
city_age_distribution	\N	\N	\N	static	\N	\N	\N	主計處	顯示臺北市年齡分區	顯示臺北市年齡分區，將市民人口依年齡群體劃分至不同行政區域。此分區有助於掌握各區人口結構分布，包括幼年人口、青壯年人口與高齡人口比例，為政策制定者、城市規劃單位及研究人員提供重要的分析依據。透過此資料，可進行公共資源配置、社區照護設計及設施規劃，確保臺北市在教育、醫療、交通與長照等方面的發展，能更貼近各年齡層居民的實際需求，促進人口結構與城市功能的平衡發展。	使用於城市規劃、社會政策制定及人口統計分析，臺北市年齡分區數據可協助市府機關與研究單位掌握市內人口結構的變化。此指標適用於評估各年齡層在不同行政區的分布情形，有助於規劃教育資源、醫療設施及長照服務的佈局與優化。此外，企業亦可依據此資料進行在地市場分析，針對不同年齡族群設計產品與服務，提升區域經營策略的精準度與實效性，強化對臺北市多元人口需求的回應。\n\n\n\n\n\n\n\n\n	{https://data.taipei/dataset/detail?id=1e0c58e9-6aa5-4acb-a5a1-f60bacad60f3}	{doit}	2024-11-28 05:56:00+00	2025-02-21 07:52:55.450103+00	three_d	select x_axis,y_axis,round(sum(data)/1000) data\r\nfrom(select 區域別 as x_axis,'0_14歲人口數' as y_axis,percent24 as data\r\nfrom \r\npublic.city_age_distribution_taipei \r\nwhere 區域別 != '總計' and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_taipei)\r\nunion all\r\nselect 區域別 as x_axis,'15_64歲人口數' as y_axis,percent26 as data\r\nfrom \r\npublic.city_age_distribution_taipei \r\nwhere 區域別 != '總計' and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_taipei)\r\nunion all\r\nselect 區域別 as x_axis,'65歲以上人口數' as y_axis,percent28 as data\r\nfrom \r\npublic.city_age_distribution_taipei \r\nwhere 區域別 != '總計' and 年份=(select max(年份)\r\nfrom \r\npublic.city_age_distribution_taipei)\r\n)d\r\ngroup by x_axis,y_axis\r\n	\N	taipei
dependency_aging	\N	\N	\N	static	\N	\N	\N	主計處	顯示雙北扶養比及老化指數時間數列統計資料	顯示雙北扶養比及老化指數時間數列統計資料。雙北政府主計處提供了扶養比和老化指數資料，詳細記錄了各年齡段人口比例的變化情況。這些資料有助於分析雙北人口結構的演變，評估青壯年人口對幼年和老年人口的扶養負擔，以及社會老化程度。透過這些統計資料，政策制定者和研究人員可以深入了解人口趨勢，為未來的社會福利和經濟發展規劃提供參考。	使用於人口結構分析、社會福利規劃與經濟發展評估，雙北的扶養比與老化指數數據提供決策參考。政府機構可透過這些統計資料評估勞動力供給與社會扶養負擔，進而調整退休政策與醫療資源配置。企業可運用數據研判市場趨勢，規劃銀髮族產品與服務。學術研究則可透過時間序列分析，探討人口老化對經濟與社會的影響，為未來城市發展與人口政策提供科學依據。\r\n	{https://data.taipei/dataset/detail?id=aafb15dc-5508-4091-bd48-a708e60f6698,https://data.ntpc.gov.tw/datasets/8308ab58-62d1-424e-8314-24b65b7ab492}	{doit,ntpc}	2024-11-28 05:56:00+00	2024-12-10 02:59:39.341+00	time	select \r\nx_axis,y_axis,round(avg(data)) data\r\nfrom (\r\nselect TO_TIMESTAMP(end_of_year , 'YYYY-MM-DD HH24:MI:SS.MS') AT TIME ZONE 'Asia/Taipei' AS x_axis,\r\n'扶養比' as y_axis,total_dependency_ratio as data  \r\nfrom \r\ndependency_ratio_and_aging_index_tpe\r\nunion all\r\nselect TO_TIMESTAMP(end_of_year , 'YYYY-MM-DD HH24:MI:SS.MS') AT TIME ZONE 'Asia/Taipei' AS x_axis,\r\n'老化指數' as y_axis ,aging_index \r\nfrom \r\ndependency_ratio_and_aging_index_tpe\r\nunion all\r\nselect TO_TIMESTAMP(end_of_year , 'YYYY-MM-DD HH24:MI:SS.MS') AT TIME ZONE 'Asia/Taipei' AS x_axis,\r\n'扶養比' as y_axis,total_dependency_ratio  \r\nfrom \r\ndependency_ratio_and_aging_index_new_tpe\r\nunion all\r\nselect TO_TIMESTAMP(end_of_year , 'YYYY-MM-DD HH24:MI:SS.MS') AT TIME ZONE 'Asia/Taipei' AS x_axis,\r\n'老化指數' as y_axis ,aging_index \r\nfrom \r\ndependency_ratio_and_aging_index_new_tpe\r\n)d\r\nwhere x_axis >'2013-01-01 00:00:00.000'\r\ngroup by x_axis,y_axis\r\norder by 1\r\n	\N	metrotaipei
dependency_aging	\N	\N	\N	static	\N	\N	\N	主計處	顯示臺北市扶養比及老化指數時間數列統計資料	顯示臺北市扶養比及老化指數時間數列統計資料。臺北市政府主計處提供了扶養比和老化指數資料，詳細記錄了各年齡段人口比例的變化情況。這些資料有助於分析臺北市人口結構的演變，評估青壯年人口對幼年和老年人口的扶養負擔，以及社會老化程度。透過這些統計資料，政策制定者和研究人員可以深入了解人口趨勢，為未來的社會福利和經濟發展規劃提供參考。	使用於人口結構分析、社會福利規劃與經濟發展評估，臺北市的扶養比與老化指數數據提供決策參考。政府機構可透過這些統計資料評估勞動力供給與社會扶養負擔，進而調整退休政策與醫療資源配置。企業可運用數據研判市場趨勢，規劃銀髮族產品與服務。學術研究則可透過時間序列分析，探討人口老化對經濟與社會的影響，為未來城市發展與人口政策提供科學依據。\r\n	{https://data.taipei/dataset/detail?id=aafb15dc-5508-4091-bd48-a708e60f6698}	{doit}	2024-11-28 05:56:00+00	2025-02-25 01:43:21.031142+00	time	select \r\nx_axis,y_axis,round(avg(data)) data\r\nfrom (\r\nselect TO_TIMESTAMP(end_of_year , 'YYYY-MM-DD HH24:MI:SS.MS') AT TIME ZONE 'Asia/Taipei' AS x_axis,\r\n'扶養比' as y_axis,total_dependency_ratio as data  \r\nfrom \r\ndependency_ratio_and_aging_index_tpe\r\nunion all\r\nselect TO_TIMESTAMP(end_of_year , 'YYYY-MM-DD HH24:MI:SS.MS') AT TIME ZONE 'Asia/Taipei' AS x_axis,\r\n'老化指數' as y_axis ,aging_index \r\nfrom \r\ndependency_ratio_and_aging_index_tpe\r\n)d\r\nwhere x_axis >'2013-01-01 00:00:00.000'\r\ngroup by x_axis,y_axis\r\norder by 1\r\n	\N	taipei
ebus_percent	\N	\N	\N	static	\N	\N	\N	交通局	顯示雙北電動公車比例	此圖顯示雙北地區電動公車的比例，呈現臺北市與新北市公車車隊中電動車所占比重，以及近年來電動公車數量的成長情形。圖表比較傳統燃油公車與電動公車的比例變化，並標示雙北兩市政府推動電動化政策、補助措施及其帶來的環保效益。透過這些數據，可評估雙北地區電動公車的普及程度，及其對減碳、空氣品質改善的實質貢獻，進一步作為規劃大臺北地區公共運輸電動化策略的重要依據，推動都會區交通體系朝向低碳永續發展。	可用於評估雙北地區公共運輸電動化進程，透過此圖顯示臺北市與新北市公車系統中電動公車的占比及成長趨勢。圖表比較傳統燃油公車與電動公車的比例變化，並標示雙北兩市推動相關政策、補助措施及其所帶來的環保效益。透過這些數據，可評估雙北地區電動公車的普及率，以及其在減碳排放與空氣品質改善上的具體貢獻，進而作為制定更完善的都會區公共運輸電動化策略的重要依據，推動雙北朝向低碳永續城市目標發展。	{https://tdx.transportdata.tw/api/basic/v2/Bus/Vehicle/City/Taipei?%24top=30&%24format=JSON,https://tdx.transportdata.tw/api/basic/v2/Bus/Vehicle/City/NewTaipei?%24top=30&%24format=JSON}	{doit,ntpc}	2025-02-15 05:56:00+00	2024-02-15 02:59:39.341+00	percent	select '電動公車數量' as x_axis,y_axis,sum(data) data from \r\n(select '電動巴士' as y_axis,count(*) as  data\r\nfrom public.bus_info_new_tpe\r\nwhere plate_numb like 'E%'\r\nunion all\r\nselect '非電動巴士' as y_axis,count(*) as  data\r\nfrom public.bus_info_new_tpe\r\nwhere plate_numb not like 'E%'\r\nunion all\r\nselect '電動巴士' as y_axis,count(*) as  data\r\nfrom public.bus_info_tpe\r\nwhere plate_numb like 'E%'\r\nunion all\r\nselect '非電動巴士' as y_axis,count(*) as  data\r\nfrom public.bus_info_tpe)d\r\ngroup by \r\ny_axis\r\n	\N	metrotaipei
ebus_percent	\N	\N	\N	static	\N	\N	\N	交通局	顯示臺北電動公車比例	此圖顯示臺北市電動公車的比例，呈現全市公車車隊中電動車所占比重，以及近年來電動公車數量的成長情形。圖表比較傳統燃油公車與電動公車的比例變化，並標示臺北市政府推動電動化政策、補助措施及其帶來的環保效益。透過這些數據，可評估臺北市電動公車的普及程度，及其在減碳與空氣品質改善上的貢獻，有助於進一步規劃更完善的公共運輸電動化策略，推動城市交通朝向低碳永續目標邁進。	可用於評估臺北市公共運輸電動化的進程，透過此圖顯示電動公車在市區公車總數中的占比及其成長趨勢。圖表呈現傳統燃油公車與電動公車的比例變化，並標示臺北市政府推動的政策措施、補助方案及相關環保效益等影響因素。透過這些數據，可分析臺北市電動公車的普及程度及其在減碳排放與空氣品質改善方面的貢獻，有助於進一步規劃更完善的公共運輸電動化策略，推動臺北朝向低碳與永續發展的城市目標邁進。	{https://tdx.transportdata.tw/api/basic/v2/Bus/Vehicle/City/Taipei?%24top=30&%24format=JSON}	{doit}	2025-02-15 05:56:00+00	2025-02-20 09:11:21.620625+00	percent	select '電動公車數量' as x_axis,y_axis,sum(data) data from \r\n(\r\nselect '電動巴士' as y_axis,count(*) as  data\r\nfrom public.bus_info_tpe\r\nwhere plate_numb like 'E%'\r\nunion all\r\nselect '非電動巴士' as y_axis,count(*) as  data\r\nfrom public.bus_info_tpe)d\r\ngroup by \r\ny_axis	\N	taipei
youbike_availability	\N	{99}	\N	current	\N	10	minute	交通局	顯示當前雙北共享單車YouBike的使用情況。	顯示雙北地區（臺北市與新北市）當前共享單車 YouBike 的使用情況，格式為可借車輛數／全區車位數。資料來源為兩市交通局公開資料，每5分鐘更新一次，提供即時的車輛可用資訊與站點使用狀況，有助於掌握整體運行效率與民眾使用情形，亦可作為交通管理與營運調度的參考依據。	藉由顯示雙北地區 YouBike 的使用情況，以及觀察可借車輛數約為車柱總數的一半，可大致掌握目前停放於站點與使用中車輛的整體分布情形。使用者亦可透過地圖模式查詢雙北各站點的即時資訊，包括可借車輛數、可還空位數及站點位置，方便規劃路線與掌握使用狀況，提升共享單車的便利性與使用效率。	{https://tdx.transportdata.tw/api-service/swagger/basic/2cc9b888-a592-496f-99de-9ab35b7fb70d#/Bike/BikeApi_Availability_2181,https://tdx.transportdata.tw/api/basic/v2/Bike/Availability/City/NewTaipei?%24top=30&%24format=JSON}	{doit,ntpc}	2023-12-20 05:56:00+00	2024-03-19 06:08:17.99+00	percent	select x_axis,y_axis,sum(data)data\r\nfrom (select '在站車輛' as x_axis, \r\nunnest(ARRAY['可借車輛', '空位']) as y_axis, \r\nunnest(ARRAY[SUM(available_rent_general_bikes), SUM(available_return_bikes)]) as data\r\nfrom tran_ubike_realtime_new_tpe\r\nunion all \r\nselect '在站車輛' as x_axis, \r\nunnest(ARRAY['可借車輛', '空位']) as y_axis, \r\nunnest(ARRAY[SUM(available_rent_general_bikes), SUM(available_return_bikes)]) as data\r\nfrom tran_ubike_realtime)d\r\ngroup by x_axis,y_axis	\N	metrotaipei
youbike_availability	\N	{70}	\N	current	\N	10	minute	交通局	顯示當前臺北市共享單車YouBike的使用情況。	顯示臺北市當前共享單車 YouBike 的使用情況，格式為可借車輛數／全市車位數。資料來源為臺北市政府交通局公開資料，每5分鐘更新一次，反映即時的使用狀況與車輛調度情形，可作為交通監測與市民使用參考依據。	藉由臺北市 YouBike 使用情況的顯示，以及全市可借車輛數約為車柱總數的一半，可大致掌握目前停放於站點與正在使用中的車輛數量。使用者可透過地圖模式查詢臺北市各站點的即時資訊，包括可借車輛數、可還空位數及站點位置，方便即時掌握使用狀況，提升共享單車的使用效率與便利性。	{https://tdx.transportdata.tw/api-service/swagger/basic/2cc9b888-a592-496f-99de-9ab35b7fb70d#/Bike/BikeApi_Availability_2181}	{doit}	2023-12-20 05:56:00+00	2024-03-19 06:08:17.99+00	percent	select '在站車輛' as x_axis, \r\nunnest(ARRAY['可借車輛', '空位']) as y_axis, \r\nunnest(ARRAY[SUM(available_rent_general_bikes), SUM(available_return_bikes)]) as data\r\nfrom tran_ubike_realtime	\N	taipei
foodborne_disease_three_d_district_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 行政區 x 年度）	食品相關疾病案件（2023~2025 行政區 x 年度），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select district as x_axis, trim(year) as y_axis, sum(cases)::int as data from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by district, trim(year) order by district, trim(year)::int	\N	taipei
foodborne_disease_three_d_district_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 行政區 x 年度）	食品相關疾病案件（2023~2025 行政區 x 年度），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select district as x_axis, trim(year) as y_axis, sum(cases)::int as data from public.foodborne_disease where trim(year)::int between 112 and 114 group by district, trim(year) order by district, trim(year)::int	\N	metrotaipei
foodborne_disease_three_d_year_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 年度 x 行政區）	食品相關疾病案件（2023~2025 年度 x 行政區），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select trim(year) as x_axis, district as y_axis, sum(cases)::int as data from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by trim(year), district order by trim(year)::int, district	\N	taipei
foodborne_disease_three_d_year_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 年度 x 行政區）	食品相關疾病案件（2023~2025 年度 x 行政區），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select trim(year) as x_axis, district as y_axis, sum(cases)::int as data from public.foodborne_disease where trim(year)::int between 112 and 114 group by trim(year), district order by trim(year)::int, district	\N	metrotaipei
foodborne_disease_two_d_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 行政區總覽）	食品相關疾病案件（2023~2025 行政區總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select district as x_axis, sum(cases)::int as data from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by district order by district	\N	taipei
foodborne_disease_two_d_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 行政區總覽）	食品相關疾病案件（2023~2025 行政區總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select district as x_axis, sum(cases)::int as data from public.foodborne_disease where trim(year)::int between 112 and 114 group by district order by district	\N	metrotaipei
foodborne_disease_two_d_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 年度總覽）	食品相關疾病案件（2023~2025 年度總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select trim(year) as x_axis, sum(cases)::int as data from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by trim(year) order by trim(year)::int	\N	taipei
foodborne_disease_two_d_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 年度總覽）	食品相關疾病案件（2023~2025 年度總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select trim(year) as x_axis, sum(cases)::int as data from public.foodborne_disease where trim(year)::int between 112 and 114 group by trim(year) order by trim(year)::int	\N	metrotaipei
foodborne_disease_percent_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 行政區占比）	食品相關疾病案件（2023~2025 行政區占比），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	percent	select '食品相關疾病案件占比' as x_axis, district as y_axis, sum(cases)::int as data from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by district order by district	\N	taipei
foodborne_disease_percent_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 行政區占比）	食品相關疾病案件（2023~2025 行政區占比），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	percent	select '食品相關疾病案件占比' as x_axis, district as y_axis, sum(cases)::int as data from public.foodborne_disease where trim(year)::int between 112 and 114 group by district order by district	\N	metrotaipei
foodborne_disease_time_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 年度趨勢）	食品相關疾病案件（2023~2025 年度趨勢），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	time	select make_timestamp(trim(year)::int + 1911, 1, 1, 0, 0, 0) as x_axis, district as y_axis, sum(cases)::float as data from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by trim(year), district order by trim(year)::int, district	\N	taipei
foodborne_disease_time_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件（2023~2025 年度趨勢）	食品相關疾病案件（2023~2025 年度趨勢），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	time	select make_timestamp(trim(year)::int + 1911, 1, 1, 0, 0, 0) as x_axis, district as y_axis, sum(cases)::float as data from public.foodborne_disease where trim(year)::int between 112 and 114 group by trim(year), district order by trim(year)::int, district	\N	metrotaipei
foodborne_disease_map_legend	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件圖例（2023~2025）	食品相關疾病案件圖例（2023~2025），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	map_legend	select district as name, 'circle' as type, sum(cases)::float as value from public.foodborne_disease where city='臺北市' and trim(year)::int between 112 and 114 group by district order by value desc	\N	taipei
foodborne_disease_map_legend	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品相關疾病案件圖例（2023~2025）	食品相關疾病案件圖例（2023~2025），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	map_legend	select district as name, 'circle' as type, sum(cases)::float as value from public.foodborne_disease where trim(year)::int between 112 and 114 group by district order by value desc	\N	metrotaipei
food_inspection_three_d_district_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（行政區 x 年度）	食品抽驗量（行政區 x 年度），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select district as x_axis, trim(year) as y_axis, sum(count)::int as data from public.food_inspection where city='臺北市' group by district, trim(year) order by district, trim(year)::int	\N	taipei
food_inspection_three_d_district_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（行政區 x 年度）	食品抽驗量（行政區 x 年度），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select district as x_axis, trim(year) as y_axis, sum(count)::int as data from public.food_inspection group by district, trim(year) order by district, trim(year)::int	\N	metrotaipei
food_inspection_three_d_year_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（年度 x 行政區）	食品抽驗量（年度 x 行政區），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select trim(year) as x_axis, district as y_axis, sum(count)::int as data from public.food_inspection where city='臺北市' group by trim(year), district order by trim(year)::int, district	\N	taipei
food_inspection_three_d_year_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（年度 x 行政區）	食品抽驗量（年度 x 行政區），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select trim(year) as x_axis, district as y_axis, sum(count)::int as data from public.food_inspection group by trim(year), district order by trim(year)::int, district	\N	metrotaipei
food_inspection_two_d_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（行政區總覽）	食品抽驗量（行政區總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select district as x_axis, sum(count)::int as data from public.food_inspection where city='臺北市' group by district order by district	\N	taipei
food_inspection_two_d_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（行政區總覽）	食品抽驗量（行政區總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select district as x_axis, sum(count)::int as data from public.food_inspection group by district order by district	\N	metrotaipei
food_inspection_two_d_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（年度總覽）	食品抽驗量（年度總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select trim(year) as x_axis, sum(count)::int as data from public.food_inspection where city='臺北市' group by trim(year) order by trim(year)::int	\N	taipei
food_inspection_two_d_year	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（年度總覽）	食品抽驗量（年度總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select trim(year) as x_axis, sum(count)::int as data from public.food_inspection group by trim(year) order by trim(year)::int	\N	metrotaipei
food_inspection_percent_result	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗結果占比	食品抽驗結果占比，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	percent	select '食品抽驗結果占比' as x_axis, case when result then '合格' else '不合格' end as y_axis, sum(count)::int as data from public.food_inspection where city='臺北市' group by y_axis order by y_axis	\N	taipei
food_inspection_percent_result	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗結果占比	食品抽驗結果占比，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	percent	select '食品抽驗結果占比' as x_axis, case when result then '合格' else '不合格' end as y_axis, sum(count)::int as data from public.food_inspection group by y_axis order by y_axis	\N	metrotaipei
food_inspection_time_daily	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（日趨勢）	食品抽驗量（日趨勢），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	time	select to_timestamp(inspection_date, 'YYYY-MM-DD') at time zone 'Asia/Taipei' as x_axis, district as y_axis, sum(count)::float as data from public.food_inspection where city='臺北市' group by inspection_date, district order by inspection_date, district	\N	taipei
food_inspection_time_daily	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗量（日趨勢）	食品抽驗量（日趨勢），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	time	select to_timestamp(inspection_date, 'YYYY-MM-DD') at time zone 'Asia/Taipei' as x_axis, district as y_axis, sum(count)::float as data from public.food_inspection group by inspection_date, district order by inspection_date, district	\N	metrotaipei
food_inspection_map_legend	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗圖例	食品抽驗圖例，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	map_legend	select district as name, 'circle' as type, sum(count)::float as value from public.food_inspection where city='臺北市' group by district order by value desc	\N	taipei
food_inspection_map_legend	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	食品抽驗圖例	食品抽驗圖例，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	map_legend	select district as name, 'circle' as type, sum(count)::float as value from public.food_inspection group by district order by value desc	\N	metrotaipei
emergency_medical_service_three_d_district_city	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（行政區 x 城市）	急救責任醫院數（行政區 x 城市），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select district as x_axis, city as y_axis, count(*)::int as data from public.emergency_medical_service where city='臺北市' group by district, city order by district, city	\N	taipei
emergency_medical_service_three_d_district_city	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（行政區 x 城市）	急救責任醫院數（行政區 x 城市），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select district as x_axis, city as y_axis, count(*)::int as data from public.emergency_medical_service group by district, city order by district, city	\N	metrotaipei
emergency_medical_service_three_d_city_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（城市 x 行政區）	急救責任醫院數（城市 x 行政區），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select city as x_axis, district as y_axis, count(*)::int as data from public.emergency_medical_service where city='臺北市' group by city, district order by city, district	\N	taipei
emergency_medical_service_three_d_city_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（城市 x 行政區）	急救責任醫院數（城市 x 行政區），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	three_d	select city as x_axis, district as y_axis, count(*)::int as data from public.emergency_medical_service group by city, district order by city, district	\N	metrotaipei
emergency_medical_service_two_d_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（行政區總覽）	急救責任醫院數（行政區總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select district as x_axis, count(*)::int as data from public.emergency_medical_service where city='臺北市' group by district order by district	\N	taipei
emergency_medical_service_two_d_district	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（行政區總覽）	急救責任醫院數（行政區總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select district as x_axis, count(*)::int as data from public.emergency_medical_service group by district order by district	\N	metrotaipei
emergency_medical_service_two_d_city	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（城市總覽）	急救責任醫院數（城市總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select city as x_axis, count(*)::int as data from public.emergency_medical_service where city='臺北市' group by city order by city	\N	taipei
emergency_medical_service_two_d_city	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（城市總覽）	急救責任醫院數（城市總覽），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	two_d	select city as x_axis, count(*)::int as data from public.emergency_medical_service group by city order by city	\N	metrotaipei
emergency_medical_service_percent_city	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院占比	急救責任醫院占比，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	percent	select '急救責任醫院占比' as x_axis, city as y_axis, count(*)::int as data from public.emergency_medical_service where city='臺北市' group by city order by city	\N	taipei
emergency_medical_service_percent_city	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院占比	急救責任醫院占比，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	percent	select '急救責任醫院占比' as x_axis, city as y_axis, count(*)::int as data from public.emergency_medical_service group by city order by city	\N	metrotaipei
emergency_medical_service_time_created	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（時間序列）	急救責任醫院數（時間序列），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	time	select date_trunc('day', created_at) as x_axis, city as y_axis, count(*)::float as data from public.emergency_medical_service where city='臺北市' group by date_trunc('day', created_at), city order by x_axis, city	\N	taipei
emergency_medical_service_time_created	\N	\N	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院數（時間序列）	急救責任醫院數（時間序列），依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	time	select date_trunc('day', created_at) as x_axis, city as y_axis, count(*)::float as data from public.emergency_medical_service group by date_trunc('day', created_at), city order by x_axis, city	\N	metrotaipei
emergency_medical_service_map_legend	\N	{102}	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院圖例	急救責任醫院圖例，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	map_legend	select district as name, 'circle' as type, count(*)::float as value from public.emergency_medical_service where city='臺北市' group by district order by value desc	\N	taipei
emergency_medical_service_map_legend	\N	{103}	{}	static	\N	0	\N	臺北市/新北市政府資料開放平台	急救責任醫院圖例	急救責任醫院圖例，依需求輸出 x_axis / y_axis / data（或 name / type / value）。	可直接作為 query_charts raw SQL，供前端對應圖表型態渲染與比對。	{}	{doit,ntpc}	2026-05-02 00:00:00+00	2026-05-02 00:00:00+00	map_legend	select district as name, 'circle' as type, count(*)::float as value from public.emergency_medical_service group by district order by value desc	\N	metrotaipei
\.


COPY public.dashboard_groups (dashboard_id, group_id) FROM stdin;
1	4
2	4
106	2
356	2
355	3
359	3
358	3
360	2
361	3
\.

--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 222
-- Name: dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dashboards_id_seq', (SELECT COALESCE(MAX(id), 0) FROM public.dashboards), true);


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 224
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.groups_id_seq', (SELECT COALESCE(MAX(id), 4) FROM public.groups), true);


--
-- Custom overrides: food safety and emergency medical dashboard
--

INSERT INTO public.component_maps (id, index, title, type, source, size, icon, paint, property)
VALUES
(
    104,
    'foodborne_disease_metrotaipei',
    '食品相關疾病分布',
    'fill',
    'geojson',
    NULL,
    NULL,
    $${"fill-color":["step",["get","value"],"#E8F6EF",26,"#B8E3C8",51,"#7BC87C",76,"#2E8B57",101,"#0B3D2E"],"fill-opacity":0.72,"fill-outline-color":"#FFFFFF"}$$::json,
    $$[{"key":"city","name":"城市"},{"key":"district","name":"行政區"},{"key":"value","name":"食品相關疾病數量"}]$$::json
)
ON CONFLICT (id) DO UPDATE SET
    index = EXCLUDED.index,
    title = EXCLUDED.title,
    type = EXCLUDED.type,
    source = EXCLUDED.source,
    size = EXCLUDED.size,
    icon = EXCLUDED.icon,
    paint = EXCLUDED.paint,
    property = EXCLUDED.property;

INSERT INTO public.component_charts (index, color, types, unit)
VALUES
    ('foodborne_disease_map_legend', '{#E8F6EF,#B8E3C8,#7BC87C,#2E8B57,#0B3D2E}', '{MapLegend}', '件'),
    ('food_inspection_three_d_district_year', '{#56B96D,#ED6A45}', '{ColumnChart}', '件'),
    ('emergency_medical_service_map_legend', '{#D84A4A,#3E8E7E,#F2C14E}', '{TextUnitChart}', '家'),
    ('food_safety_risk_rank_map', '{#E8F6EF,#F5D76E,#F49F36,#E06666,#8B1E3F}', '{FoodSafetyRiskMap}', '分')
ON CONFLICT (index) DO UPDATE SET
    color = EXCLUDED.color,
    types = EXCLUDED.types,
    unit = EXCLUDED.unit;

INSERT INTO public.components (id, index, name)
VALUES (240, 'food_safety_risk_rank_map', '雙北各區食安風險排行')
ON CONFLICT (id) DO UPDATE SET
    index = EXCLUDED.index,
    name = EXCLUDED.name;

UPDATE public.components
SET name = CASE id
    WHEN 225 THEN '食品相關疾病分布'
    WHEN 226 THEN '食品抽驗結果（行政區）'
    WHEN 239 THEN '急救責任醫院數量'
    ELSE name
END
WHERE id IN (225, 226, 239);

UPDATE public.dashboards
SET components = '{240,225,226}',
    updated_at = '2026-05-02 00:00:00+00'
WHERE index IN ('health_food_medical_tpe', 'health_food_medical_metrotaipei');

INSERT INTO public.dashboards (id, index, name, components, icon, updated_at, created_at)
VALUES
    (365, 'medical_emergency_tpe', '醫療救護', '{239}', 'local_hospital', '2026-05-02 00:00:00+00', '2026-05-02 00:00:00+00'),
    (366, 'medical_emergency_newtpe', '醫療救護', '{239}', 'local_hospital', '2026-05-02 00:00:00+00', '2026-05-02 00:00:00+00')
ON CONFLICT (index) DO UPDATE SET
    name = EXCLUDED.name,
    components = EXCLUDED.components,
    icon = EXCLUDED.icon,
    updated_at = EXCLUDED.updated_at;

DELETE FROM public.dashboard_groups
USING public.dashboards
WHERE public.dashboard_groups.dashboard_id = public.dashboards.id
  AND public.dashboards.index IN ('medical_emergency_tpe', 'medical_emergency_newtpe');

INSERT INTO public.dashboard_groups (dashboard_id, group_id)
SELECT dashboards.id, groups.id
FROM public.dashboards
JOIN public.groups ON (
    (dashboards.index = 'medical_emergency_tpe' AND groups.name = 'taipei')
    OR (dashboards.index = 'medical_emergency_newtpe' AND groups.name = 'metrotaipei')
)
ON CONFLICT (dashboard_id, group_id) DO NOTHING;

UPDATE public.query_charts
SET
    map_config_ids = '{104}',
    short_desc = '食品相關疾病分布',
    long_desc = '以雙北行政區界呈現 2023~2025 年食品相關疾病案件數量，顏色越深代表近三年累計案件數越高。',
    use_case = '可用於辨識雙北近三年食品相關疾病案件較集中的行政區，輔助食安風險觀察與資源配置。',
    query_type = 'map_legend',
    query_chart = $$SELECT *
FROM (
    SELECT '0 - 25 件' AS name, 'fill' AS type
    UNION ALL SELECT '26 - 50 件', 'fill'
    UNION ALL SELECT '51 - 75 件', 'fill'
    UNION ALL SELECT '76 - 100 件', 'fill'
    UNION ALL SELECT '101 件以上', 'fill'
) legend$$
WHERE index = 'foodborne_disease_map_legend';

UPDATE public.query_charts
SET
    short_desc = '食品抽驗合格與不合格數量（行政區）',
    long_desc = '以堆疊長條圖呈現各行政區食品抽驗數量，長條下半部為合格、上半部為不合格。',
    use_case = '可用於比較各行政區食品抽驗量與不合格量，快速辨識抽驗量體與異常較高的區域。',
    query_type = 'three_d',
    query_chart = $$WITH districts AS (
    SELECT DISTINCT city, district
    FROM public.food_inspection
    WHERE city = '臺北市'
), statuses AS (
    SELECT '合格' AS label, TRUE AS result, 1 AS sort_order
    UNION ALL
    SELECT '不合格', FALSE, 2
)
SELECT districts.district AS x_axis,
       statuses.label AS y_axis,
       COALESCE(SUM(food_inspection.count), 0)::int AS data
FROM districts
CROSS JOIN statuses
LEFT JOIN public.food_inspection
    ON food_inspection.city = districts.city
   AND food_inspection.district = districts.district
   AND food_inspection.result = statuses.result
GROUP BY districts.district, statuses.label, statuses.sort_order
ORDER BY districts.district, statuses.sort_order$$
WHERE index = 'food_inspection_three_d_district_year'
  AND city = 'taipei';

UPDATE public.query_charts
SET
    short_desc = '食品抽驗合格與不合格數量（雙北行政區）',
    long_desc = '以堆疊長條圖呈現雙北各行政區食品抽驗數量，長條下半部為合格、上半部為不合格。',
    use_case = '可用於比較雙北各行政區食品抽驗量與不合格量，快速辨識抽驗量體與異常較高的區域。',
    query_type = 'three_d',
    query_chart = $$WITH districts AS (
    SELECT DISTINCT city, district
    FROM public.food_inspection
), statuses AS (
    SELECT '合格' AS label, TRUE AS result, 1 AS sort_order
    UNION ALL
    SELECT '不合格', FALSE, 2
)
SELECT districts.city || districts.district AS x_axis,
       statuses.label AS y_axis,
       COALESCE(SUM(food_inspection.count), 0)::int AS data
FROM districts
CROSS JOIN statuses
LEFT JOIN public.food_inspection
    ON food_inspection.city = districts.city
   AND food_inspection.district = districts.district
   AND food_inspection.result = statuses.result
GROUP BY districts.city, districts.district, statuses.label, statuses.sort_order
ORDER BY districts.city, districts.district, statuses.sort_order$$
WHERE index = 'food_inspection_three_d_district_year'
  AND city = 'metrotaipei';

UPDATE public.query_charts
SET
    map_config_ids = '{103}',
    short_desc = '急救責任醫院數量',
    long_desc = '統計臺北市、新北市與雙北合計的急救責任醫院數量，並可在地圖上顯示醫院位置。',
    use_case = '可用於快速掌握雙北急救責任醫院資源分布，搭配地圖檢視各院位置與基本資訊。',
    query_type = 'three_d',
    query_chart = $$SELECT y_axis, icon, data
FROM (
    SELECT '臺北市' AS y_axis, '家' AS icon, COUNT(*)::int AS data, 1 AS sort_order
    FROM public.emergency_medical_service
    WHERE city = '臺北市'
    UNION ALL
    SELECT '新北市' AS y_axis, '家' AS icon, COUNT(*)::int AS data, 2 AS sort_order
    FROM public.emergency_medical_service
    WHERE city = '新北市'
    UNION ALL
    SELECT '雙北' AS y_axis, '家' AS icon, COUNT(*)::int AS data, 3 AS sort_order
    FROM public.emergency_medical_service
) stats
ORDER BY sort_order$$
WHERE index = 'emergency_medical_service_map_legend';

DELETE FROM public.query_charts
WHERE index = 'food_safety_risk_rank_map';

INSERT INTO public.query_charts (
    index,
    history_config,
    map_config_ids,
    map_filter,
    time_from,
    time_to,
    update_freq,
    update_freq_unit,
    source,
    short_desc,
    long_desc,
    use_case,
    links,
    contributors,
    created_at,
    updated_at,
    query_type,
    query_chart,
    query_history,
    city
)
VALUES
(
    'food_safety_risk_rank_map',
    NULL,
    NULL,
    '{}'::json,
    'static',
    NULL,
    0,
    NULL,
    '臺北市/新北市政府資料開放平台',
    '臺北市各區食安風險排行地圖',
    '以 2023~2025 年食品相關疾病案件、食品抽驗不合格率、急救責任醫院資源三項資料合成 0 到 100 分食安風險。算法：風險分數 = 100 * (0.50 * 疾病案件指數 + 0.35 * 平滑後抽驗不合格率指數 + 0.15 * 醫療應變缺口)。疾病案件指數為該區 2023~2025 年食品相關疾病案件數除以全市最高值；抽驗不合格率先用全市平均不合格率與 50 件虛擬樣本做平滑，避免低抽驗量行政區被少數不合格件數放大，再除以全市最高平滑不合格率；醫療應變缺口為 1 - 該區急救責任醫院數 / 全市最高急救責任醫院數。',
    '可用於快速辨識食安事件負擔高、抽驗不合格比例偏高且醫療應變資源相對不足的行政區，作為稽查排程、宣導與跨局處資源配置的優先排序參考。',
    '{}',
    '{doit}',
    '2026-05-02 00:00:00+00',
    '2026-05-02 00:00:00+00',
    'two_d',
    $$WITH districts AS (
    SELECT DISTINCT city, district
    FROM public.foodborne_disease
    WHERE city = '臺北市'
      AND trim(year)::int BETWEEN 112 AND 114
    UNION
    SELECT DISTINCT city, district
    FROM public.food_inspection
    WHERE city = '臺北市'
    UNION
    SELECT DISTINCT city, district
    FROM public.emergency_medical_service
    WHERE city = '臺北市'
),
disease AS (
    SELECT city, district, SUM(cases)::float AS disease_cases
    FROM public.foodborne_disease
    WHERE city = '臺北市'
      AND trim(year)::int BETWEEN 112 AND 114
    GROUP BY city, district
),
inspection AS (
    SELECT city,
           district,
           SUM(count)::float AS inspections,
           SUM(CASE WHEN result THEN 0 ELSE count END)::float AS failed_inspections
    FROM public.food_inspection
    WHERE city = '臺北市'
    GROUP BY city, district
),
hospital AS (
    SELECT city, district, COUNT(*)::float AS hospitals
    FROM public.emergency_medical_service
    WHERE city = '臺北市'
    GROUP BY city, district
),
metrics AS (
    SELECT districts.district,
           COALESCE(disease.disease_cases, 0) AS disease_cases,
           COALESCE(inspection.inspections, 0) AS inspections,
           COALESCE(inspection.failed_inspections, 0) AS failed_inspections,
           COALESCE(hospital.hospitals, 0) AS hospitals
    FROM districts
    LEFT JOIN disease
        ON disease.city = districts.city
       AND disease.district = districts.district
    LEFT JOIN inspection
        ON inspection.city = districts.city
       AND inspection.district = districts.district
    LEFT JOIN hospital
        ON hospital.city = districts.city
       AND hospital.district = districts.district
),
scored AS (
    SELECT metrics.*,
           CASE
               WHEN SUM(inspections) OVER () > 0
               THEN SUM(failed_inspections) OVER () / SUM(inspections) OVER ()
               ELSE 0
           END AS avg_fail_rate
    FROM metrics
),
indexed AS (
    SELECT district,
           disease_cases / NULLIF(MAX(disease_cases) OVER (), 0) AS disease_index,
           ((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0))
               / NULLIF(MAX((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0)) OVER (), 0) AS fail_index,
           1 - hospitals / NULLIF(MAX(hospitals) OVER (), 0) AS care_gap
    FROM scored
)
SELECT district AS x_axis,
       ROUND((100 * (
           0.50 * COALESCE(disease_index, 0) +
           0.35 * COALESCE(fail_index, 0) +
           0.15 * COALESCE(care_gap, 1)
       ))::numeric, 1)::float AS data
FROM indexed
ORDER BY data DESC, district$$,
    NULL,
    'taipei'
),
(
    'food_safety_risk_rank_map',
    NULL,
    NULL,
    '{}'::json,
    'static',
    NULL,
    0,
    NULL,
    '臺北市/新北市政府資料開放平台',
    '雙北各區食安風險排行地圖',
    '以 2023~2025 年食品相關疾病案件、食品抽驗不合格率、急救責任醫院資源三項資料合成 0 到 100 分食安風險。算法：風險分數 = 100 * (0.50 * 疾病案件指數 + 0.35 * 平滑後抽驗不合格率指數 + 0.15 * 醫療應變缺口)。疾病案件指數為該區 2023~2025 年食品相關疾病案件數除以雙北最高值；抽驗不合格率先用雙北平均不合格率與 50 件虛擬樣本做平滑，避免低抽驗量行政區被少數不合格件數放大，再除以雙北最高平滑不合格率；醫療應變缺口為 1 - 該區急救責任醫院數 / 雙北最高急救責任醫院數。',
    '可用於快速辨識食安事件負擔高、抽驗不合格比例偏高且醫療應變資源相對不足的行政區，作為稽查排程、宣導與跨局處資源配置的優先排序參考。',
    '{}',
    '{doit,ntpc}',
    '2026-05-02 00:00:00+00',
    '2026-05-02 00:00:00+00',
    'two_d',
$$WITH districts AS (
    SELECT DISTINCT city, district
    FROM public.foodborne_disease
    WHERE trim(year)::int BETWEEN 112 AND 114
      AND district <> '其他'
    UNION
    SELECT DISTINCT city, district
    FROM public.food_inspection
    UNION
    SELECT DISTINCT city, district
    FROM public.emergency_medical_service
),
disease AS (
    SELECT city, district, SUM(cases)::float AS disease_cases
    FROM public.foodborne_disease
    WHERE trim(year)::int BETWEEN 112 AND 114
    GROUP BY city, district
),
inspection AS (
    SELECT city,
           district,
           SUM(count)::float AS inspections,
           SUM(CASE WHEN result THEN 0 ELSE count END)::float AS failed_inspections
    FROM public.food_inspection
    GROUP BY city, district
),
hospital AS (
    SELECT city, district, COUNT(*)::float AS hospitals
    FROM public.emergency_medical_service
    GROUP BY city, district
),
metrics AS (
    SELECT districts.district,
           COALESCE(disease.disease_cases, 0) AS disease_cases,
           COALESCE(inspection.inspections, 0) AS inspections,
           COALESCE(inspection.failed_inspections, 0) AS failed_inspections,
           COALESCE(hospital.hospitals, 0) AS hospitals
    FROM districts
    LEFT JOIN disease
        ON disease.city = districts.city
       AND disease.district = districts.district
    LEFT JOIN inspection
        ON inspection.city = districts.city
       AND inspection.district = districts.district
    LEFT JOIN hospital
        ON hospital.city = districts.city
       AND hospital.district = districts.district
),
scored AS (
    SELECT metrics.*,
           CASE
               WHEN SUM(inspections) OVER () > 0
               THEN SUM(failed_inspections) OVER () / SUM(inspections) OVER ()
               ELSE 0
           END AS avg_fail_rate
    FROM metrics
),
indexed AS (
    SELECT district,
           disease_cases / NULLIF(MAX(disease_cases) OVER (), 0) AS disease_index,
           ((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0))
               / NULLIF(MAX((failed_inspections + avg_fail_rate * 50) / NULLIF(inspections + 50, 0)) OVER (), 0) AS fail_index,
           1 - hospitals / NULLIF(MAX(hospitals) OVER (), 0) AS care_gap
    FROM scored
)
SELECT district AS x_axis,
       ROUND((100 * (
           0.50 * COALESCE(disease_index, 0) +
           0.35 * COALESCE(fail_index, 0) +
           0.15 * COALESCE(care_gap, 1)
       ))::numeric, 1)::float AS data
FROM indexed
ORDER BY data DESC, district$$,
    NULL,
    'metrotaipei'
);

SELECT pg_catalog.setval('public.dashboards_id_seq', (SELECT COALESCE(MAX(id), 0) FROM public.dashboards), true);


-- Completed on 2024-02-16 10:38:44 UTC

--
-- PostgreSQL database dump complete
