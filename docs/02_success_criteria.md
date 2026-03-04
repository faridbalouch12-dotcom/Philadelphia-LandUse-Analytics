# Month 1 Success Criteria

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This document defines the 8 pass/fail checks that determine whether Month 1 is complete and the project is ready to proceed to Month 2 implementation. Each check references a specific artifact and requirement. All 8 must pass.

---

## Pass/Fail Checks

### Check 1 — All Tasks Complete

**Artifact:** `.claude/progress.md`

**Requirement:** All tasks marked `[x]` with PASS verdicts. No incomplete `[ ]` items remain.

**Fail if:** Any task is missing a PASS verdict or marked incomplete.

---

### Check 2 — Grain Spec Is Implementable

**Artifact:** `docs/modeling/grain_spec.md`

**Requirement:** The spec contains one grain statement per table. A reviewer can write the CREATE TABLE statement for `permits_fact` from the spec alone, including exact column names, data types, primary key (surrogate + natural), and foreign keys to dimensions.

**Fail if:** Grain statement is vague, no example key is shown, or alternatives are not documented with rationale.

---

### Check 3 — Table Inventory Is Complete

**Artifact:** `docs/modeling/table_inventory.md`

**Requirement:** Every table is listed with its type (feature or rollup), grain, and intended consumers. Each dimension includes SCD strategy with justification.

**Fail if:** Any table is missing, SCD strategy is unspecified, or rationale is absent.

---

### Check 4 — Metric Definitions Are Queryable

**Artifact:** `docs/metrics/` (one file per metric)

**Requirement:** For each metric, a reviewer can write the complete SQL query — including all joins, the correct formula, and aggregation grain — from the definition alone. Numerator, denominator, filters, and caveats are all specified.

**Fail if:** Any metric definition is ambiguous about grain, formula components, or required joins.

---

### Check 5 — ERD Is Renderable and Complete

**Artifact:** `docs/diagrams/erd.mmd`

**Requirement:** The diagram renders in GitHub and shows all fact and dimension tables with primary keys, foreign keys, cardinality (1:N), and grain annotated on each fact table.

**Fail if:** Any table is missing, PKs/FKs are unlabeled, cardinality is absent, or grain is not annotated.

---

### Check 6 — Source Catalog Covers All 4 MVP Datasets

**Artifact:** `docs/source_catalog/` (one entry per dataset)

**Requirement:** A catalog entry exists for each of the 4 MVP datasets: planning districts, L&I permits, zoning base districts, and ACS context. Each entry includes access URL, key fields, update cadence, and top risks.

**Fail if:** Any dataset is missing an entry, or any entry omits access URL, key fields, cadence, or risks.

---

### Check 7 — Dataflow Diagram Is Complete

**Artifact:** `docs/diagrams/dataflow.mmd`

**Requirement:** The diagram renders in GitHub and shows all 4 datasets flowing through the pipeline. Feature and rollup layers are visually separated. Grains are labeled at each stage.

**Fail if:** Any dataset is missing, feature vs. rollup layers are not distinguished, or grains are unlabeled.

---

### Check 8 — Policies Are In Place

**Artifact:** `docs/policies/` (ACS usage policy + land area denominator policy)

**Requirement:** `acs_usage_policy.md` defines what ACS is and is not used for, and includes a standard disclaimer sentence for dashboards and docs. `land_area_denominator_policy.md` states land-only area, units (sq miles), and how edge cases are handled.

**Fail if:** Either policy file is missing, or the ACS policy has no standard disclaimer sentence, or the land area policy does not address edge cases.

---

## Scoring

| Result | Meaning |
|--------|---------|
| 8/8 PASS | Month 1 complete — proceed to Month 2 |
| 6–7/8 PASS | Close — address failing checks before proceeding |
| < 6/8 PASS | Not ready — significant gaps remain |

---

## Links

**Related Documents:**
- Scope memo: [`docs/00_scope_memo.md`](./00_scope_memo.md)
- Problem statement: [`docs/01_problem_statement.md`](./01_problem_statement.md)
- Docs index: [`docs/README.md`](./README.md)

---

## Change Log

| Date | Change Description | Author |
|------|--------------------|--------|
| 2026-03-03 | Initial draft | Farid |
