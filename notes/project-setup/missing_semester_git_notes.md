# MIT Missing Semester: Version Control (Git) — Notes

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Source:** [D8], [V4]

---

## Purpose

These notes capture the conceptual foundations of Git's data model and establish a deliberate solo workflow for this project — including a branch strategy that scales from Month 1 (documentation) to Month 2+ (pipelines and code).

---

## Key Takeaways

- Git models history as a DAG (directed acyclic graph) of commit objects — each commit is a node, parent pointers are directed edges, and the graph is acyclic because no commit can point to a descendant
- The three core object types are blobs (file content), trees (directory structure), and commits (snapshot + parent + author/message) — together they form a content-addressable store where every object is referenced by its SHA hash
- A branch is just a lightweight pointer to a commit — creating a branch copies nothing; it just names a position in the graph
- A solo developer still needs a deliberate workflow: atomic commits, pre-commit diff review, and a branch strategy matched to the risk level of the work
- Protecting `main` from broken state matters more in Month 2+ (pipelines, SQL, dbt) than in Month 1 (documentation), which is why the branch strategy changes at that boundary

---

## Detailed Notes

### Git's Data Model

Git stores repository history as three fundamental object types:

| Object | What it stores | Project example |
|--------|---------------|-----------------|
| **Blob** | An array of bytes representing the content of a single file | The contents of `notes/kimball_grain_notes.md` |
| **Tree** | A directory: maps names to either blobs (files) or other trees (subdirectories), recursively | The `notes/` folder, which contains blobs and possibly nested trees |
| **Commit** | A pointer to a root tree (snapshot of the full repo), plus: parent commit(s), author, timestamp, and message | Every task completion commit in this repo |

The commit graph is a **DAG (directed acyclic graph)**:
- Nodes are commits
- Edges are parent pointers (each commit points to its parent)
- The graph is **acyclic** because no commit can ever point to one of its own descendants — history only flows backward to parents, never forward to children

This structure makes history immutable: once a commit exists, it cannot be silently altered without changing its SHA hash, which would invalidate all descendants.

### Branches and References

A branch is a named pointer (reference) to a commit. Creating a branch does not copy files — it just creates a new label that can advance independently. `HEAD` is a special reference pointing to the currently checked-out commit or branch tip.

Because branches are cheap, the decision of when to branch is entirely about workflow risk management, not storage cost.

### `git diff --staged` as a Pre-Commit Review

`git diff` (no flags) shows changes in the working directory not yet staged — i.e., what hasn't been added yet.

`git diff --staged` (or `--cached`) shows changes that *are* staged and are about to become the next commit. This is the correct pre-commit review command: it shows exactly what will be committed before it goes into history.

A passing test suite checks functional correctness but does not catch: unintended file modifications, accidental config changes, new directories or files included by mistake, secrets accidentally staged, or scope creep. A `git diff --staged` review catches all of these.

---

## Branch Strategy for This Project

### Month 1 (Documentation only — current)

**Strategy:** Commit directly to `main`. No feature branches.

**Rationale:** Month 1 contains only markdown documentation — no pipelines, no SQL, no data. A bad commit can be fixed forward in the next commit with no downstream breakage. The overhead of branches per task (100 tasks) outweighs the risk reduction at this stage.

**Quality gate:** Review `git diff --staged` before every commit to verify scope and intent.

### Month 2+ (Pipelines, dbt models, SQL)

**Strategy:** Feature branches for any new pipeline, dbt model, or SQL schema work. Direct-to-main commits remain acceptable for minor documentation updates and notes.

**Rationale:** A broken push to `main` in Month 2+ can corrupt pipeline state, break dbt runs, or introduce bad data into Postgres. A feature branch keeps `main` clean — if the branch breaks, it is not merged, and `main` remains in a working state. Reverting a broken push to `main` is messier and risks losing in-progress work.

**Branch naming convention (Month 2+):** Follow the convention established in `CONTRIBUTING.md`:
- `feat/<short-description>` for new pipelines or models
- `fix/<short-description>` for bug fixes
- `chore/<short-description>` for maintenance
- `docs/<short-description>` for documentation changes

---

## The 5 Rules I Will Follow

1. **Commit messages are short and imperative.** Start with a verb: "Add," "Update," "Fix," "Remove." No past tense, no trailing periods.

2. **Review `git diff --staged` before every commit.** Confirm that only the intended files are staged and that no unintended changes, config modifications, or secrets are included.

3. **Commits are atomic — one commit per completed task.** Each commit represents a single logical unit of work, tied to one syllabus task. No mixing unrelated changes in a single commit.

4. **Commit messages reference the task deliverable.** The message describes what was produced, not what was done abstractly. Examples: "Add spatial SQL notes," "Add ACS period estimates notes," "Update limitations register for zoning."

5. **Use feature branches for Month 2+ pipeline and model work; commit directly to `main` for Month 1 documentation.** The branch strategy is a deliberate risk-management decision, not a default. Branches protect `main` when a broken push could cause real damage; in Month 1, the cost of branches exceeds the benefit.

---

## Application to Project

| Concept | How I'll apply it |
|---------|-------------------|
| DAG mental model | Understanding why reverting on `main` is messy: a revert creates a new commit, but the broken state remains in history. A feature branch that is never merged leaves `main` clean by design. |
| Atomic commits | One commit per syllabus task ensures history is readable as a progress log — each commit corresponds to a deliverable artifact. |
| `git diff --staged` review | Run before every commit in Month 1 as the primary quality gate, replacing the PR self-review step that would otherwise exist in a branched workflow. |
| Two-phase branch strategy | Month 1 is docs-only → direct to main. Month 2+ introduces pipelines → feature branches for any work that could break the pipeline if pushed broken. |

---

## Open Questions

- [ ] In Month 2+, what is the minimum test suite that must pass before merging a feature branch? (To be defined when pipelines are scoped)
- [ ] Should a branch protection rule be added to `main` before Month 2 begins, requiring at least a passing CI check before merge?

---

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|------------|-----------------|
| A1 | Month 1 documentation commits carry low enough risk that direct-to-main is acceptable — a bad doc commit can always be fixed forward | If a doc commit somehow breaks a downstream process (e.g., a CLAUDE.md change breaks the learning assistant), the no-branch strategy would make rollback messier |
| A2 | Feature branches in Month 2+ will be short-lived (one task or one pipeline) and not long-running, avoiding complex merge conflicts | Long-running branches diverge significantly from main and create harder merges; if tasks are large, branch strategy may need revision |

---

## Links

**Related Notes:**
- PostGIS Spatial Primer Notes: [`postgis_spatial_primer_notes.md`](./postgis_spatial_primer_notes.md)
- Kimball Grain Notes: [`kimball_grain_notes.md`](./kimball_grain_notes.md)

**Project Documents:**
- Contributing guide: [`../CONTRIBUTING.md`](../CONTRIBUTING.md)
- Docs folder: [`../docs/`](../docs/)

---

## References

- **[D8]** MIT Missing Semester. "Version Control (Git)." https://missing.csail.mit.edu/2026/version-control/
- **[V4]** MIT Missing Semester. "Version Control Lecture (Video)." https://missing.csail.mit.edu/2026/version-control/

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-03 | Initial notes created | Farid  |
