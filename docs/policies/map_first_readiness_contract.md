# Map-First Readiness Contract

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Final

---

## Purpose

This contract defines the conditions that must be met before any feature-level spatial layer in this warehouse is considered "map-first ready" — meaning it can be safely consumed by a map rendering tool (Metabase map view, QGIS, PostGIS-based exploration) without additional transformation.

This contract governs:
- `geo_district_boundaries` (E8) — planning district polygons
- `fct_permits` (E4) — permit event points
- Any future spatial feature layer added to the warehouse

It does not govern rollup tables (`fct_district_year_zoning_composition`, `agg_district_acs_attributes_hist`) — those tables contain no geometry and are not intended for map rendering.

---

## Scope

**In scope:**
- CRS (coordinate reference system) requirements
- Geometry validity requirements
- Required columns for map rendering
- Quality flag expectations
- What "map-first ready" does and does not guarantee

**Out of scope:**
- Styling or symbology choices in Metabase or QGIS
- Thematic map design
- Dashboard layout

---

## Contract conditions

A feature-level spatial layer is map-first ready when all of the following conditions are met:

---

### C1 — Geometry is stored in a confirmed, standardized CRS

**Requirement:** All geometry columns must be in **EPSG:4326** (WGS 84, latitude/longitude decimal degrees) before the table is loaded into the warehouse.

**Why:** Metabase's map views and most web mapping tools expect WGS 84. Geometry stored in a local projected CRS (e.g., EPSG:2272 Pennsylvania State Plane) will render in the wrong location or not at all.

**Validation step:** Confirm CRS from the authoritative ArcGIS FeatureServer metadata in Month 2 EDA. Use `ST_SRID()` in PostGIS to verify before computing any derived spatial metrics.

**Current status:** CRS is unconfirmed for both the planning districts and zoning datasets. Area metrics (`land_area_sqmi`, `polygon_area_sqmi`) and density metrics must be suppressed until CRS is validated. (See L14, L22 in [limitations register](../limitations_register.md).)

---

### C2 — All geometries are valid (no topology errors)

**Requirement:** Every geometry row must pass `ST_IsValid()` in PostGIS. Invalid geometries (self-intersections, unclosed rings, duplicate vertices) must be repaired with `ST_MakeValid()` or logged and excluded before the table is considered map-first ready.

**Why:** Invalid geometries cause spatial join failures, incorrect area calculations, and rendering artifacts.

**Validation step:** Run `SELECT count(*) FROM table WHERE NOT ST_IsValid(geometry_column)` during Month 2 EDA. Log any invalid features in the pipeline quality report.

---

### C3 — Point geometry is populated for all assignable records (permits)

**Requirement:** For `fct_permits`, every row must have either:
- A valid `point_geometry` (geocoded to an assignable location), or
- A non-null `unassigned_flag = TRUE` explaining why geometry is absent.

Rows with null geometry and no flag are not permitted in the mart table.

**Why:** Metabase map views will silently drop rows with null geometry. An explicit flag allows analysts to audit the unassigned share and surface it in dashboards, rather than having unassigned permits disappear invisibly.

**Threshold:** If the unassigned share in any district-month exceeds **10%**, a visible quality warning should appear on any map view for that slice. (See [permits geocoding risk note](../feasibility/permits_geocoding_risk_note.md).)

---

### C4 — A stable, unique identifier per feature is present

**Requirement:** Every row in a spatial feature table must have a stable, unique identifier that survives pipeline re-runs:
- `fct_permits`: `permitnumber`
- `geo_district_boundaries`: (`district_id`, `boundary_version`)

**Why:** Map rendering tools and downstream joins depend on stable identifiers. Without them, map layers cannot be filtered, re-queried, or cross-referenced with rollup tables.

---

### C5 — `district_id` assignment is complete for all geometry-bearing records

**Requirement:** Every permit with a valid point geometry must have a non-null `district_id` assigned before the record enters the mart. District assignment is done via spatial join in staging (`stg_li_permits`).

**Why:** District assignment is the bridge between the feature layer and all rollup tables. A permit without a `district_id` cannot contribute to any district-level metric.

**Exceptions:** Permits that fall outside all 18 district polygons (e.g., geometry errors or addresses outside city limits) are assigned `unassigned_flag = TRUE` and excluded from rollups. They remain in `fct_permits` as auditable records.

---

### C6 — Area metrics are computed by PostGIS, not taken from source fields

**Requirement:** All area values (`land_area_sqmi`, `polygon_area_sqmi`) must be computed using PostGIS (`ST_Area()` with geography cast) after CRS validation. Raw source fields (e.g., `Shape__Area` from ArcGIS) must not be used as area denominators.

**Why:** Source area fields use the source CRS's native units (which may be feet, meters, or degrees depending on the projection). Using them without CRS confirmation produces systematically wrong area values. (See L22 in [limitations register](../limitations_register.md).)

---

## What "map-first ready" does not guarantee

- It does not guarantee that all records have geometry. Permits with `unassigned_flag = TRUE` remain in the table; map tools will drop them silently unless a filter is applied.
- It does not guarantee accuracy of permit addresses. Geocoding quality is a separate concern from geometry validity.
- It does not guarantee that zoning polygons have stable boundaries across vintages. Geometry changes between vintage years can create false "churn" — see [zoning comparability plan](../zoning_comparability_plan.md).
- It does not make rollup tables map-first ready. `fct_district_year_zoning_composition` and `agg_district_acs_attributes_hist` have no geometry columns and are not covered by this contract.

---

## Assumptions

| ID | Assumption | Impact if Wrong | Mitigation |
|----|------------|-----------------|------------|
| A1 | Planning district boundaries are stable across the MVP 5-year window | Permits assigned to the wrong district for years after a boundary change | `boundary_version` column in `geo_district_boundaries` allows re-assignment if boundaries change |
| A2 | Metabase will render `fct_permits` point geometry and `geo_district_boundaries` polygon geometry correctly once CRS is EPSG:4326 | Map views may not render or may render in wrong locations | Validate rendering with a small sample before publishing dashboard |
| A3 | PostGIS `ST_Area()` with geography cast gives sufficiently accurate area in square miles for this project's precision needs | Area metrics may be slightly inaccurate near district boundaries due to spherical approximation | Documented as acceptable for MVP; revisit if metrics require higher precision |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | CRS validation is deferred and a metric is built before area is confirmed correct | Medium | High | Hard block: suppress all area-dependent metrics until C1 is satisfied |
| R2 | Geometry invalidity in zoning shapefiles causes incorrect overlay intersections | Medium | High | Run `ST_IsValid()` check before any spatial join; repair or exclude invalid features |
| R3 | Unassigned permit share is high in specific districts, making district comparisons misleading | Medium | Medium | Surface unassigned share in dashboard; add quality warning if > 10% threshold is crossed |

---

## Links

- Feature vs rollup policy: [`docs/policies/feature_vs_rollup_policy.md`](./feature_vs_rollup_policy.md)
- Land-area denominator policy: [`docs/policies/land_area_denominator_policy.md`](./land_area_denominator_policy.md)
- Permits geocoding risk note: [`docs/feasibility/permits_geocoding_risk_note.md`](../feasibility/permits_geocoding_risk_note.md)
- Limitations register (L14, L22): [`docs/limitations_register.md`](../limitations_register.md)
- ERD diagram: [`docs/diagrams/erd.mmd`](../diagrams/erd.mmd)
- Dataflow diagram: [`docs/diagrams/dataflow.mmd`](../diagrams/dataflow.mmd)

---

## References

- **[D3]** PostGIS Project. *PostGIS Manual: Introduction*. See [Resources](../../.claude/resources.md).
- **[B1]** Kimball, R., and Ross, M. *The Data Warehouse Toolkit* (3rd ed.). See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial contract — 6 conditions, assumptions, risks, and links (Task 17.2) | Farid |
