import geopandas as gpd
from sqlalchemy import text
from . import utils

GEOJSON_URL = "https://hub.arcgis.com/api/v3/datasets/0960ea0f38f44146bb562f2b212075aa_0/downloads/data?format=geojson&spatialRefId=4326&where=1%3D1"
TABLE_NAME = "planning_districts"


def create_planning_districts() -> int:
    """Creates the Planning District table in raw schema. No changes are made from source as it is meant to be immutable."""
    planning_district_gdf = gpd.read_file(GEOJSON_URL)

    engine = utils.create_postgis_engine()
    with engine.connect() as conn:
        conn.execute(text("DROP TABLE IF EXISTS raw.planning_districts CASCADE"))
        conn.commit()

    planning_district_gdf.to_postgis(
        name=TABLE_NAME,
        schema="raw",
        con=engine,
        if_exists="replace",
        index=False,
    )
    print("Created Planning Districts Table!")
    return len(planning_district_gdf)


if __name__ == "__main__":
    count = create_planning_districts()
    utils.insert_logs_row("raw", TABLE_NAME, GEOJSON_URL, count)
