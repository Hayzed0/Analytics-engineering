{{
    config(
        materialized= 'table'
    )
}}

with green_tripdata as (
    select *,
        'Green' as service_type
    from {{ ref('stg_green_data') }}
),
yellow_tripdata as (
    select *, 
        'Yellow' as service_type
    from {{ ref('stg_yellow_data') }}
),
trips_unioned as (
    select *
    from green_tripdata
    union all
    select * from yellow_tripdata
),
dim_zone as (
    select * from {{ ref('dim_zone') }}
    where borough != 'Unknown'  -- Standardized capitalization
)

select 
    -- All columns from our main unioned taxi trips
    trips_unioned.tripid,
    trips_unioned.vendorid,
    trips_unioned.service_type,
    trips_unioned.ratecodeid,
    trips_unioned.pickup_locationid,
    trips_unioned.dropoff_locationid,
    trips_unioned.pickup_datetime,
    trips_unioned.dropoff_datetime,
    trips_unioned.passenger_count,
    trips_unioned.trip_distance,
    trips_unioned.fare_amount,
    trips_unioned.total_amount,
    trips_unioned.payment_type_description,
    
    -- Explicitly aliased pickup zone columns (Prevents Duplicates)
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone_name,
    
    -- Explicitly aliased dropoff zone columns (Prevents Duplicates)
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone_name

from trips_unioned
inner join dim_zone as pickup_zone
    on trips_unioned.pickup_locationid = pickup_zone.locationid
inner join dim_zone as dropoff_zone
    on trips_unioned.dropoff_locationid = dropoff_zone.locationid