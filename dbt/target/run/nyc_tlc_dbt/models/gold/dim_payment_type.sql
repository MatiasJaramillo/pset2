
  
    

  create  table "taxi_db"."gold"."dim_payment_type__dbt_tmp"
  
  
    as
  
  (
    with payment_types as (

    select distinct
        case
            when payment_type = 1 then 'card'
            when payment_type = 2 then 'cash'
            else 'other'
        end as payment_type
    from "taxi_db"."silver"."silver_trips_clean"

)

select *
from payment_types
where payment_type is not null
  );
  