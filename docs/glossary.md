# Glossary (v0)

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This glossary defines the core terminology used across all project artifacts. Its goal is to reduce ambiguity and align terminology so that specs, notes, and diagrams use the same language consistently. Terms are defined at the level of specificity needed for this project; general industry definitions are adapted where the project makes specific choices.

---

## Terms

---

### Accumulating snapshot fact table

An accumulating snapshot fact table is a fact-table design where you store one row per process instance (one row per permit, one row per case) and update that same row over time as the process moves through its lifecycle. Instead of recording separate rows for each status change, you capture milestone columns — most commonly date/timestamp fields such as `applied_date`, `issued_date`, `completed_date`, plus optional duration metrics.

This pattern prevents accidental over-counting and makes lifecycle questions (how long from issue to completion?) straightforward because all milestones live on a single row at a consistent grain. In this project, a permit accumulating snapshot supports questions like "how long from issue to completion by district and permit type?" because all relevant lifecycle dates are on one row per permit.

*See also:* [Grain](#grain), [Periodic snapshot](#periodic-snapshot)

---

### Additive / semi-additive / non-additive facts

**Additive** facts can be meaningfully summed across all dimensions associated with the fact table — for example, summing a permit count across districts, time periods, or categories produces valid totals.

**Semi-additive** facts can be summed across some dimensions but not all. Most commonly they represent a state "as of" a point in time (like an active count at month-end), so summing across time periods double-counts the same ongoing items.

**Non-additive** facts cannot be meaningfully summed across any dimension. These are typically ratios or statistics (like a median) where summing yields a mathematically valid number that is analytically meaningless — better practice is to store the underlying components and compute the ratio at query time.

*See also:* [Grain](#grain), [Rollup table](#rollup-table)

---

### Bounding box

A bounding box is the smallest axis-aligned rectangle that fully encloses a geometry, represented by four values: `min_x`, `max_x`, `min_y`, `max_y`. PostGIS uses bounding boxes as a cheap first-pass filter in spatial indexing: if a point isn't inside the polygon's bounding rectangle, it cannot be inside the polygon, so you skip the expensive containment math. Because rectangles overestimate irregular shapes, a bounding box test can rule out candidates but cannot confirm a match — it narrows down the set that needs exact checking. [D3]

*See also:* [Spatial index](#spatial-index)

---

### Feature layer

A feature layer in GIS is a map layer that stores a collection of geographic features of the same type — such as points (permit addresses), lines (roads), or polygons (planning districts, zoning areas) — along with their attributes in a table of fields. Feature layers are the primary "things you can map": you can symbolize them, filter them, join them to other data, and run spatial analysis on them. In web GIS, a feature layer is often exposed as a queryable service.

*See also:* [Feature table vs rollup table](#feature-table-vs-rollup-table), [Geometry types](#geometry-types)

---

### Feature table vs rollup table

A **feature table** is a dataset that includes a geometry column (point/line/polygon) plus attributes, meaning each row is both an observation and a mappable object. Feature tables can be rendered as maps and support spatial operations (containment, intersection, distance).

A **rollup table** (see [Rollup table](#rollup-table)) summarizes metrics by some attribute grouping — for example, district-year permit counts or zoning churn rate by district — and typically has no geometry. Rollup tables cannot be mapped by themselves; they require a join back to a boundary feature layer for visualization.

In this project, feature tables power map visuals and spatial joins, while rollup tables power trend charts and district-level comparisons.

*See also:* [Grain](#grain), [Rollup table](#rollup-table)

---

### Geometry types

**Point** geometry represents a single coordinate location (e.g., a geocoded permit address). Used when the "where" is best modeled as one spot on the map.

**Line** geometry represents a path made of multiple connected points (e.g., roads, rivers). Useful for network-like features and distance-along-a-path analysis.

**Polygon** geometry represents an area enclosed by a ring of connected points (e.g., planning districts, zoning areas). Enables containment, overlap, and area-based analysis. [D3, V3]

*See also:* [Feature layer](#feature-layer), [Point-in-polygon](#point-in-polygon)

---

### Grain

Grain is the business-level declaration of exactly what one row in a fact (or snapshot) table represents, stated in plain language as "one row per [business event or snapshot]" — declared before choosing dimensions or facts. It should be declared at the atomic level (the lowest level the business process captures), and it becomes a binding contract: every dimension and fact added to the table must be consistent with that declared row meaning.

Mixing different grains in one table, or joining tables at incompatible grains without handling the granularity mismatch, can silently corrupt aggregations — the most dangerous kind of error because results may look plausible but be wrong. [B1]

*See also:* [Accumulating snapshot fact table](#accumulating-snapshot-fact-table), [Periodic snapshot](#periodic-snapshot)

---

### Land-only area

Land-only area is the measured area of a geography after excluding water surfaces (and depending on the dataset definition, other non-developable surfaces) so the result reflects the portion that is meaningfully "land." Operationally, it is computed by taking a boundary polygon (e.g., a planning district), subtracting water polygons (e.g., hydrography features), and calculating the remaining polygon area in consistent units (square miles in this project).

It matters here because normalizing development metrics (permits, zoning churn, etc.) by land-only area produces fairer cross-district comparisons — especially when districts differ significantly in how much of their footprint is rivers, lakes, or other water.

*See also:* [Feature layer](#feature-layer)

---

### Period estimate (ACS)

A period estimate is an estimate produced by combining survey responses collected continuously over a multi-year window (e.g., a 5-year estimate like 2020–2024). It represents an average across the whole collection period, not conditions in a single calendar year. Because it is averaged across the window, it is often best interpreted as approximating the midpoint of that period (so 2020–2024 is closer to ~2022 than "just 2024").

A key rule: only compare non-overlapping 5-year periods (e.g., 2015–2019 vs. 2020–2024). Overlapping windows share most of the same underlying respondents, making differences unreliable. [D1, D2]

*See also:* [Vintage](#vintage)

---

### Periodic snapshot

A periodic snapshot is a table where each row represents the state of an entity (or a rollup) at a regular time interval — typically expressed as one row per [entity] per [time period]. In this project, examples include "one row per planning district per calendar month" and "one row per planning district per year."

Periodic snapshots are often derived from more atomic event data for query performance, and they must not be joined to snapshots at a different time grain without aligning granularity (e.g., district-month vs. district-year). [B1]

*See also:* [Grain](#grain), [Rollup table](#rollup-table)

---

### Point-in-polygon

Point-in-polygon is a spatial join pattern where the join condition is geometric containment rather than a shared key: for each point feature, determine which polygon feature contains it. In this project, this is how a geocoded permit address (a point) gets assigned to a planning district boundary (a polygon) — by checking whether the point falls inside the district shape. It is foundational because many real datasets do not come with a district ID pre-attached; it must be derived by spatial containment. [D3, V3]

*See also:* [Geometry types](#geometry-types), [Spatial index](#spatial-index)

---

### Rollup table

A rollup table is an aggregated table that summarizes high-volume, granular data into broader, more manageable summaries grouped by some attribute combination — for example, district-year permit counts or zoning churn rate by district. Rollup tables typically have no geometry column; they require a join back to a boundary feature layer for map visualization.

In this project, rollup tables are the primary output of the analytics layer and power trend charts, district-level comparisons, and metric calculations.

*See also:* [Feature table vs rollup table](#feature-table-vs-rollup-table), [Periodic snapshot](#periodic-snapshot)

---

### SCD Type 1 (overwrite)

Slowly Changing Dimension (SCD) Type 1 handles changes to dimension attributes by overwriting the old value with the new value, so the dimension table always reflects the most current information. It does not preserve history: after the update, you cannot see what the attribute used to be.

Type 1 is appropriate when the change is a correction or when historical reporting by the old value is not meaningful (e.g., fixing a misspelled name, standardizing a category label). [B1]

*See also:* [SCD Type 2](#scd-type-2-new-row-preserve-history)

---

### SCD Type 2 (new row, preserve history)

Slowly Changing Dimension (SCD) Type 2 handles changes by inserting a new row whenever tracked dimension attributes change, preserving history instead of overwriting it. Each version is distinguished with a surrogate key and typically "as-of" fields like `effective_start_date`, `effective_end_date`, and/or a `current_flag`, allowing facts to join to the version that was true at the time of the event.

In this project, SCD Type 2 matters because descriptive context can change over a permit's lifecycle — status labels, work type classifications, geocode corrections, district assignment updates, zoning category alignment, etc. Type 2 lets you analyze permits as they were described at each point in time, rather than forcing everything to reflect the latest corrected state. [B1]

*See also:* [SCD Type 1](#scd-type-1-overwrite)

---

### Spatial index

A spatial index is an index on a geometry column that makes spatial filtering and spatial joins fast enough to be practical at scale. In PostGIS, the index supports a two-phase approach: it first applies a cheap bounding box filter to rule out geometries that cannot possibly match, then runs the expensive exact geometry computation only on the remaining candidates.

Any table used in spatial relationship queries (containment, intersection, nearest) or frequent map viewport queries should have a spatial index on its geometry column; otherwise PostGIS may fall back to costly sequential scans. [D3, V3]

*See also:* [Bounding box](#bounding-box), [Point-in-polygon](#point-in-polygon)

---

### Vintage

Vintage refers to a specific, timestamped release of a dataset — the data as it was published at that point in time, including all corrections and updates made up to that release but none made after. A vintage is a frozen snapshot: its contents do not change even as later releases correct errors or revise boundaries.

This matters for reproducibility: analyzing a 2020 vintage of planning district boundaries will always produce the same result, because that vintage is fixed. Applying the same analysis in 2025 using a live dataset where boundaries may have changed would not be a reproducible environment. Tracking vintage is essential for zoning data (which has multiple dated snapshots) and ACS data (which is released as multi-year period estimates tied to a collection window). [D1, D3]

*See also:* [Period estimate (ACS)](#period-estimate-acs)

---

### Zoning churn

Zoning churn measures the amount of zoning reclassification that occurs when comparing two zoning map vintages for the same geography. A churn event happens when a parcel's zoning category changes from one vintage to the next (e.g., Residential → Commercial). Churn can be summarized across all parcels in a district as a rate or share of land or parcels affected.

In this project, zoning churn matters because higher churn signals active rezoning pressure — an indicator that regulatory conditions are shifting in ways that can precede or accompany changes in development patterns.

*See also:* [Vintage](#vintage), [Rollup table](#rollup-table)

---

## References

- **[B1]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.). — Grain, fact types, SCD strategies, accumulating and periodic snapshots.
- **[D1]** U.S. Census Bureau. *Understanding and Using ACS Single-Year and Multiyear Estimates.* — Period estimate definition, comparability rules.
- **[D2]** U.S. Census Bureau. *Comparing ACS Data.* — Non-overlapping comparison rules, MOE guidance.
- **[D3]** PostGIS Project. *PostGIS Manual: Introduction.* — Geometry types, spatial index concepts, PostGIS fundamentals.
- **[V3]** Crunchy Data (Paul Ramsey). *PostGIS Introduction.* — Conceptual overview of PostGIS and spatial querying.

See [Resources](../.claude/resources.md) for full citations and URLs.

---

## Links

**Related Documents:**
- Style guide: [`docs/style_guide.md`](./style_guide.md)
- Scope memo: [`docs/00_scope_memo.md`](./00_scope_memo.md)
- Kimball grain notes: [`notes/kimball_grain_notes.md`](../notes/kimball_grain_notes.md)
- ACS period estimates notes: [`notes/acs_period_estimates_notes.md`](../notes/acs_period_estimates_notes.md)
- PostGIS spatial primer notes: [`notes/postgis_spatial_primer_notes.md`](../notes/postgis_spatial_primer_notes.md)
- Docs index: [`docs/README.md`](./README.md)

---

## Change Log

| Date | Change Description | Author |
|------|--------------------|--------|
| 2026-03-03 | Initial draft (v0) — 18 terms | Farid |
