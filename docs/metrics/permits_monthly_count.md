# Permits Monthly Count — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Metric ID:** permits_monthly_count

---

## Metric Name

**Name:** permits_monthly_count
**One-liner:** Count of permits issued per planning district per calendar month.

---

## Purpose

How many permits were issued in each planning district each month, to track construction activity trends over time?

**Example:**
> How is permit activity in the Lower North district trending over the last 5 years compared to other districts?

---

## Numerator / Denominator

**Numerator:** N/A
**Denominator:** N/A

This is a simple count with no ratio.

---

## Formula

```
permits_monthly_count = COUNT(permit_number)
```

**Aggregation type:** additive
**SQL sketch (optional):**
```sql
SELECT
    district_key,
    date_month_key,
    COUNT(permit_number) AS permits_monthly_count
FROM stg_permits
GROUP BY district_key, date_month_key
```

---

## Grain

**Grain statement:** One row per planning district per calendar month.

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Planning District | dim_district | 18 districts; conformed spine |
| Calendar Month | dim_date | Joined via month surrogate key |
| Permit Type | permit_category_groups | Optional filter; coarse categories per permit_category_grouping_memo.md |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_permits | Primary fact source | permit_number, issue_date, district_key |
| dim_district | District lookup | district_key, district_name |
| dim_date | Time lookup | date_month_key, year, month |

---

## Test Ideas

- [ ] Sum of all district counts for a given month equals citywide total for that month
- [ ] No district has a negative count
- [ ] No nulls in district_key or date_month_key
- [ ] Row count matches expected grain: 18 districts × months in window = total rows
- [ ] No permit_number appears in more than one district for the same month

---

## Caveats / Limitations

- Counts reflect permit **issuance date**, not construction start or completion; there is a time lag between issuance and actual construction activity.
- Address-geocoded points near district boundaries may be ambiguous; district assignment uncertainty can affect district-level rollups for permits close to boundary lines.
- Cancelled or voided permits issued in a given month are still counted; issuance does not guarantee that work was completed or even started.

---

## Links

**Related Metrics:**
- [Permits per land sq mi](./permits_per_sqmi_land.md)
- [Permits composition](./permits_composition.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md)
- [Table inventory](../modeling/table_inventory.md)
- [L&I permits source catalog](../source_catalog/li_permits.md)
- [Permit category grouping memo](../decisions/permit_category_grouping_memo.md)
- [Permits geocoding risk note](../feasibility/permits_geocoding_risk_note.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
