<!-- Developed by Taipei Urban Intelligence Center 2023-2024-->

<script setup>
import { computed, ref, watch } from "vue";
import bus from "../assets/map/bus.png";
import metro from "../assets/map/metro.png";
import triangle_green from "../assets/map/triangle_green.png";
import triangle_white from "../assets/map/triangle_white.png";
import bike_green from "../assets/map/bike_green.png";
import bike_orange from "../assets/map/bike_orange.png";
import bike_red from "../assets/map/bike_red.png";
import cross_bold from "../assets/map/cross_bold.png";
import cross_normal from "../assets/map/cross_normal.png";
import cctv from "../assets/map/cctv.png";
import live from "../assets/map/live.png";

const props = defineProps([
	"activeCity",
	"chart_config",
	"series",
	"map_config",
	"map_filter",
	"map_filter_on",
]);
const emits = defineEmits([
	"filterByParam",
	"filterByLayer",
	"clearByParamFilter",
	"clearByLayerFilter",
	"fly"
]);

function returnIcon(name) {
	switch (name) {
	case "bus":
		return bus;
	case "metro":
		return metro;
	case "triangle_green":
		return triangle_green;
	case "triangle_white":
		return triangle_white;
	case "bike_green":
		return bike_green;
	case "bike_orange":
		return bike_orange;
	case "bike_red":
		return bike_red;
	case "cross_bold":
		return cross_bold;
	case "cross_normal":
		return cross_normal;
	case "cctv":
		return cctv;
	case "live":
		return live;
	default:
		return "";
	}
}

const selectedIndex = ref(null);
const geoJson = ref(null);
const geoJsonLoading = ref(false);
const CITY_PROPERTY_VALUES = {
	taipei: "臺北市",
	newtaipei: "新北市",
	taoyuan: "桃園市",
};

const inlineMapConfig = computed(() => {
	if (!Array.isArray(props.map_config)) return null;
	return props.map_config.find(
		(config) =>
			config &&
			config.type === "fill" &&
			config.source === "geojson" &&
			config.index
	);
});

const hasInlineMap = computed(() => Boolean(inlineMapConfig.value));
const inlineMapFeatures = computed(() => {
	const features = geoJson.value?.features || [];
	const cityName =
		CITY_PROPERTY_VALUES[props.activeCity] ||
		CITY_PROPERTY_VALUES[inlineMapConfig.value?.city];

	if (!cityName) return features;

	const filteredFeatures = features.filter(
		(feature) => feature.properties?.city === cityName
	);

	return filteredFeatures.length ? filteredFeatures : features;
});
const fillExpression = computed(
	() => inlineMapConfig.value?.paint?.["fill-color"]
);
const valueProperty = computed(() => {
	if (
		Array.isArray(fillExpression.value) &&
		Array.isArray(fillExpression.value[1]) &&
		fillExpression.value[1][0] === "get"
	) {
		return fillExpression.value[1][1];
	}
	return "value";
});

watch(
	() => inlineMapConfig.value?.index,
	async (index) => {
		geoJson.value = null;
		if (!index) return;

		geoJsonLoading.value = true;
		try {
			const response = await fetch(`/mapData/${index}.geojson`);
			if (!response.ok) {
				throw new Error(`Failed to load ${index}.geojson`);
			}
			geoJson.value = await response.json();
		} catch (error) {
			console.error(error);
			geoJson.value = null;
		} finally {
			geoJsonLoading.value = false;
		}
	},
	{ immediate: true }
);

function walkCoordinates(coordinates, callback) {
	if (!Array.isArray(coordinates)) return;
	if (typeof coordinates[0] === "number") {
		callback(coordinates);
		return;
	}
	coordinates.forEach((item) => walkCoordinates(item, callback));
}

const geoBounds = computed(() => {
	const bounds = {
		minLng: Infinity,
		maxLng: -Infinity,
		minLat: Infinity,
		maxLat: -Infinity,
	};

	inlineMapFeatures.value.forEach((feature) => {
		walkCoordinates(feature.geometry?.coordinates, ([lng, lat]) => {
			bounds.minLng = Math.min(bounds.minLng, lng);
			bounds.maxLng = Math.max(bounds.maxLng, lng);
			bounds.minLat = Math.min(bounds.minLat, lat);
			bounds.maxLat = Math.max(bounds.maxLat, lat);
		});
	});

	if (!Number.isFinite(bounds.minLng)) return null;
	return bounds;
});

function projectCoordinate([lng, lat]) {
	const bounds = geoBounds.value;
	if (!bounds) return [0, 0];

	const width = 320;
	const height = 210;
	const padding = 8;
	const lngSpan = bounds.maxLng - bounds.minLng || 1;
	const latSpan = bounds.maxLat - bounds.minLat || 1;
	const x =
		padding +
		((lng - bounds.minLng) / lngSpan) * (width - padding * 2);
	const y =
		padding +
		((bounds.maxLat - lat) / latSpan) * (height - padding * 2);

	return [x, y];
}

function ringToPath(ring) {
	return ring
		.map((coordinate, index) => {
			const [x, y] = projectCoordinate(coordinate);
			return `${index === 0 ? "M" : "L"}${x.toFixed(2)} ${y.toFixed(2)}`;
		})
		.join(" ");
}

function geometryToPath(geometry) {
	if (!geometry) return "";
	if (geometry.type === "Polygon") {
		return geometry.coordinates.map((ring) => `${ringToPath(ring)} Z`).join(" ");
	}
	if (geometry.type === "MultiPolygon") {
		return geometry.coordinates
			.flatMap((polygon) => polygon.map((ring) => `${ringToPath(ring)} Z`))
			.join(" ");
	}
	return "";
}

function getFeatureColor(feature) {
	const value = Number(feature.properties?.[valueProperty.value]) || 0;
	const expression = fillExpression.value;

	if (Array.isArray(expression) && expression[0] === "step") {
		let color = expression[2];
		for (let index = 3; index < expression.length; index += 2) {
			if (value >= expression[index]) {
				color = expression[index + 1];
			}
		}
		return color;
	}

	return props.chart_config.color[0];
}

const inlineMapPaths = computed(() => {
	return inlineMapFeatures.value.map((feature) => ({
		path: geometryToPath(feature.geometry),
		fill: getFeatureColor(feature),
		title: `${feature.properties?.city || ""}${
			feature.properties?.district || feature.properties?.TNAME || ""
		}: ${feature.properties?.[valueProperty.value] || 0} ${
			props.chart_config.unit || ""
		}`,
	}));
});

function handleDataSelection(index) {
	if (!props.map_filter || !props.map_filter_on) {
		return;
	}
	if (index !== selectedIndex.value) {
		// Supports filtering by xAxis
		if (props.map_filter.mode === "byParam") {
			emits(
				"filterByParam",
				props.map_filter,
				props.map_config,
				props.series[index].name,
				null
			);
		}
		// Supports filtering by xAxis
		else if (props.map_filter.mode === "byLayer") {
			emits("filterByLayer", props.map_config, props.series[index].name);
		}
		selectedIndex.value = index;
	} else {
		if (props.map_filter.mode === "byParam") {
			emits("clearByParamFilter", props.map_config);
		} else if (props.map_filter.mode === "byLayer") {
			emits("clearByLayerFilter", props.map_config);
		}
		selectedIndex.value = null;
	}
}
</script>

<template>
  <div
    :class="{
      maplegend: true,
      'maplegend-with-map': hasInlineMap,
    }"
  >
    <div
      v-if="hasInlineMap"
      class="maplegend-map"
    >
      <svg
        v-if="inlineMapPaths.length"
        viewBox="0 0 320 210"
        role="img"
        aria-label="雙北行政區數量分布圖"
      >
        <path
          v-for="item in inlineMapPaths"
          :key="item.title"
          :d="item.path"
          :fill="item.fill"
        >
          <title>{{ item.title }}</title>
        </path>
      </svg>
      <div
        v-else-if="geoJsonLoading"
        class="maplegend-map-loading"
      />
    </div>
    <div class="maplegend-legend">
      <button
        v-for="(item, index) in series"
        :key="item.name"
        :class="{
          'maplegend-legend-item': true,
          'maplegend-filter': map_filter_on && map_filter,
          'maplegend-selected':
            map_filter_on && selectedIndex === index,
        }"
        @click="handleDataSelection(index)"
      >
        <!-- Show different icons for different map types -->
        <div
          v-if="item.type !== 'symbol'"
          :style="{
            backgroundColor: `${chart_config.color[index]}`,
            height: item.type === 'line' ? '0.4rem' : '1rem',
            borderRadius: item.type === 'circle' ? '50%' : '2px',
          }"
        />
        <img
          v-else
          :src="returnIcon(item.icon)"
        >
        <!-- If there is a value attached, show the value -->
        <div v-if="item.value">
          <h5>{{ item.name }}</h5>
          <h6>{{ item.value }} {{ chart_config.unit }}</h6>
        </div>
        <div v-else>
          <h6>{{ item.name }}</h6>
        </div>
      </button>
    </div>
  </div>
</template>

<style scoped lang="scss">
* {
	margin: 0;
	padding: 0;
	font-family: "微軟正黑體", "Microsoft JhengHei", "Droid Sans", "Open Sans",
		"Helvetica";
	overflow: hidden;
}

button {
	border: none;
	background-color: transparent;
}
.maplegend {
	width: 100%;
	height: 100%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin-top: -var(--font-ms);
	overflow: visible;

	&-with-map {
		display: grid;
		grid-template-columns: minmax(150px, 1.1fr) minmax(130px, 0.9fr);
		column-gap: 0.75rem;
		align-items: center;
		justify-content: initial;
		margin-top: 0;
	}

	&-map {
		width: 100%;
		height: 100%;
		min-height: 170px;
		display: flex;
		align-items: center;
		justify-content: center;

		svg {
			width: 100%;
			height: 100%;
			max-height: 210px;
		}

		path {
			stroke: rgba(255, 255, 255, 0.8);
			stroke-width: 1;
			vector-effect: non-scaling-stroke;
		}

		&-loading {
			width: 2rem;
			height: 2rem;
			border: 3px solid var(--color-border);
			border-top-color: var(--color-highlight);
			border-radius: 50%;
			animation: spin 1s linear infinite;
		}
	}

	&-legend {
		width: 100%;
		display: grid;
		grid-template-columns: 1fr 1fr;
		column-gap: 0.5rem;
		row-gap: 0.5rem;
		overflow: visible;

		&-item {
			display: flex;
			align-items: center;
			padding: 5px 10px 5px 5px;
			border: 1px solid transparent;
			border-radius: 5px;
			transition: box-shadow 0.2s;
			cursor: auto;

			div:first-child,
			img {
				width: var(--font-ms);
				margin-right: 0.75rem;
			}

			h5 {
				color: var(--color-complement-text);
				font-size: 0.75rem;
				text-align: left;
			}

			h6 {
				color: var(--color-normal-text);
				font-size: var(--font-ms);
				font-weight: 400;
				text-align: left;
			}
		}
	}

	&-filter {
		border: 1px solid var(--color-border);
		cursor: pointer;

		&:hover {
			box-shadow: 0px 0px 5px black;
		}
	}

	&-selected {
		box-shadow: 0px 0px 5px black;
	}
}

.maplegend-with-map .maplegend-legend {
	grid-template-columns: 1fr;
	row-gap: 0.35rem;
}

.maplegend-with-map .maplegend-legend-item {
	padding: 3px 5px;
}

.maplegend-with-map .maplegend-legend-item h6 {
	font-size: 0.9rem;
}

@keyframes spin {
	to {
		transform: rotate(360deg);
	}
}
</style>
