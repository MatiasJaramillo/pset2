drop table if exists gold.dim_payment_type cascade;

create table gold.dim_payment_type (
    payment_type text not null
) partition by list (payment_type);

create table gold.dim_payment_type_cash
    partition of gold.dim_payment_type
    for values in ('cash');

create table gold.dim_payment_type_card
    partition of gold.dim_payment_type
    for values in ('card');

create table gold.dim_payment_type_other
    partition of gold.dim_payment_type
    for values in ('other');