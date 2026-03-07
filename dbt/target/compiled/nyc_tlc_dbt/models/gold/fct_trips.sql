with base as (

    select *
    from "taxi_db"."silver"."silver_trips_clean"

),

final as (

    select
        md5(
            concat_ws(
                '||',
                coalesce(service_type, ''),
                coalesce(source_month, ''),
                coalesce(vendorid::text, ''),
                coalesce(pickup_ts::text, ''),
                coalesce(dropoff_ts::text, ''),
                coalesce(pulocationid::text, ''),
                coalesce(dolocationid::text, ''),
                coalesce(total_amount::text, ''),
                coalesce(trip_distance::text, '')
            )
        ) as trip_key,

        cast(pickup_ts as date) as pickup_date,
        cast(to_char(cast(pickup_ts as date), 'YYYYMMDD') as integer) as pickup_date_key,
        cast(to_char(cast(dropoff_ts as date), 'YYYYMMDD') as integer) as dropoff_date_key,

        pulocationid as pu_zone_key,
        dolocationid as do_zone_key,

        service_type as service_type_key,

        case
            when payment_type = 1 then 'card'
            when payment_type = 2 then 'cash'
            else 'other'
        end as payment_type_key,

        vendorid as vendor_key,

        pickup_ts,
        dropoff_ts,

        extract(epoch from (dropoff_ts - pickup_ts)) / 60.0 as trip_duration_minutes,

        passenger_count,
        trip_distance,
        ratecodeid,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,

        source_month,
        ingest_ts,
        source_file

    from base

)

select *
from final