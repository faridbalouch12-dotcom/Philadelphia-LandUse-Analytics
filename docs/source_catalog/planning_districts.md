# Source Catalog — Planning Districts (S1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Overview

- **Dataset purpose:** Polygon boundary layer defining Philadelphia's 18 planning districts — the canonical geographic reporting unit for district-first analytics.
- **What one row/feature represents:** One planning district polygon.
- **How this dataset is used in the project:**
  - District dimension (`dim_district`) — canonical keys and labels for all rollups
  - Spatial join target for permit points (point-in-polygon), zoning polygons (overlay), and ACS tract aggregation
  - Source of land-only area denominator (`land_area_sqmi`) for intensity metrics
- **Primary consumers:** Both — district-first rollups and map-first exploration layer

---

## Access

- **Primary source/host:** OpenDataPhilly — Planning Districts (S1)
- **Access method(s):** ArcGIS Hub Download API (GeoJSON)
- **Preferred method for this project:** ArcGIS Hub download URL for Month-2 ingestion pipeline (`https://hub.arcgis.com/api/v3/datasets/0960ea0f38f44146bb562f2b212075aa_0/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1`)
- **Known limits / constraints:** Update cadence and boundary version not stated in extract metadata — validate before operationalizing
- **Expected size / volume notes:** Small dataset (18 features); no size or rate-limit concerns

---

## Time Fields

- **Time fields present:** None (boundary layer, not an event dataset)
- **Canonical time field for the project:** Not applicable
- **Time semantics:** Static reference dimension for MVP; treat as slowly changing dimension candidate if boundaries ever change
- **Time coverage:** Not applicable
- **Time granularity supported:** Not applicable

---

## Geometry

- **Geometry type:** Polygon
- **Geometry field(s) / how geometry is derived:** `geometry` field in GeoJSON (native polygon boundaries)
- **CRS / coordinate system:** Not specified in extract metadata — validate in Month 2 ingestion
- **Spatial join role:** (1) Point-in-polygon for permit assignment; (2) overlay for zoning/ACS; (3) mapping boundary layer for dashboards
- **Known geometry issues:** Geometry validity and topology not validated; boundary-edge ambiguity affects near-border record assignment

---

## Keys

- **Candidate primary key(s) / unique identifier(s):**
  - `objectid` — confirmed non-null 18/18, unique in extract
  - `abbrev` — confirmed non-null 18/18, unique in extract (e.g., "RW", "NDEL"); likely equivalent to `LABEL` in official schema
  - `DIST_NUM` — listed in official fields.json schema but **not present in GeoJSON extract**; preferred natural key per schema; confirm availability from authoritative API
- **Uniqueness confidence:** High for `objectid` and `abbrev` in the current extract; `DIST_NUM` unconfirmed until API pull
- **Composite key:** Not needed
- **Surrogate key needed:** Optional; create `district_sk` for warehouse consistency; keep confirmed natural key as `district_id`
- **Deduping rules:** Not expected (static boundary set); if API returns duplicates, flag as data quality issue

---

## Key Columns

- **Required (MVP):** Natural key (`DIST_NUM` from API or `objectid` from extract), display label (`dist_name`), district geometry
- **Optional:** `abbrev` (abbreviated label), `Shape__Area` / `AREA` (area — only after CRS validation), `SEQUENCE` (UI ordering)
- **High-risk fields:** `Shape__Area` / `AREA` — unit unknown; do not use as sq mi denominator until CRS is confirmed; derive land-only area from geometry instead
- **Categorical fields:** Not applicable (fixed 18-district set with no categorical grouping needed for MVP)

---

## Update Cadence

- **Published update cadence:** Not documented in extract metadata; assumed infrequent
- **Does history change or append-only?:** Boundary datasets typically have versioned snapshots; update behavior not validated
- **Freshness expectation for dashboards:** Static for MVP; refresh only if boundaries change
- **Notes on versioning:** L1 in the limitations register flags that boundaries are treated as static (last confirmed 2015); versioning strategy (SCD2) deferred to Month 6

---

## Risks

- **Data quality risks:** Schema mismatch between official fields.json (`DIST_NUM`, `LABEL`) and GeoJSON extract (`abbrev`, `Shape__Area`) — natural key strategy depends on which fields the authoritative API returns
- **Spatial risks:** Geometry validity and CRS not confirmed; invalid polygons or incorrect CRS would break point-in-polygon assignments and produce wrong area denominators
- **Time risks:** Not applicable (no time field); boundary version uncertainty could affect longitudinal comparability if districts changed post-2015
- **Comparability risks:** If a new boundary version is used without versioning, all historical rollups become inconsistent (L1)
- **Bias/interpretation risks:** Land-only area is not available as-is; using total area (including water) would produce lower permits-per-sq-mi values than land-only; do not use `Shape__Area` without CRS and land/water decomposition validation

---

## Notes

- **MVP validation TODOs (Month 2):**
  - Confirm authoritative API returns `DIST_NUM` and `LABEL` fields; reconcile with GeoJSON extract schema
  - Validate CRS and compute land-only area (`land_area_sqmi`) in a standardized CRS
  - Confirm boundary version used and check if newer version exists
  - Validate geometry validity (no self-intersections, topology errors)

---

## Links

- **Dataset landing page:** S1 (OpenDataPhilly — Planning Districts)
- **Metadata summary:** [`docs/source_catalog/planning_districts_metadata_summary.md`](./planning_districts_metadata_summary.md)
- **Feasibility checklist:** [`docs/feasibility/planning_districts_feasibility.md`](../feasibility/planning_districts_feasibility.md)
- **Critical fields dictionary:** [`docs/data_dictionary/planning_districts_critical_fields.md`](../data_dictionary/planning_districts_critical_fields.md)
- **Land-area denominator policy:** [`docs/policies/land_area_denominator_policy.md`](../policies/land_area_denominator_policy.md)
- **Source reference:** [`docs/03_mvp_datasets.md`](../03_mvp_datasets.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md) (L1, L2, L11)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
