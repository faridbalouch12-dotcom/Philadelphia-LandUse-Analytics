# Feasibility checklist - Zoning Base Districts (S3)

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
- **MVP role:** Zoning snapshot source for district-year composition and churn.

---

## 1) Time field selection

**Goal:** Confirm there is a usable time field for year-level zoning analysis.

**Fill in**
- **Candidate time fields:**
  - Vintage year from layer/resource label
  - Optional edit timestamps in some vintages only
- **Selected canonical time field for MVP:** derived `vintage_year`
- **Time semantics:** snapshot-vintage (not event time)
- **Expected missingness / quirks:** no stable per-row date field across all
  vintages; edit fields appear only in certain years
- **Time coverage:** pre-2012, 2015-2024, current (as listed on source page)
- **Aggregation grain supported:** yearly snapshot comparisons

**Pass criteria**
- A single canonical time approach is selected and justified.

**Verdict:** PASS WITH CONSTRAINTS - use derived `vintage_year`; do not rely on
row-level date fields for cross-year comparisons.

**Mitigation if not pass**
- Restrict to a smaller year window where endpoint naming and schema can be
  verified end-to-end.

---

## 2) Geo linkage approach

**Goal:** Confirm zoning polygons can be assigned to planning districts.

**Fill in**
- **Geometry present?:** Yes - polygon geometry in sampled layers
- **District assignment method:** Polygon overlay/intersection with planning
  district polygons; aggregate area-weighted zoning class shares by
  district-year
- **Expected "unassigned" share and measurement:** For polygons, track
  non-intersecting share and invalid geometry share (should be near zero)
- **Boundary-edge risk:** Slivers and segmentation differences may appear as
  false change; track sliver share and apply minimum area threshold
- **CRS / geometry validity concerns:** CRS and geometry validity checks are
  required in Month 2 ingestion before trusting churn rates

**Pass criteria**
- Clear district linkage method and quality checks are defined.

**Verdict:** PASS WITH CONSTRAINTS - spatial linkage is feasible, but sliver and
CRS controls are mandatory.

**Mitigation if not pass**
- Defer churn metric claims and keep only coarse composition until geometry QA
passes.

---

## 3) Key field completeness

**Goal:** Confirm records can be uniquely identified in a way that supports
repeatable ingestion.

**Fill in**
- **Candidate unique ID field(s):**
  - `objectid` (within-vintage unique in sampled layers)
  - `globalid` exists only in some sampled vintages, so not universal
- **Uniqueness confidence:** High within a vintage, low across vintages
- **Composite key for raw/staging:** `vintage_year + objectid`
- **Deduping policy:** Dedupe only within each vintage layer; never treat
  `objectid` as a cross-year identity
- **Join keys to other tables:**
  - spatial join to districts via geometry
  - join to class mapping via (`vintage_year`, `code`) or mapped class key

**Pass criteria**
- Stable per-vintage key strategy is documented.

**Verdict:** PASS WITH CONSTRAINTS - keying is workable when scoped to
per-vintage identity.

**Mitigation if not pass**
- Add warehouse surrogate keys and persist raw source identifiers for lineage.

---

## 4) Category stability

**Goal:** Confirm zoning classes can be grouped consistently year to year.

**Fill in**
- **Categorical fields used in MVP metrics:** `code`, `long_code`,
  `zoninggroup`
- **Known drift risks:**
  - Class labels/codes may change across vintages
  - Optional status/context fields differ by year
- **Proposed grouping strategy:** Start with coarse mapped groups plus
  `unknown/unmapped` bucket; only publish trend claims after mapping QA
- **Comparability constraints:** Avoid strong year-to-year causal language until
  class harmonization checks are complete
- **How drift will be monitored:** Year-by-year value set diff on
  `code`/`long_code`; track unmapped share

**Pass criteria**
- Drift-aware grouping strategy exists, or unstable comparisons are explicitly
scoped out.

**Direct answer to key feasibility question**
- **"Are class codes consistent year-to-year?"** Not proven yet. Current
  evidence supports **partial consistency with known drift risk**, so metrics
  must use mapping + unknown share tracking before hard claims.

**Verdict:** PASS WITH CONSTRAINTS - usable for MVP only with explicit
harmonization guardrails.

**Mitigation if not pass**
- Narrow the vintage window and/or publish only single-year composition (no
year-over-year churn claims).

---

## 5) Known blockers

**Fill in**
- **Access blockers:** None hard; multi-endpoint management required.
- **Field blockers:** No blocker for baseline composition fields in sampled
  vintages.
- **Versioning blockers:** Schema drift across vintages is a known risk, not a
  hard blocker.
- **Legal/licensing blockers:** None identified.
- **MVP decision:** Use with constraints.

**Unknowns to validate later (explicit)**
- Confirm endpoint details for each target vintage in the final chosen window.
- Confirm class-code harmonization quality before publishing churn narratives.
- Confirm CRS consistency across vintage pulls.

---

## Risk mapping from `03_mvp_datasets.md`

| Risk | Where tracked | Mitigation |
|---|---|---|
| R1: class label/code drift across vintages | limitations register L7 | Class mapping table + unknown bucket + unmapped share metric |
| R2: boundary/geometry differences affect comparability | limitations register L8 and L2 | Area-weighted overlay, sliver threshold, boundary caveats |
| R3: schema inconsistency across vintages | limitations register L7 | Standardized staging schema + per-vintage field audit |

---

## Final feasibility verdict

- **Verdict:** USE WITH CONSTRAINTS
- **Constraints:**
  - Derive `vintage_year` from endpoint/resource, not row-level date fields
  - Use per-vintage keying (`vintage_year + objectid`)
  - Require class mapping and unknown-share tracking before trend claims
  - Apply sliver/geometry QA before churn interpretation
- **Next validation steps (Month 2):**
  - Build per-vintage schema audit table
  - Build year-to-year class value diff report
  - Build overlay QA metrics (invalid geometry, sliver share, non-intersection)

---

## Links

- **Metadata summary:** [`docs/source_catalog/zoning_base_districts_metadata_summary.md`](../source_catalog/zoning_base_districts_metadata_summary.md)
- **Source catalog:** [`docs/source_catalog/zoning_base_districts.md`](../source_catalog/zoning_base_districts.md)
- **Critical fields dictionary:** [`docs/data_dictionary/zoning_critical_fields.md`](../data_dictionary/zoning_critical_fields.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
