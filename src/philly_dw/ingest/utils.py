import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine


load_dotenv()


def create_postgis_engine() -> Engine:
    """Creates sqlalchemy Engine for postgres using .env at project root

    Returns:
        Engine: sqlalchemy Engine
    """
    db_user = os.getenv("POSTGRES_USER")
    db_password = os.getenv("POSTGRES_PASSWORD")
    db_host = os.getenv("POSTGRES_HOST")
    db_port = os.getenv("POSTGRES_PORT")
    db_name = os.getenv("POSTGRES_DB")
    try:
        engine = create_engine(
            f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
        )
        print("PostGIS engine created successfully")
        return engine
    except Exception as e:
        print(f"An error has occurred: {e}")
        raise


def insert_logs_row(schema_name: str, table_name: str, source_url: str, row_count: int) -> None:
    """Write a row to {schema_name}.ingestion_logs recording what was loaded.

    Args:
        schema_name: Schema the data was loaded into (e.g. 'raw').
        table_name: Table the data was loaded into (e.g. 'planning_districts').
        source_url: URL the data was extracted from.
        row_count: Number of rows loaded.
    """
    engine = create_postgis_engine()

    val = (schema_name, table_name, source_url, row_count)
    sql = f"INSERT INTO {schema_name}.ingestion_logs (schema_name,table_name,source_url,row_count) VALUES  (%s,%s,%s,%s)"
    with engine.raw_connection() as raw_conn:
        cursor = raw_conn.cursor()
        cursor.execute(sql, val)
        print("Logs entry added.")
        raw_conn.commit()
