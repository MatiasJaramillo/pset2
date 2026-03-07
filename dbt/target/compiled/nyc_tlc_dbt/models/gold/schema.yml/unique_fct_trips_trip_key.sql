
    
    

select
    trip_key as unique_field,
    count(*) as n_records

from "taxi_db"."gold"."fct_trips"
where trip_key is not null
group by trip_key
having count(*) > 1


