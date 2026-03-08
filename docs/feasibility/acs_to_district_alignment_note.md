# ACS to Planning District Boundary Alignment Note

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

This note documents the spatial alignment challenge between ACS census tract boundaries and Philadelphia planning district boundaries, explains the chosen approach for resolving that mismatch, and defines the sanity checks that will be run during Month 2 pipeline development to validate the allocation.

---

## The Alignment Problem

ACS data is published at the census tract level. The warehouse aggregates demographic context to the planning district level. These two boundary systems do not align — census tracts frequently straddle planning district boundaries, meaning a single tract's population must be divided across two or more districts.

No pre-built crosswalk exists for this mapping. The Census Bureau publishes relationship files between Census-defined geographies (counties, places, ZCTAs), but Philadelphia planning districts are a city-defined boundary the Census Bureau does not recognize. The allocation must be computed from the geometry directly.

---

## Approach: Spatial Overlay with Area-Weighted Interpolation

The chosen approach is a **spatial overlay**: intersect census tract polygons with planning district polygons in PostGIS, compute the overlap area for each (tract, district) pair, and use that area fraction to allocate the tract's demographic values proportionally to each district.

The core formula (per *Spatial SQL*, Forrest, Ch. 5.1):

```
allocated_value = tract_value * (
    ST_Area(ST_Intersection(tract.geom, district.geom))
    / ST_Area(tract.geom)
)
```

District-level demographic totals are the sum of all allocated tract contributions:

```
district_value = SUM(allocated_value) over all tracts intersecting the district
```

---

## Limitation: Uniform Distribution Assumption and MAUP

Area-weighted interpolation assumes the population (or any demographic variable) is **uniformly distributed** within each census tract. In practice this is often false — residents cluster in residential blocks, not commercial zones, parks, or industrial areas.

**Example:** A tract that is 50% inside District A and 50% inside District B, but where all residents live on the District A side. Area weighting allocates 50% of the population to each district. The true split is 100% to District A.

This is an instance of the **Modifiable Areal Unit Problem (MAUP)**: the aggregated values depend on how the boundary was drawn, not just on the underlying population. Planning district comparisons may be distorted near district borders where large split tracts exist and residential density is uneven.

This limitation is documented in the limitations register as **L10**.

---

## Slivers

When two polygon layers are intersected, tiny polygon fragments called **slivers** can be created at boundary edges due to minor geometry misalignments between the two datasets. Slivers produce spurious (tract, district) intersection rows with near-zero area and negligible allocated values, but they add noise and can inflate row counts in the intersection result.

Mitigation: apply a minimum area threshold when filtering intersection results (e.g., discard fragments below a de minimis area such as 1 sq meter). Track sliver share as a pipeline quality metric.

---

## Sanity Checks (Month 2)

The following checks will be run after the overlay is computed to validate the allocation before use in metrics:

| Check | What it measures | Pass condition |
|---|---|---|
| **Geometry validity** | Confirm planning district polygons tile Philadelphia without overlaps or gaps | No overlapping districts; full city coverage |
| **Split-tract count per district** | Count tracts assigned to more than one district; compute as share of each district's total tracts | Flag districts where split-tract share exceeds 20% |
| **Split ratio for split tracts** | For split tracts, compute the area fraction per district; identify tracts with near-even splits (45–55%) | Document count and share; these carry the highest MAUP risk |
| **Population total check** | Sum allocated district populations; compare to Philadelphia's total ACS population | Allocated total within ±1% of city total |

Districts with high split-tract counts or severe split ratios will carry a caveat in downstream demographic metrics: small differences between adjacent districts may not be reliable.

---

## Links

- **ACS source catalog:** [`docs/source_catalog/acs_context.md`](../source_catalog/acs_context.md)
- **ACS feasibility checklist:** [`docs/feasibility/acs_feasibility.md`](acs_feasibility.md)
- **ACS critical fields dictionary:** [`docs/data_dictionary/acs_critical_fields.md`](../data_dictionary/acs_critical_fields.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md) (entries L10, L2)
- **PostGIS spatial primer notes:** [`notes/gis/postgis_spatial_primer_notes.md`](../../notes/gis/postgis_spatial_primer_notes.md)

---

## Change Log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial draft      | Farid  |
