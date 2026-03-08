insert into gold.fct_trips (
    trip_key,
    pickup_date,
    pickup_date_key,
    dropoff_date_key,
    pu_zone_key,
    do_zone_key,
    service_type_key,
    payment_type_key,
    vendor_key,
    pickup_ts,
    dropoff_ts,
    trip_duration_minutes,
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
)
with base as (
    select
        *,
        row_number() over (
            partition by
                coalesce(service_type, ''),
                coalesce(source_month, ''),
                coalesce(vendorid::text, ''),
                coalesce(pickup_ts::text, ''),
                coalesce(dropoff_ts::text, ''),
                coalesce(pulocationid::text, ''),
                coalesce(dolocationid::text, ''),
                coalesce(passenger_count::text, ''),
                coalesce(ratecodeid::text, ''),
                coalesce(payment_type::text, ''),
                coalesce(fare_amount::text, ''),
                coalesce(extra::text, ''),
                coalesce(mta_tax::text, ''),
                coalesce(tip_amount::text, ''),
                coalesce(tolls_amount::text, ''),
                coalesce(improvement_surcharge::text, ''),
                coalesce(total_amount::text, ''),
                coalesce(congestion_surcharge::text, ''),
                coalesce(airport_fee::text, ''),
                coalesce(trip_distance::text, '')
            order by
                ingest_ts,
                source_file
        ) as dup_seq
    from silver.silver_trips_clean
)
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
            coalesce(passenger_count::text, ''),
            coalesce(ratecodeid::text, ''),
            coalesce(payment_type::text, ''),
            coalesce(fare_amount::text, ''),
            coalesce(extra::text, ''),
            coalesce(mta_tax::text, ''),
            coalesce(tip_amount::text, ''),
            coalesce(tolls_amount::text, ''),
            coalesce(improvement_surcharge::text, ''),
            coalesce(total_amount::text, ''),
            coalesce(congestion_surcharge::text, ''),
            coalesce(airport_fee::text, ''),
            coalesce(trip_distance::text, ''),
            dup_seq::text
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
from base;