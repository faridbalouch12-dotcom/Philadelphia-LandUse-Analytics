# Source Catalog — Planning Districts (District Spine)

**Author:** Farid  
**Created:** 2026-03-05  
**Status:** Draft  

## Overview
- **What it is:** Polygon boundary layer defining Philadelphia’s planning districts (district spine).
- **Project relevance:** Canonical geography for district-first reporting and a join target for rollups and maps.
- **Intended outputs:** District dimension (`dim_district`), and derived land-only area denominator (`land_area_sqmi_land`).

## Access
- **Provided extract files:** `Planning_Districts.geojson`, `fields.json`
- **Access method (this project):** Local extract for MVP; later refresh from authoritative GIS source if needed.
- **Constraints/notes:** Update cadence and boundary version are not stated in the provided metadata; validate before operationalizing.

## Time Fields
- **Time fields present:** None in this extract (boundary layer).
- **Time semantics:** Not an event dataset; treat as a slowly changing dimension candidate if boundaries ever change.
- **Time coverage:** Not applicable.

## Geometry
- **Geometry type:** Polygon
- **Geometry role:** Spatial spine for point-in-polygon assignment of permits; overlay for zoning/ACS; mapping boundary layer.
- **CRS:** Not specified in provided metadata (validate during ingestion).
- **Known geometry risks:** Geometry validity/topology issues could affect district assignment; boundary-edge ambiguity impacts near-border records.

## Keys
- **Candidate primary key(s):** Prefer `DIST_NUM` as stable district identifier if unique; fall back to `OBJECTID` only if `DIST_NUM` unavailable.
- **Uniqueness evidence (this extract):**
  - `DIST_NUM`: non-null ?/18, unique_if_present=?
  - `OBJECTID`: non-null ?/18, unique_if_present=?
- **Surrogate key:** Optional; create `district_sk` for warehouse consistency (keep `DIST_NUM` as natural key).

## Key Columns
- **Required (MVP):** `DIST_NUM`, `DIST_NAME` (and/or `LABEL`), district geometry
- **Optional:** `AREA` (unit must be validated), `SEQUENCE` (ordering)
- **High-risk fields:** area fields with unknown unit; do not use as denominator unless validated

## Update Cadence
- **Provided cadence:** Not included in the extract metadata.
- **Working assumption:** Infrequent updates; treat as stable spine for MVP.
- **Validation plan:** Confirm authoritative dataset “last updated” and whether boundary versions exist.

## Risks
- Boundary changes could break longitudinal comparability unless versioned.
- Invalid polygons/topology could misassign permits and distort rollups.
- Using `AREA` as denominator without verifying units could produce incorrect intensity metrics.

## Notes
- Land-only area should be derived from geometry (standardized CRS) rather than assumed from `AREA` unless units are confirmed.
- District-first grain depends on this spine being stable and uniquely keyed.

## Links
- Local extracts: `Planning_Districts.geojson`, `fields.json`
- Related internal docs: feasibility checklist; critical fields dictionary; land area denominator policy; limitations register
