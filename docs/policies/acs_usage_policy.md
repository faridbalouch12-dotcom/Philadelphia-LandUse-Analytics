# ACS usage policy

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-08
**Status:** Draft

## Purpose

This policy defines how the American Community Survey (ACS) is used in the Philadelphia Planning District Change Explorer so demographic context is presented accurately and consistently, without overstating precision or implying causation.

---

## What ACS is used for

ACS is used for demographic and housing context at tract grain, grouped by planning district for dashboard interactions.

Specifically, ACS is used to:
- Provide bookend context snapshots using 5-year ACS period estimates (e.g., 2015-2019 vs 2020-2024).
- Support dashboard context panels and district hover interactions via tract-level distributions (income, tenure, education, etc.).
- Enable before/after comparisons only when the two periods are non-overlapping.

---

## What ACS is not used for

ACS is not used to:
- Produce an annual district time series within a 5-year window (ACS 5-year estimates are period averages, not yearly point estimates).
- Use 1-year ACS estimates for tract-level or planning-district-level analysis (1-year estimates are not available at tract geography and therefore cannot support this use case).
- Normalize MVP development intensity metrics (permits are normalized by land-only area in MVP; ACS is context-only).
- Publish single-value district-level ACS aggregates as official KPI metrics.
- Support causal claims (e.g., "demographic change caused permit activity to increase"). ACS is descriptive context and operates at a different temporal grain than permits.
- Compare overlapping 5-year periods (e.g., 2019-2023 vs 2020-2024), because overlap makes observed differences statistically unreliable.

---

## Required standards for dashboards and docs

1. **5-year estimates only** - All ACS values shown in the product must be from ACS 5-year period estimates.
2. **Period labeling is mandatory** - Every dashboard tile/table/tooltip that displays ACS data must include the exact collection period label (e.g., "ACS Period Estimate Used: 2020-2024").
3. **Only non-overlapping comparisons** - If a dashboard or document shows ACS change over time, it must use non-overlapping periods only (e.g., 2015-2019 vs 2020-2024).
4. **Tract-level presentation for district interactions** - Dashboard ACS panels must show tract-level distributions (ranges, bins, tract counts), not single-value district ACS KPIs.
5. **MOE-aware interpretation** - Tract-level MOE columns must be available in the warehouse mart, and UI/docs must avoid treating raw MOEs as aggregated comparison uncertainty.
6. **No causal language** - Any narrative content must avoid causal wording. Use phrasing like "alongside," "in the same period," or "as context."

---

## Standard disclaimer sentence (copy/paste)

> Demographic data shown here are 5-year period estimates from the U.S. Census Bureau's American Community Survey (ACS). Five-year estimates are used because 1-year estimates are not available at the census tract level required for planning-district context. These estimates represent averages across surveys conducted over multiple years and do not reflect conditions in any single year. Only non-overlapping ACS periods should be compared (e.g., 2015-2019 vs 2020-2024); overlapping periods are not valid to compare. ACS values are presented as tract-level distributions for district context and do not establish that demographic conditions caused changes in permit activity.

---

## Links

- ACS period-estimates notes: [`notes/data-sources/acs_period_estimates_notes.md`](../../notes/data-sources/acs_period_estimates_notes.md)
- Limitations register: [`docs/limitations_register.md`](../limitations_register.md)
- Decision log: [`docs/decision_log.md`](../decision_log.md)

---

## References

- **[D1]** U.S. Census Bureau. *American Community Survey: Period Estimates*. See [Resources](../../.claude/resources.md).
- **[D2]** U.S. Census Bureau. *ACS Guidance on Comparing Estimates*. See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-08 | Aligned policy with D8-D10: tract-level distribution presentation, MOE retention, and explicit no single-value district ACS KPI rule | Farid |
