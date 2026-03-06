# Permit Category Grouping Decision Memo (MVP)

**Author:** Farid
**Created:** 2026-03-06
**Last Updated:** 2026-03-06
**Status:** Draft

---

## Purpose

This memo documents the decision on how to group L&I permit category fields for the MVP composition metric. The goal is to lock a grouping philosophy before pipeline implementation to prevent silent errors, category drift, and unmaintainable schema designs downstream. The decision is grounded in the structure of the raw `permittype` field and informed by the antipatterns in [B5] (SQL Antipatterns, Ch. 9 and Ch. 11).

---

## Scope

**In Scope:**
- Primary grouping field selection for the permits composition metric
- Mapping architecture (lookup table vs. schema-baked values)
- Category drift risks and mitigation strategies for the 5-year ECLIPSE window

**Out of Scope:**
- Geocoding quality and district assignment accuracy (see Task 7.6)
- Full permits dimension schema design (Week 3)
- Historical pre-2020 HANSEN data extension (deferred beyond MVP)
- Contractor grouping (requires heavy entity resolution; deferred)

---

## Definitions

- **Grouping philosophy:** The combination of (1) which source field drives category groupings, (2) what canonical buckets are defined, and (3) how the mapping from raw values to canonical buckets is stored and maintained.
- **Lookup table:** A reference table storing valid category values as rows, referenced via a foreign key from the permits staging table. Allows adding or retiring values without schema changes. See [Glossary](../glossary.md).
- **Category drift:** Incremental change in the string values of a categorical field over time — either new values appearing, old values disappearing, or the same concept labeled differently across source system versions or time.
- **Unmapped catch-all:** A designated canonical group (e.g., `"Other/Unmapped"`) that absorbs any raw value not present in the lookup table, preventing pipeline breakage and preserving observability.

---

## Grouping Philosophy

### Primary Grouping Field: `permittype`

`permittype` is selected as the primary grouping field for the MVP composition metric. It has 14 distinct non-overlapping values in the 5-year ECLIPSE window (2021–2026), low enough to be manageable and meaningful for district-level composition analysis.

It answers the most relevant question for the district change story: **what kind of work is being done in this district?**

| Field | Cardinality (5yr) | Stability | MVP Role |
|---|---|---|---|
| `permittype` | 14 | Medium (drift possible but slow) | **Primary grouping** |
| `commercialorresidential` | 3 (incl. null) | High | Optional secondary slice |
| `typeofwork` | ~59 (full dataset) | Low — silent label drift | Excluded from primary grouping |
| `permitdescription` | Mirrors `permittype` | Medium | Display label / QA only |

### Secondary Slice: `commercialorresidential`

`commercialorresidential` is used as an optional secondary cut. It is binary (Commercial / Residential / NULL) and stable, allowing analysts to further slice permit composition by property type. It is not the primary grouping axis because it answers *who the permit is for*, not *what kind of work is happening* — a less informative lens for the district change story. If null rate exceeds 10% in-window, this slice should be suppressed from displayed metrics.

### Excluded: `typeofwork`

`typeofwork` is explicitly excluded from primary grouping for MVP. It has high cardinality (~59 distinct values across the full dataset) and documented silent label drift (e.g., `"Alterations"` vs `"Addition/Alteration"`). It may be introduced in a later phase with a dedicated mapping table and unmapped share monitoring.

---

## Mapping Architecture

Raw `permittype` values are mapped to canonical groups via a **lookup table**, not via ENUM or CHECK constraints embedded in the column definition. This directly applies the solution from [B5] Ch. 11:

> *"Use metadata when validating against a fixed set of values. Use data when validating against a fluid set of values."*

The permit category groupings are a fluid set — the city can introduce new permit types at any time. Baking them into the schema would require DDL changes (ALTER TABLE) to accommodate new values, potentially interrupting the pipeline or requiring ETL operations. A lookup table avoids this entirely.

**Proposed lookup table structure:**

```
permit_category_groups
├── category_id        (surrogate PK — stable across renames)
├── raw_permittype     (raw string from source — FK target from permits staging)
├── canonical_group    (stable bucket name, e.g., "Building", "Zoning/Use", "Mechanical/Trade")
├── active             (BOOLEAN — retire old mappings without deleting rows)
└── notes              (optional — documents why a mapping decision was made)
```

**Unmapped catch-all:** Any `raw_permittype` value that does not match a row in `permit_category_groups` is assigned to an `"Other/Unmapped"` canonical group. This means:

- Pipeline never breaks on a new value
- Unknown values are visible in composition charts rather than silently dropped
- Unmapped share is monitorable — an alert triggers if it exceeds 1% in any monthly load

**Visual reference:** [`../../notes/permit_category_grouping_visual.html`](../../notes/permit_category_grouping_visual.html)

---

## Assumptions

| ID | Assumption | Impact if Wrong | Mitigation |
|----|-----------|----------------|------------|
| A1 | `permittype` has 14 stable, non-overlapping values in the 5-year ECLIPSE window with no mid-window schema changes | New values push permits into the catch-all bucket; composition metrics undercount specific categories until the lookup is updated | Monitor unmapped share per monthly load; alert if > 1% |
| A2 | `commercialorresidential` null rate is low enough in the 5-year window to support use as a secondary slice | If null rate is high, the secondary slice produces misleading percentage shares | Track null rate at ingest; suppress secondary slice if null > 10% |
| A3 | The ECLIPSE system of record is stable for the full 5-year window (2021–2026) | If a new system transition occurs mid-window, category labels may shift without notice | Use `systemofrecord` field to detect regime changes at ingest; treat any non-ECLIPSE records as requiring separate mapping |

---

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| R1 | New `permittype` values emerge mid-pipeline | Low (5-yr ECLIPSE window is stable) | High — breaks ingestion if hardcoded; silently drops if unhandled | Lookup table with unmapped catch-all bucket; monitor unmapped share per load; update lookup table as new values are confirmed |
| R2 | HANSEN→ECLIPSE cross-era label mismatch creates phantom category splits | Low for MVP (5-yr window is 100% ECLIPSE) | High if historical extension is attempted | Document known cross-era label pairs (e.g., `"ZP_ZONING"` → `"ZONING/USE REGISTRATION"`); apply canonical mapping in staging before any cross-era join; lookup table handles this by accepting both raw values as separate rows mapping to the same canonical group |
| R3 | Silent incremental label drift in `typeofwork` creates phantom category splits | Medium (ongoing, unannounced — no schema change notice given) | Medium — composition metrics show artificial trend where none exists | Exclude `typeofwork` from primary MVP grouping entirely; if introduced in a later phase, enforce unmapped catch-all and monthly drift monitoring; distinguish from R2 in that this drift is continuous and undocumented, not a one-time transition event |

---

## References

- **[B5]** Karwin, B. (2010). *SQL Antipatterns: Avoiding the Pitfalls of Database Programming.* The Pragmatic Bookshelf.
  - Ch. 9 — Metadata Tribbles (pp. 110–121): don't let data values spawn schema objects (tables or columns)
  - Ch. 11 — 31 Flavors (pp. 131–138): store valid category values as data in a lookup table, not as metadata in column definitions
- **[S2]** OpenDataPhilly. *L&I Building and Zoning Permits.* https://opendataphilly.org/datasets/licenses-and-inspections-building-and-zoning-permits/

---

## Links

**Related Documents:**
- L&I Permits critical fields dictionary: [`../data_dictionary/li_permits_critical_fields.md`](../data_dictionary/li_permits_critical_fields.md)
- L&I Permits source catalog: [`../source_catalog/li_permits.md`](../source_catalog/li_permits.md)
- Limitations register: [`../limitations_register.md`](../limitations_register.md)

**Visual Supplements:**
- Grouping architecture diagram: [`../../notes/permit_category_grouping_visual.html`](../../notes/permit_category_grouping_visual.html)

---

## Change Log

| Date | Change Description | Author |
|---|---|---|
| 2026-03-06 | Initial draft | Farid |
