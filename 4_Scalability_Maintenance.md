# 4. Skalabilitas & Pemeliharaan

# A. Pembagian Tabel (Table Partitioning)

Saya akan membagi tabel besar seperti transaksi menjadi bagian-bagian kecil berdasarkan waktu. Ini seperti menyimpan dokumen lama di map terpisah berdasarkan tahun, sehingga lebih mudah dicari dan dikelola.

Contoh untuk tabel transaksi di MySQL:

```sql
CREATE TABLE transactions (
  id INT AUTO_INCREMENT,
  product_id INT,
  transaction_date DATE,
  PRIMARY KEY (id, transaction_date)
)
PARTITION BY RANGE (YEAR(transaction_date)) (
  PARTITION p2020 VALUES LESS THAN (2021),
  PARTITION p2021 VALUES LESS THAN (2022),
  PARTITION p2022 VALUES LESS THAN (2023),
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

Keuntungannya:
- Query lebih cepat karena hanya memindai data di partisi tertentu
- Backup bisa dilakukan per partisi
- Data lama bisa diarsipkan lebih mudah

# B. Perawatan Rutin Database

1. Perawatan Indeks
   Setiap bulan saya akan menjalankan:
   ```sql
   OPTIMIZE TABLE transactions, stock;
   ```
   Ini seperti merapikan buku di perpustakaan agar tetap mudah dicari.

2. Pemantauan
   Saya akan memantau:
   - Query yang lambat (menggunakan slow query log)
   - Kunci yang bermasalah
   - Penggunaan ruang penyimpanan

   Contoh perintah untuk melihat query lambat:
   ```sql
   SELECT * FROM mysql.slow_log ORDER BY start_time DESC LIMIT 10;
   ```

3. Backup
   Strategi backup saya:
   - Backup penuh setiap minggu
   - Backup incremental setiap hari
   - Simpan backup di 2 lokasi berbeda

   Contoh backup sederhana:
   ```bash
   mysqldump -u admin -p inventory > backup_$(date +%Y%m%d).sql
   ```

4. Pembersihan Data
   Data transaksi lebih dari 3 tahun akan dipindahkan ke tabel arsip:
   ```sql
   INSERT INTO transactions_archive
   SELECT * FROM transactions 
   WHERE transaction_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);
   
   DELETE FROM transactions 
   WHERE transaction_date < DATE_SUB(NOW(), INTERVAL 3 YEAR);
   ```

# Tips Tambahan dari Pengalaman

1. Jadwal Perawatan
   - Setiap pagi: Cek error log
   - Setiap minggu: Optimasi tabel penting
   - Setiap bulan: Review indeks yang tidak terpakai

2. Alat Bantu
   - phpMyAdmin untuk monitoring sederhana
   - Percona Toolkit untuk analisis lebih dalam
   - Custom script untuk otomatisasi backup

3. Pentingnya Dokumentasi
   Selalu catat:
   - Perubahan struktur database
   - Masalah yang pernah terjadi dan solusinya
   - Jadwal perawatan rutin

Dengan pendekatan ini, database kita bisa:
- Menangani pertumbuhan data yang pesat
- Tetap cepat meski data sudah bertahun-tahun
- Mudah dipulihkan jika terjadi masalah