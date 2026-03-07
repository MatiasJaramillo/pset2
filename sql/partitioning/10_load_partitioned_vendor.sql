insert into gold.dim_vendor (vendor_key)
select distinct
    vendorid as vendor_key
from silver.silver_trips_clean
where vendorid is not null;