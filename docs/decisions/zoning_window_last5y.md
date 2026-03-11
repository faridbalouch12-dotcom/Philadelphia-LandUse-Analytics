# Zoning Vintage Window Decision Memo (MVP)

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

This memo documents the decision to scope the MVP zoning analysis window to
2021–2025 (last 5 years) and explains how the design supports extension to
the full 2015–2024 archive later without rewriting metrics.

---

## Decision

**MVP zoning vintage window: 2021–2025 (5 vintages)**

---

## Rationale

### 1. Alignment with permits data source transition

The L&I permits dataset migrated from the HANSEN source system to Eclipse
around 2021. Pre-transition records have different schema characteristics and
data quality profiles. Anchoring the zoning window at 2021 keeps both
analytical paths (permits and zoning) on the same temporal footing for MVP,
avoiding cross-system comparability issues before they are properly
characterized.

### 2. MVP scope constraint

Five vintages are sufficient to observe meaningful zoning trends at the
district level and demonstrate the periodic snapshot fact table pattern.
Extending to a 10-year window (2015–2024) is a post-MVP exercise once the
pipeline and crosswalk infrastructure are validated.

---

## Extension Path (2015–2024)

Extending to the full archive later requires no metric rewrites. The process
is:

1. **Obtain earlier vintage shapefiles** from OpenDataPhilly (annual snapshots
   available back to at least 2015).
2. **Audit code vocabulary consistency** — check whether zoning code names in
   earlier vintages (e.g., 2015–2020) match the current vocabulary used in
   2021–2025. Philadelphia has occasionally renamed or reclassified base
   district codes.
3. **Apply a crosswalk if needed** — if a code name differs across vintages
   (e.g., a 2019 vintage uses `RSA-4` for what is now called `RSA-5`), a
   mapping table translates old codes to current vocabulary during the
   transform step. The fact table always speaks current code vocabulary; the
   crosswalk lives in the pipeline.
4. **Load new rows into `fct_district_year_zoning_composition`** — the grain
   (`vintage_year × district × zoning_code`) and schema are unchanged. Earlier
   vintages are additive rows, not schema changes.

Because the fact table grain contract is stable, all existing metric
definitions (`pct_district_area`, `area_sqft`) apply identically to 2015 data
as to 2021 data. No metric spec requires revision.

---

## Antipattern Risk: Hardcoded Code Values

If zoning code values are hardcoded into metric queries, CHECK constraints, or
dashboard filters (e.g., `WHERE zoning_code IN ('RSA-5', 'CMX-2', ...)`),
extending to older vintages with different code names becomes fragile and
error-prone. This is an instance of the **31 Flavors antipattern** (SQL
Antipatterns, Ch. 9) — baking enumerated values into logic that must be
maintained manually when values change.

**Mitigation:** All code-level filtering should reference the
`dim_zoning_code` lookup table, not hardcoded lists. Code reclassifications
are handled in the crosswalk during load, not in downstream queries.

---

## What This Memo Does Not Cover

- The crosswalk table schema (to be defined in Month 2 pipeline design)
- Actual validation of code consistency across vintages (to be done during EDA
  in Month 2)
- Pre-2015 data availability (out of scope indefinitely)

---

## Links

- Decision log: [`docs/decision_log.md`](../decision_log.md)
- Source catalog — Zoning base districts: [`docs/source_catalog/zoning_base_districts.md`](../source_catalog/zoning_base_districts.md)
- SQL Antipatterns notes: [`notes/sql/sql_antipatterns_b5_notes.md`](../../notes/sql/sql_antipatterns_b5_notes.md)
- Lookup table vs SCD Type 2 explainer: [`notes/kimball/lookup_vs_scd2_explainer.html`](../../notes/kimball/lookup_vs_scd2_explainer.html)
- Zoning comparability plan (draft): [`docs/zoning_comparability_plan_draft.md`](../zoning_comparability_plan_draft.md) *(Task 8.6)*

---

## Change Log

| Date       | Change                  | Author |
|------------|-------------------------|--------|
| 2026-03-08 | Initial memo created    | Farid  |
