select distinct
    vendorid as vendor_key
from "taxi_db"."silver"."silver_trips_clean"
where vendorid is not null