select distinct
    service_type
from "taxi_db"."silver"."silver_trips_clean"
where service_type is not null