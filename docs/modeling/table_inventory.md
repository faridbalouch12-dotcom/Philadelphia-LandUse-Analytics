# Table Inventory

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-10
**Status:** Draft

---

## Purpose

This document inventories all planned warehouse tables for the Philadelphia data warehouse MVP. Each table is classified by schema layer, type, grain, and intended consumers to clarify what each table is for and who should query it.

---

## Scope

**In scope:**
- All analyst-facing MVP tables across marts and analytics layers
- Type classification (feature / rollup / dimension / bridge / geo)
- Grain statement (one row per …)
- Intended consumers

**Out of scope:**
- Raw landing tables (documented in source catalog)
- Staging tables (dbt `stg_*` — pipeline-only; documented in dataflow diagram)
- Intermediate transform tables (dbt `int_*` — pipeline-only; documented in [erd_text_draft.md](./erd_text_draft.md) E10–E14 and [dataflow.mmd](../diagrams/dataflow.mmd))
- Physical DDL and column-level specs (covered in column contracts)
- dbt implementation details
- Metric definitions (covered in metric specs)

---

## Type definitions

| Type | Definition |
|------|------------|
| **feature** | One row = one real-world object or event at atomic grain. Map-ready; supports drill-down. Not pre-aggregated. See [feature_vs_rollup_policy.md](../policies/feature_vs_rollup_policy.md). |
| **rollup** | One row = one aggregate at a higher grain intended for dashboards and comparisons. Reproducible from upstream feature tables. See [feature_vs_rollup_policy.md](../policies/feature_vs_rollup_policy.md). |
| **dimension** | Lookup / reference table providing descriptive attributes for joining to fact tables. |
| **bridge** | Resolves a many-to-many relationship between two entities. Infrastructure table — queryable by advanced analysts but not intended for direct dashboard queries. |
| **geo** | Stores polygon geometry for spatial operations and map rendering. Not intended for analytics joins due to geometry overhead. |
---

## Table inventory

### Marts layer (schema: `marts`)

| Table | Entity | Type | Grain | SCD Strategy | Intended consumers |
|-------|--------|------|-------|--------------|-------------------|
| `dim_district` | E1 | dimension | One planning district | **Type 1** — district names and area are administratively stable; corrections overwrite in place | SQL analysts (joins); Metabase dashboards (district filter) | Key columns: `district_id` (integer PK), `district_name`, `district_abbrev`, `land_area_sqmi` |
| `dim_date` | E2 | dimension | One calendar date | **Static** — calendar dates never change; table is generated once and never updated | Pipeline / dbt models (all fact tables join via EOY surrogate date keys) |
| `dim_zoning` | E3 | dimension | One zoning code | **Type 1** — zoning categories are broad and stable within the MVP window; label corrections overwrite in place | SQL analysts (joins); Metabase dashboards (zoning filter) |
| `fct_permits` | E4 | feature | One issued permit event (`status = 'Issued'`) | N/A — transaction fact; rows are immutable once loaded | SQL analysts (drill-down, custom aggregations); Metabase dashboards (permit counts, intensity metrics) |
| `fct_district_year_zoning_composition` | E5 | rollup | One planning district × one vintage year × one zoning code | N/A — periodic snapshot; each vintage is a full reload, not an update | Metabase dashboards (zoning composition charts, YoY comparisons); SQL analysts (composition queries) |
| `bridge_tract_district_overlap` | E6 | bridge | One census tract × one planning district × one boundary version overlap, where `pct_tract_area > 0.01` | N/A — versioned by `boundary_version`; new boundary → new rows, old rows retained | Pipeline / dbt models (primary — used to aggregate `fct_tract_acs` to district level); advanced analysts building custom MOE-aware district aggregations (secondary) |
| `fct_tract_acs` | E7 | feature | One census tract × one ACS 5-year period snapshot (wide — each indicator as separate column) | N/A — append-only by period; historical periods are never updated | SQL analysts (custom MOE-aware aggregations); pipeline / dbt models (source for `agg_district_acs_attributes_hist` via bridge); GIS tools / map rendering (tract-level choropleth maps via `tract_geometry`) |
| `geo_district_boundaries` | E8 | geo | One planning district boundary version | N/A — versioned by `boundary_version`; geometry rows are immutable once loaded | GIS tools / map rendering only; not for analytics joins (geometry overhead) |

### Analytics layer (schema: `analytics`)

| Table | Entity | Type | Grain | SCD Strategy | Intended consumers |
|-------|--------|------|-------|--------------|-------------------|
| `agg_district_acs_attributes_hist` | E9 | rollup | One planning district × one boundary version × one census attribute × one bin range | N/A — derived rollup; rebuilt from source on refresh | Metabase dashboards only (district-level ACS histogram visualizations, hover tooltips) |

---

## Consumer categories

| Consumer | Description |
|----------|-------------|
| **Metabase dashboards** | Pre-built charts and filters in the district change explorer. Queries rollup and aggregation tables directly. |
| **SQL analysts** | Analysts writing custom SQL against mart tables. May query feature tables for drill-down or custom aggregations. |
| **Pipeline / dbt models** | dbt transformations that use bridge or dimension tables as intermediate inputs. Not end users. |
| **Advanced analysts** | SQL analysts building custom district estimates from raw ACS data using MOE-aware weighted aggregation via the bridge. Secondary use case. |
| **GIS tools / map rendering** | Spatial tools (PostGIS queries, QGIS, or Metabase map visualizations) that require polygon geometry. |

---

## Assumptions

| ID | Assumption | Impact if wrong | Mitigation |
|----|------------|-----------------|------------|
| A1 | `fct_permits` is the atomic feature layer for permits — no further-atomic source needed for MVP | If individual permit amendments/renewals need to be tracked separately, grain must change | Document in limitations register; revisit grain in Month 2 |
| A2 | `bridge_tract_district_overlap` is not a target for Metabase dashboards — analysts who need custom aggregations will write SQL | If non-technical users need to explore tract-level data, a pre-built aggregation layer (similar to E9) would need to be added | Monitor usage patterns; add rollup table if demand emerges |
| A3 | `geo_district_boundaries` is consumed only by GIS/map rendering, not analytics joins. **Note:** `fct_tract_acs` is an explicit exception — it co-locates `tract_geometry` because its join frequency is low and its consumers use explicit column selection (see D19). The separation policy applies to `dim_district` / `geo_district_boundaries`, not as a universal rule. | If analysts query `fct_tract_acs` with `SELECT *` in analytical contexts, geometry column overhead is unnecessary | Enforce explicit column selection in all dbt models that consume `fct_tract_acs`; document in dbt model YAML |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | Analysts query `bridge_tract_district_overlap` directly without applying overlap weights correctly, producing incorrect district-level estimates | Medium | High | Add documentation note on bridge table; pre-aggregate via `agg_district_acs_attributes_hist` for standard use cases |
| R2 | `fct_district_year_zoning_composition` rollup diverges from `geo_district_boundaries` feature layer if zoning code list changes across vintages | Medium | Medium | Document assumption A1 in zoning comparability plan; validate code lists before Month 2 |

---

## Links

- Feature vs rollup policy: [`docs/policies/feature_vs_rollup_policy.md`](../policies/feature_vs_rollup_policy.md)
- ERD text draft: [`docs/modeling/erd_text_draft.md`](./erd_text_draft.md)
- Grain spec: [`docs/modeling/grain_spec.md`](./grain_spec.md)
- Decision log: [`docs/decision_log.md`](../decision_log.md)
- Schema layer redesign notes: [`notes/claude_sessions/session_2026-03-10_task-5-2_schema-redesign.md`](../../notes/claude_sessions/session_2026-03-10_task-5-2_schema-redesign.md)

---

## References

- **[B1]** Kimball, R., and Ross, M. *The Data Warehouse Toolkit* (3rd ed.). See [Resources](../../.claude/resources.md).

---

## Change log

| Date | Change description | Author |
|------|--------------------|--------|
| 2026-03-08 | Initial draft — 9 tables, type classifications, grain statements, consumer designations, assumptions and risks | Farid |
| 2026-03-09 | Added SCD Strategy column for all 9 tables (Month 1 closeout) | Farid |
| 2026-03-10 | Added 5-layer schema architecture; moved E9 to analytics layer | Farid |
| 2026-03-10 | Reconciliation: removed intermediate tables (E10–E14) and transform type — pipeline-only tables documented in erd_text_draft.md and dataflow.mmd; tightened scope to marts + analytics; removed A4 | Farid |
| 2026-03-10 | Updated fct_tract_acs consumers to include GIS/map rendering via tract_geometry; updated A3 to scope geometry-separation policy to dim_district/geo_district_boundaries only (D19 exception noted) | Farid |
