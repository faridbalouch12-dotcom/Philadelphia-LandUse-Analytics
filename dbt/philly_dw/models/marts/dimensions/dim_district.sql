SELECT 
    pd.district_id as district_id,
    pd.district_name as district_name,
    pd.district_abbrev as district_abbrev,
    st_transform(pd.geom, 4326) AS polygon_geometry,
    pd.land_area_sqmi
FROM {{ref('stg_planning_districts')}}  as pd