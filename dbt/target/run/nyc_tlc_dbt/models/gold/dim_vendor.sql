
  
    

  create  table "taxi_db"."gold"."dim_vendor__dbt_tmp"
  
  
    as
  
  (
    select distinct
    vendorid as vendor_key
from "taxi_db"."silver"."silver_trips_clean"
where vendorid is not null
  );
  