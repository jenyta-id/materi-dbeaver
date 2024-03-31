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
[^longnote]: ROW_NUMBER() (Transact-SQL)

    ROW_NUMBER() adalah fungsi yang digunakan untuk menambahkan nomor urut ke setiap baris hasil query. OVER clause digunakan untuk mengurutkan baris hasil query berdasarkan nomor order.

    CONCAT (Transact-SQL)

      CONCAT adalah fungsi yang digunakan untuk menggabungkan beberapa string menjadi satu string. Dalam query di atas, CONCAT digunakan untuk menggabungkan nomor order dengan prefiks SALES- dan menggabungkan alamat pelanggan dari beberapa kolom.

    FORMAT (Transact-SQL)

      FORMAT adalah fungsi yang digunakan untuk memformat string menjadi bentuk yang lebih mudah dibaca. Dalam query di atas, FORMAT digunakan untuk memformat harga jual total dari setiap order menjadi format mata uang rupiah (IDR).

    COALESCE (Transact-SQL)

      COALESCE adalah fungsi yang digunakan untuk mengembalikan nilai pertama yang tidak null dari sebuah daftar nilai. Dalam query di atas, COALESCE digunakan untuk mengganti nilai null dari kolom alamat pelanggan dengan string -.

    GROUP BY (Transact-SQL)

      GROUP BY digunakan untuk mengelompokkan hasil query berdasarkan nilai dari kolom tertentu. Dalam query di atas, GROUP BY digunakanuntuk mengelompokkan hasil query berdasarkan nomor order.

    INNER JOIN (Transact-SQL)

      INNER JOIN digunakan untuk menggabungkan dua atau lebih tabel berdasarkan kondisi tertentu. Dalam query di atas, INNER JOIN digunakan untuk menggabungkan tabel orders dengan tabel customers dan orderdetails.

    WHERE (Transact-SQL)

       WHERE digunakan untuk mengfilter data hasil query berdasarkan kondisi tertentu. Dalam query di atas, WHERE digunakan untuk mengfilter data order dengan tanggal order yang sesuai.
