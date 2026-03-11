# Local Reset Runbook

**Purpose:** Recover a broken local warehouse by dropping and rebuilding the minimum set of schemas needed to fix the problem.
**Audience:** Developer (solo project).
**Last updated:** 2026-03-10

---

## Quick reference — pick the right command

| Failure mode | Command |
|---|---|
| `agg_district_acs_attributes_hist` output is wrong (bad bins, tract_count mismatch, missing attributes) | `make reset-analytics` |
| dbt/Jinja model broke staging, intermediate, marts, or analytics output | `make reset-transforms` |
| Upstream source changed and raw data is stale (e.g., API schema change, Hansen → Eclipse transition) | `make reset-data` |
| Infrastructure broken — Postgres volume corrupt, init SQL needs to re-run, PostGIS state wrong | `make reset-nuclear` |

**Rule of thumb:** Use the smallest reset that fixes the problem. Each level drops more data and takes longer to recover.

---

## Prerequisites

- Docker Desktop is running
- Virtual environment is active (`source .venv/bin/activate`)
- For levels 1–3: Postgres service must be running (`make up` first if needed)
- For level 4 (nuclear): service does not need to be running — the command stops it

---

## Reset levels

### Level 1 — `make reset-analytics`

**What it fixes:** Wrong output in `agg_district_acs_attributes_hist`. Raw, staging, intermediate, and marts schemas are intact and trusted.

**What gets dropped:** `analytics` schema only.

**Steps:**
1. Drops and recreates the `analytics` schema (all agg tables gone)
2. Re-runs `philly_dw.agg_district_acs_attributes_hist` (Python) to rebuild the histogram table from `fct_tract_acs` and `bridge_tract_district_overlap`

**Verify:** Query `analytics.agg_district_acs_attributes_hist` and confirm `tract_count` sums match the tract count in `marts.fct_tract_acs` for the same district and period.

---

### Level 2 — `make reset-transforms`

**What it fixes:** A broken dbt model corrupted intermediate, marts, or analytics output. Raw data in the `raw` schema is confirmed good.

**What gets dropped:** `intermediate`, `marts`, `analytics` schemas.

**Steps:**
1. Drops and recreates `intermediate`, `marts`, `analytics` schemas
2. Runs `dbt run` — rebuilds all dbt models from staging through marts in DAG order (staging is rebuilt from raw as part of the run; this is idempotent)
3. Re-runs `philly_dw.agg_district_acs_attributes_hist` (Python) to rebuild analytics

**Note:** `dbt run` rebuilds staging too — this is expected and safe. Staging reads from raw (intact), so the rebuild is idempotent.

**Verify:** Run `dbt test` after completion to confirm grain constraints and uniqueness checks pass.

---

### Level 3 — `make reset-data`

**What it fixes:** Raw data is stale because the upstream source changed (API schema change, new source system, expanded date range). The fix is in the data, not the code.

**What gets dropped:** All five schemas (`analytics`, `marts`, `intermediate`, `staging`, `raw`).

**Steps:**
1. Drops and recreates all five schemas
2. Re-runs all four ingestion scripts (`ingest-all`) to re-fetch from upstream APIs
3. Runs `dbt run` to rebuild staging through marts
4. Re-runs `philly_dw.agg_district_acs_attributes_hist` (Python) to rebuild analytics

**Warning:** Re-ingestion makes live API calls. If the upstream source is temporarily unavailable, ingestion will fail — wait and retry.

**Note:** This replaces the old `rebuild` target, which did not drop schemas before re-ingesting.

---

### Level 4 — `make reset-nuclear`

**What it fixes:** Infrastructure-level failures — Postgres volume corruption, `01_schemas.sql` needs to re-run (e.g., after adding a new schema or changing extension config), PostGIS extension state is wrong. SQL-level `DROP SCHEMA` cannot fix these.

**What gets destroyed:** The entire `postgres_data` Docker volume (all data, all schemas, all extensions).

**Steps:**
1. `docker compose down -v` — stops all services and destroys the named volume (`postgres_data`)
2. `docker compose up -d --wait` — recreates the volume, starts services, runs `01_schemas.sql` automatically (creates all schemas + PostGIS extension), waits for healthchecks to pass
3. Re-runs all four ingestion scripts (`ingest-all`)
4. Runs `dbt run`
5. Re-runs `philly_dw.agg_district_acs_attributes_hist` (Python)

**Warning:** This is irreversible. All local data is gone. Re-ingestion makes live API calls and may take several minutes depending on dataset sizes.

**Verify after up:** Connect to Postgres and confirm schemas and PostGIS exist before ingestion starts (see [stack smoke test runbook](./stack_smoke_test.md)).

---

## What is NOT reset

The following are never touched by any reset command:

| What | Why |
|---|---|
| `.env` / credentials | Not stored in DB |
| dbt model files (`transform/`) | Code, not data |
| Python ingestion scripts (`src/ingest/`) | Code, not data |
| `metabase_data` Docker volume | Metabase internal DB — dashboard config lives here |
| Git history | Unrelated to DB state |

To reset Metabase dashboards, manually delete the `metabase_data` volume separately.

---

## Links

- Task runner: [`Makefile`](../../Makefile)
- Schema definitions: [`docker/postgres/init/01_schemas.sql`](../../docker/postgres/init/01_schemas.sql)
- Stack smoke test: [`docs/runbooks/stack_smoke_test.md`](./stack_smoke_test.md)
- Write access by layer policy: [`docs/policies/write_access_by_layer.md`](../policies/write_access_by_layer.md)
