drop table if exists gold.dim_date cascade;

create table gold.dim_date (
    date_key integer not null,
    full_date date,
    year integer,
    quarter integer,
    month integer,
    month_name text,
    day integer,
    day_of_week integer,
    day_name text,
    week_of_year integer,
    is_weekend boolean
);