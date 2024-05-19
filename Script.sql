use classicmodels;
SELECT 
    ROW_NUMBER() OVER(ORDER BY orders.orderNumber) AS 'No',
    orders.orderDate as 'Tanggal Oder',
    Concat('SALES-', orders.orderNumber) as 'No Oder',
    Concat(SUM(orderdetails.quantityOrdered), ' Units') as 'Quantity Sales',
    Concat('$ ', ROUND(SUM(orderdetails.priceEach), 0)) as 'Value Sale',
    FORMAT(ROUND(SUM(orderdetails.priceEach), 0) * 16000, ',') as 'Value Sales (Rp)',
    customers.customerName as 'Nama Pelanggan',
    customers.phone as 'No Telp',
    COALESCE(Concat(customers.addressLine1, ' ', customers.city, ' ', customers.country, ' ', customers.postalCode), '-') as 'Alamat',
    orders.status as 'Status Order',
    COALESCE(orders.comments, '-') as 'Note Order'
FROM orders 
INNER JOIN customers 
    ON orders.customerNumber = customers.customerNumber 
INNER JOIN orderdetails 
    ON orderdetails.orderNumber = orders.orderNumber 
WHERE 
    orders.orderDate >= '2003-02-01' AND 
    orders.orderDate <= '2003-03-31'
GROUP BY orders.orderNumber;




-- pembelajaran MSIB IT 3/28/2024

select o.orderNumber, o.customerNumber, o.orderDate, o.status, o.comments, sum(o2.quantityOrdered) qty, sum(o2.priceEach) price from orders o 
   inner join orderdetails o2 
      on o.orderNumber = o2.orderNumber 
      group by o.orderNumber 
      order by o.orderNumber ;
   
select @b:=@b+1 `No`, y. * from (
select /*z**/ concat('SALES-', z.orderNumber) as `No Order`, date_format(z.orderDate, '%d %M %Y') `Tgl Order`, /*z.productCode as `Kode Produk`, p.productName as `Nama Produk`, concat(z.quantityOrdered, ' Units') `Qty`,*/ concat(z.productCode, ' - ', p.productName, ' - ', z.quantityOrdered) as `Tes Gabungin (SKU)`, p.productVendor `Vendor`, c.customerName `Pembeli`, c.phone `No Telp`, if(e.jobTitle!='',e.jobTitle, 'Tidak Bekerja') `Pekerjaan`, round(if(p2.amount!='', p2.amount,0)) `Saldo`, c.country `Negara` 
from (
select o.orderNumber, o.orderDate, o.status, o.customerNumber, o2.productCode, o2.quantityOrdered, o2.priceEach from orders o 
  inner join orderdetails o2
    on o.orderNumber = o2.orderNumber 
 where o.orderNumber = 10101
) as z inner join products p 
    on p.productCode = z.productCode
    inner join customers c
       on c.customerNumber = z.customerNumber
    left join employees e 
       on c.salesRepEmployeeNumber = e.reportsTo
    left join payments p2
       on c.customerNumber = p2.customerNumber
) as y, (select @b=0) b;

select * from information_schema;
call sp_report_penjualan_detail(10204);
select * from orders o ;
select * from payments p ;

