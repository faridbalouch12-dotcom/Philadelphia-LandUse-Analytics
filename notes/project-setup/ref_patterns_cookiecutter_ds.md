# cookiecutter-data-science: Reference Patterns — Notes

**Author:** Farid
**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Source:** [R1]

---

## Purpose

These notes extract 5 structural patterns from the cookiecutter-data-science reference repo and document how each applies to the Philadelphia data warehouse project in Month 1 and beyond.

---

## 5 Patterns + Application

### Pattern 1: Immutable Raw Data + Layered Data Flow

**What it is:** The `data/` folder is split into four sub-levels: `raw/` (original, immutable data dump), `external/` (third-party sources), `interim/` (intermediate transformed data), and `processed/` (final canonical datasets ready for modeling). Raw data is never modified after ingestion — all transformations produce new outputs in downstream layers.

**Why it matters:** Treating raw data as immutable means you can always re-derive everything from source. If a transformation is wrong, you fix the code and rerun — you don't patch the raw file.

**How I'll apply it:** In this project, the database schemas mirror this structure: `raw` schema (original ingested data, never overwritten in place), `staging` schema (cleaned and typed), `mart` schema (aggregated fact and dimension tables). The `data/raw/` local folder holds any sample files used for development, and is never edited manually.

---

### Pattern 2: References Directory for Explanatory Materials

**What it is:** A dedicated `references/` folder holds data dictionaries, manuals, and all other explanatory materials — kept separate from source code and notebooks.

**Why it matters:** Explanatory materials live in a predictable, searchable location. Reviewers know where to look for context without hunting through code files.

**How I'll apply it:** Already doing this via `docs/` (curated specs, policies, data dictionaries) and `notes/` (reading notes, triage rules, conceptual primers). The `references/` pattern confirms this separation is intentional and standard — not just a personal preference.

---

### Pattern 3: `requirements.txt` for Environment Reproducibility

**What it is:** A `requirements.txt` file (or `pyproject.toml`) pins the exact Python package versions needed to reproduce the analysis environment. Anyone who clones the repo can run `pip install -r requirements.txt` and get the same environment.

**Why it matters:** Without pinned dependencies, "works on my machine" bugs are hard to diagnose. Pinned versions make the environment reproducible across machines and over time.

**How I'll apply it:** A `requirements.txt` will be maintained in the repo root listing all Python ingestion dependencies (e.g., `psycopg2`, `requests`, `geopandas`) with pinned versions. This is set up when the Python ingestion pipeline is built in Month 2.

---

### Pattern 4: Notebooks Folder for Exploration

**What it is:** A dedicated `notebooks/` folder separates exploratory Jupyter notebooks from production source code. Notebooks follow a naming convention: `<number>-<initials>-<short-description>` (e.g., `1.0-fk-initial-permits-exploration`) for ordering and discoverability.

**Why it matters:** Mixing notebooks with pipeline code creates confusion about what is production logic vs. throwaway exploration. The naming convention makes it clear which notebooks were created first and what each one investigated.

**How I'll apply it:** A `notebooks/` folder will be created in Month 2 for exploratory data analysis of permit, zoning, and ACS datasets before production ingestion is written. The numbered naming convention will be adopted so the exploration sequence is recoverable from the file listing.

---

### Pattern 5: Single-Command Reproducibility Entry Point

**What it is:** A `Makefile` at the repo root defines short named commands (`make data`, `make train`) that wrap longer shell commands. Any contributor can clone the repo and run one command to execute the full pipeline — no need to read docs to find the right command sequence.

**Why it matters:** Reproducibility is only real if someone else can actually reproduce it. If running the project requires reading a README and piecing together 5 commands, the barrier is too high. A single entry point removes that friction.

**How I'll apply it:** `docker compose up -d` is the equivalent entry point for this project — it starts Postgres and Metabase with one command. In Month 2, this may be extended with a `Makefile` or shell script that chains `docker compose up -d` → run ingestion → `dbt run` into a single `make pipeline` command.

---

## Links

**Related Notes:**
- jaffle-shop patterns: [`ref_patterns_jaffle_shop.md`](./ref_patterns_jaffle_shop.md)
- Missing Semester Git notes: [`missing_semester_git_notes.md`](./missing_semester_git_notes.md)

**Project Documents:**
- Docs folder: [`../docs/`](../docs/)
- Data storage policy: [`../docs/policies/data_storage_policy.md`](../docs/policies/data_storage_policy.md)

---

## References

- **[R1]** DrivenData. "cookiecutter-data-science." GitHub. https://github.com/drivendataorg/cookiecutter-data-science

---

## Change Log

| Date       | Change Description    | Author |
|------------|-----------------------|--------|
| 2026-03-03 | Initial notes created | Farid  |
