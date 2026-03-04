# MVP datasets

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This document lists the four MVP datasets selected for the Philadelphia district-level data warehouse. Each entry documents purpose, time coverage, cadence, geometry type, and top risks. This constrains the project scope to sources that directly support the MVP questions and prevents scope creep in Weeks 2–4.

---

## Scope

**In Scope:** The four datasets required for MVP analysis — district spine, permit activity, zoning snapshots, and demographic context.

**Out of Scope:** Any additional datasets not listed here. Extensions (e.g., additional ACS indicators, parcel-level data) are deferred to future months.

---

## Datasets

### 1. Planning districts (S1)

**Description:** Outlines of the 18 districts for Philadelphia2035 District Plans, maintained by the Philadelphia City Planning Commission.

| Field | Detail |
|-------|--------|
| **Purpose** | The spine of the entire analysis. Every metric is calculated at the district level — permits, zoning, and demographic context are all rolled up to these 18 districts. |
| **Time coverage** | Static. Last updated 2015-05-26; marked "as needed." Boundaries are treated as fixed for the MVP period. |
| **Cadence** | No regular update cycle. Boundary changes are rare and would require a versioning strategy if they occur. |
| **Geometry type** | Polygons (district boundaries) |

**Top risks:**

| ID | Risk |
|----|------|
| R1 | District boundaries have not been updated since 2015. Permits, zoning polygons, and census tracts from earlier or later periods may not align perfectly with these boundaries. |
| R2 | Permits and census tracts assigned to districts via spatial join may straddle boundary edges, introducing uncertainty in district-level aggregations. |
| R3 | If boundaries are ever revised, all downstream rollups become incomparable to prior periods without reprocessing. |

---

### 2. L&I building and zoning permits (S2)

**Description:** Permit, license, inspection, case and violation data from the Department of Licenses & Inspections. Covers new constructions, alterations, demolitions, occupancy changes, and mechanical/electrical/plumbing installations. Each permit has a unique permit number, application type, permit code, description of work, status, and contact information.

| Field | Detail |
|-------|--------|
| **Purpose** | The primary fact table for the warehouse. Tracks physical change activity across districts over time, enabling analysis of permit volume, composition, and density by district and month. |
| **Time coverage** | 2007–present |
| **Cadence** | Updated daily |
| **Geometry type** | Points (geocoded to permit addresses) |

**Top risks:**

| ID | Risk |
|----|------|
| R1 | Permits are geocoded to addresses. Addresses near district boundaries cannot be cleanly assigned to a single district, introducing uncertainty in district-level aggregations. |
| R2 | New permit types may have been introduced over the 15+ year history of the dataset. Comparing counts of a permit type that did not exist in earlier years to recent counts produces misleading trend analysis. |
| R3 | Category label drift — the same underlying permit type may have been described with different text values across years (e.g., "Res" vs. "Residential"), breaking downstream grouping and comparison logic. |

---

### 3. Zoning base districts (S3)

**Description:** Polygon boundaries of the City of Philadelphia's zoning base districts at multiple points in time. Includes one pre-code layer (before August 2012) and multiple vintage layers after the new zoning code became effective on August 22, 2012. Data updates for the current layer are ongoing through 2025.

| Field | Detail |
|-------|--------|
| **Purpose** | Enables year-to-year zoning composition and churn analysis across districts. By comparing vintages, we can track how the zoning mix within each district has changed over time. |
| **Time coverage** | 2012–2025 (post new zoning code; pre-2012 vintage available but excluded from MVP) |
| **Cadence** | Annual vintage snapshots available |
| **Geometry type** | Polygons (zoning district boundaries) |

**Top risks:**

| ID | Risk |
|----|------|
| R1 | Zoning category label drift across vintages — the same zoning class may be represented with different text values in different years, breaking year-to-year comparisons. |
| R2 | District boundary changes between vintages mean that a property's district assignment may change over time, making year-to-year composition comparisons misleading without accounting for boundary shifts. |
| R3 | Schema inconsistency across vintages — column names, data types, or available fields may differ between yearly layers, breaking joins or automated ingestion pipelines. |

---

### 4. ACS demographic context (D1)

**Description:** The American Community Survey (ACS) provides detailed social, housing, economic, and demographic data at the census tract level. The 5-year estimate is the only ACS product available at census tract geography, as 1-year estimates require a population of 65,000+.

| Field | Detail |
|-------|--------|
| **Purpose** | Adds demographic context to district-level permit and zoning analysis. Enables statements like "districts with higher median income in period X had higher/lower permit activity." ACS is used as context only — not as a causal explanation for permit trends. |
| **Time coverage** | MVP windows: 2012–2016 and 2017–2021 (non-overlapping 5-year estimates) |
| **Cadence** | New 5-year estimates released annually, but valid comparisons can only be made between non-overlapping windows (every 5 years). |
| **Geometry type** | Polygons (census tract boundaries) |

**Top risks:**

| ID | Risk |
|----|------|
| R1 | Comparing overlapping 5-year windows is statistically invalid. Consecutive annual releases share 4 years of underlying data, making any observed difference indistinguishable from sampling noise. Only non-overlapping windows (e.g., 2012–2016 vs. 2017–2021) are valid to compare. |
| R2 | 5-year estimates are the only option at census tract geography. This limits temporal granularity — we cannot track annual demographic shifts, only 5-year averages. |
| R3 | Census tracts that straddle planning district boundaries cannot be cleanly assigned to a single district, introducing uncertainty in district-level demographic aggregations. |

---

## References

- **[S1]** City of Philadelphia / ArcGIS. *Planning Districts (Feature Layer)*. See [Resources](../.claude/resources.md) for full details.
- **[S2]** OpenDataPhilly. *L&I Building and Zoning Permits*. See [Resources](../.claude/resources.md) for full details.
- **[S3]** City of Philadelphia / ArcGIS. *Zoning Base Districts*. See [Resources](../.claude/resources.md) for full details.
- **[D1]** U.S. Census Bureau. (2022). *Period Estimates in the American Community Survey*. See [Resources](../.claude/resources.md) for full details.

---

## Links

**Related documents:**
- [Scope memo](./00_scope_memo.md)
- [Problem statement](./01_problem_statement.md)
- [Glossary](./glossary.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-03 | Initial draft      | Farid  |
