select distinct
    vendorid as vendor_key
from {{ ref('silver_trips_clean') }}
where vendorid is not null