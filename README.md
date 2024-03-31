# materi-dbeaver

## Report Penjualan Periode 2003-02-01 s/d 2003-03-31
SQL yang akan dijelaskan dalam dokumentasi ini digunakan untuk membuat laporan penjualan periode 1 Febuari 2003 s/d 31 Maret 2003 dari database classicmodels.

> Pertama, mari kita buat query untuk mendapatkan data yang diperlukan. Query ini melakukan inner join tabel orders dengan tabel customers dan orderdetails untuk mendapatkan data customer, order, dan detail order sebagai berikut:

```
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
```

> Berikut ini adalah penjelasan untuk setiap bagian dari query di atas:
1. 'ROW_NUMBER()' OVER(ORDER BY orders.orderNumber) AS 'No': Menambahkan nomor urut ke setiap baris hasil query dengan mengurutkan berdasarkan nomor order.
orders.orderDate as 'Tanggal Oder': Menampilkan tanggal order.
2. 'Concat('SALES-', orders.orderNumber)' as 'No Oder': Menampilkan nomor order dengan prefiks SALES-.
3. 'Concat(SUM(orderdetails.quantityOrdered)', ' Units') as 'Quantity Sales': Menampilkan jumlah unit yang terjual dari setiap order.
4. 'Concat('$ ', ROUND(SUM(orderdetails.priceEach), 0))' as 'Value Sale': Menampilkan harga jual total dari setiap order.
5. 'FORMAT(ROUND(SUM(orderdetails.priceEach), 0) * 16000, ',')' as 'Value Sales (Rp)': Menampilkan harga jual total dari setiap order dalam mata uang rupiah (IDR).
6. 'customers.customerName' as 'Nama Pelanggan': Menampilkan nama pelanggan.
7. 'customers.phone' as 'No Telp': Menampilkan nomor telepon pelanggan.
8. 'COALESCE(Concat(customers.addressLine1', ' ', customers.city, ' ', customers.country, ' ', customers.postalCode), '-') as 'Alamat': Menampilkan alamat pelanggan.
9. 'orders.status' as 'Status Order': Menampilkan status order.
10. 'COALESCE(orders.comments', '-') as 'Note Order': Menampilkan catatan order.

> Selain itu, query ini juga melakukan filtering data order dengan menggunakan WHERE clause, yaitu hanya menampilkan data order yang tanggal ordernya antara 1 Februari 2003 s/d 31 Maret 2003.
> Setelah query di atas sudah benar, kita bisa mengeksekusinya di client atau tools yang digunakan untuk mengakses database classicmodels. Hasil dari query ini akan menjadi sebuah tabel yang berisi data penjualan periode 1 Februari 2003 s/d 31 Maret 2003.

> Penjelasan Detailnya
1. ROW_NUMBER() (Transact-SQL)
'ROW_NUMBER()' adalah fungsi yang digunakan untuk menambahkan nomor urut ke setiap baris hasil query. OVER clause digunakan untuk mengurutkan baris hasil query berdasarkan nomor order.
2. CONCAT (Transact-SQL)
'CONCAT' adalah fungsi yang digunakan untuk menggabungkan beberapa string menjadi satu string. Dalam query di atas, CONCAT digunakan untuk menggabungkan nomor order dengan prefiks SALES- dan menggabungkan alamat pelanggan dari beberapa kolom.
3. FORMAT (Transact-SQL)
'FORMAT' adalah fungsi yang digunakan untuk memformat string menjadi bentuk yang lebih mudah dibaca. Dalam query di atas, FORMAT digunakan untuk memformat harga jual total dari setiap order menjadi format mata uang rupiah (IDR).
4. COALESCE (Transact-SQL)
'COALESCE' adalah fungsi yang digunakan untuk mengembalikan nilai pertama yang tidak null dari sebuah daftar nilai. Dalam query di atas, COALESCE digunakan untuk mengganti nilai null dari kolom alamat pelanggan dengan string -.
5. GROUP BY (Transact-SQL)
'GROUP BY' digunakan untuk mengelompokkan hasil query berdasarkan nilai dari kolom tertentu. Dalam query di atas, GROUP BY digunakanuntuk mengelompokkan hasil query berdasarkan nomor order.
6. INNER JOIN (Transact-SQL)
'INNER JOIN' digunakan untuk menggabungkan dua atau lebih tabel berdasarkan kondisi tertentu. Dalam query di atas, INNER JOIN digunakan untuk menggabungkan tabel orders dengan tabel customers dan orderdetails.
7. WHERE (Transact-SQL)
' WHERE' digunakan untuk mengfilter data hasil query berdasarkan kondisi tertentu. Dalam query di atas, WHERE digunakan untuk mengfilter data order dengan tanggal order yang sesuai.

## <Localhost> Script
```
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
```

## Procedure parameters di MySQL dengan menggunakan DBeaver
1. Buka DBeaver dan koneksikan ke database MySQL Anda.
2. Klik kanan pada database yang ingin Anda gunakan, lalu pilih "Create Procedure".
3. Pada window "Create Procedure", tentukan nama procedure, parameter yang diperlukan, dan tipe data yang akan dikembalikan. Dalam contoh ini, kita akan membuat procedure bernama "sp_report_penjualan_detail" yang menerima satu parameter bertipe data integer bernama "numor".
4. Dalam body procedure, kita akan menggunakan query berikut untuk mengambil data penjualan berdasarkan nomor pesanan yang diberikan:
```
CREATE DEFINER=`root`@`localhost` PROCEDURE `classicmodels`.`sp_report_penjualan_detail`(numor int)
begin
	set @numor:=numor;
select @b:=@b+1 `No`, y. * from (
select /*z**/ concat('SALES-', z.orderNumber) as `No Order`, date_format(z.orderDate, '%d %M %Y') `Tgl Order`, /*z.productCode as `Kode Produk`, p.productName as `Nama Produk`, concat(z.quantityOrdered, ' Units') `Qty`,*/ concat(z.productCode, ' - ', p.productName, ' - ', z.quantityOrdered) as `Tes Gabungin (SKU)`, p.productVendor `Vendor`, c.customerName `Pembeli`, c.phone `No Telp`, if(e.jobTitle!='',e.jobTitle, 'Tidak Bekerja') `Pekerjaan`, round(if(p2.amount!='', p2.amount,0)) `Saldo`, c.country `Negara` 
from (
select o.orderNumber, o.orderDate, o.status, o.customerNumber, o2.productCode, o2.quantityOrdered, o2.priceEach from orders o 
  inner join orderdetails o2
    on o.orderNumber = o2.orderNumber 
 where o.orderNumber = @numor
) as z inner join products p 
    on p.productCode = z.productCode
    inner join customers c
       on c.customerNumber = z.customerNumber
    left join employees e 
       on c.salesRepEmployeeNumber = e.reportsTo
    left join payments p2
       on c.customerNumber = p2.customerNumber
) as y, (select @b=0) b;
END
```
5. Klik tombol "Execute" untuk menjalankan query atau CTRL+tanda panah atas+Enter
