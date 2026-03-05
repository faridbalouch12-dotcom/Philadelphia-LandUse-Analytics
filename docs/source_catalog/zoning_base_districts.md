# Source catalog - Zoning Base Districts (S3)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Overview

- **Dataset purpose:** Citywide zoning polygon snapshots by vintage year, used
  to track district-level zoning composition and zoning churn over time.
- **What one row/feature represents:** One zoning polygon in one vintage layer.
- **How this dataset is used in the project:**
  - Feature-level zoning snapshot layer by year
  - District-year zoning composition rollups
  - Year-to-year zoning churn metrics (with strict comparability caveats)
- **Primary consumers:** Both district-first rollups and map-first layers.

---

## Access

- **Primary source/host:** OpenDataPhilly listing with ArcGIS feature service
  resources.
- **Access method(s):**
  - ArcGIS FeatureServer API (preferred)
  - GeoJSON resource links per vintage
- **Preferred method for this project (and why):**
  - Pull each vintage from FeatureServer/GeoJSON endpoints and normalize into a
    common staging schema.
  - Reason: geometry is preserved; per-vintage extraction is explicit and
    automatable.
- **Known limits / constraints:**
  - Multi-endpoint vintage access, not one single historical table.
  - Schema drift exists across vintages (field additions/removals).
- **Expected size / volume notes:**
  - Approximately 29k polygons per sampled vintage.
  - Overlay workflows increase compute cost compared with point datasets.

---

## Time fields

- **Candidate time fields:**
  - Vintage year from layer/resource name (stable candidate)
  - Audit timestamps (`created_date`, `last_edited_date`) only in some vintages
- **Canonical time field for the project (and why):**
  - **`vintage_year` (derived)** from the source layer being ingested.
  - Reason: row-level date fields are not consistently available year-to-year.
- **Time semantics:** Snapshot-vintage time, not event-time.
- **Time coverage (from source listing):** pre-2012, 2015-2024, and current.
- **Time granularity supported:** Yearly snapshot comparisons.

---

## Geometry

- **Geometry type:** Polygon (`esriGeometryPolygon`)
- **Geometry field(s) / how geometry is derived:**
  - Native polygon geometry from each vintage service layer.
- **CRS / coordinate system:** Validate during Month 2 ingestion from service
  metadata for each pulled layer.
- **Spatial join role:**
  - Overlay zoning polygons with planning districts to compute district-year
    composition and churn.
- **Known geometry issues:**
  - Slivers and topology differences across vintages can create false churn if
    not handled with area thresholds and comparability rules.

---

## Keys

- **Candidate primary key(s) / unique identifier(s):**
  - `objectid` is present in sampled vintages and appears unique within a
    single layer.
  - `code` is a zoning class label, not a row-level unique polygon key.
- **Uniqueness confidence:** High within a vintage for `objectid`; low for
  cross-vintage continuity.
- **Proposed composite key (for raw/staging):** `vintage_year + objectid`
- **Surrogate key needed?:** Yes, for warehouse consistency (for example,
  `zoning_polygon_sk`) because source IDs are not guaranteed stable across
  vintages.
- **Deduping rules:**
  - Deduping is per-vintage only.
  - Do not assume `objectid` continuity between years.

---

## Key columns

- **Required fields (MVP):**
  - `objectid`
  - `code`
  - `long_code`
  - `zoninggroup`
  - `geometry`
  - derived `vintage_year`
- **Optional fields (future):**
  - `pending`, `pendingbill`, `pendingbillurl`
  - `sunset_date`, `sunsetbillnum`, `sunsetbilllink`
  - `globalid`, edit-tracking fields (when present)
- **High-risk fields (schema drift):**
  - Sunset and audit fields are not present in all vintages.
  - Field casing and system fields differ by layer.
- **Categorical fields used for grouping (and drift risk):**
  - Primary: `code`, `long_code`, `zoninggroup`
  - Risk: class/code taxonomy can drift by year; mapping needed before claims.

---

## Update cadence

- **Published update cadence:** Annual snapshots with a current layer.
- **Does history change or append-only?:**
  - Vintages behave like snapshots.
  - Current layer can be edited between snapshots.
- **Freshness expectation for dashboards:**
  - MVP zoning outputs should be annual (not daily/real-time).
- **Notes on versioning:**
  - Year-specific layers must be versioned explicitly in ingestion.
  - Comparability is a modeling decision, not guaranteed by source structure.

---

## Risks

- **Data quality risks:** schema drift across vintages; inconsistent optional
  fields; possible class label/code shifts.
- **Spatial risks:** polygon topology and slivers may inflate apparent change.
- **Time risks:** snapshot-year ambiguity if `vintage_year` is not explicitly
  set from endpoint metadata.
- **Comparability risks:** year-to-year class mappings may not be one-to-one;
  district composition shifts can include schema artifacts.
- **Bias/interpretation risks:** do not claim all measured churn is policy or
  market change until schema and geometry comparability checks pass.

---

## Notes

- **Open questions / validation TODOs:**
  - Confirm all intended vintage endpoints and naming conventions.
  - Profile field-level coverage for each selected MVP year before metric specs.
  - Define class harmonization rules and unknown bucket treatment.
  - Define sliver threshold and area-weighting rules for churn metrics.
- **Hard-decision deferral (intentional):**
  - Final year window and final class harmonization strategy are deferred until
    the full metadata -> source -> feasibility -> dictionary loop is completed
    across datasets.

---

## Links

- **Dataset landing page:** <https://opendataphilly.org/datasets/zoning-base-districts/>
- **Metadata summary:** [`docs/source_catalog/zoning_base_districts_metadata_summary.md`](./zoning_base_districts_metadata_summary.md)
- **Feasibility checklist:** [`docs/feasibility/zoning_feasibility.md`](../feasibility/zoning_feasibility.md)
- **Critical fields dictionary:** [`docs/data_dictionary/zoning_critical_fields.md`](../data_dictionary/zoning_critical_fields.md)
- **MVP datasets context:** [`docs/03_mvp_datasets.md`](../03_mvp_datasets.md)
- **Data access notes:** [`docs/04_data_access_notes.md`](../04_data_access_notes.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
