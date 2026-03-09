# Month 1 Recap — Executive Summary

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Final

---

## What Month 1 Was

Month 1 was a deliberate documentation-first month. No pipelines, no SQL, no dbt models. The goal was to build a production-level documentation package for the Philadelphia district-level data warehouse before writing a single line of code — so that when Month 2 begins, every design decision is already locked, every metric formula is already specified, and every known risk is already logged.

The bet: investing four weeks in documentation upfront prevents months of debt downstream.

---

## What Was Built

Month 1 produced a complete warehouse design artifact package organized across four weeks:

---

### Week 1 — Repo Setup and Conceptual Foundations

Established the infrastructure for a reviewable, reproducible project:

- **Repo governance:** [`CONTRIBUTING.md`](../CONTRIBUTING.md), [`docs/style_guide.md`](./style_guide.md), [`.github/pull_request_template.md`](../.github/pull_request_template.md), [`docs/repo_settings_checklist.md`](./repo_settings_checklist.md)
- **Core project framing:** [`docs/00_scope_memo.md`](./00_scope_memo.md), [`docs/01_problem_statement.md`](./01_problem_statement.md), [`docs/02_success_criteria.md`](./02_success_criteria.md)
- **Learning library:** [`docs/learning_resources.md`](./learning_resources.md), [`docs/bibliography.md`](./bibliography.md)
- **Policies:** [`docs/policies/data_storage_policy.md`](./policies/data_storage_policy.md), [`docs/policies/feature_vs_rollup_policy.md`](./policies/feature_vs_rollup_policy.md), [`docs/policies/land_area_denominator_policy.md`](./policies/land_area_denominator_policy.md), [`docs/policies/acs_usage_policy.md`](./policies/acs_usage_policy.md)
- **Foundation logs:** [`docs/assumptions_log.md`](./assumptions_log.md), [`docs/decision_log.md`](./decision_log.md), [`docs/limitations_register.md`](./limitations_register.md), [`docs/glossary.md`](./glossary.md)

**Key outcome:** The project had a public GitHub repo with documented workflow, locked decisions, and explicit non-goals before any dataset analysis began.

---

### Week 2 — Dataset Deep-Dives

Exhaustively cataloged all four MVP datasets and produced feasibility and risk documentation for each:

- **Source catalogs:** Planning Districts, L&I Permits, Zoning Base Districts, ACS Context — in [`docs/source_catalog/`](./source_catalog/)
- **Feasibility checklists:** [`docs/feasibility/`](./feasibility/) — including geocoding risk, land-only area, ACS-to-district alignment
- **Critical fields dictionaries:** [`docs/data_dictionary/`](./data_dictionary/)
- **Decision memos:** [`docs/decisions/permit_category_grouping_memo.md`](./decisions/permit_category_grouping_memo.md), [`docs/decisions/zoning_window_last5y.md`](./decisions/zoning_window_last5y.md)
- **Comparability plan (draft):** [`docs/zoning_comparability_plan_draft.md`](./zoning_comparability_plan_draft.md)

**Key outcome:** Every dataset that will be ingested in Month 2 has documented access method, key field choices, risks, and limitations before the first line of pipeline code is written.

---

### Week 3 — Data Modeling and Metric Specs

Converted the dataset strategy into a formal warehouse design:

- **Grain spec:** [`docs/modeling/grain_spec.md`](./modeling/grain_spec.md) — 6 grain statements, 4 schema contracts (SC1–SC4, DDL-ready), 2 failure modes
- **ERD text draft:** [`docs/modeling/erd_text_draft.md`](./modeling/erd_text_draft.md) — 9 entities, 12 relationships, 5 design decisions
- **Table inventory:** [`docs/modeling/table_inventory.md`](./modeling/table_inventory.md) — all 9 tables typed, consumer-designated, and SCD-strategy documented
- **7 metric specs** in [`docs/metrics/`](./metrics/): permits monthly count, permits per land sq mi, permits composition, zoning composition by year, zoning YoY churn, ACS income proxy, ACS tenure proxy
- **Zoning comparability plan (final):** [`docs/zoning_comparability_plan.md`](./zoning_comparability_plan.md) — vocabulary detection, mapping strategy, and MVP claim bounds
- **Standard disclaimer library:** [`docs/policies/disclaimer_library.md`](./policies/disclaimer_library.md) — 5 standard disclaimers, 5 forbidden claims

**Key outcome:** A Month 2 engineer could read the metric specs and grain contracts and know exactly what to build. Every formula, denominator choice, and caveat is documented before any code exists.

---

### Week 4 — Diagrams, Contracts, and Product Specs

Translated the design into visual artifacts, spatial contracts, and product definitions:

- **ERD diagram:** [`docs/diagrams/erd.mmd`](./diagrams/erd.mmd) — Mermaid `erDiagram`, 9 entities, 12 relationships, renders in GitHub
- **ERD review checklist:** [`docs/checklists/erd_review_checklist.md`](./checklists/erd_review_checklist.md) — 19 checks across 3 tiers (all pass)
- **Dataflow diagram:** [`docs/diagrams/dataflow.mmd`](./diagrams/dataflow.mmd) — raw → staging → mart, feature vs rollup layers, grain labels
- **Decision log (D12–D14):** [`docs/decision_log.md`](./decision_log.md) — EOY date pattern, geometry separation, bridge-as-lookup design
- **Map-first readiness contract:** [`docs/policies/map_first_readiness_contract.md`](./policies/map_first_readiness_contract.md) — 6 conditions for spatial layers
- **Month 1 repo review checklist:** [`docs/checklists/month1_review_checklist.md`](./checklists/month1_review_checklist.md) — 48 checks across 10 sections
- **Product specs:** [`docs/product/district_brief_spec.md`](./product/district_brief_spec.md), [`docs/product/district_compare_spec.md`](./product/district_compare_spec.md)

**Key outcome:** The warehouse has a visual schematic, a spatial readiness standard, and a product definition — the three things that bridge documentation into implementation.

---

## Key Decisions Made in Month 1

The following decisions are the architectural foundation for Month 2. All are in [`docs/decision_log.md`](./decision_log.md):

| Decision | What was locked |
|----------|-----------------|
| D1 | Stack: Postgres + Python + dbt + Metabase in Docker Compose |
| D3 | District-first MVP; feature layers retained for map-first later |
| D4 | Monthly permit aggregation; land-only area normalization |
| D7 | Two separate fact tables: `fct_permits` (transaction) and `fct_district_year_zoning_composition` (periodic snapshot) |
| D8–D10 | ACS carried at tract grain with MOE columns; no district-level ACS aggregation; tract-level distributions on dashboard |
| D12 | EOY surrogate date keys for all year-level joins to `dim_date` |
| D13 | Polygon geometry separated from `dim_district` into `geo_district_boundaries` |
| D14 | `fct_tract_acs` used as dimensional lookup for bridge table; no separate `dim_census_tract` |
| D15 | `fct_permits` locked as transaction fact only; permit lifecycle accumulating snapshot deferred |
| D16 | Bridge table overlap threshold: `pct_tract_area > 0.01` (1% minimum, GIS slivers dropped) |
| D17 | SCD strategy: Type 1 for `dim_district` and `dim_zoning`; static for `dim_date` |

---

## What Month 1 Did Not Do

By design:
- No pipelines, no ingestion code, no ETL
- No SQL models or dbt implementation
- No Metabase dashboards
- No ACS ingestion from Census API
- No CRS validation (Month 2 EDA task)
- No zoning crosswalk construction (Month 2 EDA task)

---

## Known Limitations Going Into Month 2

The limitations register ([`docs/limitations_register.md`](./limitations_register.md)) tracks 22 items. The most consequential for Month 2:

| ID | What it blocks |
|----|---------------|
| L14 | CRS unconfirmed for planning districts → all area and density metrics suppressed until validated |
| L22 | CRS unconfirmed for zoning shapefiles → `polygon_area_sqmi` cannot be computed from raw `Shape__Area` |
| L3 | Geocoding quality unknown → unassigned permit share must be measured and published before trusting district rollups |
| L7, L15–L17 | Zoning vocabulary drift → crosswalk and `vocab_stable` flagging must be built before YoY metrics are valid |

---

## What Month 2 Should Start With

Based on the Month 1 foundation, Month 2 should begin in this order:

1. **Validate CRS** for planning districts and zoning shapefiles (unblocks L14 and L22)
2. **Build the ingestion pipeline** for planning districts → raw → staging (`stg_planning_districts`)
3. **Compute `land_area_sqmi`** via PostGIS after CRS confirmation
4. **Build `dim_district`** from staging
5. **Begin L&I permits ingestion** → raw → staging (`stg_li_permits`) → district assignment → `fct_permits`
6. **Measure and publish unassigned permit share** (L3)
7. **Begin zoning ingestion** → raw → staging → code vocabulary EDA → crosswalk build

The metric specs in [`docs/metrics/`](./metrics/) define exactly what each mart table needs to contain. The grain spec and table inventory define the schema contracts.

---

## Links

**Scope and framing:**
- [Scope memo](./00_scope_memo.md)
- [Problem statement](./01_problem_statement.md)
- [Month 1 success criteria](./02_success_criteria.md)

**Dataset documentation:**
- [Source catalog — Planning Districts](./source_catalog/planning_districts.md)
- [Source catalog — L&I Permits](./source_catalog/li_permits.md)
- [Source catalog — Zoning Base Districts](./source_catalog/zoning_base_districts.md)
- [Source catalog — ACS Context](./source_catalog/acs_context.md)

**Warehouse design:**
- [Grain spec](./modeling/grain_spec.md)
- [ERD diagram](./diagrams/erd.mmd)
- [Dataflow diagram](./diagrams/dataflow.mmd)
- [Table inventory](./modeling/table_inventory.md)

**Metric specs:**
- [Permits monthly count](./metrics/permits_monthly_count.md)
- [Permits per land sq mi](./metrics/permits_per_sqmi_land.md)
- [Permits composition](./metrics/permits_composition.md)
- [Zoning composition by year](./metrics/zoning_composition_by_year.md)
- [Zoning YoY churn](./metrics/zoning_year_to_year_churn.md)
- [ACS income proxy](./metrics/acs_income_proxy.md)
- [ACS tenure proxy](./metrics/acs_tenure_proxy.md)

**Comparability and disclaimers:**
- [Zoning comparability plan (final)](./zoning_comparability_plan.md)
- [Standard disclaimer library](./policies/disclaimer_library.md)

**Diagrams and contracts:**
- [ERD review checklist](./checklists/erd_review_checklist.md)
- [Map-first readiness contract](./policies/map_first_readiness_contract.md)
- [Month 1 repo review checklist](./checklists/month1_review_checklist.md)

**Product specs:**
- [District brief spec](./product/district_brief_spec.md)
- [Compare districts spec](./product/district_compare_spec.md)

**Risk and control:**
- [Limitations register](./limitations_register.md)
- [Decision log](./decision_log.md)
- [Assumptions log](./assumptions_log.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial Month 1 executive summary (Task 20.1) | Farid |
| 2026-03-09 | Month 1 closeout pass: updated grain spec description (SC1–SC4 added), table inventory (SCD), decision table (D15–D17) | Farid |
