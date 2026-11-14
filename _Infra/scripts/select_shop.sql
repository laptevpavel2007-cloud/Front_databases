-- Анализ закупки продукции.
select 
    format(so.dateadd, 'yyyy-MM') as purchase_month,
    isnull(vg.description, 'Без группы') as vendor_group,
    v.firstname as vendor_name,
    p.description as product_name,
    sum(cast(so.amount as decimal(18,2))) as total_amount
from [dbo].[bm_storageoperations] so
join [dbo].[vendors] v on so.vendorid = v.id
left join [dbo].[vendorgroup] vg on v.clientgroup = vg.vendorgroupid
join [dbo].[product] p on so.productid = p.id
where so.operationid = 1
group by format(so.dateadd, 'yyyy-MM'), vg.description, v.firstname, p.description
order by purchase_month desc, total_amount desc;

-- Анализ продажи товара.
select 
    format(j.dater, 'yyyy-MM') as sales_month,
    tt.description as operation_type,
    p.description as product_name,
    sum(cast(jd.quantity as decimal(18,2))) as total_sold,
    sum(cast(jd.sbrutto as decimal(18,2))) as total_revenue
from [dbo].[bm_journal_details] jd
join [dbo].[journal] j on jd.sourceid = j.id
left join [dbo].[transtype] tt on j.transtype = tt.transtypeid
join [dbo].[product] p on jd.productid = p.id
group by format(j.dater, 'yyyy-MM'), tt.description, p.description
order by sales_month desc, total_revenue desc;


-- Анализ взаимоотношений с поставщиками.
select 
    format(so.dateadd, 'yyyy-MM') as order_month,
    coalesce(vg.description, 'Без группы') as vendor_group,
    v.firstname as vendor_name,
    p.description as product_name,
    count(distinct so.documentid) as documents_count,
    sum(try_cast(so.amount as decimal(18,2))) as total_amount
from [dbo].[bm_storageoperations] so
join [dbo].[vendors] v on so.vendorid = v.id
left join [dbo].[vendorgroup] vg on v.clientgroup = vg.vendorgroupid
join [dbo].[product] p on so.productid = p.id
where so.operationid = 1
group by format(so.dateadd, 'yyyy-MM'), vg.description, v.firstname, p.description
order by order_month desc, total_amount desc;


-- Анализ работы персонала.
select 
    datepart(year, j.dater) as year_num,
    datepart(quarter, j.dater) as quarter_num,
    p.lastname + ' ' + p.firstname as employee_name,
    count(distinct j.id) as receipts_count,
    sum(cast(j.amount as decimal(18,2))) as total_revenue,
    count(distinct js.id) as sessions_count
from [dbo].[journal] j
join [dbo].[personnel] p on j.loginid = p.personid
left join [dbo].[bm_journalsessions] js on p.personid = js.personid
group by datepart(year, j.dater), datepart(quarter, j.dater), p.lastname, p.firstname
order by year_num desc, quarter_num desc, total_revenue desc;


-- Анализ остатков.
select 
    datepart(year, so.dateadd) as year_num,
    datepart(week, so.dateadd) as week_num,
    p.description as product_name,
    sum(case when so.operationid = 1 then cast(so.quantity as decimal(18,2)) else 0 end) as quantity_in,
    sum(case when so.operationid = 2 then cast(so.quantity as decimal(18,2)) else 0 end) as quantity_out,
    sum(case when so.operationid = 1 then cast(so.quantity as decimal(18,2)) else -cast(so.quantity as decimal(18,2)) end) as net_movement
from [dbo].[bm_storageoperations] so
join [dbo].[product] p on so.productid = p.id
group by datepart(year, so.dateadd), datepart(week, so.dateadd), p.description
order by year_num desc, week_num desc, net_movement desc;