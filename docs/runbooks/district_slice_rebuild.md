# Runbook: District slice clean rebuild

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

---

## Purpose

Proves the district slice is reproducible from a clean local state. Run this after any significant change to the district pipeline (ingestion, staging, or marts) to confirm the full path still works end to end.

---

## Prerequisites

- Docker installed and running
- `.env.example` values confirmed (or `.env` overrides in place)
- dbt virtual environment activated

---

## Step 1 — Wipe and restart the stack

```bash
make reset-nuclear
```

`make reset-nuclear` runs `docker compose down -v` (removes containers **and** volumes) then brings the stack back up. This is the only command that guarantees a true zero state — `make down` stops containers but preserves the `postgres_data` volume.

> **Note:** `reset-nuclear` also runs `ingest-all` and `dbt run` internally. If you want to run those steps manually (e.g., to test each step independently), use `docker compose down -v && docker compose up -d --wait` instead and proceed through the steps below.

Confirm Postgres is healthy:

```bash
docker compose -f docker/docker-compose.yml ps
```

Expected: `postgres_philly_dw` status = `healthy`.

---

## Step 2 — Run the planning districts ingestion

```bash
make ingest-districts
```

Expected: planning districts raw table populated in the `raw` schema.

Verify:

```bash
docker compose -f docker/docker-compose.yml exec postgres_philly_dw \
  psql -U philly -d philly_dw -c "SELECT count(*) FROM raw.planning_districts;"
```

Expected: 18 rows.

---

## Step 3 — Run dbt

```bash
cd dbt/philly_dw
dbt run --select stg_planning_districts dim_district dim_date
dbt test --select stg_planning_districts dim_district dim_date
```

Expected:
- 3 models pass
- All tests pass (6/6 for `dim_district`, including `assert_18_districts`)

---

## Step 4 — Verify in Metabase

1. Open `http://localhost:3000`
2. SQL Editor → run:

```sql
SELECT count(*) FROM marts.dim_district;
```

Expected: 18

```sql
SELECT round(sum(land_area_sqmi)) FROM marts.dim_district;
```

Expected: 142

---

## Done

If all four steps pass, the district slice is clean-start reproducible.

---

## Troubleshooting

**`make up` fails on init scripts**
Check `docker/postgres/init/` scripts for syntax errors. Run `docker compose logs postgres_philly_dw` for details.

**dbt run fails with "relation does not exist"**
Ingestion didn't run or ran against wrong schema. Confirm `raw.planning_districts` exists before running dbt.

**Metabase can't see `marts` schema**
Confirm dbt run completed without errors. Check `profiles.yml` for correct schema target.
