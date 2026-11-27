do $$
begin

    begin

        drop table if exists purchases cascade;
        drop sequence if exists seq_purchases cascade;

    end;

    begin

        create sequence seq_purchases;

        create table purchases (
            id bigint primary key default nextval('seq_purchases'),
            product_id bigint,
            unit_id bigint,
            group_id bigint,
            vendor_id bigint,
            quan float,
            amount float,
            date_add timestamp default now(),
            date_id bigint
        );

		comment on type purchases is 'Таблица фактов для учета закупки';

    end;


    begin

        alter table purchases
        add constraint fk_purchases_product foreign key (product_id) references dim_products(id),
        add constraint fk_purchases_unit foreign key (unit_id) references dim_ranges(id),
        add constraint fk_purchases_group foreign key (group_id) references dim_products_groups(id),
        add constraint fk_purchases_vendor foreign key (vendor_id) references dim_vendors(id),
        add constraint fk_purchases_date foreign key (date_id) references dim_data(id);

    end;

end $$