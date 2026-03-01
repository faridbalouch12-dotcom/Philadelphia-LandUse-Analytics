# Contributing to Philly Data Warehouse

## Scope

This workflow applies to all changes made to this repository. Whether documentation updates, data model specifications, or future code implementation, every change follows the same branch-and-PR path. No exceptions.

---

## Branch Rules

### Allowed Prefixes

All feature branches must use one of the following prefixes:

- `feat/` — New features, specifications, or capabilities
- `fix/` — Bug fixes, corrections, or error resolution
- `docs/` — Documentation updates (README, guides, specifications)
- `chore/` — Maintenance tasks (dependency updates, tooling, cleanup)

### Branch Naming

- Branches must start from `main`
- Use descriptive names after the prefix: `feat/dataset-catalog`, `docs/update-glossary`, `fix/grain-spec-typo`
- Keep names lowercase with hyphens separating words

**Example:**
```bash
git checkout main
git pull origin main
git checkout -b feat/metrics-definitions
```

---

## Commit Style

### Message Format

- Write commit messages in **imperative mood** (e.g., "Add dataset catalog" not "Added dataset catalog")
- Keep the subject line under 50 characters
- Use the body (optional) to explain *why*, not *what* — the diff shows *what* changed

### Commit Scope

- **One logical change per commit** — if you're fixing a typo *and* adding a new section, make two commits
- Commits should be focused and atomic — each commit should leave the repo in a working state

**Good examples:**
```
Add permit dataset to catalog
Fix grain definition in fct_permits spec
Update glossary with SCD Type 2 definition
```

**Bad examples:**
```
Updates
Fixed stuff
WIP - more changes coming
```

---

## PR Rule

**All merges to `main` must go through a Pull Request.** Direct commits to `main` are not allowed.

This applies even when working solo. The PR serves as:
- A forcing function for self-review
- A checkpoint to verify Definition of Done is met
- A documented decision trail with context

---

## Ready to Merge

Before merging a PR, verify all of the following:

### 1. Definition of Done Met
- All requirements from the task's Definition of Done are satisfied
- Deliverable artifacts exist at the correct file paths

### 2. Pass/Fail Gates Satisfied
- Artifact exists where specified
- All mandatory sections/fields are present

### 3. Self-Review Score 7+
- Run through the 5-criteria rubric (Clarity, Completeness, Traceability, Consistency, Task Objective Mastery)
- Score honestly — each criterion rated 0–2
- If total score is below 7/10, address gaps before merging

### 4. Documentation Updates
- If the PR adds a new document, ensure it's linked in the root `README.md` "Links to Docs Index" section
- If the PR changes existing specs, verify cross-references are updated (e.g., glossary terms, metric definitions)

---

## Review Expectation

Since this is a solo project, **structured self-review replaces peer review.**

Before merging:

1. **Read the PR diff as if you didn't write it** — does it make sense to a future reader?
2. **Check against the task rubric** — score each of the 5 criteria honestly
3. **Verify links and cross-references** — click every link, confirm every reference resolves
4. **Run the "six months later" test** — if you open this file in six months, will you understand the decisions made and why?

If any of these fail, push fixes to the branch before merging.

---

## Example Workflow

```bash
# Start new work
git checkout main
git pull origin main
git checkout -b feat/assumptions-log

# Make changes, commit atomically
git add docs/assumptions.md
git commit -m "Add assumptions log with initial 5 entries"

git add docs/assumptions.md
git commit -m "Link assumptions log in README"

# Push branch and open PR
git push origin feat/assumptions-log
# (Open PR on GitHub)

# Self-review in PR interface
# - Check Definition of Done
# - Score 5 criteria
# - Verify documentation links

# Merge when ready (via GitHub UI, not CLI)
# Delete branch after merge
```

---

## Questions or Issues?

This is a learning project — the workflow is designed to build production-level habits, not to slow you down. If a rule feels like busywork without learning value, document the concern in an issue and revisit the workflow.
