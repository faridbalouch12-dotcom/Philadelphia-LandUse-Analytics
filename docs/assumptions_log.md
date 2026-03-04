# Assumptions log

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This document records the key assumptions currently underlying the MVP
dataset scope and access design. The goal is to make uncertainty explicit
now, so it can be validated before those assumptions turn into hidden bugs
in downstream modeling, pipeline design, or analysis.

---

## Scope

**In Scope:** Assumptions implied by the current MVP dataset selection,
spatial rollup strategy, data access plan, and ACS comparison approach.

**Out of Scope:** Final validation results, implementation details, and any
new assumptions introduced in later modeling or pipeline work.

---

## Assumptions

### A1. Planning district boundaries can be treated as static for the MVP analysis period

| Field | Detail |
|-------|--------|
| **Statement** | Planning district boundaries can be treated as static for the MVP analysis period. |
| **Rationale** | The Planning Districts layer is described as last updated in 2015 and is being used as the fixed district spine. |
| **Validation plan** | Check the Planning Districts metadata for newer versions, confirm the feature count remains 18, and verify there is no official note of boundary revision since 2015. |
| **Impact if wrong** | District-level trends become non-comparable across time. Zoning and permits could be assigned differently across years, biasing comparisons. |

---

### A2. Spatial assignment of permits to districts is good enough for district-level aggregation

| Field | Detail |
|-------|--------|
| **Statement** | Spatial assignment of permits to districts is good enough for district-level aggregation, with boundary-straddling cases limited enough not to materially distort results. |
| **Rationale** | Boundary-edge uncertainty affecting district assignment is already identified as a known risk in the MVP dataset selection. |
| **Validation plan** | Compute the share of permits within a small buffer of district boundaries, track that share by district and month, and run sensitivity checks on district totals. |
| **Impact if wrong** | Some districts may be systematically over-counted or under-counted. Apparent month-to-month change may partly reflect boundary noise rather than real activity. |

---

### A3. Carto SQL API access for L&I permits is stable and supports date-filtered extraction for the last five years

| Field | Detail |
|-------|--------|
| **Statement** | Carto SQL API access for L&I permits is stable and supports repeatable date-filtered extraction for the last five years. |
| **Rationale** | The current access plan uses the Carto SQL API with date filtering to keep the permit extract to a manageable size. |
| **Validation plan** | Run test queries across multiple months and years, document any rate limits or row caps, and confirm schema stability and repeatability. |
| **Impact if wrong** | Ingestion may fail or return incomplete data. The project may need a different access method, or paging and partitioning may need to be implemented earlier than planned. |

---

### A4. The permits dataset has a reliable event date field suitable for monthly rollups

| Field | Detail |
|-------|--------|
| **Statement** | The permits dataset contains at least one event date field reliable enough to support monthly district-level rollups. |
| **Rationale** | Permits are the core physical-change fact source, and the MVP requires monthly district rollups. |
| **Validation plan** | Profile candidate date fields for missingness and distribution, then compare monthly rollups produced by different date fields over a sample period. |
| **Impact if wrong** | Monthly trends may be distorted if the wrong date field is used, making time-series conclusions unreliable. |

---

### A5. Permit numbers are unique enough to support deduping and incremental loads

| Field | Detail |
|-------|--------|
| **Statement** | Permit IDs (permit numbers) are unique enough to act as a stable key for deduping and incremental loads. |
| **Rationale** | The permits dataset is currently treated as permit-level grain, with one unique permit number per permit record. |
| **Validation plan** | Test permit number uniqueness over multi-year samples, identify duplicates, and determine whether duplicates represent revisions or amendments that need an explicit business rule. |
| **Impact if wrong** | Double-counting may inflate activity totals, and incremental refreshes may re-ingest prior records and skew trends. |

---

### A6. Permit category fields are stable enough for coarse historical grouping

| Field | Detail |
|-------|--------|
| **Statement** | Permit category fields are stable enough to support coarse grouping without major historical drift breaking comparisons. |
| **Rationale** | Permit type and label drift over time has already been identified as a major risk, but the MVP still depends on broad category comparison. |
| **Validation plan** | Build a frequency table of category values by year, quantify drift, define a mapping to stable groups, and track the share of unknown or unmapped values. |
| **Impact if wrong** | Composition results may be misleading because observed shifts could reflect taxonomy drift rather than real changes in permit activity. |

---

### A7. Zoning base district annual vintages are accessible as separate endpoints

| Field | Detail |
|-------|--------|
| **Statement** | Zoning base district annual vintages are accessible as separate endpoints and can be fetched year by year in GeoJSON as planned. |
| **Rationale** | The current access approach assumes each target year can be retrieved from a year-specific GeoJSON endpoint. |
| **Validation plan** | Confirm an endpoint exists for each target year, validate the response format, and verify the presence of zoning class and geometry fields. |
| **Impact if wrong** | Missing years or broken endpoints reduce comparability, and year-to-year churn metrics may become incomplete or infeasible. |

---

### A8. Zoning class codes and labels are comparable across years

| Field | Detail |
|-------|--------|
| **Statement** | Zoning class codes and labels are comparable enough across years, or can be normalized enough, to support composition and churn analysis. |
| **Rationale** | Zoning label and schema drift across vintages has already been flagged as a major risk in the MVP dataset selection. |
| **Validation plan** | Compare class code and value sets between consecutive years, document renames and merges, define a mapping strategy, and quantify the unmappable share. |
| **Impact if wrong** | Apparent zoning churn may reflect schema changes rather than real rezoning, making year-to-year comparisons invalid without harmonization. |

---

### A9. ACS tract-level tabular data can be joined to tract geometries via GEOID

| Field | Detail |
|-------|--------|
| **Statement** | ACS tract-level tabular data can be joined reliably to tract geometries via GEOID for the chosen comparison windows. |
| **Rationale** | The ACS ingestion plan depends on separate ACS API and TIGER/Line pulls joined on GEOID. |
| **Validation plan** | Validate GEOID formatting, measure the join match rate, and confirm tract vintage alignment with the ACS periods being used. |
| **Impact if wrong** | Demographic rollups may be incomplete or biased if many tracts fail to join or if tract vintages do not align with the ACS data. |

---

### A10. ACS is suitable as district-level context using non-overlapping 5-year windows

| Field | Detail |
|-------|--------|
| **Statement** | ACS is suitable as district-level context when used with non-overlapping 5-year windows, but not as an annual district trend source. |
| **Rationale** | The MVP plan uses ACS 5-year estimates and explicitly notes that tract-level annual estimates are not available for the target variables. |
| **Validation plan** | Confirm the chosen comparison windows do not overlap, verify the required indicators exist in both windows, and document a standard dashboard disclaimer. |
| **Impact if wrong** | If windows overlap or variables are not comparable, change narratives weaken and demographic outputs may need to be re-scoped or replaced with alternative sources. |

---

## Links

**Related documents:**
- [MVP datasets](./03_mvp_datasets.md)
- [Data access notes](./04_data_access_notes.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-03 | Initial draft      | Farid  |
