insert into gold.dim_service_type (service_type)
select distinct
    service_type
from silver.silver_trips_clean
where service_type is not null;