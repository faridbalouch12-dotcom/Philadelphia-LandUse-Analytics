import pytest
from philly_dw.ingest.utils import create_postgis_engine
from sqlalchemy import text


def _table_exists():
    """Check if raw.planning_districts exists in the database."""
    try:
        with create_postgis_engine().connect() as conn:
            result = conn.execute(
                text(
                    "SELECT 1 FROM information_schema.tables "
                    "WHERE table_schema = 'raw' AND table_name = 'planning_districts'"
                )
            )
            return result.scalar() is not None
    except Exception:
        return False


requires_data = pytest.mark.skipif(
    not _table_exists(),
    reason="raw.planning_districts not loaded — run make ingest-districts first",
)


@requires_data
def test_row_count():
    """Verify raw.planning_districts has exactly 18 rows (one per Philadelphia planning district)."""
    with create_postgis_engine().connect() as connection:
        query = text("SELECT count(*) FROM raw.planning_districts")
        result = connection.execute(query)
        count = result.scalar()
    assert count == 18, f"Invalid Row Count. Expected 18. Got: {count}"


@requires_data
def test_geometry():
    """Verify no rows in raw.planning_districts have null geometry."""
    with create_postgis_engine().connect() as connection:
        query = text(
            "SELECT count(*) FROM raw.planning_districts where geometry is null"
        )
        result = connection.execute(query)
        count = result.scalar()
    assert count == 0, f"{count} planning districts have null geometry."
