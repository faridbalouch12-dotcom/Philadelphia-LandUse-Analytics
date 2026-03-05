# Critical fields dictionary - Zoning Base Districts (S3)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header

- **Dataset name:** Zoning Base Districts (vintages)
- **Dataset ID:** S3
- **Source page / endpoint:** <https://opendataphilly.org/datasets/zoning-base-districts/>
- **Reviewer:** Farid
- **Date:** 2026-03-05
- **MVP role:** Zoning snapshot input for district-year composition/churn.

---

## Field dictionary

**Risk level scale:** High = metric breaks or joins fail if field is missing or
wrong; Med = analysis degrades but remains usable; Low = not required for MVP.

| Field name | Meaning | Required? | Expected type | Risk level | Common null/invalid patterns | Notes |
|---|---|---|---|---|---|---|
| `objectid` | Row ID within a vintage layer | Yes | integer | High | Should be non-null and unique per layer; not stable across years | Use with `vintage_year` as raw/staging composite key. |
| `code` | Zoning class code | Yes | string | High | Label/value drift possible across vintages | Primary class field for composition and mapping. |
| `long_code` | Longer zoning code/label | Yes | string | Med | May vary in formatting or naming by year | Secondary label/check field for mappings. |
| `zoninggroup` | Coarse zoning grouping | Yes | string | High | Group values may shift over time | Candidate coarse grouping field; still drift-check annually. |
| `geometry` | Polygon geometry | Yes | geometry (polygon) | High | Invalid geometry, slivers, topology issues | Required for district overlay and area-weighted rollups. |
| `pending` | Pending zoning status | No | string | Med | Not uniformly meaningful for trend use | Optional context only unless explicitly modeled. |
| `pendingbill` | Pending bill identifier | No | string | Low | Often sparse; format variation possible | Optional context field. |
| `pendingbillurl` | Link to pending bill | No | string/url | Low | Null or stale links possible | Optional documentation field. |
| `sunset_date` | Sunset date metadata | No | date/datetime | Low | Not present in all vintages | Appears in sampled 2021+ layers only. |
| `sunsetbillnum` | Sunset bill number | No | string | Low | Not present in all vintages | Appears in sampled 2021+ layers only. |
| `sunsetbilllink` | Sunset bill URL | No | string/url | Low | Not present in all vintages | Appears in sampled 2021+ layers only. |
| `globalid` | ArcGIS global identifier | No | guid/string | Low | Present only in some vintages | Not reliable as universal cross-vintage key. |
| `created_user` | Record creator user | No | string | Low | Present only in some vintages | Sampled in 2022 only; not part of MVP metrics. |
| `created_date` | Record creation timestamp | No | datetime | Low | Present only in some vintages | Not used for cross-vintage time logic. |
| `last_edited_user` | Last editor user | No | string | Low | Present only in some vintages | Audit field only. |
| `last_edited_date` | Last edit timestamp | No | datetime | Low | Present only in some vintages | Audit field only. |
| `Shape__Area` | Source polygon area in service units | No | numeric | Med | Unit/CRS ambiguity | Do not use directly for denominator metrics without CRS validation. |
| `Shape__Length` | Source polygon perimeter in service units | No | numeric | Low | Unit ambiguity | Optional geometry QA aid only. |
| `vintage_year` (derived) | Snapshot year assigned from source layer | Yes | integer | High | Incorrect assignment if endpoint parsing fails | Canonical time key for zoning snapshots. |

---

## Field availability notes across sampled vintages

Sampled API layers on 2026-03-05: `current`, `2024`, `2022`, `2021`, `2020`,
`2019`.

- `objectid`, `code`, `citycor`, `long_code`, `zoninggroup`, `pending`,
  `pendingbill`, `pendingbillurl`, `Shape__Area`, and `Shape__Length` were
  present in all sampled layers.
- Sunset fields (`sunset_date`, `sunsetbillnum`, `sunsetbilllink`) were present
  in sampled 2021+ layers and absent in sampled 2020/2019.
- `globalid` was present in sampled `current` and `2022` only.
- Edit-tracking fields (`created_user`, `created_date`, `last_edited_user`,
  `last_edited_date`) were observed in sampled 2022 only.

These differences are expected schema drift and should be normalized in staging.

---

## Required fields summary (MVP)

- **Time fields:**
  - derived `vintage_year`
- **Geography / linkage fields:**
  - `geometry`
- **Key / ID fields:**
  - `objectid` (paired with `vintage_year`)
- **Category / grouping fields:**
  - `code`
  - `long_code`
  - `zoninggroup`
- **Other MVP-required fields:**
  - none

---

## Links

- **Source catalog entry:** [`docs/source_catalog/zoning_base_districts.md`](../source_catalog/zoning_base_districts.md)
- **Metadata summary:** [`docs/source_catalog/zoning_base_districts_metadata_summary.md`](../source_catalog/zoning_base_districts_metadata_summary.md)
- **Feasibility checklist:** [`docs/feasibility/zoning_feasibility.md`](../feasibility/zoning_feasibility.md)
- **Limitations register entries:** L7, L8

---

## Notes for implementation later

- Build a standardized staging schema that includes all required MVP fields and
  nullable optional drift fields.
- Add automated checks:
  - not-null on `objectid`, `code`, `zoninggroup`, geometry
  - uniqueness of (`vintage_year`, `objectid`)
  - yearly class-value diff report for `code` and `long_code`
  - geometry validity and sliver-share QA metrics

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
