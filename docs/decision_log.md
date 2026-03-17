# Decision log

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-10
**Status:** Draft

---

## Purpose

This document records the major project decisions that have been locked to
date, along with the alternatives considered, the rationale for each choice,
and the downstream implications. The goal is to preserve the reasoning while
context is fresh, so future revisions can build on explicit tradeoffs instead
of guesswork.

---

## Scope

**In Scope:** Month 1 decisions that are already locked and materially shape
the project's stack, workflow, grains, metrics, and analytical framing.

**Out of Scope:** Future implementation decisions, unresolved design choices,
and placeholder entries for decisions that have not actually been made yet.

---

## Decision entries

### D1. Use a reproducible local stack: Postgres + Python + dbt + Metabase in Docker Compose

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-03 |
| **Decision** | I'm using a reproducible local stack: Postgres + Python + dbt + Metabase, run in Docker (Compose). |
| **Alternatives** | (1) Databricks-first (Delta + notebooks + jobs), (2) Snowflake or BigQuery + dbt Cloud + hosted BI, (3) file-based analytics (DuckDB or Parquet + notebooks), (4) Postgres + Python only (skip dbt or BI). |
| **Rationale** | Postgres + Python matches my strengths and keeps the environment simple and local. dbt forces me to practice the skills I'm trying to build (data modeling, tests, documentation) without needing enterprise infrastructure. Metabase gives me a lightweight BI surface to show district-first analytics outcomes. Docker/Compose makes the whole thing reproducible and sharable. |
| **Implications** | This lets anyone run the project locally and makes it portfolio-ready. It also keeps me mostly in batch workflows and moderate data volumes unless I later migrate. It pushes me to define clean marts and metrics so the BI layer doesn't become a pile of ad hoc queries. |

---

### D2. Use GitHub as the single source of truth with branches, PRs, templates, and checklists

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-03 |
| **Decision** | GitHub is my single source of truth; I work via branches + PRs with templates/checklists (even when I'm the only contributor). |
| **Alternatives** | (1) Keep everything local with loose files and occasional zip backups, (2) use Notion or Drive as the primary system and treat code as secondary, (3) direct commits to main without PRs. |
| **Rationale** | One of my biggest gaps is a scalable workflow (version control, collaboration habits, reviewability). A PR-first workflow forces me to document changes, keep artifacts organized, and build the habits I'd need on a real DE or AE team. Treating GitHub as the source of truth reduces drift between docs, decisions, and the work itself. |
| **Implications** | This gives me traceability and sets me up for CI later, but it does slow me down a bit up front. It forces me to break work into smaller, reviewable chunks and to keep my repo clean. |

---

### D3. Make the MVP district-first while retaining feature-level layers for later map-first work

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-03 |
| **Decision** | The MVP is district-first: my main product surface is planning-district rollups, while I still retain feature-level spatial layers so map-first is possible later. |
| **Alternatives** | (1) Map-first MVP (interactive spatial explorer first), (2) parcel-first MVP, (3) tract, neighborhood, or ZIP-first reporting. |
| **Rationale** | The questions I care about first are how each district changed over time and how districts compare, which are naturally district-level time-series problems. District-first reduces early complexity and forces me to be disciplined about grain and metrics, which is a core skill gap I'm trying to close. Keeping feature-level layers means I'm not painting myself into a corner for map-first later. |
| **Implications** | This enables a clear, defensible dashboard and district briefs quickly, but it delays micro-geography storytelling such as hotspots and corridor or buffer analysis. It forces me to publish canonical rollup tables (district x month, district x year) and not rely on ad hoc aggregation. |

---

### D4. Aggregate permits monthly and normalize primarily by land-only area

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-03 |
| **Decision** | I'm aggregating permits monthly and normalizing primarily by land-only area (permits per land sq. mile). |
| **Alternatives** | (1) Normalize per population or housing units (ACS denominators), (2) use raw counts only, (3) normalize by total area (land + water), (4) aggregate quarterly instead of monthly. |
| **Rationale** | Monthly is a good balance between signal and noise: detailed enough to see changes but not so granular that daily volatility dominates. Land-only area is stable and avoids ACS comparability issues while I'm still building the platform. Normalization is important for fair cross-district comparisons, and land-only avoids distortion from water area. |
| **Implications** | This gives me a consistent intensity metric for comparisons and keeps the MVP simpler. It also means I'm not yet making per resident impact claims (that can come later). It forces me to compute and store land-only area consistently and to track unassigned permits so the rate remains credible. |

---

### D5. Focus zoning analysis on recent year-to-year comparisons over the last five years

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-03 |
| **Decision** | Zoning analysis is year-to-year over the most recent 5 years, but I'm keeping the model extensible to the full 2015-2024 vintages later. |
| **Alternatives** | (1) Earliest vs latest only (single diff), (2) full 2015-2024 year-to-year immediately, (3) skip zoning in the MVP. |
| **Rationale** | Year-to-year gives a better picture of how zoning policy changes unfold, but it increases comparability risk and workload. Limiting to the last 5 years keeps the scope realistic and reduces the surface area for schema drift and vintage inconsistencies. Designing for extensibility preserves my ability to expand once I've proven the comparability approach. |
| **Implications** | This enables a defensible recent rezoning churn narrative without boiling the ocean, but it postpones deeper historical zoning storytelling. It forces me to document schema/category drift and be explicit about what I can and can't claim. |

---

### D6. Use ACS as district-level context, not as the primary normalization basis for MVP metrics

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-03 |
| **Decision** | I'm using ACS as district-level context (income + tenure proxies) with explicit period labels and careful interpretation, and I'm not using ACS for MVP normalization. |
| **Alternatives** | (1) Use ACS population/housing units for normalization, (2) try to build annual demographic trends at small geographies, (3) leave demographics out entirely until later. |
| **Rationale** | ACS 5-year estimates are rolling period estimates, and overlapping comparisons can create misleading year-to-year narratives. Keeping ACS as context avoids contaminating my headline permit intensity metric and keeps the project's messaging responsible. Including basic context still supports the change + demographics storyline without over-claiming precision. |
| **Implications** | This gives me credible demographic context panels with standard disclaimers, but it limits what I can claim about short-term demographic shifts. It forces explicit period labeling and non-overlapping comparison choices for change claims (e.g., 2015-2019 vs 2020-2024). Presentation details were later refined by D10: tract-level distributions are shown instead of district-level aggregate KPIs. |

---

### D7. Add a zoning composition periodic snapshot fact table alongside the permits transaction fact table

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-07 |
| **Decision** | The warehouse includes the following fact tables. New fact tables are appended to this list as they are added. |

**Warehouse fact tables:**

| Table | Fact Type | Grain | Business Process | Measures |
|-------|-----------|-------|------------------|----------|
| `fct_permits` | Transaction | One issued permit event | L&I building permit issuance — tracks what construction activity was authorized, where, and when | Event count (implicit); `permit_category_group` enables composition breakdowns |
| `fct_district_year_zoning_composition` | Periodic snapshot | One district × one vintage year × one zoning code | Regulatory land use composition — tracks how each district's zoning makeup is distributed and shifts over time | `area_sqmi`, `pct_district` |
| `fct_tract_acs` | Periodic snapshot | One census tract × one ACS 5-year period | Demographic and housing context — captures income and tenure characteristics at tract level for district-level distribution analysis | `median_hh_income` (+ MOE), `owner_occupied_pct` (+ MOE), `total_pop` (+ MOE) |
| **Alternatives** | (1) Model zoning as a slowly changing dimension (SCD Type 2) on the permits fact table. (2) Single fact table only, treating zoning composition as a derived metric computed at query time. |
| **Rationale** | Permits and zoning answer two separate analytical questions — physical change over time (permits) and regulatory change over time (zoning). Zoning composition is a measurement (land area share by class per district per year), not descriptive context, so it belongs in a fact table rather than a dimension. An SCD Type 2 would track what a polygon's classification *is* over time, but cannot measure how much land area is in each class per district per year. A periodic snapshot is the correct Kimball pattern because the source data consists of annual state snapshots, not event transactions, and the metrics are semi-additive (can be summed across zoning codes within a district-year, but not across years). |
| **Implications** | The warehouse has three independent fact tables sharing conformed dimensions (district, date). Metric specs, ERD, and the feature vs. rollup policy must all reflect each fact table's path. Zoning composition metrics are semi-additive and must not be summed across vintage years. ACS estimates are non-additive and must be presented as tract-level distributions (D10). |

---

### D8. Carry MOE columns in the tract-level ACS mart table; do not aggregate MOEs further up

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | The ACS mart table (`fct_tract_acs` or equivalent) will include raw MOE columns alongside every estimate (e.g., `median_hh_income_moe`) at tract grain. The pipeline will not compute aggregated MOEs for cross-district differences or derived metrics. |
| **Alternatives** | (1) Omit MOE columns entirely — simpler schema, but hides uncertainty from downstream users. (2) Compute and store the aggregated MOE for each derived metric — more complete, but adds significant complexity and requires decisions about which aggregation formula to apply per metric. |
| **Rationale** | Surfacing raw MOEs in the mart makes uncertainty visible to any downstream user without requiring them to re-fetch source data. Omitting them would force anyone who cares about statistical significance to go back to the Census Bureau API. Computing aggregated MOEs for cross-district comparisons requires nontrivial formula choices (e.g., √(MOE_A² + MOE_B²) for differences) and would need to be re-implemented for every derived metric — disproportionate effort for MVP. Carrying raw MOEs is the minimum responsible step: it provides the building blocks without locking in aggregation decisions upstream. |
| **Implications** | Mart schema must include `*_moe` columns for every ACS estimate field at tract grain. Downstream dashboards must not interpret raw MOEs as aggregated comparison uncertainty — documentation and disclaimers must explain this. In combination with D10, ACS is presented as tract-level distributions rather than district-level aggregate KPIs. This decision defers aggregated MOE computation to Month 3+ when metric specs are finalized and the cost/benefit is clearer. |

---

### D9. Represent district income context as a range of tract-level medians, not an aggregated district median

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | ACS median household income will be represented at the district level as the range of tract-level medians within the district (min, max, tract count) — not as a single aggregated district median. |
| **Alternatives** | (1) Area-weighted average of tract medians — produces a biased approximation because median is not an additive statistic; income distributions within tracts are rarely uniform. (2) PUMS microdata aggregation — would allow a true district median but PUMS is available at PUMA level (not planning district), adding boundary alignment complexity that exceeds MVP scope. (3) Substitute additive count-based proxies (e.g., households below poverty threshold) — valid, but loses the intuitive income framing stakeholders expect. |
| **Rationale** | Median is not additive: averaging tract medians across a district does not produce the true district median and is misleading in mixed-income districts where distributions are skewed or bimodal. Showing the range of tract medians is statistically honest, surfaceable via a tooltip, and more informative — it reveals intra-district income inequality that a single aggregated figure would hide. |
| **Implications** | The ACS income metric spec (Task 14.1) must define the metric as `min(tract_median)`, `max(tract_median)`, and `count(tracts)` per district per period as distribution context metadata, not a canonical district KPI. Dashboard tooltips must label values as tract-level estimates, not district medians. This approach is documented as L18 in the limitations register. |

---

### D10. Present all ACS indicators on the dashboard at tract level; no single-value district ACS KPI

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | The dashboard will display all ACS indicators as tract-level distributions (e.g., histograms or breakdowns on hover), not as single-value district-level ACS KPIs. The warehouse will store tract-level ACS data as-is, available for direct querying by anyone who needs it. |
| **Alternatives** | (1) Tiered approach — aggregate additive stats (counts, sums) to district level and show distributions only for non-additive stats (medians, rates). (2) Suppress non-additive ACS indicators entirely; show only additive counts where aggregation is valid. (3) Aggregate everything using area-weighting and document the approximation. |
| **Rationale** | A tiered approach creates UX inconsistency — users see single numbers for some indicators and distributions for others with no clear explanation of why. This inconsistency is likely to be more confusing than the statistical nuance it tries to preserve. A uniform "tract-level distributions" approach is simpler to explain ("you're seeing the tracts within this district"), statistically honest for all indicator types, and avoids fabricating district-level figures that aren't directly measured. The warehouse layer still stores tract-level data, so anyone querying directly can apply their own aggregation logic. |
| **Implications** | Dashboard ACS panels must be designed around distribution/histogram views, not single-value KPIs. No district-level ACS aggregate will be produced or published as an official single-number metric; contextual summaries (for example ranges, tract counts, and histogram bins) are acceptable when explicitly labeled as tract-derived context. The ACS income and tenure metric specs (Tasks 14.1–14.2) must reflect tract-level presentation. L18 and L19 in the limitations register are partially resolved by this approach — they become documentation obligations rather than active data quality risks. |

---

### D11. Cross-metric consistency fixes (Week 3 quality pass — Task 15.1)

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | Five naming inconsistencies identified across metric specs and modeling docs were resolved: (1) `stg_permits` → `fct_permits` in source tables of permits_monthly_count, permits_per_sqmi_land, and permits_composition — metric specs reference analyst-facing fact tables, not staging tables. (2) `dim_permit_type` → `permit_category_groups` in dimensions of permits_monthly_count and permits_per_sqmi_land — table inventory does not include a separate dim_permit_type; the lookup is permit_category_groups per the grouping memo. (3) `dim_zoning_code` → `dim_zoning` in zoning_comparability_plan final — table inventory (E3) uses dim_zoning as the canonical name. (4) Planning District dimension in ACS metric specs corrected from bridge_tract_district_overlap to dim_district — the bridge is infrastructure, not a sliceable dimension. (5) SQL sketch in permits_composition corrected from stg_permits to fct_permits for consistency with (1). |
| **Alternatives** | Leave inconsistencies in place until Month 2 implementation forces resolution. |
| **Rationale** | Naming inconsistencies in documentation specs create ambiguity that compounds when engineers implement models. Resolving them in documentation before any code is written is lower cost than reconciling divergent table names after pipeline work begins. |
| **Implications** | All metric specs and the final zoning comparability plan now use consistent table names aligned to the table inventory. Month 2 pipeline implementation should treat these names as canonical. |

---

### D12. Use EOY surrogate date keys for all year-level and period-level fact-to-dimension joins

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | All year-level and period-level fact tables join to `dim_date` using an end-of-year (EOY) surrogate date column — e.g., `vintage_date` (zoning), `acs_period_end_date` (ACS), `boundary_version_eoy` (bridge) — rather than a raw integer year field. |
| **Alternatives** | (1) Store the year as an integer column and join `dim_date` on `year = year`. (2) Store the year as the January 1st date (SOY) rather than December 31st. |
| **Rationale** | Joining on `year` integer would match 365 rows in `dim_date` per fact row — a fan-out join that inflates row counts in any query that spans both the fact and the date dimension. An EOY date resolves to exactly one `dim_date` row, giving the fact table a clean, unambiguous FK. December 31st was chosen over January 1st because it is the natural period-end date: zoning vintages are annual state snapshots best described by their end date, and ACS period labels (e.g., "2019-2023") end on December 31st of the labeled end year. |
| **Implications** | Every year-level or period-level fact table must include an explicit EOY date column (not just a year integer). Pipeline logic must compute and store these surrogate date values before loading. `dim_date` must cover the full analysis window plus boundary years. Analysts querying time attributes must join through `dim_date` — they should not filter directly on the integer year stored in fact tables. |

---

### D13. Separate polygon geometry from `dim_district` into a dedicated `geo_district_boundaries` table

> **SUPERSEDED by D20 on 2026-03-15.** See D20 for current decision.

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | Planning district polygon geometry is stored in a dedicated `geo_district_boundaries` table (E8), not in `dim_district` (E1). `dim_district` contains only lightweight scalar attributes: `district_id`, `district_name`, `land_area_sqmi`. |
| **Alternatives** | (1) Store geometry in `dim_district` — simplifies schema by one table, all district attributes in one place. (2) Store geometry as a pre-computed WKT string column in `dim_district` — reduces spatial overhead while keeping schema flat. |
| **Rationale** | Polygon geometry is large. Every analytics query that joins to `dim_district` to filter or label by district would carry a geometry column it does not need, increasing memory and I/O cost. Separating geometry means analytics joins stay lightweight and fast; geometry is only loaded when spatial operations or map rendering are needed. This also enforces a clean boundary between the analytics layer (`dim_district`) and the spatial/feature layer (`geo_district_boundaries`), consistent with the feature vs rollup policy. |
| **Implications** | `dim_district` is a lightweight lookup table with no geometry. Any query requiring district polygon geometry must join to `geo_district_boundaries`. Map rendering tools must know to use the `geo_` table. dbt models building rollups should join to `dim_district`, not `geo_district_boundaries`. |

---

### D14. Use `fct_tract_acs` as a dimensional lookup for the bridge table rather than creating a separate `dim_census_tract`

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-08 |
| **Decision** | `bridge_tract_district_overlap` joins to `fct_tract_acs` on `geoid_tract` to look up tract identity. No separate `dim_census_tract` is created. |
| **Alternatives** | (1) Create a `dim_census_tract` dimension table containing just `geoid_tract` and tract metadata; let the bridge and the ACS fact table both join to it. |
| **Rationale** | ACS data at the tract level is itself a measurement — it contains estimates and margins of error, not just descriptive attributes. Creating a `dim_census_tract` would either (a) duplicate `geoid_tract` metadata already stored in `fct_tract_acs`, or (b) create a dimension with no attributes beyond the key, which adds schema complexity without analytical benefit. The bridge already holds the spatial relationship (`overlap_area_sqft`, `pct_tract_area`, `assignment_method`). Using `fct_tract_acs` as a lookup is a deliberate, documented design decision — not an oversight. |
| **Implications** | `bridge_tract_district_overlap` carries a FK to `fct_tract_acs`, making `fct_tract_acs` function partly as a lookup table. This is a documented non-standard Kimball pattern for this project. Analysts building custom district-level aggregations via the bridge must join to `fct_tract_acs` for estimates and MOEs — they do not need a separate dim table. |

---

### D15. `fct_permits` is a transaction fact table only in MVP; permit lifecycle snapshot deferred

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-09 |
| **Decision** | The MVP uses `fct_permits` as a transaction/event fact table only — one row per issued permit, filtered in staging to `status = 'Issued'`. A separate `fct_permit_lifecycle_snapshot` (accumulating snapshot tracking milestone dates such as applied, issued, and completed) is explicitly deferred to a future phase. |
| **Alternatives** | (1) MVP includes both a transaction fact and a lifecycle accumulating snapshot fact — more complete, but adds staging complexity and requires reliable milestone date coverage that the raw data does not currently guarantee. (2) MVP uses only an accumulating snapshot — simpler to answer lifecycle questions, but adds update complexity and doesn't align with how the raw data is naturally structured (it's filtered to issued events, not tracked through a full lifecycle). |
| **Rationale** | The raw L&I data is filtered to `status = 'Issued'`, which means each permit row represents a single completed issuance event. A transaction fact is the natural pattern for this structure. Lifecycle questions (e.g., how long from application to issuance?) require reliable population of milestone columns (`permitapplicationdate`, `permitcompleteddate`) — fields that are currently sparse or inconsistently populated. Building an accumulating snapshot on incomplete milestone data would produce misleading duration metrics. Deferring it keeps the MVP clean and avoids fabricating lifecycle claims the data can't support. |
| **Implications** | `fct_permits` must be treated as a transaction fact throughout all documentation, metric specs, ERD annotations, and implementation work. Any reference to permit lifecycle or accumulating snapshot must include explicit "deferred" language. When lifecycle data quality improves in Month 2+, a separate `fct_permit_lifecycle_snapshot` can be added without changing the existing transaction fact table. |

---

### D16. Bridge table minimum overlap threshold: `pct_tract_area > 0.01`

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-09 |
| **Decision** | `bridge_tract_district_overlap` only stores rows where `pct_tract_area > 0.01` (i.e., a census tract must contribute more than 1% of its area to a planning district to be included). Rows below this threshold are dropped in staging and never loaded. All rows that pass are assigned `assignment_method = 'overlap_weighted'`. |
| **Alternatives** | (1) Include all rows where `overlap_area_sqft > 0` — captures every geometric intersection, including zero-area edge/point touches and GIS slivers. (2) Use a higher threshold (e.g., 5%) — more conservative, removes borderline overlaps but risks dropping tracts with meaningful small contributions near district edges. |
| **Rationale** | Philadelphia planning district boundaries are well-defined administrative boundaries and census tract geometries are generally clean. Slivers below 1% are almost certainly GIS artifacts from polygon edge alignment, not real geographic overlap worth weighting on. Filtering them reduces noise in weighted ACS aggregations with negligible impact on accuracy — a tract contributing < 1% of its area to a district adds near-zero weight to any estimate. Using `pct_tract_area` (relative threshold) rather than `overlap_area_sqft` (absolute threshold) is more robust because it scales correctly regardless of tract size. |
| **Implications** | `pct_tract_area` values for a given tract will sum to slightly less than 1.0 across all its district rows (< 1% gap from dropped slivers) — this is acceptable for MVP. Staging logic must implement the filter before load, not as a DB constraint. The threshold must be documented in the bridge table's data dictionary and the limitations register as a known approximation. |

---

### D17. SCD strategy for all warehouse dimensions

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-09 |
| **Decision** | `dim_district`: Type 1 (overwrite). `dim_date`: Static (generated once, never updated). `dim_zoning`: Type 1 (overwrite). Fact and bridge tables are not subject to SCD — they are immutable once loaded or versioned by design. |
| **Alternatives** | Type 2 (track history) for `dim_district` or `dim_zoning` — would preserve the old row and add a new one when attributes change, keeping historical facts linked to the description accurate at the time. |
| **Rationale** | `dim_district`: Philadelphia planning district names and boundaries are administratively stable. The boundary itself is tracked separately via `boundary_version` in `geo_district_boundaries` and `bridge_tract_district_overlap` — so geographic changes are already versioned at the appropriate layer, not in the dimension. `dim_date`: Calendar dates are immutable by definition. `dim_zoning`: Zoning categories (`zoning_label`, `zoning_category`) are broad and stable within the MVP window (recent 5 years). The raw `zoning_code` is preserved in `fct_district_year_zoning_composition` regardless of label changes, so historical composition data is not affected by a Type 1 overwrite — only the display label changes. Type 2 would add surrogate key complexity and version-tracking overhead not justified by the stability of these attributes at MVP scale. |
| **Implications** | No surrogate key versioning columns (`effective_date`, `expiry_date`, `is_current`) are needed on any dimension for MVP. If a `dim_zoning` label is corrected in Month 2+, the correction silently applies to all historical display queries — this is acceptable and documented. If district boundaries change materially, the change is captured via a new `boundary_version` in the spatial tables, not via `dim_district`. |

---

### D18. Use a 5-layer schema architecture: raw, staging, intermediate, marts, analytics

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-10 |
| **Decision** | The warehouse uses 5 schemas: `raw` (API landing zone, Python-only writes), `staging` (cleaned/standardized data, dbt `stg_*` models), `intermediate` (complex grain-changing transforms, dbt `int_*` models), `marts` (analyst-facing fact/dimension/bridge tables, dbt `dim_*/fct_*/bridge_*/geo_*` models), `analytics` (Metabase-only aggregations, dbt `agg_*` models). |
| **Alternatives** | (1) **2-layer (staging/marts)** — original conceptual design. Assumed raw data would sit as files on disk, but data arrives via API and is loaded directly into Postgres by Python. Conflated "raw API landing" with "cleaned data" in a single staging schema. (2) **3-layer (raw/staging/marts)** — added `raw` as the Python-only landing schema. Better, but staging → marts still required too much transformation in a single step: both simple column renames and complex spatial joins happened inside staging or were deferred to query time. |
| **Rationale** | The key driver was the complexity of the spatial work. Staging should only do simple, repeatable transformations — renaming columns, standardizing types, CRS validation, applying crosswalks. Nothing that changes the grain or requires joining multiple sources. The spatial joins (point-in-polygon for permits, polygon intersection for zoning, tract-district overlap for ACS) are the hardest part of this pipeline: they change grain, require PostGIS operations, and are the most likely to break. Folding them into staging makes that layer hard to read and debug. Separating them into `intermediate` gives the dbt DAG a clean structure — stg_* cleans raw data, int_* does joins. The marts/analytics split was driven by `agg_district_acs_attributes_hist`: it answers a specific Metabase question and no SQL analyst would ever query it directly. Putting it in `analytics` makes that boundary explicit rather than leaving a Metabase-only table sitting next to analyst-facing fact tables in `marts`. The 5-layer design adds more tables to maintain and more documentation to update, but that cost is worth it given the complexity of the spatial joins and the clear boundary it establishes between "cleaning raw data" and "doing joins on data." |
| **Implications** | Every dbt model now has an explicit schema home: `stg_*` → staging, `int_*` → intermediate, `dim_*/fct_*/bridge_*/geo_*` → marts, `agg_*` → analytics. `intermediate` is pipeline-only — analysts should not query it directly (enforced by the read/write policy in Task 5.3). `analytics` is Metabase-only — SQL analysts use `marts` for custom work. Python writes exclusively to `raw`; nothing else touches it. The dbt DAG will naturally organize into four pipeline phases, making it easier to read and debug. Five new intermediate tables (E10–E14) were added to the table inventory to represent this layer. |

---

### D19. Co-locate `tract_geometry` in `fct_tract_acs` rather than separating to a dedicated `geo_tract_boundaries` table

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-10 |
| **Decision** | `fct_tract_acs` includes a `tract_geometry` (polygon, EPSG:4326) column alongside ACS measurements. No separate `geo_tract_boundaries` table is created for census tracts. |
| **Alternatives** | (1) Follow the D13 geometry-separation pattern — create a dedicated `geo_tract_boundaries` table, join to it only for map rendering. (2) Store no tract geometry in marts at all — derive geometry only during intermediate spatial joins and discard afterward. |
| **Rationale** | D13's geometry-separation reasoning applies specifically to `dim_district` because it is the universal analytics lookup joined by every domain query — pulling a geometry column into that join would affect every fact query in the warehouse. `fct_tract_acs` has a much lower join frequency: it is joined by `bridge_tract_district_overlap` (a pipeline-level dbt transform) and referenced by `agg_district_acs_attributes_hist`. Both consumers are dbt models that use explicit column selection via `ref()`, not `SELECT *`, so the geometry column is never pulled unintentionally. A dedicated `geo_tract_boundaries` table would add a join for Metabase map rendering with no analytical benefit. Census tract boundaries are defined by decennial census vintages (2010, 2020) — for MVP (a single ACS period), no geometry redundancy occurs. |
| **Implications** | `fct_tract_acs` now serves three roles: (1) ACS measurement store, (2) dimensional lookup for the bridge (D14), and (3) geometry source for tract-level map rendering. dbt models consuming `fct_tract_acs` must use explicit column selection and must not use `SELECT *`. Analysts writing custom SQL should exclude `tract_geometry` from aggregation queries that don't need spatial output. If the project scales to multiple ACS periods using different decennial boundary vintages, geometry storage will be redundant across periods — revisit this decision at that point. |

---

### D20. Co-locate `polygon_geometry` in `dim_district`; drop `geo_district_boundaries`

| Field | Detail |
|-------|--------|
| **Date** | 2026-03-15 |
| **Decision** | `dim_district` includes a `polygon_geometry` (EPSG:4326) column. `geo_district_boundaries` (E8) is dropped from the schema. Boundary versioning (`boundary_version`) is also dropped — boundary changes are handled via Type 1 overwrite on `dim_district`, consistent with D17. |
| **Alternatives** | (1) Keep D13 as-is — maintain `geo_district_boundaries` as a separate geo table. (2) Store geometry as WKT string in `dim_district` — reduces PostGIS overhead while keeping schema flat. |
| **Rationale** | D13's geometry-separation reasoning was that `dim_district` is joined by every analytics query, making geometry column overhead unavoidable. At MVP scale with 18 static districts, this overhead is negligible — the geometry data is tiny. The D19 precedent established that co-location is acceptable when consumers use explicit column selection. Adding a separate `geo_district_boundaries` table adds schema complexity (an extra table, an extra task, an extra join for map rendering) without meaningful benefit at this scale. Boundary versioning is also dropped: district boundaries are administratively stable for the MVP window, and the versioning mechanism adds complexity (new rows per boundary change, bridge table re-computation) that is not justified for 18 static districts. |
| **Implications** | `dim_district` now carries a `polygon_geometry GEOMETRY(MULTIPOLYGON, 4326)` column. Task 32.3 (`geo_district_boundaries`) is collapsed into 32.2. The `geo_` table type is no longer used in the marts layer. D17's reference to boundary versioning via `geo_district_boundaries` is superseded for the `dim_district` case — boundary changes now result in a Type 1 overwrite on `dim_district`. dbt models joining `dim_district` for analytics (non-spatial) purposes must use explicit column selection and exclude `polygon_geometry`. |

---

## References

- **[B7]** The Pragmatic Programmer (20th Anniversary). See
  [Resources](../.claude/resources.md) for full details.

---

## Links

**Related documents:**
- [Scope memo](./00_scope_memo.md)
- [Assumptions log](./assumptions_log.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-03 | Initial draft      | Farid  |
| 2026-03-07 | Added D7: two-fact-table design decision | Farid |
| 2026-03-08 | Added D8: carry MOE columns in tract-level ACS mart | Farid |
| 2026-03-08 | Added D9: represent income as tract median range, not aggregated district median | Farid |
| 2026-03-08 | Added D10: present all ACS indicators at tract level on dashboard; no single-value district ACS KPI | Farid |
| 2026-03-08 | Added D11: cross-metric consistency fixes from Task 15.1 quality pass | Farid |
| 2026-03-08 | Added D12: EOY surrogate date key pattern; D13: geometry separation from dim_district; D14: fct_tract_acs as bridge lookup — all from ERD work (Task 16.3) | Farid |
| 2026-03-09 | Added D15: fct_permits locked as transaction fact; permit lifecycle accumulating snapshot deferred (Month 1 closeout) | Farid |
| 2026-03-09 | Added D16: bridge table minimum overlap threshold pct_tract_area > 0.01 (Month 1 closeout) | Farid |
| 2026-03-09 | Added D17: SCD strategy for all dimensions — Type 1 for dim_district and dim_zoning, static for dim_date (Month 1 closeout) | Farid |
| 2026-03-10 | Added D18: 5-layer schema architecture (raw/staging/intermediate/marts/analytics) | Farid |
| 2026-03-10 | Amended D7: replaced stale "two fact tables" count with appendable fact table registry; added fct_tract_acs; updated Implications to reflect three fact tables | Farid |
| 2026-03-10 | Reordered entries D11–D18 to sequential numeric order (D-numbers unchanged) | Farid |
| 2026-03-10 | Added D19: tract_geometry co-located in fct_tract_acs rather than separated to geo_tract_boundaries — D13 pattern explicitly not applied; rationale: low join frequency, explicit column selection, MVP scope | Farid |
| 2026-03-15 | Superseded D13: polygon_geometry co-located in dim_district; geo_district_boundaries dropped; boundary versioning dropped — D19 precedent applied; 18 static districts, negligible overhead, MVP scope | Farid |
