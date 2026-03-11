# /update-docs — Docs Index Sync

Scan the repo for documentation files that are not linked in `docs/README.md` and add any missing links.

---

## Procedure

1. **Scan these locations** for `.md` files:
   - `docs/` (all subdirectories)
   - `notes/` (all subdirectories)
   - Skip root-level files: `README.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `docs/README.md` itself

2. **Read `docs/README.md`** to see what is already linked.

3. **For any file not already linked**, add a row to the appropriate table section in `docs/README.md`:
   - Match the existing table format: `| [Display name](./path/to/file.md) | One-line summary |`
   - Place it in the correct category (Source catalogs, Feasibility, Modeling specs, etc.)
   - If no existing category fits, add a new section following the established pattern
   - For `notes/` files, add to the appropriate topical section or create a "Notes" section if needed

4. **Report** what was added. If nothing was missing, confirm all files are already linked.
