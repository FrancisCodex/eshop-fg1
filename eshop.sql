-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 07, 2024 at 03:42 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eshop`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` char(36) NOT NULL DEFAULT uuid(),
  `user_id` char(36) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` > 0),
  `is_selected_for_checkout` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `product_id`, `quantity`, `is_selected_for_checkout`) VALUES
('2e02dd3e-ad61-11ef-aa97-088fc343d6e5', '2dfaaf4c-ad61-11ef-aa97-088fc343d6e5', 1, 2, 1),
('2e02f171-ad61-11ef-aa97-088fc343d6e5', '2dfaaf4c-ad61-11ef-aa97-088fc343d6e5', 3, 1, 1),
('2e02f295-ad61-11ef-aa97-088fc343d6e5', '2dfab9a1-ad61-11ef-aa97-088fc343d6e5', 6, 1, 1),
('2e02f321-ad61-11ef-aa97-088fc343d6e5', '2dfab9a1-ad61-11ef-aa97-088fc343d6e5', 5, 1, 0),
('2e02f3b2-ad61-11ef-aa97-088fc343d6e5', '2dfaba83-ad61-11ef-aa97-088fc343d6e5', 8, 1, 1),
('2e02f435-ad61-11ef-aa97-088fc343d6e5', '2dfaba83-ad61-11ef-aa97-088fc343d6e5', 10, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `checkout`
--

CREATE TABLE `checkout` (
  `checkout_id` char(36) NOT NULL DEFAULT uuid(),
  `order_id` char(36) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `checkout`
--

INSERT INTO `checkout` (`checkout_id`, `order_id`, `product_id`, `quantity`) VALUES
('2e08c3e2-ad61-11ef-aa97-088fc343d6e5', '2e06f4b5-ad61-11ef-aa97-088fc343d6e5', 1, 2),
('2e08d67a-ad61-11ef-aa97-088fc343d6e5', '2e06f4b5-ad61-11ef-aa97-088fc343d6e5', 3, 1),
('2e08d78b-ad61-11ef-aa97-088fc343d6e5', '2e0704e2-ad61-11ef-aa97-088fc343d6e5', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` char(36) NOT NULL DEFAULT uuid(),
  `user_id` char(36) DEFAULT NULL,
  `order_date` date NOT NULL DEFAULT curdate(),
  `address_id` char(36) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `order_status` varchar(20) NOT NULL DEFAULT 'Pending'
) ;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `address_id`, `total_amount`, `order_status`) VALUES
('2e06f4b5-ad61-11ef-aa97-088fc343d6e5', '2dfaaf4c-ad61-11ef-aa97-088fc343d6e5', '2024-11-28', '2e051ea6-ad61-11ef-aa97-088fc343d6e5', 159.97, 'Pending'),
('2e0704e2-ad61-11ef-aa97-088fc343d6e5', '2dfab8bb-ad61-11ef-aa97-088fc343d6e5', '2024-11-28', '2e05297f-ad61-11ef-aa97-088fc343d6e5', 49.99, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment_id` char(36) NOT NULL DEFAULT uuid(),
  `order_id` char(36) DEFAULT NULL,
  `payment_date` date DEFAULT curdate(),
  `payment_method` varchar(20) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT 'Pending',
  `encrypted_payment_details` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`payment_id`, `order_id`, `payment_date`, `payment_method`, `payment_status`, `encrypted_payment_details`) VALUES
('2e0a96ea-ad61-11ef-aa97-088fc343d6e5', '2e06f4b5-ad61-11ef-aa97-088fc343d6e5', '2024-11-28', 'Credit Card', 'Completed', 0x656e637279707465645f64657461696c735f31),
('2e0aa2ea-ad61-11ef-aa97-088fc343d6e5', '2e0704e2-ad61-11ef-aa97-088fc343d6e5', '2024-11-28', 'PayPal', 'Completed', 0x656e637279707465645f64657461696c735f32);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `user_id` char(36) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `size` varchar(10) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `material` varchar(50) DEFAULT NULL,
  `date_added` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `user_id`, `product_name`, `description`, `price`, `category_id`, `image_url`, `size`, `color`, `material`, `date_added`) VALUES
(1, '2dfab8bb-ad61-11ef-aa97-088fc343d6e5', 'Casual Shirt', 'A comfortable casual shirt.', 29.99, 1, 'url_to_image_1', 'M', 'Blue', 'Cotton', '2024-11-28'),
(2, '2dfab8bb-ad61-11ef-aa97-088fc343d6e5', 'Denim Jeans', 'Classic blue denim jeans', 45.99, 2, 'url_to_image_2', '32', 'Blue', 'Denim', '2024-11-28'),
(3, '2dfab9eb-ad61-11ef-aa97-088fc343d6e5', 'Leather Jacket', 'Stylish leather jacket', 99.99, 3, 'url_to_image_3', 'L', 'Black', 'Leather', '2024-11-28'),
(4, '2dfab9eb-ad61-11ef-aa97-088fc343d6e5', 'Winter Boots', 'Warm winter boots', 79.99, 4, 'url_to_image_4', '9', 'Brown', 'Leather', '2024-11-28'),
(5, '2dfabacb-ad61-11ef-aa97-088fc343d6e5', 'Sports Watch', 'Digital sports watch', 34.99, 5, 'url_to_image_5', NULL, 'Black', 'Plastic', '2024-11-28'),
(6, '2dfabacb-ad61-11ef-aa97-088fc343d6e5', 'Running Shoes', 'Lightweight running shoes', 59.99, 4, 'url_to_image_6', '10', 'Red', 'Synthetic', '2024-11-28'),
(7, '2dfab8bb-ad61-11ef-aa97-088fc343d6e5', 'Wool Scarf', 'Warm winter scarf', 24.99, 5, 'url_to_image_7', NULL, 'Gray', 'Wool', '2024-11-28'),
(8, '2dfab9eb-ad61-11ef-aa97-088fc343d6e5', 'Summer Dress', 'Floral summer dress', 49.99, 1, 'url_to_image_8', 'M', 'Floral', 'Cotton', '2024-11-28'),
(9, '2dfabacb-ad61-11ef-aa97-088fc343d6e5', 'Leather Belt', 'Classic leather belt', 29.99, 5, 'url_to_image_9', 'M', 'Brown', 'Leather', '2024-11-28'),
(10, '2dfab8bb-ad61-11ef-aa97-088fc343d6e5', 'Sunglasses', 'UV protection sunglasses', 39.99, 5, 'url_to_image_10', NULL, 'Black', 'Plastic', '2024-11-28');

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE `product_category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_category`
--

INSERT INTO `product_category` (`category_id`, `category_name`) VALUES
(5, 'Accessories'),
(3, 'Jackets'),
(2, 'Pants'),
(1, 'Shirts'),
(4, 'Shoes');

-- --------------------------------------------------------

--
-- Table structure for table `product_inventory`
--

CREATE TABLE `product_inventory` (
  `inventory_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` >= 0),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_inventory`
--

INSERT INTO `product_inventory` (`inventory_id`, `product_id`, `quantity`, `updated_at`) VALUES
(1, 1, 100, '2024-11-28 08:17:16'),
(2, 2, 75, '2024-11-28 08:17:16'),
(3, 3, 50, '2024-11-28 08:17:16'),
(4, 4, 60, '2024-11-28 08:17:16'),
(5, 5, 120, '2024-11-28 08:17:16'),
(6, 6, 80, '2024-11-28 08:17:16'),
(7, 7, 150, '2024-11-28 08:17:16'),
(8, 8, 90, '2024-11-28 08:17:16'),
(9, 9, 200, '2024-11-28 08:17:16'),
(10, 10, 100, '2024-11-28 08:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `request_logs`
--

CREATE TABLE `request_logs` (
  `ip` varchar(45) DEFAULT NULL,
  `timestamp` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `request_logs`
--

INSERT INTO `request_logs` (`ip`, `timestamp`) VALUES
('::1', 1733538947),
('::1', 1733538949);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL
) ;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(3, 'Admin'),
(1, 'Buyer'),
(2, 'Seller');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_address`
--

CREATE TABLE `shipping_address` (
  `address_id` char(36) NOT NULL DEFAULT uuid(),
  `user_id` char(36) DEFAULT NULL,
  `street_address` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `country` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipping_address`
--

INSERT INTO `shipping_address` (`address_id`, `user_id`, `street_address`, `city`, `state`, `postal_code`, `country`) VALUES
('2e051ea6-ad61-11ef-aa97-088fc343d6e5', '2dfaaf4c-ad61-11ef-aa97-088fc343d6e5', '123 Main St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e05297f-ad61-11ef-aa97-088fc343d6e5', '2dfab8bb-ad61-11ef-aa97-088fc343d6e5', '456 Elm St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052a03-ad61-11ef-aa97-088fc343d6e5', '2dfab94e-ad61-11ef-aa97-088fc343d6e5', '789 Oak St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052a3b-ad61-11ef-aa97-088fc343d6e5', '2dfab9a1-ad61-11ef-aa97-088fc343d6e5', '101 Maple St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052a71-ad61-11ef-aa97-088fc343d6e5', '2dfab9eb-ad61-11ef-aa97-088fc343d6e5', '202 Birch St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052aa8-ad61-11ef-aa97-088fc343d6e5', '2dfaba39-ad61-11ef-aa97-088fc343d6e5', '303 Cedar St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052ad7-ad61-11ef-aa97-088fc343d6e5', '2dfaba83-ad61-11ef-aa97-088fc343d6e5', '404 Pine St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052b13-ad61-11ef-aa97-088fc343d6e5', '2dfabacb-ad61-11ef-aa97-088fc343d6e5', '505 Spruce St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052b48-ad61-11ef-aa97-088fc343d6e5', '2dfabb21-ad61-11ef-aa97-088fc343d6e5', '606 Fir St', 'Anytown', 'Anystate', '12345', 'USA'),
('2e052b77-ad61-11ef-aa97-088fc343d6e5', '2dfabb66-ad61-11ef-aa97-088fc343d6e5', '707 Walnut St', 'Anytown', 'Anystate', '12345', 'USA');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` char(36) NOT NULL DEFAULT uuid(),
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `contacts` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `reg_date` date DEFAULT curdate(),
  `role_id` int(11) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `date_of_birth`, `contacts`, `email`, `password`, `reg_date`, `role_id`, `is_verified`) VALUES
('2dfaaf4c-ad61-11ef-aa97-088fc343d6e5', 'John', 'Doe', '1980-01-01', '09123456789', 'john.doe@example.com', '$2y$10$4UcjxGIlLvyUqPCXM1kvj.Demo3ZKSScoAjZ/8FWydpPPmeBtLZna', '2024-11-28', 1, 1),
('2dfab8bb-ad61-11ef-aa97-088fc343d6e5', 'Jane', 'Smith', '1990-05-15', '09234567890', 'jane.smith@example.com', 'hashed_password_2', '2024-11-28', 2, 1),
('2dfab94e-ad61-11ef-aa97-088fc343d6e5', 'Alice', 'Johnson', '1985-07-22', '09345678901', 'alice.johnson@example.com', 'hashed_password_3', '2024-11-28', 3, 1),
('2dfab9a1-ad61-11ef-aa97-088fc343d6e5', 'Bob', 'Brown', '2000-09-30', '09456789012', 'bob.brown@example.com', 'hashed_password_4', '2024-11-28', 1, 0),
('2dfab9eb-ad61-11ef-aa97-088fc343d6e5', 'Carol', 'Davis', '1995-03-11', '09567890123', 'carol.davis@example.com', 'hashed_password_5', '2024-11-28', 2, 0),
('2dfaba39-ad61-11ef-aa97-088fc343d6e5', 'Dave', 'Wilson', '1992-06-18', '09678901234', 'dave.wilson@example.com', 'hashed_password_6', '2024-11-28', 3, 0),
('2dfaba83-ad61-11ef-aa97-088fc343d6e5', 'Eve', 'Taylor', '1988-12-25', '09789012345', 'eve.taylor@example.com', 'hashed_password_7', '2024-11-28', 1, 0),
('2dfabacb-ad61-11ef-aa97-088fc343d6e5', 'Frank', 'Anderson', '1975-10-01', '09890123456', 'frank.anderson@example.com', 'hashed_password_8', '2024-11-28', 2, 0),
('2dfabb21-ad61-11ef-aa97-088fc343d6e5', 'Grace', 'Thomas', '2001-02-14', '09901234567', 'grace.thomas@example.com', 'hashed_password_9', '2024-11-28', 3, 0),
('2dfabb66-ad61-11ef-aa97-088fc343d6e5', 'Hank', 'Moore', '1998-11-03', '09012345678', 'hank.moore@example.com', 'hashed_password_10', '2024-11-28', 1, 0),
('456e1d16-ad69-11ef-aa97-088fc343d6e5', 'bogs', 'meow', '2004-11-22', '9111111111', 'dejilef119@jonespal.com', '$2y$10$4UcjxGIlLvyUqPCXM1kvj.Demo3ZKSScoAjZ/8FWydpPPmeBtLZna', '2024-11-28', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_tokens`
--

CREATE TABLE `user_tokens` (
  `token_id` int(11) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `token_type` varchar(20) NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ;

--
-- Dumping data for table `user_tokens`
--

INSERT INTO `user_tokens` (`token_id`, `user_id`, `token`, `token_type`, `issued_at`, `expires_at`) VALUES
(3, '2dfaaf4c-ad61-11ef-aa97-088fc343d6e5', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzM1MzgwMzMsImV4cCI6MTczMzU0ODgzMywidXNlcl9pZCI6IjJkZmFhZjRjLWFkNjEtMTFlZi1hYTk3LTA4OGZjMzQzZDZlNSIsInJvbGUiOiJCdXllciJ9.rVOZVIfERUqIrW1l-lKeodsvD24Px4ZbO3BCKe8g5FQ', 'JWT', '2024-12-07 02:20:33', '2024-12-07 05:20:33');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `checkout`
--
ALTER TABLE `checkout`
  ADD PRIMARY KEY (`checkout_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `address_id` (`address_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Indexes for table `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `shipping_address`
--
ALTER TABLE `shipping_address`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `contacts` (`contacts`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD PRIMARY KEY (`token_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `product_category`
--
ALTER TABLE `product_category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_inventory`
--
ALTER TABLE `product_inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_tokens`
--
ALTER TABLE `user_tokens`
  MODIFY `token_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `checkout`
--
ALTER TABLE `checkout`
  ADD CONSTRAINT `checkout_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `checkout_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `shipping_address` (`address_id`) ON DELETE SET NULL;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `product_category` (`category_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD CONSTRAINT `product_inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `shipping_address`
--
ALTER TABLE `shipping_address`
  ADD CONSTRAINT `shipping_address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE SET NULL;

--
-- Constraints for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
