# Style guide — Philly Data Warehouse

This document defines style and formatting conventions for all project artifacts. The goal is to make specs, documentation, and future code consistent, reviewable, and maintainable.

---

## Code style (Month 2+)

When code is introduced in Month 2, this project follows **Google's Python Style Guide** and **Google's Code Review Standards**.

### References

- **Python Style Guide:** [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- **Code Review Standards:** [Google Code Review Developer Guide](https://google.github.io/eng-practices/review/reviewer/looking-for.html)

### Key principles (applied in Month 2+)

- PEP 8 compliant formatting
- Docstrings required for all functions, classes, and modules
- Descriptive variable and function names (no abbreviations unless standard in the domain)
- Type hints where applicable
- Maximum line length: 80 characters for code, 100 for docstrings/comments

**Note:** These standards do not apply to Month 1, which is documentation-only. Enforcement begins when Python code is introduced.

---

## Documentation style (active now)

Curated documentation in `/docs` and the reusable templates in
`/docs/templates` follow the conventions below.

---

### File naming rules

**General Rules:**
- Use lowercase letters only
- Separate words with underscores (`_`), not hyphens or spaces
- Be descriptive — file names should indicate content without needing to open the file
- Use `.md` extension for all Markdown documents

**Examples:**
- ✅ `dataset_catalog.md`
- ✅ `grain_spec.md`
- ✅ `assumptions_log.md`
- ❌ `DatasetCatalog.md` (uppercase)
- ❌ `dataset-catalog.md` (hyphens)
- ❌ `catalog.md` (not descriptive)

**Special Cases:**
- Root-level project docs use UPPERCASE: `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`
- Configuration files follow their tool's convention: `.gitignore`, `requirements.txt`, `pyproject.toml`

---

### Required sections for specs, memos, and notes

All specification documents (data model specs, metric definitions, dataset catalogs) must include the following sections where applicable:

#### 1. **Header block** (required for curated docs and templates)

```markdown
# Document Title

**Author:** Farid
**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD
**Status:** Draft | In Review | Final
```

#### 2. **Purpose** (required for specs)

One paragraph explaining *why this document exists* and *what problem it solves*.

Example:
> This grain specification defines the atomic unit of observation for each fact table in the warehouse, ensuring consistent query results and preventing fan-out issues during joins.

#### 3. **Scope** (required for specs)

What is covered and what is explicitly *not* covered.

Example:
> **In Scope:** Fact tables for permits, demographics, and zoning. **Out of Scope:** Bridge tables and aggregates, which will be addressed in Month 3.

#### 4. **Definitions** (required when introducing new terms)

Define any terms or concepts not already in the glossary. Link to the glossary for existing terms.

Example:
> `**Grain:** The level of detail captured in a single row of a fact table. See [Glossary](./glossary.md#grain) for full definition.`

#### 5. **Body content** (structure varies by document type)

Use clear, hierarchical headings:
- `##` for major sections
- `###` for subsections
- `####` sparingly, only when deep nesting is necessary

#### 6. **References** (required if citing external sources)

List all external resources cited in the document using the resource ID system (see **Resource Citation Format** below).

Example:
```markdown
## References

- **[B3]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.), Chapter 3: "Retail Sales"
- **[D1]** U.S. Census Bureau. (2022). *PUMS Documentation*. Retrieved from [link]
```

#### 7. **Change log** (required for specs that will evolve)

Track major revisions at the bottom of the document.

Example:
```markdown
## Change Log

| Date       | Change Description                  | Author |
|------------|-------------------------------------|--------|
| 2026-02-15 | Initial draft                       | Farid  |
| 2026-02-20 | Added SCD Type 2 strategy for demographics | Farid  |
```

---

### Resource citation format

The project maintains a central resource library in `claude/resources.md`
with IDs for books (B1–B12), datasets (D1–D24), style guides (S1–S3),
reference docs (R1–R2), and videos (V1–V9).

**When citing a resource in any document:**

1. Use the resource ID in square brackets: `[B3]`, `[D7]`
2. Include the full citation in a **References** section at the end of the document
3. Link back to `claude/resources.md` when first mentioning the resource

**Inline Citation Example:**

```markdown
The Kimball methodology recommends conformed dimensions [B3] to enable
consistent cross-process analysis.
```

**References Section Example:**

```markdown
## References

- **[B3]** Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit* (3rd ed.).
  See [Resources](../claude/resources.md#b3) for full details.
```

**Why This Matters:**
- Enables traceability — readers can verify claims by checking the source
- Maintains consistency — everyone uses the same resource IDs
- Prevents link rot — if a URL changes, update it once in `claude/resources.md`, not in 20 documents

---

### Markdown formatting conventions

#### Headings

- Use ATX-style headings (`#`, `##`, `###`) — not underline-style (`===`, `---`)
- One `#` (H1) per document — the document title
- Use sentence case, not title case: `## Data model design` not `## Data Model Design`
- No punctuation at the end of headings

#### Lists

**Unordered lists:**
- Use `-` (hyphen), not `*` or `+`
- Indent nested lists with 2 spaces

**Ordered lists:**
- Use `1.`, `2.`, `3.` — not `1)` or `(1)`
- For nested lists, use letters: `a.`, `b.`, `c.`

#### Links

**Internal links (within repo):**
- Use relative paths: ``[Glossary](./glossary.md)`` or ``[Resources](../claude/resources.md)``
- Include section anchors when linking to specific headings: ``[Grain definition](./glossary.md#grain)``

**External links:**
- Use descriptive link text, not "click here"
- ✅ `[U.S. Census Bureau ACS Documentation](https://census.gov/acs)`
- ❌ `Click [here](https://census.gov/acs) for ACS docs`

#### Code and file paths

- Inline code and file paths use backticks: \`fct_permits\`, \`/docs/data-model.md\`
- Code blocks use triple backticks with language identifier:

```python
def calculate_permit_density(permits, population):
    return (permits / population) * 1000
```

#### Tables

- Use pipe formatting with header separator
- Align columns for readability (not required for rendering, but makes source readable)

```markdown
| Column Name | Data Type | Description          |
|-------------|-----------|----------------------|
| permit_id   | INTEGER   | Unique permit ID     |
| issue_date  | DATE      | Date permit issued   |
```

#### Emphasis

- **Bold** for key terms on first use: `**grain** is the atomic unit of a fact table`
- *Italics* for emphasis or to highlight contrasts: `permits *issued* vs. permits *approved*`
- Avoid excessive formatting — let content speak for itself

---

### Cross-referencing between documents

When referencing another project document:

1. Use relative paths to ensure links work in both local and GitHub environments
2. Link to the specific section when possible:
   `[Grain spec](./grain_spec.md#fct-permits)`
3. Add context when linking: Don't just say "see grain spec" — say
   `"see the grain specification for fct_permits in [grain_spec.md](./grain_spec.md#fct-permits)"`

**Example:**
```markdown
Each metric must specify its grain (see [Grain specification](./grain_spec.md))
and source tables (see [Dataset catalog](./dataset_catalog.md)).
```

---

## Enforcement

### During self-review

Before submitting any document for grading or merging a PR, verify:

- [ ] File name follows lowercase-with-underscores convention
- [ ] Required sections are present (Purpose, Scope, References if applicable)
- [ ] All resources are cited using IDs from `claude/resources.md`
- [ ] Markdown formatting is consistent (headings, lists, links)
- [ ] Cross-references resolve correctly (click every link)

### During grading

The **Consistency** rubric criterion checks adherence to this style guide:

- **2 points:** Fully consistent — follows all naming, formatting, and citation rules
- **1 point:** Mostly consistent — minor deviations (e.g., 1-2 missing resource citations, inconsistent heading case)
- **0 points:** Inconsistent — multiple violations (wrong file names, missing required sections, no resource citations)

---

## Updates to this guide

This style guide is a living document. If you encounter ambiguity or a case not covered here:

1. Document the decision in an issue or PR comment
2. Update this guide with the new rule
3. Apply the rule consistently going forward

**Change Log:**

| Date       | Change Description       | Author |
|------------|--------------------------|--------|
| 2026-02-28 | Initial version created  | Farid  |
