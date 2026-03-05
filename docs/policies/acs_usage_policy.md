# ACS usage policy

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

## Purpose

This policy defines how the American Community Survey (ACS) is used in the Philadelphia Planning District Change Explorer so demographic context is presented accurately and consistently, without overstating precision or implying causation. This policy is grounded in the project's ACS period-estimate notes.

---

## What ACS is used for

ACS is used for **district-level demographic and housing context** to accompany the district-first physical/regulatory change metrics.

Specifically, ACS is used to:
- Provide **bookend snapshots** of demographic context using **5-year ACS period estimates** (e.g., 2015–2019 vs 2020–2024) for planning-district summaries.
- Support **context panels** in dashboards and district briefs (e.g., income proxy, tenure proxy such as owner vs renter share).
- Enable **before/after comparisons** only when the two periods are **non-overlapping**.

---

## What ACS is not used for

ACS is not used to:
- Produce an **annual district time series** within a 5-year window (ACS 5-year estimates are period averages, not yearly point estimates).
- Use **1-year ACS estimates** for tract-level or planning-district-level analysis (1-year estimates are not available at tract geography and therefore cannot support district aggregation at the needed level).
- Normalize MVP "development intensity" metrics (permits are normalized by land-only area in the MVP; ACS is context-only).
- Support **causal claims** (e.g., "demographic change caused permit activity to increase"). ACS is descriptive context and operates at a different temporal grain than permits.
- Compare **overlapping** 5-year periods (e.g., 2019–2023 vs 2020–2024), because overlap makes observed differences statistically unreliable.

---

## Required standards for dashboards and docs

1. **5-year estimates only** — All ACS values shown in the product must be from ACS 5-year period estimates.
2. **Period labeling is mandatory** — Every dashboard tile/table/tooltip that displays ACS data must include the exact collection period label (e.g., "ACS Period Estimate Used: 2020–2024").
3. **Only non-overlapping comparisons** — If a dashboard or document shows change over time using ACS, it must use non-overlapping periods only (e.g., 2015–2019 vs 2020–2024).
4. **No causal language** — Any narrative content must avoid causal wording. Use phrasing like "alongside," "in the same period," or "as context."

---

## Standard disclaimer sentence (copy/paste)

> Demographic data shown here are 5-year period estimates from the U.S. Census Bureau's American Community Survey (ACS). Five-year estimates are used because 1-year estimates are not available at the census tract level required for planning-district analysis. These estimates represent averages across surveys conducted over multiple years and do not reflect conditions in any single year. Only non-overlapping ACS periods should be compared (e.g., 2015–2019 vs 2020–2024); overlapping periods are not valid to compare. ACS data is provided as context only and does not establish that demographic conditions caused changes in permit activity.

---

## Links

- ACS period-estimates notes: [`notes/acs_period_estimates_notes.md`](../../notes/acs_period_estimates_notes.md)
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
