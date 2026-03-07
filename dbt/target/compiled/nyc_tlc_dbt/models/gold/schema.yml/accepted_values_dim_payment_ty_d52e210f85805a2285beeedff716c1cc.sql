
    
    

with all_values as (

    select
        payment_type as value_field,
        count(*) as n_records

    from "taxi_db"."gold"."dim_payment_type"
    group by payment_type

)

select *
from all_values
where value_field not in (
    'cash','card','other'
)


