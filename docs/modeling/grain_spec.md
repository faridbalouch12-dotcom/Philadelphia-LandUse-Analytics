# Grain spec

**Author:** Farid  
**Created:** 2026-03-08  
**Last Updated:** 2026-03-08  
**Status:** Draft  

---

## Purpose

This document defines the row-level grain contract for Week 3 modeling tables
so joins and metrics stay consistent.

---

## Scope

**In scope:**
- Five explicit grain statements
- One example primary key per table
- Two failure modes to avoid

**Out of scope:**
- Physical DDL and indexing
- dbt implementation details
- Full metric formulas

---

## Grain statements

| ID | Table | Grain statement (one row = ...) | Example PK |
|---|---|---|---|
| G1 | `fct_permits` | one issued permit event from L&I, filtered in staging to `status = 'Issued'` and keyed to `permitissuedate` | `permitnumber` |
| G2 | `fct_district_year_zoning_composition` | one planning district x one vintage year x one zoning code composition snapshot | (`district_id`, `vintage_year_key`, `zoning_code`) |
| G3 | `bridge_tract_district_overlap` | one census tract x one planning district x one boundary version overlap relationship where overlap exists | (`geoid_tract`, `district_id`, `boundary_version`) |
| G4 | `fct_tract_acs` | one census tract x one ACS period snapshot with estimate and MOE columns | (`geoid_tract`, `acs_period_label`) |
| G5 | `dim_date` | one calendar date in the conformed time dimension | `date_key` |

**Notes for G3 (`bridge_tract_district_overlap`):**
- Expected measures: `overlap_area_sqft`, `pct_tract_area`
- Assignment metadata: `assignment_method = 'overlap_any'`

---

## Failure modes to avoid

### FM1. Mixed status/event logic in permits fact

If non-issued statuses are loaded into `fct_permits`, the fact no longer
represents physical-change intent consistently.

### FM2. Fan-out duplication from overlap joins

`bridge_tract_district_overlap` is many-to-many by design. If `fct_tract_acs`
is joined through overlap rows and then aggregated without explicit grouping
rules, tract contributions can be double-counted across districts.

---

## Links

- Decision log: [`docs/decision_log.md`](../decision_log.md)
- Week 2 recap: [`docs/week2_recap.md`](../week2_recap.md)
- ACS alignment note: [`docs/feasibility/acs_to_district_alignment_note.md`](../feasibility/acs_to_district_alignment_note.md)

---

## References

- **[B1]** Kimball, R., and Ross, M. *The Data Warehouse Toolkit* (3rd ed.). See [Resources](../../.claude/resources.md).

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-08 | Initial Task 11.1 draft with five grain statements, PK examples, and failure modes | Farid |
| 2026-03-08 | Finalized through tutor discussion: issued-only permits, overlap-based tract mapping, and retained boundary version | Farid |
