drop table if exists gold.fct_trips cascade;

create table gold.fct_trips (
    trip_key text not null,
    pickup_date date not null,
    pickup_date_key integer,
    dropoff_date_key integer,
    pu_zone_key integer,
    do_zone_key integer,
    service_type_key text,
    payment_type_key text,
    vendor_key integer,
    pickup_ts timestamp,
    dropoff_ts timestamp,
    trip_duration_minutes numeric,
    passenger_count numeric,
    trip_distance numeric,
    ratecodeid numeric,
    fare_amount numeric,
    extra numeric,
    mta_tax numeric,
    tip_amount numeric,
    tolls_amount numeric,
    improvement_surcharge numeric,
    total_amount numeric,
    congestion_surcharge numeric,
    airport_fee numeric,
    source_month text,
    ingest_ts timestamp,
    source_file text
) partition by range (pickup_date);

create table gold.fct_trips_2024_01
    partition of gold.fct_trips
    for values from ('2024-01-01') to ('2024-02-01');

create table gold.fct_trips_2024_02
    partition of gold.fct_trips
    for values from ('2024-02-01') to ('2024-03-01');

create table gold.fct_trips_2024_03
    partition of gold.fct_trips
    for values from ('2024-03-01') to ('2024-04-01');

create table gold.fct_trips_default
    partition of gold.fct_trips default;