# ACS Uncertainty Messaging Notes (MOE-Aware)

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

ACS estimates are derived from a sample survey, not a full enumeration. Every estimate carries a margin of error (MOE) that quantifies the uncertainty band around the reported value. This note documents three reusable disclaimer sentences for dashboards and reports, and two examples of claims the project will not make, grounded in how MOEs behave across three scenarios: single-district trends, cross-district comparisons, and overlapping period comparisons.

---

## Background: Why MOE Matters for This Project

ACS 5-year estimates report a single number (e.g., median household income = $52,400) alongside a margin of error (e.g., ±$2,800 at the 90% confidence level). The reported number is the Census Bureau's best estimate from the sample — but the true value could be anywhere within that band.

Three scenarios where this matters for district-level analysis:

**1. Single-district, year-over-year change**
A change smaller than the MOE is statistically indistinguishable from zero. A district's median income rising from $52,400 to $53,900 (a $1,500 change) against a ±$3,000 MOE is noise, not signal.

**2. Cross-district comparison**
When comparing two districts, the uncertainty of the *difference* between them is larger than either MOE alone. The Census Bureau's formula for the MOE of a difference is approximately √(MOE_A² + MOE_B²). If both districts have ±$3,000 MOE, the MOE on the difference is ~±$4,243. A $3,000 gap between districts is entirely within that band — the ranking cannot be treated as definitive.

**3. Overlapping period comparison**
ACS 5-year estimates spanning overlapping periods (e.g., 2018–2022 vs. 2019–2023) share four years of underlying survey data. Any observed difference between them cannot be reliably attributed to real change — most of the data is the same. The Census Bureau advises against comparing overlapping 5-year estimates.

---

## Reusable Disclaimers

**D1 — Single-district trend disclaimer (for time-series charts):**
> "Year-over-year changes in ACS estimates smaller than the reported margin of error should not be interpreted as real change. Only differences that exceed the MOE indicate a potentially meaningful trend."

**D2 — Cross-district comparison disclaimer (for ranking tables and maps):**
> "Differences between planning districts in ACS-derived indicators may not be statistically significant. When the gap between two districts is smaller than the combined margin of error, the ranking should be treated as approximate, not definitive."

**D3 — Period estimate disclaimer (for all ACS indicators):**
> "All demographic figures are ACS 5-year period estimates covering a multi-year window, not a snapshot of a single year. Comparisons should only be made between non-overlapping periods (e.g., 2015–2019 vs. 2020–2024)."

---

## Bad Claims to Avoid

**BC1 — Claiming real year-over-year change without checking MOE:**
> ❌ "Median household income in Kensington increased from $28,400 to $30,100 between the 2019–2023 and 2020–2024 estimates, indicating rising incomes."

*Why it's wrong:* The two periods overlap by four years, making any observed difference statistically unreliable. Even if the periods were non-overlapping, a $1,700 change would need to exceed the MOE to be meaningful.

**BC2 — Ranking districts as definitively wealthier or poorer:**
> ❌ "Lower North Philadelphia has a higher median household income than Kensington, making it a wealthier district."

*Why it's wrong:* If the gap between the two estimates ($58,000 vs. $55,000) is smaller than the combined MOE of the difference (~±$4,000+), the true values could be reversed. A definitive ranking claim requires the difference to exceed the combined uncertainty band.

---

## Links

- **ACS source catalog:** [`docs/source_catalog/acs_context.md`](../docs/source_catalog/acs_context.md)
- **ACS methodology summary:** [`docs/source_catalog/acs_context_methodology_summary.md`](../docs/source_catalog/acs_context_methodology_summary.md)
- **ACS usage policy:** [`docs/policies/acs_usage_policy.md`](../docs/policies/acs_usage_policy.md)
- **ACS critical fields dictionary:** [`docs/data_dictionary/acs_critical_fields.md`](../docs/data_dictionary/acs_critical_fields.md)
- **Limitations register:** [`docs/limitations_register.md`](../docs/limitations_register.md)

---

## Change Log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial draft      | Farid  |
