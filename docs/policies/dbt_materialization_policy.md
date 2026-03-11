# dbt materialization policy

**Author:** Farid
**Created:** 2026-03-11
**Last Updated:** 2026-03-11
**Status:** Active

## Purpose

This policy defines the default dbt materialization for each model layer in the philly_dw project. Materialization is a cost-and-correctness decision — a view over a 2M-row permits scan inside a dashboard query is a different choice than a view over a lightweight rename of a 18-row geometry table. These decisions are made at the folder level in `dbt_project.yml` and documented here so they can be reviewed and updated as the project scales.

---

## Layer defaults

| Layer | Materialization | Schema |
|-------|----------------|--------|
| `staging/` | `view` | `staging` |
| `intermediate/` | `table` | `intermediate` |
| `marts/` | `table` | `marts` |
| `analytics/` | `table` | `analytics` |

---

## Rationale by layer

### staging — view

Staging models are lightweight: column renames, type casts, and light filtering on top of raw source tables. No aggregations, no joins across sources.

Views are appropriate here because:
- The transform cost is trivial — staging is just a projection of raw
- Staging models are only ever read by dbt itself (intermediate or marts), never by Metabase
- The view cost is paid once per `dbt run` when downstream tables are materialized, not at dashboard query time
- Storing staging as tables would duplicate raw data with no query performance benefit

### intermediate — table

Intermediate models contain the expensive work: spatial joins, area computations, vocabulary crosswalk application, and multi-source joins. These are pipeline-only transforms that exist to break complex logic into cacheable steps.

Tables are required here because:
- Spatial joins (e.g., point-in-polygon for permit district assignment) are expensive — materializing the result avoids re-running them every time a mart references intermediate
- Marts may reference multiple intermediate models; views would compound the compute cost
- Intermediate results do not change until raw data changes, so caching is safe

### marts — table

Marts are the primary query layer: fact tables, dimensions, the spatial bridge, and geometry tables. This is what Metabase connects to.

Tables are required here because:
- Consistent query performance is required — views on fact tables with millions of rows are unacceptable in a dashboard context
- `fct_permits` will grow to 2M+ rows; a view over it inside every Metabase query would be a significant performance problem
- Dimensions and geometry tables are small but are joined frequently — table materialization keeps joins predictable

### analytics — table

Analytics models are pre-aggregated rollups built on top of marts, designed specifically for dashboard consumption (e.g., `agg_district_acs_attributes_hist`).

Tables are required here because:
- These models exist precisely because the aggregation is expensive — storing them avoids re-running the aggregation on every Metabase query
- Metabase hits these tables directly; a view here would defeat the purpose of pre-aggregation
- Dashboard load time is user-facing; this layer must be stable and fast

---

## Known model-level overrides

No overrides are locked at this time. Candidates to watch:

- **`fct_permits`** — if row counts exceed 5M, consider `incremental` materialization to avoid full rebuilds on every ingest cycle. Decision deferred until Week 7 (permits vertical slice).
- **`bridge_tract_district_overlap`** — spatial intersection is expensive but static (only changes when district or tract boundaries change). If rebuild time becomes problematic, consider `incremental` with a manual full-refresh trigger on vintage change.

---

## Links

- dbt project config: [`dbt/philly_dw/dbt_project.yml`](../../dbt/philly_dw/dbt_project.yml)
- dbt folder structure: [`dbt/philly_dw/models/`](../../dbt/philly_dw/models/)

---

## References

- **[D36]** dbt Labs. *Materializations*. See [Resources](../../.claude/resources.md).
- **[D37]** dbt Labs. *dbt_project.yml configuration*. See [Resources](../../.claude/resources.md).
- **[D38]** dbt Labs. *Best practices: How we structure our dbt projects*. See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-11 | Initial policy — layer defaults and rationale for all 4 layers | Farid |
