insert into gold.dim_payment_type (payment_type)
select distinct
    case
        when payment_type = 1 then 'card'
        when payment_type = 2 then 'cash'
        else 'other'
    end as payment_type
from silver.silver_trips_clean;