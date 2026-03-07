
  create view "taxi_db"."silver"."silver_taxi_zone_lookup_clean__dbt_tmp"
    
    
  as (
    select
    cast(locationid as integer) as locationid,
    borough,
    zone,
    service_zone
from bronze.taxi_zone_lookup
where locationid is not null
  );