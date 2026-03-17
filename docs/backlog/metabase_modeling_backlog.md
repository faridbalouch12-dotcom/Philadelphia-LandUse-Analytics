# Metabase Modeling Backlog

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

Issues and usability gaps surfaced while working in Metabase during the district slice. These are things that look fine in dbt but only become apparent in the BI layer.

---

## District slice — 2026-03-15

### MB-1 — `polygon_geometry` renders as WKB hex
**Severity:** Low (expected behavior, not a bug)
**Observed:** `polygon_geometry` column displays as a long hex string in the SQL editor.
**Why:** Metabase's SQL editor has no geometry renderer. WKB (Well-Known Binary) is PostGIS's binary storage format, serialized to hex for display.
**Fix path:** Upload a GeoJSON export of `dim_district` as a custom map (Admin → Settings → Maps) to enable choropleth visualization. Deferred to visualization phase.

---

### MB-2 — `date_key` displays with thousands separators
**Severity:** Low (cosmetic only)
**Observed:** `date_key = 20200101` displays as `20,200,101` in Metabase.
**Why:** Metabase formats all integer columns with thousands separators by default.
**Fix path:** Use `date_actual` for any display-facing questions. `date_key` is a join column — not intended for display. No upstream model change needed.

---

### MB-3 — `raw` and `staging` schemas potentially visible in Metabase
**Severity:** Medium (analyst-facing noise, potential for confusion)
**Observed:** After connecting the warehouse, Metabase syncs all schemas the connected user has access to. `raw` and `staging` may appear alongside `marts`.
**Why:** The Metabase user (`philly`) has access to all schemas.
**Fix path:** Restrict the Metabase Postgres user to `marts` schema only via a dedicated role, or document that internal schemas are intentionally exposed for now (MVP acceptable). Deferred.

---

## No blocking issues found

All district-slice tables (`dim_district`, `dim_date`) are correctly named, typed, and queryable. The 18-district sanity question returns expected rows and totals. No upstream model changes required from this review.

---

## Pipeline / infrastructure — 2026-03-15 (surfaced during Task 34.1 clean-start test)

### INF-1 — Ingest script fails on re-run due to missing CASCADE ✓ RESOLVED
**Severity:** High (blocks re-ingestion whenever staging views exist)
**Observed:** `make ingest-districts` fails with `cannot drop table raw.planning_districts because other objects depend on it` when `staging.stg_planning_districts` view exists.
**Root cause:** `to_postgis(if_exists="replace")` issues a bare `DROP TABLE` without CASCADE. Postgres refuses because the staging view depends on the raw table.
**Fix:** Added explicit `DROP TABLE IF EXISTS raw.planning_districts CASCADE` before `to_postgis()` call in `src/philly_dw/ingest/planning_districts.py`. Verified working 2026-03-15.

### INF-2 — `make down` does not wipe volumes ✓ DOCUMENTED
**Severity:** Low (by design, but runbook was misleading)
**Observed:** After `make down && make up`, `postgres_data` volume persisted — not a true clean start.
**Root cause:** `make down` calls `docker compose down` (stops containers, preserves volumes). This is correct behavior for day-to-day use.
**Fix:** Updated `docs/runbooks/district_slice_rebuild.md` to use `make reset-nuclear` for true zero-state rebuilds. `reset-nuclear` uses `docker compose down -v` which removes volumes.
