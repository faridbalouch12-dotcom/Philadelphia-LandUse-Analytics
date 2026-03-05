# Metadata summary - Zoning Base Districts (S3)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Purpose

Pre-work metadata summary for S3 before finalizing the full source catalog.
This captures coverage, cadence, candidate vintage/time handling, category
fields, location fields, and schema-drift warnings needed for feasibility work.

---

## Dataset overview

- **Dataset name:** Zoning Base Districts (vintages)
- **Publisher:** City of Philadelphia / ArcGIS (via OpenDataPhilly listing)
- **Source page:** <https://opendataphilly.org/datasets/zoning-base-districts/>
- **Dataset role in project:** Zoning snapshot backbone for district-year zoning
  composition and churn analysis.

---

## Coverage and cadence

- **Published cadence:** Annual snapshots plus a "current" layer.
- **Coverage shown on source page (as of 2026-03-05):**
  - Current
  - 2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016, 2015
  - Pre-2012
- **MVP working window from existing project notes:** 2020-2025 candidate
  analysis window (subject to final comparability decision).

---

## Geometry and location fields

- **Geometry type:** Polygon (`esriGeometryPolygon`)
- **Primary location field:** `geometry` (polygon boundaries)
- **Other location-like fields in sampled vintages:** `citycor`
- **Spatial use:** Overlay with planning districts for district-level zoning
  rollups and churn calculations.

---

## Candidate event-date / time fields

This is a snapshot dataset. There is no reliable per-row event timestamp across
all vintages.

- **Candidate time semantics:**
  - Vintage year from layer/resource label (recommended canonical time input)
  - Optional audit timestamps when present in specific vintages (not stable)
- **Canonical time decision for feasibility pass:** derive and store
  `vintage_year` from the resource/layer being ingested.

---

## Category fields (for zoning composition)

Fields observed across sampled vintages that can support category groupings:

- `code` (or `CODE` in current layer display metadata)
- `long_code`
- `zoninggroup`
- `pending` (status flag, optional for interpretation)

---

## Size warnings

- Feature count is roughly ~29k polygons per vintage layer in sampled years.
- Multi-vintage pulls multiply total volume quickly (for example, 6 vintages is
  ~174k polygon features before overlays).
- This is smaller than S2 permits by row count, but heavier geometrically due
  to full-city polygon layers per vintage.

---

## Observed schema differences (sampled vintages)

Quick API probe on 2026-03-05 across `current`, `2024`, `2022`, `2021`,
`2020`, and `2019` showed drift:

- `sunset_date`, `sunsetbillnum`, `sunsetbilllink` appear in 2021+ sampled
  layers but not in 2020/2019.
- `globalid` appears in `current` and `2022`, but not in all sampled vintages.
- Editor-tracking fields (`created_user`, `created_date`, `last_edited_user`,
  `last_edited_date`) appeared in sampled 2022 but not in other sampled years.
- Display field casing differs (`CODE` vs `code`).

These differences are exactly the comparability/integration risk to handle in
the feasibility and data dictionary loop.

---

## Sampled layer stats (2026-03-05 probe)

| Layer | Feature count | Field count | Notes |
|---|---:|---:|---|
| current | 29,196 | 14 | includes `globalid` |
| 2024 | 29,157 | 13 | includes sunset fields |
| 2022 | 29,169 | 18 | includes edit-tracking + `globalid` |
| 2021 | 29,143 | 13 | includes sunset fields |
| 2020 | 28,989 | 10 | no sunset fields in sample |
| 2019 | 29,024 | 10 | no sunset fields in sample |

---

## Links

- **Source catalog entry:** [`docs/source_catalog/zoning_base_districts.md`](./zoning_base_districts.md)
- **Feasibility checklist:** [`docs/feasibility/zoning_feasibility.md`](../feasibility/zoning_feasibility.md)
- **Critical fields dictionary:** [`docs/data_dictionary/zoning_critical_fields.md`](../data_dictionary/zoning_critical_fields.md)
- **MVP datasets context:** [`docs/03_mvp_datasets.md`](../03_mvp_datasets.md)
- **Data access notes:** [`docs/04_data_access_notes.md`](../04_data_access_notes.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
