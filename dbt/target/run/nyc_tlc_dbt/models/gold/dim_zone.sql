
  
    

  create  table "taxi_db"."gold"."dim_zone__dbt_tmp"
  
  
    as
  
  (
    select distinct
    locationid as zone_key,
    borough,
    zone,
    service_zone
from "taxi_db"."silver"."silver_taxi_zone_lookup_clean"
where locationid is not null
  );
  