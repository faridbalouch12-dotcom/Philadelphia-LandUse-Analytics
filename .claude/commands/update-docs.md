# /update-docs — README Links Sync

Scan the repo for documentation files that are not linked in the README and add any missing links.

---

## Procedure

1. **Scan these locations** for `.md` files:
   - `docs/` (all files)
   - `notes/` (all files)
   - Root-level docs: `README.md`, `CONTRIBUTING.md`, `CLAUDE.md` (skip — these don't need to be linked)

2. **Read the "Links to Docs Index" section** of `README.md` to see what is already linked.

3. **For any file not already linked**, add an entry in this exact format (match the existing style):
   ```
   - **[Short descriptive name]:** [`path/to/file.md`](./path/to/file.md)
   ```
   Use a short, plain-English name (e.g., "Kimball grain notes", "Data storage policy").

4. **Report** what was added. If nothing was missing, confirm all files are already linked.
