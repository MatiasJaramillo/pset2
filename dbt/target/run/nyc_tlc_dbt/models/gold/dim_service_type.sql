
  
    

  create  table "taxi_db"."gold"."dim_service_type__dbt_tmp"
  
  
    as
  
  (
    select distinct
    service_type
from "taxi_db"."silver"."silver_trips_clean"
where service_type is not null
  );
  