-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 11, 2025 at 06:43 AM
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
-- Database: `bigshop`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(2, 'siam', 'siam@mail.com', '$2y$12$mtkMUQSU3tL7lj4zWTtjzOA1gIhL/dP7ZnWnZ9WB5DQmql0mMbaEq', NULL, NULL, NULL),
(3, 'Alif', 'admin@mail.com', '$2y$12$EFC.Wc9rB0StlWCDKHU61.bAoMmZaun6v.S48z9svvR2F3bZHM2Mq', NULL, '2024-12-22 09:00:59', '2024-12-22 09:00:59'),
(4, 'rifat', 'rifat@mail.com', '$2y$12$1mwmRcR/u3h7gDn8/Ox1H.mp2KiMf3qWB0c/Igs4qdhOdGImtylOS', NULL, '2025-02-19 18:10:43', '2025-02-19 18:10:43');

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

CREATE TABLE `attributes` (
  `attribute_row_id` int(10) UNSIGNED NOT NULL,
  `attribute_name` varchar(255) NOT NULL,
  `attribute_value` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attributes`
--

INSERT INTO `attributes` (`attribute_row_id`, `attribute_name`, `attribute_value`, `created_by`, `created_at`, `updated_at`) VALUES
(3, 'Size', '[\"medium\",\"large\",\"extra large\"]', 2, '2024-12-20 15:52:02', '2024-12-20 15:52:02'),
(4, 'Color', '[\"blue\",\"brown\",\"maroon\"]', 2, '2024-12-20 15:52:26', '2024-12-20 15:52:26'),
(8, 'Gender', '[\"Male\",\"Female\"]', 3, '2025-02-21 16:25:44', '2025-02-21 16:25:44');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('spatie.permission.cache', 'a:3:{s:5:\"alias\";a:4:{s:1:\"a\";s:2:\"id\";s:1:\"b\";s:4:\"name\";s:1:\"c\";s:10:\"guard_name\";s:1:\"r\";s:5:\"roles\";}s:11:\"permissions\";a:4:{i:0;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:11:\"role-create\";s:1:\"c\";s:5:\"admin\";}i:1;a:4:{s:1:\"a\";i:3;s:1:\"b\";s:9:\"role-edit\";s:1:\"c\";s:5:\"admin\";s:1:\"r\";a:2:{i:0;i:1;i:1;i:2;}}i:2;a:4:{s:1:\"a\";i:4;s:1:\"b\";s:9:\"role-list\";s:1:\"c\";s:5:\"admin\";s:1:\"r\";a:1:{i:0;i:1;}}i:3;a:3:{s:1:\"a\";i:6;s:1:\"b\";s:8:\"role-add\";s:1:\"c\";s:5:\"admin\";}}s:5:\"roles\";a:2:{i:0;a:3:{s:1:\"a\";i:1;s:1:\"b\";s:11:\"super-admin\";s:1:\"c\";s:5:\"admin\";}i:1;a:3:{s:1:\"a\";i:2;s:1:\"b\";s:5:\"admin\";s:1:\"c\";s:5:\"admin\";}}}', 1740263341);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_row_id` int(10) UNSIGNED NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `category_slug` varchar(255) DEFAULT NULL,
  `category_image` varchar(255) NOT NULL,
  `category_description` varchar(255) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `has_child` int(11) DEFAULT NULL,
  `is_featured` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `count_product` int(11) DEFAULT NULL,
  `category_sort_order` int(11) DEFAULT NULL,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_row_id`, `category_name`, `category_slug`, `category_image`, `category_description`, `parent_id`, `has_child`, `is_featured`, `level`, `count_product`, `category_sort_order`, `meta_key`, `meta_description`, `created_at`, `updated_at`) VALUES
(1, 'Men', NULL, '1738788208_3evtox7uc4tuki7hkg7enxy8ojd5a2p3072xapn8tqgjprwo.png.jpg', 'Mens Good Looks', 0, 1, 0, 0, NULL, NULL, NULL, NULL, '2024-12-20 15:49:29', '2025-02-05 14:43:28'),
(2, 'Men Shirt', NULL, '1740171286_t4VP4gnzN0hzv70veMOOLaTyoTYLxI79kFw0xxqT.jpg', 'Basic Tshirt Good wear', 1, 1, 1, 1, NULL, NULL, NULL, NULL, '2024-12-20 15:50:39', '2025-02-21 14:54:47'),
(4, 'Woman\'s  Wear', NULL, '1738788105_WOT-012-NAVYBLUE-WEB-01.webp', 'Good LOOKS', 0, 1, 0, 0, NULL, NULL, NULL, NULL, '2025-01-09 11:06:59', '2025-02-05 14:41:47'),
(5, 'Woman\'s Coat', NULL, '1738788309_0de1dee0-b0f2-40bd-b1b7-c03774e53b5f.8c328493109c36723e05d2983b9f6de3.webp', 'Very good looking', 4, NULL, 0, 1, NULL, NULL, NULL, NULL, '2025-02-05 14:45:10', '2025-02-05 14:45:10'),
(9, 'Electrical Product', NULL, '1740077680_How_to_dispose_of_small_electrical_appliance_BLOG_feature_image_1112x.webp', 'Very Good electric Products', 0, 1, 0, 0, NULL, NULL, NULL, NULL, '2025-02-20 12:54:46', '2025-02-20 12:58:37'),
(11, 'Jeans', NULL, '1740170065_0547350_mens-slim-fit-stretchable-denim-jeans-pant-deep-blue.webp', 'Very nice Jeans', 1, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-02-21 14:34:25', '2025-02-21 14:34:25'),
(12, 'Saree', NULL, '1740170180_sita-dark-maroon-semi-silk-saree-sarees-110.webp', 'Very Nice Saree', 4, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-02-21 14:36:20', '2025-02-21 14:36:20'),
(14, 'Blender', NULL, '1740176007_images (3).jpg', 'test', 9, NULL, 0, 1, NULL, NULL, NULL, NULL, '2025-02-21 16:13:34', '2025-02-21 16:13:34'),
(16, 'Swaet Shirt', NULL, '1740176708_65a3f23db86af-square.jpg', 'Very Nice Shirt', 1, NULL, 0, 1, NULL, NULL, NULL, NULL, '2025-02-21 16:25:08', '2025-02-21 16:25:08');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_08_23_223750_create_admins_table', 1),
(5, '2024_09_05_204719_create_categories_table', 1),
(6, '2024_09_25_220320_create_attributes_table', 1),
(7, '2024_10_28_193206_create_products_table', 1),
(8, '2024_10_28_194014_create_product_inventory_table', 1),
(9, '2024_10_28_195059_create_product_attributes_table', 1),
(10, '2024_10_28_195246_create_product_images_table', 1),
(11, '2024_10_28_202927_create_product_discounts_table', 1),
(12, '2024_12_22_034100_create_permission_tables', 2),
(13, '2025_02_18_191316_create_orders_table', 3),
(14, '2025_02_18_191347_create_order_product_table', 3);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\Admin', 3),
(3, 'App\\Models\\Admin', 4);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_number` varchar(255) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','processing','completed','cancelled') NOT NULL,
  `description` text DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `payment_gateway` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `total_amount`, `status`, `description`, `user_id`, `payment_gateway`, `transaction_id`, `created_at`, `updated_at`) VALUES
(1, 'ORD-25021808391997', 1600.00, 'completed', '', 3, 'cash on delivery', NULL, '2025-02-18 14:39:25', '2025-02-20 10:59:11'),
(3, 'ORD-25021811169144', 1600.00, 'processing', '', 5, 'cash on delivery', NULL, '2025-02-18 17:16:04', '2025-02-20 10:51:42'),
(4, 'ORD-25021907557420', 800.00, 'processing', '', 6, 'cash on delivery', NULL, '2025-02-19 13:55:23', '2025-02-20 12:40:46'),
(5, 'ORD-25021908053312', 800.00, 'completed', '', 11, 'cash on delivery', NULL, '2025-02-19 14:05:40', '2025-02-20 14:00:32'),
(6, 'ORD-25021908179012', 800.00, 'processing', '', 12, 'cash on delivery', NULL, '2025-02-19 14:17:13', '2025-02-21 14:28:39'),
(7, 'ORD-25021908337296', 800.00, 'completed', '', 13, 'VISA-Dutch Bangla', '67b64033b25c6', '2025-02-19 14:33:55', '2025-02-21 14:29:10'),
(8, 'ORD-25021908522009', 2400.00, 'processing', '', 14, 'VISA-Dutch Bangla', '67b6449888887', '2025-02-19 14:52:40', '2025-02-21 14:29:21'),
(9, 'ORD-25022008427379', 2400.00, 'completed', '', 15, 'cash on delivery', NULL, '2025-02-20 14:42:40', '2025-02-21 16:05:14'),
(10, 'ORD-25022008447807', 2400.00, 'completed', '', 16, 'cash on delivery', NULL, '2025-02-20 14:44:52', '2025-02-21 15:58:52'),
(11, 'ORD-25022008507018', 2400.00, 'pending', '', 19, 'cash on delivery', NULL, '2025-02-20 14:50:15', '2025-02-20 14:50:15'),
(12, 'ORD-25022009029160', 2400.00, 'pending', '', 20, 'MASTER-Dutch Bangla', '67b79874a79f7', '2025-02-20 15:02:44', '2025-02-20 15:02:44'),
(13, 'ORD-25022107467018', 2400.00, 'processing', '', 21, 'VISA-Dutch Bangla', '67b8d81e8457c', '2025-02-21 13:46:38', '2025-02-21 16:23:55'),
(14, 'ORD-25022108133394', 6000.00, 'processing', '', 22, 'VISA-Dutch Bangla', '67b8de83db96e', '2025-02-21 14:13:55', '2025-02-21 16:16:37'),
(16, 'ORD-25022110493626', 2400.00, 'pending', '', 32, 'VISA-Dutch Bangla', '67b902fd9632b', '2025-02-21 16:49:33', '2025-02-21 16:49:33');

-- --------------------------------------------------------

--
-- Table structure for table `order_product`
--

CREATE TABLE `order_product` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_product`
--

INSERT INTO `order_product` (`id`, `order_id`, `product_id`, `quantity`, `price`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 2, 1600.00, '2025-02-18 14:39:25', '2025-02-18 14:39:25'),
(3, 3, 4, 2, 1600.00, '2025-02-18 17:16:04', '2025-02-18 17:16:04'),
(4, 4, 4, 1, 800.00, '2025-02-19 13:55:23', '2025-02-19 13:55:23'),
(5, 5, 4, 1, 800.00, '2025-02-19 14:05:40', '2025-02-19 14:05:40'),
(6, 6, 4, 1, 800.00, '2025-02-19 14:17:13', '2025-02-19 14:17:13'),
(7, 7, 4, 1, 800.00, '2025-02-19 14:33:55', '2025-02-19 14:33:55'),
(8, 8, 4, 3, 2400.00, '2025-02-19 14:52:40', '2025-02-19 14:52:40'),
(9, 9, 4, 3, 2400.00, '2025-02-20 14:42:40', '2025-02-20 14:42:40'),
(10, 10, 4, 3, 2400.00, '2025-02-20 14:44:52', '2025-02-20 14:44:52'),
(11, 11, 4, 3, 2400.00, '2025-02-20 14:50:15', '2025-02-20 14:50:15'),
(12, 12, 4, 3, 2400.00, '2025-02-20 15:02:44', '2025-02-20 15:02:44'),
(13, 13, 4, 3, 2400.00, '2025-02-21 13:46:38', '2025-02-21 13:46:38'),
(14, 14, 1, 3, 6000.00, '2025-02-21 14:13:55', '2025-02-21 14:13:55'),
(16, 16, 12, 4, 2400.00, '2025-02-21 16:49:33', '2025-02-21 16:49:33');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(2, 'role-create', 'admin', NULL, NULL),
(3, 'role-edit', 'admin', NULL, NULL),
(4, 'role-list', 'admin', '2025-02-19 17:18:09', '2025-02-19 17:18:09'),
(6, 'role-add', 'admin', '2025-02-21 16:28:53', '2025-02-21 16:28:53');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `product_title` varchar(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `short_description` varchar(255) DEFAULT NULL,
  `long_description` text DEFAULT NULL,
  `product_model` varchar(255) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `product_tags` text DEFAULT NULL,
  `product_sku` varchar(255) NOT NULL,
  `product_price` double NOT NULL,
  `product_unit` int(11) DEFAULT NULL,
  `is_featured` tinyint(4) DEFAULT NULL,
  `top_selling` tinyint(4) DEFAULT NULL,
  `is_refundable` tinyint(4) DEFAULT NULL,
  `active_status` tinyint(4) NOT NULL DEFAULT 1,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_title`, `category_id`, `short_description`, `long_description`, `product_model`, `brand_id`, `product_tags`, `product_sku`, `product_price`, `product_unit`, `is_featured`, `top_selling`, `is_refundable`, `active_status`, `created_by`, `created_at`, `updated_at`) VALUES
(6, 'Cargo jeans', 11, 'Very nice Jeans', 'Very nice Jeans', 'jjjj', 1, 'ghgt', 'PR-10111', 600, 3, 1, 0, 0, 1, 3, '2025-02-21 14:40:57', '2025-02-21 14:40:57'),
(7, 'Polo Shirt', 2, 'Very nice', 'Very nice&nbsp;', 'jjjj', 1, 'ghgt', 'PR-107', 400, 3, 1, 0, 0, 1, 3, '2025-02-21 14:43:11', '2025-02-21 14:43:11'),
(8, 'Jamdani Saree', 12, 'Very nice', 'Very nice', 'jjjj', 1, 'ghgt', 'PR-107', 2000, 3, 1, 0, 0, 1, 3, '2025-02-21 14:51:30', '2025-02-21 15:05:09'),
(9, 'Full sleeve Shirt', 2, 'Full sleeve Shirt', 'Full sleeve Shirt', 'jjjj', 1, 'ghgt', 'PR-107', 1000, 3, 1, 0, 0, 1, 3, '2025-02-21 15:01:15', '2025-02-21 15:01:15'),
(11, 'Cotton Saree', 12, 'Very nice', 'Very nice&nbsp;', 'jjjj', 2, 'ghgt', 'PR-107', 2000, 3, 1, 0, 0, 1, 3, '2025-02-21 15:22:42', '2025-02-21 15:22:42'),
(12, 'Sweat Shirt', 16, 'Very Nice', 'Very Nice', 'jjjj', 1, 'ghgt', 'PR-10111', 600, 3, 1, 0, 0, 1, 3, '2025-02-21 16:27:28', '2025-02-21 16:27:28');

-- --------------------------------------------------------

--
-- Table structure for table `product_attributes`
--

CREATE TABLE `product_attributes` (
  `product_attr_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `attribute_title` varchar(255) NOT NULL,
  `attribute_price` double NOT NULL,
  `attribute_quantity` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_attributes`
--

INSERT INTO `product_attributes` (`product_attr_id`, `product_id`, `attribute_title`, `attribute_price`, `attribute_quantity`, `created_at`, `updated_at`) VALUES
(30, 6, 'medium + blue', 600, 23, '2025-02-21 14:40:57', '2025-02-21 14:40:57'),
(31, 6, 'medium + brown', 600, 7, '2025-02-21 14:40:57', '2025-02-21 14:40:57'),
(32, 7, 'large + maroon', 400, 11, '2025-02-21 14:43:11', '2025-02-21 14:43:11'),
(35, 9, 'large + maroon', 1000, 11, '2025-02-21 15:01:16', '2025-02-21 15:01:16'),
(36, 8, 'medium + maroon', 6000, 9, '2025-02-21 15:05:10', '2025-02-21 15:05:10'),
(37, 10, 'brown', 4000, 4, '2025-02-21 15:09:13', '2025-02-21 15:09:13'),
(38, 10, 'maroon', 4000, 4, '2025-02-21 15:09:13', '2025-02-21 15:09:13'),
(39, 11, 'extra large + brown', 2000, 10, '2025-02-21 15:22:42', '2025-02-21 15:22:42'),
(40, 11, 'extra large + blue', 2000, 10, '2025-02-21 15:22:42', '2025-02-21 15:22:42'),
(41, 12, 'medium + brown', 600, 10, '2025-02-21 16:27:29', '2025-02-21 16:27:29'),
(42, 12, 'medium + maroon', 600, 10, '2025-02-21 16:27:29', '2025-02-21 16:27:29');

-- --------------------------------------------------------

--
-- Table structure for table `product_discounts`
--

CREATE TABLE `product_discounts` (
  `discount_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `discount_price` double NOT NULL,
  `discount_type` tinyint(4) NOT NULL,
  `started_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `image_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `feature_image` varchar(255) NOT NULL,
  `gallery_images` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`image_id`, `product_id`, `feature_image`, `gallery_images`, `created_at`, `updated_at`) VALUES
(6, 6, '1740170457_0547350_mens-slim-fit-stretchable-denim-jeans-pant-deep-blue.webp', '[\"1740170457_651830ea2edad-square.png\"]', '2025-02-21 14:40:57', '2025-02-21 14:40:57'),
(7, 7, '1740170591_4f64a3f58350b2f1aef402f10804a309.jpg_720x720q80.jpg', '[\"1740170591_4f64a3f58350b2f1aef402f10804a309.jpg_720x720q80.jpg\"]', '2025-02-21 14:43:11', '2025-02-21 14:43:11'),
(8, 8, '1740171909_sita-dark-maroon-semi-silk-saree-sarees-110.webp', '[\"1740171910_sita-maroon-semi-silk-saree-sarees-786.webp\"]', '2025-02-21 14:51:31', '2025-02-21 15:05:10'),
(9, 9, '1740171675_CSSL201-1297.jpg', '[\"1740171676_m-w3173410420x-wrangler-20x-original-imaf8ahzk3vhhhny.webp\"]', '2025-02-21 15:01:16', '2025-02-21 15:01:16'),
(10, 10, '1740172152_images (3).jpg', '[\"1740172153_images (2).jpg\"]', '2025-02-21 15:09:13', '2025-02-21 15:09:13'),
(11, 11, '1740172962_f662c6de73e8cf03b7a21c41a76437bc.jpg_720x720q80.jpg', '[\"1740172962_TES223_1_1800x1800.webp\"]', '2025-02-21 15:22:42', '2025-02-21 15:22:42'),
(12, 12, '1740176848_images (5).jpg', '[\"1740176849_TGYHNFULSWEAT-PLAINST1601_3783ee97-957d-4f87-8edd-b72d6e98c975_600x.webp\"]', '2025-02-21 16:27:29', '2025-02-21 16:27:29');

-- --------------------------------------------------------

--
-- Table structure for table `product_inventory`
--

CREATE TABLE `product_inventory` (
  `product_stock_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(11) NOT NULL,
  `stock_amount` int(11) NOT NULL,
  `modified_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_inventory`
--

INSERT INTO `product_inventory` (`product_stock_id`, `product_id`, `stock_amount`, `modified_at`, `created_at`, `updated_at`) VALUES
(6, 6, 30, NULL, '2025-02-21 14:40:57', '2025-02-21 14:40:57'),
(7, 7, 11, NULL, '2025-02-21 14:43:11', '2025-02-21 14:43:11'),
(8, 8, 9, NULL, '2025-02-21 14:51:31', '2025-02-21 15:05:10'),
(9, 9, 11, NULL, '2025-02-21 15:01:16', '2025-02-21 15:01:16'),
(10, 10, 8, NULL, '2025-02-21 15:09:13', '2025-02-21 15:09:13'),
(11, 11, 20, NULL, '2025-02-21 15:22:42', '2025-02-21 15:22:42'),
(12, 12, 20, NULL, '2025-02-21 16:27:29', '2025-02-21 16:27:29');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'super-admin', 'admin', NULL, NULL),
(2, 'admin', 'admin', NULL, NULL),
(3, 'manager', 'admin', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(3, 1),
(3, 2),
(4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('Sa6EUM6BhngLcBDb4acyqcbrZkS65EI85Ueu3sYW', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiSGVuYWxBVXRBNTJyNzZsOFg4Z0R2TzRlZHVmYmtJSjlkdXVETjVJQiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjU6ImFsZXJ0IjthOjA6e31zOjUyOiJsb2dpbl9hZG1pbl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjM7fQ==', 1740178417),
('UwdoWSrlkGBgYx71eERq5USbmf0vXfQbdaMWzBux', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiUHBjeWRtNktnSDBQZHhjWkRZQjYza3BmNTlkY3FFMGN1NjdBTk5tViI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mzc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9kYXNoYm9hcmQiO31zOjUyOiJsb2dpbl9hZG1pbl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjM7czo1OiJhbGVydCI7YTowOnt9fQ==', 1740174295);

-- --------------------------------------------------------

--
-- Table structure for table `table_information`
--

CREATE TABLE `table_information` (
  `id` int(11) NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `table_details` text NOT NULL,
  `guide` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_information`
--

INSERT INTO `table_information` (`id`, `table_name`, `table_details`, `guide`) VALUES
(1, 'admins', ' The admins table stores administrator account information. It has id as a bigint(20) unsigned auto-increment primary key, along with name, email (unique), password, and remember_token. The created_at and updated_at columns store timestamps for when the admin record was created and last updated. This table is used for managing system administrators and is referenced in other tables, such as attributes.created_by and products.created_by', 'Join admins.id with attributes.created_by or products.created_by to identify which admin created the attribute or product.'),
(2, 'attributes', 'The attributes table defines product attributes such as size, color, or gender. It has attribute_row_id as an unsigned int(10) auto-increment primary key, attribute_name as a varchar(255), and attribute_value stored as text (often in JSON format). The created_by column stores the admin ID from the admins table, and created_at and updated_at store timestamps.', 'Join attributes.attribute_row_id with related attribute mapping tables (if implemented) or use created_by to link with admins.id'),
(3, 'cache', 'The cache table stores cached application data for performance optimization. It has key as the primary key (varchar(255)), value as mediumtext, and expiration as an integer timestamp. This table is mainly used by the Laravel framework and is not typically included in business queries.', 'Not used in business joins.'),
(4, 'cache_locks', 'The categories table organizes products into hierarchical categories. It has category_row_id as an unsigned int(10) auto-increment primary key, category_name as a varchar(255), and optional fields for category_slug, category_image, and category_description. The parent_id column supports nested categories, while is_featured, has_child, and level help in organizing and displaying categories.', 'Join categories.category_row_id with products.category_id to get products under a specific category.'),
(5, 'failed_jobs', 'The failed_jobs table stores records of failed background jobs. It has id as a bigint(20) unsigned auto-increment primary key, uuid (unique), connection, queue, payload, exception, and a failed_at timestamp.', ' Not used in business joins.'),
(6, 'jobs', 'The jobs table stores queued jobs for Laravel’s background processing system. It has id as a bigint(20) unsigned auto-increment primary key, queue as a varchar(255), payload and attempts, along with timestamps for job availability and creation.', 'Not used in business joins.'),
(7, 'job_batches', 'The job_batches table stores metadata for batches of queued jobs. It has id as the primary key (varchar(255)), name, total_jobs, pending_jobs, failed_jobs, and timestamps for creation and completion.', 'Not used in business joins.'),
(8, 'migrations', 'The migrations table tracks executed Laravel migration files. It has id as an unsigned int(10) auto-increment primary key, migration as the filename, and batch as an integer grouping number.', 'Not used in business joins.'),
(9, 'model_has_permissions', 'The model_has_permissions table assigns permissions to models (admins or users). It has a composite primary key (permission_id, model_id, model_type) and a foreign key permission_id referencing permissions.id.', 'Join model_has_permissions.permission_id with permissions.id to get permission details, and use model_id with the appropriate user or admin table based on model_type.'),
(10, 'model_has_roles', 'The model_has_roles table assigns roles to models. It has a composite primary key (role_id, model_id, model_type) and a foreign key role_id referencing roles.id.', 'Join model_has_roles.role_id with roles.id to get role details, and use model_id with the appropriate user or admin table based on model_type.'),
(11, 'orders', 'The orders table stores customer order information. It has id as a bigint(20) unsigned auto-increment primary key, order_number (unique), total_amount as a decimal, status (enum: pending, processing, completed, cancelled), and user_id as a foreign key to users.id. Additional fields include description, payment_gateway, and transaction_id.', 'Join orders.id with order_product.order_id to get product details for each order, and join orders.user_id with users.id to get customer information.'),
(12, 'order_product', 'The order_product table connects orders to products in a many-to-many relationship. It has id as a primary key, order_id referencing orders.id, and product_id referencing products.product_id. It also includes quantity, price, and timestamps.', 'Join order_product.product_id with products.product_id to get product details, and join order_product.order_id with orders.id to get order information.'),
(13, 'password_reset_tokens', 'The password_reset_tokens table stores password reset requests. It has email as the primary key, token for password reset authentication, and created_at as a timestamp.', 'Not used in business joins.'),
(14, 'permissions', 'The permissions table stores system permissions. It has id as a bigint(20) unsigned auto-increment primary key, name for the permission, guard_name, and timestamps.', 'Join permissions.id with role_has_permissions.permission_id or model_has_permissions.permission_id to see which roles or models have this permission.'),
(15, 'products', ' The products table contains the main product catalog. It has product_id as an unsigned int(10) auto-increment primary key, product_title, category_id (linking to categories.category_row_id), short_description, long_description, product_model, brand_id, product_tags, product_sku, and product_price. Additional fields track product_unit, is_featured, top_selling, is_refundable, active_status, and created_by (admin).', 'Join products.product_id with product_inventory.product_id, product_images.product_id, product_attributes.product_id, order_product.product_id, or product_discounts.product_id depending on the query.'),
(16, 'product_attributes', ' The product_attributes table stores specific product variations, such as size and color combinations. It has product_attr_id as the primary key, product_id referencing products.product_id, attribute_title, attribute_price, and attribute_quantity.', 'Join product_attributes.product_id with products.product_id to get the base product details.'),
(17, 'product_discounts', 'The product_discounts table stores discount details for products. It has discount_id as the primary key, product_id referencing products.product_id, discount_price, discount_type, started_at, and ends_at.', 'Join product_discounts.product_id with products.product_id to get discount details for a product.'),
(18, 'product_images', 'The product_images table stores images for products. It has image_id as the primary key, product_id referencing products.product_id, feature_image, and gallery_images.', 'Join product_images.product_id with products.product_id to retrieve images for a given product.'),
(19, 'product_inventory', 'The product_inventory table tracks available stock for each product. It has product_stock_id as the primary key, product_id referencing products.product_id, stock_amount, and timestamps.', 'Join product_inventory.product_id with products.product_id to find stock levels for specific products.'),
(20, 'roles', 'The roles table stores system roles. It has id as a bigint(20) unsigned auto-increment primary key, name, guard_name, and timestamps. The combination of name and guard_name is unique.', 'Join roles.id with model_has_roles.role_id or role_has_permissions.role_id to find related models or permissions.'),
(21, 'role_has_permissions', 'The role_has_permissions table connects roles to permissions. It has a composite primary key (permission_id, role_id) and foreign keys referencing permissions.id and roles.id.', 'Join role_has_permissions.role_id with roles.id and role_has_permissions.permission_id with permissions.id.'),
(22, 'sessions', 'The sessions table stores active user sessions. It has id as the primary key, user_id referencing users.id, ip_address, user_agent, payload, and last_activity timestamp.', 'Join sessions.user_id with users.id to identify which user owns a session.'),
(23, 'table_information', 'The table_information table stores descriptive text about other tables. It has id as the primary key, table_name, and table_details as text.', 'Not typically joined with business data but can be queried to retrieve schema descriptions.'),
(24, 'users', 'The users table stores customer account information. It has id as a bigint(20) unsigned auto-increment primary key, name, email (unique), email_verified_at, password, and remember_token. The created_at and updated_at columns store timestamps. ', 'Join users.id with orders.user_id to get the orders placed by a user.');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(3, 'afs gjh', 'hkljl', NULL, '$2y$12$VuueOvCfXcgc9zsdVBB8SulhRzZIXQ1dAwGiNXJIPbGZgwgReybZ2', NULL, '2025-02-18 14:39:25', '2025-02-18 14:39:25'),
(5, 'fkedv htjergr', 'fhetegwg', NULL, '$2y$12$vSNiymzts9.cUCec2Wc.9uN6zYQmTJc9/C4lsuWoFx/NKq36WqJVq', NULL, '2025-02-18 17:16:04', '2025-02-18 17:16:04'),
(6, 'rhtjy jukt', 'jtjtjt', NULL, '$2y$12$/EKaEYFY72kQanAmW2wZzO4KaCEO1xkhGfC1NTazRLYTD8hZevqji', NULL, '2025-02-19 13:55:23', '2025-02-19 13:55:23'),
(11, 'Romaa jukt', 'alif@gg', NULL, '$2y$12$yTS/OSAaBxj/UfJFHBTfjeN9KxlnK2E3Fdyld7v8.P7gSUgxPHwMS', NULL, '2025-02-19 14:05:40', '2025-02-19 14:05:40'),
(12, 'chandu1 chandu1', 'chandu1', NULL, '$2y$12$pETAjuRm80n7DrOdeYWvvO2TLvVqczRMLtTzYIZaWs53wQBIMfABO', NULL, '2025-02-19 14:17:13', '2025-02-19 14:17:13'),
(13, 'NIna NIna', 'NIna', NULL, '$2y$12$8UHPKaTRLP/lHDwkaX3iLeLWkwR8LzjJHxJtHSI.uTcUBw9Vh04Qq', NULL, '2025-02-19 14:33:55', '2025-02-19 14:33:55'),
(14, 'Final Final', 'Final', NULL, '$2y$12$WkEYWLb8QzzMymJsfIsLT.XucbvMIULAU1wem84EUb2hSDnjj0DN6', NULL, '2025-02-19 14:52:40', '2025-02-19 14:52:40'),
(15, 'Md Muzadded Chowdhury', 'alif@mail.com', NULL, '$2y$12$S3BhTCknplDtxu4UnQCS7OR/YNl4UFSR5vvvDivBUV3VJ9pYh3GBG', NULL, '2025-02-20 14:42:40', '2025-02-20 14:42:40'),
(16, 'Muzadded Chowdhury', 'alifmuzz@mail.com', NULL, '$2y$12$1VWmirYbX43qanzXpwYxXun3vcOue/a2k9bzCcANjTqNbhD31VFTm', NULL, '2025-02-20 14:44:52', '2025-02-20 14:44:52'),
(19, 'Muzaddeddgbg Chowdhury', 'alifmuzz@mail.comfhh', NULL, '$2y$12$SZDq9iMXRt3WIe40l3WQe.98Z3vgkfRSonAWdgBFC.SN1biiw/2Yq', NULL, '2025-02-20 14:50:15', '2025-02-20 14:50:15'),
(20, 'gjj stj', 'stuj', NULL, '$2y$12$WkJezdhKq87UuEXD2FRtE.diDc6s2DUJ.XwS8vg09hiC8NWmBD/GC', NULL, '2025-02-20 15:02:44', '2025-02-20 15:02:44'),
(21, 'eee eee', 'eee', NULL, '$2y$12$oWhbcbJCs7BjXV6OzI/Q6.WDcZXkWp0pCWOwDtvu1eGzfar6UW5sa', NULL, '2025-02-21 13:46:38', '2025-02-21 13:46:38'),
(22, '222 22', '222', NULL, '$2y$12$7HpvrtIgG5af0eMlhIdCM.51/6J/HggWHzA/ez/TtvZ1iJjrumMBe', NULL, '2025-02-21 14:13:55', '2025-02-21 14:13:55'),
(31, 'Md Muzadded Chowdhury', 'aligdf@mail.com', NULL, '$2y$12$8zG9QCabz4MOSj/WNtH7DO5qAi6JI5tQvFkhkw1byOKs0WJsFO5jK', NULL, '2025-02-21 16:33:23', '2025-02-21 16:33:23'),
(32, 'Siam Ahmed', 'siam@mail.com', NULL, '$2y$12$JzS9pNMBF/GZjBBZLb7LwOzvNXVzbEDonp0IuksyFAGVPX4xPpIRq', NULL, '2025-02-21 16:49:33', '2025-02-21 16:49:33');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_email_unique` (`email`);

--
-- Indexes for table `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`attribute_row_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_row_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_product`
--
ALTER TABLE `order_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_product_order_id_foreign` (`order_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `product_attributes`
--
ALTER TABLE `product_attributes`
  ADD PRIMARY KEY (`product_attr_id`);

--
-- Indexes for table `product_discounts`
--
ALTER TABLE `product_discounts`
  ADD PRIMARY KEY (`discount_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`image_id`);

--
-- Indexes for table `product_inventory`
--
ALTER TABLE `product_inventory`
  ADD PRIMARY KEY (`product_stock_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `table_information`
--
ALTER TABLE `table_information`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `attributes`
--
ALTER TABLE `attributes`
  MODIFY `attribute_row_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_row_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `order_product`
--
ALTER TABLE `order_product`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_attributes`
--
ALTER TABLE `product_attributes`
  MODIFY `product_attr_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `product_discounts`
--
ALTER TABLE `product_discounts`
  MODIFY `discount_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `image_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_inventory`
--
ALTER TABLE `product_inventory`
  MODIFY `product_stock_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `table_information`
--
ALTER TABLE `table_information`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `order_product_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
