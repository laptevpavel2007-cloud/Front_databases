do $$
begin

    begin

        drop table if exists purchases cascade;
        drop sequence if exists seq_purchases cascade;

    end;

    begin

                create sequence seq_purchases;
        comment on sequence seq_purchases is 'Счётчик внутренних кодов закупок';

        create table purchases (
            id          int default nextval('public.seq_purchases'),
            product_id  int,
            unit_id     int,
            group_id    int,
            vendor_id   int,
            quan        float,
            amount      float,
            date_add    timestamp default now(),
            date_id     int);

		comment on type purchases is 'Таблица фактов для учета закупки';

        alter table purchases add constraint pk_purchases primary key (id);

    end;


    begin

        alter table purchases
        add constraint fk_purchases_product foreign key (product_id) references dim_products(id),
        add constraint fk_purchases_unit foreign key (unit_id) references dim_measurement_units(id),
        add constraint fk_purchases_group foreign key (group_id) references dim_product_groups(id),
        add constraint fk_purchases_vendor foreign key (vendor_id) references dim_vendors(id),
        add constraint fk_purchases_date foreign key (date_id) references dim_time(id);

    end;

end $$