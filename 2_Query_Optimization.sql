-- 1. Menampilkan stok produk yang tersedia di semua gudang

SELECT
  p.product_name,
  w.warehouse_name,
  s.quantity
FROM stock s
JOIN products p ON s.product_id = p.id
JOIN warehouses w ON s.warehouse_id = w.id
ORDER BY p.product_name, w.warehouse_name;

-- Optimisasi:

-- Gunakan index pada stock.product_id dan stock.warehouse_id untuk mempercepat JOIN.
-- Pastikan ada index pada products.id dan warehouses.id.
-- ORDER BY berdasarkan product_name dan warehouse_name akan optimal jika sudah diurutkan oleh index di kolom terkait (optional tergantung kebutuhan sorting

-- 2. Menampilkan stok produk yang ada di bawah level minimum dan perlu di-restock

SELECT
  p.product_name,
  SUM(s.quantity) AS total_stock,
  p.min_stock_level
FROM products p
LEFT JOIN stock s ON s.product_id = p.id
GROUP BY p.id
HAVING SUM(s.quantity) < p.min_stock_level;

-- Optimisasi:

-- Gunakan LEFT JOIN agar produk yang belum punya stok tetap muncul (bisa total stok-nya NULL).
-- Index yang disarankan: stock.product_id, products.id, dan products.min_stock_level.
-- Pastikan agregasi SUM() tidak menghitung NULL sebagai 0.

-- 3. Menghitung total nilai inventaris di semua gudang berdasarkan harga produk

SELECT
  SUM(s.quantity * p.unit_price) AS total_inventory_value
FROM stock s
JOIN products p ON s.product_id = p.id;

-- Optimisasi:
-- Index di stock.product_id dan products.unit_price.
-- Pastikan unit_price menggunakan tipe data numerik presisi tinggi seperti DECIMAL(10,2).

-- 4. Menghasilkan laporan transaksi masuk dan keluar 3 bulan terakhir

SELECT
  t.transaction_date,
  t.transaction_type,
  p.product_name,
  w.warehouse_name,
  t.quantity,
  t.remarks
FROM transactions t
JOIN products p ON t.product_id = p.id
JOIN warehouses w ON t.warehouse_id = w.id
WHERE t.transaction_date >= NOW() - INTERVAL 3 MONTH
ORDER BY t.transaction_date DESC;

-- Optimisasi:
-- Tambahkan index di transactions.transaction_date dan transaction_type untuk mempercepat filter waktu.
-- Gunakan WHERE untuk membatasi pencarian data besar di tabel transaksi.
-- Hindari fungsi DATE() di WHERE karena membuat query non-sargable (tidak pakai index).

-- 5. Menampilkan daftar permintaan restock

SELECT
  ro.order_date,
  p.product_name,
  s.supplier_name,
  w.warehouse_name,
  ro.quantity,
  ro.status
FROM restock_orders ro
JOIN products p ON ro.product_id = p.id
JOIN suppliers s ON ro.supplier_id = s.id
JOIN warehouses w ON ro.warehouse_id = w.id
ORDER BY ro.order_date DESC;

-- Optimisasi:
-- Pastikan ada index di kolom ro.order_date, product_id, supplier_id, warehouse_id.
-- Jika data besar, filter WHERE ro.status = 'pending' atau sesuai status untuk membatasi rows.