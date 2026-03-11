"""Smoke test: verify DB connectivity and expected warehouse schemas exist (Task 27.2)."""

import os

import psycopg

EXPECTED_SCHEMAS = frozenset({"raw", "staging", "intermediate", "marts", "analytics"})


def _build_connstr() -> str:
    """Build a psycopg connection string from environment variables."""
    return (
        f"host={os.environ['POSTGRES_HOST']} "
        f"port={os.environ['POSTGRES_PORT']} "
        f"dbname={os.environ['POSTGRES_DB']} "
        f"user={os.environ['POSTGRES_USER']} "
        f"password={os.environ['POSTGRES_PASSWORD']}"
    )


def test_db_connectivity_and_schemas() -> None:
    """Verify the database is reachable and all expected warehouse schemas exist."""
    with psycopg.connect(_build_connstr()) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT schema_name FROM information_schema.schemata")
            present = {row[0] for row in cur.fetchall()}

    missing = EXPECTED_SCHEMAS - present
    assert not missing, f"Missing schemas: {missing}"
