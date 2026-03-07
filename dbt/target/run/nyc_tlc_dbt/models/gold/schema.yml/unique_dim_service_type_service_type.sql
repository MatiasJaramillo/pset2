select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    service_type as unique_field,
    count(*) as n_records

from "taxi_db"."gold"."dim_service_type"
where service_type is not null
group by service_type
having count(*) > 1



      
    ) dbt_internal_test