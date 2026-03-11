# ACS Income Proxy — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-10
**Metric ID:** acs_income_proxy

---

## Metric Name

**Name:** acs_income_proxy
**One-liner:** Tract-level median household income estimates from ACS 5-year period data, used as a demographic income context indicator for planning districts.

---

## Purpose

How do median household incomes vary across census tracts within and between planning districts? This metric provides income context for each district by surfacing the distribution of tract-level median incomes — not a single district-level KPI, but a tract distribution to be shown in a histogram or comparable visualization.

**Example:**
> What is the distribution of tract-level median household incomes across the tracts within Lower North Philadelphia for the 2020–2024 ACS period?

---

## Numerator / Denominator

**Numerator:** N/A

**Denominator:** N/A

Median household income is a non-additive statistic. It is stored at tract level as-is and surfaced as a distribution. No district-level single-value aggregate is published.

---

## Formula

```
acs_income_proxy = median_hh_income
    (warehouse column in fct_tract_acs; sourced from ACS field DP03_0062E)
```

**Aggregation type:** non-additive (medians cannot be averaged or summed across tracts; district-level aggregation requires special methods outside MVP scope)

**Source field:** `median_hh_income` from `fct_tract_acs` (G4)

**Dashboard surface:** `agg_district_acs_attributes_hist` (G6) — tract-level values aggregated into histogram bins per district, per ACS period.

---

## Grain

**Grain statement:** One census tract per ACS 5-year period snapshot.

*Source table grain (G4):* `fct_tract_acs` — one row per `(geoid_tract, acs_period_label)`

*Dashboard grain (G6):* `agg_district_acs_attributes_hist` — one row per `(district_id, boundary_version_eoy, census_attribute, bin_range)`

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Census Tract | fct_tract_acs | geoid_tract — canonical 11-digit join key |
| Planning District | dim_district | Reached via bridge_tract_district_overlap; tracts may span multiple districts |
| ACS Period | fct_tract_acs | acs_period_label (e.g., "2020–2024"); 5-year estimates only |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_tract_acs | Raw ACS tract-level estimates (G4) | geoid_tract, acs_period_label, median_hh_income, median_hh_income_moe |
| bridge_tract_district_overlap | Tract → district spatial bridge (G3) | geoid_tract, district_id, boundary_version, pct_tract_area |
| agg_district_acs_attributes_hist | Pre-aggregated histogram rollup (G6) | district_id, census_attribute, bin_range, tract_count |
| dim_district | District lookup | district_id, district_name |

---

## Test Ideas

- [ ] No null values in `median_hh_income` for tracts in the Philadelphia 5-county area (flag but do not drop nulls — some tracts legitimately suppress median income)
- [ ] MOE column (`median_hh_income_moe`) is retained and non-null for all rows with non-null estimates
- [ ] Only non-overlapping ACS periods are compared in any dashboard or analysis output
- [ ] ACS period label is present and matches the vintage year in all fct_tract_acs rows
- [ ] Histogram bin counts in agg_district_acs_attributes_hist sum to the correct number of tracts per district

---

## Caveats / Limitations

- **Non-additive:** Median household income cannot be averaged or summed across tracts. District-level medians require special aggregation (e.g., interpolation from grouped data) that is outside MVP scope. Publish tract distributions only.
- **Period estimates, not point-in-time:** ACS 5-year estimates represent an average across the collection period. The label "2020–2024" does not reflect conditions in 2024 specifically.
- **Non-overlapping periods only:** Only compare ACS periods that do not overlap (e.g., 2015–2019 vs 2020–2024). Overlapping period comparisons are statistically invalid; see [ACS usage policy](../policies/acs_usage_policy.md).
- **MAUP risk at district boundaries:** Tracts straddling planning district boundaries are allocated via area-weighted interpolation, which assumes uniform population distribution within tracts. Districts near boundaries with large split tracts carry higher uncertainty; see [ACS to district alignment note](../feasibility/acs_to_district_alignment_note.md).
- **MOE must be retained:** Margin of error (`median_hh_income_moe`) must be stored in the mart and available for analysts; do not suppress it.
- **Income suppression:** The Census Bureau suppresses median income estimates for tracts with small populations. Suppressed values (typically coded as -666666666 or null in the API) must be treated as missing, not zero.

---

## Links

**Related Metrics:**
- [ACS tenure proxy](./acs_tenure_proxy.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md) — G4, G6
- [Table inventory](../modeling/table_inventory.md)
- [ACS usage policy](../policies/acs_usage_policy.md)
- [ACS to district alignment note](../feasibility/acs_to_district_alignment_note.md)
- [ACS critical fields dictionary](../data_dictionary/acs_critical_fields.md)
- [ACS source catalog](../source_catalog/acs_context.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
| 2026-03-10 | Reconciliation: aligned district_key → district_id per column_contracts.md | Farid |
| 2026-03-10 | Reconciliation: G6 dashboard grain — boundary_version → boundary_version_eoy (aligns with corrected G6 PK in grain_spec.md) | Farid |
| 2026-03-10 | Reconciliation: replaced raw ACS field codes with SC4 warehouse column names — DP03_0062E → median_hh_income, DP03_0062M → median_hh_income_moe | Farid |
| 2026-03-10 | Full reconciliation: remaining DP03_0062E/M references in test ideas and caveats replaced with warehouse column names | Farid |
