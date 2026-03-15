SELECT 
    pd.objectid as district_id,
    pd.dist_name as district_name,
    pd.abbrev as district_abbrev,
    st_transform(pd.geometry, 2272) AS geom,
    st_area(
        st_transform(pd.geometry, 2272)
    )/27878400 AS land_area_sqmi
FROM {{ source('open_data_philly', 'planning_districts') }} as pd