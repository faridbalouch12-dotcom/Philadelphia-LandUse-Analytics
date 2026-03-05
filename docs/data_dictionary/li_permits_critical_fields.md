# Critical fields dictionary — L&I Building and Zoning Permits (S2)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header

- **Dataset name:** Licenses & Inspections Building and Zoning Permits (OpenDataPhilly)
- **Dataset ID:** S2
- **Source page / endpoint:** <https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/>
- **Reviewer:** Farid
- **Date:** 2026-03-05
- **MVP role:** Permits fact backbone (feature-level permit events → district × month rollups)
- **Locked scope for analysis:** Last 5 years (based on `permitissuedate`)

---

## Field Dictionary

**Risk level scale:** High = metric breaks or joins fail if this field is missing/wrong; Med = analysis degrades but is still usable; Low = not used in MVP metrics.

| Field name | Meaning | Required? | Expected type | Risk level | Common null/invalid patterns | Notes |
|---|---|---|---|---|---|---|
| `permitnumber` | Permit identifier (business key) | Yes | string | High | Rare nulls in practice; potential duplicates if revisions exist in future pulls | Use as the canonical permit key for event grain ("1 row = 1 permit"). Validate uniqueness per extract. |
| `objectid` | Row-level unique ID from source | No (recommended) | integer | Med | None expected; can differ across pulls if source republishes | Keep as technical surrogate ID for staging/debugging; do not treat as business identity across refreshes unless confirmed stable. |
| `permitissuedate` | Canonical permit issuance date | Yes | datetime | High | Should be non-null for MVP; may have timezone/format differences | Canonical time field for district × month rollups. Defines last-5-year window. |
| `permittype` | Coarse permit type | Yes | string | High | Should be non-null; category drift possible over long periods | Best primary grouping field for MVP composition (low cardinality). |
| `permitdescription` | Coarse permit description | Yes | string | Med | Should be non-null; may mirror permittype but can vary | Secondary grouping; use for display labels and QA vs `permittype`. |
| `the_geom` | Point geometry for the permit | Yes | geometry (point) | High | Invalid geometry, rare parsing errors; may be out-of-city | Primary field for district attribution (point-in-polygon). Keep feature-level geometry for map-first later. |
| `lat` | Latitude | No (fallback) | float | Med | Missing for small share; may be 0/0 or out of range in bad records | Fallback if geometry parsing fails; also useful for quick sanity checks. |
| `lng` | Longitude | No (fallback) | float | Med | Missing for small share; may be 0/0 or out of range | Same as `lat`. |
| `geocode_x` | Geocode X coordinate (projected) | No | float | Low | Could be null/0 if geocoding failed | Helpful for debugging geocoding quality; not needed for MVP metrics. |
| `geocode_y` | Geocode Y coordinate (projected) | No | float | Low | Could be null/0 if geocoding failed | Same as `geocode_x`. |
| `address` | Permit address (as geocoded) | No (recommended) | string | Med | Null in small share; formatting inconsistencies | Useful for QA, debugging, and later "drivers" work; not required for district rollups if geometry works. |
| `censustract` | Census tract ID | No (recommended) | string | Med | Null in small share; formatting quirks (leading zeros) | Useful for auditing district assignment and later ACS linkage strategies; treat as string. |
| `zip` | Zip code | No | string | Low | Null/invalid ZIPs; may reflect mailing vs location | Useful for sanity checks only; not a district-level key. |
| `commercialorresidential` | Binary classification | No (optional MVP) | string | Med | Small missingness; occasional nonstandard values | Optional composition slice. If used, track missing share. |
| `applicanttype` | Applicant type category | No | string | Low | Usually complete; possible drift | Optional descriptive breakdown; not required for MVP. |
| `typeofwork` | Type of work (more granular than permittype) | No | string | Med | Label variants over time (e.g., "Alterations" vs "Addition/Alteration") | Only use if you build a mapping to stable groups + track "unknown/unmapped" share. |
| `status` | Permit status | No | string | Low | Can be inconsistent; lifecycle semantics vary | Not needed for MVP physical-change counts; relevant later for lifecycle/accumulating snapshot modeling. |
| `systemofrecord` | Source system name | No (recommended) | string | Med | In last-5-year window, expected to be stable; older years differ | QA field: last-5-years should be 100% ECLIPSE; use to detect schema regime changes across eras. |
| `contractorname` | Contractor name | No | string | Low | Missing for a non-trivial share; inconsistent formatting | Not needed for MVP. If "drivers" is later, expect heavy cleaning/entity resolution. |
| `usecategories` | Use category labels | No | string | Low | Very high missingness (~88.75%) + high cardinality | Not suitable for MVP grouping; defer unless you design a robust mapping and accept sparse coverage. |
| `numberofunits` | Reported number of units | No | numeric | Low | Extremely sparse (~92.65% null); self-reported/unverified | Do not use for "units added" narratives in MVP; only later with disclaimers and validation. |

---

## Required Fields Summary (MVP)

- **Time fields:**
  - `permitissuedate`
- **Geography / linkage fields:**
  - `the_geom` (primary)
  - `lat`, `lng` (optional fallbacks)
- **Key / ID fields:**
  - `permitnumber` (business key)
  - `objectid` (recommended for staging/debugging)
- **Category / grouping fields:**
  - `permittype` (primary)
  - `permitdescription` (display/QA)
  - `commercialorresidential` (optional)
- **Other MVP-required fields:**
  - None strictly required beyond the above; recommended QA fields: `systemofrecord`, `censustract`, `address`

---

## Links

- **Source catalog entry:** [`docs/source_catalog/li_permits.md`](../source_catalog/li_permits.md)
- **Feasibility checklist:** [`docs/feasibility/li_permits_feasibility.md`](../feasibility/li_permits_feasibility.md)
- **Related metric specs** (to be linked in Week 3):
  - `docs/metrics/permits_monthly_count.md`
  - `docs/metrics/permits_per_sqmi_land.md`
  - `docs/metrics/permits_composition.md`
- **Limitations register entries:**
  - L3 — Permit geocoding quality
  - L4 — Permit category drift
  - L5 — Permit event date ambiguity

---

## Notes for Implementation Later (optional)

- **Fields that look useful but aren't reliable for MVP:**
  - `usecategories`, `numberofunits`, `occupancytype` (sparse / high-cardinality / unverified)
- **Fields likely needing normalization/mapping:**
  - `typeofwork` (map to coarse work groups; track "unknown/unmapped")
  - `contractorname` (entity resolution if you do "drivers" later)
- **Known schema drift concerns:**
  - HANSEN (pre-2020) vs ECLIPSE (2020+) system transition; last-5-year window is 100% ECLIPSE but historical extension would require validation
- **Validation checks to run when building pipelines:**
  - Uniqueness: `permitnumber` should be unique in-window
  - Not-null: `permitissuedate`, `permittype`, `the_geom` (or track exceptions)
  - Geo QA: percent unassigned to district; percent near boundaries; lat/lng range checks
  - Category QA: yearly distribution drift for `permittype` / `permitdescription`

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
