# Metadata summary — L&I Building and Zoning Permits (S2)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Purpose

Pre-work summary of dataset metadata reviewed before writing the full source catalog entry. Captures the key structural facts needed to assess feasibility and inform cataloging decisions.

---

## Dataset overview

- **Dataset name:** L&I Building and Zoning Permits
- **Publisher:** City of Philadelphia, Licenses & Inspections
- **Source:** OpenDataPhilly
- **Source URL:** <https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/>

---

## Geometry type

- **Type:** Points — permit records geocoded to permit address/location.
- **Geometry fields present:**
  - `the_geom` (point geometry)
  - `the_geom_webmercator` (web-mercator projection)
  - `lat`, `lng` and `geocode_x`, `geocode_y` as coordinate fields

---

## Feature count

- **Full extract:** 908,878 rows × 49 columns
- **Last-5-year slice** (`permitissuedate` window): 184,671 rows covering 61 months (2021-03 through 2026-03)

---

## Candidate key and name fields

**Primary key candidates:**
- `permitnumber` — business key; best candidate for "one row = one permit"
- `objectid` — row-level unique ID
- `posse_jobid` — also unique in the last-5-year slice

**Secondary join IDs (useful for later enrichments):**
- `addressobjectid`, `opa_account_num`, `parcel_id_num`, `parentjobid`, `zoningpermitjobid`

**Time fields:**
- `permitissuedate` — canonical event date for MVP monthly rollups
- `permitcompleteddate`, `mostrecentinsp`, `certificateofoccupancydate` — lifecycle signals; much sparser

**Category fields (for composition):**
- `permittype`, `permitdescription` — best candidates for stable coarse grouping
- `commercialorresidential`, `status`, `applicanttype`, `typeofwork` — usable with care; `typeofwork` is higher-cardinality

**Geography fields present (non-planning-district):**
- `council_district` — City Council district (not planning district)
- `censustract` — useful for auditing / optional fallback
- `zip`

**Planning district field:** Not present. Planning district assignment requires a spatial join (point-in-polygon) against the planning districts polygon layer.

---

## Update cadence

- **Published cadence:** Daily.
- **Implication for MVP:** Raw feature layer can be refreshed frequently, but primary reporting rollup is district × month — so daily refresh mainly affects the current month's partial counts.

---

## Top risks

- **Geocoding gaps:** Permits are address-geocoded; some records may lack valid coordinates or be mislocated near district boundaries, affecting district assignment accuracy.
- **Category drift:** `permittype`/`permitdescription` values may shift over time; `typeofwork` has 59 distinct values with label variants — composition metrics can be misleading if categories aren't mapped to stable groups.
- **Date field ambiguity:** Four candidate time fields exist with very different missingness profiles; choosing the wrong one (e.g., `certificateofoccupancydate` at ~97% null) would break monthly rollups or produce misleading trend narratives.

---

## Links

- **Source catalog entry:** [`docs/source_catalog/li_permits.md`](./li_permits.md)
- **Source reference:** [`docs/03_mvp_datasets.md`](../03_mvp_datasets.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-05 | Added top risks section (grading feedback) | Farid  |
