select
    cast(locationid as integer) as locationid,
    borough,
    zone,
    service_zone
from bronze.taxi_zone_lookup
where locationid is not null