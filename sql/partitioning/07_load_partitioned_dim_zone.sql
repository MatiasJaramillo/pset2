insert into gold.dim_zone (zone_key, borough, zone, service_zone)
select distinct
    locationid as zone_key,
    borough,
    zone,
    service_zone
from silver.silver_taxi_zone_lookup_clean
where locationid is not null;