do $$
begin

    begin

        drop table if exists procurement, sales, personnel, remains;
        drop sequence if exists seq_procurement, seq_sales, seq_personnel, seq_remains;

    end;

    begin

        create sequence seq_procurement;

        create table procurement (
            id bigint primary key default nextval('seq_procurement'),
            doc_id bigint,
            prod_id bigint,
            ven_id bigint,
            quan float,
            amount float,
            date_add timestamp default now()
        );
        comment on table procurement is 'Таблица закупок продукции';


        create sequence seq_sales;

        create table sales (
            id bigint primary key default nextval('seq_sales'),
            prod_id bigint,
            pers_id bigint,
            quan float,
            rev float,
            date_add timestamp default now()
        );
        comment on table sales is 'Таблица продажи продукции';


        create sequence seq_personnel;

        create table personnel (
            id bigint primary key default nextval('seq_personnel'),
            pers_id bigint,
            receipts bigint,
            revenue float,
            date_add timestamp default now()
        );
        comment on table personnel is 'Таблица персонала';


        create sequence seq_remains;

        create table remains (
            id bigint primary key default nextval('seq_remains'),
            prod_id bigint,
            year_n int,
            week_n int,
            qty_in float,
            qty_out float,
            date_add timestamp default now()
        );
        comment on table remains is 'Таблица остатотков товара на складе';

    end;

end $$;