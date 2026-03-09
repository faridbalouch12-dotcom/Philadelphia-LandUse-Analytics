# Month 1 Repo Review Checklist

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Active

---

## Purpose

This checklist is the final gate before closing Month 1. It confirms that the documentation package is complete, internally consistent, and ready for a reviewer to evaluate without needing oral explanation. Each check is pass/fail; all must pass before Month 1 is considered closed.

This checklist was written for Task 17.3 per the Month 1 syllabus. It covers the full documentation set built across Weeks 1–4.

---

## Section 1 — Repo structure and governance

| # | Check | Status | Notes |
|---|-------|--------|-------|
| G1 | `README.md` contains all required sections: Overview, Locked Decisions, Month-1 Deliverables, Repo Structure, How to Contribute/Work, Links to Docs Index | | |
| G2 | `CONTRIBUTING.md` specifies branch prefix rules, commit message pattern, and "no direct commits to main" | | |
| G3 | `.gitignore` blocks `*.gpkg`, `*.shp`, and large CSV/data files | | |
| G4 | `docs/style_guide.md` defines file naming, required header blocks, resource citation format, and template usage rules | | |
| G5 | `docs/policies/data_storage_policy.md` states what can and cannot be committed | | |
| G6 | `.github/pull_request_template.md` includes Purpose, Artifacts Updated, Checklist, Risks/Assumptions, Links | | |

---

## Section 2 — Core project documentation

| # | Check | Status | Notes |
|---|-------|--------|-------|
| P1 | `docs/00_scope_memo.md` states objective, locked decisions, Month-1 deliverables, non-goals, and success definition | | |
| P2 | `docs/01_problem_statement.md` targets non-technical Philly stakeholders; includes top 3 questions and explicit non-goals | | |
| P3 | `docs/02_success_criteria.md` lists 8–12 pass/fail checks, each referencing a specific artifact | | |
| P4 | `docs/03_mvp_datasets.md` lists exactly four datasets with purpose, coverage, cadence, geometry type, and top risks | | |
| P5 | `docs/04_data_access_notes.md` covers chosen access mode, cadence, and large-dataset warnings for each source | | |
| P6 | `docs/glossary.md` contains at least 25 terms with definitions and project examples | | |

---

## Section 3 — Modeling specs

| # | Check | Status | Notes |
|---|-------|--------|-------|
| M1 | `docs/modeling/grain_spec.md` contains 6 grain statements, each with a single-sentence definition and example PK | | |
| M2 | `docs/modeling/erd_text_draft.md` lists 9 entities (E1–E9) and 12 relationships (R1–R12) with cardinality and join keys | | |
| M3 | `docs/diagrams/erd.mmd` renders in GitHub; entity count, PK annotations, and relationship labels match the text draft | | |
| M4 | `docs/checklists/erd_review_checklist.md` self-audit is complete; all checks pass | | |
| M5 | `docs/modeling/table_inventory.md` classifies all 9 tables by type, grain, and intended consumers | | |
| M6 | `docs/diagrams/dataflow.mmd` renders in GitHub; shows all 4 datasets flowing raw → staging → mart, with feature vs rollup layers labeled | | |

---

## Section 4 — Metric specs

| # | Check | Status | Notes |
|---|-------|--------|-------|
| MS1 | `docs/metrics/permits_monthly_count.md` defines grain, formula, aggregation type, dimensions, test ideas, and caveats | | |
| MS2 | `docs/metrics/permits_per_sqmi_land.md` defines grain, formula, non-additivity note, denominator policy reference, and caveats | | |
| MS3 | `docs/metrics/permits_composition.md` defines grain, formula, count-vs-share design decision, and caveats | | |
| MS4 | `docs/metrics/zoning_composition_by_year.md` defines grain, formula, semi-additivity note, `vocab_stable` dependency, and caveats | | |
| MS5 | `docs/metrics/zoning_year_to_year_churn.md` defines grain, query-time self-join pattern, FM2 compliance, and caveats | | |
| MS6 | `docs/metrics/acs_income_proxy.md` defines tract-level distribution grain (not district KPI), MOE retention, MAUP risk, and caveats | | |
| MS7 | `docs/metrics/acs_tenure_proxy.md` defines tract-level distribution grain, non-additivity of rates, and caveats | | |
| MS8 | All 7 metric specs link to their source grain spec, table inventory entry, and relevant limitations register items | | |

---

## Section 5 — Source documentation

| # | Check | Status | Notes |
|---|-------|--------|-------|
| S1 | All 4 datasets have a metadata summary in `docs/source_catalog/` | | |
| S2 | All 4 datasets have a full source catalog entry in `docs/source_catalog/` | | |
| S3 | All 4 datasets have a completed feasibility checklist in `docs/feasibility/` | | |
| S4 | All 4 datasets have a critical fields dictionary in `docs/data_dictionary/` | | |
| S5 | `docs/feasibility/land_only_area_note.md` states land-only choice, unit convention (sq mi), and where denominator is stored | | |
| S6 | `docs/feasibility/permits_geocoding_risk_note.md` defines expected geo fields, unassigned-rate metric, and dashboard surfacing approach | | |
| S7 | `docs/feasibility/acs_to_district_alignment_note.md` covers overlay vs crosswalk, slivers, MAUP, and planned sanity checks | | |

---

## Section 6 — Policies and contracts

| # | Check | Status | Notes |
|---|-------|--------|-------|
| PC1 | `docs/policies/feature_vs_rollup_policy.md` defines feature vs rollup, gives concrete examples for permits and zoning, and states reproducibility requirements | | |
| PC2 | `docs/policies/land_area_denominator_policy.md` locks land-only convention, unit (sq mi), and edge case handling | | |
| PC3 | `docs/policies/acs_usage_policy.md` states what ACS is and is not used for; includes standard disclaimer sentence | | |
| PC4 | `docs/policies/disclaimer_library.md` contains 5 standard disclaimer sentences and 5 forbidden claim examples with acceptable alternatives | | |
| PC5 | `docs/policies/map_first_readiness_contract.md` defines 6 conditions for a spatial layer to be map-first ready (CRS, validity, identifier, district assignment, area computation) | | |
| PC6 | `docs/zoning_comparability_plan.md` (final) defines vocabulary detection, crosswalk strategy, and what the MVP will and will not claim | | |

---

## Section 7 — Planning and control logs

| # | Check | Status | Notes |
|---|-------|--------|-------|
| L1 | `docs/assumptions_log.md` contains ≥10 assumptions with statement, rationale, validation plan, and impact if wrong | | |
| L2 | `docs/decision_log.md` contains ≥12 entries with date, decision, alternatives, rationale, and implications | | |
| L3 | `docs/limitations_register.md` contains ≥22 items; each has severity, impact, mitigation, and timeframe | | |
| L4 | Limitations register items for permits, zoning, and ACS metrics link to the relevant metric spec files | | |

---

## Section 8 — Navigation and traceability

| # | Check | Status | Notes |
|---|-------|--------|-------|
| N1 | `docs/README.md` (docs index) links to every file in `docs/` with a 1-line summary; no orphan docs | | |
| N2 | `README.md` (root) Links to Docs Index section is current; no broken links | | |
| N3 | All metric specs link to their upstream grain spec, source catalog, and limitations register entries | | |
| N4 | All limitations register entries with metric spec cross-references link to the correct files | | |
| N5 | `docs/modeling/erd_text_draft.md` links to grain spec and decision log | | |
| N6 | All source catalog entries link to their feasibility checklist and critical fields dictionary | | |

---

## Section 9 — Product specs

| # | Check | Status | Notes |
|---|-------|--------|-------|
| PR1 | `docs/product/district_brief_spec.md` lists required sections, required metrics, standard disclaimers, and caveats | | |
| PR2 | `docs/product/district_compare_spec.md` lists metric list, ranking direction, and caveats | | |

---

## Section 10 — Week recaps and Month 1 summary

| # | Check | Status | Notes |
|---|-------|--------|-------|
| WR1 | `docs/week2_recap.md` links to key Week 2 artifacts; includes a concrete Week 3 plan | | |
| WR2 | `docs/week3_recap.md` links to key Week 3 artifacts; includes a concrete Week 4 plan | | |
| WR3 | `docs/month1_recap.md` links to scope memo, catalogs, grain spec, key metrics, comparability plan, diagrams, limitations, and product specs | | |

---

## How to use this checklist

1. Work through each section sequentially.
2. Mark each item ✅ PASS or ❌ FAIL with a brief note.
3. Do not mark Month 1 as closed until all items are ✅ PASS.
4. For any ❌ FAIL items, log a fix task before the Month 1 release/tag.

---

## Links

- Docs index: [`docs/README.md`](../README.md)
- Month 1 success criteria: [`docs/02_success_criteria.md`](../02_success_criteria.md)
- ERD review checklist: [`docs/checklists/erd_review_checklist.md`](./erd_review_checklist.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial checklist — 10 sections, 48 checks (Task 17.3) | Farid |
