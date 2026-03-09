# Week 3 recap + Week 4 plan

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

This recap consolidates Week 3 data modeling and metric spec outputs into one handoff document. It captures what was accomplished and learned each day, records the cross-cutting decisions that emerged, and defines a concrete Week 4 execution plan for diagrams and product specs. It is written for both future-me and a reviewer who needs to understand how Week 3 shaped the warehouse design.

---

## Scope

**In Scope:**
- Week 3 artifacts: grain spec, ERD, table inventory, glossary, metric specs, comparability plan, disclaimer library
- What was accomplished each day, what was learned, and what carries forward
- Cross-cutting naming decisions and consistency fixes that now govern Month 2 implementation
- A task-specific Week 4 plan aligned to the syllabus sequence

**Out of Scope:**
- Month 2 implementation details (pipelines, SQL, dbt models)
- New design decisions not already documented in Week 3 artifacts

---

## Week 3 in one sentence

Week 3 converted the dataset strategy from Week 2 into a formal warehouse design: grains are locked, tables are typed and inventoried, and every MVP metric has a documented formula, grain, caveats, and source tables.

---

## Day 11 recap — Modeling foundations

### Tasks completed

- Tasks 11.1–11.4: grain spec, ERD text draft, table inventory, and glossary expansion

### What I did

I defined the row-level grain contracts for all six MVP warehouse tables, drafted a text-only ERD showing entities and cardinalities, classified all 9 tables by type (feature / rollup / dimension / bridge / geo), and added 10+ modeling terms to the glossary. This was the structural foundation that all metric specs in Days 12–14 built on.

### What I learned

Grain is not just an abstract Kimball concept — it is a hard constraint that prevents fact tables from becoming ambiguous query surfaces. The most important grain decision for this project was distinguishing the permits transaction grain (one event) from the zoning snapshot grain (one district × year × code). Both share conformed dimensions but answer fundamentally different questions and cannot be joined without re-aggregation. I also learned that documenting table types explicitly (feature vs rollup) is not just classification for its own sake — it tells future engineers what a table is for and protects it from being misused.

### Key takeaway

Grain definitions done right protect every downstream metric. Done wrong, they silently inflate counts, break joins, and make the product misleading without any obvious error to debug.

### Why this matters for the project

Day 11 gave every subsequent metric spec its anchor. Without the grain spec and table inventory, metric specs would have been written against vague table shapes rather than locked contracts. The failure modes documented in FM1 and FM2 now have names that can be referenced in code review.

### Day result

Six grain statements locked, nine tables typed and inventoried, two failure modes documented. Week 3 modeling work has a design foundation.

### Relevant artifacts

- [Grain spec](./modeling/grain_spec.md)
- [ERD text draft](./modeling/erd_text_draft.md)
- [Table inventory](./modeling/table_inventory.md)
- [Glossary (updated)](./glossary.md)

---

## Day 12 recap — Permits metric specs

### Tasks completed

- Tasks 12.1–12.5: metric spec template, permits monthly count, permits per land sq mi, permits composition, limitations register update

### What I did

I finalized the metric spec template after reviewing Kimball Ch. 1 and a government metric spec format (DOE EVMS) for structural inspiration. I then authored three permits metric specs: monthly count (simple additive count), permits per land sq mi (non-additive ratio, normalized by land-only area), and permits composition (count by canonical permit type group; share derived at query time). I updated the limitations register with two new entries: cancelled/voided permits still counted (L21) and a new cross-reference structure linking limitations to their metric specs.

### What I learned

The transition from "permits are feasible" (Week 2) to "here is the exact formula and grain for each metric" (Week 3) surfaces decisions that were implicit before. The non-additivity of `permits_per_sqmi_land` is an example: it is obvious in retrospect, but without writing the spec you would not catch that summing district intensity values across districts produces a meaningless number. I also learned that composition metrics should store counts and derive shares at query time — storing both creates redundancy and risks stale percentage columns.

### Key takeaway

Metric specs force precision that design discussions never achieve. Every formula has aggregation type implications, and every caveat in a metric spec is a future dbt test waiting to be written.

### Why this matters for the project

The permits metric specs are the direct inputs to Month 2 dbt mart models. Without them, model authors would have to re-derive these decisions under time pressure. With them, the grain, denominator policy, and quality checks are already documented.

### Day result

Three permits metric specs authored; limitations register hardened with L21 and metric spec cross-links.

### Relevant artifacts

- [Metric spec template](./templates/metric_spec_template.md)
- [Permits monthly count](./metrics/permits_monthly_count.md)
- [Permits per land sq mi](./metrics/permits_per_sqmi_land.md)
- [Permits composition](./metrics/permits_composition.md)
- [Limitations register](./limitations_register.md)

---

## Day 13 recap — Zoning metric specs + comparability plan finalized

### Tasks completed

- Tasks 13.1–13.4: zoning composition by year, zoning YoY churn, finalized comparability plan, limitations register update

### What I did

I authored two zoning metric specs and finalized the comparability plan. The composition metric documents the pre-aggregated snapshot grain (G2) and makes explicit that area is stored but share is derived. The churn metric documents the query-time self-join pattern (enforced by FM2 from the grain spec) and the vocab_stable flag dependency. The finalized comparability plan corrected the dimension table name (dim_zoning_code → dim_zoning per table inventory) and added links to the metric specs. The limitations register gained L22 (zoning Shape__Area CRS ambiguity) and updated cross-links.

### What I learned

Zoning metrics are the most constraint-laden specs in the project. Every calculation depends on conditions being met upstream (vocabulary stability, confirmed CRS, geometry validity) before the number can be trusted. This made writing the caveats more rigorous than for permits — the metric is not just "uncertain," it is explicitly invalid under certain conditions that must be flagged in the fact table.

### Key takeaway

A metric spec's caveats section is not fine print. For zoning, the vocab_stable caveat is a precondition for correctness, not a soft interpretive note. That distinction needs to be clear in the product, not just the documentation.

### Why this matters for the project

The zoning specs define exactly what the Month 2 pipeline needs to compute, flag, and store. The vocab_stable flag logic and the crosswalk table design are now documented upstream of any pipeline work.

### Day result

Two zoning metric specs authored; comparability plan promoted to final; limitations register updated with L22.

### Relevant artifacts

- [Zoning composition by year](./metrics/zoning_composition_by_year.md)
- [Zoning year-to-year churn](./metrics/zoning_year_to_year_churn.md)
- [Zoning comparability plan (final)](./zoning_comparability_plan.md)
- [Limitations register](./limitations_register.md)

---

## Day 14 recap — ACS metric specs + disclaimer library

### Tasks completed

- Tasks 14.1–14.3: ACS income proxy, ACS tenure proxy, standard disclaimer library

### What I did

I authored two ACS metric specs framed entirely as tract-level distribution metrics, not district-level KPIs (per D10). Both specs document the dual grain (G4 for storage, G6 for dashboard surface), the non-additivity of their core statistics, MAUP risk at district boundaries, and MOE retention requirements. The disclaimer library codified five standard disclaimer sentences and five forbidden claim examples, grounded in the ACS usage policy, zoning comparability plan, and permits metric specs.

### What I learned

The ACS metric specs required the most careful framing of the three source types. The policy work from Week 2 (D8, D9, D10) was the direct input — without having locked those decisions first, the metric specs would have had to rediscover them. The income suppression edge case (-666666666 in the Census API) is an example of a data quality issue that only becomes visible when you're forced to write a test ideas section.

### Key takeaway

ACS is the most tractable when treated as a context layer with explicit disclaimers rather than a measurable fact source. The disclaimer library makes that treatment enforceable at the point of output, not just in policy documents.

### Why this matters for the project

The disclaimer library is the enforcement mechanism for the ACS usage policy in real product copy. Without it, individual dashboard developers would have to re-derive appropriate language every time they add an ACS panel.

### Day result

Two ACS metric specs authored; standard disclaimer library created with five disclaimers and five forbidden claims.

### Relevant artifacts

- [ACS income proxy](./metrics/acs_income_proxy.md)
- [ACS tenure proxy](./metrics/acs_tenure_proxy.md)
- [Standard disclaimer library](./policies/disclaimer_library.md)

---

## Day 15 recap — Week 3 quality pass

### Tasks completed

- Tasks 15.1–15.3: cross-metric consistency check, docs index update, Week 3 recap

### What I did

I ran a cross-metric consistency check across all metric specs and modeling docs, identified five specific naming inconsistencies, and fixed them: (1) `stg_permits` → `fct_permits` in source tables of all permits specs; (2) `dim_permit_type` → `permit_category_groups` in permits_monthly_count and permits_per_sqmi_land dimensions; (3) `dim_zoning_code` → `dim_zoning` in the zoning comparability plan; (4) Planning District dimension in ACS specs corrected from bridge table to dim_district; (5) logged all fixes as D11 in the decision log. I refreshed the docs index with new Modeling specs and Metric specs sections, and wrote this recap.

### What I learned

The consistency pass caught naming drift that accumulated across separate writing sessions. The table name disagreements (stg vs fct, dim_zoning vs dim_zoning_code) are exactly the type of issue that causes Month 2 pipeline developers to implement the wrong table name and discover the error only when dbt tests fail. A single pass at the end of the week is insufficient for large documentation sets — the pattern to fix is to standardize table names in a canonical list (table inventory) before authoring metric specs, so all specs inherit the names from one source of truth.

### Key takeaway

Documentation consistency is a form of technical debt. Small naming drift across files is invisible individually but creates friction at implementation time — and it is far cheaper to fix in documentation than in running pipelines.

### Why this matters for the project

Week 3 closes with a consistent, cross-linked documentation set. Every metric has a spec; every spec links to its grain, source, and limitation entries; every table name now agrees with the table inventory. Month 2 can build from a stable foundation.

### Day result

Five consistency issues identified and fixed; docs index updated; Week 3 closed.

### Relevant artifacts

- [Decision log (D11)](./decision_log.md)
- [Docs index](./README.md)
- [Limitations register](./limitations_register.md)

---

## Cross-week synthesis

### What Week 3 accomplished

- It converted dataset feasibility (Week 2) into a formal warehouse design: locked grains, typed tables, and documented metric formulas.
- It produced seven MVP metric specs covering all three analytical paths (permits, zoning, ACS context).
- It resolved the most important modeling ambiguity: zoning and permits are separate fact tables with different grains, not a single combined fact.
- It codified the ACS tract-distribution presentation pattern into reusable disclaimers and forbidden claim examples.
- It closed a quality pass that standardized table naming across all documentation.

### What I learned across the week

- Grain decisions made in Day 11 directly shaped how caveats were written in Days 12–14. Getting the foundation right early paid off.
- Non-additivity is not a single concept: there are at least three distinct cases in this project (ratio metrics like permits_per_sqmi, medians like ACS income, and change metrics like zoning churn). Each requires different handling.
- Disclaimer libraries and forbidden claim lists are underrated documentation artifacts. They make policy enforceable at the point of output.

### Main Week 3 takeaway

Week 3 turned a source strategy into a warehouse design. By the end of the week, the project has a documented shape that an engineer could implement — grain contracts, fact table types, metric formulas, and quality expectations are all written down before any code exists.

---

## Modeling handoff into Week 4

Week 3 implies a specific Week 4 scope:

- The ERD text draft needs to become a visual Mermaid diagram for reviewability.
- The dataflow diagram (raw → staging → mart) has not yet been drawn; Week 4 is the right time.
- The metric specs and grain spec need a final self-audit to confirm no cross-spec gaps remain.
- The output product needs a view spec: what does the "district brief" and the "compare districts" view actually show?
- Traceability and cross-links need a final pass before Month 1 closes.

---

## Week 4 plan (task-specific)

- **Day 16: ERD diagram**
  - Task 16.1: create `docs/modeling/erd.md` (or `.png`) with a Mermaid ERD diagram derived from the text draft.
  - Task 16.2: run an ERD review checklist self-audit (grain, PKs, FK relationships, conformed dimensions).
  - Task 16.3: update decision log from any ERD-driven decisions.

- **Day 17: Dataflow diagram + map-first contract**
  - Task 17.1: create a high-level dataflow diagram (Mermaid) showing raw → staging → mart layers.
  - Task 17.2: write the "map-first ready" contract — what must be true for the map-first layer to be queryable.
  - Task 17.3: create a repo review checklist for Month 1 closeout.

- **Day 18: Documentation final pass**
  - Task 18.1: docs index final pass — no orphan docs, summaries accurate.
  - Task 18.2: traceability pass — confirm all metric specs link to limitations register entries; all limitation entries link to metric specs.
  - Task 18.3: consistency pass — terminology and naming alignment (second pass after D11 fixes).
  - Task 18.4: limitations register final hardening for Month 1.

- **Day 19: Product specs**
  - Task 19.1: define the "district brief" output spec — what the MVP narrative output looks like for one district.
  - Task 19.2: create the "compare districts" view spec.
  - Task 19.3: update learning resources for Week 4 diagram and product spec work.

- **Day 20: Month 1 closeout**
  - Task 20.1: write the Month 1 recap (executive summary of the full Month 1 documentation package).
  - Task 20.3: create the Month 1 release/tag in GitHub.

---

## Links

- Week 3 modeling foundations:
  - [Grain spec](./modeling/grain_spec.md)
  - [ERD text draft](./modeling/erd_text_draft.md)
  - [Table inventory](./modeling/table_inventory.md)
- Week 3 metric specs:
  - [Permits monthly count](./metrics/permits_monthly_count.md)
  - [Permits per land sq mi](./metrics/permits_per_sqmi_land.md)
  - [Permits composition](./metrics/permits_composition.md)
  - [Zoning composition by year](./metrics/zoning_composition_by_year.md)
  - [Zoning year-to-year churn](./metrics/zoning_year_to_year_churn.md)
  - [ACS income proxy](./metrics/acs_income_proxy.md)
  - [ACS tenure proxy](./metrics/acs_tenure_proxy.md)
- Week 3 decisions and policies:
  - [Zoning comparability plan (final)](./zoning_comparability_plan.md)
  - [Standard disclaimer library](./policies/disclaimer_library.md)
  - [Decision log (D11)](./decision_log.md)
- Cross-cutting:
  - [Limitations register](./limitations_register.md)
  - [Docs index](./README.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial draft for Task 15.3 (Week 3 recap + Week 4 plan) | Farid |
