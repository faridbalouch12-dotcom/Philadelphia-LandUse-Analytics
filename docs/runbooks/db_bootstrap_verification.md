# Database Bootstrap Verification

**Purpose:** Confirm that the init SQL ran correctly after a clean boot — schemas exist, PostGIS is available, and the database is ready for ingestion.
**Run when:** After `docker compose up` from a fresh volume, or after `make reset-nuclear`.
**Last verified:** 2026-03-10

---

## Starting state

Clean boot: `docker compose down -v` followed by `docker compose up -d --wait`. No prior data in the volume.

---

## Check 1 — Schemas present

**Query:**

```sql
SELECT schema_name FROM information_schema.schemata
WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
ORDER BY schema_name;
```

**Expected result (6 schemas):**

| schema_name |
|---|
| analytics |
| intermediate |
| marts |
| public |
| raw |
| staging |

**Verified:** All 6 schemas present after clean boot (DBVisualizer schema tree).

---

## Check 2 — PostGIS and extensions installed

**Query:**

```sql
SELECT extname FROM pg_extension;
```

**Expected result (5 extensions):**

| extname |
|---|
| plpgsql |
| postgis |
| address_standardizer |
| address_standardizer_data_us |
| citext |

**Verified:** All 5 extensions present. `postgis` confirms spatial functions are available; `citext` is available for case-insensitive text comparisons.

---

## Check 3 — PostGIS functional

**Query:**

```sql
SELECT PostGIS_Version();
```

**Expected:** Returns a version string. If this fails, the extension exists but is not functional.

**Verified:** `3.5 USE_GEOS=1 USE_PROJ=1 USE_STATS=1` — spatial functions are operational.

---

## What this confirms

- `docker/postgres/init/01_schemas.sql` ran automatically on first boot
- All 5 warehouse schemas (`raw`, `staging`, `intermediate`, `marts`, `analytics`) were created
- PostGIS and supporting extensions are installed and usable
- The database is ready to receive raw data from ingestion scripts

---

## Links

- Init SQL: [`docker/postgres/init/01_schemas.sql`](../../docker/postgres/init/01_schemas.sql)
- Stack smoke test: [`docs/runbooks/stack_smoke_test.md`](./stack_smoke_test.md)
- Write access policy: [`docs/policies/write_access_by_layer.md`](../policies/write_access_by_layer.md)
- Reset workflow: [`docs/runbooks/local_reset.md`](./local_reset.md)
