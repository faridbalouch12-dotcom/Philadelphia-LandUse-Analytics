# Syllabus Reference — Month 2

All tasks are listed by Week → Day → Task. For each task, the key fields are:
- **Task ID** and **Name**
- **Description** (the Read/Do instructions)
- **Learning Objective**
- **Definition of Done** (the exact pass criteria)
- **Deliverable Artifacts** (the exact file paths that must exist)
- **Reading Resources** / **Video Resources** (IDs — resolve in `month2_resources.md`)

> **Month 2 objective:** convert the Month 1 design package into a working local MVP: Dockerized Postgres/PostGIS + dbt + Python ingestion + Metabase, with working vertical slices for planning districts, permits, zoning, and ACS.
>
> **Workload assumption:** 7 days/week, 40–60 hours/week.
>
> **Important constraint:** this month is already aggressive. Do **not** add Airflow, cloud deployment, streaming, semantic-layer experiments, or fancy data-quality frameworks unless the core MVP is already working.

---

## Definition of “Month 2 complete”

By the end of Month 2, the repo should contain:
1. A passing local stack (`docker compose up`) with Postgres/PostGIS and Metabase.
2. A Python ingestion layer with reproducible raw loads for the 4 MVP datasets.
3. A dbt project with sources, staging models, marts, tests, and docs for the MVP.
4. Working warehouse objects for:
   - `dim_date`
   - `dim_district`
   - `geo_district_boundaries`
   - `fct_permits`
   - `fct_district_year_zoning_composition`
   - `bridge_tract_district_overlap`
   - `fct_tract_acs`
5. At least one working Metabase dashboard or dashboard-ready set of saved questions.
6. Updated README/runbooks so a reviewer can boot the project locally and understand what is implemented.

---

## WEEK 1 — Month 1 Closeout + Local Platform Foundation

### Day 1 — Resolve the remaining Month 1 contradictions

---

**Task 1.1 — Re-read Month 1 gate documents**
- Description: Re-read `docs/02_success_criteria.md`, `docs/month1_recap.md`, `docs/modeling/grain_spec.md`, `docs/modeling/table_inventory.md`, and `docs/glossary.md`. Mark exactly which contradictions still exist.
- Learning Objective: Stop coding on top of ambiguous design decisions.
- Definition of Done: You have a short written list of all remaining contradictions and missing pass criteria, with no vague “fix docs later” placeholders.
- Deliverables: `docs/checklists/month1_closeout_findings.md`
- Reading: B1

---

**Task 1.2 — Resolve the permits fact-table decision**
- Description: Decide whether the MVP contains only `fct_permits` as a transaction fact, or `fct_permits` plus a later deferred lifecycle snapshot table. Write the decision once, then reuse it everywhere.
- Learning Objective: Learn that ambiguous grain decisions are not minor wording issues; they break downstream builds.
- Definition of Done: A single sentence can answer “What is the permits fact table in the MVP?” and every related document now agrees.
- Deliverables: `docs/decision_log.md`
- Reading: B1

---

**Task 1.3 — Propagate the permits decision across all affected docs**
- Description: Update the grain spec, table inventory, glossary, recap, and ERD annotations so they all reflect the same permits-table decision.
- Learning Objective: Practice cross-document consistency, not isolated document editing.
- Definition of Done: No file in the design package describes the permits fact differently from any other file.
- Deliverables: `docs/modeling/grain_spec.md, docs/modeling/table_inventory.md, docs/glossary.md, docs/month1_recap.md, docs/diagrams/erd.mmd`
- Reading: B1

---

**Task 1.4 — Make the progress tracker real**
- Description: Replace the placeholder `.claude/progress.md` with a real Month 1 pass/fail tracker tied to the 8 success checks.
- Learning Objective: Make progress auditable instead of implied.
- Definition of Done: `.claude/progress.md` shows each Month 1 check, pass/fail status, and evidence note.
- Deliverables: `.claude/progress.md`

---

**Task 1.5 — Re-grade Month 1 honestly**
- Description: Re-run the 8 Month 1 checks after the doc fixes and record which ones now pass or fail.
- Learning Objective: Build the habit of closing loops instead of assuming completion.
- Definition of Done: The file states an explicit Month 1 score such as `8/8 PASS` or a smaller number with remaining blockers.
- Deliverables: `.claude/progress.md (updated), docs/checklists/month1_closeout_findings.md (updated)`

---

### Day 2 — Turn the Month 1 design into a usable implementation contract

---

**Task 2.1 — Add SCD strategy to dimensions**
- Description: Update the table inventory or a new dimension-spec document so each dimension includes SCD type plus project-specific rationale.
- Learning Objective: Move from conceptual dimensional modeling to actual implementation policy.
- Definition of Done: `dim_district`, `dim_date`, and `dim_zoning` each have a named SCD strategy with a non-generic reason.
- Deliverables: `docs/modeling/table_inventory.md OR docs/modeling/dimension_spec.md`
- Reading: B1, D6

---

**Task 2.2 — Upgrade `fct_permits` spec to DDL-ready**
- Description: Create `docs/modeling/column_contracts.md` and add exact columns, data types, nullability, surrogate key strategy, natural key, and dimension FKs for `fct_permits`. Do not add this to the grain spec — grain says *what each row is*, column contracts say *what each field is*. Cross-reference between the two docs.
- Learning Objective: Learn what “implementable spec” actually means, and why grain specs and column contracts are different documents with different jobs.
- Definition of Done: A reviewer could draft a first-pass `CREATE TABLE` for `fct_permits` without guessing. `column_contracts.md` and `grain_spec.md` each reference the other.
- Deliverables: `docs/modeling/column_contracts.md`
- Reading: B1, D6, D7

---

**Task 2.3 — Upgrade the remaining high-risk table specs**
- Description: Add DDL-level column contracts for `fct_district_year_zoning_composition`, `bridge_tract_district_overlap`, `fct_tract_acs`, `dim_district`, and `dim_zoning` to the same `column_contracts.md` file.
- Learning Objective: Extend rigor beyond the table you happen to think about most. Note that `dim_zoning` is a first-class dimension — it needs a column contract before the zoning marts can be built.
- Definition of Done: All 5 target tables have exact column contracts and validation rules. `dim_zoning` has a surrogate key strategy, natural key, and SCD type recorded.
- Deliverables: `docs/modeling/column_contracts.md (updated)`
- Reading: B1, D6, D7

---

**Task 2.4 — Add grain annotations to the ERD**
- Description: Annotate each fact-like table inside the Mermaid ERD body with its grain.
- Learning Objective: Make the diagram self-contained enough for a reviewer to read without cross-referencing 5 other docs.
- Definition of Done: Every fact/bridge/rollup entity shows its grain in the ERD source and renders correctly in GitHub.
- Deliverables: `docs/diagrams/erd.mmd`
- Reading: B1

---

**Task 2.5 — Split “designed” vs “implemented” in the README**
- Description: Update the README so it clearly distinguishes completed Month 1 design work from Month 2 implementation targets.
- Learning Objective: Avoid accidental overclaiming.
- Definition of Done: A new reviewer can tell in under 30 seconds what exists only as design and what exists as code.
- Deliverables: `README.md`

---

### Day 3 — Python project scaffold and local developer ergonomics

---

**Task 3.1 — Create the Python project manifest**
- Description: Create a project manifest for Python dependencies and project metadata. Keep it minimal; do not prematurely optimize packaging.
- Learning Objective: Establish one reproducible way to install and run the Python layer.
- Definition of Done: A clean environment can install dependencies from one canonical project file.
- Deliverables: `pyproject.toml`
- Reading: B8

---

**Task 3.2 — Create the source package skeleton**
- Description: Create the Python package skeleton for config, logging, ingest utilities, and validators.
- Learning Objective: Avoid a future repo where pipeline logic is scattered across random scripts.
- Definition of Done: The package imports cleanly and has clear submodules for config, common utilities, ingest, and validation.
- Deliverables: `src/philly_dw/__init__.py, src/philly_dw/config.py, src/philly_dw/logging.py, src/philly_dw/ingest/__init__.py, src/philly_dw/validate/__init__.py`

---

**Task 3.3 — Add environment-variable handling**
- Description: Define which values belong in environment variables and provide a template file for local setup.
- Learning Objective: Separate config from code before secrets and local paths start leaking into commits.
- Definition of Done: All runtime-specific values needed for Month 2 are listed in `.env.example` with comments.
- Deliverables: `.env.example, docs/runbooks/local_env_setup.md`

---

**Task 3.4 — Add task runner commands**
- Description: Add a small command runner surface for the most common tasks: stack up/down, tests, dbt build, docs generate, and core ingestion commands.
- Learning Objective: Reduce command drift and “I forgot the exact incantation” friction.
- Definition of Done: One file exists with repeatable commands for the core local workflow.
- Deliverables: `Makefile OR justfile`
- Reading: D2, D5

---

**Task 3.5 — Write the local-dev runbook**
- Description: Write the exact boot sequence for a new machine: create env, fill `.env`, boot Docker, connect to Postgres, run dbt, run tests.
- Learning Objective: Treat onboarding instructions as part of the product.
- Definition of Done: A future-you could follow the document after a month away and get the stack working.
- Deliverables: `docs/runbooks/local_dev_bootstrap.md`

---

### Day 4 — Docker Compose stack skeleton

---

**Task 4.1 — Create the Compose file**
- Description: Create the initial multi-service Compose definition. Keep it focused on only what Month 2 truly needs.
- Learning Objective: Learn to define the whole local platform as code instead of as a memory exercise.
- Definition of Done: The Compose file validates and includes at least database and BI services.
- Deliverables: `compose.yml`
- Reading: D1, D2, D5

---

**Task 4.2 — Add the PostGIS-backed database service**
- Description: Configure the local database service with the correct image, container name, volume mounts, env variables, and healthcheck.
- Learning Objective: Stand up a durable local analytical database instead of using throwaway local installs.
- Definition of Done: `docker compose up db` starts successfully, stays healthy, and persists data across restart.
- Deliverables: `compose.yml`
- Reading: D2, D4, D5

---

**Task 4.3 — Add the Metabase service**
- Description: Add Metabase to the stack and wire it so it can later connect to the project database.
- Learning Objective: Keep the reporting layer close to the warehouse from the start.
- Definition of Done: `docker compose up metabase` starts successfully and the local UI is reachable.
- Deliverables: `compose.yml`
- Reading: D26, V2

---

**Task 4.4 — Add named volumes and healthchecks**
- Description: Add persistent volumes and healthchecks for the services you actually need to keep stateful and observable.
- Learning Objective: Learn the difference between ephemeral containers and persistent data.
- Definition of Done: The database survives container restart and the Compose file has working healthchecks for key services.
- Deliverables: `compose.yml`
- Reading: D4, D5

---

**Task 4.5 — Smoke-test the whole stack**
- Description: Bring the full local stack up, restart it, inspect logs, and document any startup rough edges.
- Learning Objective: Catch local-platform issues early before adding application complexity.
- Definition of Done: `docker compose up -d` works from a clean state and a short smoke-test note exists.
- Deliverables: `docs/runbooks/stack_smoke_test.md`
- Reading: D2

---

### Day 5 — Database bootstrap and schema initialization

---

**Task 5.1 — Create database init SQL for extensions**
- Description: Add the SQL that enables required extensions such as PostGIS.
- Learning Objective: Ensure the DB starts in a project-ready state without manual clicking around.
- Definition of Done: A clean database boot includes the needed extensions automatically.
- Deliverables: `docker/postgres/init/00_extensions.sql`
- Reading: D10

---

**Task 5.2 — Create database init SQL for schemas**
- Description: Create the schema layout for `raw`, `staging`, `marts`, `analytics`, and any helper schemas you intentionally want.
- Learning Objective: Translate the warehouse layering from design docs into the physical database.
- Definition of Done: Fresh DB bootstrap creates the target schemas correctly.
- Deliverables: `docker/postgres/init/01_schemas.sql`
- Reading: D7

---

**Task 5.3 — Add a schema/read-write policy note**
- Description: Document which layer each pipeline component can write to and which layers should be treated as read-only in practice.
- Learning Objective: Prevent layer leakage before it starts.
- Definition of Done: The runbook clearly states who writes to `raw`, who transforms in `staging`, and what lives in `marts`.
- Deliverables: `docs/policies/write_access_by_layer.md`

---

**Task 5.4 — Create a safe reset workflow**
- Description: Add a documented reset path for local development that is explicit about what gets deleted.
- Learning Objective: Learn to recover quickly from bad local states without random manual cleanup.
- Definition of Done: You have one documented reset command path and it is tested once.
- Deliverables: `docs/runbooks/local_reset.md, Makefile OR justfile (updated)`
- Reading: D4

---

**Task 5.5 — Verify the database bootstrap manually**
- Description: Connect to Postgres after a clean boot and verify schemas, extension availability, and base connectivity.
- Learning Objective: Build the habit of checking the real system, not just trusting config files.
- Definition of Done: A short verification note shows the schemas and PostGIS extension are present after clean startup.
- Deliverables: `docs/runbooks/db_bootstrap_verification.md`

---

### Day 6 — dbt project scaffold

---

**Task 6.1 — Initialize the dbt project**
- Description: Create the dbt project in the repo and choose a project name that will still make sense six months from now.
- Learning Objective: Start the transformation layer early rather than bolting it on later.
- Definition of Done: The dbt project exists and `dbt debug` passes locally.
- Deliverables: `dbt/philly_dw/dbt_project.yml, dbt/philly_dw/models/.gitkeep`
- Reading: D17

---

**Task 6.2 — Configure dbt connection profiles**
- Description: Wire dbt to the local Postgres instance using the environment strategy you chose on Day 3.
- Learning Objective: Learn the boundary between runtime configuration and project code.
- Definition of Done: `dbt debug` and a trivial `dbt run` both succeed locally.
- Deliverables: `dbt/README.md, docs/runbooks/dbt_local_setup.md`
- Reading: D17

---

**Task 6.3 — Create source declarations for all 4 MVP datasets**
- Description: Add placeholder source declarations now, even if all raw tables are not yet loaded.
- Learning Objective: Make the project DAG explicit from the beginning.
- Definition of Done: dbt source YAML files exist for planning districts, permits, zoning, and ACS-related raw tables.
- Deliverables: `dbt/philly_dw/models/sources/src_planning.yml, dbt/philly_dw/models/sources/src_permits.yml, dbt/philly_dw/models/sources/src_zoning.yml, dbt/philly_dw/models/sources/src_acs.yml`
- Reading: D18

---

**Task 6.4 — Create the dbt folder structure**
- Description: Create folders for sources, staging, intermediate models if needed, marts, and docs/YAML.
- Learning Objective: Prevent a flat project layout that becomes unreadable after ten models.
- Definition of Done: The dbt project has a clean folder layout aligned to the Month 1 model design.
- Deliverables: `dbt/philly_dw/models/staging/, dbt/philly_dw/models/marts/, dbt/philly_dw/models/intermediate/`
- Reading: D21, D22, D23

---

**Task 6.5 — Generate the first dbt docs site**
- Description: Run dbt docs generation even if the project is still sparse.
- Learning Objective: Normalize documentation as part of the workflow, not an end-of-project chore.
- Definition of Done: `dbt docs generate` succeeds and the project has a saved note on how to open the docs locally.
- Deliverables: `docs/runbooks/dbt_docs.md`
- Reading: D20

---

**Task 6.6 — Define the materialization strategy**
- Description: Decide, for every planned model layer, which dbt materialization you will use: `view`, `table`, or `incremental`. Write the policy in `dbt_project.yml` folder-level defaults and note any model-level overrides you already know about (e.g., large fact tables that should not be views).
- Learning Objective: Understand that materialization is a cost-and-correctness decision, not a default you leave alone. A `view` on a 2M-row permits scan inside a dashboard query is a bad surprise.
- Definition of Done: `dbt_project.yml` has folder-level materialization defaults. A short policy note explains the rationale for each layer’s default choice.
- Deliverables: `dbt/philly_dw/dbt_project.yml (updated), docs/policies/dbt_materialization_policy.md`
- Reading: D21, D22, D23

---

### Day 7 — Tests, linting, and CI skeleton

---

**Task 7.1 — Add pytest configuration**
- Description: Add a base pytest config and test folder structure for pipeline and validation code.
- Learning Objective: Establish a home for tests before the project accumulates behavior.
- Definition of Done: `pytest` discovers the test suite and runs at least one trivial test.
- Deliverables: `tests/__init__.py, tests/test_smoke.py, pyproject.toml OR pytest.ini`
- Reading: D24

---

**Task 7.2 — Add the first real smoke test**
- Description: Write one smoke test that checks environment/config loading or DB connectivity.
- Learning Objective: Make tests prove something real, not just exist.
- Definition of Done: The smoke test fails when config is broken and passes when it is correct.
- Deliverables: `tests/test_config_or_db_connectivity.py`
- Reading: D24, D15

---

**Task 7.3 — Add lint/format tooling**
- Description: Add one Python lint/format path and document how to run it. Keep the setup simple.
- Learning Objective: Catch obvious code-quality mistakes early.
- Definition of Done: One command runs the chosen lint/format checks locally.
- Deliverables: `pyproject.toml (updated), Makefile OR justfile (updated)`

---

**Task 7.4 — Add pre-commit hooks**
- Description: Add lightweight pre-commit hooks for Python formatting/linting plus basic YAML/whitespace sanity checks.
- Learning Objective: Shift easy mistakes left.
- Definition of Done: Pre-commit runs locally and checks at least Python + generic text hygiene.
- Deliverables: `.pre-commit-config.yaml`

---

**Task 7.5 — Add a GitHub Actions workflow**
- Description: Add a minimal CI workflow that installs Python dependencies and runs the core test command.
- Learning Objective: Prove the repo can catch breakage without relying only on local runs.
- Definition of Done: A workflow file exists and runs successfully on one push.
- Deliverables: `.github/workflows/python-ci.yml`
- Reading: D25

---

## WEEK 2 — Planning Districts Vertical Slice

### Day 8 — Planning districts raw ingestion

---

**Task 8.1 — Inspect the planning-district source endpoint**
- Description: Reconfirm the access method, query shape, row count expectations, fields, and geometry presence before writing the loader.
- Learning Objective: Never start coding extraction from a half-remembered endpoint.
- Definition of Done: The extraction note records endpoint URL, expected response type, and fields needed for Month 2.
- Deliverables: `docs/runbooks/planning_districts_extract_plan.md`
- Reading: D30

---

**Task 8.2 — Build the raw extractor**
- Description: Create the Python extraction command for planning districts, including explicit out-fields and geometry handling.
- Learning Objective: Learn to write repeatable extracts instead of one-off notebook pulls.
- Definition of Done: One command lands a raw snapshot locally from the source endpoint.
- Deliverables: `src/philly_dw/ingest/planning_districts.py`
- Reading: D14, D30

---

**Task 8.3 — Add raw snapshot manifest metadata**
- Description: Save metadata with each raw extract: extraction time, row count, source URL, and file hash if feasible.
- Learning Objective: Make raw loads traceable and restartable.
- Definition of Done: A manifest file is created alongside the raw payload and contains extraction metadata.
- Deliverables: `data/raw/planning_districts/<snapshot_date>/manifest.json`
- Reading: B2

---

**Task 8.4 — Land the first raw snapshot**
- Description: Run the extractor and save the first snapshot into the repo’s raw-data layout.
- Learning Objective: Turn the ingestion code into evidence, not aspiration.
- Definition of Done: The raw snapshot exists locally and can be inspected independently of the extractor code.
- Deliverables: `data/raw/planning_districts/<snapshot_date>/planning_districts_raw.*`

---

**Task 8.5 — Write the raw-ingest runbook**
- Description: Document how to rerun the extract, where the files land, and what “good” output looks like.
- Learning Objective: Treat extraction as an operational workflow.
- Definition of Done: The runbook is specific enough that you could rerun the step after forgetting the command.
- Deliverables: `docs/runbooks/planning_districts_raw_ingest.md`

---

### Day 9 — Planning districts raw QA

---

**Task 9.1 — Record row-count expectations**
- Description: Compare the landed snapshot’s row count to the expected district count and document any mismatch.
- Learning Objective: Start every dataset with count sanity checks before transformation.
- Definition of Done: The QA note states the expected row count, actual row count, and disposition.
- Deliverables: `docs/qa/planning_districts_raw_qa.md`

---

**Task 9.2 — Verify the key fields**
- Description: Confirm the candidate business key(s), district name fields, and any area-related fields from the raw snapshot.
- Learning Objective: Verify field assumptions before you hardcode them into models.
- Definition of Done: The QA note explicitly states which field(s) will become the district business key and why.
- Deliverables: `docs/qa/planning_districts_raw_qa.md (updated)`
- Reading: D6

---

**Task 9.3 — Verify geometry presence and type**
- Description: Check whether the raw snapshot contains geometry, what geometry type it is, and whether any rows are null or invalid.
- Learning Objective: Learn to profile geometry early, not after spatial joins start failing.
- Definition of Done: The QA note records geometry presence, geometry type, and null/invalid counts.
- Deliverables: `docs/qa/planning_districts_raw_qa.md (updated)`
- Reading: D10, D14

---

**Task 9.4 — Inspect CRS/SRID evidence**
- Description: Determine what the source explicitly says about spatial reference and what still needs verification in-database.
- Learning Objective: Stop treating CRS as an afterthought.
- Definition of Done: You have a written statement of what is known, what is inferred, and what still needs DB-level confirmation.
- Deliverables: `docs/qa/planning_districts_raw_qa.md (updated), docs/limitations_register.md (updated)`
- Reading: D10, D12

---

**Task 9.5 — Add at least one raw-data validator test**
- Description: Write a Python validator or test for the easiest high-value rule: expected row count, required columns, or non-null key field.
- Learning Objective: Start automating QA instead of leaving it as a note-only process.
- Definition of Done: One test fails when the key assumption is violated.
- Deliverables: `tests/test_planning_districts_raw.py`
- Reading: D24

---

### Day 10 — Load planning districts into the warehouse and create staging

---

**Task 10.1 — Create the raw landing table**
- Description: Create the raw table definition for planning districts in Postgres/PostGIS.
- Learning Objective: Move from filesystem snapshots into warehouse-managed raw storage.
- Definition of Done: A raw table exists in the DB and matches the intended landing shape.
- Deliverables: `sql/raw/planning_districts_raw.sql OR src/philly_dw/load/planning_districts_raw.py`
- Reading: D6, D7

---

**Task 10.2 — Load the first snapshot into `raw`**
- Description: Load the landed planning-district snapshot into the raw schema.
- Learning Objective: Build the full extract-to-load path before writing transformations.
- Definition of Done: The raw table contains the loaded snapshot and row counts match the raw file.
- Deliverables: `src/philly_dw/load/planning_districts_raw.py OR docs/runbooks/planning_districts_raw_load.md`
- Reading: D15

---

**Task 10.3 — Declare the planning-district source in dbt**
- Description: Update the dbt source YAML to point to the raw table you just loaded.
- Learning Objective: Make raw lineage visible in the dbt DAG.
- Definition of Done: `dbt source freshness` or source parsing recognizes the planning-district raw table.
- Deliverables: `dbt/philly_dw/models/sources/src_planning.yml`
- Reading: D18

---

**Task 10.4 — Build `stg_planning_districts`**
- Description: Create the staging model that standardizes names, keys, geometry field names, and any obvious cleanup.
- Learning Objective: Separate raw landing from cleaned analytical staging.
- Definition of Done: The staging model builds successfully and contains only the cleaned fields you intend downstream.
- Deliverables: `dbt/philly_dw/models/staging/planning/stg_planning_districts.sql`
- Reading: D22

---

**Task 10.5 — Add dbt tests for the staging model**
- Description: Add not-null and uniqueness tests for the district business key and any other obvious invariants.
- Learning Objective: Use dbt tests where table-level warehouse assertions are appropriate.
- Definition of Done: `dbt test --select stg_planning_districts` passes.
- Deliverables: `dbt/philly_dw/models/staging/planning/stg_planning_districts.yml`
- Reading: D19

---

### Day 11 — CRS validation and land area computation

---

**Task 11.1 — Confirm the geometry SRID in-database**
- Description: Inspect the loaded district geometry in PostGIS and confirm what SRID the DB thinks it has.
- Learning Objective: Move CRS confirmation out of guesswork and into actual DB inspection.
- Definition of Done: A note exists stating the source SRID and how it was verified.
- Deliverables: `docs/qa/planning_districts_crs_validation.md`
- Reading: D10, D12

---

**Task 11.2 — Choose the projected CRS for area calculations**
- Description: Choose and document the projected CRS you will use for area calculations and why.
- Learning Objective: Learn that area calculations require an intentional projection choice.
- Definition of Done: The selected projected CRS is recorded and justified in one place.
- Deliverables: `docs/decision_log.md (updated), docs/qa/planning_districts_crs_validation.md (updated)`
- Reading: D12, D13

---

**Task 11.3 — Compute `land_area_sqmi`**
- Description: Transform the geometry to the chosen projected CRS and compute district land area in square miles.
- Learning Objective: Turn the Month 1 denominator policy into a working warehouse field.
- Definition of Done: A model or SQL statement exists that computes non-null positive `land_area_sqmi`.
- Deliverables: `dbt/philly_dw/models/intermediate/planning/int_planning_district_area.sql`
- Reading: D12, D13

---

**Task 11.4 — Reconcile the computed area with any source area field**
- Description: If the source exposes area-like fields, compare them to your computed value and note the differences.
- Learning Objective: Build trust in the calculation instead of assuming it is correct.
- Definition of Done: The QA note states whether the computed area is accepted as canonical and why.
- Deliverables: `docs/qa/planning_districts_crs_validation.md (updated)`

---

**Task 11.5 — Add an automated area sanity test**
- Description: Add a test asserting that district area is positive and not null for all districts.
- Learning Objective: Catch broken geometry or projection issues early.
- Definition of Done: The automated test runs and passes.
- Deliverables: `dbt/philly_dw/models/intermediate/planning/int_planning_district_area.yml OR tests/test_planning_area.py`
- Reading: D19, D24

---

### Day 12 — Build district dimensions and geometry tables

---

**Task 12.1 — Build `dim_date`**
- Description: Create the first version of `dim_date` with the date range needed for permits, zoning vintages, and month/year rollups.
- Learning Objective: Make date joins explicit instead of improvised in each query.
- Definition of Done: `dim_date` builds with the required date keys and calendar attributes.
- Deliverables: `dbt/philly_dw/models/marts/dimensions/dim_date.sql, dbt/philly_dw/models/marts/dimensions/dim_date.yml`
- Reading: B1

---

**Task 12.2 — Build `dim_district`**
- Description: Build the district dimension with the chosen business key, surrogate key if used, district names, and stable descriptive attributes.
- Learning Objective: Separate descriptive district attributes from geometry and metrics.
- Definition of Done: `dim_district` builds and contains one current row per district for the MVP.
- Deliverables: `dbt/philly_dw/models/marts/dimensions/dim_district.sql, dbt/philly_dw/models/marts/dimensions/dim_district.yml`
- Reading: B1, D23

---

**Task 12.3 — Build `geo_district_boundaries`**
- Description: Create the geometry table separated from `dim_district`, consistent with the Month 1 design decision.
- Learning Objective: Keep geometry-heavy tables isolated from descriptive dimensions.
- Definition of Done: The geometry table builds and joins cleanly to `dim_district`.
- Deliverables: `dbt/philly_dw/models/marts/geo/geo_district_boundaries.sql, dbt/philly_dw/models/marts/geo/geo_district_boundaries.yml`
- Reading: D10, D23

---

**Task 12.4 — Add dimension/geometry relationship tests**
- Description: Add tests for uniqueness, not-null keys, and district-to-geometry join integrity.
- Learning Objective: Make your dimensional assumptions executable.
- Definition of Done: The tests pass and relationship assumptions are encoded in code, not just in docs.
- Deliverables: `dbt/philly_dw/models/marts/dimensions/dim_district.yml, dbt/philly_dw/models/marts/geo/geo_district_boundaries.yml`
- Reading: D19

---

**Task 12.5 — Update dbt documentation for the district layer**
- Description: Add descriptions for models and key columns in the district slice.
- Learning Objective: Practice building a warehouse that others can read, not just query.
- Definition of Done: The key district models and columns appear with descriptions in dbt docs.
- Deliverables: `dbt/philly_dw/models/marts/dimensions/dim_district.yml, dbt/philly_dw/models/marts/geo/geo_district_boundaries.yml (updated)`
- Reading: D20

---

### Day 13 — Connect the district slice to Metabase

---

**Task 13.1 — Connect Metabase to the Postgres database**
- Description: Add the project database in Metabase and verify basic connectivity.
- Learning Objective: Make the warehouse visible to the BI layer early.
- Definition of Done: Metabase can see the target schemas/tables.
- Deliverables: `docs/runbooks/metabase_connection.md`
- Reading: D26

---

**Task 13.2 — Expose the district dimension and geometry tables**
- Description: Verify that the district tables are queryable from Metabase and note any visibility issues.
- Learning Objective: Close the loop from warehouse object to analyst-facing tool.
- Definition of Done: The target tables can be queried in Metabase.
- Deliverables: `docs/runbooks/metabase_connection.md (updated)`

---

**Task 13.3 — Create one district sanity question**
- Description: Create a basic sanity question/table showing the district list and area values.
- Learning Objective: Use the BI layer as a debugging surface, not just a final presentation layer.
- Definition of Done: One saved Metabase question exists and returns the expected district rows.
- Deliverables: `assets/screenshots/metabase_district_sanity.png OR docs/runbooks/metabase_district_sanity.md`
- Reading: D27, V2

---

**Task 13.4 — Capture any district-slice issues discovered in Metabase**
- Description: Record naming, field-type, visibility, or usability issues that only become obvious in the BI layer.
- Learning Objective: Learn that model usability matters in addition to correctness.
- Definition of Done: A small backlog note exists with concrete fix items.
- Deliverables: `docs/backlog/metabase_modeling_backlog.md`

---

**Task 13.5 — Update the docs index**
- Description: Add the new runbooks, QA notes, and implementation files to the docs index.
- Learning Objective: Keep documentation discoverable while the repo is growing fast.
- Definition of Done: No new docs created in Week 2 are missing from the docs index.
- Deliverables: `docs/README.md`

---

### Day 14 — Week 2 checkpoint and cleanup

---

**Task 14.1 — Run the district slice from clean start**
- Description: From a clean local state, boot the stack and rebuild the full planning-district slice end to end.
- Learning Objective: Prove the slice is reproducible, not just salvageable.
- Definition of Done: You can go from zero to working district models and Metabase visibility using the documented workflow.
- Deliverables: `docs/runbooks/district_slice_rebuild.md`

---

**Task 14.2 — Refactor obvious naming or structure debt**
- Description: Fix awkward naming, duplicate logic, or misplaced files discovered during the first full vertical slice.
- Learning Objective: Refactor while the cost is still low.
- Definition of Done: The district slice is cleaner than it was on Day 13, with no unresolved “obvious mess” left behind.
- Deliverables: `src/... OR dbt/... (refactored), docs/runbooks/district_slice_rebuild.md (updated)`
- Reading: B8

---

**Task 14.3 — Add a district-slice QA checklist**
- Description: Create a short checklist of the validations you now expect to run whenever the district slice changes.
- Learning Objective: Convert ad hoc checking into repeatable review.
- Definition of Done: The checklist contains only checks you would realistically rerun.
- Deliverables: `docs/checklists/district_slice_qa.md`

---

**Task 14.4 — Write the district-slice recap**
- Description: Write a short recap: what works, what is still brittle, and what needs to be reused for permits/zoning/ACS.
- Learning Objective: Extract the repeatable engineering lessons from the first slice.
- Definition of Done: The recap is specific enough to guide Week 3.
- Deliverables: `docs/recaps/week2_district_slice.md`

---

**Task 14.5 — Open the permits blocker list**
- Description: List any blockers that could slow permits implementation: endpoint size, geometry uncertainty, batching, category normalization, or district assignment assumptions.
- Learning Objective: Begin Week 3 with eyes open.
- Definition of Done: The blocker list is written before any permits code starts.
- Deliverables: `docs/backlog/permits_blockers.md`

---

## WEEK 3 — Permits Vertical Slice

### Day 15 — Permits extraction strategy

---

**Task 15.1 — Re-inspect the permits source**
- Description: Confirm access method, row volume, pagination strategy, and geometry/location fields for the permits source.
- Learning Objective: Large sources require an extraction plan, not just enthusiasm.
- Definition of Done: The extraction note states how you will page or partition the source.
- Deliverables: `docs/runbooks/li_permits_extract_plan.md`
- Reading: D30

---

**Task 15.2 — Choose the extraction key strategy**
- Description: Decide whether batching is based on object ID ranges, issue date windows, or another stable partitioning key.
- Learning Objective: Learn to design restarts and backfills intentionally.
- Definition of Done: One batching strategy is documented with rationale and restart behavior.
- Deliverables: `docs/runbooks/li_permits_extract_plan.md (updated)`
- Reading: B2, D30

---

**Task 15.3 — Build the permits extractor CLI/module**
- Description: Create the Python extraction command for permits with batching support.
- Learning Objective: Build a repeatable loader for large public-source data.
- Definition of Done: The extractor can run against a small bounded partition and save raw output locally.
- Deliverables: `src/philly_dw/ingest/li_permits.py`
- Reading: D14, D30, D15

---

**Task 15.4 — Land a small sample successfully**
- Description: Run the extractor on a small bounded slice first.
- Learning Objective: De-risk the extraction before attempting larger loads.
- Definition of Done: A sample raw snapshot lands successfully and can be reloaded.
- Deliverables: `data/raw/li_permits/<snapshot_or_partition>/...`

---

**Task 15.5 — Write the backfill plan**
- Description: Write the sequence you will use to expand from sample extraction to the desired history window.
- Learning Objective: Separate “the extractor works” from “the backfill is operationally defined.”
- Definition of Done: The plan states partition order, checkpointing, and what to do on failure.
- Deliverables: `docs/runbooks/li_permits_backfill_plan.md`

---

### Day 16 — Permits raw load and checkpointing

---

**Task 16.1 — Create the raw permits landing table**
- Description: Define the raw landing table for permits in Postgres.
- Learning Objective: Give the large raw source a stable warehouse landing zone.
- Definition of Done: The raw table exists with the intended landing columns and geometry handling.
- Deliverables: `sql/raw/li_permits_raw.sql OR src/philly_dw/load/li_permits_raw.py`
- Reading: D6, D7

---

**Task 16.2 — Load the first batch into `raw`**
- Description: Load the sample/bounded raw file into the raw schema.
- Learning Objective: Turn extraction output into usable warehouse state.
- Definition of Done: The loaded row count matches the landed raw batch.
- Deliverables: `src/philly_dw/load/li_permits_raw.py`

---

**Task 16.3 — Add raw-batch manifest/checkpoint tracking**
- Description: Track what has already been extracted and loaded so reruns are safe.
- Learning Objective: Learn the operational side of batch ingestion.
- Definition of Done: A manifest or checkpoint table/file exists and can be updated after each successful batch.
- Deliverables: `src/philly_dw/ingest/checkpoints.py, data/raw/li_permits/checkpoints.json OR raw.ingest_checkpoints table`
- Reading: B2

---

**Task 16.4 — Validate row counts and key coverage**
- Description: Compare landed file counts to DB counts and inspect obvious key/date nulls in raw.
- Learning Objective: Catch extraction/load corruption early.
- Definition of Done: A raw QA note records row-count parity and any glaring null-pattern issues.
- Deliverables: `docs/qa/li_permits_raw_qa.md`

---

**Task 16.5 — Run one safe rerun scenario**
- Description: Intentionally rerun a completed batch and verify the chosen checkpoint/idempotency behavior.
- Learning Objective: Prove your loader is restartable.
- Definition of Done: The rerun behavior is documented and does not silently double-load data.
- Deliverables: `docs/qa/li_permits_raw_qa.md (updated), docs/runbooks/li_permits_backfill_plan.md (updated)`

---

### Day 17 — Permits staging normalization

---

**Task 17.1 — Declare the permits raw source in dbt**
- Description: Wire the raw permits table into dbt as a source.
- Learning Objective: Bring the permits raw data into the DAG cleanly.
- Definition of Done: dbt recognizes the raw permits source.
- Deliverables: `dbt/philly_dw/models/sources/src_permits.yml`
- Reading: D18

---

**Task 17.2 — Build `stg_li_permits_base`**
- Description: Create the base staging model that renames fields, standardizes types, and preserves raw lineage.
- Learning Objective: Use staging to normalize, not to bury business logic.
- Definition of Done: The model builds and the output schema is cleaner than the raw source but still close to it.
- Deliverables: `dbt/philly_dw/models/staging/permits/stg_li_permits_base.sql`
- Reading: D22

---

**Task 17.3 — Standardize core dates and categories**
- Description: Normalize issue dates, completion/status dates if retained, and your chosen permit category grouping fields. The category grouping logic must live in a dbt seed file (`permit_category_groups.csv`) — not as a CASE statement inside the staging SQL. The staging model should JOIN to that seed. This is the correct pattern from B5 (SQL Antipatterns, “Enum Strings” chapter): externalize lookup logic so it can be reviewed and updated without touching SQL.
- Learning Objective: Understand the difference between data transformation (the staging model’s job) and mapping/lookup tables (a seed’s job). The staging model should be readable as “what the field means”, not “where this category belongs.”
- Definition of Done: `permit_category_groups.csv` exists as a dbt seed with raw category values mapped to canonical groups. The staging model joins to it rather than embedding category logic inline. The seed is documented in YAML.
- Deliverables: `dbt/philly_dw/seeds/permit_category_groups.csv, dbt/philly_dw/seeds/permit_category_groups.yml, dbt/philly_dw/models/staging/permits/stg_li_permits_base.sql (updated), dbt/philly_dw/models/staging/permits/stg_li_permits_base.yml`
- Reading: B1, B5, D20

---

**Task 17.4 — Add key logic and dedupe rules**
- Description: Implement the natural key / surrogate key logic and document any deduplication assumptions.
- Learning Objective: Learn that raw public data often needs explicit duplicate handling.
- Definition of Done: The staging layer has a documented unique-row strategy.
- Deliverables: `dbt/philly_dw/models/staging/permits/stg_li_permits_base.sql (updated), docs/qa/li_permits_raw_qa.md (updated)`
- Reading: D6, D19

---

**Task 17.5 — Add staging tests**
- Description: Add dbt tests for the core staging invariants you can already assert.
- Learning Objective: Encode what “clean enough for downstream use” means.
- Definition of Done: The permits staging tests pass.
- Deliverables: `dbt/philly_dw/models/staging/permits/stg_li_permits_base.yml`
- Reading: D19

---

### Day 18 — District assignment and spatial QA for permits

---

**Task 18.1 — Confirm the permit geometry strategy**
- Description: Verify which geometry field or location representation you will use for district assignment.
- Learning Objective: Avoid silently using the wrong spatial representation.
- Definition of Done: One written note states the chosen geometry source and what happens when it is missing.
- Deliverables: `docs/decision_log.md (updated), docs/qa/li_permits_spatial_assignment.md`
- Reading: D10, D30

---

**Task 18.2 — Build the permit geometry staging model**
- Description: Create the staging model that exposes the geometry needed for district assignment.
- Learning Objective: Keep geometry preparation explicit instead of buried inside the final fact model.
- Definition of Done: A staging model exists with the permit geometry prepared for spatial join.
- Deliverables: `dbt/philly_dw/models/staging/permits/stg_li_permits_geo.sql`
- Reading: D10, D12

---

**Task 18.3 — Build the spatial join to districts**
- Description: Join staged permits to district geometry using the chosen spatial rule.
- Learning Objective: Implement the district-assignment logic as a reviewable model.
- Definition of Done: The join produces assigned district keys for the rows that can be spatially located.
- Deliverables: `dbt/philly_dw/models/intermediate/permits/int_li_permits_district_assignment.sql`
- Reading: D10, D11

---

**Task 18.4 — Measure unassigned share**
- Description: Calculate the share of permits that cannot be assigned to a district and record it.
- Learning Objective: Publish spatial uncertainty instead of hiding it.
- Definition of Done: An unassigned-share metric exists and is documented.
- Deliverables: `docs/qa/li_permits_spatial_assignment.md (updated), dbt/philly_dw/models/intermediate/permits/int_li_permits_assignment_qa.sql`

---

**Task 18.5 — Record spatial-assignment caveats**
- Description: Add the major caveats from the district-assignment step to the limitations register and/or disclaimer library.
- Learning Objective: Carry uncertainty forward into analyst-facing outputs.
- Definition of Done: The relevant limitations/disclaimers are updated with concrete wording.
- Deliverables: `docs/limitations_register.md, docs/policies/disclaimer_library.md`
- Reading: B2

---

### Day 19 — Build `fct_permits`

---

**Task 19.1 — Reconfirm the fact grain in code**
- Description: Before writing the fact model, restate the grain in the model header comment or YAML.
- Learning Objective: Prevent accidental drift between spec and implementation.
- Definition of Done: The model itself contains or links to its grain statement.
- Deliverables: `dbt/philly_dw/models/marts/permits/fct_permits.sql OR .yml`
- Reading: B1

---

**Task 19.2 — Build the fact model**
- Description: Create `fct_permits` from the cleaned staging and district-assignment layers.
- Learning Objective: Translate design grain into actual SQL.
- Definition of Done: The fact table builds and its row count aligns with the intended grain after exclusions/dedupes.
- Deliverables: `dbt/philly_dw/models/marts/permits/fct_permits.sql`
- Reading: D23

---

**Task 19.3 — Add relationship and uniqueness tests**
- Description: Add dbt tests for the chosen natural key / uniqueness rule and for FK relationships to date/district.
- Learning Objective: Enforce the basic integrity of the permits fact.
- Definition of Done: The tests pass and reflect the spec.
- Deliverables: `dbt/philly_dw/models/marts/permits/fct_permits.yml`
- Reading: D19

---

**Task 19.4 — Validate row counts against the raw source**
- Description: Compare `fct_permits` row counts to the raw landing table. Account for intentional exclusions (nulls, dedupes, unassigned) and document the reconciliation. This is your control total check — it should be repeatable, not a one-time spot check.
- Learning Objective: Build the discipline of tracing mart rows back to raw source counts. A fact table that no one can reconcile to source is a liability.
- Definition of Done: A control-total note exists showing the raw count, exclusion reasons, and final fact count. The arithmetic adds up. Any unexplained variance is flagged.
- Deliverables: `docs/qa/fct_permits_control_totals.md`
- Reading: B2

---

**Task 19.5 — Validate the fact against the metric specs**
- Description: Compare the implemented fact fields to the Month 1 metric definitions for permits.
- Learning Objective: Ensure the fact really supports the promised metrics.
- Definition of Done: Each permits metric spec is marked “supported” or “missing field/logic” with evidence.
- Deliverables: `docs/checklists/permits_metric_spec_validation.md`

---

### Day 20 — Build the permits marts

---

**Task 20.1 — Build monthly permit counts**
- Description: Create the permits monthly count mart/model from `fct_permits`.
- Learning Objective: Build the first analyst-facing aggregate from the fact.
- Definition of Done: The model builds and can answer “monthly permit counts by district”.
- Deliverables: `dbt/philly_dw/models/marts/permits/mart_permits_monthly_count.sql`
- Reading: D23

---

**Task 20.2 — Build permits per land square mile**
- Description: Join the permits fact to district area and build the density metric model.
- Learning Objective: Convert a documented denominator policy into executable SQL.
- Definition of Done: The model builds with the correct district-area denominator.
- Deliverables: `dbt/philly_dw/models/marts/permits/mart_permits_per_sqmi_land.sql`
- Reading: B1

---

**Task 20.3 — Build permits composition**
- Description: Create the category-composition mart/model from the permits fact.
- Learning Objective: Support share-based category analysis, not just counts.
- Definition of Done: The model builds and the category shares aggregate correctly at the defined grain.
- Deliverables: `dbt/philly_dw/models/marts/permits/mart_permits_composition.sql`

---

**Task 20.4 — Document the permits marts**
- Description: Add model and key-column descriptions plus any caveat text needed in YAML.
- Learning Objective: Keep marts usable by others.
- Definition of Done: The new marts appear clearly in dbt docs.
- Deliverables: `dbt/philly_dw/models/marts/permits/marts_permits.yml`
- Reading: D20

---

**Task 20.5 — Create 2–3 Metabase sanity questions for permits**
- Description: Build a few simple Metabase questions against the permit marts to verify the output is usable.
- Learning Objective: Use the BI layer to pressure-test naming and usability.
- Definition of Done: At least 2 saved questions exist and produce sensible results.
- Deliverables: `assets/screenshots/metabase_permits_sanity.png OR docs/runbooks/metabase_permits_sanity.md`
- Reading: D27, V2

---

### Day 21 — Permits checkpoint and hardening

---

**Task 21.1 — Run a full rebuild of the permits slice**
- Description: Rebuild raw → staging → fact → marts for the permits slice and time the main steps.
- Learning Objective: See the operational behavior of the slice, not just its happy-path SQL.
- Definition of Done: The rebuild finishes and a timing note exists.
- Deliverables: `docs/runbooks/permits_slice_rebuild.md`

---

**Task 21.2 — Add performance-minded indexes where justified**
- Description: Now that you have real query shapes from Day 19–20 Metabase questions and dbt tests, add indexes for the joins and filters you actually ran. Spatial index on the district geometry table if not already present. B-tree on `permitissuedate` and `district_key` if permit scans are slow.
- Learning Objective: Learn to index after you have evidence, not before. An index added without a query to justify it is noise.
- Definition of Done: Any added index is documented in `index_notes.md` with the query pattern that motivated it. No index exists without a named reason.
- Deliverables: `sql/performance/permits_indexes.sql, docs/runbooks/index_notes.md`
- Reading: D8, D11

---

**Task 21.3 — Triage the slowest query or model**
- Description: Identify the slowest step in the permits slice and improve it once.
- Learning Objective: Practice focused performance tuning instead of aimless micro-optimization.
- Definition of Done: One concrete bottleneck is improved or explicitly deferred with rationale.
- Deliverables: `docs/runbooks/index_notes.md (updated)`

---

**Task 21.4 — Update the limitations register**
- Description: Add any new permits-specific caveats discovered during build or QA.
- Learning Objective: Keep risk tracking live during implementation.
- Definition of Done: The limitations register reflects actual Week 3 findings.
- Deliverables: `docs/limitations_register.md`

---

**Task 21.5 — Write the permits vertical-slice recap**
- Description: Summarize what works, what is fragile, and what patterns to reuse in Week 4.
- Learning Objective: Make the learning reusable across datasets.
- Definition of Done: The recap is explicit about the remaining risks in zoning and ACS.
- Deliverables: `docs/recaps/week3_permits_slice.md`

---

**Task 21.6 — Re-check the Month 1 permits-related docs against the implementation**
- Description: Confirm the code and docs still agree on grain, keys, and caveats after the real build.
- Learning Objective: Keep documentation alive after coding starts.
- Definition of Done: Any drift is fixed immediately.
- Deliverables: `docs/modeling/grain_spec.md, docs/modeling/table_inventory.md, docs/metrics/permits_*.md (updated if needed)`

---

## WEEK 4 — Zoning Vertical Slice

### Day 22 — Zoning raw ingestion

---

**Task 22.1 — Inventory the zoning vintages**
- Description: List the available vintages/files/endpoints you will use in Month 2.
- Learning Objective: Build a controlled vintage plan before loading spatial snapshots.
- Definition of Done: One note lists the zoning vintages and how each one will be accessed.
- Deliverables: `docs/runbooks/zoning_vintage_inventory.md`

---

**Task 22.2 — Define the zoning raw-file layout**
- Description: Decide where raw zoning vintages will live locally and how they will be named.
- Learning Objective: Keep multi-vintage spatial inputs organized and auditable.
- Definition of Done: The raw storage convention is documented and used for the first landed vintages.
- Deliverables: `docs/runbooks/zoning_raw_layout.md`

---

**Task 22.3 — Land two vintages as a smoke test**
- Description: Extract or download two zoning vintages first before automating the full set.
- Learning Objective: De-risk the raw-access path before expanding to all vintages.
- Definition of Done: Two zoning raw snapshots exist locally and can be inspected.
- Deliverables: `data/raw/zoning_base_districts/<vintage>/...`
- Reading: D14, D30

---

**Task 22.4 — Build the repeatable zoning raw loader**
- Description: Create the Python extraction/loading path for the remaining vintages.
- Learning Objective: Turn one-off raw access into a repeatable process.
- Definition of Done: One command or script can process a specified zoning vintage.
- Deliverables: `src/philly_dw/ingest/zoning_base_districts.py`

---

**Task 22.5 — Write the zoning-ingest runbook**
- Description: Document the exact steps for landing and rerunning zoning vintages.
- Learning Objective: Preserve the extraction logic outside your short-term memory.
- Definition of Done: The runbook includes the command pattern and expected outputs.
- Deliverables: `docs/runbooks/zoning_raw_ingest.md`

---

### Day 23 — Zoning staging, geometry validation, and CRS work

---

**Task 23.1 — Create the zoning raw landing table strategy**
- Description: Decide whether zoning raw tables are per-vintage or unioned-with-vintage-column and implement the landing approach.
- Learning Objective: Make the multi-vintage physical design explicit before modeling on top of it.
- Definition of Done: The chosen raw landing strategy exists in the database.
- Deliverables: `sql/raw/zoning_raw.sql OR src/philly_dw/load/zoning_raw.py`
- Reading: D6, D7

---

**Task 23.2 — Declare zoning raw sources in dbt**
- Description: Wire the raw zoning tables into dbt.
- Learning Objective: Keep lineage explicit even for multi-vintage spatial tables.
- Definition of Done: dbt sources exist for the zoning raw layer.
- Deliverables: `dbt/philly_dw/models/sources/src_zoning.yml`
- Reading: D18

---

**Task 23.3 — Build the staging model for zoning polygons**
- Description: Standardize vintage, zoning code fields, geometry column, and obvious cleanup rules.
- Learning Objective: Keep raw-to-clean transformation readable and reviewable.
- Definition of Done: The staging model builds successfully for the landed vintages.
- Deliverables: `dbt/philly_dw/models/staging/zoning/stg_zoning_base_districts.sql`
- Reading: D22

---

**Task 23.4 — Validate CRS and geometry quality**
- Description: Confirm SRID, inspect invalid geometries, and note any repair strategy if needed.
- Learning Objective: Avoid calculating areas or overlaps on broken geometry.
- Definition of Done: The zoning geometry QA note records SRID, invalid-geometry count, and next-step disposition.
- Deliverables: `docs/qa/zoning_geometry_qa.md`
- Reading: D10, D12

---

**Task 23.5 — Compute zoning polygon area in the chosen projected CRS**
- Description: Calculate polygon area in the correct projected CRS and expose it as a staging/intermediate field.
- Learning Objective: Ensure zoning composition can later be area-based rather than purely polygon-count based.
- Definition of Done: The area field is computed and documented.
- Deliverables: `dbt/philly_dw/models/intermediate/zoning/int_zoning_polygon_area.sql`
- Reading: D12, D13

---

### Day 24 — Zoning vocabulary EDA and crosswalk seed

---

**Task 24.1 — Extract distinct zoning codes by vintage**
- Description: Create a simple profile of distinct zoning codes for each landed vintage.
- Learning Objective: Make vocabulary drift measurable instead of anecdotal.
- Definition of Done: One artifact lists the distinct codes by vintage.
- Deliverables: `analysis/zoning_code_profiles.csv OR docs/qa/zoning_code_profiles.md`

---

**Task 24.2 — Compare code sets year-to-year**
- Description: Identify codes added, removed, or renamed between adjacent vintages.
- Learning Objective: Turn “drift” into explicit change sets.
- Definition of Done: The comparison artifact clearly shows new/removed/changed codes.
- Deliverables: `analysis/zoning_code_diffs.csv OR docs/qa/zoning_code_profiles.md (updated)`

---

**Task 24.3 — Create the initial crosswalk seed**
- Description: Build the first version of the zoning code crosswalk seed file used by dbt or Python logic.
- Learning Objective: Externalize mapping logic instead of hardcoding it into SQL.
- Definition of Done: A seed file exists with vintage/code mappings and status notes.
- Deliverables: `dbt/philly_dw/seeds/zoning_code_crosswalk.csv`
- Reading: D20

---

**Task 24.4 — Flag unstable or unresolved mappings**
- Description: Add fields or notes indicating which mappings are safe, ambiguous, or intentionally excluded from churn claims.
- Learning Objective: Avoid overclaiming comparability.
- Definition of Done: The seed or QA note clearly distinguishes stable vs unresolved mappings.
- Deliverables: `dbt/philly_dw/seeds/zoning_code_crosswalk.csv (updated), docs/zoning_comparability_plan.md (updated)`

---

**Task 24.5 — Update the claim-boundary docs**
- Description: Update the comparability plan and disclaimer language based on what the real crosswalk work revealed.
- Learning Objective: Keep analytical claims bounded by actual evidence.
- Definition of Done: The project docs reflect the real mapping limitations discovered in implementation.
- Deliverables: `docs/zoning_comparability_plan.md, docs/policies/disclaimer_library.md`

---

### Day 25 — Zoning composition and churn marts

---

**Task 25.1 — Build `fct_district_year_zoning_composition`**
- Description: Intersect zoning polygons with district boundaries and compute the year-level district zoning composition fact. Each row is one district × year × zoning code, with area in the projected CRS and `vocab_stable` flag joined from the crosswalk seed.
- Learning Objective: Implement the core area-based zoning rollup promised in Month 1.
- Definition of Done: (1) All 5 vintages are present in the output. (2) Every row has a non-null `vocab_stable` flag. (3) For each district × year combination, the sum of zoning polygon areas reconciles with `dim_district.land_area_sqmi` within a documented tolerance (state the tolerance explicitly). (4) Any gap between zoning coverage and district area is flagged, not silently dropped.
- Deliverables: `dbt/philly_dw/models/marts/zoning/fct_district_year_zoning_composition.sql, dbt/philly_dw/models/marts/zoning/fct_district_year_zoning_composition.yml`
- Reading: D10, D11, D23

---

**Task 25.2 — Build the zoning composition metric model**
- Description: Create the analyst-facing zoning composition mart/model from the fact table.
- Learning Objective: Separate the fact from the specific reporting-friendly rollup.
- Definition of Done: The model builds and supports the composition metric spec.
- Deliverables: `dbt/philly_dw/models/marts/zoning/mart_zoning_composition_by_year.sql`

---

**Task 25.3 — Build the YoY churn model**
- Description: Build the year-over-year churn model using only the code mappings you judge safe enough to compare.
- Learning Objective: Turn comparability policy into executable filtering logic.
- Definition of Done: The churn model builds and explicitly excludes or flags unresolved mappings.
- Deliverables: `dbt/philly_dw/models/marts/zoning/mart_zoning_yoy_churn.sql`

---

**Task 25.4 — Add zoning tests**
- Description: Add tests for year coverage, valid mapping flags, and basic share sanity checks.
- Learning Objective: Make the zoning marts self-checking.
- Definition of Done: The zoning marts have at least the core integrity tests passing.
- Deliverables: `dbt/philly_dw/models/marts/zoning/zoning_marts.yml`
- Reading: D19

---

**Task 25.5 — Create one zoning sanity view in Metabase**
- Description: Expose at least one zoning mart in Metabase and sanity-check its output.
- Learning Objective: Pressure-test the usability of the zoning layer.
- Definition of Done: One saved question exists and matches warehouse expectations.
- Deliverables: `assets/screenshots/metabase_zoning_sanity.png OR docs/runbooks/metabase_zoning_sanity.md`
- Reading: D27, V2

---

### Day 26 — Build `dim_zoning` and connect zoning to Metabase

---

**Task 26.1 — Build `dim_zoning`**
- Description: Build the zoning dimension from the crosswalk seed and staging layer. Each row represents one canonical zoning code with its descriptive attributes, `vocab_stable` flag, and cross-vintage mapping status. This is the dimension that `fct_district_year_zoning_composition` will join to.
- Learning Objective: Understand that a fact table’s zoning code column is not self-describing — the dimension is what gives it meaning, comparability, and groupability for analysts.
- Definition of Done: `dim_zoning` builds with one row per canonical code. The `vocab_stable` flag is non-null for every row. Foreign key relationship to `fct_district_year_zoning_composition` is declared in dbt YAML and passes the test.
- Deliverables: `dbt/philly_dw/models/marts/dimensions/dim_zoning.sql, dbt/philly_dw/models/marts/dimensions/dim_zoning.yml`
- Reading: B1, D23

---

**Task 26.2 — Add zoning relationship tests**
- Description: Add dbt tests for uniqueness on `dim_zoning`, not-null on key fields, and the FK relationship between the composition fact and the zoning dimension.
- Learning Objective: Make the zoning dimensional structure executable, not just documented.
- Definition of Done: Tests pass. The composition fact cannot reference a zoning code that doesn’t exist in `dim_zoning`.
- Deliverables: `dbt/philly_dw/models/marts/dimensions/dim_zoning.yml (updated), dbt/philly_dw/models/marts/zoning/fct_district_year_zoning_composition.yml (updated)`
- Reading: D19

---

**Task 26.3 — Expose zoning marts in Metabase**
- Description: Verify that `dim_zoning`, `fct_district_year_zoning_composition`, and the composition/churn marts are all queryable in Metabase. Note any field-type or visibility issues.
- Learning Objective: Use the BI layer as a sanity check on the zoning dimensional design.
- Definition of Done: All three objects are queryable. Any usability issues are logged to the Metabase backlog.
- Deliverables: `docs/runbooks/metabase_zoning_connection.md, docs/backlog/metabase_modeling_backlog.md (updated)`
- Reading: D26, D27

---

**Task 26.4 — Create 2–3 Metabase zoning questions**
- Description: Build basic sanity questions: composition shares for one district, YoY churn for one district, and a comparison across districts for one year.
- Learning Objective: Pressure-test whether the zoning mart design actually supports the product use cases it promised.
- Definition of Done: 2–3 saved questions exist. The output is explainable to a reviewer.
- Deliverables: `assets/screenshots/metabase_zoning_questions.png OR docs/runbooks/metabase_zoning_questions.md`
- Reading: D27, V2

---

**Task 26.5 — Update zoning documentation**
- Description: Add model and column descriptions to all zoning mart and dimension YAML. Update the docs index with any new documents created during zoning build.
- Learning Objective: Keep documentation live during implementation, not as a post-build chore.
- Definition of Done: All zoning models appear in `dbt docs generate` output with descriptions. No new docs are missing from the docs index.
- Deliverables: `dbt/philly_dw/models/marts/zoning/zoning_marts.yml (updated), docs/README.md (updated)`
- Reading: D20

---

### Day 27 — Zoning hardening and Week 4 closeout

---

**Task 27.1 — Run a full rebuild of the zoning slice**
- Description: From a clean local state, rebuild raw → staging → intermediate → fact → marts for the full zoning slice.
- Learning Objective: Prove the zoning slice is reproducible, not just successful when it was first built.
- Definition of Done: The rebuild completes using only documented steps. A timing note exists.
- Deliverables: `docs/runbooks/zoning_slice_rebuild.md`

---

**Task 27.2 — Validate composition area reconciliation**
- Description: Run the area reconciliation check defined in Task 25.1’s DoD: for each district × year, confirm that summed zoning polygon areas match `land_area_sqmi` within the documented tolerance. Record the actual gap distribution.
- Learning Objective: Make the tolerance a measured number, not a claim.
- Definition of Done: A QA note exists with the actual area reconciliation results. Any district × year with a gap exceeding tolerance is named and disposition is documented.
- Deliverables: `docs/qa/zoning_area_reconciliation.md`

---

**Task 27.3 — Update the limitations register for zoning**
- Description: Add zoning-specific caveats: vocabulary instability, crosswalk ambiguities, area reconciliation gaps, and any vintage-level access issues discovered.
- Learning Objective: Keep risk tracking alive during build.
- Definition of Done: The limitations register has at least 3 new concrete zoning entries.
- Deliverables: `docs/limitations_register.md (updated)`

---

**Task 27.4 — Write the zoning vertical-slice recap**
- Description: Summarize what works, what is fragile, and what patterns the ACS week should reuse.
- Learning Objective: Extract the transferable lessons before starting ACS.
- Definition of Done: The recap is specific enough to guide Week 5 spatial work.
- Deliverables: `docs/recaps/week4_zoning_slice.md`

---

**Task 27.5 — Open the ACS blocker list**
- Description: List any known blockers for ACS: Census API key access, tract geometry source, MOE handling decision, bridge table edge cases, or histogram aggregation design.
- Learning Objective: Begin Week 5 with eyes open.
- Definition of Done: The blocker list is written before any ACS code starts.
- Deliverables: `docs/backlog/acs_blockers.md`

---

## WEEK 5 — ACS + Dashboard Assembly + Month Closeout

### Day 28 — ACS extraction strategy and raw ingestion

---

**Task 28.1 — Finalize the ACS variable list and API setup**
- Description: Confirm the exact ACS variables you will pull for the MVP (income, tenure, and any others from the Month 1 metric spec) and configure the Census API key path in `.env.example`. Document the variable codes with plain-English labels.
- Learning Objective: Keep ACS extraction intentionally scoped. The Census API returns hundreds of variables — you only want the ones your metric specs actually need.
- Definition of Done: The variable list is recorded with Census variable codes and human-readable descriptions. The API key path is in `.env.example`. The years to pull are stated.
- Deliverables: `docs/runbooks/acs_extract_plan.md, .env.example (updated)`
- Reading: D28, D29

---

**Task 28.2 — Build the ACS extractor**
- Description: Create the Python extraction module for the chosen ACS variables and years. Handle the Census API’s row limits and pagination if needed.
- Learning Objective: Turn ACS access into a repeatable extract rather than a browser export habit.
- Definition of Done: One command retrieves the chosen ACS estimates for the target geography and years and saves them to a raw file.
- Deliverables: `src/philly_dw/ingest/acs_5yr.py`
- Reading: D28, D29

---

**Task 28.3 — Land raw ACS estimates and MOE columns**
- Description: Load the extracted ACS estimates and their MOEs into the raw schema. Both the estimate and margin-of-error columns must land together — do not strip MOEs at ingestion.
- Learning Objective: Preserve statistical uncertainty at the raw layer so it can be carried forward or explicitly dropped with a documented rationale.
- Definition of Done: Raw ACS table exists with estimate and MOE column pairs. Row count matches expected number of tracts × years.
- Deliverables: `data/raw/acs_5yr/<snapshot_date>/..., raw.acs_tract_estimates table`
- Reading: D28, D29

---

**Task 28.4 — Land tract geometry for district overlap**
- Description: Obtain and land the Philadelphia census tract boundary geometry required for the district overlap bridge. This is a separate step from the ACS tabular estimates.
- Learning Objective: Recognize that ACS estimates are tabular — spatial bridge logic requires a separate geometry dataset for the tracts.
- Definition of Done: Tract geometry is available in the DB as a PostGIS geometry table. Geometry is in EPSG:4326 or your project CRS.
- Deliverables: `data/raw/census_tracts/<snapshot_date>/... OR raw.census_tract_boundaries`
- Reading: D10, D14

---

**Task 28.5 — Declare ACS raw sources in dbt**
- Description: Wire the raw ACS estimates and tract geometry tables into dbt as sources.
- Learning Objective: Keep lineage explicit from the first ACS model.
- Definition of Done: dbt recognizes the raw ACS sources and `dbt source freshness` can run against them.
- Deliverables: `dbt/philly_dw/models/sources/src_acs.yml (updated)`
- Reading: D18

---

### Day 29 — ACS staging and tract geometry staging

---

**Task 29.1 — Build `stg_acs_tract_estimates`**
- Description: Standardize ACS column names, cast to correct types, and retain estimate and MOE column pairs. Do not drop MOEs here.
- Learning Objective: Use staging to normalize without business logic. MOE handling is a documented policy decision, not a silent staging drop.
- Definition of Done: The staging model builds with estimate and MOE pairs. Column names are consistent and human-readable.
- Deliverables: `dbt/philly_dw/models/staging/acs/stg_acs_tract_estimates.sql, dbt/philly_dw/models/staging/acs/stg_acs_tract_estimates.yml`
- Reading: D22, D28

---

**Task 29.2 — Build `stg_census_tract_boundaries`**
- Description: Standardize the tract geometry staging model: CRS validation, geometry validity check, and consistent column names.
- Learning Objective: Apply the same spatial QA discipline from the district and zoning slices to the ACS geometry layer.
- Definition of Done: The staging model builds. SRID is validated. Invalid geometry count is recorded.
- Deliverables: `dbt/philly_dw/models/staging/acs/stg_census_tract_boundaries.sql, dbt/philly_dw/models/staging/acs/stg_census_tract_boundaries.yml`
- Reading: D10, D12, D22

---

**Task 29.3 — Add ACS staging tests**
- Description: Add dbt tests for the ACS staging layer: uniqueness on tract × year, not-null on key estimate columns, and expected year coverage.
- Learning Objective: Encode what “clean enough for downstream use” means for ACS tabular data.
- Definition of Done: Staging tests pass. Year coverage matches the extract plan.
- Deliverables: `dbt/philly_dw/models/staging/acs/stg_acs_tract_estimates.yml (updated)`
- Reading: D19

---

**Task 29.4 — Document the MOE handling policy**
- Description: Decide and document how MOEs will be handled in the mart layer: carried forward as columns, summarized to a reliability flag, or dropped with explicit rationale. Update `acs_usage_policy.md`.
- Learning Objective: Treat MOE handling as a deliberate design choice, not an afterthought. Dropping MOEs silently is an analytical integrity risk.
- Definition of Done: `acs_usage_policy.md` has a named MOE policy with rationale. The downstream mart tasks will implement this policy.
- Deliverables: `docs/policies/acs_usage_policy.md (updated)`
- Reading: D28, D29

---

**Task 29.5 — Validate tract geometry against district geometry**
- Description: Check that the tract boundary geometries have reasonable overlap with the planning district geometries before building the bridge. Catch CRS mismatches and extent surprises here, not mid-bridge.
- Learning Objective: Pre-validate spatial inputs before an expensive intersection operation.
- Definition of Done: A QA note records the CRS of both layers, total tract count, and any obvious geometry issues.
- Deliverables: `docs/qa/acs_tract_geometry_qa.md`
- Reading: D10, D11

---

### Day 30 — Bridge table and ACS fact

---

**Task 30.1 — Build `bridge_tract_district_overlap`**
- Description: Intersect census tract boundaries with planning district boundaries to produce weighted overlap fractions. Each row is one tract × district pair with an `overlap_weight` = (intersection area ÷ tract area). Apply a sliver threshold to drop negligible overlaps; document the threshold.
- Learning Objective: Implement a bridge table that preserves the tract-grain ACS design while enabling district context. Understand that the weight must sum to approximately 1.0 per tract, not per district.
- Definition of Done: (1) Bridge builds successfully. (2) For each tract, overlap weights sum to between 0.98 and 1.02 (document the tolerance). (3) Sliver threshold is recorded in a comment or YAML. (4) A spot-check QA note confirms the weight distribution looks reasonable.
- Deliverables: `dbt/philly_dw/models/marts/acs/bridge_tract_district_overlap.sql, dbt/philly_dw/models/marts/acs/bridge_tract_district_overlap.yml`
- Reading: B1, D10, D11, D23

---

**Task 30.2 — Add bridge table QA tests**
- Description: Add dbt tests to verify the weight-sum invariant and FK integrity between bridge, tract geometry, and district tables.
- Learning Objective: Make the most fragile object in the warehouse self-checking.
- Definition of Done: Tests pass and the weight-sum test has an explicit tolerance defined in the test parameters.
- Deliverables: `dbt/philly_dw/models/marts/acs/bridge_tract_district_overlap.yml (updated)`
- Reading: D19

---

**Task 30.3 — Build `fct_tract_acs`**
- Description: Build the ACS fact table at tract grain using the standardized staging estimates. Include the MOE columns according to the policy from Task 29.4. Join to `dim_date` for year key.
- Learning Objective: Keep ACS at its intended grain instead of forcing a fake district-level aggregation. The fact table is tract-level — district context comes via the bridge.
- Definition of Done: `fct_tract_acs` builds, matches the selected variable list, and includes MOE handling per policy. Row count = expected tracts × years.
- Deliverables: `dbt/philly_dw/models/marts/acs/fct_tract_acs.sql, dbt/philly_dw/models/marts/acs/fct_tract_acs.yml`
- Reading: D23, D28, D29

---

**Task 30.4 — Build `agg_district_acs_attributes_hist`**
- Description: Build the pre-aggregated district-level ACS histogram table using the bridge weights. This is the table that Metabase will actually query for the “district demographic context” panels — not `fct_tract_acs` directly. Each row is one district × year × ACS attribute with the weighted estimate.
- Learning Objective: Understand the design pattern: the fact table preserves tract-grain correctness, and the pre-aggregation table makes the BI layer fast and interpretable. Both are needed.
- Definition of Done: The aggregate table builds. Weighted estimates exist for each district × year. The relationship to `fct_tract_acs` via the bridge is implemented and documented.
- Deliverables: `dbt/philly_dw/models/marts/acs/agg_district_acs_attributes_hist.sql, dbt/philly_dw/models/marts/acs/agg_district_acs_attributes_hist.yml`
- Reading: B1, D23

---

**Task 30.5 — Build ACS proxy metric models**
- Description: Build the income and tenure proxy mart models needed for the MVP from `agg_district_acs_attributes_hist`.
- Learning Objective: Translate the Month 1 metric specs into warehouse objects without violating the ACS grain rules.
- Definition of Done: The proxy models build and retain the tract-level caveat language in documentation.
- Deliverables: `dbt/philly_dw/models/marts/acs/mart_acs_income_proxy.sql, dbt/philly_dw/models/marts/acs/mart_acs_tenure_proxy.sql`

---

### Day 31 — ACS documentation, caveats, and Metabase

---

**Task 31.1 — Add ACS caveat documentation**
- Description: Add model and column descriptions plus the standard ACS disclaimers to all ACS mart YAML. The proxy models must explicitly state the tract-to-district weighting methodology and its limitations.
- Learning Objective: Preserve statistical caveats through implementation. A district-level income estimate produced by areal interpolation is a different thing from a direct survey estimate — document that difference.
- Definition of Done: ACS marts and proxy models appear in dbt docs with descriptions and explicit usage caveats.
- Deliverables: `dbt/philly_dw/models/marts/acs/acs_marts.yml, docs/policies/acs_usage_policy.md (updated)`
- Reading: D20, D28, D29

---

**Task 31.2 — Connect ACS marts to Metabase**
- Description: Verify that `agg_district_acs_attributes_hist`, `mart_acs_income_proxy`, and `mart_acs_tenure_proxy` are all queryable in Metabase. Log any visibility or type issues.
- Learning Objective: Close the loop from tract-level ACS data to a usable analyst-facing surface.
- Definition of Done: All three objects are queryable in Metabase. Issues are logged.
- Deliverables: `docs/runbooks/metabase_acs_connection.md`
- Reading: D26, D27

---

**Task 31.3 — Create ACS Metabase sanity questions**
- Description: Build 2–3 basic Metabase questions: income proxy by district, tenure mix by district, and one year-over-year comparison. Confirm the numbers are plausible against publicly known Philadelphia demographics.
- Learning Objective: Use sanity-checking against external reference data as part of the QA workflow, not just automated tests.
- Definition of Done: 2–3 saved questions exist. The district income and tenure distributions are broadly consistent with publicly available Philadelphia ACS summaries.
- Deliverables: `assets/screenshots/metabase_acs_questions.png OR docs/runbooks/metabase_acs_questions.md`
- Reading: D27, V2

---

**Task 31.4 — Update the ACS limitations register**
- Description: Add ACS-specific caveats: areal interpolation assumptions, MOE aggregation limitations, and any years where data quality was suspect.
- Learning Objective: Carry forward the statistical uncertainty of ACS into the project’s public-facing caveats.
- Definition of Done: The limitations register has at least 3 new ACS-specific entries with concrete wording.
- Deliverables: `docs/limitations_register.md (updated)`

---

**Task 31.5 — Write the ACS vertical-slice recap**
- Description: Summarize what works, what remains fragile, and what the bridge table actually cost in complexity vs. alternatives.
- Learning Objective: Evaluate the Month 1 bridge design against implementation reality.
- Definition of Done: The recap is honest about whether the bridge design was worth it for the MVP scope.
- Deliverables: `docs/recaps/week5_acs_slice.md`

---

### Day 32 — Dashboard assembly

---

**Task 32.1 — Build the district brief dashboard**
- Description: Assemble the first full Metabase dashboard using the implemented marts. The dashboard should cover at minimum: district selector, permit activity panel (monthly counts or density), zoning composition panel, and ACS demographic context panel.
- Learning Objective: Turn warehouse outputs into a usable product slice.
- Definition of Done: A reviewer can open one dashboard and see district, permits, zoning composition, and ACS context together.
- Deliverables: `assets/screenshots/metabase_district_brief_dashboard.png OR docs/product/month2_dashboard_build.md`
- Reading: D27, V2, V6

---

**Task 32.2 — Build the compare-district question**
- Description: Create one compare-district analytical question that puts at least two districts side-by-side on a shared metric (permit density, zoning residential share, or income proxy).
- Learning Objective: Exercise the model layer with a multi-district use case.
- Definition of Done: One compare-style question exists and is understandable without explanation.
- Deliverables: `assets/screenshots/metabase_compare_districts.png OR docs/product/month2_compare_view.md`

---

**Task 32.3 — Capture the product polish backlog**
- Description: Record dashboard and model UX issues that should not block Month 2 completion but should feed Month 3.
- Learning Objective: Separate MVP completion from polish backlog.
- Definition of Done: A backlog note with prioritized non-blocking improvements exists.
- Deliverables: `docs/backlog/product_polish_backlog.md`

---

**Task 32.4 — Update the docs index**
- Description: Add all new documents created in Weeks 4 and 5 to the docs index.
- Learning Objective: Keep documentation discoverable while the repo is growing fast.
- Definition of Done: No document created in Weeks 4–5 is missing from the docs index.
- Deliverables: `docs/README.md (updated)`

---

### Day 33 — Final hardening and month closeout

---

**Task 33.1 — Run the full project from clean start**
- Description: From a clean local state, run the complete Month 2 workflow: boot stack, load all 4 datasets, build all dbt models, run all tests, and open the BI layer.
- Learning Objective: Prove the repo works as a system, not just as isolated successful days.
- Definition of Done: The end-to-end run works using only documented steps. A timing note exists.
- Deliverables: `docs/runbooks/month2_full_rebuild.md`

---

**Task 33.2 — Run all automated checks**
- Description: Run pytest, `dbt build`, `dbt docs generate`, and any lint/pre-commit checks adopted during the month.
- Learning Objective: Make “done” mean verified, not just “I think it works.”
- Definition of Done: The core automated checks pass and the results are recorded.
- Deliverables: `docs/runbooks/month2_validation_results.md`

---

**Task 33.3 — Write the Month 2 recap**
- Description: Write the month-end recap describing what is implemented, what is partially implemented, and what was deliberately deferred.
- Learning Objective: Build the habit of honest technical retrospectives.
- Definition of Done: The recap clearly states what a reviewer can run and what remains open.
- Deliverables: `docs/month2_recap.md`

---

**Task 33.4 — Update the README for implemented architecture**
- Description: Refresh the README to show the real Month 2 architecture, setup steps, and implemented MVP surfaces.
- Learning Objective: Keep the root repo narrative synchronized with the codebase.
- Definition of Done: The README no longer reads like a design-only repo.
- Deliverables: `README.md`
- Reading: D20, D26

---

**Task 33.5 — Create the Month 3 backlog**
- Description: Rank the next issues by impact and dependency: full historical backfill, lifecycle snapshot, stronger tests, dashboard polish, performance, packaging, deployment, or orchestration.
- Learning Objective: End the month with a deliberate next step instead of momentum loss.
- Definition of Done: A prioritized backlog exists with no vague “keep improving” filler items.
- Deliverables: `docs/backlog/month3_backlog.md`
- Reading: B2, B7

---

## End-of-month review questions

Use these before declaring Month 2 complete:

1. Can a clean machine boot the stack from your docs alone?
2. Are all 4 MVP datasets actually represented in code and warehouse objects, not just in notes?
3. Do the dbt models and the Month 1 metric specs still agree?
4. Do you have at least one dashboard or saved-question product surface that uses real marts?
5. Are the main uncertainties published as caveats, limitations, or backlog items instead of hidden?
6. Does `dim_zoning` exist as a first-class object with tests, not just zoning codes embedded in the fact?
7. Does the bridge table have a validated weight-sum invariant, not just a build that succeeds?
8. Can you trace every mart row count back to a raw source count with documented exclusions?

If the answer to any of these is “not really,” Month 2 is not fully complete yet.
