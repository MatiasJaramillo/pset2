select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

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



      
    ) dbt_internal_test