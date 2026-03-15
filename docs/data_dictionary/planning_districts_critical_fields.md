# Critical Fields Dictionary — Planning Districts (S1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header

- **Dataset name:** Planning Districts
- **Dataset ID:** S1 (district spine)
- **Files reviewed:** `Planning_Districts.geojson`, `fields (1).json`
- **Reviewer:** Farid
- **Date:** 2026-03-05
- **MVP role:** District spine for rollups + denominator support (land-only area derived from geometry)
- **Locked scope for analysis:** Static boundary set (18 districts); no time window

---

## Field Dictionary

**Risk level scale:** High = metric breaks or joins fail if this field is missing/wrong; Med = analysis degrades but is still usable; Low = not used in MVP metrics.

> **Note on schema vs. extract:** Fields marked `[schema only]` appear in `fields (1).json` but are NOT present in the local GeoJSON extract. Fields marked `[extract only]` appear in the GeoJSON but not in the official schema. Strategy for which fields are actually available from the authoritative API source must be confirmed in Month 2.

| Field name | Source | Meaning | Required? | Expected type | Risk level | Common null/invalid patterns | Notes |
|---|---|---|---|---|---|---|---|
| `DIST_NUM` | schema only | District identifier (natural key per official schema) | Yes (if available) | string | High | Should be non-null, unique; not present in GeoJSON extract | Preferred natural key; use as `district_id` in `dim_district`. Confirm availability from authoritative API. If absent, fall back to `objectid`. |
| `DIST_NAME` | both | Full district name | Yes | string | High | Should be non-null; confirmed as `dist_name` in GeoJSON | Display label in dashboards and reports; do not use as join key. |
| `LABEL` | schema only | District label (likely combines number + name or abbreviation) | No (recommended) | string | Med | Not present in GeoJSON; may be equivalent to `abbrev` | Use if available and consistent; otherwise derive from `DIST_NUM` + `DIST_NAME`. |
| `abbrev` | extract only | Short abbreviation (e.g., "RW", "NDEL") | No (recommended) | string | Med | Non-null, unique in extract; not in official schema | Likely equivalent to `LABEL` or a short form of `DIST_NUM`; useful for chart labels and map tooltips. Confirm against authoritative schema. |
| `geometry` | both | District polygon geometry | Yes | polygon/multipolygon | High | Invalid geometry; missing geometry | Required for spatial joins and mapping; required for land-only area derivation; validate geometry validity in ingestion. |
| `Shape__Area` | extract only | Area in projected CRS units | No | numeric | Med | CRS unit unknown; may differ from true sq mi | Do NOT use as denominator until CRS and unit confirmed; derive `land_area_sqmi` from geometry in a standardized CRS instead. |
| `AREA` | schema only | Publisher-provided area value | No | numeric | Med | Unit unknown; may mismatch derived area | Same caution as `Shape__Area`; do not use as denominator without validation. |
| `SEQUENCE` | schema only | Ordering / sequence field | No | string | Low | Not present in GeoJSON extract | Optional for UI sorting only; low priority. |
| `OBJECTID` | schema only | Source object identifier (schema) | No (recommended) | numeric | Med | May differ from `objectid` in extract | Debugging only; treat as technical row key for staging. |
| `OBJECTID_1` | schema only | Secondary object identifier | No | numeric | Low | Not present in GeoJSON extract; may be an artifact | Debugging only. |
| `objectid` | extract only | Row-level unique identifier (in GeoJSON) | No (recommended) | numeric | Med | Non-null 18/18, unique in extract | Interim natural key for MVP if `DIST_NUM` unavailable; do not treat as stable across republishes unless confirmed. |
| `Shape__Length` | extract only | Perimeter length in projected CRS units | No | numeric | Low | CRS unit unknown | Not needed for MVP; may be used for geometry QA. |

---

## Required Fields Summary (MVP)

- **Key / ID fields:**
  - `objectid` (confirmed natural key — `DIST_NUM` absent from API; renamed to `district_id` in staging)
- **Display / label fields:**
  - `dist_name` (full name, required — renamed to `district_name` in staging)
  - `abbrev` (short label, required — renamed to `district_abbrev` in staging)
- **Geometry:**
  - `geometry` (polygon, EPSG:4326 at source; reprojected to EPSG:2272 in staging)
- **Derived field:**
  - `land_area_sqmi` — computed in staging via `ST_Area(ST_Transform(geometry, 2272)) / 27878400`

---

## Implementation Notes (Month 2 — resolved)

- ~~Compute and store `land_area_sqmi`~~ — **Done:** derived in `stg_planning_districts` via EPSG:2272 reprojection.
- ~~Reconcile `abbrev` vs. `LABEL`~~ — **Done:** `abbrev` used as canonical short label (`district_abbrev`). `LABEL` not present in API response.
- ~~Validate `DIST_NUM`~~ — **Done:** `DIST_NUM` confirmed absent from API. `objectid` adopted as `district_id`.
- If district boundaries change, version the district dimension (SCD2) and backfill rollups by boundary version. *(Still applies — deferred.)*

---

## Links

- **Source catalog entry:** [`docs/source_catalog/planning_districts.md`](../source_catalog/planning_districts.md)
- **Feasibility checklist:** [`docs/feasibility/planning_districts_feasibility.md`](../feasibility/planning_districts_feasibility.md)
- **Land-area denominator policy:** [`docs/policies/land_area_denominator_policy.md`](../policies/land_area_denominator_policy.md)
- **Limitations register entries:**
  - L1 — District boundary version treated as static
  - L2 — Near-boundary ambiguity for joining datasets
  - L11 — Land-only area derivation required before density metrics

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-05 | Added Risk level column, Source column, Links, Change log; clarified schema vs. extract field availability | Farid |
