# Feature vs rollup policy

**Author:** Farid
**Created:** 2026-03-04
**Last Updated:** 2026-03-04
**Status:** Draft

## Purpose
This policy defines how the project separates **feature-level tables** (atomic, map-ready records) from **rollup tables** (district-first aggregates). The goal is to support:
- a credible **district-first** MVP (fast, consistent dashboards), and
- future **map-first** analytics (drill-down and spatial exploration),
without forcing a redesign of the data model later.

---

## Core rules

### 1) Feature layers are retained (foundation is never discarded)
**Policy:** For every core domain dataset (permits, zoning, planning districts, ACS geographies if used), the project will retain a feature-level representation at the lowest practical grain.

**Why:** Feature layers preserve auditability and enable map-first consumers later. Rollups are not a substitute for feature-level data.

**What this means in practice**
- Feature-level tables remain available even after rollups exist.
- Rollups must not be the only representation of a domain.
- If a rollup is published, the upstream feature-level source must still exist (or a documented reason must exist for why it cannot).

---

### 2) Rollups are reproducible from feature layers
**Policy:** Every rollup table must be reproducible from the underlying feature layer(s) using documented transformations and definitions (metrics, grains, and policies). No rollup should depend on manual edits or “dashboard logic.”

**Why:** This ensures a single source of truth and prevents “the dashboard became the ETL.”

**Minimum requirements**
- Each rollup has a clear **grain statement** (“one row per …”).
- Each rollup references the feature table(s) it is derived from.
- Each rollup references the metric definitions used (e.g., permits per land sq. mile).
- If reconciliation is possible, rollups should reconcile to feature totals within documented constraints (e.g., excluding unassigned records).

---

## Definitions (project-specific)

### Feature table
A table where **one row represents one real-world object or event**, typically with geometry (or fields sufficient to derive geometry). Feature tables are map-ready and support drill-down.

### Rollup table
A table where **one row represents an aggregate** at a higher grain intended for dashboards and comparisons (district-first). Rollups should be stable, performant, and consistent across all charts.

---

## Concrete examples

### Example A: Permits (feature-level) vs District-month permits (rollup)

#### A1) Permit events — feature table
**Grain:** 1 row = 1 permit record (event-level).  
**Purpose:** drill-down, auditing, and future map-first exploration.  
**Typical columns (conceptual):**
- permit identifier (best available unique ID)
- canonical event date field (chosen for aggregation)
- permit category/type fields (used for grouping)
- location/geometry (point preferred; otherwise address + quality flags)
- assigned `district_id` (if district attribution is done upstream)
- quality flags (e.g., “unassigned to district”, geocode confidence)

**Example questions this supports**
- “Show me the actual permits in District 9 in January 2024.”
- “Where are permit hotspots within District 6?”

#### A2) District-month permits — rollup table
**Grain:** 1 row = 1 district × 1 month.  
**Purpose:** district-first time series, comparisons, and stable dashboard metrics.  
**Derived from:** permit events feature table + district spine (for land-only area).  
**Typical columns (conceptual):**
- `district_id`
- `month` (canonical month key)
- permit_count
- permits_per_land_sq_mile (uses land-only area denominator)
- (recommended) unassigned_permit_count / unassigned_share

**Example questions this supports**
- “Which districts have the highest permitting intensity?”
- “How did permitting activity change month-to-month in District 3?”

#### A3) Why this separation matters
- The feature table preserves detail and supports mapping.
- The rollup table prevents every dashboard chart from re-implementing aggregation rules differently.
- The rollup table should always be reproducible from the feature table using documented definitions.

---

### Example B: Zoning polygons (feature-level) vs District-year zoning composition (rollup)

#### B1) Zoning polygons — feature table
**Grain:** 1 row = 1 zoning polygon in 1 vintage layer.
**Purpose:** Spatial source of truth; supports map-first exploration and overlay QA.
**Typical columns (conceptual):**
- `objectid` + `vintage_year_key` (composite key)
- `code`, `long_code`, `zoning_category` (classification fields)
- geometry (polygon)
- assigned `district_id` (from polygon overlay with planning districts)
- derived `intersection_area_sqft` (area of polygon clipped to district)

**Example questions this supports**
- "Show me all RSA-5 zoning polygons in District 9 in 2023."
- "Which zoning polygons straddle district boundaries?"

#### B2) District-year zoning composition — rollup table (periodic snapshot fact table)
**Grain:** 1 row = 1 zoning code × 1 planning district × 1 vintage year.
**Purpose:** District-first regulatory change tracking; enables composition and churn metrics.
**Derived from:** zoning polygons feature table + district spine (for total district area).
**Typical columns (conceptual):**
- `district_id`
- `vintage_year_key`
- `zoning_code` (harmonized)
- `area_sqmi` (total intersection area for this code in this district-year)
- `pct_district` (share of district land area — semi-additive fact)

**Example questions this supports**
- "What share of District 5's land area was residential in 2022 vs 2023?"
- "Which districts saw the largest shift away from industrial zoning over 5 years?"

**Note on semi-additivity:** `pct_district` can be summed across zoning codes within a single district-year (sums to ~100%), but must not be summed across vintage years — that operation is meaningless.

---

## Additional guidance (recommended)

### Naming conventions
Naming conventions are defined in the decision log — see [D18](../decision_log.md) for the authoritative prefix scheme (`stg_*`, `int_*`, `fct_*`, `dim_*`, `bridge_*`, `geo_*`, `agg_*`).

### Auditability expectations
- Rollups should document reconciliation expectations:
  - what is included/excluded (e.g., permits with missing geometry)
  - any filtering rules (e.g., only permits with valid event_date)
- Known limitations must be captured in the limitations register and linked from rollup docs.

---

## Links
- Grain spec:
- Metric specs:
- Land-only area denominator policy:
- Limitations register:
- Decision log entries relevant to this policy:

---

## References

- **[D3]** OpenGeo. *Introduction to PostGIS*. See [Resources](../../.claude/resources.md).
- **[B1]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.). See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-04 | Initial draft      | Farid  |
| 2026-03-07 | Added Example B: zoning polygon feature table and district-year composition rollup (D7) | Farid |
| 2026-03-10 | Reconciliation: replaced naming conventions with pointer to D18 (feat_* prefix never used; D18 defines authoritative scheme) | Farid |
| 2026-03-10 | Reconciliation: aligned B1/B2 conceptual columns to SC2/SC6 — zoninggroup → zoning_category, vintage_year → vintage_year_key, area_sqft → area_sqmi, pct_district_area → pct_district | Farid |