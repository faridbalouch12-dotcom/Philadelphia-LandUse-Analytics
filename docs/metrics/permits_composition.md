# Permits Composition — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-10
**Metric ID:** permits_composition_count

---

## Metric Name

**Name:** permits_composition_count
**One-liner:** Count of permits issued per canonical permit type group, per planning district per calendar month.

---

## Purpose

What kind of construction activity is happening in each district? This metric breaks down the monthly permit count by coarse permit type (e.g., building, zoning/use, mechanical/trade) to show the composition of activity, not just the total volume.

**Example:**
> Is the increase in permit activity in South Philadelphia driven by new building permits or zoning/use registrations?

---

## Numerator / Denominator

**Numerator:** N/A

**Denominator:** N/A

This is a simple count per canonical group. Share (percentage of total) is a derived calculation at query time — see Formula below.

---

## Formula

```
permits_composition_count = COUNT(permitnumber)
    GROUP BY permit_category_group
```

**Derived share (query-time only — not stored):**
```
permits_composition_share = COUNT(permitnumber) per group
    / SUM(COUNT(permitnumber)) OVER (PARTITION BY district_id, date_key)
```

**Aggregation type:** count is additive; share is non-additive (do not aggregate percentage columns across rows)

**SQL sketch (optional):**
```sql
SELECT
    p.district_id,
    d.year,
    d.month,
    p.permit_category_group,
    COUNT(p.permitnumber) AS permits_composition_count
FROM fct_permits p
JOIN dim_date d USING (date_key)
GROUP BY p.district_id, d.year, d.month, p.permit_category_group
```

---

## Grain

**Grain statement:** One row per planning district per calendar month per canonical permit type group.

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Planning District | dim_district | 18 districts; conformed spine |
| Calendar Month | dim_date | Joined via month surrogate key |
| Canonical Permit Group | `permit_category_group` (column on `fct_permits`) | Grouping applied in staging per permit_category_grouping_memo.md; includes "Other/Unmapped" catch-all |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_permits | Primary fact source | permitnumber, date_key, district_id, permit_category_group |
| dim_district | District lookup | district_id, district_name |
| dim_date | Time lookup | date_key, year, month |

---

## Test Ideas

- [ ] Sum of all canonical group counts for a district × month equals the total permits_monthly_count for that district × month
- [ ] No district × month × group row has a negative count
- [ ] "Other/Unmapped" share is < 1% in any monthly load; alert if exceeded
- [ ] No nulls in district_id, date_key, or permit_category_group
- [ ] All active canonical groups appear in every district × month combination (even if count = 0)

---

## Caveats / Limitations

- The `"Other/Unmapped"` canonical group absorbs any `permittype` value not present in the `permit_category_groups` lookup table. If this group's share exceeds 1% in any monthly load, the lookup table needs updating before composition metrics can be trusted.
- Category drift risk: the City of Philadelphia may introduce new permit types without notice. Monitor unmapped share per load; update lookup table as new values are confirmed.
- Share (percentage) should always be recomputed from counts at query time; do not aggregate or average percentage columns across rows.
- `typeofwork` is intentionally excluded from primary grouping due to high cardinality and silent label drift; see [permit category grouping memo](../decisions/permit_category_grouping_memo.md).

---

## Links

**Related Metrics:**
- [Permits monthly count](./permits_monthly_count.md)
- [Permits per land sq mi](./permits_per_sqmi_land.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md)
- [Table inventory](../modeling/table_inventory.md)
- [Permit category grouping memo](../decisions/permit_category_grouping_memo.md)
- [L&I permits source catalog](../source_catalog/li_permits.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
| 2026-03-10 | Reconciliation: aligned column names to column_contracts.md; fixed SQL sketch FROM stg_permits → fct_permits (D11); permit_category_group is now a column on fct_permits per SC1, no separate join needed | Farid |
| 2026-03-10 | Reconciliation: fixed SQL sketch GROUP BY — date_key → year, month; added dim_date join (daily granularity → monthly) | Farid |
| 2026-03-10 | Reconciliation: source tables fct_permits key fields — permitissuedate → date_key (date_key is the FK used; permitissuedate is raw source only) | Farid |
| 2026-03-10 | Full reconciliation: `permit_category_groups` table reference → `permit_category_group` column on `fct_permits` (no separate lookup table) | Farid |
