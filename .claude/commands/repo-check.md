# /repo-check — Repo Consistency Check

Scan the repo for infrastructure drift, spec-code mismatches, pattern violations, and documentation gaps. Reports findings without auto-fixing.

Usage: `/repo-check`

---

## Step 1: Scan the codebase

Read the following files/directories:

**Python layer:**
- All `.py` files in `src/philly_dw/` (recursively) — extract `import` and `from ... import` statements
- `pyproject.toml` — extract `dependencies` and `dev` optional dependencies
- All `.py` files in `src/philly_dw/ingest/` — list module names (excluding `__init__.py` and `utils.py`)

**Environment layer:**
- `.env.example` — extract all variable names
- All `os.getenv()` and `os.environ[]` calls in `src/`
- All `env_var()` calls in `dbt/` YAML/SQL files

**dbt layer:**
- All `dbt/philly_dw/models/sources/src_*.yml` — extract declared table names
- All `dbt/philly_dw/models/staging/**/*.sql` — list implemented staging models
- All `dbt/philly_dw/models/staging/**/*.yml` — list implemented test files
- All `dbt/philly_dw/models/marts/**/*.sql` — list implemented mart models
- All `dbt/philly_dw/data-tests/*.sql` — list data tests

**Config layer:**
- `Makefile` — extract `ingest-*` target names and the Python module paths they invoke
- `docker/postgres/init/*.sql` — extract schema and table definitions
- `dbt/philly_dw/dbt_project.yml` — extract schema/materialization config

**Docs layer:**
- All `.md` files under `docs/` (recursively)
- `docs/README.md` — extract all linked file paths

**Specs layer:**
- `docs/modeling/column_contracts.md` — extract column names/types per table
- `docs/modeling/grain_spec.md` — extract PK definitions per table
- `docs/metrics/*.md` — extract source table and column references

---

## Step 2: Run the 12 checks

### A. Infrastructure Consistency

**A1 — Python Dependencies**
For each third-party `import` in `src/` and `tests/`, verify the package appears in `pyproject.toml` `dependencies` or `dev` dependencies.
- Known mappings: `dotenv` → `python-dotenv`, `sqlalchemy` may be transitive from `dbt-postgres`
- Flag only top-level missing packages, not transitive deps
- Also flag: production imports listed under `dev` deps only (e.g., `python-dotenv` used in `src/` but only in `[project.optional-dependencies] dev`)

**A2 — Environment Variables**
- Collect all variable names from `os.getenv()` in `src/` and `env_var()` in `dbt/`
- Collect all variable names defined in `.env.example`
- Report: code-referenced variables not in `.env.example`, and `.env.example` variables not referenced by any code

**A3 — Makefile Targets**
- Extract all `ingest-*` target names and the Python module paths they invoke
- Verify each referenced module exists in the filesystem
- Check for ingest modules in `src/philly_dw/ingest/` that have no corresponding Makefile target
- Flag inconsistent naming patterns (e.g., `philly_dw.ingest.planning_districts` vs `philly_dw.ingest_permits`)

**A4 — Docker Init Scripts**
- Extract schema names from `CREATE SCHEMA` in `docker/postgres/init/01_schemas.sql`
- Cross-reference against schemas in `dbt_project.yml` config and Python code
- Flag schemas referenced by code but not created in init scripts

**A5 — dbt Source Declarations**
- For each Python ingest module, identify the raw table it creates (from `TABLE_NAME` constant or `to_postgis(name=...)`)
- Check that a matching `src_*.yml` declares that table
- Check reverse: declared source tables with no corresponding ingest module (may be placeholder — flag as ADVISORY)

### B. Spec ↔ Code Consistency

**B1 — Column Contracts vs dbt Models**
- For each table in `column_contracts.md` (SC1–SC6), check if a corresponding dbt model exists
- If the model exists: compare column names in the contract to columns in the model's SELECT or YAML
- If the model does not exist: report `NOT YET IMPLEMENTED` (informational, not drift)
- Flag type mismatches only when clearly wrong (e.g., contract says VARCHAR, model outputs integer)

**B2 — Grain Validation**
- For each grain statement in `grain_spec.md`, check if the corresponding dbt model has a `unique` test on the declared PK
- If the model exists but has no uniqueness test on the PK: DRIFT
- If the model does not exist: `NOT YET IMPLEMENTED`

**B3 — Metric Spec Table References**
- For each metric spec in `docs/metrics/`, extract the source table and column references
- Check that each referenced table exists as a dbt model (or source)
- Check that each referenced column appears in the model's YAML or SQL
- If the mart model doesn't exist yet: `NOT YET IMPLEMENTED`

### C. Pattern Consistency

**C1 — Pipeline Completeness per Dataset**
For each of the 4 MVP datasets (planning_districts, li_permits, zoning, acs), check which artifacts exist:

| Artifact | Expected location |
|----------|------------------|
| Python extractor | `src/philly_dw/ingest/{dataset}.py` |
| dbt source YAML | `dbt/.../sources/src_{domain}.yml` |
| Staging model | `dbt/.../staging/{domain}/stg_{dataset}.sql` |
| Staging tests | `dbt/.../staging/{domain}/stg_{dataset}.yml` |
| Raw QA doc | `docs/qa/{dataset}_raw_qa.md` |
| Ingest runbook | `docs/runbooks/{dataset}_raw_ingest.md` |
| Makefile target | `ingest-{short_name}` in Makefile |
| pytest validators | `tests/test_{dataset}_raw.py` |

Report a per-dataset table showing present/missing for each artifact.

**C2 — Naming Convention Consistency**
- Scan all implemented dbt models for shared concept columns (`district_id`, `date_key`, `zoning_code`, `geoid_tract`)
- Flag any model that uses a variant name for the same concept (e.g., `dist_id` instead of `district_id`)
- This is ADVISORY — naming drift is worth knowing but may have legitimate reasons

### D. Documentation & Policy

**D1 — Docs Index Completeness**
- List all `.md` files under `docs/` (excluding `docs/README.md`)
- Parse `docs/README.md` for all linked file paths
- Report `.md` files not in the index
- If drift found, suggest running `/update-docs`

**D2 — Write Access Policy**
- Check dbt model schema assignments (from `dbt_project.yml` config and any model-level `{{ config() }}` overrides)
- Compare against `write_access_by_layer.md` rules:
  - `stg_*` → staging only
  - `int_*` → intermediate only
  - `dim_*/fct_*/bridge_*/geo_*` → marts only
  - `agg_*` → analytics only
- Flag any model whose prefix doesn't match its schema assignment

---

## Step 3: Report

Present a structured report:

```
### Repo Consistency Report

**Checks passed:** X/12
**Drift found:** Y   |   Advisory: Z

--- A. Infrastructure ---
A1. Python Dependencies: OK / DRIFT
  - [specifics]
A2. Environment Variables: OK / DRIFT
  - [specifics]
A3. Makefile Targets: OK / DRIFT
  - [specifics]
A4. Docker Init Scripts: OK / DRIFT
  - [specifics]
A5. dbt Source Declarations: OK / DRIFT
  - [specifics]

--- B. Spec ↔ Code ---
B1. Column Contracts: OK / DRIFT / NOT YET IMPLEMENTED
  - [specifics per table]
B2. Grain Validation: OK / DRIFT / NOT YET IMPLEMENTED
  - [specifics per table]
B3. Metric Spec References: OK / DRIFT / NOT YET IMPLEMENTED
  - [specifics per metric]

--- C. Pattern Consistency ---
C1. Pipeline Completeness:
  | Dataset | Extractor | Source YAML | Staging | Tests | QA Doc | Runbook | Makefile | pytest |
  |---------|-----------|-------------|---------|-------|--------|---------|---------|--------|
  | planning_districts | ✓ | ✓ | ✓ | ... | ... | ... | ... | ... |
  | li_permits | ... | ... | ... | ... | ... | ... | ... | ... |
  | zoning | ... | ... | ... | ... | ... | ... | ... | ... |
  | acs | ... | ... | ... | ... | ... | ... | ... | ... |

C2. Naming Conventions: OK / ADVISORY
  - [specifics]

--- D. Documentation & Policy ---
D1. Docs Index: OK / DRIFT
  - [specifics]
D2. Write Access Policy: OK / ADVISORY
  - [specifics]
```

---

## Step 4: Suggest fixes

For each DRIFT finding, suggest the specific fix (which file, what to add/change). Do not apply fixes automatically — present them for the learner to act on.

---

## Guardrails

- Report only — do NOT auto-fix anything
- Do NOT block work — present findings and let the learner decide priority
- `NOT YET IMPLEMENTED` is informational, not an error — specs exist for tables that haven't been built yet
- ADVISORY findings are flagged but don't block work
- C1 pipeline completeness doubles as the "what do I need to build next" reference for new vertical slices
- Do NOT re-check architectural decisions — that's `/reconcile`'s job
