# Data Dictionary — ACS Demographic Context (D1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header
- Dataset name: ACS 5-Year Data Profiles (Census Data API)
- Dataset ID (e.g., S1/S2/S3/D1): D1
- Source page / endpoint: https://api.census.gov/data/2024/acs/acs5/profile
- Reviewer: Farid
- Date: 2026-03-05
- MVP role (district spine / permits fact / zoning snapshots / ACS context): ACS context

---

## Field Dictionary

| Field name | Meaning | Required? | Expected type | Common null/invalid patterns | Notes |
|---|---|---|---|---|---|
| `acs_vintage_year` | ACS release year (endpoint year) | Yes | integer | missing/not set | Store explicitly. Used for comparisons and lineage. |
| `acs_period_label` | Human-readable 5-year window label (e.g., `2020–2024`) | Yes | string | inconsistent label vs vintage | Required for dashboard text and “non-overlap” validation rules. |
| `GEO_ID` | Census API prefixed tract identifier | Yes | string | missing prefix; malformed | Parse to get tract GEOID; keep raw value for traceability. |
| `state` | State FIPS | Yes | string | wrong length; numeric cast drops zeros | Keep as string. PA is `42`. |
| `county` | County FIPS | Yes | string | wrong length; numeric cast drops zeros | Keep as string. Philadelphia County is `101` (full FIPS 42101). |
| `tract` | Tract code | Yes | string | wrong length; missing zeros | Keep as string (typically 6 digits). |
| `geoid_tract` | 11-digit tract GEOID (`state+county+tract`) | Yes | string | bad concatenation/zero padding | Canonical join key to tract polygons and crosswalk table. |
| `NAME` | Tract label | No | string | inconsistent naming | Display only; do not use as a key. |
| `DP05_0001E` | Total population (estimate) | Yes | integer | null; non-numeric strings | Additive with tract→district weighting (approximate). |
| `DP02_0001E` | Total households (estimate) | Yes | integer | null; non-numeric | Additive with tract→district weighting; useful denominators. |
| `DP03_0062E` | Median household income (estimate) | No (recommended) | integer | null; 0; non-numeric | Non-additive; district values require special handling or should be left as tract-only. |
| `DP04_0047E` | Renter-occupied housing units (estimate) | No | integer | null; non-numeric | Additive with weighting; can derive renter share with appropriate denominator. |
| `DP04_0045E` | Occupied housing units (estimate) | No | integer | null; non-numeric | Denominator for renter share if you compute rates. |
| `DP02_0068E` | BA+ count (population 25+) | No | integer | null; non-numeric | Use with `DP02_0059E` as denominator to compute district share. |
| `DP02_0059E` | Population 25+ | No | integer | null; non-numeric | Denominator for education share. |

---

## Required Fields Summary (MVP)

- **Time / period fields:** `acs_vintage_year`, `acs_period_label`
- **Key / ID fields:** `geoid_tract` (canonical join key), `GEO_ID` (raw, for traceability), `state`, `county`, `tract`
- **Display:** `NAME` (display only, not a join key)
- **MVP measures:** `DP05_0001E` (population), `DP02_0001E` (households), `DP03_0062E` (median income), `DP04_0047E` + `DP04_0045E` (renter share), `DP02_0068E` + `DP02_0059E` (education share)

---

## Notes
- Prefer pulling **counts (…E)** so district-level rates can be recomputed from aggregated numerator/denominator.
- Do not aggregate tract percentages directly.
- Medians are not additive; publish tract medians or label any district approximation explicitly.

---

## Links

- **Source catalog entry:** [`docs/source_catalog/acs_context.md`](../source_catalog/acs_context.md)
- **Methodology summary:** [`docs/source_catalog/acs_context_methodology_summary.md`](../source_catalog/acs_context_methodology_summary.md)
- **Feasibility checklist:** [`docs/feasibility/acs_feasibility.md`](../feasibility/acs_feasibility.md)
- **ACS usage policy:** [`docs/policies/acs_usage_policy.md`](../policies/acs_usage_policy.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
