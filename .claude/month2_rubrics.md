# Rubrics Reference — Month 2

The universal rubric (5 criteria, 0–2 each, max 10) is defined in `CLAUDE.md`. This file contains the **task-specific checks for criterion 5 (Task Objective Mastery)** for every Month 2 task, plus Month 2-specific scoring notes that matter more now that the work includes code, Docker, SQL, dbt, geospatial logic, and dashboards.

When grading, always:
1. Check Pass/Fail gates first (artifact exists + Definition of Done met)
2. Score criteria 1–4 against the universal rubric
3. Use the task-specific checks below for criterion 5

---

## Universal Criterion Scoring Notes

### Consistency (Criterion 4)

When scoring Consistency (0–2), check alignment with the repo `style_guide.md`, templates, Month 2 file naming, and the implementation contracts set in Month 1.

**For all documentation artifacts:**
- File names follow lowercase_with_underscores convention
- Required sections are present (Purpose, Scope, References where applicable)
- Resources are cited using IDs from `month2_resources.md` (`[B3]`, `[D18]`, etc.)
- Markdown formatting is consistent (heading levels, list styles, link formats)
- Cross-references use correct relative paths and resolve properly
- README/runbooks reflect what is actually implemented, not what is merely planned

**For code artifacts:**
- Python follows Google Python Style Guide / PEP 8 conventions closely enough to be maintainable
- Modules, functions, and SQL model names are clear and project-specific
- Docstrings/comments exist where intent would otherwise be ambiguous
- Config is externalized appropriately; no hard-coded secrets or machine-specific paths
- Code layout matches the responsibilities claimed in the docs (for example, raw extraction logic is not scattered across unrelated files)

**For SQL / dbt artifacts:**
- Model names follow a consistent layer convention (`stg_`, `dim_`, `fct_`, etc.)
- Grain is explicit and matches the design docs
- Tests line up with the model’s real failure modes, not generic boilerplate only
- Source, staging, and mart responsibilities are kept separate
- dbt docs/descriptions are updated when new models are added

**For local-platform artifacts:**
- `compose.yml`, `.env.example`, runbooks, and task-runner commands agree with one another
- Services, ports, healthchecks, volume mounts, and schema names are consistent across files
- The repo supports clean-start reproduction without hidden local setup steps

**Scoring:**
- **2 points:** Fully consistent — docs/code/config all align; naming, structure, and claims match reality
- **1 point:** Mostly consistent — small mismatches or omissions, but the repo remains understandable and runnable
- **0 points:** Inconsistent — docs drift from code, naming is messy, or the reviewer cannot trust the repo narrative

### Operational correctness notes for Month 2

These do **not** replace the universal rubric, but they should inform scoring across all criteria:
- Prefer **working, reviewable, reproducible** implementations over ambitious but half-wired scaffolding.
- A task that “exists” but cannot be run from the documented workflow should be scored harshly.
- For ingestion/load tasks, rerun safety and provenance matter; for dbt tasks, grain/test discipline matters; for spatial tasks, CRS/SRID correctness matters.
- Dashboard tasks should validate the warehouse outputs; they are not decoration.

---

## WEEK 1

> **Universal Week 1 requirement for criterion 5:** Month 1 closeout tasks must remove ambiguity, not just add more text. Platform/scaffold tasks must create a reproducible local foundation that future tasks can build on without hidden setup.
>
> **Template compliance:** Design docs and runbooks should follow the Month 1 memo/style conventions. Code/config artifacts should be minimal, readable, and consistent with the runbooks.

### Day 1 — Resolve the remaining Month 1 contradictions

**1.1 — Re-read Month 1 gate documents**
- Findings list names the exact contradictory files/claims and groups them by issue type (grain, SCD, ERD, progress-tracking, README narrative).
- No item is phrased vaguely; each finding is actionable enough to turn into a discrete fix.

**1.2 — Resolve the permits fact-table decision**
- Decision memo states the MVP permits fact in one sentence, names the deferred alternative explicitly, and explains why it is deferred.
- The wording is precise enough that the same sentence can be reused verbatim across docs and code comments.

**1.3 — Propagate the permits decision across all affected docs**
- All listed artifacts use the same permits-grain language; there are no leftover references to a conflicting lifecycle design.
- ERD, glossary, recap, and table specs describe the same object, not nearby-but-different concepts.

**1.4 — Make the progress tracker real**
- Tracker lists all 8 Month 1 checks individually with pass/fail state, evidence note, and blocker note where relevant.
- The file reads like an audit trail rather than a motivational status update.

**1.5 — Re-grade Month 1 honestly**
- Re-grade states an explicit score and references evidence for each check instead of saying Month 1 is “basically done.”

---

### Day 2 — Turn the Month 1 design into a usable implementation contract

**2.1 — Add SCD strategy to dimensions**
- Each dimension has a named SCD type, change-handling rule, and project-specific rationale tied to actual source behavior.
- No dimension uses a generic “SCD2 for history” explanation without saying what history changes are expected.

**2.2 — Upgrade `fct_permits` spec to DDL-ready**
- `column_contracts.md` exists and is a distinct document from `grain_spec.md`. Each document cross-references the other.
- `fct_permits` entry in `column_contracts.md` includes exact columns, SQL types, nullability, business key/surrogate key handling, and FK expectations.
- Spec includes at least 2–3 validation rules that would catch grain violations or duplicate facts.

**2.3 — Upgrade the remaining high-risk table specs**
- All five target tables (`fct_district_year_zoning_composition`, `bridge_tract_district_overlap`, `fct_tract_acs`, `dim_district`, `dim_zoning`) have the same DDL-grade rigor as `fct_permits` — not lighter prose summaries.
- `dim_zoning` entry explicitly names its surrogate key strategy, natural key, and SCD type with project-specific rationale.
- Validation rules are tailored to each table’s grain and failure modes — the bridge table rules address weight-sum invariants, not just non-null keys.

**2.4 — Add grain annotations to the ERD**
- Each fact-like entity displays its grain inside the Mermaid body and renders legibly in GitHub.
- A reviewer can understand entity purpose and granularity from the diagram alone.

**2.5 — Split “designed” vs “implemented” in the README**
- README clearly separates “designed” from “implemented” sections and avoids implying code exists when it does not.
- Top-of-file project status is visible without scrolling deep into the document.

---

### Day 3 — Python project scaffold and local developer ergonomics

**3.1 — Create the Python project manifest**
- `pyproject.toml` is the single canonical dependency/config entry point and does not contain speculative tooling you are not using yet.

**3.2 — Create the source package skeleton**
- Package structure cleanly separates config/common/ingest/validate responsibilities and imports successfully from a clean environment.

**3.3 — Add environment-variable handling**
- `.env.example` covers every runtime-specific value needed in Month 2 and intentionally excludes secrets or machine-specific junk.
- Runbook explains where each variable is consumed.

**3.4 — Add task runner commands**
- Runner commands cover the real daily workflow and actually call the underlying tools/files that exist in the repo.
- Command names are memorable and consistent rather than one-off shell aliases.

**3.5 — Write the local-dev runbook**
- Runbook can be followed on a fresh machine without unstated tribal knowledge or hidden prerequisites.

---

### Day 4 — Docker Compose stack skeleton

**4.1 — Create the Compose file**
- Compose file includes only services required for the Month 2 MVP and validates without schema errors.
- Service names, ports, and environment variable references are consistent with the runbooks.

**4.2 — Add the PostGIS-backed database service**
- Database service uses a PostGIS-capable image, persistent storage, and clearly defined initialization behavior.

**4.3 — Add the Metabase service**
- Metabase service boots through Compose, has persistent app data where appropriate, and documents how it connects to Postgres.

**4.4 — Add named volumes and healthchecks**
- Volumes are justified by persistence needs, and healthchecks test meaningful readiness rather than superficial container start.

**4.5 — Smoke-test the whole stack**
- Smoke test proves both services come up together and that the database is reachable from the expected client path.

---

### Day 5 — Database bootstrap and schema initialization

**5.1 — Create database init SQL for extensions**
- Init SQL enables required extensions idempotently and does not assume manual post-start setup.

**5.2 — Create database init SQL for schemas**
- Schema init creates the intended warehouse layers cleanly and in the correct order.

**5.3 — Add a schema/read-write policy note**
- Policy note makes schema ownership/responsibility explicit so raw/staging/marts boundaries are not hand-wavy.

**5.4 — Create a safe reset workflow**
- Reset workflow is destructive by design but safe by documentation: it states what is dropped, what persists, and when to use it.

**5.5 — Verify the database bootstrap manually**
- Manual verification captures concrete evidence: schemas/extensions visible, not just “seems to work.”

---

### Day 6 — dbt project scaffold

**6.1 — Initialize the dbt project**
- dbt project initializes successfully and adopts a folder/layout pattern that will scale beyond a toy demo.

**6.2 — Configure dbt connection profiles**
- Profile/target configuration is externalized cleanly and works with the local Postgres service from the Compose stack.

**6.3 — Create source declarations for all 4 MVP datasets**
- All 4 MVP raw datasets are declared as dbt sources with accurate names, schemas, and freshness/test placeholders where appropriate.

**6.4 — Create the dbt folder structure**
- Folder structure enforces separation among staging/intermediate/marts/seeds/macros/tests instead of dumping models into one folder.

**6.5 — Generate the first dbt docs site**
- First docs site renders and is useful—sources/models are named and described, not just auto-generated stubs.

**6.6 — Define the materialization strategy**
- `dbt_project.yml` has folder-level materialization defaults for each model layer, not uniform `view` for everything.
- The policy note explains *why* each layer uses its default: a view over a 2M-row fact table is a different decision than a view over a 10-row seed, and those decisions should be named.
- Any known model-level overrides (e.g., large fact tables that must be `table` not `view`) are documented before the model is built, not discovered later.

---

### Day 7 — Tests, linting, and CI skeleton

**7.1 — Add pytest configuration**
- Pytest configuration supports running tests locally from the repo root with predictable discovery.

**7.2 — Add the first real smoke test**
- Smoke test exercises a real project invariant (for example, service/database connectivity), not a meaningless assertion.

**7.3 — Add lint/format tooling**
- Lint/format tooling is minimal and enforceable; it should reduce noise, not introduce a huge configuration rabbit hole.

**7.4 — Add pre-commit hooks**
- Pre-commit hooks run the same checks you actually care about and do not silently skip broken files.

**7.5 — Add a GitHub Actions workflow**
- CI workflow is small but real: it installs the project, runs checks, and fails loudly on breakage.

---

## WEEK 2

> **Universal Week 2 requirement for criterion 5:** Raw-ingestion and district-slice tasks must preserve provenance, make geometry/CRS choices explicit, and prove the first vertical slice works from source inspection through dbt models and Metabase validation.
>
> **Template compliance:** Endpoint notes, QA checklists, runbooks, and recaps should stay reviewable and cross-linked to the implemented code/models.

### Day 8 — Planning districts raw ingestion

**8.1 — Inspect the planning-district source endpoint**
- Endpoint inspection documents pagination limits, output format, geometry availability, field list strategy, and extraction risks before coding.

**8.2 — Build the raw extractor**
- Extractor can be rerun deterministically and writes the exact payload/file(s) expected by the raw layer.

**8.3 — Add raw snapshot manifest metadata**
- Manifest records source URL, extraction timestamp, row count/hash or equivalent provenance fields needed for auditability.

**8.4 — Land the first raw snapshot**
- First landed snapshot is complete enough to support downstream QA and has no missing companion metadata.

**8.5 — Write the raw-ingest runbook**
- Runbook documents the exact extractor command, expected outputs, and common failure points.

---

### Day 9 — Planning districts raw QA

**9.1 — Record row-count expectations**
- Row-count expectations are explicit (for example, 18 districts) and tied to source evidence rather than guesswork.

**9.2 — Verify the key fields**
- Key-field review identifies candidate business keys, duplicate risk, null behavior, and any normalization needed before staging.

**9.3 — Verify geometry presence and type**
- Geometry QA confirms presence, expected type, and any empty/invalid cases; results are quantified, not described vaguely.

**9.4 — Inspect CRS/SRID evidence**
- CRS/SRID evidence is captured from the actual data or service metadata and linked to the later area-calculation choice.

**9.5 — Add at least one raw-data validator test**
- Validator test checks a real raw invariant such as row count, key presence, or geometry non-null share.

---

### Day 10 — Load planning districts into the warehouse and create staging

**10.1 — Create the raw landing table**
- Raw landing table mirrors the raw extract closely enough to preserve provenance while still being loadable and queryable.

**10.2 — Load the first snapshot into `raw`**
- Initial raw load completes successfully with row counts reconciled against the snapshot manifest.

**10.3 — Declare the planning-district source in dbt**
- dbt source declaration matches the actual raw table names and columns loaded into Postgres.

**10.4 — Build `stg_planning_districts`**
- `stg_planning_districts` standardizes names/types and isolates raw quirks without baking in analyst-specific logic.

**10.5 — Add dbt tests for the staging model**
- dbt tests cover the key assumptions: uniqueness, not-null expectations, and any accepted-value or geometry sanity checks.

---

### Day 11 — CRS validation and land area computation

**11.1 — Confirm the geometry SRID in-database**
- SRID confirmation is done in-database, not guessed from filenames or external memory.

**11.2 — Choose the projected CRS for area calculations**
- Projected CRS choice is justified for Philadelphia area calculations and documented so future geometry work reuses it.

**11.3 — Compute `land_area_sqmi`**
- `land_area_sqmi` calculation uses an appropriate projected CRS and a transparent unit conversion path.

**11.4 — Reconcile the computed area with any source area field**
- Reconciliation note quantifies differences versus any source area field and explains whether discrepancies are acceptable.

**11.5 — Add an automated area sanity test**
- Area sanity test would catch gross CRS/unit mistakes rather than merely checking the column exists.

---

### Day 12 — Build district dimensions and geometry tables

**12.1 — Build `dim_date`**
- `dim_date` covers the date grain needed by Month 2 models and includes stable surrogate/business key handling.

**12.2 — Build `dim_district`**
- `dim_district` has one row per district at the intended grain and carries only dimension-level attributes, not mixed-grain metrics.

**12.3 — Build `geo_district_boundaries`**
- `geo_district_boundaries` stores geometry in a reviewer-readable way and preserves the link back to `dim_district`.

**12.4 — Add dimension/geometry relationship tests**
- Tests prove the dimension/geometry relationship, uniqueness, and expected cardinality.

**12.5 — Update dbt documentation for the district layer**
- dbt docs explain purpose, grain, and key joins for each district-layer model.

---

### Day 13 — Connect the district slice to Metabase

**13.1 — Connect Metabase to the Postgres database**
- Metabase connection succeeds from the local stack with stable credentials/config documented in the runbook.

**13.2 — Expose the district dimension and geometry tables**
- Only the intended district tables are exposed or highlighted; naming is reviewer-friendly rather than raw/internal.

**13.3 — Create one district sanity question**
- Sanity question materially validates the district slice (for example, district count/area summary), not just “select *”.

**13.4 — Capture any district-slice issues discovered in Metabase**
- Issues list captures exact problems surfaced in Metabase and ties them to upstream fixes or backlog items.

**13.5 — Update the docs index**
- Docs index reflects the new runbooks/models/checklists and contains no orphaned Month 2 docs.

---

### Day 14 — Week 2 checkpoint and cleanup

**14.1 — Run the district slice from clean start**
- District slice can be reproduced from a clean start using only the repo instructions and checked-in code/config.

**14.2 — Refactor obvious naming or structure debt**
- Refactor changes reduce debt without changing intended behavior; naming/structure becomes clearer, not merely different.

**14.3 — Add a district-slice QA checklist**
- Checklist is executable: another reviewer could use it to validate the district slice end to end.

**14.4 — Write the district-slice recap**
- Recap explains what works, what does not, and what technical debt remains; it is not just a list of files created.

**14.5 — Open the permits blocker list**
- Permits blocker list is prioritized by dependency/risk rather than dumped as an unordered concern list.

---

## WEEK 3

> **Universal Week 3 requirement for criterion 5:** Permits tasks must emphasize restart safety, grain correctness, spatial assignment transparency, and alignment between written metric specs and implemented models.
>
> **Template compliance:** Fact/mart documentation, caveat notes, and recaps should explicitly match the implemented SQL/dbt logic.

### Day 15 — Permits extraction strategy

**15.1 — Re-inspect the permits source**
- Source re-inspection documents pagination, filters, date fields, record caps, and geometry realities relevant to extraction design.

**15.2 — Choose the extraction key strategy**
- Extraction-key choice is explicitly justified for restart safety, deduplication, and backfill practicality.

**15.3 — Build the permits extractor CLI/module**
- Extractor module/CLI supports parameterized runs and is organized so future backfills do not require rewriting the script.

**15.4 — Land a small sample successfully**
- Small sample lands successfully with evidence that the end-to-end path (extract → persist) works before scaling up.

**15.5 — Write the backfill plan**
- Backfill plan is concrete about chunking, checkpointing, and failure recovery; no “download everything somehow” language.

---

### Day 16 — Permits raw load and checkpointing

**16.1 — Create the raw permits landing table**
- Raw permits landing table can store source data without premature over-normalization and includes provenance fields where needed.

**16.2 — Load the first batch into `raw`**
- First batch load completes with clear row-count evidence and no silent truncation or encoding surprises.

**16.3 — Add raw-batch manifest/checkpoint tracking**
- Manifest/checkpoint tracking is sufficient to resume interrupted loads and explain what has already been landed.

**16.4 — Validate row counts and key coverage**
- Validation quantifies count differences, key coverage, and obvious null/quality issues; it does not hand-wave “looks okay.”

**16.5 — Run one safe rerun scenario**
- Rerun scenario proves idempotency or at least controlled duplicate prevention at the chosen batch grain.

---

### Day 17 — Permits staging normalization

**17.1 — Declare the permits raw source in dbt**
- dbt source declaration for permits matches the actual raw batch table(s) and naming used by the loader.

**17.2 — Build `stg_li_permits_base`**
- `stg_li_permits_base` handles raw cleanup responsibilities only and does not smuggle mart logic into staging.

**17.3 — Standardize core dates and categories**
- `permit_category_groups.csv` exists as a dbt seed with raw category values mapped to canonical groups. The staging model joins to it rather than embedding CASE logic inline.
- Core dates are standardized using documented parsing rules. No date-handling logic is buried as an unexplained CAST.
- The seed is documented in YAML with descriptions for each column.

**17.4 — Add key logic and dedupe rules**
- Business key and dedupe rules are explicit enough that duplicate handling is reviewable and testable.

**17.5 — Add staging tests**
- Staging tests cover the most failure-prone assumptions: keys, dates, required fields, and category expectations.

---

### Day 18 — District assignment and spatial QA for permits

**18.1 — Confirm the permit geometry strategy**
- Geometry strategy states clearly whether permit points, source coordinates, or fallback assignment logic are used and why.

**18.2 — Build the permit geometry staging model**
- Geometry staging model produces reviewable geometry columns with CRS handling made explicit.

**18.3 — Build the spatial join to districts**
- Spatial join logic is deterministic and aligned with district-boundary geometry; boundary/point-in-polygon assumptions are documented.

**18.4 — Measure unassigned share**
- Unassigned share is quantified and segmented enough to understand whether the join is acceptable for MVP use.

**18.5 — Record spatial-assignment caveats**
- Caveat note names assignment failure modes and what claims the dashboard should avoid because of them.

---

### Day 19 — Build `fct_permits`

**19.1 — Reconfirm the fact grain in code**
- Fact grain as implemented in SQL/dbt matches the Month 1 design decision exactly—no drift back into ambiguous lifecycle logic.

**19.2 — Build the fact model**
- `fct_permits` contains one row per fact grain, only fact-level attributes/measures, and correct keys to linked dimensions.

**19.3 — Add relationship and uniqueness tests**
- Tests enforce uniqueness and relationships at the fact grain rather than only checking non-null cosmetic columns.

**19.4 — Validate row counts against the raw source**
- A control-total note exists that traces `fct_permits` row count back to the raw source count with explicit arithmetic: raw rows − intentional exclusions (nulls, dedupes, unassigned) = final fact rows.
- Every exclusion category is named and quantified — “some rows were dropped” is not acceptable.
- Any unexplained variance between source and fact counts is flagged as an open issue, not silently accepted.

**19.5 — Validate the fact against the metric specs**
- Fact validation compares implemented outputs against the written metric specs and highlights any mismatch explicitly.

---

### Day 20 — Build the permits marts

**20.1 — Build monthly permit counts**
- Monthly permit-count mart matches the defined metric grain and does not mix district/date levels incorrectly.

**20.2 — Build permits per land square mile**
- Per-land-square-mile mart uses the documented denominator and handles division/null edge cases defensibly.

**20.3 — Build permits composition**
- Composition mart uses stable category logic and makes total-vs-share semantics unambiguous.

**20.4 — Document the permits marts**
- Documentation states each mart’s purpose, grain, inputs, caveats, and intended downstream use.

**20.5 — Create 2–3 Metabase sanity questions for permits**
- Metabase sanity questions expose whether the marts are believable—not just whether the tables are queryable.

---

### Day 21 — Permits checkpoint and hardening

**21.1 — Run a full rebuild of the permits slice**
- Permits slice can be rebuilt end to end without manual patching or hidden local state.

**21.2 — Add performance-minded indexes where justified**
- Every index added references a specific query shape or join that motivated it. “Seemed like a good idea” is not a justification.
- `index_notes.md` lists each index with the query pattern it serves. A spatial index on district geometry is expected if not already present.
- No index exists without a named reason in the documentation.

**21.3 — Triage the slowest query or model**
- Performance triage identifies the real bottleneck with evidence (query plan/runtime/logs), not guesswork.

**21.4 — Update the limitations register**
- Limitations register updates are specific to the implemented permits slice and tied to user-facing claim boundaries.

**21.5 — Write the permits vertical-slice recap**
- Recap states what is production-like, what is still MVP-only, and what remains fragile.

**21.6 — Re-check the Month 1 permits-related docs against the implementation**
- Design docs were rechecked against implementation and any drift was either corrected or logged as an intentional deviation.

---

## WEEK 4

> **Universal Week 4 requirement for criterion 5:** Zoning tasks must deliver a complete, tested vertical slice. `dim_zoning` must exist as a first-class object before the zoning marts are considered done. Spatial outputs must have area reconciliation checked and documented tolerances — not just a build that succeeds.
>
> **Template compliance:** Crosswalk seeds, caveat docs, QA notes, and recaps should be traceable back to implemented models and tests. Zoning-layer Metabase questions must actually validate the mart outputs, not just prove the tables are queryable.

### Day 22 — Zoning raw ingestion

**22.1 — Inventory the zoning vintages**
- Vintage inventory lists exactly which zoning years/files are in scope and records any missing or inconsistent vintages.

**22.2 — Define the zoning raw-file layout**
- Raw-file layout is deterministic and makes it obvious where each vintage lives and how loaders discover it.

**22.3 — Land two vintages as a smoke test**
- Two-vintage smoke test proves the ingestion path before scaling to the full recent window.

**22.4 — Build the repeatable zoning raw loader**
- Raw loader is rerunnable across vintages and preserves vintage metadata explicitly in the output.

**22.5 — Write the zoning-ingest runbook**
- Runbook explains how to add another vintage later without reverse-engineering the loader.

---

### Day 23 — Zoning staging, geometry validation, and CRS work

**23.1 — Create the zoning raw landing table strategy**
- Landing-table strategy preserves vintage identity and geometry while avoiding a one-table-per-random-experiment mess.

**23.2 — Declare zoning raw sources in dbt**
- dbt source declarations name zoning raw inputs consistently and make vintage lineage obvious.

**23.3 — Build the staging model for zoning polygons**
- Staging model standardizes zoning geometry and attributes while preserving code/vintage fields needed downstream.

**23.4 — Validate CRS and geometry quality**
- Geometry validation quantifies invalid/missing geometry, SRID issues, and any repair logic used. Numbers are explicit, not described vaguely.

**23.5 — Compute zoning polygon area in the chosen projected CRS**
- Area calculation uses the chosen projected CRS and stores results in a clearly documented unit. CRS choice matches the district-area calculation CRS.

---

### Day 24 — Zoning vocabulary EDA and crosswalk seed

**24.1 — Extract distinct zoning codes by vintage**
- Distinct-code extraction produces a reviewer-friendly inventory by vintage rather than an unreadable raw dump.

**24.2 — Compare code sets year-to-year**
- Year-to-year comparison identifies both stable codes and candidate comparability problems explicitly. Results are structured enough to feed into the crosswalk seed.

**24.3 — Create the initial crosswalk seed**
- Crosswalk seed captures initial mappings in a structure that can evolve without hidden logic in SQL. It is a dbt seed, not an inline CASE statement.

**24.4 — Flag unstable or unresolved mappings**
- Unstable/unresolved mappings are flagged clearly enough that churn outputs can exclude or caveat them. A reviewer can determine which codes are safe to compare across vintages.

**24.5 — Update the claim-boundary docs**
- Claim-boundary docs are updated to reflect what the zoning outputs can and cannot validly say, based on what the real crosswalk work revealed.

---

### Day 25 — Zoning composition and churn marts

**25.1 — Build `fct_district_year_zoning_composition`**
- Fact table grain is one row per district × year × zoning code, consistent with the ERD/specs.
- All 5 vintages are present in the output, not just the most recent.
- Every row has a non-null `vocab_stable` flag populated from the crosswalk seed.
- For each district × year combination, the sum of zoning polygon areas reconciles with `dim_district.land_area_sqmi` within a documented tolerance — the tolerance is explicitly stated and tested, not implied.
- Any gap between zoning coverage and district area is flagged in the output or a QA note, not silently dropped.

**25.2 — Build the zoning composition metric model**
- Composition metric model clearly defines numerator, denominator, and whether shares sum to 1 within the intended partition.

**25.3 — Build the YoY churn model**
- YoY churn model distinguishes actual zoning change from crosswalk/schema artifacts as far as the current mappings allow. Unstable mappings are excluded or flagged, not silently included.

**25.4 — Add zoning tests**
- Zoning tests cover duplicates, missing vintages/codes, and basic metric sanity constraints. The `vocab_stable` flag coverage is tested.

**25.5 — Create one zoning sanity view in Metabase**
- Metabase sanity view helps visually spot obvious composition/churn anomalies before wider use. The output is plausible against publicly available zoning data.

---

### Day 26 — Build `dim_zoning` and connect zoning to Metabase

**26.1 — Build `dim_zoning`**
- `dim_zoning` exists as a first-class dimension with one row per canonical code and non-null `vocab_stable` flag for every row.
- The dimension is not an afterthought bolted onto the fact table — it has its own SQL, YAML, and documented surrogate key strategy.
- FK relationship between `fct_district_year_zoning_composition` and `dim_zoning` is declared in dbt YAML and the relationship test passes.

**26.2 — Add zoning relationship tests**
- Uniqueness test on `dim_zoning` passes.
- FK integrity test prevents the composition fact from referencing codes absent from `dim_zoning`.
- Both tests are in YAML, not just described in docs.

**26.3 — Expose zoning marts in Metabase**
- All three zoning objects (`dim_zoning`, `fct_district_year_zoning_composition`, and mart models) are queryable in Metabase.
- Any field-type or visibility problems are logged to the backlog with enough specificity to fix them.

**26.4 — Create 2–3 Metabase zoning questions**
- Questions test composition shares, YoY churn, and cross-district comparison — each exercises a different analytical use case.
- Outputs are explainable to a reviewer without needing to look at the underlying SQL.

**26.5 — Update zoning documentation**
- All zoning mart and dimension models appear in `dbt docs generate` output with descriptions for models and key columns.
- No new documents created during the zoning build are missing from the docs index.

---

### Day 27 — Zoning hardening and Week 4 closeout

**27.1 — Run a full rebuild of the zoning slice**
- Zoning slice can be rebuilt end to end without manual patching or hidden local state.

**27.2 — Validate composition area reconciliation**
- Area reconciliation QA note exists with the actual gap distribution per district × year.
- Any district × year pairing that exceeds the stated tolerance is named and dispositioned — not absorbed into silence.
- The reconciliation is a quantified check, not a narrative claim that “the numbers look right.”

**27.3 — Update the limitations register for zoning**
- At least 3 new concrete zoning entries: vocabulary instability, crosswalk ambiguities, area reconciliation gaps, or vintage access issues.
- Entries are specific enough to inform dashboard caveats.

**27.4 — Write the zoning vertical-slice recap**
- Recap identifies transferable patterns for the ACS week and is honest about what remains fragile.

**27.5 — Open the ACS blocker list**
- Blockers are ordered by dependency risk, not just listed. Census API key access, tract geometry source, and bridge table design are addressed explicitly.

---

## WEEK 5

> **Universal Week 5 requirement for criterion 5:** ACS tasks must preserve statistical context (MOEs, tract grain, weighting methodology) through every layer. The bridge table must have a validated weight-sum invariant, not just a build that succeeds. Dashboard tasks must draw from tested marts; screenshots or runbook entries are expected as evidence.
>
> **Template compliance:** ACS caveat docs, usage policy updates, and bridge documentation should be precise enough to prevent misuse of overlapping ACS periods or district-level pseudo-estimates. Closeout tasks must prove reproducibility, not just assert it.

### Day 28 — ACS extraction strategy and raw ingestion

**28.1 — Finalize the ACS variable list and API setup**
- ACS variable list is explicit: each variable includes its Census variable code, plain-English label, and the MVP metric it supports.
- The variable list is scoped to MVP use cases only — speculative variables pulled “just in case” indicate poor scope discipline.
- API key path is in `.env.example` and the extraction plan documents the target years and geography level.

**28.2 — Build the ACS extractor**
- Extractor retrieves ACS data reproducibly and documents geography/period parameters rather than hard-coding mystery values.
- Census API row limits and pagination are handled correctly, not assumed to be absent.

**28.3 — Land raw ACS estimates and MOE columns**
- Raw ACS table exists with estimate and MOE column pairs. MOEs are not stripped at ingestion.
- Row count matches expected number of tracts × years.

**28.4 — Land tract geometry for district overlap**
- Tract geometry is available as a PostGIS geometry table, not as a flat coordinate file.
- SRID is documented. Geometry is at the correct geography level (tract, not block group or county).

**28.5 — Declare ACS raw sources in dbt**
- dbt source declarations exist for both ACS estimates and tract geometry tables.

---

### Day 29 — ACS staging and tract geometry staging

**29.1 — Build `stg_acs_tract_estimates`**
- Staging model retains estimate and MOE column pairs. MOE columns are not dropped here.
- Column names are consistent and human-readable — raw Census variable codes like `B19013_001E` become meaningful names.

**29.2 — Build `stg_census_tract_boundaries`**
- Staging model validates SRID, applies the same CRS handling discipline as the district and zoning slices, and records invalid-geometry count.
- Geometry type is correct for tract polygons (not points or lines).

**29.3 — Add ACS staging tests**
- Uniqueness test on tract × year passes.
- Not-null tests cover key estimate columns.
- Year coverage matches the extract plan.

**29.4 — Document the MOE handling policy**
- `acs_usage_policy.md` has a named, explicit MOE policy: carry forward as columns, summarize to reliability flag, or drop with rationale.
- “We didn’t need them” is not an acceptable rationale if MOEs were stripped without documenting why.
- The downstream mart tasks implement this policy consistently.

**29.5 — Validate tract geometry against district geometry**
- CRS of both layers is confirmed to match (or the mismatch is documented with a transform plan).
- Total tract count is recorded. Any obvious geometry extent surprises are noted before the bridge is built.

---

### Day 30 — Bridge table and ACS fact

**30.1 — Build `bridge_tract_district_overlap`**
- Bridge table contains one row per tract × district pair with a computed `overlap_weight` = (intersection area ÷ tract area).
- Per-tract weight sums fall between 0.98 and 1.02 (or the documented tolerance). The tolerance is tested, not claimed.
- Sliver threshold is documented in code comment or YAML — it is not an undocumented magic number.
- A spot-check QA note confirms weight distribution is sensible for a few representative tracts.

**30.2 — Add bridge table QA tests**
- Weight-sum invariant is implemented as a dbt test with the tolerance defined in test parameters, not hard-coded inside SQL.
- FK integrity tests prevent orphaned tract or district keys in the bridge.

**30.3 — Build `fct_tract_acs`**
- `fct_tract_acs` is at tract grain, not district grain. Row count = tracts × years as expected.
- MOE handling follows the documented policy from Task 29.4.
- `dim_date` join uses the year key, not a raw year integer.

**30.4 — Build `agg_district_acs_attributes_hist`**
- The aggregate table is a pre-computed, Metabase-queryable surface using bridge weights — it is not a view that re-runs the intersection every query.
- Each row is one district × year × ACS attribute with a weighted estimate.
- The relationship to `fct_tract_acs` via the bridge is documented in YAML, not just implied by query logic.

**30.5 — Build ACS proxy metric models**
- Proxy models are traceable back to the selected ACS variables and `agg_district_acs_attributes_hist`.
- Caveat language from the usage policy appears in the model descriptions, not just in a separate doc.

---

### Day 31 — ACS documentation, caveats, and Metabase

**31.1 — Add ACS caveat documentation**
- Proxy model YAML descriptions explicitly state that district-level estimates are produced by areal interpolation, not direct survey estimates.
- Caveat language is strong enough to prevent misuse of these values as authoritative demographic statistics.

**31.2 — Connect ACS marts to Metabase**
- All three ACS objects (`agg_district_acs_attributes_hist`, income proxy, tenure proxy) are queryable in Metabase.
- Any field-type or visibility issues are logged.

**31.3 — Create ACS Metabase sanity questions**
- At least 2–3 saved questions exist covering income proxy by district, tenure mix by district, and one YoY comparison.
- The district distributions are plausible against publicly available Philadelphia ACS summaries — this is an explicit sanity check, not just “the query ran.”

**31.4 — Update the ACS limitations register**
- At least 3 new ACS-specific limitations entries: areal interpolation assumptions, MOE aggregation limitations, and any data-quality findings from actual implementation.
- Entries are concrete enough to appear verbatim in a dashboard disclaimer.

**31.5 — Write the ACS vertical-slice recap**
- Recap honestly evaluates whether the bridge table design was worth the implementation cost for the MVP scope.
- If the answer is “could have been simpler,” that is a legitimate finding.

---

### Day 32 — Dashboard assembly

**32.1 — Build the district brief dashboard**
- Dashboard covers at minimum: district selector, permit activity panel, zoning composition panel, and ACS demographic context panel.
- Every panel draws from a tested, implemented mart — no panel points at a raw table or unfinished model.
- Screenshot or runbook entry exists as evidence.

**32.2 — Build the compare-district question**
- Compare-district question places at least two districts side-by-side on a shared metric with a consistent denominator.
- Caveats or data limitations affecting the comparison are visible in the question notes or dashboard text.

**32.3 — Capture the product polish backlog**
- Polish backlog items are concrete and actionable: “field labels are internal names, not human-readable” is acceptable; “make dashboard nicer” is not.

**32.4 — Update the docs index**
- No document created in Weeks 4–5 is missing from the docs index. This is a mechanical check, but it must pass.

---

### Day 33 — Final hardening and month closeout

**33.1 — Run the full project from clean start**
- Full project run proves a clean-start reviewer can reproduce the stack and all 4 dataset slices from repository instructions alone.
- A timing note exists. “It worked on my machine” is not sufficient evidence.

**33.2 — Run all automated checks**
- pytest, `dbt build`, and `dbt docs generate` are all run from their intended entry points and results are recorded.
- Failures, if any, are documented rather than silently worked around.

**33.3 — Write the Month 2 recap**
- Recap explains architecture, all 4 implemented slices, known gaps, and what is deliberately deferred. No gap is hidden.
- A reviewer who has not followed the month can understand what works, what is fragile, and what comes next.

**33.4 — Update the README for implemented architecture**
- README describes the implemented local architecture, run sequence, and reviewer path accurately as of month end.
- Any Month 1 design-only language has been replaced or clearly labeled as design.

**33.5 — Create the Month 3 backlog**
- Backlog is prioritized by impact/dependency and avoids filler items like “improve everything.”
- Full historical backfill, lifecycle snapshot, stronger tests, dashboard polish, performance, and deployment are each represented with a disposition (defer, prioritize, or address in Month 3).

---
