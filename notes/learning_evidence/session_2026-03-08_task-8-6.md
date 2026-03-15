# Session Notes — Task 8.6: Year-to-Year Comparability Plan (Draft)

**Date:** 2026-03-08
**Task:** 8.6 — Year-to-year comparability plan (draft)
**Score:** 9/10 (PASS)
**Deliverable:** [`docs/zoning_comparability_plan_draft.md`](../../docs/zoning_comparability_plan_draft.md)

---

## What We Worked On

Task 8.6 asked for a written plan governing how the MVP will handle year-over-year zoning composition comparisons across five vintage years (2021–2025). The deliverable had three required components: detection strategy, mapping strategy, and MVP comparability bounds/claims.

The session was primarily a design discussion before writing. You came in with clear instincts, and the conversation sharpened them into something defensible.

---

## Key Concepts Discussed

### Detection: Code-Set Comparison

The core detection approach is simple: for each adjacent vintage pair (2021→2022, etc.), compare the set of `long_code` values that appear. Codes present in year N but absent in N+1 are candidate retirements or renames. Codes present in N+1 but absent in N are candidate new classifications or renames.

You correctly identified `long_code` as the right field to compare — it's the stable identifier across vintages, not an internal ID or display label.

**The problem string comparison can't solve:** you can flag that a code disappeared and a new one appeared, but you can't tell from string comparison alone whether that's:
- **Scenario B** — a rename (same land, different label)
- **Scenario C** — a genuinely new classification (new regulatory category, new land)

That disambiguation requires a **spatial overlap check** — do polygons with the old code in year N overlap substantially with polygons using the new code in year N+1? Deferred to Month 2 EDA.

### Mapping Strategy: Three Constructs

You proposed two constructs initially (lookup table + crosswalk), which was right. We added a third (the unresolved default) to make the strategy complete:

1. **`dim_zoning_code` (lookup table)** — lives in the warehouse. Contains the union of all `long_code` values across all 5 vintages. Code string + description only, no geometry. Retired codes stay with `active = FALSE`. New confirmed classifications get `INSERT`ed. This is static — no history tracking needed because code *meanings* are stable (that's a separate problem, see 8.7/L16).

2. **`stg_zoning_code_crosswalk` (pipeline layer)** — maps source codes to canonical codes for **confirmed renames only**. Only authored when spatial or documentary evidence confirms a rename. Unconfirmed cases are not mapped here.

3. **Default for unresolved cases** — treat as a new classification until confirmed otherwise. Your reasoning: Philadelphia doesn't rename codes arbitrarily in a short window, it creates confusion for everyone (permit applicants, lawyers, planners), and renaming is intentional and documented when it does happen. So the burden of proof is on confirmation, not on assumed equivalence.

### Valid YoY Comparison Condition

You articulated this cleanly: a YoY broad-category comparison (e.g., "District X went from 30% to 35% residential") is only valid when **the set of subcodes mapping to that broad category is identical in both years**.

If "residential" means RSA-1 through RSA-5 in 2022, but RSA-6 was added to that category by 2023, then the 2022→2023 comparison isn't measuring actual rezoning — it's measuring vocabulary expansion. The plan flags these pairs with `vocab_stable = FALSE`.

---

## What You Got Right (and Where the 1-Point Deduction Came From)

Strong on all five criteria. The one deduction: the Assumptions/Risks table used the column header `Risk if Wrong` when the memo template specifies `Impact if Wrong`. Minor formatting mismatch. Worth fixing as a polish item if you revisit this document.

---

## Meta-Learning

You noted that working through the detection → mapping → claims structure gave you a better understanding — and then immediately connected it to the upcoming 8.7 work on the definition-change risk (L16), showing you were already thinking one step ahead about the limits of this plan.

---

## How This Connects to the Project

The comparability plan governs `fct_district_year_zoning_composition` and every YoY metric derived from it. Without it, a dashboard user could look at a "30% → 35% residential" trend line and not know whether that reflects actual rezoning or just the city adding RSA-6 to the residential bucket. The plan draws that line explicitly.

The crosswalk table also previews a pattern you'll use in Month 2: staging-layer normalization before loading to warehouse. The pipeline isn't just moving data — it's resolving vocabulary before facts land.

---

## Learning System Highlights

- Design Review mode forced the learner to articulate a three-part comparability framework before any code was written — detection, mapping, and validity conditions
- Counterargument surfaced the three-layer complexity problem (physical reality vs regulatory framework vs administrative records) that the learner hadn't initially distinguished
- The resulting design was stress-tested against edge cases (code renames, definition changes, subcode drift) before being locked

---

## Coming Up Next

**Task 8.7** (done same session) extended this work into the limitations register — adding L15 (vocabulary drift), L16 (definition change risk), and L17 (subcode-set instability). See [session_2026-03-08_task-8-7.md](./session_2026-03-08_task-8-7.md).

After that: **Task 9.5 — Boundary alignment note (ACS → Districts)**. This is a different flavor of the same underlying problem — spatial mismatch between two geographic units (census tracts vs. planning districts). Concepts to prime for: overlay vs. crosswalk, slivers, MAUP (Modifiable Areal Unit Problem), and area-weighted allocation.
