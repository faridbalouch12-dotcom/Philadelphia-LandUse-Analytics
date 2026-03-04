# Scope Memo — Philadelphia District-Level Data Warehouse (Month 1)

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Status:** Draft

---

## Purpose

This memo defines the scope, constraints, and success criteria for Month 1 of the Philadelphia District-Level Data Warehouse project. It serves as the authoritative reference for what is being built, what decisions are already locked, and what is explicitly deferred. Any work that falls outside this scope requires a scope change decision logged in `docs/decision_log.md`.

---

## Objective

Build a reproducible analytics platform that explains how Philadelphia's 18 planning districts change over time, using public datasets. The output is a district change explorer (interactive) plus a well-modeled warehouse that supports longitudinal analysis and future expansion to other cities.

**Target audience:** Urban planners, researchers, and data practitioners interested in land use and development patterns — including those who want to replicate this approach for other cities.

**Month 1 focus:** Month 1 is entirely pre-implementation. No code, no pipelines, no warehouse. The work is documentation and design — producing a set of artifacts detailed enough that a data engineer could build the warehouse without asking clarifying questions.

In B3 terms (Reis & Housley), Month 1 operates at the *undercurrent* layer: Data Architecture and Data Management. The lifecycle stages (ingestion, storage, transformation, serving) begin in Month 2.

---

## Locked Decisions

The following decisions are fixed for Month 1 and will not be revisited without an explicit log entry in `docs/decision_log.md`.

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Tech stack | Postgres + Python + dbt + Metabase + Docker | Standard modern data stack; avoids undifferentiated heavy lifting |
| Reproducibility | Docker Compose as default run path; GitHub as source of truth | Ensures anyone can clone and run |
| Modeling pattern | dbt `stg_*` → `dim_*` / `fct_*` | Kimball-aligned; separates raw staging from modeled output |
| Reporting grain | Philadelphia planning district (~18 districts) | District is the level where long-range planning and zoning decisions are made; sub-district grain deferred |
| Metric normalization | Land area only (sq mi) | Enables cross-district comparisons that account for size differences |
| Data time scope | Last 5 years | Balances coverage with scope; extendable to 2015–present in Month 3+ |
| Comparison period | Year-over-year | Standard planning cycle; avoids overlapping ACS period issues |
| MVP dataset scope | Permits (L&I) + Zoning base districts + ACS context + Planning district boundaries | No additional datasets until these four are stable |

---

## Month-1 Deliverables

Month 1 produces a documentation package organized into the following categories. All artifacts are tracked in `docs/README.md`.

**Repo infrastructure**
- README, .gitignore, CONTRIBUTING, doc style guide, PR template, branch protection evidence, repo settings checklist

**Scoping documents**
- Scope memo (this document), problem statement, Month-1 success criteria, glossary (v0)

**Learning notes**
- Reading notes for: Kimball (grain, facts), ACS period estimates, PostGIS spatial primer, Git/dbt patterns

**Dataset documentation** (one set per MVP dataset)
- Source catalog entries, feasibility checklists, critical fields dictionaries, data access notes

**Data modeling specs**
- Grain spec, text-only ERD draft, table inventory (feature vs. rollup), metric specs for permits + zoning + ACS indicators

**Policies**
- Data storage policy, feature vs. rollup policy, land-area denominator policy, ACS usage policy, disclaimer library

**Project artifacts**
- Assumptions log (≥10 entries), decision log (≥6 entries), limitations register (≥20 entries)

**Diagrams**
- ERD (Mermaid), high-level dataflow diagram (Mermaid)

**Product specs**
- District brief output spec, district compare view spec

**Recaps**
- Week 1–3 recaps, Month-1 executive summary, GitHub release tag

---

## Non-Goals (Month 1)

The following are explicitly out of scope for Month 1:

- No data ingestion, pipelines, or ETL scripts
- No Postgres database or schema instantiation
- No dbt models written or run
- No Metabase dashboards or reports
- No data analysis or query results
- No datasets beyond the four MVP sources
- No sub-district grain (ZIP codes, census tracts, parcels)
- No real-time or streaming data
- No ML, predictive modeling, or forecasting
- No deployment infrastructure beyond Docker Compose documentation

---

## Success Criteria

Month 1 is complete when the documentation package is **implementable** — meaning a data engineer unfamiliar with this project could read the specs and build the warehouse without asking clarifying questions.

Concretely, the following questions must be answerable from the docs alone:

**Design questions (grain spec, ERD):**
- What does one row in `permits_fact` represent?
- What grain was considered and rejected, and why?
- What are the relationships between tables, and what are the join keys?

**Spec questions (data dictionaries, metric specs):**
- What are the column names and expected types for each critical table?
- What is the SCD strategy for each dimension, and why?
- Where does each field's source data come from?
- What metric formula is used, and what are its caveats?

**Governance questions (policies, assumptions log):**
- What assumptions were made, and what breaks if they're wrong?
- What are the known limitations, and when will they be addressed?

---

## Assumptions

| ID | Assumption | Impact if Wrong | Mitigation |
|----|------------|----------------|------------|
| A1 | Philadelphia's 18 planning districts remain stable boundaries through the project | District-level grain becomes invalid; all rollups need recalculation | Monitor PCPC for boundary updates; store vintage with district geometry |
| A2 | The four MVP datasets remain publicly accessible via open data portals | Data access notes become outdated; pipelines fail | Document access mode and fallback (bulk download) for each source |
| A3 | A 5-year lookback window captures meaningful planning trends | Analysis misses longer-cycle changes (e.g., 10-year zoning shifts) | Scope is explicitly extensible; note limitation in limitations register |
| A4 | dbt + Postgres is sufficient for Month 2 implementation without infrastructure changes | Tech stack decision requires revisiting | Stack chosen for simplicity; document alternatives considered in decision log |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | Source dataset schema changes before Month 2 implementation | Medium | High | Data dictionaries document current schema; feasibility checklists flag schema stability |
| R2 | Scope creep adds a fifth dataset before the four MVP sources are stable | Medium | Medium | Locked decision in this memo; requires explicit decision log entry to override |
| R3 | Grain decision at district level proves too coarse for meaningful analysis | Low | High | Grain rationale documented; sub-district grain added as Month 3+ enhancement |

---

## References

- **[B3]** Reis, J., & Housley, M. (2022). *Fundamentals of Data Engineering*. O'Reilly. — Lifecycle framing and Stage 1 data maturity guidance.
- **[B1]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.). — Modeling pattern and grain definitions.

---

## Links

**Related Documents:**
- Problem statement: `docs/01_problem_statement.md`
- Success criteria: `docs/02_success_criteria.md`
- Decision log: `docs/decision_log.md`
- Assumptions log: `docs/assumptions_log.md`
- Docs index: `docs/README.md`

---

## Change Log

| Date | Change Description | Author |
|------|--------------------|--------|
| 2026-03-03 | Initial draft | Farid |
