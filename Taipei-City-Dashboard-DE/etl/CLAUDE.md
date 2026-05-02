# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Standalone ETL scripts for importing data into the `postgres-data` container used by the Taipei City Dashboard (`../Taipei-City-Dashboard`). Each pipeline lives in its own subdirectory containing an export script and an import shell script.

The main monorepo's DE utility library (`Taipei-City-Dashboard-DE/dags/utils/`) is a dependency — scripts use `sys.path.insert` to reference a local `dags/` directory that mirrors or symlinks that library.

---

## Environment Setup

```bash
python -m venv .venv
.venv/bin/pip install -r requirements.txt
```

---

## Running a Pipeline

Each subdirectory has a self-contained shell script that runs the full extract → transform → load cycle:

```bash
# From repo root
bash water_level/import_water_level.sh
```

The script:
1. Runs the Python export script via `.venv/bin/python` to fetch an API and produce a CSV
2. `docker cp`s the CSV into the `postgres-data` container
3. Runs `psql` inside the container to `TRUNCATE` + `COPY` into the target table

---

## Architecture Pattern

Each pipeline follows the same three-step shape:

| Step | Tool | Notes |
|------|------|-------|
| Extract | `requests` or file download | Raw API response → `pd.DataFrame` |
| Transform | `pandas` + `dags/utils/` helpers | Column renames, time normalization |
| Load | `docker exec psql … COPY … CSV HEADER` | Always `TRUNCATE` before import (full-refresh) |

**Time normalization** uses `utils.transform_time.convert_str_to_time_format` from the shared `dags/utils/` library — ensure that path is resolvable before running scripts.

**Timezone handling**: The Go backend reads `timestamptz` from PostgreSQL and appends `+08:00` directly without converting to Asia/Taipei. To compensate, export scripts must write **naive (timezone-free) timestamps in local time** to CSV — postgres stores them as-is in UTC, and the backend label then matches the actual Taipei wall-clock time. After `convert_str_to_time_format`, strip timezone info with:
```python
data["data_time"] = pd.to_datetime(data["data_time"]).apply(lambda x: x.replace(tzinfo=None))
```

**Target database**: `postgres-data` container, database `dashboard`. The `postgres-manager` database (user/config) is not touched here.

---

## Adding a New Pipeline

1. Create `<topic>/` directory with `export_<topic>_csv.py` and `import_<topic>.sh`
2. In the export script, add `sys.path.insert(0, str(Path(__file__).parent / "dags"))` to reach shared utils
3. The import shell script must `cd` to its own directory so relative `.venv/bin/python` and `docker cp` paths resolve correctly
4. Use `TRUNCATE` + `COPY … CSV HEADER` in psql; never use `\copy`
5. **Component registration** — the import script must also register the component in `dashboardmanager` (the `postgres-manager` container). Use `ON CONFLICT (index) DO NOTHING` so re-runs are idempotent:

```bash
docker exec postgres-manager psql -U postgres -d dashboardmanager -c "
INSERT INTO components (index, name)
VALUES ('<index>', '<顯示名稱>')
ON CONFLICT (index) DO NOTHING;

INSERT INTO query_charts (
  index, query_type, query_chart,
  time_from, time_to, update_freq, update_freq_unit,
  source, short_desc, links, contributors,
  created_at, updated_at, city
) VALUES (
  '<index>', '<two_d|three_d|percent|time>', '<SELECT SQL>',
  'static', 'static', 10, 'minute',
  '<資料來源>', '<簡述>', '{}', '{}',
  NOW(), NOW(), '<taipei|metrotaipei>'
) ON CONFLICT (index) DO NOTHING;
"
```

`query_type` 與必要欄位對應：
- `two_d` → `x_axis`, `data`
- `three_d` / `percent` → `x_axis`, `y_axis`, `data`
- `time` → `x_axis`（timestamptz）, `y_axis`, `data`

After registration, verify with:
```bash
docker exec postgres-manager psql -U postgres -d dashboardmanager -c "SELECT id, index, name FROM components WHERE index = '<index>';"
```
