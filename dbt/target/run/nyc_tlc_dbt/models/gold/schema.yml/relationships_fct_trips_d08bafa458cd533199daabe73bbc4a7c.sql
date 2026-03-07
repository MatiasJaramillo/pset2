select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select service_type_key as from_field
    from "taxi_db"."gold"."fct_trips"
    where service_type_key is not null
),

parent as (
    select service_type as to_field
    from "taxi_db"."gold"."dim_service_type"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test