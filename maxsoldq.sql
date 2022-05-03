select sum(Quantity) as solgt, od.productid, ProductName, c.categoryname, s.suppliername from 
order_details as od, products as p, categories as c, suppliers as s
where od.productid=p.productid
and p.categoryid=c.categoryid
and p.supplierid=s.supplierid
group by od.productid,productname order by 1 desc limit 5 ;
