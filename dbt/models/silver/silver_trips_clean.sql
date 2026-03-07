with trips as (

    select
        vendorid,
        cast(pickup_datetime as timestamp) as pickup_ts,
        cast(dropoff_datetime as timestamp) as dropoff_ts,
        cast(passenger_count as numeric) as passenger_count,
        cast(trip_distance as numeric) as trip_distance,
        cast(ratecodeid as numeric) as ratecodeid,
        store_and_fwd_flag,
        cast(pulocationid as integer) as pulocationid,
        cast(dolocationid as integer) as dolocationid,
        cast(payment_type as numeric) as payment_type,
        cast(fare_amount as numeric) as fare_amount,
        cast(extra as numeric) as extra,
        cast(mta_tax as numeric) as mta_tax,
        cast(tip_amount as numeric) as tip_amount,
        cast(tolls_amount as numeric) as tolls_amount,
        cast(improvement_surcharge as numeric) as improvement_surcharge,
        cast(total_amount as numeric) as total_amount,
        cast(congestion_surcharge as numeric) as congestion_surcharge,
        cast(airport_fee as numeric) as airport_fee,
        ingest_ts,
        source_month,
        service_type,
        source_file
    from bronze.trips_raw

),

filtered as (

    select *
    from trips
    where pickup_ts is not null
      and dropoff_ts is not null
      and pickup_ts <= dropoff_ts
      and trip_distance >= 0
      and total_amount >= 0
      and pulocationid is not null
      and dolocationid is not null

),

enriched as (

    select
        t.*,
        pu.borough as pickup_borough,
        pu.zone as pickup_zone,
        pu.service_zone as pickup_service_zone,
        do_.borough as dropoff_borough,
        do_.zone as dropoff_zone,
        do_.service_zone as dropoff_service_zone
    from filtered t
    left join {{ ref('silver_taxi_zone_lookup_clean') }} pu
        on t.pulocationid = pu.locationid
    left join {{ ref('silver_taxi_zone_lookup_clean') }} do_
        on t.dolocationid = do_.locationid

)

select *
from enriched
where pickup_zone is not null
  and dropoff_zone is not null