select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select pu_zone_key
from "taxi_db"."gold"."fct_trips"
where pu_zone_key is null



      
    ) dbt_internal_test