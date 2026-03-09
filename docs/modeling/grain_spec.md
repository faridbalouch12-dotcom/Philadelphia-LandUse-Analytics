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
