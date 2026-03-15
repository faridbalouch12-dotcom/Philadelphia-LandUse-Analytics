from philly_dw.ingest.utils import create_postgis_engine
from sqlalchemy import text


def test_row_count():
    """Verify raw.planning_districts has exactly 18 rows (one per Philadelphia planning district)."""
    # Establish a connection
    with create_postgis_engine().connect() as connection:
        # Use text() for raw SQL and parameter binding for safety
        query = text("SELECT count(*) FROM raw.planning_districts")
        result = connection.execute(query)
        count = result.scalar()
    count_true = count == 18
    assert count_true, f"Invalid Row Count. Expected 18. Got: {count}"


def test_geometry():
    """Verify no rows in raw.planning_districts have null geometry."""
    # Establish a connection
    with create_postgis_engine().connect() as connection:
        # Use text() for raw SQL and parameter binding for safety
        query = text(
            "SELECT count(*) FROM raw.planning_districts where geometry is null"
        )
        result = connection.execute(query)
        count = result.scalar()
    count_true = count == 0
    assert (
        count_true
    ), f"{count} planning districts have null geometry."
