select distinct
    service_type
from {{ ref('silver_trips_clean') }}
where service_type is not null