# jaffle-shop: Reference Patterns — Notes

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Source:** [R2]

---

## Purpose

These notes extract 5 structural patterns from the dbt-labs/jaffle-shop reference dbt project and document how each applies to the Philadelphia data warehouse project.

---

## 5 Patterns + Application

### Pattern 1: `staging/` + `marts/` Folder Separation

**What it is:** The `models/` directory is split into two subdirectories: `staging/` contains `stg_*` models that clean and type raw source data, and `marts/` contains `fct_*` and `dim_*` models that aggregate and shape data for analysis. The two layers are physically separated, not mixed in a flat folder.

**Why it matters:** Keeping staging and marts separate makes the data flow legible at a glance. Anyone navigating the repo immediately understands what layer they're in and what transformation purpose the models serve.

**How I'll apply it:** The `dbt/models/` directory will follow this exact structure: `dbt/models/staging/` for `stg_permits`, `stg_planning_districts`, `stg_zoning_base_districts`, `stg_acs_context`; and `dbt/models/marts/` for `fct_district_year_metrics`, `dim_district`, `dim_time`. This is set up when the dbt project is scaffolded in Month 2.

---

### Pattern 2: Co-located `.yml` Files for Documentation and Schema Tests

**What it is:** Each `.sql` model file in jaffle-shop has a corresponding `.yml` file in the same folder. The `.yml` file declares the model's description, column-level documentation, and schema tests (e.g., `not_null`, `unique`, `relationships`) — all co-located with the SQL that builds the model.

**Why it matters:** Documentation and tests that live next to the code they describe are more likely to stay up to date. A separate `tests/` folder creates drift — when you update a model, you have to remember to update docs and tests in a different location.

**How I'll apply it:** Every dbt model in `staging/` and `marts/` will have a paired `.yml` file in the same directory, declaring at minimum: model description, grain (as a description field), and `not_null` + `unique` tests on primary keys. Relationship tests will be added for foreign key fields where applicable.

---

### Pattern 3: `.sqlfluff` for SQL Style Enforcement

**What it is:** A `.sqlfluff` config file at the repo root configures SQLFluff, a SQL linter that enforces consistent formatting rules across all `.sql` files — keyword casing, indentation, line length, and more. The equivalent of flake8/black for Python, applied to SQL.

**Why it matters:** Inconsistent SQL formatting makes models harder to read and review. Enforcing a standard from the start (before any SQL is written) means the codebase stays consistent as it grows, and code review focuses on logic rather than style.

**How I'll apply it:** A `.sqlfluff` config file will be added to the repo root before the first dbt model is written in Month 2 — the same way Google's Python style guide was adopted before any Python code was written. Configuration will enforce: uppercase SQL keywords, 4-space indentation, and consistent comma placement.

---

### Pattern 4: `macros/` for Reusable SQL Logic

**What it is:** A dedicated `macros/` folder holds reusable Jinja SQL functions — logic that would otherwise be copy-pasted across multiple models. Macros are defined once and called by name in any model that needs them.

**Why it matters:** Copy-pasted SQL logic creates maintenance debt — fixing a bug in the logic requires finding and updating every copy. Extracting repeated logic into a macro means one fix propagates everywhere.

**How I'll apply it:** `macros/` will not be populated in Month 1 (no SQL yet). In Month 2+, candidates for macros include: date truncation/parsing patterns used across multiple staging models, the land-area normalization formula used in multiple fact table metrics, and any permit status classification logic applied repeatedly.

---

### Pattern 5: `data-tests/` for Custom Domain-Specific Tests

**What it is:** A `data-tests/` folder (empty in jaffle-shop) holds custom dbt tests written as SQL queries. Unlike schema tests declared in `.yml` files (not_null, unique), custom tests encode domain-specific business rules as SQL — for example, "no row in this table should match this condition."

**Why it matters:** Schema tests check structural integrity. Custom tests check business logic that schema tests cannot — rules that require domain knowledge about what valid data looks like.

**How I'll apply it:** `data-tests/` will not be populated in Month 1. In Month 2+, candidates for custom tests include: no permit record should have an issue date outside the 5-year analysis window, no permit point geometry should fall outside Philadelphia's city boundary, and no district should have a land area of zero in the `dim_district` table.

---

## Links

**Related Notes:**
- cookiecutter-data-science patterns: [`ref_patterns_cookiecutter_ds.md`](./ref_patterns_cookiecutter_ds.md)
- Kimball grain notes: [`kimball_grain_notes.md`](./kimball_grain_notes.md)
- PostGIS spatial primer notes: [`postgis_spatial_primer_notes.md`](./postgis_spatial_primer_notes.md)

**Project Documents:**
- Docs folder: [`../docs/`](../docs/)

---

## References

- **[R2]** dbt Labs. "jaffle-shop." GitHub. https://github.com/dbt-labs/jaffle-shop

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-03 | Initial notes created | Farid  |
