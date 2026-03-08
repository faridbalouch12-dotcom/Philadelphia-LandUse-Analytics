# Decision log

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-08
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
| **Decision** | The warehouse will have two fact tables: `fct_permits` (transaction fact table, one row per permit event) and `fct_district_year_zoning_composition` (periodic snapshot fact table, grain: one row = one zoning code × one planning district × one vintage year). |
| **Alternatives** | (1) Model zoning as a slowly changing dimension (SCD Type 2) on the permits fact table. (2) Single fact table only, treating zoning composition as a derived metric computed at query time. |
| **Rationale** | Permits and zoning answer two separate analytical questions — physical change over time (permits) and regulatory change over time (zoning). Zoning composition is a measurement (land area share by class per district per year), not descriptive context, so it belongs in a fact table rather than a dimension. An SCD Type 2 would track what a polygon's classification *is* over time, but cannot measure how much land area is in each class per district per year. A periodic snapshot is the correct Kimball pattern because the source data consists of annual state snapshots, not event transactions, and the metrics are semi-additive (can be summed across zoning codes within a district-year, but not across years). |
| **Implications** | The warehouse now has two independent fact tables sharing conformed dimensions (district, date/vintage year). Metric specs, ERD, and the feature vs. rollup policy must all reflect two fact table paths. Zoning composition metrics are semi-additive and must not be summed across vintage years. |

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
