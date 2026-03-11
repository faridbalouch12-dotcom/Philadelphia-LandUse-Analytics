# Permits Monthly Count — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-10
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
permits_monthly_count = COUNT(permitnumber)
```

**Aggregation type:** additive
**SQL sketch (optional):**
```sql
SELECT
    p.district_id,
    d.year,
    d.month,
    COUNT(p.permitnumber) AS permits_monthly_count
FROM fct_permits p
JOIN dim_date d USING (date_key)
GROUP BY p.district_id, d.year, d.month
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
| Permit Type | `permit_category_group` (column on `fct_permits`) | Optional filter; coarse categories per permit_category_grouping_memo.md |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_permits | Primary fact source | permitnumber, date_key, district_id |
| dim_district | District lookup | district_id, district_name |
| dim_date | Time lookup | date_key, year, month |

---

## Test Ideas

- [ ] Sum of all district counts for a given month equals citywide total for that month
- [ ] No district has a negative count
- [ ] No nulls in district_id or date_key
- [ ] Row count matches expected grain: 18 districts × months in window = total rows
- [ ] No permitnumber appears in more than one district for the same month

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
| 2026-03-10 | Reconciliation: aligned column names to column_contracts.md; fixed SQL sketch FROM stg_permits → fct_permits (D11) | Farid |
| 2026-03-10 | Reconciliation: fixed SQL sketch GROUP BY — date_key → year, month; added dim_date join (daily granularity → monthly) | Farid |
| 2026-03-10 | Reconciliation: source tables fct_permits key fields — permitissuedate → date_key (date_key is the FK used; permitissuedate is raw source only) | Farid |
| 2026-03-10 | Full reconciliation: `permit_category_groups` table reference → `permit_category_group` column on `fct_permits` (no separate lookup table) | Farid |
