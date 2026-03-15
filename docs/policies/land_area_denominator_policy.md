# Land-area denominator policy

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

## Purpose

This policy locks the denominator used for all area-normalized metrics in the project (e.g., permits per sq mi). The goal is to ensure consistent, comparable metrics across all 18 planning districts.

---

## Policy

### 1) Use land-only area

**Rule:** All density metrics use land-only area (excluding water) as the denominator. Total area (land + water) must not be used.

**Why:** Districts with large water boundaries would show artificially low density if total area were used, making cross-district comparisons misleading. Land-only area reflects the actual developable surface and produces fair comparisons.

### 2) Unit convention: square miles

**Rule:** Land-only area is stored and used in **square miles (sq mi)**. No other unit is permitted for MVP metrics.

**Why:** Square miles is the standard unit for urban density analysis in the U.S. context and is interpretable to a non-technical audience.

### 3) Source of land-only area

**Rule:** Land-only area values are derived from the planning districts geometry layer (district spine), computed via PostGIS in the dbt staging model (`stg_planning_districts`). Values are stored in `dim_district` and joined to rollup tables — they are not recalculated at query time.

---

## Edge case handling

### Null or zero land-only area

**Trigger:** A district's land-only area field is `NULL` or `0`.

**Interpretation:** This indicates a data quality issue (invalid or missing geometry), not a true zero area. All 18 Philadelphia planning districts have non-zero land area.

**Rule:** When land-only area is null or zero:
- All density metrics for that district are suppressed (set to `NULL`).
- The district still appears in all views and dashboards.
- A visible flag is shown to the user: *"Land area not available for this district."*
- The affected district and period are logged in the limitations register.

**Not allowed:** Falling back to total area or imputing a value silently.

---

## Consistency rules

- Every metric that normalizes by area must reference this policy in its metric spec.
- The land-only area value for each district is fixed at the time of ingestion and does not change between rollup periods unless the district geometry is explicitly updated.
- If district boundaries change, a new ingestion run must be triggered and the change logged in the decision log.

---

## Links

- Feature vs rollup policy: [`docs/policies/feature_vs_rollup_policy.md`](./feature_vs_rollup_policy.md)
- Metric specs: [Permits per sq mi](../metrics/permits_per_sqmi_land.md)
- Limitations register: [`docs/limitations_register.md`](../limitations_register.md)
- Decision log: [`docs/decision_log.md`](../decision_log.md)

---

## References

- **[D3]** OpenGeo. *Introduction to PostGIS*. See [Resources](../../.claude/resources.md).
- **[S1]** City of Philadelphia. *Planning Districts*. See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-10 | Reconciliation: filled placeholder link to permits_per_sqmi_land.md | Farid |
