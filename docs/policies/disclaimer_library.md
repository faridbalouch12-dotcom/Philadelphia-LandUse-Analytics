# Standard Disclaimer Library

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Final

---

## Purpose

This library provides copy-paste ready disclaimer sentences and forbidden-claim examples for use in dashboards, metric specs, and documentation. All disclaimers are grounded in documented policies and metric specs. Any ACS or zoning output surfaced in the product must use language consistent with this library.

---

## Standard Disclaimers

### D-ACS-1 — ACS Period Estimate (full)

> Demographic data shown here are 5-year period estimates from the U.S. Census Bureau's American Community Survey (ACS). Five-year estimates are used because 1-year estimates are not available at the census tract level required for planning-district context. These estimates represent averages across surveys conducted over multiple years and do not reflect conditions in any single year. Only non-overlapping ACS periods should be compared (e.g., 2015–2019 vs 2020–2024); overlapping periods are not valid to compare. ACS values are presented as tract-level distributions for district context and do not establish that demographic conditions caused changes in permit activity.

*Source: [ACS usage policy](./acs_usage_policy.md)*

---

### D-ACS-2 — ACS Non-Overlapping Comparison (short)

> ACS estimates shown are from non-overlapping 5-year periods. Comparing overlapping periods (e.g., 2019–2023 vs 2020–2024) is statistically invalid and not supported by this platform.

*Source: [ACS usage policy](./acs_usage_policy.md)*

---

### D-ACS-3 — Tract-Level Distribution (short)

> ACS values shown reflect the distribution of census tract estimates within this district. They are not aggregated district-level figures. Tract estimates include margins of error; small differences between tracts or districts may not be statistically meaningful.

*Source: [ACS usage policy](./acs_usage_policy.md); [ACS income proxy spec](../metrics/acs_income_proxy.md)*

---

### D-ZONING-1 — YoY Comparison Validity

> Year-over-year zoning composition comparisons are valid only when the zoning code vocabulary is confirmed stable between the two years being compared. District-year pairs flagged as potentially unstable (`vocab_stable = FALSE`) may reflect code renaming or reclassification rather than actual rezoning activity.

*Source: [Zoning comparability plan](../zoning_comparability_plan.md)*

---

### D-PERMITS-1 — Permit Issuance Lag

> Permit counts reflect the date a permit was issued, not the date construction began or was completed. There is a time lag between permit issuance and actual construction activity. Counts for a given month represent administrative issuance volume, not ground-truth construction output.

*Source: [Permits monthly count spec](../metrics/permits_monthly_count.md)*

---

## Forbidden Claims

The following phrasings are prohibited in any product output, documentation, or narrative. Each example is paired with an acceptable alternative.

| # | Forbidden claim | Why prohibited | Acceptable alternative |
|---|----------------|----------------|------------------------|
| FC-1 | "The median household income in [District X] is $Y." | ACS median income is not aggregatable to a single district value; a district-level median cannot be derived by averaging tract medians. | "Tract-level median household incomes within [District X] range from $A to $B (ACS 2020–2024, N tracts)." |
| FC-2 | "Demographic change drove permit activity in [District X]." | ACS is descriptive context only; causal attribution between demographics and permit activity is out of scope and unsupported by this dataset pairing. | "During the same period, permit activity in [District X] increased alongside a shift in the tract-level income distribution (ACS 2020–2024)." |
| FC-3 | "Zoning changed by X% in [District X] from [Year N] to [Year N+1]." (when `vocab_stable = FALSE`) | YoY comparison is invalid when code vocabulary differs between vintages; apparent change may be a schema artifact. | "Zoning composition data for this district-year pair is flagged for potential code vocabulary differences and may not reflect actual rezoning. See the comparability plan." |
| FC-4 | "Construction activity surged in [Month]." | Permit counts reflect issuance, not construction. Framing as construction activity conflates administrative records with physical work. | "Permit issuance volume increased in [Month], which may indicate elevated construction activity with a typical issuance-to-start lag." |
| FC-5 | "Based on ACS data, [District X] became more affordable between [Year A] and [Year B]." (when periods overlap) | Overlapping ACS periods (e.g., 2019–2023 vs 2020–2024) share survey respondents; observed differences are not reliable signals of real change. | Only non-overlapping periods (e.g., 2015–2019 vs 2020–2024) may be compared. If the periods overlap, suppress the comparison entirely. |

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|-----------------|
| A1 | The ACS usage policy and zoning comparability plan remain the authoritative governance documents for ACS and zoning claims. | If either policy is revised, this library must be updated; stale disclaimers may understate or overstate limitations. |
| A2 | Dashboard copy and tooltips will be authored with access to this library and will apply disclaimers consistently. | If dashboards use ad hoc wording, forbidden claim patterns may slip through without this library's guardrails. |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | New metric specs are added without reviewing the forbidden claims list, leading to dashboard copy that violates the prohibitions. | Medium | Medium | Add a "check disclaimer library" step to the metric spec review checklist; link from metric spec template. |
| R2 | Disclaimer text becomes outdated as ACS periods advance (e.g., 2020–2024 period is superseded). | Low | Low | Period labels in D-ACS-1 and D-ACS-2 are illustrative; update when actual ACS periods are finalized in Month 2 ingestion. |

---

## Links

**Governing policies:**
- [ACS usage policy](./acs_usage_policy.md)
- [Land-area denominator policy](./land_area_denominator_policy.md)

**Related metric specs:**
- [Permits monthly count](../metrics/permits_monthly_count.md)
- [ACS income proxy](../metrics/acs_income_proxy.md)
- [ACS tenure proxy](../metrics/acs_tenure_proxy.md)
- [Zoning composition by year](../metrics/zoning_composition_by_year.md)
- [Zoning year-to-year churn](../metrics/zoning_year_to_year_churn.md)

**Comparability plan:**
- [Zoning comparability plan](../zoning_comparability_plan.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial library created (Task 14.3): 5 standard disclaimers, 5 forbidden claims | Farid  |
