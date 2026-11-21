drop table if exists dim_data;
drop sequence if exists seq_data;

create sequence seq_data;

create table dim_data (
    id bigint primary key default nextval('seq_data'),
    start_m date,
    finish_m date,
    name text,
    year_n int,
    quar_n int,
    quar_name text    
);

select 
    d::date as start_m, 
    (d + interval '1 month - 1 day')::date as finish_m, 
    case 
        when extract(month from d) = 1 then 'Январь'
        when extract(month from d) = 2 then 'Февраль'
        when extract(month from d) = 3 then 'Март'
        when extract(month from d) = 4 then 'Апрель'
        when extract(month from d) = 5 then 'Май'
        when extract(month from d) = 6 then 'Июнь'
        when extract(month from d) = 7 then 'Июль'
        when extract(month from d) = 8 then 'Август'
        when extract(month from d) = 9 then 'Сентябрь'
        when extract(month from d) = 10 then 'Октябрь'
        when extract(month from d) = 11 then 'Ноябрь'
        when extract(month from d) = 12 then 'Декабрь'
    end as name, 
    extract(year from d)::int as year_n,
    extract(quarter from d)::int as quar_n, 
    'Q' || extract(quarter from d)::int as quar_name
from generate_series(
    '2000-01-01'::date, 
    current_date,
    '1 month'::interval) d;