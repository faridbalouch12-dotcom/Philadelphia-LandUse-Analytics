# Stack Smoke Test

**Purpose:** Verify that the full local stack comes up cleanly from a cold start and all services are reachable.
**Run when:** After first clone, after any `compose.yml` change, or after a `docker compose down -v` reset.
**Last verified:** 2026-03-09

---

## Prerequisites

- Docker Desktop running
- `.env` file present (copy from `.env.example` and fill in values)
- Working directory: `docker/`

---

## Step 1 — Clean start

Tear down any existing containers and volumes, then bring the stack up fresh:

```bash
cd docker/
docker compose down -v
docker compose up -d
```

Expected output from `up -d`:
- Network created
- Both volumes created (`postgres_data`, `metabase_data`)
- Postgres container starts first
- Compose waits for Postgres to reach `(healthy)` before starting Metabase

---

## Step 2 — Confirm both containers are healthy

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

Expected:

```
NAMES                                           STATUS
metabase                                        Up X minutes (healthy)
philly-landuse-analytics-postgres_philly_dw-1   Up X minutes (healthy)
```

Both must show `(healthy)` — not just `Up`. If Metabase shows `(health: starting)`, wait 1–2 minutes and re-check. Metabase takes time to fully initialize on first boot.

---

## Step 3 — Confirm Postgres is reachable and the database exists

```bash
docker exec philly-landuse-analytics-postgres_philly_dw-1 psql -U philly -d philly_dw -c "\l"
```

Expected: `philly_dw` appears in the database list, owned by `philly`.

---

## Step 4 — Confirm Metabase UI is reachable

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health
```

Expected: `200`

Or open `http://localhost:3000` in a browser — you should see the Metabase setup/login screen.

---

## Known rough edges

| Issue | Detail |
|-------|--------|
| Metabase slow to start | First boot takes 1–2 min. `(health: starting)` is normal — wait before assuming failure. |
| `pg_isready` user/db flags required | Without `-U philly -d philly_dw`, healthcheck defaults to OS user (`root`) and fails with role/database not found errors. |
| `down -v` deletes all data | The `-v` flag removes named volumes. Only use for intentional full resets — see `docs/runbooks/local_reset.md` when available. |
