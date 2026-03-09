# Zoning Composition by Year — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Metric ID:** zoning_composition_by_year

---

## Metric Name

**Name:** zoning_composition_by_year
**One-liner:** Share of district land area covered by each zoning group per planning district per vintage year.

---

## Purpose

What is the zoning makeup of each planning district in a given year? This metric tracks the distribution of residential, commercial, industrial, and other zoning categories by area, enabling district-level composition snapshots and year-over-year comparisons (computed at query time).

**Example:**
> What share of Lower North Philadelphia was zoned residential vs. commercial in 2022, and how does that compare to 2021?

---

## Numerator / Denominator

**Numerator:** Total area (sq mi) of zoning polygons belonging to a given zoning group within the district for the vintage year.

**Denominator:** Total land area of the district (sq mi) from `dim_district`.

---

## Formula

```
zoning_composition_share = SUM(zoning_polygon_area_sqmi WHERE zoninggroup = X)
    / district_land_area_sqmi
```

**Area stored as absolute value (additive); share derived at query time (non-additive).**

**Aggregation type:** area is additive within a vintage-district; share is non-additive

**SQL sketch (optional):**
```sql
SELECT
    district_key,
    vintage_year_key,
    zoning_code,
    zoninggroup,
    SUM(polygon_area_sqmi) AS zoning_area_sqmi,
    SUM(polygon_area_sqmi) / d.land_area_sqmi AS zoning_composition_share
FROM fct_district_year_zoning_composition f
JOIN dim_district d USING (district_key)
GROUP BY district_key, vintage_year_key, zoning_code, zoninggroup, d.land_area_sqmi
```

---

## Grain

**Grain statement:** One row per planning district per vintage year per zoning code.

*Source table grain (G2):* `fct_district_year_zoning_composition`

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Planning District | dim_district | 18 districts; land_area_sqmi sourced here |
| Vintage Year | dim_date | Annual snapshots; joined via EOY surrogate date key |
| Zoning Code | dim_zoning | Canonical set of all zoning codes across all vintages; retired codes flagged active = FALSE |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_district_year_zoning_composition | Pre-aggregated zoning snapshot (G2) | district_key, vintage_year_key, zoning_code, zoninggroup, polygon_area_sqmi |
| dim_district | District lookup + land area | district_key, district_name, land_area_sqmi |
| dim_zoning | Zoning code lookup | zoning_code, zoninggroup, active |
| dim_date | Time lookup | vintage_year_key, year |

---

## Test Ideas

- [ ] Sum of zoning_area_sqmi across all codes for a district × year ≈ district land_area_sqmi (within tolerance for geometry overlap/sliver noise)
- [ ] zoning_composition_share for all codes within a district × year sums to ≈ 1.0
- [ ] No negative area values
- [ ] No nulls in district_key, vintage_year_key, or zoning_code
- [ ] All 18 districts present for each vintage year
- [ ] All zoning codes present in dim_zoning (retired codes included with active = FALSE)

---

## Caveats / Limitations

- **Vocabulary stability:** Comparisons across vintage years are only valid when the zoning code vocabulary is stable (`vocab_stable = TRUE`). District-year pairs flagged as unstable may reflect code renaming rather than actual rezoning; see [zoning comparability plan](../zoning_comparability_plan_draft.md).
- **No pre-stored YoY change:** Year-over-year change is NOT stored in the fact table (per FM2 in grain spec); compute at query time via self-join on `fct_district_year_zoning_composition`.
- **Area computation:** Polygon areas are computed from geometry in staging via PostGIS. Do not use raw `Shape__Area` field from source shapefiles without CRS validation.
- **Share is non-additive:** Do not sum or average `zoning_composition_share` across codes or districts without recomputing from underlying area values.

---

## Links

**Related Metrics:**
- [Zoning year-to-year churn](./zoning_year_to_year_churn.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md) — G2
- [Table inventory](../modeling/table_inventory.md)
- [Zoning comparability plan (draft)](../zoning_comparability_plan_draft.md)
- [Zoning source catalog](../source_catalog/zoning_base_districts.md)
- [Zoning critical fields dictionary](../data_dictionary/zoning_critical_fields.md)
- [Land-area denominator policy](../policies/land_area_denominator_policy.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
