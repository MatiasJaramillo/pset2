drop table if exists gold.dim_zone cascade;

create table gold.dim_zone (
    zone_key integer not null,
    borough text,
    zone text,
    service_zone text
) partition by hash (zone_key);

create table gold.dim_zone_p0
    partition of gold.dim_zone
    for values with (modulus 4, remainder 0);

create table gold.dim_zone_p1
    partition of gold.dim_zone
    for values with (modulus 4, remainder 1);

create table gold.dim_zone_p2
    partition of gold.dim_zone
    for values with (modulus 4, remainder 2);

create table gold.dim_zone_p3
    partition of gold.dim_zone
    for values with (modulus 4, remainder 3);