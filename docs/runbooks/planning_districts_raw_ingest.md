# Planning Districts — Raw Ingest Runbook

**Author:** Farid
**Created:** 2026-03-14
**Last Updated:** 2026-03-14
**Status:** Draft

---

## Purpose

Run the planning districts extraction pipeline: pull all 18 districts from the ArcGIS Hub API and load them into the `raw.planning_districts` table in PostGIS.

---

## Prerequisites

1. **Postgres container is up and healthy:** `make up` or verify with `docker compose -f docker/docker-compose.yml ps`
2. **`.env` file exists** at project root with valid database credentials (`POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_DB`)
3. **Virtual environment activated** with dependencies installed (`geopandas`, `sqlalchemy`, `python-dotenv`)

---

## Command

```bash
make ingest-districts
```

Or directly:

```bash
cd src/
python -m philly_dw.ingest.planning_districts
```

---

## What it does

1. Pulls GeoJSON from the ArcGIS Hub download endpoint (all fields, EPSG:4326)
2. Loads the full response into `raw.planning_districts` using `to_postgis()` with `if_exists="replace"`
3. Writes a log row to `raw.ingestion_logs` with schema name, table name, source URL, row count, and timestamp

---

## What "good" looks like

| Check | Expected |
|-------|----------|
| Console output | `PostGIS engine created successfully` → `Created Planning Districts Table!` → `Logs entry added.` |
| `SELECT COUNT(*) FROM raw.planning_districts` | 18 |
| `SELECT * FROM raw.ingestion_logs WHERE table_name = 'planning_districts'` | One row per run with `row_count = 18` and a recent `loaded_at` timestamp |
| Columns in `raw.planning_districts` | `objectid`, `dist_name`, `abbrev`, `Shape__Area`, `Shape__Length`, `geometry` |

---

## Re-extraction

Running the command again is safe — `if_exists="replace"` drops and recreates the table. A new log row is appended to `raw.ingestion_logs` each run.

---

## Common failures

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `Connection refused` or engine creation error | Postgres container not running | `make up` and wait for healthcheck |
| `ModuleNotFoundError: philly_dw` | Not running from `src/` or venv not activated | Activate venv; run from `src/` directory |
| `UndefinedTable: relation "raw.ingestion_logs" does not exist` | Volume was reset without reinitializing init scripts | Run `make reset-nuclear` to rebuild from scratch, or create the table manually from `docker/postgres/init/02_tables.sql` |
| `requests.exceptions.ConnectionError` | No internet or API endpoint down | Check connectivity; verify URL in browser |

---

## Links

- **Extract plan:** `docs/runbooks/planning_districts_extract_plan.md`
- **Extractor code:** `src/philly_dw/ingest/planning_districts.py`
- **Log table DDL:** `docker/postgres/init/02_tables.sql`
- **Makefile target:** `ingest-districts`
