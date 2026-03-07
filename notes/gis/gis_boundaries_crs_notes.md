# GIS Boundaries & CRS — Notes

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Sources:** D3, D4, V3

---

## Purpose

These notes establish the conceptual foundation for working with coordinate reference systems (CRS) and geometry validity in a spatial data context. The goal is a correct mental model for understanding how CRS mismatches and geometry defects can silently corrupt district-level rollups before any spatial SQL is written.

---

## Key Takeaways

- A CRS defines how geometry coordinates map to locations on Earth's surface. Without a shared CRS across all spatial layers, spatial joins produce incorrect or empty results because the same coordinate numbers mean different physical locations in different systems
- Geographic Coordinate Systems (GCS) describe locations using angles (degrees of latitude/longitude) on a curved surface. Projected Coordinate Systems (PCS) flatten that surface onto a plane using linear units (feet or meters)
- Area calculations require a PCS: degree-based coordinates cover different physical distances at different latitudes, making `Δlat × Δlon` meaningless as an area measure. For this project, `EPSG:2272` (PA State Plane South, feet) is the standard for area calculations
- All spatial layers used in a join must share the same CRS — mixing `EPSG:2272` (feet) and `EPSG:32618` (meters/UTM) causes PostGIS to plot geometries in completely different locations, failing the join silently or returning zero rows
- Geometry validity issues — self-intersecting polygons, gaps between adjacent polygons, and overlapping polygons — can cause permits to go unassigned or be double-counted in district rollups

---

## Detailed Notes

### 1. What is a Coordinate Reference System (CRS)?

A CRS (also called SRS — Spatial Reference System) defines the rules for mapping a location on Earth's surface to a set of coordinates. It answers the question: "given these numbers, where on Earth is this point?"

Every spatial dataset uses a CRS. If two datasets use different CRS, their coordinates are speaking different languages — a point at (120, 90) in one system is a completely different physical location than (120, 90) in another.

**Visual reference:** [`gcs_vs_pcs_visual.html`](./gcs_vs_pcs_visual.html)

#### Geographic Coordinate Systems (GCS)

A GCS does not flatten the Earth. It describes locations using angles measured from Earth's center to a point on its curved surface:

- **Latitude:** angle north/south from the equator (0° at equator, ±90° at poles)
- **Longitude:** angle east/west from the Prime Meridian (0° at Greenwich, ±180°)

Philadelphia is at approximately `39.95° N, 75.17° W` in GCS (EPSG:4326 / WGS84).

These are angles, not lengths. One degree of longitude covers ~69 miles near the equator but near zero miles at the poles, as longitude lines converge. This means degrees are not linear units and cannot be used directly for distance or area calculations.

#### Projected Coordinate Systems (PCS)

A PCS transforms the curved GCS surface onto a flat plane using a mathematical projection. Coordinates are expressed in linear units — typically feet or meters — from a defined origin point.

- Distances and area calculations are straightforward: width × height, or standard geometry formulas
- Every projection introduces some distortion (shape, area, distance, or direction) because a sphere cannot be flattened without tearing or stretching — the "orange peel problem"
- Projections are optimized for specific regions; accuracy degrades as you move farther from the projection's origin

**Common CRS for Philadelphia work:**

| EPSG | Name | Units | Best for |
|------|------|-------|----------|
| 4326 | WGS84 (GCS) | Degrees | Storing/sharing data; GPS coordinates |
| 2272 | PA State Plane South | US Survey Feet | Area calculations; local Philadelphia GIS |
| 32618 | UTM Zone 18N | Meters | Federal/census datasets; broader regional analysis |
| 3857 | Web Mercator | Meters (distorted) | Web map tile rendering |

---

### 2. Why CRS Standardization Matters

#### 2a. Area Calculations — PCS vs. GCS

Land-only area in square miles is the denominator for this project's density metrics (e.g., permits per sq mi). If area is calculated in a GCS using raw latitude/longitude coordinates, the result is meaningless — a degree-sized cell in North Philadelphia covers a different physical area than a degree-sized cell near the equator.

For accurate area in square miles using `EPSG:2272` (feet):

```
area_sq_mi = ST_Area(ST_Transform(geom, 2272)) / (5280 * 5280)
```

Using raw GCS coordinates in `ST_Area()` without reprojecting returns a number in square degrees — not square miles, not square anything meaningful.

**This matters for the project because:** land-area-normalized metrics (permits per sq mi, zoning coverage per sq mi) are used to make districts comparable regardless of their physical size. A wrong denominator propagates error to every metric that uses it.

#### 2b. Spatial Joins Across Layers — Mismatched PCS

Even within the PCS family, mixing two different projected systems breaks spatial joins. The following two systems are both valid PCS for Philadelphia, but they use different origins and units:

| | EPSG:2272 (PA State Plane) | EPSG:32618 (UTM Zone 18N) |
|--|--|--|
| Units | US Survey Feet | Meters |
| Philadelphia X | ~2,694,000 ft | ~487,000 m |
| Philadelphia Y | ~236,000 ft | ~4,422,000 m |

If planning districts are stored in `EPSG:2272` and census tracts are loaded in `EPSG:32618` but not declared as such, PostGIS reads the UTM meter coordinates as if they were State Plane feet. The geometry plots thousands of miles from Philadelphia. The spatial join returns zero rows — no permits assigned — without throwing an error.

**Visual reference:** [`using_two_diff_pcs.html`](./using_two_diff_pcs.html)

**Fix:** Always declare the SRID when loading geometry into PostGIS. Use `ST_Transform()` at query time to reproject all layers to a common CRS before joining:

```sql
ST_Within(
  ST_Transform(permit.geom, 2272),
  ST_Transform(district.geom, 2272)
)
```

---

### 3. Geometry Validity Issues

A geometry validity issue is a defect in the geometry itself — independent of CRS. These defects exist within a single layer and can corrupt point-in-polygon results even when CRS is handled correctly.

**Visual reference:** [`common_geometry_issues.html`](./common_geometry_issues.html)

#### Common Issues

**Self-intersecting polygon (bowtie)**

The polygon boundary crosses itself, creating a figure-8 shape. The "interior" of the polygon becomes ambiguous — one region is enclosed by both loops, but it's unclear which loop defines "inside."

- `ST_IsValid()` returns `FALSE`
- `ST_Within()` on a permit inside the ambiguous zone returns `NULL` or incorrect result
- *Project impact:* Permits that should be assigned to a district are silently dropped

**Gaps between adjacent polygons**

Two neighboring district polygons that should share an edge instead have a small sliver of uncovered territory between them. This typically occurs when boundaries are digitized or edited independently.

- No `ST_IsValid()` check will catch this — each individual polygon is valid
- Permits with addresses in the gap zone pass `ST_Within()` against every district and get no match — they are assigned to no district
- *Project impact:* Monthly permit counts undercount; the undercounting is spatially non-random (concentrated at boundary edges)

**Overlapping polygons**

Two district polygons cover the same physical area. A permit in the overlap zone passes `ST_Within()` for both districts.

- No `ST_IsValid()` check will catch this — each polygon is individually valid
- The permit gets assigned to two districts and counted twice in rollup tables
- *Project impact:* District permit totals sum to more than the actual permit count; bias is concentrated at district boundaries

**Duplicate vertices**

Two consecutive points in a polygon ring share the exact same coordinate, creating a zero-length edge. This is technically a validity issue but rarely breaks spatial joins — it is included here because it is often a precursor to more serious defects.

---

### 4. Pre-Flight Checks Before Spatial Joins

Before running district assignment in the pipeline, verify:

| Check | How | Action if found |
|-------|-----|-----------------|
| Invalid geometries in district layer | `WHERE NOT ST_IsValid(geom)` | Run `ST_MakeValid()`, log in limitations register |
| SRID declared on all geometry columns | `SELECT Find_SRID(...)` | Assign with `UpdateGeometrySRID()` |
| Unassigned permits after join | `WHERE district_id IS NULL` | Log rate; investigate geographic clustering |
| Double-assigned permits | `GROUP BY permit_id HAVING COUNT(*) > 1` | Deduplicate; investigate boundary source |

---

## Open Questions

- [ ] What CRS do the official OpenDataPhilly planning district and zoning shapefiles ship in? (Confirm at ingest time — determine whether `ST_Transform()` is needed before joins)
- [ ] Does the planning district shapefile have any known boundary validity issues or revision history that would explain gaps or overlaps? (Check OpenDataPhilly metadata and update cadence notes)

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | The official Philadelphia planning districts shapefile (OpenDataPhilly) has no self-intersecting polygons and no inter-district gaps or overlaps | If invalid geometries exist, district assignment will silently drop or double-count permits near boundary areas; must validate with `ST_IsValid()` at ingest |
| A2 | All spatial layers (planning districts, zoning, permits) can be reprojected to `EPSG:2272` for spatial operations without meaningful accuracy loss | If a dataset uses a CRS incompatible with `ST_Transform()` to 2272 (e.g., missing SRID declaration), joins will fail silently |
| A3 | `EPSG:2272` (PA State Plane South, US Survey Feet) provides sufficient accuracy for land-area calculations at the planning district level | If distortion in 2272 at Philadelphia's location is non-trivial, area-based metrics may be slightly off; acceptable for planning-level analysis |

---

## Links

**Visual Supplements (open in browser):**
- GCS vs. PCS explainer: [`gcs_vs_pcs_visual.html`](./gcs_vs_pcs_visual.html)
- Mismatched PCS spatial join failure: [`using_two_diff_pcs.html`](./using_two_diff_pcs.html)
- Common geometry validity issues: [`common_geometry_issues.html`](./common_geometry_issues.html)

**Related Notes:**
- PostGIS Spatial Primer: [`postgis_spatial_primer_notes.md`](./postgis_spatial_primer_notes.md)
- Kimball Grain Notes: [`kimball_grain_notes.md`](./kimball_grain_notes.md)

**Project Documents:**
- Planning Districts source catalog: [`../../docs/source_catalog/planning_districts.md`](../../docs/source_catalog/planning_districts.md)
- Limitations register: [`../../docs/limitations_register.md`](../../docs/limitations_register.md)

---

## References

- **[D3]** PostGIS Project. "PostGIS Manual: Introduction." v2.5. https://postgis.net/docs/manual-2.5/postgis_introduction.html
- **[D4]** PostGIS Project. "PostGIS FAQ: Spatial Indexes." https://postgis.net/documentation/faq/spatial-indexes/
- **[V3]** Ramsey, Paul. "PostGIS Introduction." Crunchy Data (YouTube). https://www.youtube.com/live/g4DgAVCmiDE

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-05 | Initial notes created | Farid  |
