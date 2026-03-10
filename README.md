# Philadelphia-LandUse-Analytics

## Current repo status

> **Month 1 complete — design and documentation only.**
> No pipelines, no SQL, no dbt models exist yet. Everything below is designed and specified; implementation begins in Month 2.

| Layer | Status |
|-------|--------|
| Warehouse design (grain, schema contracts, ERD) | ✅ Complete |
| Dataset cataloging (L&I permits, zoning, ACS, districts) | ✅ Complete |
| Metric specifications (7 metrics defined) | ✅ Complete |
| Product specs (district brief, compare view) | ✅ Complete |
| Decision log (17 locked decisions) | ✅ Complete |
| Python ingestion pipelines | 🔲 Month 2 |
| Docker Compose stack | 🔲 Month 2 |
| dbt project + staging + mart models | 🔲 Month 2 |
| Metabase dashboards | 🔲 Month 2 |

---

## Project overview

An analytics platform to analyze changes in Philadelphia's planning districts over time, using public datasets.

## Project goal

Build a reproducible analytics platform that explains how Philadelphia's 18 planning districts change over time, using public datasets. The output is a district change explorer (interactive) plus a well-modeled warehouse that supports longitudinal analysis and future expansions.

District change is defined by: changes in building permits (L&I), zoning reclassifications, and demographic shifts (income, tenure) tracked by the American Community Survey (ACS).

---

## Locked decisions (architectural decisions, not yet implemented)

- Stack: Postgres + Python + dbt + Metabase + Docker
- Reproducibility: Docker Compose is the default run path; GitHub is the source of truth
- Modeling approach (fixed for Month 1): dbt stg_* -> dim_*/fct_* with a district-time grain.
- Metic normalization: By land area. For example, permits granted per sq mi.
- Data's time scope: Last 5 years.
- Metric comparison period: year over year.
- Incremental scope: Month 1 prioritizes permits + zoning + ACS + district boundaries; no extra datasets until those are stable.
- Environment: dev runs locally via Docker; production/cloud deployment is out of scope for Month 1

## Repo layout

- docker/ (compose, service configs)

- src/ or pipelines/ (python ingestion)

- dbt/ (dbt project)

- data/ (optional local dev samples; note what is/ isn't committed)

- docs/ (data dictionary, architecture notes)

- sql/ (optional ad-hoc queries, debugging). 
## Completed in Month 1

Month 1 was documentation and design only — no code, no SQL, no pipelines.

**Warehouse design**
- Grain spec with schema contracts for all 4 high-risk tables (DDL-ready)
- Table inventory with SCD strategies for all 9 warehouse tables
- ERD diagram (Mermaid) with grain annotations, PKs, FKs, and cardinality
- Dataflow diagram showing raw → staging → mart → BI layer
- 17 locked design decisions logged with rationale and implications

**Dataset cataloging** (4 datasets)
- L&I building permits, zoning base districts, ACS 5-year estimates, planning district boundaries
- Source catalog entry, feasibility checklist, and critical fields dictionary for each

**Metric specifications** (7 metrics)
- Permits: monthly count, permits per land sq mi, permit composition by type
- Zoning: composition by year, year-over-year churn
- ACS: income proxy (tract median range), tenure proxy (owner-occupied share)

**Policies and governance**
- Feature vs rollup policy, land-area denominator policy, ACS usage policy
- Limitations register (hardened through 4 weeks), assumptions log, decision log

**Product specs**
- District brief output spec, compare-districts view spec

**Repo infrastructure**
- GitHub workflow (branch naming, PR template, contribution guide)
- Doc style guide, doc templates, glossary

---

## Planned for Month 2

Month 2 is local implementation — building the actual pipeline from raw data to Metabase.

**Platform foundation**
- Docker Compose stack: Postgres + PostGIS + Metabase
- Python project scaffold with environment-variable handling
- Database bootstrap SQL (schemas: `raw`, `staging`, `intermediate`, `marts`, `analytics`; extensions: PostGIS)
- dbt project scaffold with source declarations and materialization strategy

**Vertical slices** (one dataset at a time, end-to-end)
1. Planning districts — raw ingest → `stg_planning_districts` → `dim_district` → `geo_district_boundaries`
2. L&I permits — raw ingest → `stg_li_permits` → `int_li_permits_issued` → `int_li_permits_issued_with_district` → `fct_permits`
3. Zoning — raw ingest → `stg_zoning_base_districts` → `int_zoning_district_intersections_{year}` → `int_zoning_district_year_composition_base` → `fct_district_year_zoning_composition`
4. ACS — raw ingest → `stg_acs_tract` → `fct_tract_acs` → bridge → `agg_district_acs_attributes_hist`

**Dashboard**
- District brief dashboard in Metabase
- Compare-districts view in Metabase
  

## How to contribute / work

### Workflow
1. Create (or pick up) a GitHub Issue describing the change.
2. Create a feature branch from `main`.
3. Implement the change with the smallest viable scope.
4. Run local checks (see **Local checks** below).
5. Open a PR back to `main` with a clear description and screenshots/log output where relevant.

### Branch naming
Use short, consistent branch names:
- `feat/<short-description>` (new capability)
- `fix/<short-description>` (bug fix)
- `chore/<short-description>` (maintenance, refactors, deps)
- `docs/<short-description>` (documentation)

Examples:
- `feat/permits-ingest`
- `feat/dbt-staging-permits`
- `fix/metabase-connection`
- `docs/modeling-conventions`

### Commit message guidance
- Prefer imperative, descriptive commits: `Add permits ingest pipeline`
- Keep commits focused; avoid mixing unrelated changes.

### Local checks (minimum bar)
Before opening a PR, ensure:
- `docker compose up -d` succeeds and services are healthy
- Ingestion job(s) run without errors (if changed)
- dbt runs succeed (if dbt changed):
  - `dbt debug`
  - `dbt run`
  - `dbt test`

If you don't have all services wired yet, document what you *did* run in the PR description.

### Where to put things
- **Curated docs:** `/docs` (anything you want to keep long-term)
- **Scratch notes:** `/notes` (temporary; can be deleted later)
- **Data (local dev only):** `/data` (do not commit large/raw datasets)
- **Service configs:** `/docker`
- **Ingestion code:** `/src` or `/pipelines`
- **dbt project:** `/dbt`

### Documentation rule
If your change affects:
- how to run the project,
- the data model,
- a metric definition,
- or a data source,
then update the relevant doc in `/docs` and ensure it's linked from `docs/README.md`.

### PR checklist
- [ ] Scope is clear and matches the Issue
- [ ] Code runs locally (or in Docker) with evidence in the PR description
- [ ] dbt models updated + tests added/updated (if applicable)
- [ ] Docs updated (root README and/or `/docs`) if behavior changed
- [ ] No secrets committed; `.env.example` updated if new env vars were added


## Links to docs index

- **Scope memo:** [`docs/00_scope_memo.md`](./docs/00_scope_memo.md)
- **Problem statement:** [`docs/01_problem_statement.md`](./docs/01_problem_statement.md)
- **Month-1 success criteria:** [`docs/02_success_criteria.md`](./docs/02_success_criteria.md)
- **Week 2 recap + Week 3 plan:** [`docs/week2_recap.md`](./docs/week2_recap.md)
- **Docs Index:** [`docs/README.md`](./docs/README.md)
- **Style guide:** [`docs/style_guide.md`](./docs/style_guide.md)
- **Repo settings checklist:** [`docs/repo_settings_checklist.md`](./docs/repo_settings_checklist.md)
- **Repo settings applied:** [`docs/repo_settings_applied.md`](./docs/repo_settings_applied.md)
- **Data storage policy:** [`docs/policies/data_storage_policy.md`](./docs/policies/data_storage_policy.md)
- **Contributing guide:** [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- **Learning resources:** [`docs/learning_resources.md`](./docs/learning_resources.md)
- **Bibliography:** [`docs/bibliography.md`](./docs/bibliography.md)
- **Resource triage rules:** [`notes/project-setup/resource_triage_rules.md`](./notes/project-setup/resource_triage_rules.md)
- **Kimball grain notes:** [`notes/kimball/kimball_grain_notes.md`](./notes/kimball/kimball_grain_notes.md)
- **Kimball facts notes:** [`notes/kimball/kimball_facts_notes.md`](./notes/kimball/kimball_facts_notes.md)
- **ACS period estimates notes:** [`notes/data-sources/acs_period_estimates_notes.md`](./notes/data-sources/acs_period_estimates_notes.md)
- **PostGIS spatial primer notes:** [`notes/gis/postgis_spatial_primer_notes.md`](./notes/gis/postgis_spatial_primer_notes.md)
- **Missing Semester Git notes:** [`notes/project-setup/missing_semester_git_notes.md`](./notes/project-setup/missing_semester_git_notes.md)
- **cookiecutter-data-science patterns:** [`notes/project-setup/ref_patterns_cookiecutter_ds.md`](./notes/project-setup/ref_patterns_cookiecutter_ds.md)
- **jaffle-shop patterns:** [`notes/project-setup/ref_patterns_jaffle_shop.md`](./notes/project-setup/ref_patterns_jaffle_shop.md)
- **Glossary:** [`docs/glossary.md`](./docs/glossary.md)
- **MVP datasets:** [`docs/03_mvp_datasets.md`](./docs/03_mvp_datasets.md)
- **Data access notes:** [`docs/04_data_access_notes.md`](./docs/04_data_access_notes.md)
- **Assumptions log:** [`docs/assumptions_log.md`](./docs/assumptions_log.md)
- **Decision log:** [`docs/decision_log.md`](./docs/decision_log.md)
- **Source catalog template:** [`docs/templates/source_catalog_template.md`](./docs/templates/source_catalog_template.md)
- **Feasibility checklist template:** [`docs/templates/feasibility_checklist.md`](./docs/templates/feasibility_checklist.md)
- **Data dictionary template:** [`docs/templates/data_dictionary_template.md`](./docs/templates/data_dictionary_template.md)
- **Feature vs rollup policy:** [`docs/policies/feature_vs_rollup_policy.md`](./docs/policies/feature_vs_rollup_policy.md)
- **Land-area denominator policy:** [`docs/policies/land_area_denominator_policy.md`](./docs/policies/land_area_denominator_policy.md)
- **ACS usage policy:** [`docs/policies/acs_usage_policy.md`](./docs/policies/acs_usage_policy.md)
- **Limitations register:** [`docs/limitations_register.md`](./docs/limitations_register.md)
- **L&I permits metadata summary:** [`docs/source_catalog/li_permits_metadata_summary.md`](./docs/source_catalog/li_permits_metadata_summary.md)
- **L&I permits source catalog:** [`docs/source_catalog/li_permits.md`](./docs/source_catalog/li_permits.md)
- **L&I permits feasibility checklist:** [`docs/feasibility/li_permits_feasibility.md`](./docs/feasibility/li_permits_feasibility.md)
- **Permits geocoding risk note:** [`docs/feasibility/permits_geocoding_risk_note.md`](./docs/feasibility/permits_geocoding_risk_note.md)
- **L&I permits critical fields dictionary:** [`docs/data_dictionary/li_permits_critical_fields.md`](./docs/data_dictionary/li_permits_critical_fields.md)
- **Planning Districts metadata summary:** [`docs/source_catalog/planning_districts_metadata_summary.md`](./docs/source_catalog/planning_districts_metadata_summary.md)
- **Planning Districts source catalog:** [`docs/source_catalog/planning_districts.md`](./docs/source_catalog/planning_districts.md)
- **Planning Districts feasibility checklist:** [`docs/feasibility/planning_districts_feasibility.md`](./docs/feasibility/planning_districts_feasibility.md)
- **Planning Districts critical fields dictionary:** [`docs/data_dictionary/planning_districts_critical_fields.md`](./docs/data_dictionary/planning_districts_critical_fields.md)
- **ACS methodology summary:** [`docs/source_catalog/acs_context_methodology_summary.md`](./docs/source_catalog/acs_context_methodology_summary.md)
- **ACS source catalog:** [`docs/source_catalog/acs_context.md`](./docs/source_catalog/acs_context.md)
- **ACS feasibility checklist:** [`docs/feasibility/acs_feasibility.md`](./docs/feasibility/acs_feasibility.md)
- **ACS critical fields dictionary:** [`docs/data_dictionary/acs_critical_fields.md`](./docs/data_dictionary/acs_critical_fields.md)
- **Zoning metadata summary:** [`docs/source_catalog/zoning_base_districts_metadata_summary.md`](./docs/source_catalog/zoning_base_districts_metadata_summary.md)
- **Zoning source catalog:** [`docs/source_catalog/zoning_base_districts.md`](./docs/source_catalog/zoning_base_districts.md)
- **Zoning feasibility checklist:** [`docs/feasibility/zoning_feasibility.md`](./docs/feasibility/zoning_feasibility.md)
- **Zoning critical fields dictionary:** [`docs/data_dictionary/zoning_critical_fields.md`](./docs/data_dictionary/zoning_critical_fields.md)
- **Land-only area evidence note:** [`docs/feasibility/land_only_area_note.md`](./docs/feasibility/land_only_area_note.md)
- **GIS boundaries & CRS notes:** [`notes/gis/gis_boundaries_crs_notes.md`](./notes/gis/gis_boundaries_crs_notes.md)
- **Permit category grouping memo:** [`docs/decisions/permit_category_grouping_memo.md`](./docs/decisions/permit_category_grouping_memo.md)
- **Zoning vintage window memo:** [`docs/decisions/zoning_window_last5y.md`](./docs/decisions/zoning_window_last5y.md)
- **SQL Antipatterns Ch. 9 & 11 notes:** [`notes/sql/sql_antipatterns_b5_notes.md`](./notes/sql/sql_antipatterns_b5_notes.md)
- **Zoning comparability plan (draft):** [`docs/zoning_comparability_plan_draft.md`](./docs/zoning_comparability_plan_draft.md)
- **ACS to district alignment note:** [`docs/feasibility/acs_to_district_alignment_note.md`](./docs/feasibility/acs_to_district_alignment_note.md)
- **ACS uncertainty messaging notes:** [`notes/acs_uncertainty_messaging_notes.md`](./notes/acs_uncertainty_messaging_notes.md)
- **Grain spec:** [`docs/modeling/grain_spec.md`](./docs/modeling/grain_spec.md)
- **ERD text draft:** [`docs/modeling/erd_text_draft.md`](./docs/modeling/erd_text_draft.md)
- **Table inventory (feature vs rollup):** [`docs/modeling/table_inventory.md`](./docs/modeling/table_inventory.md)
- **Column contracts (DDL-ready specs):** [`docs/modeling/column_contracts.md`](./docs/modeling/column_contracts.md)
- **Metric spec template:** [`docs/templates/metric_spec_template.md`](./docs/templates/metric_spec_template.md)
- **Permits monthly count metric spec:** [`docs/metrics/permits_monthly_count.md`](./docs/metrics/permits_monthly_count.md)
- **Permits per land sq mi metric spec:** [`docs/metrics/permits_per_sqmi_land.md`](./docs/metrics/permits_per_sqmi_land.md)
- **Permits composition metric spec:** [`docs/metrics/permits_composition.md`](./docs/metrics/permits_composition.md)
- **Zoning composition by year metric spec:** [`docs/metrics/zoning_composition_by_year.md`](./docs/metrics/zoning_composition_by_year.md)
- **Zoning year-to-year churn metric spec:** [`docs/metrics/zoning_year_to_year_churn.md`](./docs/metrics/zoning_year_to_year_churn.md)
- **ACS income proxy metric spec:** [`docs/metrics/acs_income_proxy.md`](./docs/metrics/acs_income_proxy.md)
- **ACS tenure proxy metric spec:** [`docs/metrics/acs_tenure_proxy.md`](./docs/metrics/acs_tenure_proxy.md)
- **ERD diagram (Mermaid):** [`docs/diagrams/erd.mmd`](./docs/diagrams/erd.mmd)
- **ERD review checklist:** [`docs/checklists/erd_review_checklist.md`](./docs/checklists/erd_review_checklist.md)
- **Dataflow diagram (Mermaid):** [`docs/diagrams/dataflow.mmd`](./docs/diagrams/dataflow.mmd)
- **Map-first readiness contract:** [`docs/policies/map_first_readiness_contract.md`](./docs/policies/map_first_readiness_contract.md)
- **Month 1 repo review checklist:** [`docs/checklists/month1_review_checklist.md`](./docs/checklists/month1_review_checklist.md)
- **District brief spec:** [`docs/product/district_brief_spec.md`](./docs/product/district_brief_spec.md)
- **Compare districts spec:** [`docs/product/district_compare_spec.md`](./docs/product/district_compare_spec.md)
- **Month 1 recap:** [`docs/month1_recap.md`](./docs/month1_recap.md)
- **Month 1 closeout findings:** [`docs/checklists/month1_closeout_findings.md`](./docs/checklists/month1_closeout_findings.md)
- **Environment variable reference:** [`.env.example`](./.env.example)
- **Local environment setup runbook:** [`docs/runbooks/local_env_setup.md`](./docs/runbooks/local_env_setup.md)
- **Task runner (Makefile):** [`Makefile`](./Makefile)
- **Local dev runbook:** [`docs/runbooks/local_dev.md`](./docs/runbooks/local_dev.md)
- **Stack smoke test runbook:** [`docs/runbooks/stack_smoke_test.md`](./docs/runbooks/stack_smoke_test.md)
