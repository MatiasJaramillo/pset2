select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select payment_type_key
from "taxi_db"."gold"."fct_trips"
where payment_type_key is null



      
    ) dbt_internal_test