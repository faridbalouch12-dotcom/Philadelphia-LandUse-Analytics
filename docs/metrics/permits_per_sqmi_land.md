# Permits per Land Sq Mi — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Metric ID:** permits_per_sqmi_land

---

## Metric Name

**Name:** permits_per_sqmi_land
**One-liner:** Number of permits issued per square mile of land area per planning district per calendar month.

---

## Purpose

Which districts have the highest construction intensity relative to their physical size? This metric normalizes permit activity by land area to enable fair cross-district comparisons — a small district with 50 permits may be more active than a large district with 200.

**Example:**
> Is Kensington issuing more permits per land sq mi than Northwest Philadelphia, even if the raw count is lower?

---

## Numerator / Denominator

**Numerator:** COUNT(permit_number) — total permits issued in the district for the month.

**Denominator:** `land_area_sqmi` — land-only area of the district in square miles, sourced from `dim_district` per [land-area denominator policy](../policies/land_area_denominator_policy.md). Water area excluded.

---

## Formula

```
permits_per_sqmi_land = COUNT(permit_number) / land_area_sqmi
```

**Aggregation type:** non-additive (ratio — cannot be summed across districts or months; citywide intensity must be recomputed from totals, not summed from district values)

**SQL sketch (optional):**
```sql
SELECT
    p.district_key,
    p.date_month_key,
    COUNT(p.permit_number) / d.land_area_sqmi AS permits_per_sqmi_land
FROM stg_permits p
JOIN dim_district d USING (district_key)
GROUP BY p.district_key, p.date_month_key, d.land_area_sqmi
```

---

## Grain

**Grain statement:** One row per planning district per calendar month.

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Planning District | dim_district | 18 districts; land_area_sqmi sourced here |
| Calendar Month | dim_date | Joined via month surrogate key |
| Permit Type | permit_category_groups | Optional filter; composition slice |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_permits | Primary fact source | permit_number, issue_date, district_key |
| dim_district | Land area lookup | district_key, district_name, land_area_sqmi |
| dim_date | Time lookup | date_month_key, year, month |

---

## Test Ideas

- [ ] No district has a negative value
- [ ] No nulls in district_key or date_month_key
- [ ] Metric is NULL (not zero or infinity) for any district where land_area_sqmi is null or zero
- [ ] Citywide intensity recomputed from totals matches weighted average of district values
- [ ] land_area_sqmi values in dim_district are non-null and > 0 for all 18 districts

---

## Caveats / Limitations

- Counts reflect permit **issuance date**, not construction start or completion; there is a time lag between issuance and actual construction activity.
- Address-geocoded points near district boundaries may be ambiguous; district assignment uncertainty affects district-level rollups for permits close to boundary lines.
- If a district's `land_area_sqmi` is null or zero, this metric is suppressed (set to NULL) per the [land-area denominator policy](../policies/land_area_denominator_policy.md); the district still appears in views with a visible "Land area not available" flag.
- Non-additive: do not sum this metric across districts. To compute citywide intensity, divide the citywide permit count by total Philadelphia land area.

---

## Links

**Related Metrics:**
- [Permits monthly count](./permits_monthly_count.md)
- [Permits composition](./permits_composition.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md)
- [Table inventory](../modeling/table_inventory.md)
- [Land-area denominator policy](../policies/land_area_denominator_policy.md)
- [L&I permits source catalog](../source_catalog/li_permits.md)
- [Permits geocoding risk note](../feasibility/permits_geocoding_risk_note.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
