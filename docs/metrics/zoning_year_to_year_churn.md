# Zoning Year-to-Year Churn — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Metric ID:** zoning_year_to_year_churn

---

## Metric Name

**Name:** zoning_year_to_year_churn
**One-liner:** Change in district land area share for each zoning group between consecutive vintage years, in percentage points.

---

## Purpose

How much did the zoning composition of each planning district change year over year? This metric identifies districts with active rezoning activity and surfaces which zoning categories are growing or shrinking.

**Example:**
> Did the share of commercially-zoned land in Kensington increase from 2022 to 2023?

---

## Numerator / Denominator

**Numerator:** `zoning_composition_share` in vintage year N minus `zoning_composition_share` in vintage year N−1, in percentage points.

**Denominator:** N/A — the input shares are already rates.

---

## Formula

```
zoning_year_to_year_churn =
    zoning_composition_share(year N) - zoning_composition_share(year N-1)
```

Expressed in percentage points. A positive value indicates the zoning group's share grew; negative indicates it shrank.

**Aggregation type:** non-additive (cannot be summed across zoning codes or districts without recomputing from underlying area values)

**Important:** This metric is NOT pre-stored in the warehouse. Per FM2 in the grain spec, YoY change must be computed at query time via self-join on `fct_district_year_zoning_composition` to avoid mixing two fact types at the same grain.

**SQL sketch (optional):**
```sql
SELECT
    curr.district_id,
    curr.vintage_year_key AS year_n,
    prev.vintage_year_key AS year_n_minus_1,
    z.zoning_category,
    curr.pct_district - prev.pct_district AS zoning_yoy_churn_pct_pts
FROM fct_district_year_zoning_composition curr
JOIN fct_district_year_zoning_composition prev
    ON curr.district_id = prev.district_id
    AND curr.zoning_code = prev.zoning_code
    AND curr.vintage_year_key = prev.vintage_year_key + 10000  -- EOY surrogate: 20231231 → 20221231
JOIN dim_zoning z ON curr.zoning_code = z.zoning_code
-- TODO: vocab_stable filter — column not yet in column contracts; see zoning comparability plan
```

---

## Grain

**Grain statement:** One row per planning district per vintage year transition (N → N−1) per zoning group.

*Computed at query time from:* `fct_district_year_zoning_composition` (G2) via self-join.

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Planning District | dim_district | 18 districts; conformed spine |
| Vintage Year Pair | dim_date | Year N and Year N−1; annual cadence |
| Zoning Group | dim_zoning | Coarse grouping (zoning_category); retired codes remain in dim_zoning with no active flag (Type 1 SCD — no versioning columns per D17) |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_district_year_zoning_composition | Self-join source for YoY diff | district_id, vintage_year_key, zoning_code, area_sqmi, pct_district |
| dim_district | District lookup | district_id, district_name |
| dim_zoning | Zoning category lookup | zoning_code, zoning_category |

---

## Test Ideas

- [ ] Sum of churn values across all zoning codes for a given district × year transition ≈ 0 (gains and losses net out)
- [ ] No churn values outside the range [−1.0, 1.0] (cannot gain or lose more than 100%)
- [ ] Only `vocab_stable = TRUE` district-year pairs are included in reported churn; flagged pairs excluded or labeled
- [ ] No nulls in district_id, vintage_year_key, or zoning_category
- [ ] Churn is NULL (not computed) for the earliest vintage year where no prior year exists

---

## Caveats / Limitations

- **Vocabulary stability is required:** YoY pairs where `vocab_stable = FALSE` must not be reported as reliable churn. Apparent change in those pairs may reflect code renaming rather than actual rezoning activity; see [zoning comparability plan](../zoning_comparability_plan.md).
- **Not pre-stored:** This metric is computed at query time via self-join. It should not be added as a column to `fct_district_year_zoning_composition` (per FM2 in grain spec).
- **Small changes near district boundaries:** Tiny percentage-point shifts (< 0.5 pp) may reflect geometry precision differences across vintages rather than real rezoning.
- **Non-additive:** Churn values cannot be summed across zoning codes (they net to approximately zero) or across districts (different land areas).

---

## Links

**Related Metrics:**
- [Zoning composition by year](./zoning_composition_by_year.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md) — G2, FM2
- [Table inventory](../modeling/table_inventory.md)
- [Zoning comparability plan](../zoning_comparability_plan.md)
- [Zoning source catalog](../source_catalog/zoning_base_districts.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
| 2026-03-10 | Reconciliation: aligned column names to column_contracts.md; zoninggroup → zoning_category; district_key → district_id; added TODO for vocab_stable (not yet in column contracts) | Farid |
| 2026-03-10 | Reconciliation: removed active = FALSE from Dimensions Notes; fixed lingering zoninggroup → zoning_category in Notes column; clarified retired code handling per D17 | Farid |
| 2026-03-10 | Reconciliation: zoning_comparability_plan_draft.md → zoning_comparability_plan.md (final doc supersedes draft) | Farid |
