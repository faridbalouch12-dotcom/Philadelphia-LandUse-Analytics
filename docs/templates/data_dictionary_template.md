# Data Dictionary Template

**Author:** Farid
**Created:** 2026-03-04
**Last Updated:** 2026-03-04
**Status:** Draft

Use this template to document the critical fields for each dataset. The goal is to make it obvious which fields are required for the MVP, how they should be interpreted, and what data quality issues to expect.

---

## Dataset header
- Dataset name:
- Dataset ID (e.g., S1/S2/S3/D1):
- Source page / endpoint:
- Reviewer:
- Date:
- MVP role (district spine / permits fact / zoning snapshots / ACS context):

---

## Field Dictionary

**Risk level scale:** High = metric breaks or joins fail if this field is missing/wrong; Med = analysis degrades but is still usable; Low = not used in MVP metrics.

| Field name | Meaning | Required? | Expected type | Risk level | Common null/invalid patterns | Notes |
|---|---|---|---|---|---|---|
|  |  | Yes/No | string / integer / float / boolean / date / datetime / geometry | High / Med / Low | e.g., null for older records; placeholder values; malformed IDs | include units, code lists, transformations, join usage, etc. |
|  |  | Yes/No |  |  |  |  |
|  |  | Yes/No |  |  |  |  |
|  |  | Yes/No |  |  |  |  |

---

## Required Fields Summary (MVP)
List the minimum fields needed for the MVP, grouped by purpose.

- Time fields:
- Geography / linkage fields:
- Key / ID fields:
- Category / grouping fields:
- Other MVP-required fields:

---

## Links
- Source catalog entry for this dataset:
- Feasibility checklist for this dataset:
- Related metric specs:
- Limitations register entries (if applicable):

---

## Notes for Implementation Later (optional)
- Any fields that look required but aren’t reliable:
- Any fields that need normalization or mapping:
- Known schema drift concerns (if this dataset has vintages/years):
- Validation checks you expect to run (e.g., uniqueness, not-null, accepted values):

---

## Change log

| Date       | Change description | Author |
|------------|--------------------|--------|
| 2026-03-04 | Initial draft      | Farid  |
