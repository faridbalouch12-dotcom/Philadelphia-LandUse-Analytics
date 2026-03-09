# Grain spec

**Author:** Farid  
**Created:** 2026-03-08  
**Last Updated:** 2026-03-08  
**Status:** Draft  

---

## Purpose

This document defines the row-level grain contract for Week 3 modeling tables
so joins and metrics stay consistent.

---

## Scope

**In scope:**
- Six explicit grain statements
- One example primary key per table
- Two failure modes to avoid

**Out of scope:**
- Physical DDL and indexing
- dbt implementation details
- Full metric formulas

---

## Grain statements

### G1 — `fct_permits`

**Purpose:** The core permit event fact table. Tracks every building/construction permit issued by L&I. Used for monthly counts, permits-per-sqmi, and permit composition metrics at the district level.

**Definition:** One issued permit event from L&I, filtered in staging to `status = 'Issued'`.

**Example PK:** `permitnumber`

---

### G2 — `fct_district_year_zoning_composition`

**Purpose:** Pre-aggregated zoning snapshot table. Tracks the area and share of each zoning code within each planning district for each vintage year. Used for zoning composition metrics and as input to year-over-year change calculations (computed at query time by analysts).

**Definition:** One planning district × one vintage year × one zoning code composition snapshot.

**Example PK:** (`district_id`, `vintage_year_key`, `zoning_code`)

---

### G3 — `bridge_tract_district_overlap`

**Purpose:** Spatial bridge table resolving the many-to-many relationship between census tracts and planning districts. Enables ACS tract-level data to be aggregated to the district level via weighted overlap. Versioned by district boundary to support future boundary changes.

**Definition:** One census tract × one planning district × one boundary version overlap relationship, where overlap exists.

**Example PK:** (`geoid_tract`, `district_id`, `boundary_version`)

**Notes:**
- Expected measures: `overlap_area_sqft`, `pct_tract_area`
- Assignment metadata: `assignment_method = 'overlap_any'`

---

### G4 — `fct_tract_acs`

**Purpose:** Raw ACS demographic context table at the census tract level. Stores 5-year period estimates and margins of error for each indicator as wide columns. Serves as the source for G6 histogram aggregations and supports analysts who want to build custom district-level estimates using MOE-aware methods.

**Definition:** One census tract × one ACS period snapshot; each indicator (estimate + MOE) is a separate column.

**Example PK:** (`geoid_tract`, `acs_period_label`)

---

### G5 — `dim_date`

**Purpose:** Conformed date dimension. Provides calendar attributes (year, month, quarter, etc.) for joining to permit event dates and zoning vintage years. Standard Kimball conformed dimension shared across fact tables.

**Definition:** One calendar date in the conformed time dimension.

**Example PK:** `date_key`

---

### G6 — `agg_district_acs_attributes_hist`

**Purpose:** Pre-aggregated histogram table supporting district-level ACS distribution visualizations. Each row represents one bin of a distribution for one attribute within one district, allowing hover tooltips to show how census tracts are distributed (e.g., how many tracts fall in the $80k–$100k median income range for a given district).

**Definition:** One planning district × one boundary version × one census attribute × one bin range; measure is count of census tracts falling in that bin.

**Example PK:** (`district_id`, `boundary_version`, `census_attribute`, `bin_range`)

**Notes:**
- Derived from G4 via G3 overlap bridge
- Bins defined using percentile-based ranges computed from G4 before aggregation
- Supports district-level histogram visualizations (e.g., hover tooltip showing distribution of tract-level median income)

---

## Schema contracts

> **Note:** The schema contracts below define grain statements and validation rules at a high level. DDL-ready column contracts (exact types, nullability, key strategy) are in [`docs/modeling/column_contracts.md`](./column_contracts.md).

### SC1 — `fct_permits`

> Goal: a developer can write a first-pass DDL from this table alone.

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
- Natural PK: `permitnumber` (stable source system key, no surrogate needed on fact tables per Kimball)
- FK to `dim_district`: `district_id` (NULLABLE)
- FK to `dim_date`: `date_key` (integer surrogate)

**Grain validation rules:**
1. `permitnumber` must be unique — any duplicate signals a staging deduplication failure
2. `district_id` IS NULL count must be monitored each load and logged as the unassigned permit share
3. `permitissuedate` must fall within the expected analysis window (2015-01-01 to current) — outliers flagged as data quality issues

---

### SC2 — `fct_district_year_zoning_composition`

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `district_id` | `VARCHAR` | NOT NULL | PK component, FK → `dim_district`. |
| `vintage_year_key` | `INTEGER` | NOT NULL | PK component, FK → `dim_date` (EOY surrogate, e.g. `20231231`). |
| `zoning_code` | `VARCHAR` | NOT NULL | PK component, FK → `dim_zoning`. |
| `vintage_date` | `DATE` | NOT NULL | EOY date for the vintage year (e.g., `2023-12-31`). Used to join `dim_date`. |
| `area_sqmi` | `NUMERIC` | NOT NULL | Area of this zoning code within this district for this vintage. Must be > 0. |
| `pct_district` | `NUMERIC` | NOT NULL | Share of district land area covered by this zoning code. Must be > 0. |

**Key strategy:**
- Composite natural PK: (`district_id`, `vintage_year_key`, `zoning_code`) — no surrogate
- FKs: `district_id` → `dim_district`, `vintage_year_key` → `dim_date`, `zoning_code` → `dim_zoning`

**Grain validation rules:**
1. `(district_id, vintage_year_key, zoning_code)` must be unique
2. `SUM(pct_district)` per (`district_id`, `vintage_year_key`) should approximate 1.0 — large deviations indicate missing zoning codes or geometry gaps
3. `area_sqmi` and `pct_district` must be > 0 — zero-area rows indicate a staging error

---

### SC3 — `bridge_tract_district_overlap`

| Column | Type | Nullable | Business meaning |
|--------|------|----------|-----------------|
| `geoid_tract` | `VARCHAR` | NOT NULL | PK component, FK → `fct_tract_acs`. Census tract GEOID. |
| `district_id` | `VARCHAR` | NOT NULL | PK component, FK → `dim_district`. |
| `boundary_version` | `VARCHAR` | NOT NULL | PK component. String label for the district boundary vintage (e.g., `'2020'`). |
| `boundary_version_eoy` | `DATE` | NOT NULL | EOY date for the boundary version. FK → `dim_date`. |
| `overlap_area_sqft` | `NUMERIC` | NOT NULL | Raw area of the tract–district intersection in sq ft. Must be > 0. |
| `pct_tract_area` | `NUMERIC` | NOT NULL | Share of the tract's total area that falls within this district. Must be > 0.01 (1% threshold — rows below this are dropped as GIS slivers). |
| `assignment_method` | `VARCHAR` | NOT NULL | How overlap was computed. Value: `'overlap_weighted'` for all rows passing the threshold. |

**Key strategy:**
- Composite natural PK: (`geoid_tract`, `district_id`, `boundary_version`) — no surrogate
- FKs: `geoid_tract` → `fct_tract_acs`, `district_id` → `dim_district`, `boundary_version_eoy` → `dim_date`

**Grain validation rules:**
1. `(geoid_tract, district_id, boundary_version)` must be unique
2. `pct_tract_area` must be > 0.01 — enforced as a staging filter, not a DB constraint
3. `SUM(pct_tract_area)` per (`geoid_tract`, `boundary_version`) should be ≤ 1.0 and typically close to 1.0 — large gaps indicate tracts clipped by boundary artifacts

---

### SC4 — `fct_tract_acs`

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

**Key strategy:**
- Composite natural PK: (`geoid_tract`, `acs_period_label`) — no surrogate
- FK: `acs_period_end_date` → `dim_date`

**Grain validation rules:**
1. `(geoid_tract, acs_period_label)` must be unique
2. Non-overlapping periods must be used for year-over-year comparisons — `acs_period_label` values must be validated against the ACS usage policy before any change analysis
3. NULL estimates are acceptable but must be counted and logged per load — downstream dashboard logic must handle NULLs explicitly

---

## Failure modes to avoid

### FM1. Grain integrity failure in `fct_permits`

If multiple rows share the same `permitnumber` with `status = 'Issued'` (e.g., due to duplicates in raw data), the one-row-per-permit guarantee breaks and permit counts become inflated. Deduplication must be enforced in staging before load.

### FM2. Mixed-grain facts in `fct_district_year_zoning_composition`

G2 is a pure snapshot table — each row answers "what is the zoning composition in this district for this year?" Resist the urge to add pre-computed change metrics (e.g., `pct_change_from_prior_year`) as columns. Those measures span two years and represent a different business question. Storing them in the snapshot table mixes two fact types at the same grain, creating NULL-filled rows for the earliest vintage and conflating snapshot logic with change logic. Year-over-year change should be computed at query time by analysts via self-join or window function.

---

## Links

- Decision log: [`docs/decision_log.md`](../decision_log.md)
- Week 2 recap: [`docs/week2_recap.md`](../week2_recap.md)
- ACS alignment note: [`docs/feasibility/acs_to_district_alignment_note.md`](../feasibility/acs_to_district_alignment_note.md)

---

## References

- **[B1]** Kimball, R., and Ross, M. *The Data Warehouse Toolkit* (3rd ed.). See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial Task 11.1 draft with five grain statements, PK examples, and failure modes | Farid |
| 2026-03-08 | Finalized through tutor discussion: added G6 (agg_district_acs_attributes_hist), corrected FM1/FM2, clarified G4 wide-table design rationale | Farid |
| 2026-03-09 | Added schema contracts SC1–SC4 for all four high-risk tables; column types, nullability, key strategy, and grain validation rules (Month 1 closeout) | Farid |
