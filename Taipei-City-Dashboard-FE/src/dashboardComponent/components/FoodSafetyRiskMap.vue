<script setup>
import { computed, ref, watch } from "vue";

const props = defineProps([
	"chart_config",
	"activeChart",
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
]);

const geoJson = ref(null);
const geoJsonLoading = ref(false);
const hoveredDistrict = ref(null);
const selectedDistrict = ref(null);

const colors = computed(() =>
	props.chart_config.color?.length
		? props.chart_config.color
		: ["#E8F6EF", "#F5D76E", "#F49F36", "#E06666", "#8B1E3F"]
);

const riskData = computed(() => {
	const rows = props.series?.[0]?.data || [];
	return rows
		.map((item) => ({
			name: item.x,
			score: Number(item.y) || 0,
		}))
		.sort((a, b) => b.score - a.score);
});

const riskLookup = computed(() =>
	riskData.value.reduce((output, item, index) => {
		output[item.name] = {
			...item,
			rank: index + 1,
		};
		return output;
	}, {})
);

const highestScore = computed(() =>
	Math.max(...riskData.value.map((item) => item.score), 0)
);

watch(
	() => props.activeChart,
	async (activeChart) => {
		if (activeChart !== "FoodSafetyRiskMap" || geoJson.value) return;

		geoJsonLoading.value = true;
		try {
			const response = await fetch("/mapData/metrotaipei_town.geojson");
			if (!response.ok) {
				throw new Error("Failed to load metrotaipei_town.geojson");
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

function getDistrictName(feature) {
	return feature.properties?.district || feature.properties?.TNAME || "";
}

function getCityName(feature) {
	return feature.properties?.city || feature.properties?.PNAME || "";
}

function getRiskLevel(score) {
	if (score >= 80) return 4;
	if (score >= 60) return 3;
	if (score >= 40) return 2;
	if (score >= 20) return 1;
	return 0;
}

function getRiskColor(score) {
	return colors.value[Math.min(getRiskLevel(score), colors.value.length - 1)];
}

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

	(geoJson.value?.features || []).forEach((feature) => {
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

	const width = 360;
	const height = 250;
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

const mapPaths = computed(() =>
	(geoJson.value?.features || []).map((feature) => {
		const district = getDistrictName(feature);
		const risk = riskLookup.value[district] || { score: 0, rank: null };
		const opacity = highestScore.value
			? Math.max(0.2, risk.score / highestScore.value)
			: 0.2;

		return {
			district,
			city: getCityName(feature),
			path: geometryToPath(feature.geometry),
			score: risk.score,
			rank: risk.rank,
			fill: getRiskColor(risk.score),
			opacity,
		};
	})
);

function formatScore(score) {
	return Number(score).toFixed(1);
}

function selectDistrict(district) {
	if (!props.map_filter || !props.map_filter_on) {
		selectedDistrict.value =
			selectedDistrict.value === district ? null : district;
		return;
	}

	if (selectedDistrict.value !== district) {
		if (props.map_filter.mode === "byParam") {
			emits("filterByParam", props.map_filter, props.map_config, district, null);
		} else if (props.map_filter.mode === "byLayer") {
			emits("filterByLayer", props.map_config, district);
		}
		selectedDistrict.value = district;
	} else {
		if (props.map_filter.mode === "byParam") {
			emits("clearByParamFilter", props.map_config);
		} else if (props.map_filter.mode === "byLayer") {
			emits("clearByLayerFilter", props.map_config);
		}
		selectedDistrict.value = null;
	}
}
</script>

<template>
  <div
    v-if="activeChart === 'FoodSafetyRiskMap'"
    class="food-risk-map"
  >
    <div class="food-risk-map-map">
      <svg
        v-if="mapPaths.length"
        viewBox="0 0 360 250"
        role="img"
        aria-label="雙北各區食安風險排行地圖"
      >
        <path
          v-for="item in mapPaths"
          :key="`${item.city}-${item.district}`"
          :class="{
            'food-risk-map-district': true,
            'food-risk-map-district-active':
              hoveredDistrict === item.district ||
              selectedDistrict === item.district,
          }"
          :d="item.path"
          :fill="item.fill"
          :fill-opacity="item.opacity"
          @mouseenter="hoveredDistrict = item.district"
          @mouseleave="hoveredDistrict = null"
          @click="selectDistrict(item.district)"
        >
          <title>
            {{ item.city }}{{ item.district }}：第 {{ item.rank || "-" }} 名，風險 {{ formatScore(item.score) }} {{ chart_config.unit }}
          </title>
        </path>
      </svg>
      <div
        v-else-if="geoJsonLoading"
        class="food-risk-map-loading"
      />
    </div>
    <div class="food-risk-map-ranking">
      <button
        v-for="(item, index) in riskData"
        :key="item.name"
        :class="{
          'food-risk-map-ranking-item': true,
          'food-risk-map-ranking-item-active':
            hoveredDistrict === item.name ||
            selectedDistrict === item.name,
        }"
        @mouseenter="hoveredDistrict = item.name"
        @mouseleave="hoveredDistrict = null"
        @click="selectDistrict(item.name)"
      >
        <span>{{ index + 1 }}</span>
        <p>{{ item.name }}</p>
        <strong>{{ formatScore(item.score) }}</strong>
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
	box-sizing: border-box;
}

button {
	border: 0;
	background: transparent;
	color: inherit;
}

.food-risk-map {
	width: 100%;
	height: 100%;
	display: grid;
	grid-template-columns: minmax(180px, 1.25fr) minmax(150px, 0.75fr);
	gap: 0.75rem;
	align-items: stretch;
	overflow: hidden;

	&-map {
		min-height: 210px;
		display: flex;
		align-items: center;
		justify-content: center;
		overflow: hidden;

		svg {
			width: 100%;
			height: 100%;
			max-height: 250px;
		}
	}

	&-district {
		stroke: rgba(255, 255, 255, 0.85);
		stroke-width: 1;
		vector-effect: non-scaling-stroke;
		cursor: pointer;
		transition: fill-opacity 0.15s, stroke-width 0.15s;

		&-active {
			fill-opacity: 1;
			stroke: var(--color-highlight);
			stroke-width: 2;
		}
	}

	&-ranking {
		display: grid;
		grid-auto-rows: minmax(28px, auto);
		align-content: start;
		gap: 0.35rem;
		overflow: auto;
		padding-right: 0.15rem;

		&-item {
			width: 100%;
			min-height: 28px;
			display: grid;
			grid-template-columns: 24px minmax(0, 1fr) 52px;
			align-items: center;
			gap: 0.45rem;
			border: 1px solid var(--color-border);
			border-radius: 5px;
			padding: 0.25rem 0.35rem;
			cursor: pointer;
			text-align: left;

			span {
				width: 22px;
				height: 22px;
				display: inline-flex;
				align-items: center;
				justify-content: center;
				border-radius: 50%;
				background-color: var(--color-component-background);
				color: var(--color-complement-text);
				font-size: 0.75rem;
			}

			p {
				min-width: 0;
				color: var(--color-normal-text);
				font-size: 0.9rem;
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
			}

			strong {
				color: var(--color-normal-text);
				font-size: 0.9rem;
				text-align: right;
			}

			&-active {
				border-color: var(--color-highlight);
				box-shadow: 0 0 0 1px var(--color-highlight);
			}
		}
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

@media (max-width: 700px) {
	.food-risk-map {
		grid-template-columns: 1fr;
		grid-template-rows: minmax(190px, 1fr) minmax(120px, 0.85fr);
	}
}

@keyframes spin {
	to {
		transform: rotate(360deg);
	}
}
</style>
