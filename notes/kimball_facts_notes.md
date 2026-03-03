# Kimball: Facts for Measurement — Notes

**Author:** Farid
**Created:** 2026-03-02
**Last Updated:** 2026-03-02
**Source:** [B1] The Data Warehouse Toolkit (3rd ed.), Chapter 2, p. 40

---

## Purpose

These notes define what counts as a fact in the Philly Data Warehouse domain, distinguish facts from descriptive context, and identify the three types of facts with project-specific examples.

---

## Key Takeaways

- A fact is a **numeric measurement** that results from a business process event — it's what you're actually trying to measure
- Whether something is a fact or a dimension attribute **depends on the business process being modeled**, not on the data itself (e.g. salary is a fact in a payroll process, a dimension attribute in a store performance analysis)
- Facts fall into three types based on how they behave mathematically: **additive**, **semi-additive**, and **non-additive**
- Only facts consistent with the declared grain are allowed in a fact table
- A fact table row corresponds to a physical observable event — it is not shaped by the demands of a particular report

---

## Detailed Notes

### What a Fact Is

Kimball (p. 40): *"Facts are the measurements that result from a business process event and are almost always numeric. A single fact table row has a one-to-one relationship to a measurement event as described by the fact table's grain."*

Facts are:
- Numeric
- Produced by a business process event
- Consistent with the declared grain of the fact table
- The primary target of aggregations (SUM, AVG, COUNT, etc.)

Facts are **not**:
- Descriptive attributes of entities (those belong in dimension tables)
- Ratios or derived metrics stored pre-calculated (non-additive facts should be stored as components where possible)

**Caveat — when you have no choice:** The "avoid storing ratios" rule applies when you *have* the underlying components. With ACS data, the Census Bureau publishes the median directly and does not release household-level microdata for Philadelphia planning districts. You cannot recompute the median from first principles — you must store it as-is. Median income is therefore stored as a non-additive fact not because it's ideal, but because the data source leaves no alternative.

### Context Determines Classification

The same data element can be a fact or a dimension attribute depending on the business process:

| Data Element | Business Process | Classification |
|-------------|-----------------|----------------|
| Salary | Payroll processing | Fact (measurement of a pay event) |
| Salary | Store performance analysis | Dimension attribute (descriptive context of an employee) |
| Permit fee | Permit issuance | Fact (measurement of the permit event) |

### Three Types of Facts

**Additive** — can be summed across *all* dimensions associated with the fact table.
- Most flexible and useful type
- Example: `SUM(permit_fee)` across districts, time periods, or permit types all produce meaningful totals

**Semi-additive** — can be summed across *some* dimensions but not all.
- Common pattern: counts or balances that represent a state at a point in time
- Summing across time periods double-counts the same records
- Example: active permit count at month-end can be summed across districts (to get citywide total) but not across months (same permit would be counted in each month it remains open)

**Non-additive** — cannot be meaningfully summed across *any* dimension.
- Typically ratios, averages, or statistical measures
- Summing produces a mathematically valid but meaningless number
- Example: `SUM(median_income)` across districts = sum of medians, not a meaningful aggregate
- Correct approach: store the underlying components (e.g. total income, population count) and calculate the ratio at query time

---

## Application to Project

### Candidate Facts for the Philly Data Warehouse

| Fact | Type | Measurement Unit | Grain | Notes |
|------|------|-----------------|-------|-------|
| Permit fee | Additive | USD | One building permit in Philadelphia | Numeric, tied to a single permit event; safe to sum across all dimensions |
| Active permit count (month-end) | Semi-additive | Count of permits | One planning district per calendar month | Represents open permits as of month-end snapshot; summable across districts at the same point in time, not across time periods |
| Median household income | Non-additive | USD | One planning district per year | Statistical measure from ACS; summing across districts or years produces a meaningless number; use AVG or weighted average at query time instead |

### Why Median Income is Non-Additive (Not Semi-Additive)

A semi-additive fact can still be summed across *some* dimension meaningfully. Median income cannot:
- `SUM(median_income)` across districts = sum of medians, not a Philadelphia-wide median
- `SUM(median_income)` across years = cumulative sum of annual medians, not meaningful
- The correct aggregation is either `AVG()` (simple average across districts) or a population-weighted average — but neither is a simple SUM

---

## Open Questions

- [ ] Does L&I permit data include a `permit_fee` field, or does fee need to be derived/estimated? Verify when cataloging the dataset (Task 7.x)
- [ ] Should active permit count be tracked at month-end or at the point of status change? To be confirmed when designing the accumulating snapshot
- [ ] Are there other ACS variables (e.g. total population, renter count) that are fully additive and could serve as base components for derived metrics?

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | L&I permit data includes a numeric permit fee field | Permit fee fact may not be available; would need to fall back to permit count as the primary additive fact |
| A2 | ACS median income is reported at the planning district level (or can be approximated at that level) | If only available at census tract level, aggregation to district grain requires population weighting and introduces additional uncertainty |

---

## Links

**Related Notes:**
- Kimball Grain Notes: [`kimball_grain_notes.md`](./kimball_grain_notes.md)
- ACS Period Estimates Notes: [`acs_period_estimates_notes.md`](./acs_period_estimates_notes.md) *(Task 2.7 — upcoming)*

**Project Documents:**
- Docs folder: [`../docs/`](../docs/)

---

## References

- **[B1]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.), Chapter 2, pp. 40–42. See [Resources](../..claude/resources.md).

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-02 | Initial notes created | Farid  |
| 2026-03-02 | Added caveat on storing pre-calculated statistics when underlying components unavailable | Farid  |
