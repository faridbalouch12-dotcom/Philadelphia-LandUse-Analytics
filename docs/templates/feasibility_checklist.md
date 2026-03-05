# Feasibility Checklist Template

**Author:** Farid
**Created:** 2026-03-04
**Last Updated:** 2026-03-04
**Status:** Draft

Purpose: Use this checklist to decide whether a dataset is viable for the MVP and what must be documented before it can be safely used in district-first metrics.

This template is designed to answer:
- Does this dataset have a usable time field to aggregate by month/year?
- Can records be linked to a planning district via geometry or address?
- Are the key fields complete enough to be trustworthy?
- Are category values stable enough to group over time (or will schema drift break your metrics)?
- Are there any known blockers that would prevent MVP use?

When filling this out, pull dataset-specific “Top risks” from `03_mvp_datasets.md` and map them into the sections below (Time / Geo / Keys / Categories / Blockers).

---

## Dataset header
- Dataset name:
- Dataset ID (e.g., S1/S2/S3/D1):
- Source page / endpoint:
- Reviewer:
- Date:
- MVP role (district spine / permits fact / zoning snapshots / ACS context):

---

## 1) Time field selection

**Goal:** confirm there is at least one time field that can support your planned aggregation (monthly for permits; yearly/vintage for zoning; period label for ACS).

**Questions to answer**
- Does the dataset contain a time field that represents the event time (preferred) or at least a consistent proxy?
- Can the time field support aggregation at the required grain (month/year/period)?
- Are there multiple candidate time fields (e.g., application date vs issue date) that could change interpretation?

**Fill in**
- Candidate time fields (list all):
- Selected canonical time field for MVP:
- Time semantics (event time vs update time vs period estimate):
- Expected missingness / quirks:
- Time coverage (start–end):
- Aggregation grain supported (month/year/period):

**Pass criteria**
- A single canonical time field is selected and justified.
- Known caveats are documented (e.g., backfills, updates to historical records).

**If not pass, what’s the mitigation?**
- (e.g., choose alternate time field, restrict time window, treat as snapshot only, etc.)

---

## 2) Geo linkage approach

**Goal:** confirm records can be assigned to planning districts (district-first) and retained as feature-level geometry (map-first ready) where applicable.

**Questions to answer**
- Can records be linked to planning districts via geometry (point/polygon overlay)?
- If no geometry, can you geocode reliably from address (and how will you measure failure)?
- What happens for records near district boundaries?

**Fill in**
- Geometry present? (yes/no). If yes, type (point/polygon/line):
- District assignment method (geometry overlay / address geocode / crosswalk):
- Expected “unassigned” share and how you’ll measure it:
- Boundary-edge risk and how you’ll report it:
- CRS / geometry validity concerns (if known):

**Pass criteria**
- There is a clear, auditable linkage method.
- You have a plan to quantify linkage quality (e.g., unassigned %; near-boundary share).

**If not pass, what’s the mitigation?**
- (e.g., fallback linkage method, limit to records with valid geometry, etc.)

---

## 3) Key field completeness

**Goal:** confirm you can uniquely identify records (or define a stable composite key) to avoid duplicates and enable consistent rollups.

**Questions to answer**
- Is there a stable unique identifier (permit number, GEOID, polygon id, etc.)?
- Are key fields populated at a high enough rate to trust joins and deduping?
- Do you expect duplicates (revisions/amendments), and how will you treat them?

**Fill in**
- Candidate primary key / unique ID field(s):
- Uniqueness confidence (high/med/low) + why:
- Expected completeness (% non-null) and any known gaps:
- Composite key (if needed):
- Deduping policy (if duplicates exist):
- Join keys to other tables (district_id, vintage_year, GEOID, etc.):

**Pass criteria**
- A key strategy exists (unique or composite) and is documented.
- Known duplicate/revision behavior is acknowledged.

**If not pass, what’s the mitigation?**
- (e.g., create surrogate key, restrict to subset with reliable ids, etc.)

---

## 4) Category stability

**Goal:** confirm you can group records over time without schema drift or label drift breaking metrics.

**Questions to answer**
- Are categorical fields (permit type, zoning class, status, etc.) stable across time?
- Do label values drift (e.g., “Res” vs “Residential”)?
- Do new categories appear over time that would bias comparisons?

**Fill in**
- Categorical fields used in MVP metrics:
- Known drift risks (label drift, new categories, redefinitions):
- Proposed grouping strategy (coarse groups / mapping table / “unknown” bucket):
- Comparability constraints (what comparisons are unsafe):
- How you’ll monitor drift over time (conceptually):

**Pass criteria**
- Grouping logic is robust to drift (or drift is explicitly scoped out).
- You have a plan to track “unknown/unmapped” share.

**If not pass, what’s the mitigation?**
- (e.g., reduce to fewer groups, stop using category breakdowns in MVP, etc.)

---

## 5) Known blockers

**Goal:** identify anything that would prevent MVP use (access limits, missing essential fields, inconsistent vintages).

**Questions to answer**
- Are there access constraints (rate limits, row caps, authentication) that block ingestion?
- Is the dataset too incomplete (time/geo/key fields) to support MVP questions?
- Are yearly/vintage layers inconsistent enough to block automation?

**Fill in**
- Access blockers (rate limits, payload size, missing endpoints):
- Field blockers (missing time field, missing geometry, missing IDs):
- Versioning blockers (schema changes across vintages/years):
- Legal/licensing blockers (if any):
- MVP decision (Use now / Use with constraints / Defer):

**Pass criteria**
- No blockers that prevent using the dataset for MVP at the chosen scope.

---

## Risk mapping from `03_mvp_datasets.md`

**Goal:** explicitly map the dataset’s “Top risks” into mitigation actions and where they will be tracked (limitations register, decision log, metric caveats).

- Relevant risks from `03_mvp_datasets.md` (copy IDs + summary):
- Where each risk is tracked:
  - Limitations register item(s):
  - Metric caveats:
  - Decision log entry (if applicable):
- Mitigation plan per risk:

---

## Final feasibility verdict

- Verdict: ✅ Use for MVP / ⚠️ Use with constraints / ❌ Defer
- Constraints (if any):
- Next validation step(s) and owner:

## Change Log

| Date       | Change Description          | Author |
|------------|-----------------------------|--------|
| 2026-03-04 | Initial draft               | Farid  |
