# SQL Antipatterns (B5) — Ch. 9 & Ch. 11 Notes

**Author:** Farid
**Created:** 2026-03-06
**Last Updated:** 2026-03-06
**Sources:** [B5] Karwin, *SQL Antipatterns*, Ch. 9 (pp. 110–121) & Ch. 11 (pp. 131–138)

---

## Purpose

These notes capture the two antipatterns from [B5] most directly relevant to the Philly warehouse: **Metadata Tribbles** (Ch. 9) and **31 Flavors** (Ch. 11). Both chapters address the same root mistake from different directions — letting data values bleed into schema design — and together informed the permit category grouping decision in Task 7.5.

---

## Key Takeaways

- Both antipatterns share a root cause: **data values becoming schema objects** (table names, column names, or constraint definitions). The schema becomes a snapshot of today's data instead of a stable structure that holds any data.
- The fix in both cases is the same direction: **keep volatile business values as rows in a table, not as metadata in the schema**.
- Karwin's summary line from Ch. 11 covers both chapters: *"Use metadata when validating against a fixed set of values. Use data when validating against a fluid set of values."*
- **Metadata Tribbles** is the table/column spawning form: `Permits_2021`, `Permits_2022`, or `permit_count_2021`, `permit_count_2022`.
- **31 Flavors** is the constraint-baking form: `CHECK (permittype IN ('BUILDING', 'ELECTRICAL', ...))` or `ENUM('BUILDING', 'ELECTRICAL', ...)`.
- Both are recognizable by the same tell: **when new data requires a new schema object** (a new table, a new column, or an ALTER TABLE), that's the antipattern in action.

---

## Detailed Notes

### Chapter 9 — Metadata Tribbles: Don't Let Data Spawn Schema Objects

#### The antipattern

The objective is performance — querying a smaller table is faster. The mistaken solution is to split one table into many, using a data value (like year or category) as the split key:

```sql
-- Antipattern: table per year
CREATE TABLE Permits_2021 ( ... );
CREATE TABLE Permits_2022 ( ... );
CREATE TABLE Permits_2023 ( ... );
-- And now you need Permits_2024...
```

Or the column variant — splitting one column into many:

```sql
-- Antipattern: column per year
CREATE TABLE DistrictMetrics (
    district_id   INT,
    permit_count_2021  INT,
    permit_count_2022  INT,
    permit_count_2023  INT
    -- Need to ALTER TABLE every new year
);
```

In both cases, a **data value** (the year) has become a **metadata object** (a table name or column name).

#### Why it breaks

**Update anomalies:** Correcting a permit's issue date from 2022 to 2021 means deleting from `Permits_2022` and inserting into `Permits_2021` — a multi-table operation for what should be a single UPDATE.

**Referential integrity is impossible:** A `Comments` table that needs to FK to permits can't write `FOREIGN KEY (permit_id) REFERENCES Permits_????(permit_id)` — there's no single table to reference.

**Query complexity grows unbounded:** Every cross-year query requires an expanding UNION:

```sql
SELECT * FROM Permits_2021
UNION ALL SELECT * FROM Permits_2022
UNION ALL SELECT * FROM Permits_2023
-- Next year: add another UNION ALL
```

**Schema sync:** Adding a new column (say, `district_id`) requires ALTER TABLE on every split table. Miss one and your UNION queries break.

**New data demands new schema objects:** On January 1, 2024, the pipeline fails because `Permits_2024` doesn't exist yet. The code that routes inserts has to be updated before any data flows.

#### The solution

One table with a `year` (or `date`) column. Let data be data:

```sql
CREATE TABLE Permits (
    permit_id     SERIAL PRIMARY KEY,
    permittype    VARCHAR(50),
    issue_date    DATE,
    district_id   INT
    -- year is just a column value, not a table name
);
```

For genuine performance needs, use **horizontal partitioning** — the database manages the physical split while you still query a single logical table:

```sql
CREATE TABLE Permits (
    ...
    issue_date DATE
) PARTITION BY HASH (EXTRACT(YEAR FROM issue_date))
  PARTITIONS 4;
```

For rarely-queried bulky columns, use **vertical partitioning** — split by columns into a dependent table rather than by rows into separate tables. This keeps your main table lean for the queries you run most often.

#### Recognition signs (from Karwin, p. 116)
- *"We need a table per [data value]..."*
- *"How do I query a table name dynamically?"*
- *"We forgot to create the new year's table."*
- *"How do I search many tables at once? They all have the same columns."*

---

### Chapter 11 — 31 Flavors: Don't Bake Valid Values into the Schema

#### The antipattern

The objective is valid: restrict a column to a known set of values so invalid data can't enter. The mistaken solution is to encode those values in the column definition itself:

```sql
-- Antipattern: CHECK constraint
CREATE TABLE Permits (
    permittype VARCHAR(20)
        CHECK (permittype IN ('BUILDING', 'ELECTRICAL', 'PLUMBING'))
);

-- Antipattern: ENUM (MySQL)
CREATE TABLE Permits (
    permittype ENUM('BUILDING', 'ELECTRICAL', 'PLUMBING')
);
```

This seems safe — until the city adds a new permit type.

#### Why it breaks

**Adding a new value requires DDL:**

```sql
-- Have to redefine the whole column
ALTER TABLE Permits MODIFY COLUMN permittype
    ENUM('BUILDING', 'ELECTRICAL', 'PLUMBING', 'NEW_TYPE');
```

In some databases this locks the table, requiring ETL operations or downtime. As Karwin notes, changing metadata should be infrequent and carefully tested — but permit categories can change at any time with no announcement.

**Retiring old values is dangerous:** If you remove `'FIXED'` from an ENUM because the status was renamed, all historical rows that used `'FIXED'` now reference an invalid value. You can't simply delete it.

**Querying the valid set is awkward:** To populate a dropdown with valid permit types, you need to parse `INFORMATION_SCHEMA` — a query that returns the constraint definition as a raw string, not a clean result set.

**The application code problem:** Many teams maintain a parallel list of valid values in application code (a Python list or a config file). When the DB constraint is updated but the app code isn't (or vice versa), they drift out of sync silently.

#### Real-world example: FIPS county codes

FIPS codes identify counties in the U.S. and occasionally get reassigned or changed when jurisdictions are reorganized. If you write:

```sql
CREATE TABLE Counties (
    fips_code VARCHAR(5)
        CHECK (fips_code IN ('42001', '42003', '42005', ...))
);
```

...then when a FIPS code changes, you need a DDL operation to update the constraint. This was observed in practice on a vaccination analysis project where codes shifted mid-analysis.

The lookup table solution handles this gracefully — just INSERT the new code, UPDATE the old one to `active = FALSE`.

#### The solution: lookup table with FK

Store valid values as rows in a reference table, not in the column definition:

```sql
CREATE TABLE PermitTypes (
    permittype  VARCHAR(50) PRIMARY KEY,
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    notes       TEXT
);

INSERT INTO PermitTypes (permittype) VALUES
    ('BUILDING'), ('ELECTRICAL'), ('PLUMBING');

CREATE TABLE Permits (
    permit_id   SERIAL PRIMARY KEY,
    permittype  VARCHAR(50),
    FOREIGN KEY (permittype) REFERENCES PermitTypes(permittype)
        ON UPDATE CASCADE
);
```

**Key advantages:**

- Adding a new value: `INSERT INTO PermitTypes VALUES ('NEW_TYPE', TRUE, NULL);` — no DDL, no downtime
- Retiring a value: `UPDATE PermitTypes SET active = FALSE WHERE permittype = 'OLD_TYPE';` — historical rows still reference a valid FK, but the value is excluded from new entries
- Querying valid values: `SELECT permittype FROM PermitTypes WHERE active = TRUE ORDER BY permittype;` — a standard SELECT, not a metadata parse
- Portability: relies on standard FK constraints, not proprietary ENUM syntax

**For fluid categories, add the unmapped catch-all:**

Any value not in the lookup table falls into an `'Other/Unmapped'` group rather than rejecting the row. This is the difference between a pipeline that *breaks* on new data and one that *absorbs* it while making the gap visible.

#### Recognition signs

- *"We have to take the database offline to add a new choice to a menu."*
- *"The status column can only have these values — we shouldn't need to revise this list."* (*Shouldn't need to* ≠ *can't.*)
- *"The list in the application code got out of sync with the database again."*

---

## Application to Project

### Ch. 9 — Metadata Tribbles

**Don't do this:**
```sql
-- Wrong: table per permit year
CREATE TABLE li_permits_2021 ( ... );
CREATE TABLE li_permits_2022 ( ... );
```

**Don't do this either:**
```sql
-- Wrong: column per year in rollup
CREATE TABLE district_metrics (
    district_id         INT,
    permit_count_2021   INT,
    permit_count_2022   INT,
    permit_count_2023   INT
);
```

**Do this:**
```sql
-- Right: one permits table, year is a value
CREATE TABLE stg_li_permits (
    permit_id       TEXT PRIMARY KEY,
    permittype      TEXT,
    issue_date      DATE,
    district_id     INT
    -- year extracted at query time: EXTRACT(YEAR FROM issue_date)
);

-- Right: one rollup table, year is a dimension column
CREATE TABLE fct_district_month (
    district_id     INT,
    year_month      DATE,  -- e.g., 2022-03-01
    permit_count    INT
);
```

### Ch. 11 — 31 Flavors

**Don't do this:**
```sql
-- Wrong: baked ENUM
CREATE TABLE stg_li_permits (
    permittype ENUM('BUILDING', 'ELECTRICAL', 'ZONING/USE REGISTRATION', ...)
);
```

**Do this:**
```sql
-- Right: lookup table
CREATE TABLE permit_category_groups (
    category_id      SERIAL PRIMARY KEY,
    raw_permittype   TEXT UNIQUE,
    canonical_group  TEXT NOT NULL,  -- e.g., 'Building', 'Zoning/Use', 'Other/Unmapped'
    active           BOOLEAN NOT NULL DEFAULT TRUE,
    notes            TEXT
);

-- stg_li_permits.permittype LEFT JOINs to permit_category_groups.raw_permittype
-- NULLs → canonical_group = 'Other/Unmapped' in the transform layer
```

**Three drift scenarios this handles for our project:**
1. **New permittype value added** → INSERT into lookup table, no DDL
2. **HANSEN → ECLIPSE label mismatch** → INSERT both `'ZP_ZONING'` and `'ZONING/USE REGISTRATION'` as separate rows mapping to the same `canonical_group`
3. **Silent typeofwork label drift** → excluded from primary grouping for MVP; if added later, same lookup table pattern applies

**Visual reference:** [`sql_antipatterns_b5_visual.html`](./sql_antipatterns_b5_visual.html)

---

## Open Questions

- [ ] What are the exact 14 `permittype` values in the 5-year ECLIPSE window? (Confirm at ingest time — populate `permit_category_groups` from this list)
- [ ] Does Postgres support declarative table partitioning in our Docker setup? (Relevant if permits table grows beyond manageable size in Month 2)
- [ ] What's the actual null rate for `commercialorresidential` in the 5-year window? (Determines whether secondary slice is usable — suppress if > 10%)

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | The lookup table pattern (FK + active column) is sufficient for MVP category management without needing full SCD Type 2 | If permit type labels change frequently with historical significance, start_date/end_date columns may be needed in the lookup table to track when each mapping was valid |
| A2 | Horizontal partitioning is not needed for the 5-year permits slice (~185k rows) | If query performance degrades at scale, revisit partitioning strategy — but don't over-engineer for MVP |

---

## Links

**Related Documents:**
- Permit category grouping memo: [`../../docs/decisions/permit_category_grouping_memo.md`](../../docs/decisions/permit_category_grouping_memo.md)
- L&I permits critical fields dictionary: [`../../docs/data_dictionary/li_permits_critical_fields.md`](../../docs/data_dictionary/li_permits_critical_fields.md)
- Permit category grouping visual: [`./sql_antipatterns_b5_visual.html`](./sql_antipatterns_b5_visual.html)

**Related Notes:**
- Kimball grain notes: [`./kimball_grain_notes.md`](./kimball_grain_notes.md)
- PostGIS spatial primer: [`./postgis_spatial_primer_notes.md`](./postgis_spatial_primer_notes.md)

---

## References

- **[B5]** Karwin, B. (2010). *SQL Antipatterns: Avoiding the Pitfalls of Database Programming.* The Pragmatic Bookshelf.
  - Ch. 9 — Metadata Tribbles (pp. 110–121)
  - Ch. 11 — 31 Flavors (pp. 131–138)

---

## Change Log

| Date | Change Description | Author |
|---|---|---|
| 2026-03-06 | Initial notes created from Task 7.5 discussion session | Farid |
