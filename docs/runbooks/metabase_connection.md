# Runbook: Metabase connection

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

---

## Prerequisites

- Docker stack running (`make up`)
- Postgres healthcheck passing (`docker compose ps` shows `postgres_philly_dw` as healthy)
- dbt models built (`dbt run` complete — target tables must exist in `marts` schema)
- Metabase accessible at `http://localhost:3000`

---

## Add the warehouse database

1. Log in to Metabase at `http://localhost:3000`
2. Go to **Admin → Databases → Add database**
3. Fill in the connection fields:

| Field | Value |
|-------|-------|
| Database type | PostgreSQL |
| Display name | `philly_dw` |
| Host | `postgres_philly_dw` |
| Port | `5432` |
| Database name | `philly_dw` |
| Username | `philly` |
| Password | `changeme` |

> **Host must be `postgres_philly_dw`** — the Docker Compose service name, not `localhost`.
> From inside the Metabase container, `localhost` resolves to Metabase itself, not Postgres.

4. Click **Save** — Metabase will test the connection and sync table metadata.

---

## Verify connectivity

Run a sanity query in **SQL Editor → New question → Native query**:

```sql
SELECT * FROM marts.dim_district LIMIT 5;
```

Expected: 5 rows with `district_id`, `district_name`, `district_abbrev`, `polygon_geometry`, `land_area_sqmi`.

```sql
SELECT * FROM marts.dim_date LIMIT 5;
```

Expected: 5 rows with `date_key`, `date_actual`, and calendar attributes.

---

## Known display quirks

**`polygon_geometry` renders as WKB hex**
Expected. Metabase's SQL editor has no geometry renderer. Raw WKB hex is the serialized binary representation of the polygon. To visualize district boundaries, use the custom map upload (Admin → Settings → Maps) with a GeoJSON export — deferred to the visualization phase.

**`date_key` displays with commas (e.g., `20,200,101`)**
Expected. Metabase formats integers with thousands separators by default. The value is correct (`20200101` = January 1, 2020). Use `date_actual` for display in questions; `date_key` is for joins only.

---

## Troubleshooting

**"Connection refused" or "could not connect to server"**
- Confirm Postgres container is healthy: `docker compose ps`
- Confirm host is set to `postgres_philly_dw`, not `localhost`

**Tables not visible after connecting**
- Trigger a manual sync: Admin → Databases → `philly_dw` → Sync database schema now
- Confirm dbt models have been run: `dbt run` from `dbt/philly_dw/`

**`marts` schema not visible**
- dbt materializes to the schema defined in `profiles.yml`. Confirm `schema: marts` is set and `dbt run` completed without errors.
