# Week 2 recap + Week 3 plan

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Draft

---

## Purpose

This recap consolidates Week 2 dataset onboarding outputs into one handoff
document, captures what was accomplished and learned each day, and defines a
concrete Week 3 execution plan for modeling and metric spec work. It is written
for both future-me and a reviewer who needs to understand how Week 2 changed
the shape of the project.

---

## Scope

**In Scope:**
- Week 2 artifacts for district spine, permits, zoning, and ACS context
- What was accomplished each day, what was learned, and what carries forward
- Cross-cutting decisions and constraints that now govern Week 3 specs
- A task-specific Week 3 plan aligned to the syllabus sequence

**Out of Scope:**
- New technical design decisions not already documented in Week 2 artifacts
- Month 2 implementation details (pipelines, SQL, dbt models)

---

## Week 2 in one sentence

Week 2 converted the project from a high-level idea about Philadelphia district
change into a constrained dataset strategy with explicit source choices, field
rules, feasibility limits, and comparability guardrails.

---

## Day 6 recap â€” Planning districts as the district spine

### Tasks completed

- Tasks 6.1-6.7: metadata summary, source catalog, feasibility checklist,
  critical fields dictionary, land-only area note, limitations update, and GIS
  boundaries/CRS note

### What I did

I profiled the planning districts layer as the shared geographic backbone for
the entire warehouse. That work included documenting the raw metadata, writing
the source catalog, testing whether the geometry is fit for district-first
rollups, defining the critical fields, locking the land-only denominator
decision, and writing supporting GIS notes on CRS and geometry validity.

### What I learned

The planning district file is small and conceptually simple, but it carries
outsized modeling risk. The local GeoJSON extract does not perfectly match the
official schema, which means the natural key strategy cannot be treated as
settled yet. I also learned that land area cannot be treated as a casual field:
without CRS validation, any area-derived metric can be systematically wrong.

### Key takeaway

The district layer is not just a map boundary. It is the warehouse's shared
spatial spine, and its keying, CRS, and area logic affect every downstream
metric.

### Why this matters for the project

If the district dimension is wrong, both permitting and zoning analytics will
be wrong in the same way. Getting the district spine right now protects every
future join, every district rollup, and every land-normalized metric.

### Day result

The planning districts layer is approved as the warehouse's district spine,
subject to Month 2 confirmation of the authoritative natural key, CRS, and
boundary version.

### Relevant artifacts

- [Planning Districts metadata summary](./source_catalog/planning_districts_metadata_summary.md)
- [Planning Districts source catalog](./source_catalog/planning_districts.md)
- [Planning Districts feasibility](./feasibility/planning_districts_feasibility.md)
- [Planning Districts critical fields dictionary](./data_dictionary/planning_districts_critical_fields.md)
- [Land-only area evidence note](./feasibility/land_only_area_note.md)
- [GIS boundaries and CRS notes](../notes/gis/gis_boundaries_crs_notes.md)
- [Limitations register](./limitations_register.md)

---

## Day 7 recap â€” Permits as the physical-change fact path

### Tasks completed

- Tasks 7.1-7.7: metadata summary, source catalog, feasibility checklist,
  critical fields dictionary, permit grouping memo, geocoding risk note, and
  learning-resource updates

### What I did

I profiled the L&I permits dataset, documented how it can be accessed and used,
tested whether it can support district assignment and monthly analysis, defined
the critical fields, chose an MVP grouping philosophy for permit composition,
and documented geocoding risk and open-data resource additions.

### What I learned

Permits are the clearest source for physical activity change, but they are still
administrative records rather than ground truth. That means date choice,
business key choice, category stability, and geocoding quality all materially
change the story the fact table will tell. I also learned that the right
question for MVP is not "can permits do everything?" but "which parts of permits
are stable enough to support district-month metrics without over-claiming?"

### Key takeaway

The permits path is feasible for MVP if it is tightly scoped: use
`permitissuedate` as the canonical time field, treat `permitnumber` as the
business key, measure district assignment quality, and keep composition logic
anchored to stable fields like `permittype`.

### Why this matters for the project

This work effectively defines one of the two core fact-table tracks for Week 3:
the permitting activity fact. It establishes what counts as a reliable event,
how events attach to districts, and how permit categories can be grouped
without creating fake trend changes from label drift.

### Day result

Permits are approved as the MVP physical-change source, with explicit controls
around event date, district assignment quality, and category stability.

### Relevant artifacts

- [L&I permits metadata summary](./source_catalog/li_permits_metadata_summary.md)
- [L&I permits source catalog](./source_catalog/li_permits.md)
- [L&I permits feasibility](./feasibility/li_permits_feasibility.md)
- [L&I permits critical fields dictionary](./data_dictionary/li_permits_critical_fields.md)
- [Permit category grouping memo](./decisions/permit_category_grouping_memo.md)
- [Permits geocoding risk note](./feasibility/permits_geocoding_risk_note.md)
- [Learning resources](./learning_resources.md)
- [Bibliography](./bibliography.md)

---

## Day 8 recap â€” Zoning as the regulatory-change fact path

### Tasks completed

- Tasks 8.1-8.7: metadata summary, source catalog, feasibility checklist,
  critical fields dictionary, 5-year window memo, comparability plan draft, and
  limitations update

### What I did

I profiled the zoning base district vintages, wrote the source catalog and
feasibility assessment, documented the critical fields, chose the MVP time
window for zoning analysis, and drafted a comparability plan for year-to-year
schema and vocabulary changes. I also updated the limitations register with
zoning-specific comparability risks.

### What I learned

Zoning data cannot be treated like an event stream. It is a sequence of
periodic snapshots, and most of the hard work is not just loading polygons but
determining whether a year-to-year comparison is even valid. Code drift,
slivers, changing geometry segmentation, and broad-category instability can all
manufacture apparent "change" if they are not controlled.

### Key takeaway

The zoning path is a distinct analytical track from permits. It should be
modeled as a periodic snapshot fact with strict comparability rules, a bounded
MVP window (2021-2025), and explicit "do not claim" conditions when code
mapping is unresolved.

### Why this matters for the project

This work defines the second core fact-table track for Week 3: the zoning
regulatory environment fact. It prevents the project from confusing regulatory
classification change with actual physical development activity, which is a
critical distinction for credible district-change analysis.

### Day result

Zoning is approved for MVP only as a constrained periodic-snapshot source, with
the 2021-2025 window fixed and comparability logic deferred into explicit
mapping and flagging rules.

### Relevant artifacts

- [Zoning metadata summary](./source_catalog/zoning_base_districts_metadata_summary.md)
- [Zoning source catalog](./source_catalog/zoning_base_districts.md)
- [Zoning feasibility](./feasibility/zoning_feasibility.md)
- [Zoning critical fields dictionary](./data_dictionary/zoning_critical_fields.md)
- [Zoning last-5-years window memo](./decisions/zoning_window_last5y.md)
- [Zoning comparability plan (draft)](./zoning_comparability_plan_draft.md)
- [Limitations register](./limitations_register.md)

---

## Day 9 recap â€” ACS as contextual, caveated support

### Tasks completed

- Tasks 9.1-9.7: methodology summary, source catalog, feasibility checklist,
  critical fields dictionary, boundary alignment note, MOE-aware messaging note,
  and learning-resource updates

### What I did

I documented ACS methodology, built the source catalog and feasibility
checklist, defined the critical fields, wrote the tract-to-district alignment
approach, captured MOE-aware messaging guidance, updated the learning library
with ACS-specific resources, and locked a presentation decision: the dashboard
will not aggregate ACS indicators to district-level single values. Instead, when
users interact with a planning district, ACS context is shown as tract-level
distributions (for example, histogram bins like tract counts in the 80k-100k
income range), with MOE-aware interpretation. The tract-to-district alignment
logic remains documented as an analytical method/caveat reference, not as a
published district-level ACS KPI path for MVP dashboards.

### What I learned

ACS requires more interpretive discipline than the other Week 2 sources. It is
not a year-specific event dataset, it does not naturally align to planning
districts, and it should not be used to make causal claims about permits or
zoning. I also learned that uncertainty communication is part of the data model
itself here: non-overlapping periods, area-weighted interpolation caveats, MAUP,
sliver handling, and MOE-aware disclaimers all belong in the product logic.
Most importantly, forcing ACS into district-level aggregated KPIs creates false
precision for non-additive indicators, so a tract-distribution presentation is
more honest and easier to explain.

### Key takeaway

ACS is viable for contextual interpretation, not for casual trend storytelling.
It supports district context only when period labels, weighting assumptions, and
uncertainty messaging are explicit, and when the dashboard presents tract-level
distributions rather than fabricated district-level aggregates.

### Why this matters for the project

This keeps the project honest. ACS adds demographic context around district
change, but only if it is positioned as context rather than proof of drivers or
causes. That distinction protects the credibility of later dashboards and metric
specs.

### Day result

ACS is approved as a context layer with strict usage boundaries, not as a
peer fact source to permits or zoning. The warehouse keeps tract-level ACS
estimates plus MOE, and the dashboard presents district context via tract
distribution summaries on hover, not district-level aggregate ACS metrics.

### Relevant artifacts

- [ACS methodology summary](./source_catalog/acs_context_methodology_summary.md)
- [ACS source catalog](./source_catalog/acs_context.md)
- [ACS feasibility](./feasibility/acs_feasibility.md)
- [ACS critical fields dictionary](./data_dictionary/acs_critical_fields.md)
- [ACS to district alignment note](./feasibility/acs_to_district_alignment_note.md)
- [ACS uncertainty messaging notes](../notes/acs_uncertainty_messaging_notes.md)
- [Decision log (D9-D10)](./decision_log.md)
- [Learning resources](./learning_resources.md)
- [Bibliography](./bibliography.md)

---

## Day 10 recap â€” Closeout, hardening, and handoff to Week 3

### Tasks completed

- Tasks 10.1, 10.4, and 10.5: docs index refresh, limitations hardening, and
  recap/Week 3 planning

### What I did

I refreshed the docs index so Week 2 artifacts are discoverable, hardened the
limitations register into a more complete and specific risk log, and wrote this
recap to hand off Week 2 outputs into Week 3 modeling work.

### What I learned

Finishing the week was not just an administrative cleanup step. It clarified
that "feasible for MVP" does not mean "risk-free." The project is viable because
the known constraints are now documented, linked, and ready to be enforced in
metric specs rather than left implicit.

### Key takeaway

Week 2 ended with a stronger project boundary: the sources are usable, the
limitations are explicit, and the next modeling decisions now have a documented
constraint set to inherit.

### Why this matters for the project

This is the bridge from source understanding to warehouse design. Week 3 can now
focus on grain, facts, dimensions, and metric definitions without re-litigating
which datasets are in scope or what their major caveats are.

### Day result

Week 2 closed with a usable documentation baseline: source choices are locked,
major risks are visible, and the modeling phase can begin from explicit
constraints instead of assumptions.

### Relevant artifacts

- [Docs index](./README.md)
- [Limitations register](./limitations_register.md)
- [Learning resources](./learning_resources.md)
- [Bibliography](./bibliography.md)
- [Week 2 recap + Week 3 plan](./week2_recap.md)

---

## Cross-week synthesis

### What Week 2 accomplished

- It narrowed the warehouse to four reviewed MVP sources instead of a vague pool
  of possible Philly datasets.
- It established two clear analytical fact paths entering Week 3:
  permitting activity change and zoning regulatory change.
- It defined ACS as a contextual support layer rather than a third equivalent
  event/change fact.
- It moved major source uncertainty out of intuition and into documented
  feasibility checks, field dictionaries, decisions, and limitations.

### What I learned across the week

- Dataset onboarding is not just metadata collection; it is where warehouse
  design constraints first become visible.
- Each source has a different failure mode:
  spatial/key risk for districts, administrative/quality risk for permits,
  comparability risk for zoning, and interpretation/uncertainty risk for ACS.
- "Use with constraints" is the right Week 2 conclusion for all four sources,
  and those constraints now need to be encoded in Week 3 grain and metric work.

### Main Week 2 takeaway

Week 2 made the project substantially more concrete. By the end of the week, the
warehouse no longer had just a topic and some datasets; it had a source strategy,
two fact directions, a constrained role for ACS, and a living limitations
framework that tells Week 3 what must be preserved.

---

## Modeling handoff into Week 3

Week 2 now implies a clearer warehouse shape than existed at the start of the
week.

- Shared district spine:
  `dim_district` will be the common geographic join target for both major fact
  paths, pending final key and CRS confirmation from the planning districts
  work.
- Shared time logic, different grains:
  permitting work points toward a district-month path, while zoning work points
  toward a district-vintage-year path. Both need a conformed time dimension,
  but they do not share the same analytical grain.
- Fact path 1:
  permits now have enough documented rules to support a physical-change fact
  table centered on activity by district and month.
- Fact path 2:
  zoning now has enough documented rules to support a regulatory-change fact
  table centered on district-year composition and churn, with comparability
  flags.
- Context layer:
  ACS has a defined support role, but its caveats mean it remains a
  context-providing layer shown as tract-level distributions per district
  interaction rather than district-level aggregate KPIs; warehouse storage keeps
  tract-level estimates with MOE.

This is the main practical outcome of Week 2: the project enters Week 3 with a
more defensible model boundary, not just more documentation.

---

## Week 3 plan (task-specific)

- **Day 11: Modeling foundations**
  - Task 11.1: create `docs/modeling/grain_spec.md` with 5 unambiguous grain statements and example keys.
  - Task 11.2: create `docs/modeling/erd_text_draft.md` with entities, join keys, and cardinalities.
  - Task 11.3: create `docs/modeling/table_inventory.md` classifying feature vs rollup tables.
  - Task 11.4: update `docs/glossary.md` with modeling terms needed by the ERD and metric specs.

- **Day 12: Permits metric specs**
  - Task 12.1: finalize `docs/templates/metric_spec_template.md` to standardize all downstream metric docs.
  - Task 12.2 to 12.4: author permits metric specs for monthly count, permits per land sq mi, and composition.
  - Task 12.5: update `docs/limitations_register.md` with permits-metric-specific caveats from spec drafting.

- **Day 13: Zoning metric specs**
  - Task 13.1 and 13.2: define zoning composition and YoY churn metrics with comparability flags.
  - Task 13.3: finalize `docs/zoning_comparability_plan.md` from the draft.
  - Task 13.4: update `docs/limitations_register.md` for zoning-metric interpretation risks.

- **Day 14: ACS metric specs and disclaimer library**
  - Task 14.1 and 14.2: define ACS proxy metrics as tract-level distribution/context metrics with non-overlap and non-additivity caveats embedded (no district-level aggregate ACS KPI).
  - Task 14.3: create `docs/policies/disclaimer_library.md` with reusable ACS/zoning disclaimers and forbidden-claim examples.
  - Task 14.4: update `docs/learning_resources.md` and `docs/bibliography.md` for Week 3 modeling resources.

- **Day 15: Week 3 quality pass**
  - Task 15.1: run cross-metric consistency checks across grain, denominator, and caveat language.
  - Task 15.2: refresh `docs/README.md` to prevent orphan docs after Week 3 artifact growth.
  - Task 15.3: publish Week 3 recap with a concrete Week 4 plan.

---

## Links

- Week 2 planning districts set:
  - [Planning Districts metadata summary](./source_catalog/planning_districts_metadata_summary.md)
  - [Planning Districts source catalog](./source_catalog/planning_districts.md)
  - [Planning Districts feasibility](./feasibility/planning_districts_feasibility.md)
  - [Planning Districts critical fields dictionary](./data_dictionary/planning_districts_critical_fields.md)
- Week 2 permits set:
  - [L&I permits metadata summary](./source_catalog/li_permits_metadata_summary.md)
  - [L&I permits source catalog](./source_catalog/li_permits.md)
  - [L&I permits feasibility](./feasibility/li_permits_feasibility.md)
  - [L&I permits critical fields dictionary](./data_dictionary/li_permits_critical_fields.md)
  - [Permit category grouping memo](./decisions/permit_category_grouping_memo.md)
  - [Permits geocoding risk note](./feasibility/permits_geocoding_risk_note.md)
- Week 2 zoning set:
  - [Zoning metadata summary](./source_catalog/zoning_base_districts_metadata_summary.md)
  - [Zoning source catalog](./source_catalog/zoning_base_districts.md)
  - [Zoning feasibility](./feasibility/zoning_feasibility.md)
  - [Zoning critical fields dictionary](./data_dictionary/zoning_critical_fields.md)
  - [Zoning last-5-years window memo](./decisions/zoning_window_last5y.md)
  - [Zoning comparability plan (draft)](./zoning_comparability_plan_draft.md)
- Week 2 ACS set:
  - [ACS methodology summary](./source_catalog/acs_context_methodology_summary.md)
  - [ACS source catalog](./source_catalog/acs_context.md)
  - [ACS feasibility](./feasibility/acs_feasibility.md)
  - [ACS critical fields dictionary](./data_dictionary/acs_critical_fields.md)
  - [ACS to district alignment note](./feasibility/acs_to_district_alignment_note.md)
  - [ACS uncertainty messaging notes](../notes/acs_uncertainty_messaging_notes.md)
- Cross-cutting:
  - [Limitations register](./limitations_register.md)
  - [Learning resources](./learning_resources.md)
  - [Bibliography](./bibliography.md)
  - [Docs index](./README.md)

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial draft for Task 10.5 (Week 2 recap + Week 3 plan) | Farid |
| 2026-03-08 | Expanded recap into day-by-day narrative with learning, takeaway, and project-importance sections | Farid |
| 2026-03-08 | Added reviewer-facing polish pass with task coverage, day results, and explicit Week 3 modeling handoff | Farid |
| 2026-03-08 | Added full consistency sanity pass updates: aligned ACS source/feasibility/policy docs with D8-D10 and corrected ERD land-area field naming (land_area_sqmi) | Farid |
