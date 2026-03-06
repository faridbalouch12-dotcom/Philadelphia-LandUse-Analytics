# Source Catalog — ACS Demographic Context (D1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Overview
**What it is:** ACS 5-year tract-level demographic, social, economic, and housing profile estimates (Data Profiles DP02–DP05).  
**Project relevance:** Provides **district-level demographic context** to accompany permits (physical change) and zoning (regulatory change).  
**Intended outputs:** tract staging table; district-level rollup table(s) by ACS period; optional tract map layer once joined to tract polygons.

---

## Access
- **Primary source/host:** U.S. Census Bureau — Census Data API (ACS 5-year Data Profiles)
- **Access method(s):** HTTPS JSON API
- **Preferred method for this project:** Pull all **Philadelphia County tracts** via `for=tract:*&in=state:42 county:101`
- **Known limits:** API variable limits per request may require batching; API key recommended for reliability.
- **Expected size / volume notes:** ~hundreds of tract rows × selected variables (manageable).

**Base endpoint (example 2024 vintage):**
- `https://api.census.gov/data/2024/acs/acs5/profile`

---

## Time Fields
- **Candidate time fields:** None in-record.
- **Canonical time for the project:** `acs_vintage_year` (from endpoint year) + `acs_period_label` (e.g., `2020–2024`).
- **Time semantics:** 5-year **period estimate** (rolling multi-year average), not annual point estimate.
- **Time coverage:** choose non-overlapping vintages for comparisons (e.g., 2015–2019 vs 2020–2024).
- **Time granularity supported:** period/window only.

---

## Geometry
- **Geometry type:** None returned by API (tabular).
- **How geometry is obtained:** join to tract polygons (TIGER/Line or equivalent) using tract GEOID.
- **Spatial linkage role:** tract→district overlay/crosswalk to aggregate tract estimates to planning districts.

---

## Keys
- **Candidate primary key(s):** (`acs_vintage_year`, `geoid_tract`)
- **Candidate raw key fields:** `GEO_ID` (prefixed), or composite `state` + `county` + `tract`
- **Uniqueness confidence:** high (one row per tract per vintage)

---

## Key Columns
- **Required identifiers:** `state`, `county`, `tract`, derived `geoid_tract`, `GEO_ID`
- **Display:** `NAME` (display only)
- **Measures:** curated variable pack (DP02/DP03/DP04/DP05 estimates)

---

## Update Cadence
- **Cadence:** annual release of new 5-year vintages.
- **History changes:** values may be revised across releases; treat each vintage as a separate snapshot.
- **Implication for the project:** demographic context will update annually at most.

---

## Risks
- Overlapping-window comparisons are invalid/noisy (consecutive 5-year releases share most years).
- Tracts straddle planning district boundaries → district aggregation is approximate and depends on weighting.
- Many variables are non-additive (medians; rates/percentages without numerator/denominator counts).
- MVP omits MOE; small differences should not be over-interpreted.

---

## Notes
- Prefer **counts (…E)** for aggregation; recompute district rates from aggregated numerator/denominator.
- Keep medians, but label any district-level medians as **approximate** unless computed from distributions.
- Follow the project’s ACS usage policy and standard disclaimer language.

---

## Links

**External sources:**
- ACS base landing: https://api.census.gov/data/2024/acs.html
- Dataset endpoint: https://api.census.gov/data/2024/acs/acs5/profile.html
- Variables list: https://api.census.gov/data/2024/acs/acs5/profile/variables.html
- Groups: [DP02](https://api.census.gov/data/2024/acs/acs5/profile/groups/DP02.html) | [DP03](https://api.census.gov/data/2024/acs/acs5/profile/groups/DP03.html) | [DP04](https://api.census.gov/data/2024/acs/acs5/profile/groups/DP04.html) | [DP05](https://api.census.gov/data/2024/acs/acs5/profile/groups/DP05.html)

**Internal project docs:**
- **Methodology summary:** [`docs/source_catalog/acs_context_methodology_summary.md`](./acs_context_methodology_summary.md)
- **Feasibility checklist:** [`docs/feasibility/acs_feasibility.md`](../feasibility/acs_feasibility.md)
- **Critical fields dictionary:** [`docs/data_dictionary/acs_critical_fields.md`](../data_dictionary/acs_critical_fields.md)
- **ACS usage policy:** [`docs/policies/acs_usage_policy.md`](../policies/acs_usage_policy.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
