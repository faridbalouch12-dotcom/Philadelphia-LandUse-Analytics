# Source catalog — L&I Building and Zoning Permits (S2)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Overview

- **Dataset purpose:** City of Philadelphia Licenses & Inspections permits dataset covering building and zoning permits. Used as the **primary physical-change signal** for district-first trends and comparisons.
- **What one row represents:** One permit record identified by a unique permit number.
- **How this dataset is used in the project:**
  - Feature-level permits layer (event-level, point geometry)
  - District-first rollups: district × month permit counts, intensity (permits per land sq mi), and basic composition (coarse permit types)
- **Primary consumers:** Both
  - **District-first** dashboards (rollups)
  - **Map-first** exploration later (feature-level points)

---

## Access

- **Primary source/host:** OpenDataPhilly "Licenses and Inspections Building and Zoning Permits."
- **Access method(s):**
  - API (Carto SQL API via OpenDataPhilly)
  - Bulk downloads (CSV/SHP/GeoJSON)
- **Preferred method for this project (and why):**
  - Prefer API/date-filtered extracts (dataset is large; API is recommended by the publisher).
  - For profiling in Month 1, used a local extract: `permits_trimmed.csv` + field metadata `fields.json`.
- **Known limits / constraints:**
  - "Very large dataset" warning; bulk downloads can be heavy.
- **Expected size / volume notes:**
  - Full dataset spans 2007–present.
  - Project MVP focuses on **last 5 years** (see Notes).

---

## Time Fields

- **Candidate time fields:**
  - `permitissuedate` — "Date permit was issued."
  - `permitcompleteddate` — "Date permit was completed."
  - `mostrecentinsp` — "Most recent inspection date."
  - `certificateofoccupancydate` (present but very sparse in the last-5-year sample)
- **Canonical time field for the project (and why):**
  - **`permitissuedate`** — complete enough for monthly aggregation; aligns to permit issuance event time.
- **Time semantics:**
  - Event-time proxy (issuance date). `permitcompleteddate`/inspections are lifecycle signals but not MVP-critical.
- **Time coverage (full):** 2007–present
- **Time granularity supported:**
  - Monthly (MVP rollups)
  - Daily exists, but not needed for MVP dashboard grain

---

## Geometry

- **Geometry type:** Points (geocoded to permit addresses).
- **Geometry field(s) / how geometry is derived:**
  - `the_geom` (point geometry in the extract)
  - Metadata also describes a point geometry "Shape" field.
- **CRS / coordinate system:** Not confirmed in Month 1 (to validate in Month 2).
- **Spatial join role:**
  - Assign each permit point to a planning district (point-in-polygon)
  - Retain as feature layer for map-first later
- **Known geometry issues:**
  - Permits are address-geocoded; points near district boundaries may be ambiguous.

---

## Keys

- **Candidate primary key(s) / unique identifier(s):**
  - `permitnumber` — "Unique identifier for each permit issued."
  - `objectid` — unique row identifier (present in the extract)
  - `posse_jobid` — "Objectid and join field for related records"
- **Uniqueness confidence:** High for the MVP last-5-year slice (validated in the local extract: `permitnumber` has no duplicates).
- **Composite key (if needed):**
  - Not needed for last-5-year MVP, assuming `permitnumber` remains stable.
- **Surrogate key needed?**
  - Optional. `objectid` can be kept as a surrogate row key for the raw/staging layer.
- **Deduping rules (if duplicates occur):**
  - If future pulls contain duplicates/revisions, dedupe by `permitnumber` with an explicit revision rule (e.g., "latest record wins" if an update timestamp exists).

---

## Key Columns

- **Required fields (MVP):**
  - Time: `permitissuedate`
  - ID/key: `permitnumber` (and optionally `objectid`)
  - Geography: `the_geom` (or lat/lng equivalents if needed)
  - Category (coarse composition): `permittype`, `permitdescription`, and optionally `commercialorresidential`
  - Join helper (optional but useful): `censustract` (for auditing / fallback linkage)
- **Optional fields (future):**
  - Lifecycle: `permitcompleteddate`, `mostrecentinsp`
  - Parent/child relationships: `parentjobid` (if building project grouping later)
  - Parcel linkages: `opa_account_num`, `parcel_id_num` (if later parcel-based enrichments)
- **High-risk fields (often null / unreliable / interpretability risk):**
  - `usecategories` (high missingness / very high cardinality in the sample)
  - `occupancytype` (flagged "coming soon" and sparse)
  - `numberofunits` — explicitly self-reported and not verified; requires disclaimer if used
- **Categorical fields used for grouping (and drift risk):**
  - MVP grouping: `permittype` / `permitdescription` (stable, low cardinality)
  - Optional later: `typeofwork` (more granular; likely needs mapping due to label variation)

---

## Update Cadence

- **Published update cadence:** Updated daily.
- **Does history change or append-only?**
  - Likely includes edits/backfills over time (not validated in Month 1; validate in Month 2 by comparing repeated API pulls).
- **Freshness expectation for dashboards:**
  - MVP can be refreshed daily or weekly; district-month rollups are still monthly outputs.
- **Notes on versioning:**
  - Records originate from two systems: HANSEN (2007–2020) vs ECLIPSE (2020–present).
  - For the MVP last-5-year window, all records should be ECLIPSE (to validate in Month 2 pipeline).

---

## Risks

- **Data quality risks:** Permits may include duplicates or amendments sharing a permit number; revision/backfill behavior not validated. `numberofunits` is self-reported and unverified.
- **Spatial risks:** Address-geocoded points near district boundaries can be ambiguous; district assignment uncertainty can affect district-level rollups.
- **Time risks:** Multiple date fields exist; using completion/inspection dates without validation can produce misleading trend narratives.
- **Comparability risks:** New permit types and label drift across years can make composition trends misleading if using overly granular categories. System transition from HANSEN to ECLIPSE at ~2020 may introduce schema discontinuities.
- **Bias/interpretation risks:** Do not claim "housing units created" from `numberofunits` without a prominent disclaimer and separate validation, since it is self-reported and not verified.

---

## Notes

- **MVP time scope:** The project's locked scope is last 5 years, defined as `permitissuedate >= (max(permitissuedate) - 5 years)`.
- **Local profiling slice (Month 1):** Used `permits_trimmed.csv` to validate feasibility assumptions about keys, missingness, and category stability.
- **Validation TODOs for Month 2:**
  - Confirm CRS and geometry validity (point-in-polygon stability)
  - Confirm API extraction limits/paging behavior and schema stability across repeated pulls
  - Define "unassigned permits" reporting and boundary-sensitivity metric
  - Decide whether `typeofwork` is in-scope for MVP composition (likely "mapping required")
  - Validate HANSEN vs ECLIPSE boundary in the 5-year window

---

## Links

- **Dataset landing page:** <https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/>
- **Metadata page:** Use the "Metadata" resource link from the dataset page.
- **API documentation:** <https://carto.com/developers/sql-api/>
- **Local files used for Month-1 profiling:** `permits_trimmed.csv`, `fields.json`
- **Internal project docs:**
  - Source reference: [`docs/03_mvp_datasets.md`](../03_mvp_datasets.md)
  - Data access notes: [`docs/04_data_access_notes.md`](../04_data_access_notes.md)
  - Assumptions log: [`docs/assumptions_log.md`](../assumptions_log.md) (A3–A6)
  - Limitations register: [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
