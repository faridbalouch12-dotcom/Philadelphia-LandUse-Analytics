# Feasibility Checklist — Planning Districts (S1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header

- **Dataset name:** Planning Districts
- **Dataset ID:** S1
- **Files reviewed:** `Planning_Districts.geojson`, `fields (1).json`
- **Reviewer:** Farid
- **Date:** 2026-03-05
- **MVP role:** District spine — reporting unit and spatial join target; geometry source for land-only area denominator

---

## 1) Time field selection

**Goal:** Confirm there is at least one time field that can support monthly aggregation.

**Fill in**
- **Candidate time fields:** None — boundary layer, not an event dataset
- **Canonical time field for MVP:** Not applicable
- **Time semantics:** Static reference dimension for MVP
- **Expected missingness / quirks:** No time field expected or needed
- **Aggregation grain supported:** Districts are the spatial grain, not a time grain

**Pass criteria**
- A single canonical time field is selected and justified, or it is clearly N/A for this dataset type.

**Verdict:** ✅ PASS (N/A — acceptable for a boundary spine; time field not required)

**Mitigation if not pass**
- If boundaries change, introduce boundary versioning and treat as SCD2 (Month 6).

---

## 2) Geo linkage approach

**Goal:** Confirm district polygons support (a) point-in-polygon joins from other datasets and (b) land-only area derivation.

**Questions to answer**
- Does the geometry support point-in-polygon assignment (permits → districts)?
- Can land-only area be derived from this geometry?
- What happens for records near district boundaries?

**Fill in**
- **Geometry present?** Yes — 18 Polygon features, 0% null geometry in extract
- **District assignment method:** These ARE the district polygons; all other datasets join TO this layer (not the reverse)
- **Land-only area support:** Polygon geometry is present and can support land-only area derivation after CRS validation and water-body exclusion (separate step in Month 2)
- **Expected "unassigned" share:** Not applicable for this layer itself; unassigned rates are tracked on the permit/zoning/ACS side
- **Boundary-edge risk:** Permits and other point records near district boundaries may be ambiguously assigned; report near-boundary share for those datasets (L2)
- **CRS / geometry validity concerns:** CRS not confirmed in the extract metadata — validate in Month 2; geometry validity not checked

**Pass criteria**
- Polygon geometry exists and can serve as the spatial spine for point-in-polygon joins.
- Geometry supports land-only area derivation (after CRS validation).

**Verdict:** ✅ PASS — 18 complete polygons; geometry supports both spatial joins and area derivation pending CRS validation

**Mitigation if not pass**
- If geometry is invalid or CRS cannot be confirmed, use an authoritative GIS source (ArcGIS FeatureServer API) as fallback.

---

## 3) Key field completeness

**Goal:** Confirm districts can be uniquely identified for stable joins across all datasets.

**Questions to answer**
- Is there a stable, unique district identifier?
- Is a human-readable label available?

**Fill in**
- **Confirmed keys (in GeoJSON extract):**
  - `objectid`: non-null 18/18, unique_count=18 — confirmed unique numeric key
  - `abbrev`: non-null 18/18, unique_count=18 — confirmed unique text abbreviations (e.g., "RW", "NDEL")
  - `dist_name`: non-null 18/18, unique_count=18 — confirmed unique full names
- **Preferred natural key per official schema:** `DIST_NUM` (Text) — listed in `fields (1).json` but **not present in GeoJSON extract**; confirm availability from authoritative API in Month 2
- **Working key strategy for MVP:** Use `objectid` as interim numeric key; use `dist_name` as display label; confirm whether `DIST_NUM` or `abbrev` should be the canonical `district_id` in `dim_district`
- **Composite key:** Not needed
- **Surrogate key:** Optional; create `district_sk` in warehouse for consistency

**Pass criteria**
- At least one confirmed unique key and one confirmed display label exist.

**Verdict:** ✅ PASS — `objectid` and `dist_name` are both confirmed unique and non-null; natural key strategy to be finalized in Month 2

**Mitigation if not pass**
- If `DIST_NUM` is not available from API, adopt `abbrev` as the canonical short identifier and `dist_name` as the display label; document in decision log.

---

## 4) Category stability

**Goal:** Confirm the fixed district set is stable enough for longitudinal rollups.

**Fill in**
- **Categorical stability:** Fixed 18-district set; stability risk is boundary changes, not label drift
- **Known drift risks:** None expected for MVP window; historical boundary changes (pre-2015) are out of scope

**Pass criteria**
- The district set is fixed or changes are explicitly versioned.

**Verdict:** ✅ PASS — fixed 18-district set; boundary versioning deferred to Month 6 (L1)

---

## 5) Known blockers

**Goal:** Identify anything that would prevent MVP use.

**Fill in**
- **Access blockers:** None — local GeoJSON extract available; authoritative API accessible from OpenDataPhilly
- **Field blockers:** None — `objectid` and `dist_name` are sufficient for MVP joins and display
- **Geometry blockers:** CRS unconfirmed; land-only area cannot be finalized until Month 2 validation — not a blocker for MVP cataloging
- **Legal/licensing blockers:** None — OpenDataPhilly is open access
- **MVP decision:** ✅ Use with constraints

**Constraints to document (MVP)**
- Key: Use `objectid` as interim key; confirm `DIST_NUM` from authoritative API
- Display: `dist_name` (full name), `abbrev` (short label)
- Area: Derive `land_area_sqmi` from geometry after CRS validation — do NOT use `Shape__Area` until units are confirmed

**Verdict:** ✅ PASS — no hard blockers; proceed with local extract for Month 1 documentation

---

## Risk mapping from limitations register

| Risk | Limitations register | Mitigation |
|---|---|---|
| Boundary version treated as static; may have changed since 2015 | L1 | Confirm boundary version from authoritative source; document version used; introduce SCD2 if boundaries change (Month 6) |
| Near-boundary ambiguity for permits/zoning/ACS joins | L2 | Track near-boundary share for all joining datasets; caveat adjacent-district comparisons (Month 2) |
| Land-only area unavailable until CRS validated | L11 | Suppress density metrics until area is confirmed; compute and store `land_area_sqmi` in Month 2 pipeline |

---

## Final feasibility verdict

- **Verdict:** ✅ Use with constraints
- **Constraints:**
  - Use `objectid` as interim natural key until `DIST_NUM` is confirmed from authoritative API
  - Use `dist_name` as display label; `abbrev` as short label
  - Derive `land_area_sqmi` from geometry after CRS validation; do not use `Shape__Area` as denominator until confirmed
- **Next validation steps (Month 2):**
  - Pull from authoritative API and confirm `DIST_NUM`, `LABEL`, and schema alignment with GeoJSON extract
  - Validate CRS, geometry validity, and compute `land_area_sqmi`
  - Confirm boundary version and check if newer version exists
  - Finalize `district_id` strategy and document in decision log

---

## Links

- **Source catalog:** [`docs/source_catalog/planning_districts.md`](../source_catalog/planning_districts.md)
- **Metadata summary:** [`docs/source_catalog/planning_districts_metadata_summary.md`](../source_catalog/planning_districts_metadata_summary.md)
- **Critical fields dictionary:** [`docs/data_dictionary/planning_districts_critical_fields.md`](../data_dictionary/planning_districts_critical_fields.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
