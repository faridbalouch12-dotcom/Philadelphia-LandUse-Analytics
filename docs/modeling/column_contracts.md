# Column Contracts

**Author:** Farid
**Created:** 2026-03-09
**Last Updated:** 2026-03-09
**Status:** Draft

---

## Purpose

This document defines DDL-ready column contracts for the highest-risk warehouse tables — those where schema ambiguity would most likely cause grain violations, broken joins, or incorrect metrics. For each table: exact column names, SQL types, nullability, key strategy, and grain validation rules are specified.

**Scope:** All five high-risk tables: `fct_permits` (SC1), `fct_district_year_zoning_composition` (SC2), `bridge_tract_district_overlap` (SC3), `fct_tract_acs` (SC4), `dim_district` (SC5), `dim_zoning` (SC6).

> **Related document:** Grain statements and failure modes are in [`docs/modeling/grain_spec.md`](./grain_spec.md). This document provides the DDL-level detail that `grain_spec.md` does not cover.

---

## SC1 — `fct_permits`

> Goal: a developer can write a first-pass `CREATE TABLE` statement from this section alone.

**Grain:** One issued permit event (`status = 'Issued'`). Natural PK is `permitnumber`.

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `permitnumber` | `VARCHAR` | NOT NULL | Natural PK from L&I source system. Unique per issued permit. |
| `district_id` | `VARCHAR` | **NULLABLE** | FK → `dim_district`. NULL when geocoding fails; unassigned permits are tracked separately as a quality metric. |
| `date_key` | `INTEGER` | NOT NULL | FK → `dim_date` (surrogate). Derived from `permitissuedate`. |
| `permitissuedate` | `DATE` | NOT NULL | Raw issuance date from source. Required — permits filtered to `status = 'Issued'` must have an issue date. |
| `permittype` | `VARCHAR` | NOT NULL | Permit type from source (e.g., `BP_ADDITION`, `ZONING/USE`). Must be populated before load. |
| `permit_category_group` | `VARCHAR` | NOT NULL | Standardized grouping applied in staging per the permit category grouping memo. |
| `point_geometry` | `GEOMETRY(POINT, 4326)` | NOT NULL | Hard reject in staging if geometry is missing — no ungeocoded permits loaded. |

**Key strategy:**
- Natural PK: `permitnumber` (stable source system key; no surrogate needed on fact tables per Kimball [B1])
- FK to `dim_district`: `district_id` (NULLABLE — geocoding failures are tracked, not rejected)
- FK to `dim_date`: `date_key` (integer surrogate, e.g. `20230615`)

**Grain validation rules:**
1. `permitnumber` must be unique — any duplicate signals a staging deduplication failure
2. `district_id` IS NULL count must be monitored each load and logged as the unassigned permit share (L3 in limitations register)
3. `permitissuedate` must fall within the expected analysis window (`2015-01-01` to current) — outliers flagged as data quality issues

---

## SC2 — `fct_district_year_zoning_composition`

**Grain:** One planning district × one vintage year × one zoning code (periodic snapshot).

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `district_id` | `VARCHAR` | NOT NULL | PK component, FK → `dim_district`. |
| `vintage_year_key` | `INTEGER` | NOT NULL | PK component, FK → `dim_date` (EOY surrogate, e.g. `20231231`). |
| `zoning_code` | `VARCHAR` | NOT NULL | PK component, FK → `dim_zoning`. |
| `vintage_date` | `DATE` | NOT NULL | EOY date for the vintage year (e.g., `2023-12-31`). Used to join `dim_date`. |
| `area_sqmi` | `NUMERIC` | NOT NULL | Area of this zoning code within this district for this vintage. Must be > 0. |
| `pct_district` | `NUMERIC` | NOT NULL | Share of district land area covered by this zoning code. Must be > 0. |

**Key strategy:**
- Composite natural PK: (`district_id`, `vintage_year_key`, `zoning_code`) — no surrogate (periodic snapshot fact; stable vintage key)
- FKs: `district_id` → `dim_district`, `vintage_year_key` → `dim_date`, `zoning_code` → `dim_zoning`

**Grain validation rules:**
1. `(district_id, vintage_year_key, zoning_code)` must be unique
2. `SUM(pct_district)` per (`district_id`, `vintage_year_key`) should approximate 1.0 — large deviations indicate missing zoning codes or geometry gaps
3. `area_sqmi` and `pct_district` must be > 0 — zero-area rows indicate a staging error

---

## SC3 — `bridge_tract_district_overlap`

**Grain:** One census tract × one planning district × one boundary version, where `pct_tract_area > 0.01`.

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `geoid_tract` | `VARCHAR` | NOT NULL | PK component, FK → `fct_tract_acs`. Census tract GEOID (11-digit). |
| `district_id` | `VARCHAR` | NOT NULL | PK component, FK → `dim_district`. |
| `boundary_version` | `VARCHAR` | NOT NULL | PK component. String label for the district boundary vintage (e.g., `'2020'`). |
| `boundary_version_eoy` | `DATE` | NOT NULL | EOY date for the boundary version. FK → `dim_date`. |
| `overlap_area_sqft` | `NUMERIC` | NOT NULL | Raw area of the tract–district intersection in sq ft. Must be > 0. |
| `pct_tract_area` | `NUMERIC` | NOT NULL | Share of the tract's total area that falls within this district. Must be > 0.01 (rows below this threshold are dropped as GIS slivers per D16). |
| `assignment_method` | `VARCHAR` | NOT NULL | How overlap was computed. Value: `'overlap_weighted'` for all rows passing the threshold. |

**Key strategy:**
- Composite natural PK: (`geoid_tract`, `district_id`, `boundary_version`) — no surrogate
- FKs: `geoid_tract` → `fct_tract_acs`, `district_id` → `dim_district`, `boundary_version_eoy` → `dim_date`

**Grain validation rules:**
1. `(geoid_tract, district_id, boundary_version)` must be unique
2. `pct_tract_area` must be > 0.01 — enforced as a staging filter, not a DB constraint (see D16)
3. `SUM(pct_tract_area)` per (`geoid_tract`, `boundary_version`) should be ≤ 1.0 and typically close to 1.0 — large gaps indicate tracts clipped by boundary artifacts (weight-sum invariant)

---

## SC4 — `fct_tract_acs`

**Grain:** One census tract × one ACS 5-year period snapshot (wide — each indicator as a separate column).

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `geoid_tract` | `VARCHAR` | NOT NULL | PK component. Census tract GEOID (11-digit). |
| `acs_period_label` | `VARCHAR` | NOT NULL | PK component. Human-readable period label (e.g., `'2019-2023'`). |
| `acs_period_end_date` | `DATE` | NOT NULL | EOY date of the ACS period (e.g., `2023-12-31`). FK → `dim_date`. |
| `median_hh_income` | `NUMERIC` | **NULLABLE** | ACS estimate: median household income ($). NULL if Census did not publish. |
| `median_hh_income_moe` | `NUMERIC` | **NULLABLE** | Margin of error for `median_hh_income`. NULL if not published. |
| `owner_occupied_pct` | `NUMERIC` | **NULLABLE** | ACS estimate: share of housing units owner-occupied. NULL if not published. |
| `owner_occupied_pct_moe` | `NUMERIC` | **NULLABLE** | Margin of error for `owner_occupied_pct`. NULL if not published. |
| `total_pop` | `NUMERIC` | **NULLABLE** | ACS estimate: total population. NULL if not published. |
| `total_pop_moe` | `NUMERIC` | **NULLABLE** | Margin of error for `total_pop`. NULL if not published. |
| `renter_occupied_units` | `NUMERIC` | **NULLABLE** | ACS estimate: renter-occupied housing units (count) (DP04_0047E). NULL if Census did not publish. |
| `renter_occupied_units_moe` | `NUMERIC` | **NULLABLE** | Margin of error for `renter_occupied_units`. NULL if not published. |
| `occupied_units` | `NUMERIC` | **NULLABLE** | ACS estimate: occupied housing units, total (count) (DP04_0045E). Denominator for renter share. NULL if not published. |
| `occupied_units_moe` | `NUMERIC` | **NULLABLE** | Margin of error for `occupied_units`. NULL if not published. |

**Key strategy:**
- Composite natural PK: (`geoid_tract`, `acs_period_label`) — no surrogate
- FK: `acs_period_end_date` → `dim_date`

**Grain validation rules:**
1. `(geoid_tract, acs_period_label)` must be unique
2. Non-overlapping periods must be used for year-over-year comparisons — `acs_period_label` values must be validated against the ACS usage policy before any change analysis
3. NULL estimates are acceptable but must be counted and logged per load — downstream dashboard logic must handle NULLs explicitly

---

## SC5 — `dim_district`

**Grain:** One planning district. SCD Type 1 — corrections overwrite in place (D17).

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `district_id` | `VARCHAR` | NOT NULL | Natural PK. Stable administrative identifier from source (e.g., `'CC'` for Center City). |
| `district_name` | `VARCHAR` | NOT NULL | Human-readable district name. Subject to Type 1 overwrite if name is corrected. |
| `land_area_sqmi` | `NUMERIC` | NOT NULL | Land-only area in square miles, computed via PostGIS after CRS validation (unblocked by L14). |

**Key strategy:**
- Natural PK: `district_id` (administratively stable; no surrogate needed)
- No FK versioning columns (`effective_date`, `expiry_date`, `is_current`) — Type 1 SCD, boundary changes tracked via `boundary_version` in `geo_district_boundaries` (D17)

**Grain validation rules:**
1. `district_id` must be unique — 18 rows expected for Philadelphia MVP
2. `land_area_sqmi` must be > 0 and within a plausible range — gross CRS errors would produce wildly wrong values; validate against known district areas post-computation
3. No `district_id` in any fact table should be absent from `dim_district` — FK integrity enforced in dbt

---

## SC6 — `dim_zoning`

**Grain:** One canonical zoning code. SCD Type 1 — label corrections overwrite in place (D17).

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `zoning_code` | `VARCHAR` | NOT NULL | Natural PK. Raw zoning code from source (e.g., `'CMX-3'`). Preserved exactly as-is; never cleaned or aliased here. |
| `zoning_label` | `VARCHAR` | NOT NULL | Human-readable label (e.g., `'Commercial Mixed-Use 3'`). Subject to Type 1 overwrite if label is corrected. |
| `zoning_category` | `VARCHAR` | NOT NULL | Broad grouping (e.g., `'Commercial'`, `'Residential'`). Used for composition rollups. Subject to Type 1 overwrite. |

**Key strategy:**
- Natural PK: `zoning_code` (the raw code is the stable identifier; no surrogate needed)
- No SCD versioning columns — Type 1 chosen because zoning categories are broad and stable within the 5-year MVP window; raw `zoning_code` is preserved in `fct_district_year_zoning_composition` regardless of label changes, so historical composition data is unaffected by overwrites (D17)

**Grain validation rules:**
1. `zoning_code` must be unique — any duplicate signals a crosswalk or staging deduplication error
2. `zoning_category` must be one of the known MVP categories — unexpected values indicate a new code not yet in the crosswalk
3. No `zoning_code` in `fct_district_year_zoning_composition` should be absent from `dim_zoning` — FK integrity enforced in dbt

---

## Links

- Grain spec (grain statements and failure modes): [`docs/modeling/grain_spec.md`](./grain_spec.md)
- Table inventory (SCD strategies, consumers): [`docs/modeling/table_inventory.md`](./table_inventory.md)
- Permit category grouping memo: [`docs/decisions/permit_category_grouping_memo.md`](../decisions/permit_category_grouping_memo.md)
- Limitations register: [`docs/limitations_register.md`](../limitations_register.md)

---

## References

- **[B1]** Kimball, R., and Ross, M. *The Data Warehouse Toolkit* (3rd ed.).

---

## Change log

| Date | Change description | Author |
|------|--------------------|--------|
| 2026-03-09 | Initial draft — SC1 (`fct_permits`) column contract (Task 2.2) | Farid |
| 2026-03-09 | Added SC2–SC6: remaining four high-risk tables + dim_district and dim_zoning (Task 2.3) | Farid |
| 2026-03-10 | SC4: added renter_occupied_units, renter_occupied_units_moe, occupied_units, occupied_units_moe — raw count columns required by acs_tenure_proxy metric; supports overlap-weighted district-level aggregation | Farid |
