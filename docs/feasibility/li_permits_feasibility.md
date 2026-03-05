# Feasibility checklist — L&I Building and Zoning Permits (S2)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-05
**Status:** Draft

---

## Dataset header

- **Dataset name:** Licenses & Inspections Building and Zoning Permits
- **Dataset ID:** S2
- **Source page / endpoint:** <https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/>
- **Files reviewed:** `permits_trimmed.csv` (data), `fields.json` (metadata)
- **Reviewer:** Farid
- **Date:** 2026-03-05
- **MVP role:** Physical change backbone (permit events → district × month rollups)
- **Locked analysis window:** Last 5 years by `permitissuedate` (2021-03 through 2026-03; 184,822 rows; 61 months)

---

## 1) Time field selection

**Goal:** Confirm there is at least one time field that can support monthly aggregation.

**Questions to answer**
- Does the dataset contain a time field that represents event time?
- Can the time field support aggregation at the required grain (month)?
- Are there multiple candidate time fields that could change interpretation?

**Fill in**
- **Candidate time fields:**
  - `permitissuedate` (0% null in-window) — best event-time proxy for monthly rollups
  - `permitcompleteddate` (~21.86% null) — lifecycle signal, not MVP
  - `mostrecentinsp` (~16.32% null) — lifecycle signal, not MVP
  - `certificateofoccupancydate` (~97.01% null) — not usable in MVP
- **Canonical time field for MVP:** `permitissuedate`
- **Time semantics:** Event-time proxy ("permit issued")
- **Expected missingness / quirks:** 0% null in the last-5-year window; lifecycle fields are substantially incomplete
- **Time coverage:** 2007–present (full dataset); last-5-year window: 2021-03 through 2026-03
- **Aggregation grain supported:** Monthly (61 months in the window)

**Pass criteria**
- A single canonical time field is selected and justified.
- Known caveats are documented.

**Verdict:** ✅ PASS — `permitissuedate` is complete and supports monthly aggregation.

**Mitigation if not pass**
- If issued date proves misleading for certain narratives, defer lifecycle analyses to Phase 2 with additional validation rules.

---

## 2) Geo linkage approach

**Goal:** Confirm records can be assigned to planning districts and retained as feature-level geometry.

**Questions to answer**
- Can records be linked to planning districts via geometry?
- What happens for records near district boundaries?
- How will linkage quality be measured?

**Fill in**
- **Geometry present?** Yes — points (geocoded to permit address/location)
- **District assignment method:** Point-in-polygon using `the_geom` against planning district polygons; fallback to lat/lng if geometry parsing fails
- **Expected "unassigned" share and how you'll measure it:** Track "unassigned to district" count/share per district-month as a quality indicator; publish alongside rollup counts
- **Boundary-edge risk and how you'll report it:** Permits near district boundaries may be assigned inconsistently; report a "near-boundary share" metric (optional sensitivity indicator); caveat adjacent-district comparisons where near-boundary share is high
- **CRS / geometry validity concerns:** CRS not confirmed in Month 1 — validate in Month 2 pipeline; `the_geom` is 0% null in-window so geometry coverage is strong

**Pass criteria**
- Clear, auditable linkage method exists.
- Plan to quantify linkage quality.

**Verdict:** ✅ PASS — geometry is effectively complete; district attribution is viable via point-in-polygon.

**Mitigation if not pass**
- Keep records as "unassigned" rather than guessing; report the unassigned share explicitly and caveat comparisons.

---

## 3) Key field completeness

**Goal:** Confirm records can be uniquely identified to avoid duplicates and enable consistent rollups.

**Questions to answer**
- Is there a stable unique identifier?
- Do you expect duplicates, and how will you treat them?

**Fill in**
- **Candidate primary key / unique ID field(s):**
  - `permitnumber` — 100% non-null, 100% unique in window (business key)
  - `objectid` — 100% non-null, 100% unique (row-level key)
  - `posse_jobid` — 100% non-null, 100% unique in window
- **Uniqueness confidence:** High — `permitnumber` has zero duplicates in the last-5-year slice
- **Expected completeness:** 100% non-null for all three key candidates in window
- **Composite key:** Not needed for MVP
- **Deduping policy:** If future API pulls include revisions, dedupe by `permitnumber` with "latest record wins" rule; track revision share as a quality metric
- **Join keys to other tables:** `permitnumber` → permits fact table; `the_geom` → district polygon (spatial join); `censustract` → optional ACS crosswalk later
- **Additional note:** `systemofrecord` = 100% ECLIPSE in the last-5-year window — no HANSEN/ECLIPSE mixed-system complication for MVP

**Pass criteria**
- Key strategy exists and is documented.
- Known duplicate/revision behavior acknowledged.

**Verdict:** ✅ PASS — stable business key exists and supports event-level grain.

**Mitigation if not pass**
- Introduce surrogate key and explicit "latest record wins" rule if update timestamps exist; track revision share.

---

## 4) Category stability

**Goal:** Confirm records can be grouped over time without schema or label drift breaking metrics.

**Questions to answer**
- Are categorical fields stable across time?
- Do label values drift?
- Are new categories introduced over time?

**Fill in**
- **Categorical fields used in MVP metrics:**
  - `permittype` — low cardinality, complete → primary grouping field
  - `permitdescription` — low cardinality, complete → supplement to `permittype`
  - `commercialorresidential` — 2 values, ~0.69% null → optional composition dimension
  - `applicanttype` — 4 values, complete
- **Known drift risks:**
  - `typeofwork` has 59 distinct values with label variants — high drift risk if used for time series without mapping
  - `usecategories` is ~88.75% null and high-cardinality — not usable for MVP
  - System transition from HANSEN (pre-2020) to ECLIPSE (2020+) may introduce historical schema discontinuities outside the MVP window
- **Proposed grouping strategy:** Use `permittype`/`permitdescription` for MVP composition; maintain an "unknown/unmapped" bucket; treat `typeofwork` as Phase 2 unless a stable mapping table is built
- **Comparability constraints:** Do not use `usecategories`, `numberofunits`, or `occupancytype` in MVP; do not extend composition metrics to pre-2020 data without validating HANSEN schema compatibility
- **How you'll monitor drift:** Track "unmapped / unknown" share per category field over time; flag if new `permittype` values appear that fall outside the defined grouping

**Pass criteria**
- Grouping logic is robust to drift or drift is explicitly scoped out.
- Plan to track unknown/unmapped share.

**Verdict:** ✅ PASS WITH CONSTRAINTS — use `permittype`/`permitdescription` for MVP; avoid high-cardinality and high-null fields.

**Mitigation if not pass**
- Reduce to fewer, more stable categories; maintain mapping table with "unknown/unmapped" bucket.

---

## 5) Known blockers

**Goal:** Identify anything that would prevent MVP use.

**Fill in**
- **Access blockers:** None identified — API and bulk download are both available; large file size is a constraint, not a blocker
- **Field blockers:** None for MVP scope — time, geometry, key, and category fields are all present and sufficiently complete
- **Versioning blockers:** HANSEN/ECLIPSE system transition exists but does not affect the last-5-year MVP window (100% ECLIPSE in-window)
- **Legal/licensing blockers:** None — OpenDataPhilly is open access
- **MVP decision:** ✅ Use with constraints

**Constraints to document (MVP)**
- Canonical time field: `permitissuedate`
- District attribution: `the_geom` (point-in-polygon); publish unassigned share
- Business key: `permitnumber`
- Composition: `permittype` (optionally `commercialorresidential`); avoid `usecategories` and `numberofunits`

**Pass criteria**
- No blockers that prevent using the dataset for MVP at the chosen scope.

**Verdict:** ✅ PASS — no hard blockers for district-first MVP physical-change metrics.

---

## Risk mapping from `03_mvp_datasets.md`

**Relevant risks and mitigation:**

| Risk | Limitations register | Mitigation |
|---|---|---|
| Category drift: label/schema changes across years | L4 | Use coarse, stable categories (`permittype`); maintain mapping with "unknown" bucket; track unmapped share (Month 2/3) |
| Geocoding / district assignment gaps | L3 | Track and publish unassigned permit count/share per district-month; add quality flag; caveat comparisons where unassigned share is high (Month 2) |
| Event-date ambiguity (multiple date fields) | L5 | Lock to `permitissuedate`; document choice in metric specs; run comparison checks against candidate date fields (Month 2) |
| `numberofunits` self-reported / unverified | L12 | Exclude from MVP; treat as Phase 2 with explicit disclaimer and separate validation (Month 6) |
| Driver attribution out of scope | L12 | Restrict narratives to descriptive trends; defer causal/attribution claims to Phase 2 |

---

## Final feasibility verdict

- **Verdict:** ✅ Use with constraints
- **Constraints:**
  - Use `permitissuedate` as canonical time field
  - Use `the_geom` for district attribution; publish unassigned share
  - Use `permitnumber` as business key
  - Composition: use `permittype` (optionally `commercialorresidential`); avoid `usecategories` and `numberofunits`
- **Next validation steps (Month 2):**
  - Confirm API extraction limits/paging behavior and schema stability across repeated pulls
  - Validate geometry/CRS and compute unassigned and near-boundary share indicators
  - Finalize permit composition strategy and build `typeofwork` mapping if needed

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
