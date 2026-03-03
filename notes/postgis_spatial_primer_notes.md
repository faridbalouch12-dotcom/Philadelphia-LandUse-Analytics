# PostGIS: Spatial Primer — Notes

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Source:** [B13]

---

## Purpose

These notes establish the conceptual foundation for working with spatial data in PostGIS: what geometry types exist, how spatial joins work, and why spatial indexes are required for performant spatial queries. The goal is a correct mental model for designing map-ready tables before any spatial SQL is written.

---

## Key Takeaways

- PostGIS extends Postgres with a `geometry` data type and spatial functions, enabling SQL-based geographic analysis on point, line, and polygon data
- The three geometry types relevant to this project are: Point (permit addresses), Line (not used directly), and Polygon (district and zoning boundaries)
- Assigning a permit to a planning district is a **point-in-polygon spatial join** — the core spatial operation in this project
- Spatial indexes use a two-phase R-tree approach: cheap bounding box filter first, exact geometry check only on candidates that pass — this is what makes spatial joins performant at scale
- Every table used in spatial relationship analysis or frequent map viewport queries must have a spatial index on its geometry column

---

## Detailed Notes

### What PostGIS Adds to Postgres

PostGIS is an extension to PostgreSQL that adds:
- A `geometry` column type for storing spatial objects
- Spatial functions (e.g., `ST_Within`, `ST_Contains`, `ST_Area`) for querying and analyzing geometric relationships
- Spatial index support (R-tree) for performant spatial queries

Without PostGIS, Postgres has no native concept of location, area, or spatial containment. With PostGIS, spatial data can be queried using standard SQL joins and WHERE clauses alongside non-spatial columns.

### Geometry Types

PostGIS supports three fundamental geometry types:

| Type | Description | Project examples |
|------|-------------|-----------------|
| **Point** | A single coordinate (location) | Geocoded permit address |
| **Line** | A path between two or more points | Roads, rivers (not used directly in this project) |
| **Polygon** | An area enclosed by a ring of connected points | Planning district boundaries, zoning area boundaries |

Points represent locations where something happened. Polygons represent areas with shape and extent. The distinction determines which spatial functions apply and what indexes are needed.

### Spatial Join: Point-in-Polygon

A **spatial join** is a JOIN where the condition is a spatial relationship rather than a matching key. The core spatial join in this project is **point-in-polygon**: for each permit (point), find which planning district (polygon) contains it.

Conceptually: for every permit address, check whether that coordinate falls inside each district boundary, and assign the permit the district ID where the containment is true.

This is how raw permit addresses — which carry no district label — get associated with planning districts in the warehouse.

### Spatial Indexes: Why They Matter

Without a spatial index, PostGIS performs a **sequential scan**: for every permit point, it runs the full polygon containment calculation against every district polygon. Polygon containment math is expensive — checking 500,000 permits against 18 districts means up to 9 million geometry calculations per query.

PostGIS uses an **R-tree spatial index** that operates in two phases:

1. **Phase 1 — Bounding box filter (cheap):** Each polygon is wrapped in the smallest possible bounding rectangle (4 numbers: min_x, max_x, min_y, max_y). PostGIS checks whether the point falls within this rectangle using simple arithmetic. If the point is outside the bounding box, it cannot be inside the polygon — skip. If inside, proceed to Phase 2.

2. **Phase 2 — Exact geometry check (expensive):** Run the full polygon containment math only on candidates that passed the bounding box filter.

The bounding box always overestimates the polygon's area (rectangles are larger than irregular shapes), so Phase 1 can only rule out — it cannot confirm. Phase 2 is still required for the subset that passes.

**Two rules for when to apply a spatial index (from Forrest, *Spatial SQL*, p. 59):**
- If a table is used in spatial relationship queries (intersections, containment, nearest), index its geometry column
- If a table is queried by bounding box on a regular basis (e.g., map viewport queries), index its geometry column

---

## Map-Ready Tables in This Project

A **map-ready table** has a geometry column that can be directly rendered on a map. The three map-ready tables in this project are:

### 1. `permits` — Point geometry

- **Geometry type:** POINT (geocoded permit address)
- **Why map-ready:** Each row is a permit event at a specific location; rendered on the dashboard as a dot layer
- **Spatial index:** Required — dashboard map viewport queries filter permits to the visible area; without an index, all 500,000+ rows are scanned per pan/zoom

### 2. `planning_districts` — Polygon geometry

- **Geometry type:** POLYGON (district boundary)
- **Why map-ready:** District boundaries are rendered as filled polygon areas; clicking a district on the map filters the dashboard
- **Spatial index:** Required — polygon table is the target of point-in-polygon joins (assigning permits to districts); index enables the bounding box pre-filter

### 3. `zoning_base_districts` — Polygon geometry

- **Geometry type:** POLYGON (zoning area boundary)
- **Why map-ready:** Zoning polygons are rendered on the map colored by zoning category (residential, commercial, industrial, etc.), showing what each area is zoned for
- **Spatial index:** Required — used in spatial relationship analysis when overlaying zoning with permit or district data

---

## Why Spatial Indexing Matters for Joins

Spatial indexes are essential for any table involved in spatial relationship queries or frequent geographic filtering. PostGIS uses an R-tree index that operates in two phases: first, it compares cheap bounding boxes (4-number rectangles) to eliminate candidates that cannot possibly intersect — a bounding box check is pure arithmetic with no geometry math. Second, it runs the full, exact geometry computation only on the small subset that passes the bounding box filter. For this project, the `planning_districts` polygon table requires a spatial index because it is the target of point-in-polygon joins (assigning each permit to its district) — without the index, PostGIS runs expensive polygon containment math for every permit against every district row. The `permits` point table also requires a spatial index to support bounding box viewport queries from the map dashboard: when a user pans to a neighborhood, PostGIS must retrieve only the permits visible in the map window, and an index allows it to jump directly to the relevant subset rather than scanning all rows.

---

## Open Questions

- [ ] Which CRS (coordinate reference system) do the Philadelphia planning district and zoning shapefiles use? (To be confirmed in Task 6.x — CRS alignment is required before spatial joins will produce correct results)
- [ ] Does Metabase support direct rendering of PostGIS geometry columns, or is a separate GeoJSON export step needed? (To be confirmed before building the map dashboard layer)

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | Permit addresses in the L&I dataset are geocoded (or can be geocoded) to lat/lng coordinates, enabling conversion to PostGIS Point geometry | If addresses are not geocodable, point-in-polygon join cannot be performed and district assignment must rely on a different field |
| A2 | Planning district and zoning boundary files use a CRS compatible with the permit geocoding CRS (or can be reprojected to match) | If CRS are misaligned, spatial joins will produce incorrect results — geometries will appear to not overlap even when they should |
| A3 | Metabase can render PostGIS geometry columns directly for map visualizations | If not, a separate export or transformation step is needed before the map layer is usable |

---

## Links

**Related Notes:**
- Kimball Grain Notes: [`kimball_grain_notes.md`](./kimball_grain_notes.md)
- Kimball Facts Notes: [`kimball_facts_notes.md`](./kimball_facts_notes.md)
- ACS Period Estimates Notes: [`acs_period_estimates_notes.md`](./acs_period_estimates_notes.md)

**Project Documents:**
- Docs folder: [`../docs/`](../docs/)

---

## References

- **[B13]** Forrest, Matthew. 2023. "Spatial SQL: A Practical Approach to Modern GIS Using SQL." See [Bibliography](../docs/bibliography.md). Sections 3.4 (pp. 59–61), 2.1–2.2 (pp. 157–163), 3.5 (pp. 226–229).

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-03 | Initial notes created | Farid  |
