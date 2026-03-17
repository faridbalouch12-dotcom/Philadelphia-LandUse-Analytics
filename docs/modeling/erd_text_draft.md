# ERD Text Draft

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-10
**Status:** Draft

---

## Purpose

Text-only entity-relationship draft for the Philadelphia data warehouse. Defines all entities, their grain, key columns, and relationships (with cardinality and join keys) before the Mermaid diagram is drawn in Task 16.1.

---

## Scope

**In scope:**
- All MVP entities (fact tables, dimensions, bridge, aggregation, feature layer, intermediate transform tables)
- Relationships with cardinality and join keys
- Design decisions and assumptions surfaced during ERD work

**Out of scope:**
- Physical DDL and indexes
- dbt model implementation
- Full column lists (covered in data dictionaries)

---

## Entities

### E1 — `dim_district`

**Type:** Dimension
**Grain:** One planning district
**PK:** `district_id`
**Key columns:** `district_id` (integer), `district_name`, `district_abbrev`, `land_area_sqmi`, `polygon_geometry`
**Purpose:** District lookup table used by all fact and aggregation tables. Co-locates `polygon_geometry` for map rendering — same pattern as `fct_tract_acs` (D19). Analytics consumers must use explicit column selection and exclude `polygon_geometry` in non-spatial queries. See D20.

---

### E2 — `dim_date`

**Type:** Dimension
**Grain:** One calendar date
**PK:** `date_key`
**Key columns:** `date_key`, `full_date`, `year`, `month`, `quarter`
**Purpose:** Conformed date dimension shared across all fact tables. Fact tables join via a surrogate EOY date key (e.g., `vintage_date`, `boundary_version_eoy`, `acs_period_end_date`) rather than raw year integers, to avoid fan-out on year-level joins.

---

### E3 — `dim_zoning`

**Type:** Dimension
**Grain:** One zoning code
**PK:** `zoning_code`
**Key columns:** `zoning_code`, `zoning_label`, `zoning_category`
**Purpose:** Lookup table for zoning code descriptions and category groupings. Assumed stable across vintages for MVP — cross-vintage schema changes are a documented risk (see Assumptions).

---

### E4 — `fct_permits`

**Type:** Fact
**Grain:** One issued permit event from L&I, filtered in staging to `status = 'Issued'`
**PK:** `permitnumber`
**Key columns:** `permitnumber`, `district_id`, `date_key`, `permitissuedate`, `permittype`, `point_geometry`
**Purpose:** Core permit event fact table. Used for monthly counts, permits-per-sqmi, and composition metrics at the district level. Contains point geometry for spatial assignment — retained at row level since it is one point per permit event.

---

### E5 — `fct_district_year_zoning_composition`

**Type:** Fact (rollup)
**Grain:** One planning district × one vintage year × one zoning code composition snapshot
**PK:** (`district_id`, `vintage_year_key`, `zoning_code`)
**Key columns:** `district_id`, `vintage_year_key`, `zoning_code`, `vintage_date`, `area_sqmi`, `pct_district`, `vocab_stable`
**Purpose:** Pre-aggregated zoning composition snapshot. `vintage_date` stores the EOY date of the vintage year (e.g., `2023-12-31`) and is used as the FK to `dim_date`. Year-over-year change is computed at query time by analysts via self-join — not stored here (see grain_spec FM2).

---

### E6 — `bridge_tract_district_overlap`

**Type:** Bridge (many-to-many resolver)
**Grain:** One census tract × one planning district × one boundary version overlap relationship, where overlap exists
**PK:** (`geoid_tract`, `district_id`, `boundary_version`)
**Key columns:** `geoid_tract`, `district_id`, `boundary_version`, `boundary_version_eoy`, `overlap_area_sqft`, `pct_tract_area`, `assignment_method`
**Purpose:** Spatial bridge resolving the many-to-many relationship between census tracts and planning districts. Enables ACS tract-level data to be aggregated to the district level via weighted overlap. `boundary_version_eoy` is the EOY date of the district boundary version, used as the FK to `dim_date`. Versioned to support future boundary changes.

---

### E7 — `fct_tract_acs`

**Type:** Fact
**Grain:** One census tract × one ACS 5-year period snapshot; each indicator (estimate + MOE) is a separate column
**PK:** (`geoid_tract`, `acs_period_label`)
**Key columns:** `geoid_tract`, `acs_period_label`, `acs_period_end_date`, `tract_geometry`, `median_hh_income`, `median_hh_income_moe`, `total_pop`, `total_pop_moe`, *(additional indicators...)*
**Purpose:** Raw ACS demographic context at census tract level. Wide table — one row per tract per period, all indicators as columns. `acs_period_end_date` stores the EOY date of the period's end year (e.g., `2023-12-31` for "2019-2023") and is used as the FK to `dim_date`. `tract_geometry` stores the census tract polygon for map rendering — co-located rather than separated to a dedicated geo table; see DD6 and D19 for rationale. Supports MOE-aware custom aggregations by analysts. Source for `agg_district_acs_attributes_hist` (E9).

---

### ~~E8 — `geo_district_boundaries`~~

> **Dropped — superseded by D20 (2026-03-15).** Polygon geometry is now co-located in `dim_district`. See D20 for rationale.

---

### E9 — `agg_district_acs_attributes_hist`

**Type:** Aggregation
**Grain:** One planning district × one boundary version × one census attribute × one bin range
**PK:** (`district_id`, `boundary_version_eoy`, `census_attribute`, `bin_range`)
**Key columns:** `district_id`, `boundary_version_eoy`, `census_attribute`, `bin_range`, `tract_count`
**Purpose:** Pre-aggregated histogram table for district-level ACS distribution visualizations. `tract_count` is the number of census tracts falling in the bin. `census_attribute` and `bin_range` are inline string columns — no separate dimension lookup, as bins are data-derived from percentiles of `fct_tract_acs`. Nullability in source data is a documented limitation.

---

## Intermediate layer entities (pipeline-only)

These transform tables are pipeline-only infrastructure. They are not queried by analysts and are not shown in the analyst-facing ERD diagram (`erd.mmd`). Documented here for completeness since they are assigned entity numbers in the table inventory and represent the intermediate layer of the 5-layer architecture.

---

### E10 — `int_li_permits_issued`

**Type:** Transform
**Grain:** One permit record where `status = 'Issued'` (filtered from `stg_li_permits`)
**PK:** `permitnumber` (inherited from staging)
**Key columns:** `permitnumber`, `permitissuedate`, `permittype`, `address`, `point_geometry`
**Purpose:** Filters staged permit records to issued-only. First step in the permits pipeline. Feeds `int_li_permits_issued_with_district` (E11). Rebuilt on each pipeline run.

---

### E11 — `int_li_permits_issued_with_district`

**Type:** Transform
**Grain:** One issued permit event with assigned planning district (after point-in-polygon spatial join)
**PK:** `permitnumber` (one-to-one with E10; permits not spatially assigned are dropped or flagged)
**Key columns:** `permitnumber`, `district_id`, `permitissuedate`, `permittype`, `point_geometry`
**Purpose:** Spatially joins E10 to planning district boundaries to assign `district_id` to each permit. Direct input to `fct_permits` (E4). Rebuilt on each pipeline run.

---

### E12 — `int_tract_district_overlap`

**Type:** Transform
**Grain:** One census tract × one planning district spatial intersection pair (unfiltered — all geometric intersections including slivers)
**PK:** (`geoid_tract`, `district_id`) — composite
**Key columns:** `geoid_tract`, `district_id`, `overlap_area_sqft`, `pct_tract_area`
**Purpose:** Raw spatial intersection table before the `pct_tract_area > 0.01` threshold filter is applied (D16). Feeds `bridge_tract_district_overlap` (E6). Rebuilt on each pipeline run.

---

### E13 — `int_zoning_district_intersections_{year}`

**Type:** Transform
**Grain:** One zoning polygon × one planning district spatial intersection, per vintage year
**PK:** (`zoning_polygon_id`, `district_id`, `vintage_year`) — composite
**Key columns:** `zoning_polygon_id`, `district_id`, `zoning_code`, `vintage_year`, `intersection_area_sqft`
**Purpose:** Raw zoning × district polygon intersections before area-weight aggregation. One row per polygon-pair per year. Feeds E14. Rebuilt on each pipeline run.

---

### E14 — `int_zoning_district_year_composition_base`

**Type:** Transform
**Grain:** One planning district × one vintage year × one zoning code (area weights pre-aggregated across all intersecting polygons)
**PK:** (`district_id`, `vintage_year`, `zoning_code`) — composite
**Key columns:** `district_id`, `vintage_year`, `zoning_code`, `total_intersection_area_sqft`, `pct_district`
**Purpose:** Aggregates E13 by summing polygon intersection areas per district-year-zoning-code combination. Consolidates polygon-level intersections into one row per composition unit before loading to `fct_district_year_zoning_composition` (E5). Rebuilt on each pipeline run.

---

## Relationships

| # | From | To | Cardinality | Join Key | Notes |
|---|------|----|-------------|----------|-------|
| R1 | `fct_permits` | `dim_district` | many-to-one | `district_id` | One permit belongs to one district |
| R2 | `fct_permits` | `dim_date` | many-to-one | `date_key → date_key` | One permit has one issue date |
| R3 | `fct_district_year_zoning_composition` | `dim_district` | many-to-one | `district_id` | Many zoning snapshots per district |
| R4 | `fct_district_year_zoning_composition` | `dim_date` | many-to-one | `vintage_year_key → date_key` | EOY date of vintage year; avoids year-level fan-out |
| R5 | `fct_district_year_zoning_composition` | `dim_zoning` | many-to-one | `zoning_code` | One zoning code per row |
| R6 | `bridge_tract_district_overlap` | `dim_district` | many-to-one | `district_id` | Many tract-district pairs per district |
| R7 | `bridge_tract_district_overlap` | `fct_tract_acs` | many-to-one | `geoid_tract` | Bridge references tract fact table as lookup |
| R8 | `bridge_tract_district_overlap` | `dim_date` | many-to-one | `boundary_version_eoy → date_key` | EOY date of boundary version |
| R9 | `fct_tract_acs` | `dim_date` | many-to-one | `acs_period_end_date → date_key` | EOY date of ACS period end year |
| R10 | `agg_district_acs_attributes_hist` | `dim_district` | many-to-one | `district_id` | Many histogram bins per district |
| R11 | `agg_district_acs_attributes_hist` | `dim_date` | many-to-one | `boundary_version_eoy → date_key` | EOY date of boundary version used in aggregation |
| ~~R12~~ | ~~`geo_district_boundaries`~~ | ~~`dim_district`~~ | — | — | Dropped — `geo_district_boundaries` removed (D20) |

---

## Design decisions

**DD1 — EOY date pattern for year-level joins**
All year-level and period-level fact tables use an EOY surrogate date column (e.g., `vintage_date`, `acs_period_end_date`, `boundary_version_eoy`) to join cleanly to `dim_date` without fan-out. A join on `year` integer would match 365 rows in `dim_date` per fact row.

**DD2 — Geometry co-located in `dim_district`** *(updated 2026-03-15, supersedes original DD2 — see D20)*
`dim_district` co-locates `polygon_geometry` alongside scalar attributes, following the same pattern as `fct_tract_acs` (DD6, D19). `geo_district_boundaries` is dropped. Analytics consumers must use explicit column selection to exclude `polygon_geometry` in non-spatial queries.

**DD3 — `fct_tract_acs` used as lookup by bridge**
`bridge_tract_district_overlap` joins to `fct_tract_acs` on `geoid_tract` — a fact table acting as a dimensional lookup for tract identity. This is intentional: ACS data contains measurements (estimates + MOE), not just descriptive attributes, so a separate `dim_census_tract` would duplicate data already in the fact table.

**DD4 — No `dim_attribute_bin` for histogram**
Bin boundaries in `agg_district_acs_attributes_hist` are computed from percentiles of `fct_tract_acs` at pipeline time. A static lookup table cannot represent data-derived bins, so `census_attribute` and `bin_range` are stored as inline string columns.

**DD5 — YoY change not stored in `fct_district_year_zoning_composition`**
G2 is a pure snapshot table. Year-over-year change is computed at query time by analysts via self-join or window function. See grain_spec FM2.

**DD6 — Geometry co-located in `fct_tract_acs`, not separated to a dedicated `geo_tract_boundaries` table**
DD2 separates polygon geometry from `dim_district` because `dim_district` is joined by every analytics query in the warehouse — geometry overhead would be unavoidable. `fct_tract_acs` has low join frequency: it is consumed by `bridge_tract_district_overlap` and `agg_district_acs_attributes_hist`, both dbt models using explicit column selection. A separate `geo_tract_boundaries` table would add a join for map rendering with no analytical benefit at MVP scale. `tract_geometry` is therefore co-located in `fct_tract_acs`. See D19 for full rationale and scaling implications.

---

## Assumptions

| ID | Assumption | Impact if wrong | Mitigation |
|----|------------|-----------------|------------|
| A1 | `zoning_code` values are stable across vintage years for MVP | `dim_zoning` joins break; composition comparisons misleading | Validate code lists across vintages before Month 2 implementation; see zoning comparability plan |
| A2 | `permitnumber` is unique per issued permit in raw L&I data after status filter | Grain integrity failure in `fct_permits`; permit counts inflated | Enforce deduplication in staging; add dbt unique test on `permitnumber` |
| A3 | ACS period end year is an adequate temporal anchor for `fct_tract_acs` | Analysts may incorrectly interpret estimates as point-in-time | Add `acs_period_label` display column and standard disclaimer to dashboards |
| A4 | District boundaries are stable for the MVP 5-year window | Bridge table re-computation required if boundaries change | `boundary_version` column supports future re-computation without schema change |

---

## Links

- Grain spec: [`docs/modeling/grain_spec.md`](./grain_spec.md)
- Decision log: [`docs/decision_log.md`](../decision_log.md)
- Zoning comparability plan: [`docs/zoning_comparability_plan.md`](../zoning_comparability_plan.md)
- ACS alignment note: [`docs/feasibility/acs_to_district_alignment_note.md`](../feasibility/acs_to_district_alignment_note.md)

---

## References

- **[B1]** Kimball, R., and Ross, M. *The Data Warehouse Toolkit* (3rd ed.). See [Resources](../../.claude/resources.md).
- **[D11]** PostgreSQL Docs: Constraints (PK, UK, FK). See [Resources](../../.claude/resources.md).

---

## Change log

| Date | Change description | Author |
|------|--------------------|--------|
| 2026-03-08 | Initial draft — 9 entities, 12 relationships, 5 design decisions, 4 assumptions | Farid |
| 2026-03-10 | Added E10–E14 intermediate layer entities to reflect 5-layer architecture | Farid |
| 2026-03-10 | Reconciliation: E4 key columns corrected — added `date_key` as FK to dim_date; R2 join key updated from `permitissuedate → date_key` to `date_key → date_key` | Farid |
| 2026-03-10 | Reconciliation: E5 `vintage_year_key` corrected to PK+FK; R4 join key updated from `vintage_date → date_key` to `vintage_year_key → date_key` | Farid |
| 2026-03-10 | Reconciliation: E7 key columns `median_income/moe` → `median_hh_income/moe` to match SC4 and erd.mmd; links section `zoning_comparability_plan_draft.md` → `zoning_comparability_plan.md` (draft deleted) | Farid |
| 2026-03-10 | Full reconciliation: E5 key columns — added `vocab_stable` per SC2 update | Farid |
| 2026-03-10 | Added `tract_geometry` to E7 key columns and purpose; added DD6 — geometry co-located in fct_tract_acs (D13 pattern explicitly not applied; see D19) | Farid |
| 2026-03-15 | D20: E8 dropped; E1 updated to include polygon_geometry; DD2 updated; R12 removed | Farid |
