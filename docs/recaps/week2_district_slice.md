# Recap: Week 2 — District slice

**Author:** Farid
**Created:** 2026-03-15
**Status:** Active

---

## What was built

The full district vertical slice from raw ingest to Metabase visibility:

| Layer | Artifact | Status |
|-------|----------|--------|
| Raw | `raw.planning_districts` (18 rows, PostGIS geometry) | ✓ |
| Staging | `stg_planning_districts` (renamed columns, EPSG:2272 geometry for area calc) | ✓ |
| Marts | `dim_district` (18 rows, EPSG:4326 geometry co-located, `land_area_sqmi`) | ✓ |
| Marts | `dim_date` (2020–2030 date spine, YYYYMMDD surrogate key) | ✓ |
| Tests | 6/6 dbt tests passing, `assert_18_districts` singular test | ✓ |
| Docs | dbt docs with grain, D20 rationale, polygon_geometry CRS notes | ✓ |
| BI | Metabase connected, district sanity question (18 rows, 142 sqmi) | ✓ |

---

## Key decisions made

**D20 — Geometry co-located in `dim_district`**
Dropped the originally planned `geo_district_boundaries` table. For 18 static rows, a separate geometry table adds join overhead with no analytical benefit. Spatial joins (point-in-polygon for permits, polygon intersection for ACS tracts) happen in the `int_*` layer — by the time anything joins `dim_district` in marts, it's an integer FK join. Analytics consumers should use explicit column selection to exclude `polygon_geometry` in non-spatial queries.

**Staging → marts direct pull**
`dim_district` pulls directly from `stg_planning_districts` with no intermediate model. The `int_*` layer is for grain-changing transforms and spatial joins — not for simple pass-throughs. Adding `int_planning_districts` would be ceremony.

**CRS convention**
Staging stores geometry in EPSG:2272 (PA State Plane) for accurate area calculation. Marts transforms to EPSG:4326 (WGS 84) via `ST_Transform` for GeoJSON export and web mapping compatibility.

---

## What is still brittle

**Metabase custom map not configured**
`polygon_geometry` renders as WKB hex in the Metabase SQL editor. Choropleth visualization requires uploading a GeoJSON export as a custom map. Deferred to the visualization phase.

**Schema visibility not scoped**
The Metabase user has access to `raw`, `staging`, and `marts`. For a single-user MVP this is acceptable, but should be addressed before any analyst-facing use. Fix: create a dedicated read-only role scoped to `marts` only.

**Clean-start not yet formally verified**
The stack has been running continuously. The rebuild runbook exists but a full clean-start test is pending confirmation.

---

## Patterns to reuse for permits, zoning, and ACS

| Pattern | How to reuse |
|---------|-------------|
| Staging column renaming + CRS transform | Same approach for any geometry-bearing source |
| Direct staging → marts pull for simple dimensions | Skip `int_*` unless grain changes or spatial join needed |
| dbt tests: not_null + unique on surrogate key | Apply to every dimension |
| Singular test for cardinality | `assert_N_rows.sql` pattern — adapt count for each table |
| Metabase sanity question (group by dimension, check sum) | Build an equivalent for each slice after first `dbt run` |
| QA checklist | Copy `district_slice_qa.md` pattern, adapt baseline values |

---

## What Week 3 (permits slice) should start with

- Read the permits blocker list (`docs/backlog/permits_blockers.md`) before writing any code
- The permits ingestion will be meaningfully more complex than districts: larger dataset, geocoding uncertainty, category normalization
- District assignment for permits (point-in-polygon) happens in `int_*` — this is where the geometry in `dim_district` finally gets used
