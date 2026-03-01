# Rubrics Reference — Month 1

The universal rubric (5 criteria, 0–2 each, max 10) is defined in `CLAUDE.md`. This file contains the **task-specific checks for criterion 5 (Task Objective Mastery)** for every task, plus any additional notes that distinguish one task's grading from another.

When grading, always:
1. Check Pass/Fail gates first (artifact exists + Definition of Done met)
2. Score criteria 1–4 against the universal rubric
3. Use the task-specific checks below for criterion 5

---

## Universal Criterion Scoring Notes

### Consistency (Criterion 4)

When scoring Consistency (0–2), check alignment with `style_guide.md` and template usage:

**For all documentation artifacts:**
- File names follow lowercase_with_underscores convention
- Required sections present (Purpose, Scope, References where applicable)
- Resources cited using IDs from `resources.md` ([B3], [D7], etc.)
- Markdown formatting is consistent (heading levels, list styles, link formats)
- Cross-references use correct relative paths and resolve properly

**For memos, specs, and notes (check template compliance):**
- Header block present with all required metadata (Author, Created, Last Updated, Status/Source)
- Document structure matches the appropriate template (memo_template.md or notes_template.md)
- Assumptions section uses the specified table format (ID, Assumption, Impact if Wrong, Mitigation)
- Risks section uses the specified table format (ID, Risk, Likelihood, Impact, Mitigation) where applicable
- References section uses resource ID citation format ([B3], [D7])
- Change Log is present and maintained

**For code artifacts (Month 2+):**
- Follows Google Python Style Guide conventions
- PEP 8 compliant
- Docstrings present where required

**Scoring:**
- **2 points:** Fully consistent — follows all style guide rules AND template structure where applicable
- **1 point:** Mostly consistent — minor deviations (1-2 missing fields, inconsistent formatting, missing Change Log)
- **0 points:** Inconsistent — multiple violations (wrong file names, missing required sections, doesn't follow template structure)

---

## WEEK 1

### Day 1

**1.1 — Create GitHub repo**
- README includes: Overview, Locked Decisions, Month-1 Deliverables, Repo Structure, Work Process, Docs links.

**1.2 — Add baseline folder structure**
- Output aligns to task description and demonstrates the learning objective in your own words.

**1.3 — Add .gitignore + data policy**
- .gitignore blocks large spatial files (shp/gpkg) and raw downloads; policy states allowed exceptions (small samples).

**1.4 — Write README (v0)**
- README includes: Overview, Locked Decisions, Month-1 Deliverables, Repo Structure, Work Process, Docs links.

**1.5 — Create Docs Index**
- README includes the required sections listed above.
- Docs index has no orphan docs; every doc has 1-line summary and working link.

**1.6 — Add contribution workflow**
- CONTRIBUTING has actionable rules (branch prefixes, commit style, PR requirement) — not generic advice.

**1.7 — Add doc style guide**
- Output aligns to task description and demonstrates the learning objective in your own words.

**1.8 — Add doc templates**
- Templates match style guide required headers and include sections for assumptions/risks/links.

**1.9 — Add repo settings checklist**
- Evidence screenshot/doc shows settings clearly and is dated; checklist maps settings to GitHub UI paths.

**1.10 — Configure branch protection evidence**
- Evidence screenshot/doc shows settings clearly and is dated; checklist maps settings to GitHub UI paths.

---

### Day 2

**2.1 — Create learning library skeleton**
- Resources are pre-curated; each entry includes 1-sentence 'why' tied to Month-1 needs; no filler links.

**2.2 — Create bibliography format**
- Bibliography IDs are consistent and referenced from learning_resources/notes; includes access dates.

**2.3 — Define resource triage rules**
- Output aligns to task description and demonstrates the learning objective in your own words.

**2.4 — Populate initial resource set**
- Resources are pre-curated; each entry includes 1-sentence 'why' tied to Month-1 needs; no filler links.
- Bibliography IDs are consistent and referenced; includes access dates.

**2.5 — Kimball: Grain notes**
- Output aligns to task description and demonstrates the learning objective in your own words.

**2.6 — Kimball: Facts notes**
- Output aligns to task description and demonstrates the learning objective in your own words.

**2.7 — ACS: period estimates notes**
- Notes correctly state ACS as period estimates; warns against overlapping 5-year comparisons; includes phrasing you will use as caveat.

**2.8 — PostGIS: spatial primer notes**
- Notes accurately distinguish points vs polygons; explain spatial joins conceptually; mention why indexing matters.

**2.9 — Reference repo patterns (dbt/Git notes)**
- Output aligns to task description and demonstrates the learning objective in your own words.

**2.10 — Reference repo patterns (project structure)**
- Output aligns to task description and demonstrates the learning objective in your own words.

---

### Day 3

**3.1 — Draft scope memo (v1)**
- Scope/problem framing is non-technical, with explicit non-goals and measurable success criteria.

**3.2 — Write problem statement**
- Scope/problem framing is non-technical, with explicit non-goals and measurable success criteria.

**3.3 — Define Month-1 success criteria**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.4 — Create glossary (v0)**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.5 — List MVP datasets + rationale**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.6 — Draft data access notes**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.7 — Start assumptions log**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.8 — Create question backlog**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.9 — Create non-goals doc**
- Output aligns to task description and demonstrates the learning objective in your own words.

**3.10 — Create decision log**
- Each decision log entry includes alternatives and implications; no retroactive vague entries.

---

### Day 4

**4.1 — Create Week-1 grading rubric**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.2 — Add PR template**
- Templates enforce required fields and align to rubric; confirms they appear in GitHub UI.

**4.3 — Add issue templates (docs work)**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.4 — Configure issue chooser**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.5 — Add PR self-review checklist**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.6 — Create Week-1 exit checklist**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.7 — Define label taxonomy**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.8 — Create community health files**
- Output aligns to task description and demonstrates the learning objective in your own words.

**4.9 — Update docs navigation map**
- README includes the required sections.
- Docs index has no orphan docs; every doc has 1-line summary and working link.

**4.10 — Open PR for Week-1 WIP**
- Output aligns to task description and demonstrates the learning objective in your own words.

---

### Day 5

**5.1 — Create source catalog template**
- Templates match style guide required headers and include sections for assumptions/risks/links.

**5.2 — Create feasibility checklist template**
- Templates match style guide required headers and include sections for assumptions/risks/links.

**5.3 — Create data dictionary template**
- Templates match style guide required headers and include sections for assumptions/risks/links.

**5.4 — Draft feature vs rollup policy**
- Output aligns to task description and demonstrates the learning objective in your own words.

**5.5 — Draft land-area denominator policy**
- Output aligns to task description and demonstrates the learning objective in your own words.

**5.6 — Draft ACS usage policy**
- Notes correctly state ACS as period estimates; warns against overlapping 5-year comparisons; includes phrasing you will use as caveat.

**5.7 — Create limitations register (v0)**
- Limitations register includes severity + mitigation + when it will be addressed; avoids hand-wavy 'data may be messy'.

**5.8 — Create Week-1 recap doc**
- Output aligns to task description and demonstrates the learning objective in your own words.

**5.9 — Update learning library (Week-1)**
- Resources are pre-curated; each entry includes 1-sentence 'why' tied to Month-1 needs; no filler links.
- Bibliography IDs are consistent and referenced; includes access dates.

**5.10 — Merge Week-1 PR + tag release**
- Output aligns to task description and demonstrates the learning objective in your own words.

---

## WEEK 2

> **Universal Week 2+ requirement for criterion 5:** Every task must (a) directly address the 'Do:' part of the task description, not merely paraphrase the instructions, and (b) include an Assumptions/Risks section for any feasibility or comparability task.
>
> **Template compliance:** Source catalog entries, feasibility checklists, critical field dictionaries, and decision memos should follow the memo_template.md structure. Reading/resource notes should follow the notes_template.md structure. Check that the header block, Assumptions/Risks tables, and Change Log are present.

### Day 6 — Planning Districts

**6.1 — Review dataset metadata: Planning Districts**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, and top 3 risks.

**6.2 — Source catalog entry: Planning Districts**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, and top 3 risks.

**6.3 — Feasibility checklist: Planning Districts**
- Feasibility doc clearly states: chosen time field, geo linkage method, top blockers, and links to catalog.

**6.4 — Critical fields dictionary: Planning Districts**
- Critical fields doc marks required vs optional, expected null/invalid patterns, and links to catalog.

**6.5 — Land-only area evidence note**
- Feasibility doc clearly states: land-only choice, unit convention (sq mi), and where denominator will be stored.

**6.6 — Update limitations register (district spine)**
- Each limitation includes severity + mitigation + timeframe; language is specific (not vague).

**6.7 — Resource note: GIS boundaries & CRS**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

---

### Day 7 — L&I Permits

**7.1 — Review dataset metadata: L&I permits**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, and top 3 risks.

**7.2 — Source catalog entry: L&I permits**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, and top 3 risks.

**7.3 — Feasibility checklist: L&I permits**
- Feasibility doc clearly states: chosen time field, geo linkage method, top blockers, and links to catalog.

**7.4 — Critical fields dictionary: L&I permits**
- Critical fields doc marks required vs optional, expected null/invalid patterns, and links to catalog.

**7.5 — Permit category grouping decision memo**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**7.6 — Permits geocoding risk note**
- Feasibility doc clearly states: chosen time field, geo linkage method, top blockers, and links to catalog.

**7.7 — Update learning resources (permits/open data)**
- New resources are Tier-1/2; each has 1-sentence 'why relevant to Week 2'.

---

### Day 8 — Zoning

**8.1 — Review dataset metadata: Zoning**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, and top 3 risks.

**8.2 — Source catalog entry: Zoning**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, and top 3 risks.

**8.3 — Feasibility checklist: Zoning**
- Feasibility doc clearly states: chosen time field, geo linkage method, top blockers, and links to catalog.

**8.4 — Critical fields dictionary: Zoning**
- Critical fields doc marks required vs optional, expected null/invalid patterns, and links to catalog.

**8.5 — Zoning last-5-years window memo**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**8.6 — Year-to-year comparability plan (draft)**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**8.7 — Update limitations register (zoning)**
- Each limitation includes severity + mitigation + timeframe; language is specific (not vague).

---

### Day 9 — ACS

**9.1 — ACS methodology summary**
- Catalog includes access URL(s), time semantics (period estimates), candidate keys, cadence, and top 3 risks.

**9.2 — Source catalog entry: ACS context**
- Catalog includes access URL(s), time semantics, candidate keys, cadence, and top 3 risks.

**9.3 — Feasibility checklist: ACS context**
- Feasibility doc clearly states: supported contextual indicators, prohibited comparisons, and links to catalog.

**9.4 — Critical fields dictionary: ACS context**
- Critical fields doc marks required vs optional, expected null/invalid patterns, and links to catalog.

**9.5 — Boundary alignment note (ACS → Districts)**
- Feasibility doc clearly states: alignment approach, known risks (slivers, MAUP), and links to catalog.

**9.6 — Uncertainty messaging note (MOE-aware)**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**9.7 — Update learning resources (ACS additions)**
- New resources are Tier-1/2; each has 1-sentence 'why relevant to Week 2'.

---

### Day 10

**10.1 — Update docs index (Week 2)**
- Docs index updated; no orphan docs; summaries accurate.

**10.2 — Consistency check sweep**
- Output directly addresses the 'Do:' part. Issues are specific; not just "updated."

**10.3 — Traceability audit sweep**
- Catalog includes access URL(s), geometry, time semantics, candidate keys, cadence, top 3 risks.
- Feasibility doc clearly states: chosen time field, geo linkage method, top blockers, links to catalog.
- Critical fields doc marks required vs optional, null/invalid patterns, links to catalog.

**10.4 — Limitations register hardening**
- Each limitation includes severity + mitigation + timeframe; language is specific (not vague).

**10.5 — Week-2 recap + Week-3 plan**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**10.6 — Open PR: Week-2 artifacts**
- PR description links recap + key artifacts; checklist completed; commits logically grouped.

**10.7 — Optional: Tag Week-2 milestone**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

---

## WEEK 3

> **Universal Week 3 requirement for criterion 5:** Must directly address the 'Do:' part of the task. Must include an Assumptions/Risks section for modeling and comparability tasks.
>
> **Template compliance:** Metric specs, modeling docs, and policy documents should follow memo_template.md structure. Reading notes should follow notes_template.md structure.

### Day 11

**11.1 — Kimball: Grain deep dive + apply to project**
- Grain statements are single-sentence, unambiguous, and include an example key.

**11.2 — Identify entities + relationships (text-only ERD draft)**
- Diagram matches written grain/metric specs; entities and relationships are consistent.

**11.3 — Define 'feature vs rollup' table list**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**11.4 — Add modeling glossary expansions**
- Diagram matches written grain/metric specs; entities and relationships are consistent.

---

### Day 12

**12.1 — Metric spec template (final)**
- Metric definition includes name, purpose, grain, numerator/denominator (if any), and caveats.

**12.2 — Permits metric spec: monthly count**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**12.3 — Permits metric spec: permits per land sq mi**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**12.4 — Permits composition metric spec**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**12.5 — Update limitations register (permits metrics)**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

---

### Day 13

**13.1 — Zoning metric spec: composition by year**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.
- Explicitly distinguishes real change vs schema/vintage artifact; documents mapping/flags.

**13.2 — Zoning metric spec: year-to-year churn**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.
- Explicitly distinguishes real change vs schema/vintage artifact; documents mapping/flags.

**13.3 — Finalize zoning comparability plan**
- Explicitly distinguishes real change vs schema/vintage artifact; documents mapping/flags.

**13.4 — Update limitations register (zoning metrics)**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.
- Explicitly distinguishes real change vs schema/vintage artifact; documents mapping/flags.

---

### Day 14

**14.1 — ACS metric spec: income proxy**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**14.2 — ACS metric spec: tenure proxy**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**14.3 — Standard disclaimer library**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**14.4 — Update learning resources (Week 3 modeling)**
- Diagram matches written grain/metric specs; entities and relationships are consistent.

---

### Day 15

**15.1 — Cross-metric consistency check**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**15.2 — Docs index update (Week 3)**
- Docs index updated; no orphan docs; summaries accurate.

**15.3 — Week 3 recap + Week 4 plan**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**15.4 — Open PR: Week 3 specs**
- PR links to recap and key specs; checklist completed; commits logically grouped.

---

## WEEK 4

> **Universal Week 4 requirement for criterion 5:** Must directly address the 'Do:' part of the task. Must include an Assumptions/Risks section for modeling and comparability tasks.
>
> **Template compliance:** All specs, recaps, and policy documents should follow memo_template.md structure.

### Day 16

**16.1 — Create ERD diagram (Mermaid)**
- Diagram matches written grain/metric specs; entities and relationships are consistent.

**16.2 — ERD review checklist self-audit**
- Diagram matches written grain/metric specs; entities and relationships are consistent.

**16.3 — Update decision log from ERD work**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

---

### Day 17

**17.1 — Create high-level dataflow diagram**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**17.2 — Write 'map-first ready' contract**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**17.3 — Create repo review checklist (Month 1)**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

---

### Day 18

**18.1 — Docs index final pass**
- Docs index updated; no orphan docs; summaries accurate.

**18.2 — Traceability pass: cross-links**
- Metric definition includes name, purpose, grain, numerator/denominator, and caveats.

**18.3 — Consistency pass: terminology & naming**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**18.4 — Limitations register final hardening**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

---

### Day 19

**19.1 — Define 'district brief' output spec**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**19.2 — Create 'compare districts' view spec**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**19.3 — Update learning resources (Week 4)**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

---

### Day 20

**20.1 — Month-1 recap (executive summary)**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.

**20.2 — Open PR: Month-1 submission**
- PR links to recap and key specs; checklist completed; commits logically grouped.

**20.3 — Create Month-1 release/tag**
- Output directly addresses the 'Do:' part. Includes Assumptions/Risks section.