# Fact Table Types — Notes

**Author:** Farid
**Created:** 2026-03-07
**Last Updated:** 2026-03-07 (rev 2)
**Source:** [B1] The Data Warehouse Toolkit (3rd ed.), Chapter 2, pp. 43–44

---

## Purpose

These notes define the two fact table types used in the Philly Data Warehouse —
transaction fact tables and periodic snapshot fact tables — explain the
distinction between them, and document how each maps to a specific analytical
question in this project.

---

## Key Takeaways

- A **transaction fact table** records one row per discrete business event at
  a point in time; it is sparse (rows only exist when something happens)
- A **periodic snapshot fact table** records one row per entity per standard
  period regardless of whether activity occurred; it is uniformly dense
- The choice of fact table type follows from the nature of the business process
  being measured, not from the shape of the data
- **Facts in snapshot tables are often semi-additive** — they can be summed
  across some dimensions (e.g. across entities at the same point in time) but
  not across time periods, because they represent a state rather than an event
- The two fact table types in this project answer two independent analytical
  questions and share conformed dimensions (district, vintage/date)

---

## Detailed Notes

### Transaction Fact Tables

Kimball (p. 43): *"A row in a transaction fact table corresponds to a
measurement event at a point in space and time."*

Key characteristics:
- One row = one discrete event (a transaction, an occurrence, an action)
- Rows exist only when something happens — the table is **sparse**
- Always contains a precise timestamp or date key
- Facts are typically **additive** — they can be summed across all dimensions
- Grain is the individual event, not a period

**Classic example:** a retail sales transaction. Each line item on a receipt is
one row. No sale = no row. You can sum revenue across stores, time periods, or
products freely.

**When to use:** when the source business process generates discrete, countable
events — permits issued, orders placed, claims filed.

---

### Periodic Snapshot Fact Tables

Kimball (p. 43): *"A row in a periodic snapshot fact table summarizes many
measurement events occurring over a standard period, such as a day, a week, or
a month. The grain is the period, not the individual transaction. These fact
tables are uniformly dense in their foreign keys because even if no activity
takes place during the period, a row is typically inserted in the fact table
containing a zero or null for each fact."*

Key characteristics:
- One row = one entity × one standard period (or snapshot date)
- Rows exist for every entity in every period, even with no activity — **uniformly dense**
- Facts often represent a **state** (how much of something exists) rather than
  an event (what happened)
- Facts are typically **semi-additive** — summable across entities at the same
  point in time, but not across time periods (summing states across time
  double-counts)

**Classic example (Kimball Ch. 4 — Inventory):** warehouse stock levels. Each
product at each location gets a row every day showing how many units are on
hand. You can sum across products to get total inventory on a given day, but
summing across days gives a meaningless cumulative total of daily balances.

**When to use:** when the source data represents states that are periodically
snapshotted — inventory levels, account balances, zoning classifications.

---

### Why the Distinction Matters

| | Transaction | Periodic Snapshot |
|---|---|---|
| Row represents | A discrete event | A state as of a period |
| Density | Sparse (no event = no row) | Dense (every entity gets a row) |
| Typical fact type | Additive | Semi-additive |
| Time field | Event timestamp | Snapshot period key |
| Example | Permit issued | Zoning composition in a district-year |

Mixing these two patterns in a single fact table produces a mixed-grain design
error — a fundamental violation of Kimball's grain contract (see
[`kimball_grain_notes.md`](./kimball_grain_notes.md)).

---

## Concrete Examples with Measures

### Transaction Fact Table — Sample Rows

Each row is one permit event. Facts reflect what happened at that moment.

| permit_id | district_id | issue_date | permit_type     | permit_count | permit_fee |
|-----------|-------------|------------|-----------------|--------------|------------|
| PHL-00412 | D09         | 2023-03-14 | New Construction| 1            | 4,200      |
| PHL-00413 | D09         | 2023-03-22 | Alteration      | 1            | 850        |
| PHL-00414 | D06         | 2023-03-28 | Demolition      | 1            | 1,100      |
| PHL-00415 | D06         | 2023-04-01 | New Construction| 1            | 5,600      |

**`permit_count` — Additive**
- `SUM(permit_count)` across districts: `4` → total permits in Philadelphia in March–April 2023 ✓
- `SUM(permit_count)` across months: `4` → total permits over the period ✓
- `SUM(permit_count)` across permit types: `4` → total permits regardless of type ✓
- Safe to sum across **all** dimensions — the count is still counting real, distinct events.

**`permit_fee` — Additive**
- `SUM(permit_fee)` for D09 in March: `$5,050` ✓ (two real permits, two real fees)
- `SUM(permit_fee)` across all districts and months: `$11,750` ✓ (total revenue from permit events)
- Summing across any dimension produces a meaningful total because each row is a distinct financial transaction.

**What additivity means practically:** You can hand this table to a BI tool and let it auto-aggregate however the analyst slices it — by district, by month, by type, or any combination — and get correct answers every time, with no special instructions needed.

---

### Periodic Snapshot Fact Table — Sample Rows

Each row is a state observation: how much land area belongs to a zoning code in a district in a given vintage year.

| district_id | vintage_year | zoning_code | area_sqft   | pct_district_area |
|-------------|--------------|-------------|-------------|-------------------|
| D09         | 2022         | RSA-5       | 18,400,000  | 0.52              |
| D09         | 2022         | CMX-2       |  4,200,000  | 0.12              |
| D09         | 2022         | ICMX        |  2,800,000  | 0.08              |
| D09         | 2023         | RSA-5       | 17,900,000  | 0.51              |
| D09         | 2023         | CMX-2       |  4,700,000  | 0.13              |
| D09         | 2023         | ICMX        |  2,800,000  | 0.08              |

**`area_sqft` — Additive across zoning codes and districts; NOT across time**

Within a single vintage year, summing across zoning codes gives you total district area:

- `SUM(area_sqft)` for D09 in 2022 across all zoning codes = total land area of D09 in 2022 ✓
- `SUM(area_sqft)` for RSA-5 across all districts in 2022 = total RSA-5 land in Philadelphia in 2022 ✓

But summing across time double-counts the same physical land:

- `SUM(area_sqft)` for RSA-5 in D09 across 2022 and 2023 = `18,400,000 + 17,900,000 = 36,300,000` ✗
  - This is not a meaningful number — RSA-5 land in D09 didn't grow to 36M sqft. You measured the same (mostly) land twice.

**`pct_district_area` — Semi-additive**

Can be summed across zoning codes within a single district-year (approaches 100%):

- `SUM(pct_district_area)` for D09 in 2022 across RSA-5 + CMX-2 + ICMX + other codes ≈ `1.00` (100%) ✓
  - This is the definition of composition — what share of the district is each zone?

Cannot be summed across vintage years:

- `SUM(pct_district_area)` for RSA-5 in D09 across 2022 + 2023 = `0.52 + 0.51 = 1.03` ✗
  - Not meaningful. 103% of district area is not a number. You're adding two snapshots of the same state.

Cannot be summed across districts:

- `SUM(pct_district_area)` for RSA-5 across D09 + D06 in 2022 = `0.52 + 0.35 = 0.87` ✗
  - This doesn't represent anything. D09's RSA-5 share and D06's RSA-5 share are percentages of different totals — you can't add them.

**What semi-additivity means practically:** You cannot let a BI tool auto-aggregate `pct_district_area` freely. If a user drags it into a chart and sums it across years or across districts, they get a number that looks plausible but is wrong. The correct aggregation for cross-district comparison is `AVG(pct_district_area)` or a weighted average using `area_sqft`. This must be documented in the metric spec and enforced in the dashboard layer.

**The legitimate query this table supports:**

```sql
-- Which districts shifted the most CMX-2 land area from 2022 to 2023?
SELECT
    district_id,
    MAX(CASE WHEN vintage_year = 2022 THEN pct_district_area END) AS pct_2022,
    MAX(CASE WHEN vintage_year = 2023 THEN pct_district_area END) AS pct_2023,
    MAX(CASE WHEN vintage_year = 2023 THEN pct_district_area END)
        - MAX(CASE WHEN vintage_year = 2022 THEN pct_district_area END) AS pct_change
FROM fct_district_year_zoning_composition
WHERE zoning_code = 'CMX-2'
GROUP BY district_id
ORDER BY pct_change DESC;
```

You're comparing snapshots at a point in time, not summing across time — which is exactly the correct operation for a semi-additive fact.

---

## Application to Project

The Philly Data Warehouse uses both fact table types, one for each of its two
core analytical questions.

### Fact Table 1 — `fct_permits` (Transaction Fact Table)

**Answers:** *"How is each planning district changing physically over time?"*

**Grain:** One row per L&I permit record.

**Why transaction:** Permits are discrete events. A permit is filed at a point
in time, has an address, a type, and a status. When no permits are filed in a
district in a given month, there are simply no rows for that district-month
combination. This is exactly the sparse, event-driven structure of a transaction
fact table.

**Key facts:**
- `permit_count` — derived by aggregation (additive; safe to sum across all
  dimensions)
- `permits_per_land_sq_mile` — normalized intensity metric (non-additive ratio;
  store components and derive at query time)

**Downstream rollup:** `fct_permits` is aggregated to a
`district_month_permits` rollup table (grain: one row per district per calendar
month) for dashboard performance. The rollup is reproducible from the atomic
fact table per the feature vs. rollup policy.

**Source:** L&I permits dataset (S2)

---

### Fact Table 2 — `fct_district_year_zoning_composition` (Periodic Snapshot Fact Table)

**Answers:** *"How is zoning policy changing year-to-year within each district?"*

**Grain:** One row per zoning code × planning district × vintage year.

**Why periodic snapshot:** Zoning data does not record events — it records
states. The source data is annual vintage snapshots of what zoning
classifications exist on the ground. There is no "zoning event" to capture;
instead, we periodically observe the state of the zoning map and measure how
much land area belongs to each class per district. Every district gets a row
for every zoning code present in every vintage year, regardless of whether
anything changed.

**Key facts:**
- `area_sqft` — total land area of this zoning code in this district in this
  vintage year (additive across zoning codes within a district-year)
- `pct_district_area` — share of district land area (**semi-additive**: can be
  summed across zoning codes within a single district-year to reach ~100%;
  must NOT be summed across vintage years — that operation is meaningless)

**Why not SCD Type 2:** A slowly changing dimension tracks *what an entity's
attributes are* over time (descriptive context). A periodic snapshot fact table
measures *how much of something exists* at each point in time. Zoning
composition is a measurement — land area share by class, by district, by year —
not a descriptive attribute. Dimensions describe; fact tables measure. See
[decision log D7](../../docs/decision_log.md) for full rationale.

**Source:** Zoning base districts dataset (S3), joined to planning districts
(S1) via polygon overlay

---

## Relationship Between the Two Fact Tables

The two fact tables are **independent analytical paths** that share conformed
dimensions. See the full ERD: [warehouse_erd.html](./warehouse_erd.html)

Key points:

- `dim_district` and `dim_date` are **single shared tables** — not duplicated.
  Both fact tables carry foreign keys into the same dimension rows, which is
  what Kimball calls a **conformed dimension**.
- `dim_date` is joined at **different granularities**: `fct_permits` looks up a
  month-level key; `fct_district_year_zoning_composition` looks up a
  vintage-year-level key. Same physical table, different grain of join.
- `dim_zoning_code` is exclusive to the zoning fact table — permits do not join
  to it.

The two fact tables are not joined to each other for MVP metrics. Permits answer
question 1; zoning composition answers question 2. They may be brought together
in future analysis (e.g. "districts that rezoned also saw permit surges") but
that is a query-time join, not a warehouse design dependency.

---

## Links

**Related Notes:**
- [kimball_grain_notes.md](./kimball_grain_notes.md) — grain declaration and
  failure modes
- [kimball_facts_notes.md](./kimball_facts_notes.md) — additive, semi-additive,
  and non-additive facts
- [mvp_metrics_definitions.md](../data-sources/mvp_metrics_definitions.md) — how metrics map
  to the two analytical questions

**Project Documents:**
- [Decision log D7](../../docs/decision_log.md) — two-fact-table design decision
- [Feature vs. rollup policy](../../docs/policies/feature_vs_rollup_policy.md) —
  Example B: zoning composition rollup

---

## References

- **[B1]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd
  ed.), Chapter 2, pp. 43–44. See [Resources](../.claude/resources.md).

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-07 | Initial notes created | Farid  |
| 2026-03-07 | Added concrete examples with measures; additive/semi-additive analysis with practical implications | Farid  |
