# Compare Districts — View Spec (MVP)

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

This spec defines the **Compare Districts** view — a cross-district ranking and comparison surface that lets users see how Philadelphia's 18 planning districts stack up against each other on the MVP metrics.

The Compare Districts view is a companion to the district brief. Where the district brief provides depth on a single district, the Compare Districts view provides breadth across all 18.

---

## Scope

**In scope:**
- Metric list for the comparison view
- Ranking direction for each metric
- Required caveats and what the view must not show
- Interaction model (how a user navigates to a district brief from here)

**Out of scope:**
- Visual design (implementation phase)
- Statistical testing of rank differences (out of scope for MVP)
- Parcel-level or block-level breakdowns
- ACS cross-district ranking (prohibited — see caveats below)

---

## Audience

Same as the district brief: planners, advocates, journalists, residents. Users who want to answer "which districts are most active?" or "how does my district compare?"

---

## Metric list

The Compare Districts view includes the following metrics, one row per district, sortable by any column:

| Metric | Spec | Aggregation displayed | Ranking direction |
|--------|------|-----------------------|-------------------|
| Total permits issued (last 12 months) | [permits_monthly_count](../metrics/permits_monthly_count.md) | Sum of monthly counts over trailing 12 months | Higher = more active |
| Permits per land sq mi (last 12 months) | [permits_per_sqmi_land](../metrics/permits_per_sqmi_land.md) | Average monthly intensity over trailing 12 months | Higher = more intense |
| Dominant permit type | [permits_composition](../metrics/permits_composition.md) | Largest permit type group share over trailing 12 months | No ranking; displayed as label |
| Zoning: % residential (most recent vintage) | [zoning_composition_by_year](../metrics/zoning_composition_by_year.md) | `pct_district_area` for "Residential" group, most recent valid vintage | Higher = more residential |
| Zoning: net residential change (last 2 valid vintages) | [zoning_year_to_year_churn](../metrics/zoning_year_to_year_churn.md) | Change in residential `pct_district_area` between two most recent `vocab_stable = TRUE` vintage pairs | Positive = increased; Negative = decreased |

**ACS metrics are excluded from the comparison ranking table.** ACS context (income, tenure) is available in each district's brief. Ranking districts by ACS indicators would imply a precision and comparability that tract-level distribution data does not support at the district level.

---

## Required caveats for this view

The Compare Districts view must display the following persistent caveats at the top or in a collapsible info panel:

1. **Permit intensity is normalized by land area, not population.** Districts with larger land area and lower density may show lower intensity even if they have more total permits. Use the total count and intensity together.

2. **Zoning comparisons reflect official zoning classifications, not actual land use.** A district classified as "residential" may have significant commercial activity and vice versa.

3. **Zoning comparisons for any district-year pair flagged `vocab_stable = FALSE` are suppressed.** If the most recent valid vintage pair is older than 2 years, the district's churn value is shown as "N/A — vocabulary flag."

4. **ACS demographic indicators are not shown in this view.** Ranking districts by ACS context would misrepresent the precision of tract-level period estimates. See each district's brief for demographic context.

5. **Permit counts reflect issuance date, not construction completion.** (D-PERMITS-1)

---

## What the Compare Districts view must not show

| Prohibited | Reason |
|------------|--------|
| A ranking of districts by "median income" or any single ACS KPI | ACS median income is not aggregatable to a district-level single value; violates D10 and FC-1 |
| Zoning change values for `vocab_stable = FALSE` pairs | YoY comparison is invalid; violates D-ZONING-1 |
| A "most improved" or "most at risk" label derived from any metric | Causal and evaluative framing is out of scope for MVP; the view is descriptive only |
| Permit intensity summed across districts | `permits_per_sqmi_land` is non-additive; a citywide total is meaningless |

---

## Interaction model

- Each row in the comparison table is clickable and navigates to that district's brief.
- Users can sort by any metric column.
- A district filter allows removing specific districts from the comparison (e.g., to compare a subset of neighboring districts).
- A time period selector controls the trailing window for permit metrics (default: last 12 months).

---

## Assumptions

| ID | Assumption | Impact if Wrong | Mitigation |
|----|------------|-----------------|------------|
| A1 | All 18 districts have at least one valid zoning vintage pair (`vocab_stable = TRUE`) in the 5-year window | Some districts may show "N/A" for all churn metrics | Show "N/A — vocabulary flag" prominently; do not hide or interpolate |
| A2 | Permit totals and intensity values will be materially non-zero for all 18 districts over a 12-month window | Very low-activity districts may look identical at small scales | Add a note if a district has fewer than 10 permits in the trailing 12 months |
| A3 | Users understand that ranking by intensity ≠ ranking by absolute count | Users may mis-rank high-intensity but small districts | Display both columns side-by-side; add tooltip explaining the difference |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | Implementation adds ACS metrics to the comparison table for completeness | Medium | High | Reference this spec explicitly during implementation; D10 prohibits district-level ACS KPIs |
| R2 | Non-technical users interpret ranking position as a judgment about district quality or desirability | Medium | Medium | Use neutral column headers ("permit volume," not "construction activity"); add plain-language framing note |
| R3 | Zoning `vocab_stable` flagging causes many districts to show "N/A," making the churn column less useful | Low | Medium | Surface the issue in the limitations register and product notes; flag as a Month 2 EDA priority |

---

## Links

- District brief spec: [`docs/product/district_brief_spec.md`](./district_brief_spec.md)
- Metric specs: [`docs/metrics/`](../metrics/)
- Standard disclaimer library: [`docs/policies/disclaimer_library.md`](../policies/disclaimer_library.md)
- ACS usage policy: [`docs/policies/acs_usage_policy.md`](../policies/acs_usage_policy.md)
- Zoning comparability plan: [`docs/zoning_comparability_plan.md`](../zoning_comparability_plan.md)
- Decision log (D10 — tract-level ACS presentation): [`docs/decision_log.md`](../decision_log.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial spec — 5 metrics, ranking direction, caveats, prohibited content, interaction model (Task 19.2) | Farid |
