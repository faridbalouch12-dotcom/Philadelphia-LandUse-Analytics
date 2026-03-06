# Land-Only Area Evidence Note

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Purpose

This note documents the land-only area denominator decision for district-level intensity metrics — locking the choice, unit convention, and storage location before metric specs are written in Week 3.

---

## Decision: Land-only vs. total area

**Choice:** Land-only area (water excluded).

**Rationale:** Several Philadelphia planning districts border the Delaware or Schuylkill Rivers. Using total area (land + water) for those districts would produce artificially low density values — a district with a large river boundary would appear less dense than it actually is, making cross-district comparisons misleading. Land-only area reflects the actual developable surface and produces fair, comparable intensity metrics across all 18 districts.

**What this rules out:** `Shape__Area` from the GeoJSON extract and `AREA` from the official schema must not be used as the denominator — their units are unconfirmed and they likely represent total area including water. See [source catalog](../source_catalog/planning_districts.md) and [critical fields dictionary](../data_dictionary/planning_districts_critical_fields.md).

---

## Unit convention: square miles (sq mi)

**Choice:** Square miles.

**Rationale:** Square miles is the standard unit for urban land area and density analysis in the U.S. context, and is interpretable to a non-technical audience (planners, policymakers). All stored values and metric outputs use sq mi; no other unit is permitted for MVP metrics.

**Conversion note:** PostGIS geometry in a projected CRS (e.g., EPSG:2272 — Pennsylvania State Plane South, units in feet) will need unit conversion: `ST_Area(geometry) / 27878400.0` to convert sq ft → sq mi.

---

## Storage and usage in rollups

**Where stored:** `dim_district.land_area_sqmi` — one value per district, stored as a dimension attribute.

**Rationale for placement:** Land-only area is a static property of the district, not of any event or time period. Storing it in the district dimension keeps fact tables skinny — rollup tables join to `dim_district` at query time to access the denominator rather than carrying a redundant copy on every row.

**When computed:** During the staging/ingestion phase (Month 2), derived from the planning districts geometry in a validated projected CRS. Raw data is never modified per project data policy; the derived field is added in the staging model (`stg_planning_districts`), then carried through to `dim_district`.

**Usage in metrics:** Any metric that normalizes by area (e.g., permits per sq mi, zoning area share per sq mi) joins `dim_district` on `district_id` and divides by `land_area_sqmi`. If `land_area_sqmi` is null or zero for a district, density metrics for that district are suppressed per the land-area denominator policy.

---

## Validation TODOs (Month 2)

- Confirm CRS of the authoritative planning districts API layer
- Compute `land_area_sqmi` via PostGIS and cross-check against known approximate district sizes
- Confirm no water bodies are included in the polygon geometry (may require a water mask overlay)
- Store computed value in `stg_planning_districts` and propagate to `dim_district`

---

## Links

- **Land-area denominator policy:** [`docs/policies/land_area_denominator_policy.md`](../policies/land_area_denominator_policy.md)
- **Planning Districts source catalog:** [`docs/source_catalog/planning_districts.md`](../source_catalog/planning_districts.md)
- **Planning Districts critical fields dictionary:** [`docs/data_dictionary/planning_districts_critical_fields.md`](../data_dictionary/planning_districts_critical_fields.md)
- **Planning Districts feasibility checklist:** [`docs/feasibility/planning_districts_feasibility.md`](./planning_districts_feasibility.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md) (L11)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
