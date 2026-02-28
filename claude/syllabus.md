# Syllabus Reference — Month 1

All tasks are listed by Week → Day → Task. For each task, the key fields are:
- **Task ID** and **Name**
- **Description** (the Read/Do instructions)
- **Learning Objective**
- **Definition of Done** (the exact pass criteria)
- **Deliverable Artifacts** (the exact file paths that must exist)
- **Reading Resources** / **Video Resources** (IDs — resolve in `.claude/resources.md`)

---

## WEEK 1 — Repo Setup + Conceptual Foundations

### Day 1 — GitHub Repo + Documentation Infrastructure

---

**Task 1.1 — Create GitHub repo**
- Description: Read D8 (Git basics) + skim D12 (protected branches). Create the GitHub repo, set description/topics, confirm default branch name.
- Learning Objective: Create a reviewable workspace and adopt a default workflow mindset.
- Definition of Done: Repo exists on GitHub with a clear description and at least 3 topics/tags. Default branch is set and visible. README placeholder committed.
- Deliverables: `(GitHub) repo created; README.md (placeholder commit)`
- Reading: D8, D12 | Video: V6

---

**Task 1.2 — Add baseline folder structure**
- Description: Read R1 (cookiecutter DS) for structure ideas. Create baseline folders for docs/notes/assets/data/. Add .keep files where needed.
- Learning Objective: Establish a consistent place for specs, notes, and evidence artifacts.
- Definition of Done: Folders exist: docs/, notes/, assets/, data/, .github/. Each has a .keep so structure is tracked. README references the structure.
- Deliverables: `docs/.keep, notes/.keep, assets/.keep, data/.keep, .github/.keep`
- Reading: R1

---

**Task 1.3 — Add .gitignore + data policy**
- Description: Read D15 (ignoring files). Add a .gitignore for data projects and write a short data storage policy.
- Learning Objective: Prevent large/raw data from entering version control; make data handling explicit.
- Definition of Done: .gitignore blocks common data outputs (*.gpkg, *.shp, *.csv if large) and temp files. Data policy states rules + exceptions.
- Deliverables: `.gitignore, docs/policies/data_storage_policy.md`
- Reading: D15

---

**Task 1.4 — Write README (v0)**
- Description: Read D7 (review checklist mindset). Write README v0 with: project purpose, locked decisions, Month-1 outcomes, repo map, and how you'll work.
- Learning Objective: Make the project understandable to a reviewer in 2 minutes.
- Definition of Done: README includes sections: Overview, Locked Decisions, Month-1 Deliverables, Repo Structure, How to Contribute/Work, Links to Docs Index.
- Deliverables: `README.md`
- Reading: D7

---

**Task 1.5 — Create Docs Index**
- Description: Create docs index (single TOC) linking to all docs created so far with 1-line summaries.
- Learning Objective: Ensure reviewers can find artifacts quickly.
- Definition of Done: docs/README.md links to every file in docs/ (no orphans) and includes 1-line summary per document.
- Deliverables: `docs/README.md`

---

**Task 1.6 — Add contribution workflow**
- Description: Read/Watch D8 + V6. Write CONTRIBUTING rules: branch naming, commit hygiene, PR requirement, and how you'll request review.
- Learning Objective: Adopt a repeatable workflow suitable for team codebases.
- Definition of Done: CONTRIBUTING specifies branch prefix rules, commit message pattern, PR checklist expectation, and 'no direct commits to main'.
- Deliverables: `CONTRIBUTING.md`
- Reading: D8 | Video: V6

---

**Task 1.7 — Add doc style guide**
- Description: Read D7. Write a doc style guide: naming conventions, required headers, how to record assumptions/decisions, how to reference resources by ID.
- Learning Objective: Make future specs consistent and easy to review.
- Definition of Done: Style guide includes file naming rules, required sections for memos/specs/notes, and a convention for citing resources (IDs from Resources tab).
- Deliverables: `docs/style_guide.md`
- Reading: D7

---

**Task 1.8 — Add doc templates**
- Description: Create reusable templates aligned with the style guide (memo + notes).
- Learning Objective: Speed up future writing while improving consistency.
- Definition of Done: Templates exist and match required headers from style guide; include placeholder sections for assumptions/risks/links.
- Deliverables: `docs/templates/memo_template.md, docs/templates/notes_template.md`

---

**Task 1.9 — Add repo settings checklist**
- Description: Read D12. Create a checklist of repo settings you intend to apply (branch protection, PR requirements, etc.).
- Learning Objective: Make GitHub settings auditable (reviewable as artifacts).
- Definition of Done: Checklist lists each setting and where to configure it (menu path). Includes 'evidence artifact' requirement.
- Deliverables: `docs/repo_settings_checklist.md`
- Reading: D12 | Video: V7

---

**Task 1.10 — Configure branch protection evidence**
- Description: Read D12. Apply settings if possible; capture evidence (screenshot or written confirmation).
- Learning Objective: Practice lightweight governance and traceability.
- Definition of Done: Either (A) screenshot of branch protection settings saved, or (B) doc explains which settings are not available and why.
- Deliverables: `assets/screenshots/branch_protection.png OR docs/repo_settings_applied.md`
- Reading: D12 | Video: V7

---

### Day 2 — Learning Library + Conceptual Notes

---

**Task 2.1 — Create learning library skeleton**
- Description: Create the structure of your learning library (categories only). Then add placeholders for specific curated resources referenced in tasks 2.4–2.10.
- Learning Objective: Create an organized place to store curated learning materials tied to project needs.
- Definition of Done: `docs/learning_resources.md` contains headings for: Modeling, Postgres/DB design, GIS/PostGIS, ACS, Git/GitHub workflow, dbt, Metabase, Philly datasets; each section has a short 'Why this matters for this project' line.
- Deliverables: `docs/learning_resources.md`

---

**Task 2.2 — Create bibliography format**
- Description: Create a consistent bibliography format for all resources. Add entries for D1 and D2 as examples.
- Learning Objective: Make all sources auditable and easy to reference from notes/specs.
- Definition of Done: `docs/bibliography.md` defines required fields (ID, title, author/org, type, URL, date accessed, why relevant). Includes at least 2 filled example entries (D1, D2).
- Deliverables: `docs/bibliography.md`
- Reading: D1, D2

---

**Task 2.3 — Define resource triage rules**
- Description: Write your source-quality rules. Use ACS guidance and official docs as examples of Tier-1 sources; define what requires corroboration.
- Learning Objective: Learn to prioritize primary sources and avoid low-quality rabbit holes.
- Definition of Done: `notes/resource_triage_rules.md` defines Tier 1/2/3 sources, gives 2 examples per tier, and includes a rule like: 'blogs require confirmation from Tier-1/2 for claims used in specs'.
- Deliverables: `notes/resource_triage_rules.md`
- Reading: D2, D11

---

**Task 2.4 — Populate initial resource set (incl. foundational books)**
- Description: Populate your learning library with the curated starter pack (minimum: 12 readings + 6 videos), grouped into the categories from 2.1.
- Learning Objective: Start with a focused curriculum matched to your Month-1 needs.
- Definition of Done: `docs/learning_resources.md` lists at least: B1, B2, B3, B5, B10; D1, D2, D3, D4, D8, D9, D10, D11; R1, R2; V1, V3, V4, V5. Each entry has a 1-sentence 'why'.
- Deliverables: `docs/learning_resources.md (updated), docs/bibliography.md (updated)`
- Reading: B1, B2, B3, B5, B10, D1, D2, D3, D4, D8, D9, D10, D11, R1, R2 | Video: V1, V3, V4, V5

---

**Task 2.5 — Kimball: Grain notes**
- Description: Read Kimball's Dimensional Modeling Techniques overview + Grain. Write notes mapping 'grain' to this project's planned tables.
- Learning Objective: Be able to declare grain precisely and avoid mixed-grain joins later.
- Definition of Done: `notes/kimball_grain_notes.md` includes: (a) 3 bullet summary of grain, (b) your project grains (permit event; zoning polygon-vintage; district-month; district-year), (c) 2 'common failure modes' you will avoid.
- Deliverables: `notes/kimball_grain_notes.md`
- Reading: B1

---

**Task 2.6 — Kimball: Facts notes**
- Description: Read Kimball 'Facts for Measurement'. Write notes defining what counts as a fact in your domain.
- Learning Objective: Separate events/measures from descriptive context.
- Definition of Done: `notes/kimball_facts_notes.md` defines at least 3 candidate facts and explicitly states the measurement unit and grain for each.
- Deliverables: `notes/kimball_facts_notes.md`
- Reading: B1

---

**Task 2.7 — ACS: period estimates notes**
- Description: Read ACS period-estimates guidance + ACS comparing guidance. Write a one-page 'do/don't' list for using ACS in your project.
- Learning Objective: Avoid invalid time comparisons and over-claiming change.
- Definition of Done: `notes/acs_period_estimates_notes.md` includes: (a) definition of period estimate, (b) rule against overlapping 5-year comparisons, (c) how you'll phrase demographic caveats in the project.
- Deliverables: `notes/acs_period_estimates_notes.md`
- Reading: D1, D2

---

**Task 2.8 — PostGIS: spatial primer notes**
- Description: Read PostGIS intro + spatial index FAQ. Write conceptual notes focusing on: points vs polygons, spatial joins, and why index-aware functions matter.
- Learning Objective: Build correct mental model for map-ready tables.
- Definition of Done: `notes/postgis_spatial_primer_notes.md` includes: (a) 5 key concepts, (b) 2 examples of 'map-ready' tables you'll keep, (c) 1 paragraph on why spatial indexing matters for joins.
- Deliverables: `notes/postgis_spatial_primer_notes.md`
- Reading: D3, D4

---

**Task 2.9 — Reference repo patterns (dbt / Git notes)**
- Description: Watch Missing Semester Git lecture; write notes focusing on branching, commits, and how history is modeled.
- Learning Objective: Adopt a repeatable solo PR workflow.
- Definition of Done: `notes/missing_semester_git_notes.md` includes: your branch strategy (even solo) + 5 'rules you will follow' (small commits, PR checklist, etc.).
- Deliverables: `notes/missing_semester_git_notes.md`
- Reading: D8 | Video: V4

---

**Task 2.10 — Reference repo patterns (project structure)**
- Description: Skim cookiecutter-data-science and dbt-labs/jaffle-shop. Write 5 patterns from each you will emulate.
- Learning Objective: Learn what 'good project documentation' looks like in practice.
- Definition of Done: `notes/ref_patterns_cookiecutter_ds.md` and `notes/ref_patterns_jaffle_shop.md` each list 5 patterns + how you'll apply them to this project in Month 1.
- Deliverables: `notes/ref_patterns_cookiecutter_ds.md, notes/ref_patterns_jaffle_shop.md`
- Reading: R1, R2

---

### Day 3 — Project Scoping + Domain Context

---

**Task 3.1 — Draft scope memo (v1)**
- Description: Read B3 intro/lifecycle sections. Draft scope memo v1 (goals, non-goals, Month-1 deliverables).
- Learning Objective: Translate an idea into a constrained deliverable plan.
- Definition of Done: Scope memo states: objective, locked decisions, Month-1 deliverables list, explicit non-goals, and what success looks like.
- Deliverables: `docs/00_scope_memo.md`
- Reading: B3

---

**Task 3.2 — Write problem statement**
- Description: Read D16 + skim S1. Write a problem statement targeted at a non-technical Philly stakeholder.
- Learning Objective: Tie the platform to real questions without technical jargon.
- Definition of Done: Problem statement includes: target users, top 3 questions, why district-first, and what's out of scope until later.
- Deliverables: `docs/01_problem_statement.md`
- Reading: D16, S1

---

**Task 3.3 — Define Month-1 success criteria**
- Description: Read D7. Write Month-1 success criteria with objective checks (documents exist, contain X, linkages).
- Learning Objective: Make progress measurable and reviewable.
- Definition of Done: Success criteria lists 8–12 pass/fail checks; each references a specific artifact and requirement.
- Deliverables: `docs/02_success_criteria.md`
- Reading: D7

---

**Task 3.4 — Create glossary (v0)**
- Description: Read R6 (PostGIS intro) sections on geometry types. Create glossary v0 (15–25 terms).
- Learning Objective: Reduce ambiguity and align terminology across docs.
- Definition of Done: Glossary includes required terms: grain, vintage, churn, feature layer, rollup, land-only area, period estimate, etc.
- Deliverables: `docs/glossary.md`
- Reading: D3 | Video: V3

---

**Task 3.5 — List MVP datasets + rationale**
- Description: Read S1, S2, S3 dataset pages. List the four MVP datasets with rationale and top 3 risks each.
- Learning Objective: Constrain sources to those that support the MVP questions.
- Definition of Done: Exactly four datasets listed. Each includes: purpose, time coverage, cadence, geometry type, and top risks.
- Deliverables: `docs/03_mvp_datasets.md`
- Reading: S1, S2, S3, D1

---

**Task 3.6 — Draft data access notes**
- Description: Read S2 notes on size/formats; skim D17. Document access modes for each dataset (API/CSV/SHP), with size warnings and preferred access choice.
- Learning Objective: Avoid later surprises about data volume and access.
- Definition of Done: Access notes include: chosen access mode, why, update cadence, and a 'large dataset' warning where applicable.
- Deliverables: `docs/04_data_access_notes.md`
- Reading: S2, D17

---

**Task 3.7 — Start assumptions log**
- Description: Start an assumptions log capturing uncertainties you will validate later (>=10).
- Learning Objective: Prevent silent assumptions from becoming future bugs.
- Definition of Done: At least 10 assumptions with: statement, rationale, validation plan, and impact if wrong.
- Deliverables: `docs/assumptions_log.md`

---

**Task 3.8 — Create question backlog**
- Description: Create a backlog of non-MVP questions (drivers, amenities, transit, causality) with priority and dependencies.
- Learning Objective: Park ideas without derailing Month 1 scope.
- Definition of Done: Backlog has sections by theme and each item has: priority, data dependency, and 'not in Month 1' flag.
- Deliverables: `docs/questions_backlog.md`

---

**Task 3.9 — Create non-goals doc**
- Description: Write a standalone Non-Goals doc aligned with the scope memo.
- Learning Objective: Make exclusions explicit to prevent creep.
- Definition of Done: Non-goals doc matches scope memo; includes at least 8 non-goals and rationale for deferring them.
- Deliverables: `docs/non_goals.md`

---

**Task 3.10 — Create decision log**
- Description: Read B7 chapter on 'Tracer bullets'. Create a decision log and record the locked decisions to date (>=6 entries).
- Learning Objective: Preserve reasoning for future you (and reviewers).
- Definition of Done: Decision log has >=6 entries with: date, decision, alternatives, rationale, and implications.
- Deliverables: `docs/decision_log.md`
- Reading: B7

---

### Day 4 — GitHub Workflow Infrastructure

---

**Task 4.1 — Create Week-1 grading rubric**
- Description: Read D7. Create a Week-1 grading rubric with pass/fail + scoring criteria referencing artifacts.
- Learning Objective: Make reviews fast and objective.
- Definition of Done: Rubric includes criteria for clarity, completeness, traceability, and consistency. Each criterion points to specific artifacts.
- Deliverables: `docs/grading_rubric_week1.md`
- Reading: D7

---

**Task 4.2 — Add PR template**
- Description: Read D5, D17. Add PR template that forces you to link changed artifacts, assumptions, and evidence.
- Learning Objective: Standardize PR quality and reduce review overhead.
- Definition of Done: Template includes: Purpose, Artifacts Updated, Checklist, Risks/Assumptions, Links. Confirm it appears in PR creation.
- Deliverables: `.github/pull_request_template.md`
- Reading: D5 | Video: V6

---

**Task 4.3 — Add issue templates (docs work)**
- Description: Read D6. Add issue templates for: data-source onboarding, spec change request, reading notes.
- Learning Objective: Turn work into trackable units.
- Definition of Done: All three templates exist, require key fields, and appear in 'New issue' chooser.
- Deliverables: `.github/ISSUE_TEMPLATE/data_source_onboarding.md, .github/ISSUE_TEMPLATE/spec_change_request.md, .github/ISSUE_TEMPLATE/reading_notes.md`
- Reading: D6

---

**Task 4.4 — Configure issue chooser**
- Description: Read D6. Configure issue chooser to discourage blank issues and add helpful links.
- Learning Objective: Improve issue quality and navigation.
- Definition of Done: Blank issues disabled; contact links added (docs index, learning resources).
- Deliverables: `.github/ISSUE_TEMPLATE/config.yml`
- Reading: D6

---

**Task 4.5 — Add PR self-review checklist**
- Description: Read D7. Create a PR self-review checklist (<=15 items) aligned to your rubric.
- Learning Objective: Catch issues before review.
- Definition of Done: Checklist items are concrete (e.g., 'updated docs index', 'no orphan files', 'assumptions logged').
- Deliverables: `docs/checklists/pr_self_review_checklist.md`
- Reading: D7

---

**Task 4.6 — Create Week-1 exit checklist**
- Description: Create Week-1 exit checklist that enumerates all Week-1 required artifacts.
- Learning Objective: Prevent missed items.
- Definition of Done: Checklist references every Week-1 deliverable file and indicates which day it belongs to.
- Deliverables: `docs/checklists/week1_exit_checklist.md`

---

**Task 4.7 — Define label taxonomy**
- Description: Read D13. Define a label taxonomy and create labels in GitHub.
- Learning Objective: Make issues/PRs searchable and consistent.
- Definition of Done: Doc lists label names + intended use. Labels exist in GitHub UI (screenshot optional).
- Deliverables: `docs/repo_labels.md (and labels created in GitHub UI)`
- Reading: D13

---

**Task 4.8 — Create community health files**
- Description: Read D14. Add CODE_OF_CONDUCT and SECURITY policy (minimal templates).
- Learning Objective: Learn standard repo expectations.
- Definition of Done: Files exist and are generic; no personal data. README links to them.
- Deliverables: `CODE_OF_CONDUCT.md, SECURITY.md`
- Reading: D14

---

**Task 4.9 — Update docs navigation map**
- Description: Update docs index to ensure no orphan docs and that summaries are current.
- Learning Objective: Maintain reviewability as docs grow.
- Definition of Done: docs/README.md links to all docs in docs/ and has updated 1-line summaries.
- Deliverables: `docs/README.md (updated)`

---

**Task 4.10 — Open PR for Week-1 WIP**
- Description: Open a Week-1 WIP PR containing Day 1–4 work. Use the PR template and self-review checklist.
- Learning Objective: Practice incremental delivery and review loop.
- Definition of Done: PR exists, uses template, links to rubric, and includes checklist completion.
- Deliverables: `(GitHub PR) Week-1 WIP PR`

---

### Day 5 — Policies + Week-1 Close

---

**Task 5.1 — Create source catalog template**
- Description: Read D16 + D17. Create a source catalog template with required fields (time, geometry, keys, risks).
- Learning Objective: Standardize dataset onboarding.
- Definition of Done: Template includes: Overview, Access, Time Fields, Geometry, Keys, Key Columns, Update Cadence, Risks, Notes, Links.
- Deliverables: `docs/templates/source_catalog_template.md`
- Reading: D16, D17

---

**Task 5.2 — Create feasibility checklist template**
- Description: Create feasibility checklist template to evaluate if a dataset supports the questions.
- Learning Objective: Create repeatable assessment before writing pipelines.
- Definition of Done: Checklist covers: time field selection, geo linkage approach, key field completeness, category stability, and known blockers.
- Deliverables: `docs/templates/feasibility_checklist.md`

---

**Task 5.3 — Create data dictionary template**
- Description: Read D11 for key thinking. Create data dictionary template for critical fields.
- Learning Objective: Clarify required fields before implementation.
- Definition of Done: Template includes: field name, meaning, required?, expected type, common null/invalid patterns, notes.
- Deliverables: `docs/templates/data_dictionary_template.md`
- Reading: D11

---

**Task 5.4 — Draft feature vs rollup policy**
- Description: Read D3 + B1 briefly. Finalize feature vs rollup policy with examples for permits and zoning.
- Learning Objective: Ensure map-first readiness while delivering district-first analytics.
- Definition of Done: Policy states: feature layers retained; rollups reproducible; gives concrete examples for permits (event) vs district-month (rollup).
- Deliverables: `docs/policies/feature_vs_rollup_policy.md`
- Reading: D3, B1

---

**Task 5.5 — Draft land-area denominator policy**
- Description: Finalize land-only area denominator policy (unit conventions, interpretation, consistency rules).
- Learning Objective: Lock the normalization approach to avoid later changes.
- Definition of Done: Policy states: land-only, units (sq miles), and how to handle edge cases consistently (e.g., missing area).
- Deliverables: `docs/policies/land_area_denominator_policy.md`

---

**Task 5.6 — Draft ACS usage policy**
- Description: Read D1, D2. Finalize ACS usage policy (context-only for MVP, comparability cautions).
- Learning Objective: Prevent invalid demographic comparisons.
- Definition of Done: Policy includes: what ACS is used for, what it's not used for, and a standard disclaimer sentence for dashboards/docs.
- Deliverables: `docs/policies/acs_usage_policy.md`
- Reading: D1, D2

---

**Task 5.7 — Create limitations register (v0)**
- Description: Populate limitations register with >=10 items (severity + mitigation idea).
- Learning Objective: Make project credible by documenting pitfalls upfront.
- Definition of Done: At least 10 limitations with: severity, impact, mitigation, and where it will be addressed (Month-2/3/6).
- Deliverables: `docs/limitations_register.md`

---

**Task 5.8 — Create Week-1 recap doc**
- Description: Write a Week-1 recap summarizing what was created, what's missing, and Week-2 plan.
- Learning Objective: Improve execution quality week-to-week.
- Definition of Done: Recap links to key artifacts and includes next steps in bullets.
- Deliverables: `docs/week1_recap.md`

---

**Task 5.9 — Update learning library (Week-1)**
- Description: Update learning library and bibliography based on anything discovered in Days 3–5.
- Learning Objective: Keep the curriculum aligned to project needs.
- Definition of Done: Learning resources and bibliography updated; no duplicates; each resource has a clear rationale.
- Deliverables: `docs/learning_resources.md (updated), docs/bibliography.md (updated)`

---

**Task 5.10 — Merge Week-1 PR + tag release**
- Description: Read D14. Merge Week-1 PR to main and create a Week-1 tag/release note.
- Learning Objective: Practice incremental releases and stable milestones.
- Definition of Done: Main branch contains Week-1 artifacts. A GitHub Release or tag exists with brief release notes.
- Deliverables: `GitHub Release/Tag (Week-1) + RELEASE_NOTES.md (optional)`
- Reading: D14

---

## WEEK 2 — Dataset Deep-Dives

### Day 6 — Planning Districts (District Spine)

**Task 6.1** — Review dataset metadata: Planning Districts | Reading: S1, D17 | Deliverable: `docs/source_catalog/planning_districts_metadata_summary.md`
- DoD: Summary includes: dataset purpose, geometry type, expected feature count (~18), candidate key/name fields, update cadence, and links to source.

**Task 6.2** — Source catalog entry: Planning Districts | Reading: S1, D16 | Deliverable: `docs/source_catalog/planning_districts.md`
- DoD: Catalog includes: access URL(s), geometry, time semantics (if any), candidate keys, update cadence, top risks, and links to metadata summary.

**Task 6.3** — Feasibility checklist: Planning Districts | Deliverable: `docs/feasibility/planning_districts_feasibility.md`
- DoD: Checklist completed; explicitly states how districts will be used as reporting unit and whether geometry supports land-only area calculation.

**Task 6.4** — Critical fields dictionary: Planning Districts | Reading: D11 | Deliverable: `docs/data_dictionary/planning_districts_critical_fields.md`
- DoD: Dictionary lists required fields, expected types, validity notes, and how missing/duplicate IDs will be handled conceptually.

**Task 6.5** — Land-only area evidence note | Reading: D3 | Video: V3 | Deliverable: `docs/feasibility/land_only_area_note.md`
- DoD: Note states: land-only vs total area choice, unit convention (sq mi), and where this will be stored/used in rollups.

**Task 6.6** — Update limitations register (district spine) | Deliverable: `docs/limitations_register.md (updated)`
- DoD: Limitations register contains >=2 new district items with severity and mitigation.

**Task 6.7** — Resource note: GIS boundaries & CRS | Reading: D3, D4 | Video: V3 | Deliverable: `notes/gis_boundaries_crs_notes.md`
- DoD: Note includes: CRS meaning, why standardize, geometry validity issues, and how they could affect district assignment.

---

### Day 7 — L&I Permits

**Task 7.1** — Review dataset metadata: L&I permits | Reading: S2 | Deliverable: `docs/source_catalog/li_permits_metadata_summary.md`
- DoD: Summary includes: coverage, cadence, candidate event-date field(s), category fields, location fields, and size warnings.

**Task 7.2** — Source catalog entry: L&I permits | Reading: S2, D16 | Deliverable: `docs/source_catalog/li_permits.md`
- DoD: Catalog includes: access method, schema notes, time field decision, location fields, update cadence, and top risks.

**Task 7.3** — Feasibility checklist: L&I permits | Deliverable: `docs/feasibility/li_permits_feasibility.md`
- DoD: Checklist answers: 'Can we assign most records to a district?' and 'Is monthly timestamp reliable?' with assumptions/risks.

**Task 7.4** — Critical fields dictionary: L&I permits | Reading: D11 | Deliverable: `docs/data_dictionary/li_permits_critical_fields.md`
- DoD: Dictionary lists required fields with expected type/meaning and notes expected null/invalid patterns.

**Task 7.5** — Permit category grouping decision memo (MVP) | Reading: B5 | Deliverable: `docs/decisions/permit_category_grouping_memo.md`
- DoD: Memo states selected grouping philosophy, what fields it depends on, and 3 risks (schema/value drift).

**Task 7.6** — Permits geocoding risk note | Reading: S2, D3 | Deliverable: `docs/feasibility/permits_geocoding_risk_note.md`
- DoD: Note defines: expected geo fields, unassigned-rate metric, and how it will appear in limitations and dashboards.

**Task 7.7** — Update learning resources (permits/open data) | Reading: D16, S2 | Deliverable: `docs/learning_resources.md (updated), docs/bibliography.md (updated)`
- DoD: 3–5 additions with bibliography entries; no duplicates; each has a rationale.

---

### Day 8 — Zoning Base Districts

**Task 8.1** — Review dataset metadata: Zoning base districts | Reading: S3, D17 | Deliverable: `docs/source_catalog/zoning_base_districts_metadata_summary.md`
- DoD: Summary states: available vintages, geometry type, zoning class field(s), and potential schema differences.

**Task 8.2** — Source catalog entry: Zoning base districts | Reading: S3 | Deliverable: `docs/source_catalog/zoning_base_districts.md`
- DoD: Catalog includes: vintage years, key fields, update policy, comparability risks, and links to metadata summary.

**Task 8.3** — Feasibility checklist: Zoning base districts | Deliverable: `docs/feasibility/zoning_feasibility.md`
- DoD: Checklist answers: 'Are class codes consistent year-to-year?' and documents unknowns to validate later.

**Task 8.4** — Critical fields dictionary: Zoning base districts | Reading: D11 | Deliverable: `docs/data_dictionary/zoning_critical_fields.md`
- DoD: Dictionary lists required fields and notes where schema may change across vintages.

**Task 8.5** — Zoning last-5-years window memo | Reading: S3 | Deliverable: `docs/decisions/zoning_window_last5y.md`
- DoD: Memo lists years and states how to extend to full 2015–2024 later without rewriting metrics.

**Task 8.6** — Year-to-year comparability plan (draft) | Reading: B1, S3 | Deliverable: `docs/zoning_comparability_plan_draft.md`
- DoD: Plan includes: how to detect differences, mapping strategy, and what you will not claim in MVP.

**Task 8.7** — Update limitations register (zoning) | Deliverable: `docs/limitations_register.md (updated)`
- DoD: Limitations register includes >=3 new zoning items with severity + mitigation + when addressed.

---

### Day 9 — ACS Context

**Task 9.1** — ACS methodology summary | Reading: D1, D2 | Deliverable: `docs/source_catalog/acs_context_methodology_summary.md`
- DoD: Summary includes: period estimate definition, overlap warning, and how you'll communicate caveats.

**Task 9.2** — Source catalog entry: ACS context | Reading: D1, D2 | Deliverable: `docs/source_catalog/acs_context.md`
- DoD: Catalog includes: recommended estimate type (5-year), period label convention, geography level notes, and limitations.

**Task 9.3** — Feasibility checklist: ACS context | Deliverable: `docs/feasibility/acs_feasibility.md`
- DoD: Checklist explicitly lists supported contextual indicators and prohibited claims/comparisons.

**Task 9.4** — Critical fields dictionary: ACS context | Reading: D1, D2 | Deliverable: `docs/data_dictionary/acs_critical_fields.md`
- DoD: Dictionary includes: indicator list, period label format, and overlap warning.

**Task 9.5** — Boundary alignment note (ACS → Districts) | Reading: D3, D4 | Video: V3 | Deliverable: `docs/feasibility/acs_to_district_alignment_note.md`
- DoD: Note mentions overlay vs crosswalk, slivers, MAUP, and sanity checks you will run later.

**Task 9.6** — Uncertainty messaging note (MOE-aware) | Reading: D2 | Deliverable: `notes/acs_uncertainty_messaging_notes.md`
- DoD: Note contains 3 reusable disclaimers and 2 examples of 'bad claims' you will avoid.

**Task 9.7** — Update learning resources (ACS additions) | Reading: D1, D2 | Deliverable: `docs/learning_resources.md (updated), docs/bibliography.md (updated)`
- DoD: 2–3 Tier-1 ACS resources; each has a 1-sentence rationale.

---

### Day 10 — Week-2 QA + Close

**Task 10.1** — Update docs index (Week 2) | Deliverable: `docs/README.md (updated)`
**Task 10.2** — Consistency check sweep | Reading: D7 | Deliverable: `docs/glossary.md (updated) and/or docs/decision_log.md (updated)`
**Task 10.3** — Traceability audit sweep | Deliverable: `docs/source_catalog/*.md, docs/feasibility/*.md, docs/data_dictionary/*.md (updated if needed)`
**Task 10.4** — Limitations register hardening | Deliverable: `docs/limitations_register.md (updated)` — DoD: >=15 items, all have severity+mitigation+timeframe
**Task 10.5** — Week-2 recap + Week-3 plan | Deliverable: `docs/week2_recap.md`
**Task 10.6** — Open PR: Week-2 artifacts | Reading: D5, D7 | Video: V6 | Deliverable: `(GitHub PR) Week-2 PR`
**Task 10.7** — Optional: Tag Week-2 milestone | Reading: D14 | Deliverable: `GitHub Release/Tag (Week-2) (optional)`

---

## WEEK 3 — Data Modeling + Metric Specs

### Day 11 — Grain + Entity Modeling

**Task 11.1** — Kimball: Grain deep dive + apply to project | Reading: B1 | Deliverable: `docs/modeling/grain_spec.md` — DoD: 5 grain statements + 1 example PK per grain + 2 failure modes
**Task 11.2** — Identify entities + relationships (text-only ERD draft) | Reading: D19, D11 | Deliverable: `docs/modeling/erd_text_draft.md` — DoD: entities include districts, permits, zoning_polygons, zoning_vintages, rollups; each relationship has cardinality + join keys
**Task 11.3** — Define 'feature vs rollup' table list | Deliverable: `docs/modeling/table_inventory.md` — DoD: each table has type (feature/rollup), grain, intended consumers
**Task 11.4** — Add modeling glossary expansions | Reading: B5, D11 | Deliverable: `docs/glossary.md (updated)` — DoD: 8–12 new terms with definitions + 1 project example each

---

### Day 12 — Permits Metric Specs

**Task 12.1** — Metric spec template (final) | Reading: B1, D21 | Deliverable: `docs/templates/metric_spec_template.md` — DoD: includes metric name, purpose, grain, numerator, denominator, filters, dimensions, caveats, test ideas
**Task 12.2** — Permits metric spec: monthly count | Reading: S2 | Deliverable: `docs/metrics/permits_monthly_count.md`
**Task 12.3** — Permits metric spec: permits per land sq mi | Reading: S1 | Deliverable: `docs/metrics/permits_per_sqmi_land.md`
**Task 12.4** — Permits composition metric spec | Deliverable: `docs/metrics/permits_composition.md`
**Task 12.5** — Update limitations register (permits metrics) | Deliverable: `docs/limitations_register.md (updated)`

---

### Day 13 — Zoning Metric Specs

**Task 13.1** — Zoning metric spec: composition by year | Reading: S3 | Deliverable: `docs/metrics/zoning_composition_by_year.md`
**Task 13.2** — Zoning metric spec: year-to-year churn | Reading: S3 | Deliverable: `docs/metrics/zoning_year_to_year_churn.md`
**Task 13.3** — Finalize zoning comparability plan | Reading: D19, S3 | Deliverable: `docs/zoning_comparability_plan.md`
**Task 13.4** — Update limitations register (zoning metrics) | Deliverable: `docs/limitations_register.md (updated)`

---

### Day 14 — ACS Metric Specs + Disclaimer Library

**Task 14.1** — ACS metric spec: income proxy | Reading: D1, D2 | Deliverable: `docs/metrics/acs_income_proxy.md`
**Task 14.2** — ACS metric spec: tenure proxy | Reading: D1, D2 | Deliverable: `docs/metrics/acs_tenure_proxy.md`
**Task 14.3** — Standard disclaimer library | Reading: D2 | Deliverable: `docs/policies/disclaimer_library.md` — DoD: 5 disclaimer sentences (ACS + zoning) + 5 'forbidden claims' examples
**Task 14.4** — Update learning resources (Week 3 modeling) | Reading: D19, D21, D22, D23, D24 | Video: V8 | Deliverable: `docs/learning_resources.md (updated), docs/bibliography.md (updated)`

---

### Day 15 — Week-3 QA + Close

**Task 15.1** — Cross-metric consistency check | Deliverable: `docs/decision_log.md (updated) and/or metrics docs updated` — DoD: >=5 issues fixed; no conflicting grain statements
**Task 15.2** — Docs index update (Week 3) | Deliverable: `docs/README.md (updated)`
**Task 15.3** — Week 3 recap + Week 4 plan | Deliverable: `docs/week3_recap.md`
**Task 15.4** — Open PR: Week 3 specs | Reading: D5, D7 | Video: V6 | Deliverable: `(GitHub PR) Week-3 PR`

---

## WEEK 4 — Diagrams, Contracts + Month-1 Submission

### Day 16 — ERD Diagram

**Task 16.1** — Create ERD diagram (Mermaid) | Reading: D19 | Video: V9 | Deliverable: `docs/diagrams/erd.mmd` — DoD: renders in GitHub; matches erd_text_draft.md and grain spec
**Task 16.2** — ERD review checklist self-audit | Reading: D11 | Deliverable: `docs/checklists/erd_review_checklist.md`
**Task 16.3** — Update decision log from ERD work | Deliverable: `docs/decision_log.md (updated)` — DoD: >=3 new entries

---

### Day 17 — Dataflow Diagram + Contracts

**Task 17.1** — Create high-level dataflow diagram (Mermaid) | Reading: D20 | Deliverable: `docs/diagrams/dataflow.mmd` — DoD: all 4 datasets; feature vs rollup layers separated; grains labeled
**Task 17.2** — Write 'map-first ready' contract (final) | Reading: D3 | Deliverable: `docs/policies/map_first_readiness_contract.md`
**Task 17.3** — Create repo review checklist (Month 1) | Reading: D7 | Deliverable: `docs/checklists/month1_review_checklist.md`

---

### Day 18 — Final QA Pass

**Task 18.1** — Docs index final pass | Deliverable: `docs/README.md (updated)` — DoD: zero broken links; 1-line summaries for all Month-1 artifacts
**Task 18.2** — Traceability pass: cross-links | Deliverable: `docs/source_catalog/*.md, docs/feasibility/*.md, docs/data_dictionary/*.md, docs/metrics/*.md (updated if needed)`
**Task 18.3** — Consistency pass: terminology & naming | Deliverable: `docs/glossary.md (updated) and/or docs/decision_log.md (updated)` — DoD: >=10 issues fixed or logged
**Task 18.4** — Limitations register final hardening | Deliverable: `docs/limitations_register.md (updated)` — DoD: >=20 items; >=5 tied to specific metrics

---

### Day 19 — Product Specs

**Task 19.1** — Define 'district brief' output spec (MVP narrative) | Reading: D24 | Deliverable: `docs/product/district_brief_spec.md` — DoD: lists required sections (permits trend, zoning change, ACS context), required metrics, standard disclaimers
**Task 19.2** — Create 'compare districts' view spec | Deliverable: `docs/product/district_compare_spec.md` — DoD: metric list, ranking direction, caveats
**Task 19.3** — Update learning resources (Week 4 docs/diagrams) | Reading: D19, D20, D23 | Video: V8 | Deliverable: `docs/learning_resources.md (updated), docs/bibliography.md (updated)`

---

### Day 20 — Month-1 Submission

**Task 20.1** — Month-1 recap (executive summary) | Deliverable: `docs/month1_recap.md` — DoD: links to scope memo, catalogs, grain spec, key metrics, comparability plan, diagrams, limitations, product specs
**Task 20.2** — Open PR: Month-1 submission | Reading: D7 | Video: V6 | Deliverable: `(GitHub PR) Month-1 submission PR`
**Task 20.3** — Create Month-1 release/tag | Reading: D14 | Deliverable: `GitHub Release/Tag (Month-1)`
