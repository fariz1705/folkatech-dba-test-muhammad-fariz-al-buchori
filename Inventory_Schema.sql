CREATE TABLE `products` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `product_name` varchar(255),
  `description` text,
  `category` varchar(255),
  `unit_price` decimal,
  `min_stock_level` integer,
  `created_at` timestamp DEFAULT 'now()',
  `updated_at` timestamp DEFAULT 'now()'
);

CREATE TABLE `warehouses` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `warehouse_name` varchar(255),
  `location` varchar(255),
  `created_at` timestamp DEFAULT 'now()',
  `updated_at` timestamp DEFAULT 'now()'
);

CREATE TABLE `stock` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `product_id` integer NOT NULL,
  `warehouse_id` integer NOT NULL,
  `quantity` integer,
  `updated_at` timestamp DEFAULT 'now()'
);

CREATE TABLE `transactions` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `product_id` integer NOT NULL,
  `warehouse_id` integer NOT NULL,
  `transaction_type` varchar(50) COMMENT 'IN or OUT',
  `quantity` integer,
  `transaction_date` timestamp DEFAULT 'now()',
  `remarks` text
);

CREATE TABLE `suppliers` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `supplier_name` varchar(255),
  `contact_info` text,
  `created_at` timestamp DEFAULT 'now()',
  `updated_at` timestamp DEFAULT 'now()'
);

CREATE TABLE `restock_orders` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `product_id` integer NOT NULL,
  `supplier_id` integer NOT NULL,
  `warehouse_id` integer NOT NULL,
  `order_date` timestamp DEFAULT 'now()',
  `quantity` integer,
  `status` varchar(50) DEFAULT 'Pending' COMMENT 'Pending, Shipped, Received'
);

ALTER TABLE `stock` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `stock` ADD FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

ALTER TABLE `transactions` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `transactions` ADD FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);

ALTER TABLE `restock_orders` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `restock_orders` ADD FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

ALTER TABLE `restock_orders` ADD FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`);
