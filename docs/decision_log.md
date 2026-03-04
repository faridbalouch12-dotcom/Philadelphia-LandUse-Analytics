# Decision log

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
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
| **Implications** | This gives me credible demographic context panels with standard disclaimers, but it limits what I can claim about short-term demographic shifts. It forces explicit period labeling and non-overlapping comparison choices for change claims (e.g., 2015-2019 vs 2020-2024). |

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
