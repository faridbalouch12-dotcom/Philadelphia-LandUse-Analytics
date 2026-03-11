ye# Permits geocoding risk note — L&I Building and Zoning Permits (S2)

**Author:** Farid
**Created:** 2026-03-06
**Last Updated:** 2026-03-06
**Status:** Draft

---

## Purpose

This note documents the geocoding quality risk for the L&I permits dataset: what geo fields are available, how unassigned permits are defined and measured, and how the risk surfaces in the limitations register and dashboard.

---

## Geo fields available

| Field | Type | Role | Risk level | Notes |
|-------|------|------|------------|-------|
| `the_geom` | geometry (point) | Primary — point-in-polygon district assignment | High | Invalid or out-of-city geometry possible; primary matching path |
| `lat` / `lng` | float | Fallback — if geometry parsing fails | Med | Missing for a small share; 0/0 or out-of-range values indicate bad records |
| `address` | string | Fallback — geocode address string, retry point-in-polygon | Med | Null in small share; formatting inconsistencies; requires geocoder |
| `geocode_x` / `geocode_y` | float | Fallback — projected coordinates from permit geocode field | Low | Null/0 if geocoding failed at source; useful for debugging |
| `censustract` | string | Audit — cross-check district assignment against tract boundaries | Med | Null in small share; treat as string (leading zeros) |

---

## Spatial matching cascade

District assignment follows a four-step cascade. Each permit carries a `match_method` audit field recording which step succeeded.

| Step | Method | `match_method` value |
|------|--------|----------------------|
| 1 | Point-in-polygon on `the_geom` | `point_in_polygon` |
| 2 | Geocode `address` string → point-in-polygon | `address_match` |
| 3 | Point-in-polygon on `geocode_x` / `geocode_y` | `geocode_match` |
| 4 | Assign to district with nearest boundary point; record distance | `distance_fallback` |
| — | All steps failed or distance exceeds threshold | `unmapped` |

---

## Unassigned-rate metric

**Definition:** A permit is unassigned if it fails all four cascade steps — including the distance-based fallback — and cannot be attributed to any of the 18 planning districts.

**Formula:**

```
unassigned_rate = unmapped_permits / total_permits_in_fct_permits
```

**Threshold:** ≤ 5% overall. Any individual district with an unassigned rate exceeding 5% is flagged for manual review.

**Monitoring:** After each pipeline run, compute `unassigned_rate` by district using `match_method`. A non-uniform distribution of unmapped records across districts signals a systemic data quality problem rather than random noise.

---

## Limitations register entry

**Entry:** L3 — Permit geocoding quality

| Field | Detail |
|-------|--------|
| **Risk** | Permits that cannot be assigned to a planning district are excluded from district-level counts, causing undercounting of permit activity in affected districts. Districts with older infrastructure and inconsistent address data are at higher risk. |
| **Mitigation** | Multi-step spatial matching cascade (point-in-polygon → address match → geocode match → distance fallback) minimizes unassigned rate. `match_method` audit field enables post-hoc QA by district and by method. |
| **Threshold** | Overall unassigned rate ≤ 5%. Any district exceeding 5% flagged for investigation before publishing results. |
| **When addressed** | Pipeline validation (Month 2) |

---

## Dashboard surfacing

**Map layer:** Unassigned permits appear as gray dots. Clicking a gray dot shows a tooltip: *"Planning district not found."* All other permits are colored by district or category as normal.

**KPI cards (data quality panel):**

| Metric | Description |
|--------|-------------|
| Total permits | All permits in the extract window |
| Mapped permits | Permits successfully assigned to a district (any `match_method` except `unmapped`) |
| Unmapped permits | Permits with `match_method = 'unmapped'` |
| Unmapped % | `unmapped / total` — flagged visually if ≥ 5% |

---

## Links

- **Assumptions log:** [A11 — Spatial matching cascade](../assumptions_log.md#a11-the-spatial-matching-cascade-will-keep-the-unmapped-permit-rate-at-or-below-5)
- **Critical fields dictionary:** [`docs/data_dictionary/li_permits_critical_fields.md`](../data_dictionary/li_permits_critical_fields.md)
- **Source catalog entry:** [`docs/source_catalog/li_permits.md`](../source_catalog/li_permits.md)
- **Feasibility checklist:** [`docs/feasibility/li_permits_feasibility.md`](li_permits_feasibility.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md) (entry L3)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-06 | Initial draft      | Farid  |
