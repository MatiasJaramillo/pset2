drop table if exists gold.dim_vendor cascade;

create table gold.dim_vendor (
    vendor_key integer not null
);