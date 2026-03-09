# Docs index

**Author:** Farid
**Created:** 2026-02-28
**Last Updated:** 2026-03-08
**Status:** Active

---

## Purpose

This index maps the long-lived documentation in `docs/` so no project
artifact is orphaned as the documentation set grows. Each entry links to the
source file and gives a one-line summary of what that document is for.

---

## Start here

| Document | Summary |
|----------|---------|
| [Project overview (root README)](../README.md) | Entry point for the full repository, including project goals, repo workflow, and top-level doc links. |
| [Docs index](./README.md) | This file; the navigation map for all curated documentation in `docs/`. |
| [Style guide](./style_guide.md) | Defines the documentation standards, formatting rules, and required structural conventions for project artifacts. |

---

## Core project docs

| Document | Summary |
|----------|---------|
| [Scope memo](./00_scope_memo.md) | Defines Month 1 scope, locked decisions, non-goals, and the overall project framing. |
| [Problem statement](./01_problem_statement.md) | Frames the user problem, analytical need, and why the warehouse is worth building. |
| [Month 1 success criteria](./02_success_criteria.md) | States what a successful Month 1 outcome looks like and how completion will be judged. |
| [MVP datasets](./03_mvp_datasets.md) | Lists the four MVP datasets, why they were selected, and the main risks attached to each one. |
| [Data access notes](./04_data_access_notes.md) | Records the chosen access method, cadence, and access constraints for each MVP dataset. |
| [Glossary](./glossary.md) | Tracks working definitions for core warehouse, modeling, spatial, and ACS terminology. |
| [Week 2 recap + Week 3 plan](./week2_recap.md) | Consolidates Week 2 outputs and defines the concrete task-by-task Week 3 execution plan. |
| [Week 3 recap + Week 4 plan](./week3_recap.md) | Consolidates Week 3 modeling and metric spec outputs and defines the concrete task-by-task Week 4 execution plan. |

---

## Planning and control docs

| Document | Summary |
|----------|---------|
| [Assumptions log](./assumptions_log.md) | Captures explicit assumptions that still need validation before they turn into hidden design bugs. |
| [Decision log](./decision_log.md) | Records locked project decisions, the alternatives considered, and the implications of each choice. |
| [Limitations register](./limitations_register.md) | Tracks known project limitations with severity, mitigation, and when each will be addressed. |
| [Learning resources](./learning_resources.md) | Curated resource list for the Month 1 learning plan, tied to project needs. |
| [Bibliography](./bibliography.md) | Standard reference list and citation source for learning notes and documentation artifacts. |
| [Zoning comparability plan (draft)](./zoning_comparability_plan_draft.md) | Draft plan for detecting and handling year-to-year schema differences in zoning vintages. |
| [Zoning comparability plan (final)](./zoning_comparability_plan.md) | Finalized plan for zoning YoY comparability strategy, flagging approach, and mapping architecture. |

---

## Repo governance docs

| Document | Summary |
|----------|---------|
| [Repository settings checklist](./repo_settings_checklist.md) | Checklist of required GitHub repository settings and where to find them in the UI. |
| [Repository settings applied](./repo_settings_applied.md) | Evidence record showing which GitHub repository settings were actually configured. |
| [Data storage policy](./policies/data_storage_policy.md) | Rules for what data can and cannot be committed to the repository. |
| [Feature vs rollup policy](./policies/feature_vs_rollup_policy.md) | Defines the distinction between feature layers and rollup tables and how each will be maintained. |
| [Land area denominator policy](./policies/land_area_denominator_policy.md) | Locks the land-only area denominator convention (sq miles) for intensity metrics. |
| [ACS usage policy](./policies/acs_usage_policy.md) | Defines what ACS data is used for in this project and what comparisons are prohibited. |
| [Standard disclaimer library](./policies/disclaimer_library.md) | Copy-paste ready disclaimer sentences and forbidden-claim examples for dashboards and docs. |

---

## Source catalogs

| Document | Summary |
|----------|---------|
| [Planning Districts — metadata summary](./source_catalog/planning_districts_metadata_summary.md) | Quick-reference metadata summary for the Planning Districts boundary dataset. |
| [Planning Districts — source catalog](./source_catalog/planning_districts.md) | Full source catalog entry: access, geometry, keys, cadence, risks, and links. |
| [L&I Permits — metadata summary](./source_catalog/li_permits_metadata_summary.md) | Quick-reference metadata summary for the L&I permits dataset. |
| [L&I Permits — source catalog](./source_catalog/li_permits.md) | Full source catalog entry: access, schema, time fields, location fields, and top risks. |
| [Zoning Base Districts — metadata summary](./source_catalog/zoning_base_districts_metadata_summary.md) | Quick-reference metadata summary for the zoning base districts dataset. |
| [Zoning Base Districts — source catalog](./source_catalog/zoning_base_districts.md) | Full source catalog entry: vintages, key fields, update policy, and comparability risks. |
| [ACS Context — methodology summary](./source_catalog/acs_context_methodology_summary.md) | Summary of ACS methodology, period estimate definition, and overlap warning. |
| [ACS Context — source catalog](./source_catalog/acs_context.md) | Full source catalog entry: estimate type, period label convention, geography level, and limitations. |

---

## Feasibility checklists

| Document | Summary |
|----------|---------|
| [Planning Districts — feasibility](./feasibility/planning_districts_feasibility.md) | Feasibility assessment for using planning districts as the district spine. |
| [L&I Permits — feasibility](./feasibility/li_permits_feasibility.md) | Feasibility assessment covering district assignability and monthly timestamp reliability. |
| [Zoning — feasibility](./feasibility/zoning_feasibility.md) | Feasibility assessment covering class code consistency and year-to-year comparability unknowns. |
| [ACS — feasibility](./feasibility/acs_feasibility.md) | Feasibility assessment listing supported contextual indicators and prohibited comparisons. |
| [Land-only area evidence note](./feasibility/land_only_area_note.md) | Explains the land-only vs total area choice, unit convention, and where it feeds rollups. |
| [Permits geocoding risk note](./feasibility/permits_geocoding_risk_note.md) | Defines expected geo fields, unassigned-rate metric, and how geocoding risk surfaces in dashboards. |
| [ACS to district boundary alignment note](./feasibility/acs_to_district_alignment_note.md) | Covers overlay vs crosswalk approaches, slivers, MAUP, and planned sanity checks. |

---

## Data dictionaries

| Document | Summary |
|----------|---------|
| [Planning Districts — critical fields](./data_dictionary/planning_districts_critical_fields.md) | Critical fields dictionary for the planning districts dataset. |
| [L&I Permits — critical fields](./data_dictionary/li_permits_critical_fields.md) | Critical fields dictionary for the L&I permits dataset. |
| [Zoning Base Districts — critical fields](./data_dictionary/zoning_critical_fields.md) | Critical fields dictionary for the zoning base districts dataset, including cross-vintage schema notes. |
| [ACS Context — critical fields](./data_dictionary/acs_critical_fields.md) | Critical fields dictionary for ACS context indicators, including period label format and overlap warning. |

---

## Modeling specs

| Document | Summary |
|----------|---------|
| [Grain spec](./modeling/grain_spec.md) | Defines the row-level grain for all six MVP warehouse tables with example PKs and failure modes to avoid. |
| [ERD text draft](./modeling/erd_text_draft.md) | Text-only entity-relationship draft listing entities, cardinalities, and join keys. |
| [ERD diagram (Mermaid)](./diagrams/erd.mmd) | Mermaid erDiagram of the full MVP schema — 9 entities, 12 relationships, renders in GitHub. |
| [Table inventory](./modeling/table_inventory.md) | Classifies all 9 MVP tables by type (feature/rollup/dimension/bridge/geo), grain, and intended consumers. |

---

## Metric specs

| Document | Summary |
|----------|---------|
| [Metric spec template](./templates/metric_spec_template.md) | Reusable template for all metric specification documents. |
| [Permits monthly count](./metrics/permits_monthly_count.md) | Metric spec: count of permits issued per planning district per calendar month. |
| [Permits per land sq mi](./metrics/permits_per_sqmi_land.md) | Metric spec: permit intensity normalized by district land area (non-additive ratio). |
| [Permits composition](./metrics/permits_composition.md) | Metric spec: permit count by canonical permit type group per district per month. |
| [Zoning composition by year](./metrics/zoning_composition_by_year.md) | Metric spec: share of district land area covered by each zoning group per vintage year. |
| [Zoning year-to-year churn](./metrics/zoning_year_to_year_churn.md) | Metric spec: change in zoning share between consecutive vintage years (computed at query time). |
| [ACS income proxy](./metrics/acs_income_proxy.md) | Metric spec: tract-level median household income distribution as district demographic context. |
| [ACS tenure proxy](./metrics/acs_tenure_proxy.md) | Metric spec: tract-level renter-occupied share as district housing tenure context. |

---

## Decisions

| Document | Summary |
|----------|---------|
| [Permit category grouping memo](./decisions/permit_category_grouping_memo.md) | Records the chosen permit category grouping philosophy, field dependencies, and schema drift risks. |
| [Zoning last-5-years window memo](./decisions/zoning_window_last5y.md) | Defines the MVP zoning vintage window (last 5 years) and the path to extending it later. |

---

## Templates

| Document | Summary |
|----------|---------|
| [Memo template](./templates/memo_template.md) | Reusable template for formal project memos and structured design documents. |
| [Notes template](./templates/notes_template.md) | Reusable template for reading notes, concept notes, and source-based summaries. |
| [Source catalog template](./templates/source_catalog_template.md) | Reusable template for dataset source catalog entries. |
| [Feasibility checklist template](./templates/feasibility_checklist.md) | Reusable template for dataset feasibility assessments. |
| [Data dictionary template](./templates/data_dictionary_template.md) | Reusable template for critical fields data dictionaries. |
| [Repository settings checklist template](./templates/repo_settings_checklist.md) | Reusable template for documenting GitHub repository configuration checks. |

---

## Change log

| Date       | Change description                                  | Author |
|------------|-----------------------------------------------------|--------|
| 2026-02-28 | Initial docs index created                          | Farid  |
| 2026-03-01 | Added links, metadata, and template listings        | Farid  |
| 2026-03-03 | Rebuilt index to cover all live docs with summaries | Farid  |
| 2026-03-08 | Full Week 2 update: added source catalogs, feasibility, data dictionaries, decisions, policies, limitations register | Farid  |
| 2026-03-08 | Added Week 2 recap + Week 3 plan link               | Farid  |
| 2026-03-08 | Week 3 update: added Modeling specs section, Metric specs section, disclaimer library, and finalized zoning comparability plan | Farid  |
| 2026-03-08 | Added Week 3 recap + Week 4 plan link (Task 15.2 fix) | Farid  |
