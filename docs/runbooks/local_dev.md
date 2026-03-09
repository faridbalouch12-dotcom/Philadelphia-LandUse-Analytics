# Local Development Runbook

**Purpose:** Get the project running on a fresh machine, from clone to working stack.
**Audience:** Any developer setting up the project locally.
**Last updated:** 2026-03-09

---

## Prerequisites

Install the following before proceeding:

| Tool | Required version | Notes |
|------|-----------------|-------|
| Python | ≥ 3.11 | Check with `python --version` |
| Docker Desktop | 4.x (current) | Includes Compose v2 — required for `docker compose` (no hyphen) |
| `make` | Any | Pre-installed on macOS/Linux. Windows: install via [Chocolatey](https://chocolatey.org/) (`choco install make`) or use Git Bash |
| `git` | Any | To clone the repo |

---

## First-time setup

### 1. Clone the repo

```bash
git clone <repo-url>
cd Philadelphia-LandUse-Analytics
```

### 2. Create and activate a virtual environment

```bash
python -m venv .venv
source .venv/bin/activate        # macOS/Linux
.venv\Scripts\activate           # Windows
```

### 3. Install the package

```bash
pip install -e .
```

**Verify:** `python -c "import philly_dw"` — no output means success. An error means the install failed.

### 4. Configure environment variables

```bash
cp .env.example .env
```

Open `.env` and fill in your local values. See [`docs/runbooks/local_env_setup.md`](./local_env_setup.md) for a full explanation of each variable.

### 5. Start the stack

```bash
make up
```

**Verify:**
```bash
docker compose ps              # both db and metabase should show "running"
pg_isready -h localhost -p 5432  # should return "accepting connections"
```

Metabase UI: open `http://localhost:3000` in a browser.

### 6. Run ingestion

```bash
make ingest-all
```

Or run individual datasets:
```bash
make ingest-districts
make ingest-permits
make ingest-zoning
make ingest-acs
```

### 7. Run dbt transformations

```bash
make dbt-run
```

### 8. Run tests

```bash
make test
```

All tests should pass on a clean setup.

---

## Daily workflow

Once set up, the typical session is:

```bash
make up           # start Postgres + Metabase (if not already running)
make ingest-all   # re-ingest if source data has changed
make dbt-run      # rebuild warehouse models
make test         # verify nothing broke
```

You don't need to re-run setup steps after the first time. Just `make up` to bring the stack back if you've rebooted.

---

## Stopping the stack

```bash
make down
```

This stops the containers but preserves your data volumes. Re-running `make up` brings everything back without losing data.

---

## Available commands

Run `make help` to see all commands. Key ones:

| Command | What it does |
|---------|-------------|
| `make up` | Start Postgres + Metabase |
| `make down` | Stop all services |
| `make rebuild` | Full reset: stop → start → ingest all → dbt run |
| `make ingest-<dataset>` | Ingest one dataset (districts, permits, zoning, acs) |
| `make ingest-all` | Ingest all datasets in sequence |
| `make dbt-run` | Run dbt transformations |
| `make test` | Run pytest suite |

---

## Troubleshooting

**`ModuleNotFoundError: No module named 'philly_dw'`**
Run `pip install -e .` from the repo root inside your virtual environment.

**`connection refused` on port 5432**
The Docker stack isn't running. Run `make up` first.

**`docker compose` not found**
You may have the old `docker-compose` (v1) installed instead of Compose v2. Upgrade to Docker Desktop 4.x.

**`make: command not found` (Windows)**
Install `make` via Chocolatey (`choco install make`) or run commands from Git Bash.
