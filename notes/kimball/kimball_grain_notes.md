# Kimball: Grain — Notes

**Author:** Farid
**Created:** 2026-03-02
**Last Updated:** 2026-03-02
**Source:** [B1] The Data Warehouse Toolkit (3rd ed.), Chapter 2, p. 39

---

## Purpose

These notes capture Kimball's grain concept and apply it to the four planned fact/snapshot tables in the Philly Data Warehouse. The goal is to be able to declare grain precisely and avoid mixed-grain design errors later.

---

## Key Takeaways

- Grain is a **business-level declaration** of what one row in a fact table represents — made before choosing dimensions or facts, not derived from them
- Grain must be declared at the **atomic level**: the lowest level at which the business process captures data
- The grain declaration is a **binding contract** on the design — every dimension and fact added to the table must be consistent with it
- **Different grains must never be mixed in the same fact table** — this is a design error, not a query problem
- **Joining tables at incompatible grains** without accounting for granularity differences corrupts aggregations silently

---

## Detailed Notes

### What Grain Is

Kimball (p. 39): *"Declaring the grain is the pivotal step in a dimensional design. The grain establishes exactly what a single fact table row represents. The grain declaration becomes a binding contract on the design."*

Grain is expressed in plain language as **"one row per [business event or snapshot]"** before any technical design begins. The keys and columns follow from the grain; the grain does not follow from the keys.

**Atomic grain** = the lowest level at which data is captured by a given business process. Kimball strongly recommends starting at atomic grain because it withstands unpredictable user queries. Pre-aggregated summary tables are built on top of atomic tables for performance, but the atomic table is the source of truth.

### Failure Mode 1 — Mixed Grain (Design Error)

Occurs when rows in a single fact table represent different things.

**Example — Wrong (mixed grain):**

| permit_id | event_type | date       | permit_count |
|-----------|------------|------------|--------------|
| PHL-001   | issued     | 2024-01-15 | 1            |
| PHL-001   | completed  | 2024-06-20 | 1            |
| PHL-002   | issued     | 2024-02-01 | 1            |

`SUM(permit_count)` returns 3 — but there are only 2 unique permits. PHL-001 was counted twice.

**Why `COUNT(DISTINCT permit_id)` doesn't fully fix this:**
- It assumes every analyst knows the grain is mixed — new team members won't
- It doesn't fix other metrics: `SUM(permit_fee)` still double-counts without separate deduplication logic
- BI tools (Tableau, Power BI) auto-aggregate and have no way to know `DISTINCT` is needed — users get silent wrong answers

**Correct design (accumulating snapshot):**

| permit_id | issued_date | completed_date |
|-----------|-------------|----------------|
| PHL-001   | 2024-01-15  | 2024-06-20     |
| PHL-002   | 2024-02-01  | NULL           |

One row per permit. Milestones become date columns. No double-counting possible.

### Failure Mode 2 — Incompatible Grain Join (Query Error)

Occurs when two tables at different grains are joined carelessly, causing rows from the higher-grain table to fan out across the lower-grain table.

**Example — District-month joined to District-year:**

District-month (one row per district per calendar month):

| district   | month   | permit_count |
|------------|---------|--------------|
| Kensington | 2024-01 | 45           |
| Kensington | 2024-02 | 38           |
| ...        | ...     | ...          |
| Kensington | 2024-12 | 42           |

District-year (one row per district per year):

| district   | year | median_income |
|------------|------|---------------|
| Kensington | 2024 | $32,000       |

**Careless JOIN result:**

| district   | month   | permit_count | median_income |
|------------|---------|--------------|---------------|
| Kensington | 2024-01 | 45           | $32,000       |
| Kensington | 2024-02 | 38           | $32,000       |
| ...        | ...     | ...          | ...           |
| Kensington | 2024-12 | 42           | $32,000       |

`SUM(permit_count)` = correct. `SUM(median_income)` = $32,000 × 12 = **$384,000** — silently wrong.

The demographic figure fanned out across 12 rows and corrupts any aggregation that touches it. The fix is to aggregate the lower-grain table to match the higher-grain table before joining, or to join on the correct key (year, not month).

---

## Application to Project

### Declared Grains for the Philly Data Warehouse

| Table | Grain Statement | Fact Table Type |
|-------|----------------|-----------------|
| Permits | One row per building permit in Philadelphia | Accumulating Snapshot |
| Zoning polygon-vintage | One row per district boundary version as of a specific effective date | Dimension (SCD Type 2) |
| District-month | One row per planning district per calendar month | Periodic Snapshot |
| District-year | One row per planning district per year | Periodic Snapshot |

**Notes on permits grain:**
- L&I data distinguishes permits from inspections — a permit is issued once and has its own unique permit number tied to an address
- Permit status can transition (issued → completed/cancelled), so the table is modeled as an accumulating snapshot with milestone date columns, not as separate rows per status event
- "One row per permit issued" was rejected because "issued" implies a point-in-time status; the row actually tracks the full permit lifecycle

**Notes on district-month vs district-year:**
- District-month = permit activity rolled up by district and calendar month (derived from atomic permits table for query performance)
- District-year = ACS demographic snapshots by district and year (ACS data is not available at monthly granularity)
- These two tables must never be joined without first aggregating district-month to the yearly level, or joining only on the correct shared key (district + year)

---

## Open Questions

- [ ] Does L&I data contain permit amendment or revision records that would add rows for the same permit number? Needs verification when cataloging the dataset (Task 3.x)
- [ ] What are the exact milestone columns needed for the accumulating snapshot permits table? (issued_date, completed_date, cancelled_date — to be confirmed)
- [ ] Are planning district boundaries the same as zoning district boundaries in Philadelphia, or are these different geographies?

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | Each L&I permit has one unique permit number and does not generate multiple rows for status transitions in the source data | Grain would need to change from accumulating snapshot to transaction fact table; ETL logic would need deduplication |
| A2 | ACS demographic data is only available at annual granularity for Philadelphia planning districts | District-year table design would need to change if sub-annual ACS data exists |
| A3 | Planning district boundaries change infrequently enough that a vintage/SCD approach is sufficient | If boundaries change continuously, a different temporal modeling approach may be needed |

---

## Links

**Related Notes:**
- Kimball Facts Notes: [`kimball_facts_notes.md`](./kimball_facts_notes.md) *(Task 2.6 — upcoming)*

**Project Documents:**
- Docs folder: [`../../docs/`](../../docs/)

---

## References

- **[B1]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.), Chapter 2, pp. 39–40. See [Resources](../../.claude/resources.md).

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-02 | Initial notes created | Farid  |
