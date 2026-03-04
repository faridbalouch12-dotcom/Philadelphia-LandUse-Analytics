# Philadelphia-LandUse-Analytics

## Project overview

An analytics platform to analyze changes in Philadelphia's planning district over time with the support of public datasets.

## Project goal

Build a reproducible analytics platform that explains how Philadelphia's 18 planning districts change over time, using public datasets. The output is a district change explorer (interactive) plus a well-modeled warehouse that supports longitudinal analysis and future expansions.

District Change is defined by the change in permits of buildings (buildings getting a rental permit), zoning (single family home getting upzoned to a multi-family home), changes in demographics (income, race, education levels, etc) tracked by the American Commmunity Survey (ACS) and changes in the district's physical boundaries itself.


## Locked decisions

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
## Month-1 deliverables (v0)

By the end of Month 1, I'll have a complete documentation package for your warehouse. No code yet, just comprehensive design artifacts with a repo structure thatlooks like this:
philly-data-warehouse/
├── README.md
├── .gitignore
├── CONTRIBUTING.md
├── docs/
│   ├── glossary.md
│   ├── problem_statement.md
│   ├── success_criteria.md
│   ├── dataset_catalog.md
│   ├── grain_spec.md
│   ├── dimension_specs.md
│   ├── metric_definitions.md
│   ├── erd.md (or .png)
│   ├── dataflow_diagram.md (or .png)
│   ├── assumptions_log.md
│   ├── style_guide.md
│   ├── repo_settings_applied.md
│   ├── week1_recap.md
│   ├── week2_recap.md
│   ├── week3_recap.md
│   ├── month1_recap.md
│   ├── knowledge_gaps.md
│   └── month2_plan.md
├── notes/
│   ├── kimball_grain_notes.md
│   ├── kimball_dimensions_notes.md
│   ├── kimball_scd_notes.md
│   ├── acs_period_estimates_notes.md
│   ├── postgis_spatial_notes.md
│   └── [other reading notes]
├── assets/
│   ├── concept_map_week1.png
│   ├── concept_map_month1.png
│   └── [diagrams, screenshots]
├── books/
│   ├── kimball_data_warehouse_toolkit.pdf
│   └── [other reference PDFs]
├── .claude/
│   ├── syllabus.md
│   ├── rubrics.md
│   ├── resources.md
│   ├── progress.md
│   └── CLAUDE.md
└── templates/
    ├── memo_template.md
    └── notes_template.md

1) **Reproducible local environment**
- `docker/` (or root) includes a working `docker-compose.yml` that starts **Postgres** and **Metabase** (and any supporting services) successfully.
- `.env.example` exists and documents required environment variables; no secrets committed.

2) **Database initialization + conventions**
- A Postgres init path exists (SQL init scripts or a Python bootstrap) that creates required schemas (e.g., `raw`, `staging`, `mart`) and core extensions (if needed).
- A short `docs/modeling_conventions.md` defines naming conventions (`raw_*`, `stg_*`, `dim_*`, `fct_*`) and the chosen time grain for Month 1.

3) **Ingestion pipeline (Python)**
- A Python ingestion module/script exists that loads **at least one core dataset** into Postgres **raw** tables (starting with planning districts boundaries + at least one of permits/zoning/ACS).
- Ingestion is **idempotent** (re-running does not duplicate data).
- Basic pipeline logging exists (run timestamp, row counts, and control totals written to a log table or log file).

4) **Core reference data in the warehouse**
- Planning district boundaries are loaded into a canonical raw table (and carried through to staging), with a clear district identifier strategy documented.
- A "date spine" or time dimension exists for the Month-1 analysis window (e.g., last 5 years).

5) **dbt project scaffold**
- A dbt project exists (`dbt/` folder) with working profiles/config for the Postgres service.
- `dbt debug` succeeds using the Docker network connection.

6) **Staging models (`stg_*`)**
- `stg_*` models exist for each ingested Month-1 source (at minimum: districts + one of permits/zoning/ACS), with cleaned field names, typed columns, and parsed dates.

7) **Marts: district-time fact table(s)**
- At least one **district-time grain** fact table exists (e.g., `fct_district_year_metrics` or `fct_district_month_metrics`) that includes:
  - permit intensity metrics normalized by land area (e.g., permits per sq mi), and/or
  - a basic zoning-change metric (for the recent 5-year YoY comparison window), and/or
  - a small set of ACS indicators aligned to the same district-time grain.

8) **Dimensions (`dim_*`)**
- Core dimensions exist to support analysis (at minimum `dim_district` and `dim_time`; optionally `dim_permit_type`, `dim_zoning_category` depending on what's ingested first).

9) **Data quality checks**
- dbt tests are implemented for marts and key dims (at least `unique`, `not_null`, and `relationships` where applicable).
- Basic "sanity checks" are documented (row count expectations, missingness checks, and any known caveats).

10) **Metabase baseline analytics**
- Metabase is connected to Postgres and contains:
  - at least 3 saved questions built from marts (not raw tables), and
  - one simple dashboard with filters (district + time period) showing trends and rankings.

11) **Documentation index + month-1 docs**
- `docs/README.md` exists as a docs index and links to all Month-1 docs.
- At least one additional Month-1 doc exists describing:
  - the district-time grain,
  - the definition of key metrics (e.g., "permits per sq mi", "YoY change"), and
  - how to run the Month-1 pipeline end-to-end.

12) **Project hygiene**
- Root `README.md` includes the required sections (Overview, Locked Decisions, Month-1 Deliverables, Repo Structure, How to Contribute/Work, Links to Docs Index).
- Repo includes baseline `.gitignore` and licensing is in place (already done)
  

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

- **Docs Index:** [`docs/README.md`](./docs/README.md)
- **Style guide:** [`docs/style_guide.md`](./docs/style_guide.md)
- **Repo settings checklist:** [`docs/repo_settings_checklist.md`](./docs/repo_settings_checklist.md)
- **Repo settings applied:** [`docs/repo_settings_applied.md`](./docs/repo_settings_applied.md)
- **Data storage policy:** [`docs/policies/data_storage_policy.md`](./docs/policies/data_storage_policy.md)
- **Contributing guide:** [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- **Learning resources:** [`docs/learning_resources.md`](./docs/learning_resources.md)
- **Bibliography:** [`docs/bibliography.md`](./docs/bibliography.md)
- **Resource triage rules:** [`notes/resource_triage_rules.md`](./notes/resource_triage_rules.md)
- **Kimball grain notes:** [`notes/kimball_grain_notes.md`](./notes/kimball_grain_notes.md)
- **Kimball facts notes:** [`notes/kimball_facts_notes.md`](./notes/kimball_facts_notes.md)
- **ACS period estimates notes:** [`notes/acs_period_estimates_notes.md`](./notes/acs_period_estimates_notes.md)
- **PostGIS spatial primer notes:** [`notes/postgis_spatial_primer_notes.md`](./notes/postgis_spatial_primer_notes.md)
- **Missing Semester Git notes:** [`notes/missing_semester_git_notes.md`](./notes/missing_semester_git_notes.md)
- **cookiecutter-data-science patterns:** [`notes/ref_patterns_cookiecutter_ds.md`](./notes/ref_patterns_cookiecutter_ds.md)
- **jaffle-shop patterns:** [`notes/ref_patterns_jaffle_shop.md`](./notes/ref_patterns_jaffle_shop.md)
