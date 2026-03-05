# Source Catalog Template

**Author:** Farid
**Created:** 2026-03-04
**Last Updated:** 2026-03-04
**Status:** Draft

Use this template for every dataset you onboard. Keep sections concise but specific. The goal is that a reviewer (or future you) can answer: **what is this dataset, how do we access it, how do we use it, and what could go wrong?**

---

## Overview
**What it is:** A plain-language description of the dataset and what a “record” represents.  
**Project relevance:** Explain how this dataset supports the Philly district-first platform (e.g., district spine, permits time series, zoning snapshots, ACS context).  
**Intended outputs:** List the main artifacts this dataset feeds (feature-level layer, district rollups, dashboards).

**Fill in:**
- Dataset purpose:
- What one row/feature represents:
- How this dataset is used in the project:
- Primary consumers (district-first rollups, map-first layers, both):

---

## Access
**What it is:** How to obtain the data, including preferred access method and any constraints.  
**Include:** endpoint(s), format(s), authentication needs (if any), and size/performance warnings.

**Fill in:**
- Primary source/host (OpenDataPhilly / ArcGIS FeatureServer / Census API / etc.):
- Access method(s) (API / GeoJSON / CSV / SHP / etc.):
- Preferred method for this project (and why):
- Known limits (rate limits, row caps, paging, max payload, etc.):
- Expected size / volume notes:

---

## Time Fields
**What it is:** Which fields define time and how they should be interpreted.  
**Why it matters:** District-first metrics depend on a single canonical time field for aggregation; snapshots (zoning) need explicit vintage/year; ACS needs explicit period labels.

**Fill in:**
- Candidate time fields:
- Canonical time field for the project (and why):
- Time semantics (event time vs update time vs period estimate):
- Time coverage (start/end):
- Time granularity supported (daily/monthly/yearly/period):

---

## Geometry
**What it is:** Spatial representation and how it links to planning districts.  
**Include:** geometry type, CRS (if known), and how spatial assignment will be done conceptually.

**Fill in:**
- Geometry type (point/line/polygon/tabular-only):
- Geometry field(s) / how geometry is derived:
- CRS / coordinate system (if known):
- Spatial join role (district attribution, overlay, mapping layer):
- Known geometry issues (invalid polygons, missing coordinates, slivers, etc.):

---

## Keys
**What it is:** How you uniquely identify records and maintain stable joins over time.  
**Why it matters:** Prevents duplicates, enables incremental refresh later, and makes downstream facts trustworthy.

**Fill in:**
- Candidate primary key(s) / unique identifier(s):
- Uniqueness confidence (high/medium/low) + why:
- If no stable key exists, proposed composite key (fields used):
- Surrogate key needed? (yes/no) + rationale:
- Deduping rules (if duplicates occur):

---

## Key Columns
**What it is:** The minimum set of columns required to support the MVP and future extensions.  
**Guidance:** Mark fields as Required vs Optional, and note any columns known to be messy.

**Fill in:**
- Required fields (MVP):
- Optional fields (future):
- High-risk fields (often null, inconsistent, schema drift):
- Categorical fields used for grouping (and drift risk):

---

## Update Cadence
**What it is:** How often the dataset updates and what “freshness” means for your product.  
**Include:** whether updates are daily, weekly, monthly, ad hoc; and whether historical records change.

**Fill in:**
- Published update cadence:
- Does history change (backfills/edits) or append-only?
- Freshness expectation for dashboards (near-real-time vs monthly refresh okay):
- Notes on versioning (e.g., zoning vintages by year):

---

## Risks
**What it is:** Concrete ways this dataset can produce wrong or misleading analysis.  
**Requirement:** List risks that matter for *this project*, not generic “data may be messy.”

**Fill in:**
- Data quality risks (missingness, duplicates, inconsistent categories):
- Spatial risks (geocoding gaps, boundary effects, geometry validity):
- Time risks (wrong time field, retroactive edits, period estimate caveats):
- Comparability risks (schema drift across years/vintages):
- Bias/interpretation risks (what not to claim from this dataset):

---

## Notes
**What it is:** Any additional context that doesn’t fit above but will matter later.  
**Examples:** known quirks, edge-case handling expectations, open questions to validate.

**Fill in:**
- Known quirks / edge cases:
- Open questions / validation TODOs:
- Decisions made about this dataset (link decision log entries if applicable):

---

## Links
**What it is:** One place to find the authoritative source and supporting references.  
**Include:** dataset page, metadata page, API docs, schema docs, related city docs, etc.

**Fill in:**
- Dataset landing page:
- Metadata page:
- API documentation:
- Related documentation / definitions:
- Internal project docs that use this dataset (metrics specs, feasibility notes, etc.):

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-04 | Initial draft      | Farid  |