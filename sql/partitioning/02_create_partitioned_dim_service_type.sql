drop table if exists gold.dim_service_type cascade;

create table gold.dim_service_type (
    service_type text not null
) partition by list (service_type);

create table gold.dim_service_type_yellow
    partition of gold.dim_service_type
    for values in ('yellow');

create table gold.dim_service_type_green
    partition of gold.dim_service_type
    for values in ('green');