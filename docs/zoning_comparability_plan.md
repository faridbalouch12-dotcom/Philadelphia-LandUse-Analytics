# Zoning Year-to-Year Comparability Plan

**Author:** Farid
**Created:** 2026-03-08
**Last Updated:** 2026-03-08
**Status:** Final

> **Note:** This document supersedes [`zoning_comparability_plan_draft.md`](./zoning_comparability_plan_draft.md). The draft is preserved for reference. This final version corrects the dimension table name (`dim_zoning_code` → `dim_zoning` per table inventory) and is the authoritative reference for zoning metric specs.

---

## Purpose

This document defines the strategy for comparing zoning composition across vintage years (2021–2025) in a way that is defensible and clearly bounded. It specifies how to detect code vocabulary differences between vintages, how to handle them, and what claims the MVP will and will not make based on this data.

This plan governs the `fct_district_year_zoning_composition` fact table and any YoY metrics derived from it.

---

## Scope

**In Scope:**
- Code vocabulary detection method across the 5 MVP vintages (2021–2025)
- Mapping strategy for the `dim_zoning` lookup table and `stg_zoning_code_crosswalk`
- MVP comparability bounds — what is and is not a valid YoY comparison

**Out of Scope:**
- Pre-2021 vintage comparability (deferred to post-MVP extension path; see [`docs/decisions/zoning_window_last5y.md`](./decisions/zoning_window_last5y.md))
- Full spatial audit of code boundaries across vintages (Month 2 EDA)
- Zoning amendment tracking at the parcel level (out of scope for MVP)

---

## Step 1: Detecting Code Vocabulary Differences

The primary detection method is a **code-set comparison** across staged vintage data.

For each adjacent vintage pair (e.g., 2021 → 2022, 2022 → 2023), query the `long_code` field from the staged shapefiles and compute:

- **Codes present in year N but absent in year N+1** → candidate retirements or renames
- **Codes present in year N+1 but absent in year N** → candidate new classifications or renames

This produces a **flagged code diff** per vintage transition. The `dim_zoning` lookup table — which contains the union of all `long_code` values across all 5 vintages — serves as the master inventory for this comparison.

**Limitation of this step:** String comparison alone cannot distinguish between:
- **Scenario B** — a code was renamed (same geography, different label)
- **Scenario C** — a genuinely new classification was introduced (new regulatory category)

Disambiguating B from C requires a **spatial overlap check**: if polygons labeled with the old code in year N overlap substantially with polygons labeled with the new code in year N+1, it is likely a rename. This spatial check is an EDA step performed against staged geometries — it is deferred to Month 2 pipeline development.

---

## Step 2: Mapping Strategy

Three constructs govern code vocabulary management:

### 2a. `dim_zoning` — Lookup Table (Warehouse)

Stores the canonical set of all zoning codes recognized by the warehouse. Contains code string and description only — no geometry.

- All codes from all 5 vintages are loaded into this table on initial build.
- New codes confirmed as genuinely new classifications are added via `INSERT`, not schema changes (per [B5] 31 Flavors mitigation).
- Retired codes remain in the table with an `active = FALSE` flag rather than being deleted, to preserve referential integrity for historical fact rows.

### 2b. `stg_zoning_code_crosswalk` — Crosswalk Table (Staging/Pipeline)

Maps source codes (as they appear in a vintage shapefile) to canonical codes (as stored in the warehouse). Schema:

```sql
CREATE TABLE stg_zoning_code_crosswalk (
    source_code     VARCHAR(20),  -- code as it appears in the vintage file
    vintage_year    INTEGER,       -- which source vintage uses this name
    canonical_code  VARCHAR(20),  -- normalized code loaded into the warehouse
    notes           TEXT
);
```

A crosswalk row is only authored when a rename is **confirmed** (via spatial overlap check or official L&I/city planning documentation). Unconfirmed cases are not mapped — they retain their source code as-is and are treated as new classifications.

### 2c. Unresolved Cases — Default Treatment

When a code appears or disappears between vintages and spatial or documentary evidence is not yet available to confirm whether it is a rename (Scenario B) or a new classification (Scenario C):

**Default stance: treat as a new classification.**

Rationale: Philadelphia's zoning administration does not rename codes arbitrarily. Code renaming creates confusion for permit applicants, attorneys, and planners — it is rare, intentional, and documented when it does occur. Within a 5-year window, undocumented silent renames are unlikely. This assumption will be validated periodically against L&I department resources and official zoning ordinance records.

The burden of proof is on confirmation, not on assumption of equivalence.

---

## Step 3: MVP Comparability Bounds

### What is a valid YoY comparison

A year-over-year composition comparison (e.g., "District X went from 30% residential to 35% residential between 2022 and 2023") is **valid** when:

> **The set of `long_code` values that map to the broad category (e.g., "residential") is identical in both vintage years being compared.**

If the subcode set is stable — same RSA-1 through RSA-5 counted as "residential" in both years — then the percentage change reflects actual rezoning activity, not a vocabulary artifact.

### What the MVP will not claim

- **No causal YoY claims for district-year pairs with unresolved code discrepancies.** If a new subcode appears in vintage year N+1 and its relationship to prior subcodes is unconfirmed, the affected broad-category comparison spanning that transition is flagged as potentially incomparable.
- **No equivalence between a disappearing code and any appearing code** unless explicitly mapped in `stg_zoning_code_crosswalk` with a documented rationale.
- **No claim that apparent composition changes represent real rezoning activity** in vintages where the underlying subcode vocabulary has not been confirmed stable.

### Flagging approach

District-year pairs affected by unresolved code discrepancies will carry a flag (e.g., `vocab_stable = FALSE`) in the fact table or a companion audit table. Downstream metrics and dashboards must surface this flag rather than silently including unreliable comparisons.

The specific implementation of the flag is deferred to Month 2 pipeline design.

---

## Assumptions and Risks

| # | Assumption | Risk if Wrong | Mitigation |
|---|-----------|---------------|------------|
| A1 | Philadelphia does not silently rename zoning codes within a 5-year window without official documentation | An undocumented rename is treated as a new classification, inflating apparent category churn | Periodic validation against L&I/city planning ordinance records; crosswalk updated when renames confirmed |
| A2 | The `long_code` field is the stable identifier across vintages (not an internal ID or display label) | Comparisons built on `long_code` break if the field meaning changes | Cross-check against shapefile schema documentation during Month 2 EDA |
| A3 | Broad category groupings (e.g., "residential" = RSA-*) are stable across 2021–2025 | A new subcode added to a category could inflate or deflate category totals without reflecting actual rezoning | Subcode-set audit per category per vintage transition; flag affected pairs |

---

## What This Plan Does Not Cover

- The specific SQL implementation of the vocabulary diff query (Month 2)
- The spatial overlap check methodology (Month 2 EDA)
- The final crosswalk table contents (populated during Month 2 data load)
- Zoning amendment history or parcel-level change tracking

---

## Links

- Zoning vintage window decision: [`docs/decisions/zoning_window_last5y.md`](./decisions/zoning_window_last5y.md)
- Zoning source catalog: [`docs/source_catalog/zoning_base_districts.md`](./source_catalog/zoning_base_districts.md)
- Zoning critical fields dictionary: [`docs/data_dictionary/zoning_critical_fields.md`](./data_dictionary/zoning_critical_fields.md)
- Limitations register: [`docs/limitations_register.md`](./limitations_register.md) (L7, L8, L15, L16, L17, L22)
- Zoning composition metric spec: [`docs/metrics/zoning_composition_by_year.md`](./metrics/zoning_composition_by_year.md)
- Zoning churn metric spec: [`docs/metrics/zoning_year_to_year_churn.md`](./metrics/zoning_year_to_year_churn.md)
- Draft (preserved): [`docs/zoning_comparability_plan_draft.md`](./zoning_comparability_plan_draft.md)

---

## Change Log

| Date       | Change                        | Author |
|------------|-------------------------------|--------|
| 2026-03-08 | Final version created from draft; corrected dim_zoning_code → dim_zoning per table inventory; added metric spec links | Farid  |
