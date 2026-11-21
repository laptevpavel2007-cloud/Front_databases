use [Front];
go

select 'insert into procurement(doc_id, prod_id, ven_id, quan, amount, date_add) values ('
    + cast(DocumentID as varchar(max)) + ','
    + cast(ProductID as varchar(max)) + ','
    + cast(VendorID as varchar(max)) + ','
    + cast(cast([Count] as float) as varchar(max)) + ','
    + cast(cast(Amount as float) as varchar(max)) + ','''
    + convert(varchar(19), DateAdd, 120) + ''');'
as [sql]
from [dbo].[bm_StorageOperations]
where OperationID = 1;


select 'insert into sales(prod_id, pers_id, quan, rev, date_add) values ('
    + cast(jd.ProductID as varchar(max)) + ','
    + cast(cast(j.loginid as int) as varchar(max)) + ','
    + cast(cast(jd.Quantity as float) as varchar(max)) + ','
    + cast(cast(replace(jd.sBrutto, ',', '.') as float) as varchar(max)) + ','''
    + convert(varchar(19), j.dater, 120) + ''');'
as [sql]
from [dbo].[bm_Journal_Details] jd
inner join [dbo].[journal] j on jd.SourceID = j.transnumber;


select 'insert into personnel_stats(pers_id, receipts, revenue, date_add) values ('
    + cast(loginid as varchar(max)) + ','
    + cast(count(transnumber) as varchar(max)) + ','
    + cast(sum(isnull(cast(amount as float), 0)) as varchar(max)) + ','''
    + cast(year(dater) as varchar(max)) + '-' 
    + right('0' + cast(month(dater) as varchar(max)), 2) + '-01 00:00:00'');'
as [sql]
from [dbo].[journal]
group by loginid, year(dater), month(dater);


select 'insert into inventory(prod_id, year_n, week_n, qty_in, qty_out, date_add) values ('
    + cast(ProductID as varchar(max)) + ','
    + cast(datepart(year, DateAdd) as varchar(max)) + ','
    + cast(datepart(week, DateAdd) as varchar(max)) + ','
    + cast(sum(case 
                when OperationID = 1 then isnull(cast([Count] as float), 0) 
                else 0 
               end) as varchar(max)) + ','
    + cast(sum(case 
                when OperationID = 2 then isnull(cast([Count] as float), 0) 
                else 0 
               end) as varchar(max)) + ','''
    + convert(varchar(19), min(DateAdd), 120) + ''');'
as [sql]
from [dbo].[bm_StorageOperations]
group by ProductID, datepart(year, DateAdd), datepart(week, DateAdd);