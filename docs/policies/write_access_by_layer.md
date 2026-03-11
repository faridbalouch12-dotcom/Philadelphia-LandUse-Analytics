# Write access by layer policy

**Author:** Farid
**Created:** 2026-03-10
**Last Updated:** 2026-03-10
**Status:** Draft

## Purpose

This policy defines which pipeline component is the sole writer to each database schema. All other components treat every other schema as read-only. The goal is to prevent layer leakage — where a component accidentally writes to the wrong schema — before it starts.

This is a **convention enforced by code discipline**, not by Postgres-level role permissions (a single developer context). Each component's write scope is defined here and must not be exceeded.

---

## Core rule

> Each schema has exactly one writer. All other components are read-only consumers of that schema.

**Exception:** `analytics` is a dual-writer schema. See the `analytics` section below for the permitted exception and its conditions.

---

## Write access by schema

| Schema | Sole writer | All other components |
|--------|-------------|----------------------|
| `raw` | Python ingestion pipeline (`src/ingest/`) | Read-only |
| `staging` | dbt `stg_*` models | Read-only |
| `intermediate` | dbt `int_*` models | Read-only |
| `marts` | dbt `dim_*`, `fct_*`, `bridge_*`, `geo_*` models | Read-only |
| `analytics` | dbt `agg_*` models (default); Python pipeline (permitted exception — see below) | Read-only |

---

## Layer responsibilities

### `raw` — Python ingestion pipeline only
The raw schema holds immutable landed source data exactly as received from upstream APIs. Only the Python ingestion pipeline writes here. dbt models, ad-hoc queries, and manual edits must never write to `raw`.

### `staging` — dbt `stg_*` models only
The staging schema holds cleaned, renamed, and type-standardized versions of raw tables. Only dbt staging models write here. The Python pipeline is scoped to `raw` only and does not write to `staging` or any downstream schema.

### `intermediate` — dbt `int_*` models only
The intermediate schema holds spatial joins, district assignments, overlap calculations, and other multi-source transforms that are not yet mart-ready. Only dbt intermediate models write here.

### `marts` — dbt `dim_*`, `fct_*`, `bridge_*`, `geo_*` models only
The marts schema holds conformed dimensions, fact tables, bridge tables, and geometry tables. This is the primary analyst-facing layer. Only dbt mart models write here. Metabase and ad-hoc queries are read-only consumers.

### `analytics` — dbt `agg_*` models (default); Python pipeline (permitted exception)
The analytics schema holds purpose-built dashboard aggregations pre-computed for Metabase performance. Metabase is the sole consumer and must not write back.

**Default:** dbt `agg_*` models write here. This is the preferred path for all aggregations.

**Permitted exception:** The Python pipeline may write directly to `analytics` when both of the following conditions are met:
1. The transformation is complex enough that intermediate state must be inspected during development (e.g., weighted tract-to-district aggregations, binning derived from multi-step calculations)
2. Expressing the logic in SQL would produce a multi-level CTE that is materially harder to read, test, and debug than equivalent Python

When Python writes to `analytics`, the table must still be named with an `agg_` prefix and documented as if it were a dbt model. Python owning the write does not exempt the output from documentation or testing requirements.

---

## What "read-only" means in practice

A component is read-only with respect to a schema if:
- It does not `INSERT`, `UPDATE`, `DELETE`, or `CREATE TABLE` in that schema
- It may `SELECT` from that schema freely
- It must not use that schema as a write target, even temporarily

---

## Violation examples to avoid

- A Python ingestion script that writes a "cleaned" version directly to `staging` — staging belongs to dbt
- A dbt model that writes a raw snapshot backup to `raw` — raw belongs to the ingestion pipeline
- An ad-hoc SQL script that creates a table in `marts` outside the dbt project — marts belongs to dbt mart models
- A Metabase "model" that materializes a table back into `analytics` — analytics belongs to dbt `agg_*` models or Python (under documented exception only)
- Python writing to `analytics` for a simple aggregation that SQL could handle cleanly — the exception requires genuine complexity justification, not preference

---

## Links

- Schema definitions: [`docker/postgres/init/01_schemas.sql`](../../docker/postgres/init/01_schemas.sql)
- Naming conventions and model prefixes: [`docs/decision_log.md`](../decision_log.md) — D18
- Feature vs rollup policy: [`docs/policies/feature_vs_rollup_policy.md`](./feature_vs_rollup_policy.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-10 | Initial draft      | Farid  |
| 2026-03-10 | Expanded `analytics` to dual-writer: dbt default, Python permitted for complex aggregations with intermediate state inspection | Farid |
