# Permits Composition — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
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
permits_composition_count = COUNT(permit_number)
    GROUP BY canonical_group
```

**Derived share (query-time only — not stored):**
```
permits_composition_share = COUNT(permit_number) per group
    / SUM(COUNT(permit_number)) OVER (PARTITION BY district_key, date_month_key)
```

**Aggregation type:** count is additive; share is non-additive (do not aggregate percentage columns across rows)

**SQL sketch (optional):**
```sql
SELECT
    p.district_key,
    p.date_month_key,
    pcg.canonical_group,
    COUNT(p.permit_number) AS permits_composition_count
FROM stg_permits p
JOIN permit_category_groups pcg
    ON p.permittype = pcg.raw_permittype
GROUP BY p.district_key, p.date_month_key, pcg.canonical_group
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
| Canonical Permit Group | permit_category_groups | Lookup table mapping raw permittype → canonical group; includes "Other/Unmapped" catch-all |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_permits | Primary fact source | permit_number, issue_date, district_key, permittype |
| dim_district | District lookup | district_key, district_name |
| dim_date | Time lookup | date_month_key, year, month |
| permit_category_groups | Category mapping | raw_permittype, canonical_group, active |

---

## Test Ideas

- [ ] Sum of all canonical group counts for a district × month equals the total permits_monthly_count for that district × month
- [ ] No district × month × group row has a negative count
- [ ] "Other/Unmapped" share is < 1% in any monthly load; alert if exceeded
- [ ] No nulls in district_key, date_month_key, or canonical_group
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
