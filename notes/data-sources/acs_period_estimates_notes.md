# ACS: Period Estimates — Notes

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Source:** [D1], [D2]

---

## Purpose

These notes define what an ACS period estimate is, establish the rule against comparing overlapping 5-year estimates, and document the standard caveat language for presenting demographic data in this project.

---

## Key Takeaways

- A period estimate is an average across surveys collected over multiple years — it does not represent a single point in time
- The 5-year estimate is preferred for small geographies (census tract level): larger sample, lower margin of error, and available where 1-year estimates are not
- Only compare **non-overlapping** 5-year estimates — overlapping estimates share most of the same underlying data, making observed differences statistically unreliable
- ACS provides **demographic context only** — do not claim that demographic conditions caused changes in permit activity
- Within a 5-year project scope, ACS gives at most two bookend snapshots (e.g., 2015–2019 and 2020–2024) — not an annual time series

---

## Detailed Notes

### What a Period Estimate Is

The ACS does not survey the entire population in a single year. Instead, it continuously collects survey responses and combines them across a collection window to produce estimates. A **5-year period estimate** (e.g., 2020–2024) uses data collected from January 1, 2020 through December 31, 2024.

Because it averages across the full window, a 5-year estimate is best understood as representing the **midpoint of the collection period** — the 2020–2024 estimate approximates conditions around 2022, not 2024.

**1-year vs. 5-year estimates:**

| | 1-Year Estimate | 5-Year Estimate |
|---|---|---|
| Sample size | Smaller | Larger |
| Margin of error | Higher | Lower |
| Geographic availability | Geographies with 65,000+ population only | Down to census tract level |
| Currency | More recent | Represents a longer window |

For this project, **5-year estimates are required**: planning district analysis relies on census tract-level data. The Census Bureau does not publish 1-year estimates at the census tract level — only for geographies with 65,000+ population. Since census tracts average ~4,000 people, 1-year estimates do not exist at that geography. 5-year estimates are the only option for district-level demographic analysis.

### The Non-Overlapping Rule

Two 5-year estimates that share years in their collection windows are **not valid to compare**. Because they share most of the same underlying survey respondents, any observed difference between them is driven almost entirely by the one or two non-overlapping years — and that difference cannot be reliably distinguished from sampling noise.

**Valid comparison (non-overlapping):**
- 2015–2019 vs. 2020–2024 ✓ — no shared years; difference is interpretable

**Invalid comparison (overlapping):**
- 2019–2023 vs. 2020–2024 ✗ — share 4 years of data; difference is not statistically meaningful

### ACS as Context, Not Cause

ACS data describes demographic conditions across a district. It does not explain *why* permit activity changed. The two datasets — permits (annual events) and ACS (multi-year averages) — operate at different temporal grains and neither establishes causation from the other.

---

## Do / Don't List

| DO | DON'T |
|----|-------|
| Use 5-year ACS estimates for district-level analysis | Use 1-year estimates for census tract or planning district geographies — they do not exist at that level |
| Label every ACS figure with its collection period (e.g., "2020–2024 ACS 5-Year Estimate") | Present ACS figures without a period label |
| Compare 2015–2019 vs. 2020–2024 to show change across periods | Compare 2019–2023 vs. 2020–2024 — these overlap |
| State ACS figures as context for understanding permit trends | Claim that demographic change caused permit activity to change |
| Show "ACS Period Estimate Used: XXXX–XXXX" as a tooltip or label on dashboards | Leave users to assume the ACS figure represents a specific calendar year |
| Use non-overlapping periods when showing any before/after demographic comparison | Show year-by-year ACS trends within a 5-year window |

---

## Application to Project

### Standard Disclaimer (for dashboards and docs)

> Demographic data shown here are 5-year period estimates from the U.S. Census Bureau's American Community Survey (ACS). Five-year estimates are used because 1-year estimates are not available at the census tract level required for district-level analysis. These estimates represent averages across surveys conducted over multiple years and do not reflect conditions in any specific permit activity year. Meaningful comparisons between permit activity and demographic context can only be made using non-overlapping survey periods — for example, 2015–2019 vs. 2020–2024 are valid to compare; 2019–2023 vs. 2020–2024 are not (see label for the ACS period used). Demographic data provides context only — it does not establish that demographic conditions caused any observed change in permit activity.

### Dashboard UX Note

Every chart or table showing ACS data should display the collection period inline — e.g., as a label or tooltip: **"ACS Period Estimate Used: 2020–2024."** This makes the non-overlapping rule actionable for users who may not read the full disclaimer.

### ACS in the District-Year Table

The `district_year` periodic snapshot table will store one ACS estimate per district per non-overlapping 5-year period, labeled by the end year of the collection window (e.g., `acs_period = '2020-2024'`). Within the last 5 years, this yields at most one current snapshot; a second non-overlapping snapshot (e.g., 2015–2019) extends the window for before/after comparison.

---

## Open Questions

- [ ] Are 5-year ACS estimates available at the planning district level directly, or must they be aggregated from census tracts? (To be confirmed in Task 9.x)
- [ ] What is the most recent 5-year estimate currently published? (2020–2024 expected; confirm availability)
- [ ] Which specific ACS variables will be used as demographic indicators — median household income, renter rate, others? (To be defined in Task 14.x)

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | ACS 5-year estimates are available at census tract level for Philadelphia, enabling aggregation to planning districts | If not available at this geography, district-level demographics cannot be constructed from ACS |
| A2 | The most recent available 5-year estimate covers 2020–2024 | If only 2019–2023 is available, the project's "current" ACS snapshot will be offset from the permit data window |
| A3 | Two non-overlapping 5-year periods (e.g., 2015–2019 and 2020–2024) are sufficient for the before/after demographic comparison in Month 1 | If more temporal resolution is needed, ACS cannot provide it without switching to 1-year estimates and accepting smaller geographic coverage |

---

## Links

**Related Notes:**
- Kimball Facts Notes: [`kimball_facts_notes.md`](./kimball_facts_notes.md)
- Kimball Grain Notes: [`kimball_grain_notes.md`](./kimball_grain_notes.md)

**Project Documents:**
- Docs folder: [`../../docs/`](../../docs/)

---

## References

- **[D1]** U.S. Census Bureau. 2022. "Period Estimates in the American Community Survey." See [Bibliography](../../docs/bibliography.md).
- **[D2]** U.S. Census Bureau. n.d. "Comparing ACS Data." See [Bibliography](../../docs/bibliography.md).

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-03 | Initial notes created | Farid  |
