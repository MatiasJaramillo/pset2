
  
    

  create  table "taxi_db"."gold"."dim_date__dbt_tmp"
  
  
    as
  
  (
    with dates as (

    select distinct cast(pickup_ts as date) as full_date
    from "taxi_db"."silver"."silver_trips_clean"

    union

    select distinct cast(dropoff_ts as date) as full_date
    from "taxi_db"."silver"."silver_trips_clean"

)

select
    cast(to_char(full_date, 'YYYYMMDD') as integer) as date_key,
    full_date,
    extract(year from full_date)::integer as year,
    extract(quarter from full_date)::integer as quarter,
    extract(month from full_date)::integer as month,
    to_char(full_date, 'FMMonth') as month_name,
    extract(day from full_date)::integer as day,
    extract(isodow from full_date)::integer as day_of_week,
    to_char(full_date, 'FMDay') as day_name,
    extract(week from full_date)::integer as week_of_year,
    case
        when extract(isodow from full_date) in (6, 7) then true
        else false
    end as is_weekend
from dates
where full_date is not null
  );
  