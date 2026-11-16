-- 1. Анализ закупки продукции. Шаг Месяц.
select 
    format(so.dateadd, 'yyyy-MM') as purchase_month,
    vg.description as vendor_group,
    v.firstname as vendor_name,
    p.description as product_name,
    sum(cast(so.amount as decimal(18,2))) as total_amount
from [dbo].[bm_storageoperations] so
join [dbo].[vendors] v on so.vendorid = v.id
left join [dbo].[vendorgroup] vg on v.clientgroup = vg.vendorgroupid
inner join [dbo].[product] p on so.productid = p.id
where so.operationid = 1
group by format(so.dateadd, 'yyyy-MM'), vg.description, v.firstname, p.description
order by purchase_month desc, total_amount desc;

-- 2. Анализ продажи товара. Шаг Месяц.
select 
    format(j.dater, 'yyyy-MM') as sales_month,
    tt.description as operation_type,
    p.description as product_name,
    sum(cast(jd.quantity as decimal(18,2))) as total_sold,
    sum(cast(jd.sbrutto as decimal(18,2))) as total_revenue
from [dbo].[bm_journal_details] jd
inner join [dbo].[journal] j on jd.sourceid = j.transnumber 
left join [dbo].[transtype] tt on j.transtype = tt.transtypeid
inner join [dbo].[product] p on jd.productid = p.id
group by format(j.dater, 'yyyy-MM'), tt.description, p.description
order by sales_month desc, total_revenue desc;

-- 3. Анализ взаимоотношений с поставщиками
select 
    format(so.dateadd, 'yyyy-MM') as order_month,
    vg.description as vendor_group,
    v.firstname as vendor_name,
    count(distinct so.documentid) as documents_count,
    sum(cast(so.amount as decimal(18,2))) as total_amount
from [dbo].[bm_storageoperations] so
inner join [dbo].[vendors] v on so.vendorid = v.id
left join [dbo].[vendorgroup] vg on v.clientgroup = vg.vendorgroupid
where so.operationid = 1
group by format(so.dateadd, 'yyyy-MM'), vg.description, v.firstname
order by order_month desc, total_amount desc;

-- 4. Анализ работы персонала.
with EmployeeReceipts as (
    select 
        loginid as personid,
        datepart(year, dater) as yr,
        datepart(quarter, dater) as qtr,
        count(transnumber) as receipts_count,
        sum(cast(amount as decimal(18,2))) as total_revenue
    from [dbo].[journal]
    group by loginid, datepart(year, dater), datepart(quarter, dater)
),
EmployeeBarnetDocs as (
    select 
        PersonID,
        datepart(year, DateAdd) as yr,
        datepart(quarter, DateAdd) as qtr,
        count(ID) as barnet_docs_count
    from [dbo].[bm_JournalBarnetDocs]
    group by PersonID, datepart(year, DateAdd), datepart(quarter, DateAdd)
)
select 
    p.personid,
    p.lastname as lastname,
    p.firstname as role_or_name,
    er.yr as year_num,
    ed.qtr as quarter_num,
    er.receipts_count as receipts_count,
    er.total_revenue as total_revenue,
    ed.barnet_docs_count as barnet_docs_count
from [dbo].[personnel] p
left join EmployeeReceipts er on p.personid = er.personid
left join EmployeeBarnetDocs ed on p.personid = ed.PersonID and er.yr = ed.yr and er.qtr = ed.qtr
where er.receipts_count is not null or ed.barnet_docs_count is not null
order by year_num desc, quarter_num desc, total_revenue desc;

-- 5. Анализ остатков.
select 
    datepart(year, so.dateadd) as year_num,
    datepart(week, so.dateadd) as week_num,
    p.description as product_name,
    st.description as storage_name,
    sum(case when so.operationid = 1 then cast(so.[count] as decimal(18,2))
         else 0 end) as quantity_in,
    sum(case when so.operationid = 2 then cast(so.[count] as decimal(18,2)) 
        else 0 end) as quantity_out,
    sum(case when so.operationid = 1 then cast(so.[count] as decimal(18,2))
         else -try_cast(so.[count] as decimal(18,2)) end) as net_movement
from [dbo].[bm_storageoperations] so
inner join [dbo].[product] p on so.productid = p.id
left join [dbo].[storages] st on so.storageid = st.id
group by datepart(year, so.dateadd), datepart(week, so.dateadd), p.description, st.description
order by year_num desc, week_num desc, net_movement desc;
