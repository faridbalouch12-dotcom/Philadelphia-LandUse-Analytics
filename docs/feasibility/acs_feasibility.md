# Feasibility Checklist - ACS Demographic Context (D1)

**Author:** Farid
**Created:** 2026-03-05
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Dataset header
- Dataset name: ACS 5-Year Data Profiles (Census Data API)
- Dataset ID (e.g., S1/S2/S3/D1): D1
- Source page / endpoint: https://api.census.gov/data/2024/acs/acs5/profile
- Reviewer: Farid
- Date: 2026-03-08
- MVP role (district spine / permits fact / zoning snapshots / ACS context): ACS context

---

## 1) Time field selection

**Goal:** confirm there is a usable time concept for district context.

- Candidate time fields: None in-record; time is implicit in the endpoint year (vintage).
- Canonical time field for the project: `acs_vintage_year` + `acs_period_label`
- Time semantics: Period estimate (5-year rolling average), not annual point-in-time.
- Supported grain: period/window only.

**Pass criteria**
- PASS for context snapshots (single vintage; or non-overlapping vintage comparisons)
- FAIL if treated as monthly or true year-by-year demographics

**Mitigation**
- Use non-overlapping windows only; enforce period labeling in dashboards/docs.

---

## 2) Geo linkage approach

**Goal:** confirm ACS tracts can be grouped under planning districts for context display.

- Geometry present? No (tabular only).
- Geo linkage approach: join ACS to tract polygons via GEOID; then overlay tract polygons to planning districts and compute tract-to-district weights for grouping/caveat tracking.
- Expected unassigned: near 0 if tract and district polygons are valid; validate join coverage and weight sums.
- Boundary-edge risk: tracts often straddle district boundaries; district context grouping is approximate.

**Pass criteria**
- PASS WITH CONSTRAINTS: publish/retain grouping metadata and standard caveats.

**Mitigation**
- If crosswalk is not feasible, keep ACS strictly tract-level and disable district-hover ACS context.

---

## 3) Key field completeness

- Key strategy: (`acs_vintage_year`, `geoid_tract`)
- Candidate raw keys: `GEO_ID` or `state`+`county`+`tract`
- Expected completeness: high; validate non-null and uniqueness.

**Pass criteria**
- PASS

**Mitigation**
- Treat duplicates/missing IDs as ingestion blockers.

---

## 4) Category stability

- Categories are variable codes (DPxx_####E) rather than free-text categories.
- Drift risk: variable availability/definitions can change by vintage; mitigate with a curated variable pack and a variable-diff check for new vintages.
- Comparability constraints: overlapping windows; medians and percents without correct universes.

**Pass criteria**
- PASS (single vintage MVP)
- Multi-vintage comparisons require explicit non-overlap rules and validation.

---

## 5) Known blockers

- Access blockers: variable-per-request limits may require batching; API key recommended.
- Field blockers: no geometry in record (requires tract boundary dataset).
- MVP decision: Use with constraints.

**Verdict**
- Use with constraints (context-only; non-overlap comparisons; documented tract-to-district grouping metadata)

---

## Supported contextual indicators (MVP)

The following ACS indicators are supported for district interactions via tract-level distributions:

- **Population context** - tract population distribution (counts and optional bins)
- **Median household income proxy** - tract-level median distribution/range (no single district median KPI)
- **Renter share context** - tract-level renter share distribution
- **Education share context** - tract-level BA+ share distribution

**Prohibited claims/comparisons:**
- Do not compare overlapping 5-year windows (e.g., 2018-2022 vs 2019-2023)
- Do not publish single-value district ACS KPIs as official metrics
- Do not make causal claims linking ACS indicators to permit or zoning changes

---

## Final feasibility verdict

- Verdict: Use with constraints
- Constraints:
  - Context only; no causal claims
  - Non-overlapping 5-year comparisons only
  - District interactions must use tract-level distributions (per D10)
  - Store tract-level estimates with MOE columns; no aggregated MOE computation in MVP (per D8)
- Next validation steps:
  - Confirm the curated variable pack exists in the chosen vintage(s)
  - Validate tract geometry join quality and quantify split-tract share

---

## Links

- **Source catalog entry:** [`docs/source_catalog/acs_context.md`](../source_catalog/acs_context.md)
- **Methodology summary:** [`docs/source_catalog/acs_context_methodology_summary.md`](../source_catalog/acs_context_methodology_summary.md)
- **Critical fields dictionary:** [`docs/data_dictionary/acs_critical_fields.md`](../data_dictionary/acs_critical_fields.md)
- **Limitations register:** [`docs/limitations_register.md`](../limitations_register.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-05 | Initial draft      | Farid  |
| 2026-03-08 | Aligned feasibility verdict and supported outputs with D8-D10 (tract-level distributions + MOE retention, no single-value district ACS KPI) | Farid |
