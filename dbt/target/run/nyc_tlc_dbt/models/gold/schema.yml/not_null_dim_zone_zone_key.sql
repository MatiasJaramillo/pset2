select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select zone_key
from "taxi_db"."gold"."dim_zone"
where zone_key is null



      
    ) dbt_internal_test