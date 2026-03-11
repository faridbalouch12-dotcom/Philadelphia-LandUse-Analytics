# ACS Tenure Proxy — Metric Spec

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-10
**Metric ID:** acs_tenure_proxy

---

## Metric Name

**Name:** acs_tenure_proxy
**One-liner:** Tract-level renter-occupied housing share from ACS 5-year period data, used as a housing tenure context indicator for planning districts.

---

## Purpose

How prevalent is rental housing across the tracts within each planning district? This metric shows what share of occupied housing units are renter-occupied at the tract level, surfaced as a district distribution — not a single district-level KPI.

**Example:**
> What share of housing units in South Philadelphia tracts are renter-occupied, and how does that compare to Chestnut Hill tracts, for the 2020–2024 ACS period?

---

## Numerator / Denominator

**Numerator:** `renter_occupied_units` — renter-occupied housing units (count), from ACS field DP04_0047E, at census tract level.

**Denominator:** `occupied_units` — occupied housing units (count), from ACS field DP04_0045E, at census tract level.

---

## Formula

```
acs_tenure_proxy = renter_occupied_units / occupied_units
    (renter-occupied share, at census tract level)
```

**Aggregation type:** non-additive (ratio — cannot be summed or averaged across tracts without recomputing from underlying counts; district-level renter share must be computed from aggregated numerator/denominator counts, not by averaging tract-level percentages)

**SQL sketch (optional):**
```sql
SELECT
    geoid_tract,
    acs_period_label,
    renter_occupied_units,
    occupied_units,
    renter_occupied_units::float / NULLIF(occupied_units, 0) AS renter_share
FROM fct_tract_acs
```

---

## Grain

**Grain statement:** One census tract per ACS 5-year period snapshot.

*Source table grain (G4):* `fct_tract_acs` — one row per `(geoid_tract, acs_period_label)`

*Dashboard grain (G6):* `agg_district_acs_attributes_hist` — one row per `(district_id, boundary_version_eoy, census_attribute, bin_range)`

---

## Dimensions

| Dimension | Table | Notes |
|-----------|-------|-------|
| Census Tract | fct_tract_acs | geoid_tract — canonical 11-digit join key |
| Planning District | dim_district | Reached via bridge_tract_district_overlap; tracts may span multiple districts |
| ACS Period | fct_tract_acs | acs_period_label (e.g., "2020–2024"); 5-year estimates only |

---

## Source Tables

| Table | Role | Key Fields Used |
|-------|------|-----------------|
| fct_tract_acs | Raw ACS tract-level estimates (G4) | geoid_tract, acs_period_label, renter_occupied_units, renter_occupied_units_moe, occupied_units, occupied_units_moe |
| bridge_tract_district_overlap | Tract → district spatial bridge (G3) | geoid_tract, district_id, boundary_version, pct_tract_area |
| agg_district_acs_attributes_hist | Pre-aggregated histogram rollup (G6) | district_id, census_attribute, bin_range, tract_count |
| dim_district | District lookup | district_id, district_name |

---

## Test Ideas

- [ ] No tract has renter_share > 1.0 or < 0.0
- [ ] No nulls in occupied_units (denominator) for Philadelphia tracts; if null, renter_share is suppressed (NULL), not zero
- [ ] MOE columns for both renter_occupied_units and occupied_units are retained and non-null where estimates are non-null
- [ ] Only non-overlapping ACS periods are compared in any dashboard or analysis output
- [ ] ACS period label is present and matches the vintage year in all fct_tract_acs rows
- [ ] Histogram bin counts in agg_district_acs_attributes_hist sum to the correct number of tracts per district

---

## Caveats / Limitations

- **Non-additive:** Renter share cannot be averaged across tracts. District-level renter share must be computed by summing `renter_occupied_units` across tracts (with overlap weights from bridge table) and dividing by similarly summed `occupied_units` — not by averaging tract-level percentages.
- **Period estimates, not point-in-time:** ACS 5-year estimates represent an average across the collection period. The label "2020–2024" does not reflect conditions in 2024 specifically.
- **Non-overlapping periods only:** Only compare ACS periods that do not overlap (e.g., 2015–2019 vs 2020–2024); see [ACS usage policy](../policies/acs_usage_policy.md).
- **MAUP risk at district boundaries:** Tracts straddling planning district boundaries are allocated via area-weighted interpolation, which assumes uniform population distribution within tracts. This may misallocate tenure proportions near district edges; see [ACS to district alignment note](../feasibility/acs_to_district_alignment_note.md).
- **MOE must be retained:** Margins of error for both numerator (`renter_occupied_units`) and denominator (`occupied_units`) must be stored in the mart. Do not suppress them.
- **Zero-denominator guard:** Tracts with zero occupied housing units (`occupied_units = 0`) must not produce a division-by-zero result; suppress renter_share as NULL for those tracts.

---

## Links

**Related Metrics:**
- [ACS income proxy](./acs_income_proxy.md)

**Source Specs:**
- [Grain spec](../modeling/grain_spec.md) — G4, G6
- [Table inventory](../modeling/table_inventory.md)
- [ACS usage policy](../policies/acs_usage_policy.md)
- [ACS to district alignment note](../feasibility/acs_to_district_alignment_note.md)
- [ACS critical fields dictionary](../data_dictionary/acs_critical_fields.md)
- [ACS source catalog](../source_catalog/acs_context.md)

---

## Change Log

| Date       | Change Description   | Author |
|------------|----------------------|--------|
| 2026-03-08 | Initial spec created | Farid  |
| 2026-03-10 | Reconciliation: aligned district_key → district_id per column_contracts.md | Farid |
| 2026-03-10 | Reconciliation: G6 dashboard grain — boundary_version → boundary_version_eoy (aligns with corrected G6 PK in grain_spec.md) | Farid |
| 2026-03-10 | Reconciliation: replaced raw ACS field codes with SC4 warehouse column names — DP04_0047E → renter_occupied_units (+MOE), DP04_0045E → occupied_units (+MOE); SC4 expanded with these columns in column_contracts.md | Farid |
| 2026-03-10 | Full reconciliation: remaining DP04_0047E/0045E references in caveats replaced with warehouse column names | Farid |
