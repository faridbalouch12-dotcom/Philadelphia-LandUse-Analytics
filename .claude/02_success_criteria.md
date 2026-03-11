# Month 1 Success Criteria — Top 8 Critical Checks

**Pass all 8 → You're ready for Month 2**

---

## 1. ✅ All Tasks Complete

**Check:** `.claude/progress.md` shows all tasks marked `[x]` with PASS verdicts

**Why it matters:** Basic completion gate - can't skip tasks

---

## 2. ✅ The Grain Test

**Check:** Open `docs/modeling/grain_spec.md` — can you write the CREATE TABLE statement for permits_fact from your spec alone?

**Must include:**
- Exact column names and data types
- Primary key (surrogate + natural keys)
- Foreign keys to dimensions

**Why it matters:** Grain is the most critical design decision. If this is wrong, everything breaks.

---

## 3. ✅ The Dimension Test

**Check:** Open `docs/modeling/table_inventory.md` — can you write CREATE TABLE for each dimension (geography, time, permit_type, demographics)?

**Must specify:**
- All columns with data types
- Primary key
- SCD strategy with justification

**Why it matters:** Month 2 schema creation implements these exactly.

---

## 4. ✅ The Metric Test

**Check:** Pick one metric from `docs/metrics/` — can you write the complete SQL query including all joins?

**Example:** "Permits per capita by district-year"

**Why it matters:** If you can't query it, the metric definition is incomplete.

---

## 5. ✅ The ERD Test

**Check:** Your ERD shows:
- All fact and dimension tables
- Primary keys and foreign keys marked
- Cardinality (1:N) on relationships
- Grain annotated on fact tables

**Why it matters:** This is the blueprint. Month 2 implements this exactly.

---

## 6. ✅ Can You Explain Grain?

**Test:** Without looking at notes, explain your permits_fact grain including:
- What one row represents
- Why you chose this grain
- What alternatives you rejected and why

**Good answer:**
> "One row per permit issuance event. I chose this because it matches the source data and supports 'count permits by month' queries. I rejected 'one row per building' because buildings have many permits over time."

**Why it matters:** If you can't defend your grain choice, you don't understand dimensional modeling.

---

## 7. ✅ Can You Explain SCD Type 2?

**Test:** Explain why SCD Type 2 matters for demographics_dim

**Good answer:**
> "Demographics change over time (income goes from $45K to $52K). Type 1 would overwrite, making 2021 analysis use 2023 data incorrectly. Type 2 keeps both rows so I join to the correct historical snapshot."

**Why it matters:** SCD is fundamental to time-based analysis. You need to understand it, not just know it exists.

---

## 8. ✅ The Junior Engineer Test

**Test:** Could you hand your `docs/` folder to a junior engineer and they could:
- Build the database schema correctly
- Write the ETL scripts
- Implement the metrics layer

**...without asking you clarifying questions?**

**Pass:** Yes, the docs are self-contained and unambiguous

**Fail:** No, they'd need to ask "what did you mean by..."

**Why it matters:** This is the ultimate quality check. Documentation should stand alone.

---

## Scoring

- **8/8 passed** → Month 1 complete, ready for Month 2
- **6-7/8 passed** → Close, address gaps before proceeding
- **<6/8 passed** → Not ready, significant work needed

---

## The Gold Standard

Your documentation is complete when a stranger could implement the warehouse from your docs alone, without asking a single question.
