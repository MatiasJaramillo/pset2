
    
    

with child as (
    select do_zone_key as from_field
    from "taxi_db"."gold"."fct_trips"
    where do_zone_key is not null
),

parent as (
    select zone_key as to_field
    from "taxi_db"."gold"."dim_zone"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


