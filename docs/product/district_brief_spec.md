# District Brief — Output Spec (MVP)

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

This spec defines the content and structure of the **district brief** — the primary narrative output for a single planning district in the MVP. A district brief answers the question: *"What is happening in this district, and how does it compare to the rest of the city?"*

The district brief is one district's page in the District Change Explorer. It is the foundation for the "Compare Districts" view (see [district_compare_spec.md](./district_compare_spec.md)).

---

## Scope

**In scope:**
- Required sections and their content
- Required metrics per section (with source metric spec references)
- Standard disclaimers that must appear
- Caveats and what the brief must not claim

**Out of scope:**
- Visual design, layout, or color choices (product design phase)
- Dashboard implementation in Metabase (Month 2+)
- ACS microdata, parcel-level detail, or block-group geography (out of scope for MVP)

---

## Audience

A non-technical city planner, neighborhood advocate, journalist, or engaged resident who wants to understand how a specific Philadelphia planning district has changed over the last 5 years.

The brief must be readable without a data dictionary. All jargon must be either explained inline or replaced with plain language.

---

## Required sections

---

### Section 1 — District overview

**Purpose:** Orient the reader. Establish what district they are looking at.

**Required content:**
- District name and `district_id`
- Land area (sq miles, land only)
- A brief one-line description of the district's location within the city (e.g., "Lower North Philadelphia, bounded by...")

**Source tables:** `dim_district`

**Caveats:**
- Land area is derived from PostGIS polygon computation; CRS must be confirmed before publishing this figure (L14).

---

### Section 2 — Permit activity trends

**Purpose:** Show how construction/permitting activity has changed month-to-month and year-to-year within the district.

**Required metrics:**

| Metric | Spec | Display |
|--------|------|---------|
| Monthly permit count | [permits_monthly_count](../metrics/permits_monthly_count.md) | Line chart: monthly count over 5 years |
| Permit intensity | [permits_per_sqmi_land](../metrics/permits_per_sqmi_land.md) | Summary stat: most recent 12-month average |
| Permit composition | [permits_composition](../metrics/permits_composition.md) | Bar chart or breakdown: share by permit type group |

**Standard disclaimer (required):**
> D-PERMITS-1: Permit counts reflect the date a permit was issued, not the date construction began or was completed. There is a time lag between permit issuance and actual construction activity.

**Caveats:**
- Unassigned permits (those without a valid geocode or district assignment) are excluded from district totals. The unassigned share for this district is shown as a quality note.
- Do not use the phrase "construction surged" or similar language that implies physical activity rather than administrative issuance.

---

### Section 3 — Zoning composition and change

**Purpose:** Show how the regulatory land use mix has shifted within the district across the 5-year vintage window.

**Required metrics:**

| Metric | Spec | Display |
|--------|------|---------|
| Zoning composition by year | [zoning_composition_by_year](../metrics/zoning_composition_by_year.md) | Stacked bar or area chart: share by broad category per vintage year |
| Zoning YoY churn | [zoning_year_to_year_churn](../metrics/zoning_year_to_year_churn.md) | Table: top 3 zoning category shifts per year-to-year transition |

**Standard disclaimer (required):**
> D-ZONING-1: Year-over-year zoning composition comparisons are valid only when the zoning code vocabulary is confirmed stable between the two years being compared. District-year pairs flagged as potentially unstable may reflect code renaming or reclassification rather than actual rezoning activity.

**Caveats:**
- YoY comparisons are only shown for district-year pairs where `vocab_stable = TRUE`. Flagged pairs display a warning rather than a chart value.
- Do not use the phrase "was rezoned" for any flag pair. Use "zoning records changed" or "composition data flagged for vocabulary differences."
- Zoning composition reflects regulatory classification, not actual land use on the ground.

---

### Section 4 — Demographic context (ACS)

**Purpose:** Provide income and tenure context for the district as a backdrop to physical changes. This section is labeled explicitly as *context*, not as a trend or driver.

**Required metrics:**

| Metric | Spec | Display |
|--------|------|---------|
| Tract-level income distribution | [acs_income_proxy](../metrics/acs_income_proxy.md) | Histogram: distribution of tract median household incomes within the district |
| Tract-level tenure distribution | [acs_tenure_proxy](../metrics/acs_tenure_proxy.md) | Bar chart: % of tracts by renter-occupied share bin |

**ACS period shown:** Two non-overlapping periods, e.g., 2015–2019 and 2020–2024.

**Standard disclaimer (required):**
> D-ACS-1 (full): Demographic data shown here are 5-year period estimates from the U.S. Census Bureau's American Community Survey (ACS). Five-year estimates are used because 1-year estimates are not available at the census tract level required for planning-district context. These estimates represent averages across surveys conducted over multiple years and do not reflect conditions in any single year. Only non-overlapping ACS periods should be compared (e.g., 2015–2019 vs 2020–2024); overlapping periods are not valid to compare. ACS values are presented as tract-level distributions for district context and do not establish that demographic conditions caused changes in permit activity.

**Caveats:**
- The number of contributing tracts (N) must be shown prominently. Districts with fewer than 3 tracts should display a small-N caution note.
- Do not use the phrasing "the median income of [District X] is $Y." Use "tract-level median household incomes within [District X] range from $A to $B."
- Do not make causal claims linking ACS indicators to permit activity in the same view.

---

## What the district brief must not claim

Drawn from [disclaimer_library.md](../policies/disclaimer_library.md):

| Prohibited | Use instead |
|------------|-------------|
| "The median income of [District X] is $Y." | "Tract-level median incomes range from $A to $B (N tracts, ACS 2020–2024)." |
| "Demographic change drove permit activity." | "Permit activity and demographic context are shown for the same period; no causal relationship is implied." |
| "Zoning changed by X% …" (when `vocab_stable = FALSE`) | Show a flag; suppress the percentage. |
| "Construction activity surged in [Month]." | "Permit issuance volume increased in [Month]." |
| "Based on ACS data, [District X] became more affordable." (with overlapping periods) | Suppress comparison entirely if periods overlap. |

---

## Assumptions

| ID | Assumption | Impact if Wrong | Mitigation |
|----|------------|-----------------|------------|
| A1 | All 18 districts will have sufficient permit records and zoning coverage across the 5-year window to populate all four sections | Some districts may have low activity; sections may need to show "no data" states | Build "no data" UI states for low-activity districts |
| A2 | ACS 5-year periods 2015–2019 and 2020–2024 will be available for all planning districts (tract coverage) | Some tracts may have suppressed values; district may have partial coverage | Surface suppression counts; add small-N caution |
| A3 | Non-technical readers can interpret tract-level distributions presented as histograms | Misinterpretation risk is higher than for single-value metrics | Add plain-language tooltips; avoid statistical jargon in labels |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | Dashboard implementation teams add ACS single-value KPIs for simplicity, violating D10 and this spec | Medium | High | Reference this spec and disclaimer library during implementation review |
| R2 | Zoning flagged pairs (`vocab_stable = FALSE`) are shown without warning, misleading users | Low | High | Enforce flag check as a required condition before rendering the zoning section |
| R3 | Small-N districts (≤3 tracts) have ACS histograms that look authoritative but are unreliable | Low | Medium | Require prominent tract-count display; add caution flag for N ≤ 3 |

---

## Links

- Metric specs: [`docs/metrics/`](../metrics/)
- Standard disclaimer library: [`docs/policies/disclaimer_library.md`](../policies/disclaimer_library.md)
- ACS usage policy: [`docs/policies/acs_usage_policy.md`](../policies/acs_usage_policy.md)
- Zoning comparability plan: [`docs/zoning_comparability_plan.md`](../zoning_comparability_plan.md)
- Compare districts spec: [`docs/product/district_compare_spec.md`](./district_compare_spec.md)
- Limitations register: [`docs/limitations_register.md`](../limitations_register.md)

---

## References

- **[D24]** U.S. Digital Service / 18F. *Plain Language Guide for Government Communication*. See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial spec — 4 required sections, 7 metrics, 5 forbidden claims, assumptions and risks (Task 19.1) | Farid |
