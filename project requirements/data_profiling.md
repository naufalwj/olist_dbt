# Olist E-Commerce — Data Profiling Report

> **Dataset:** Brazilian E-Commerce Public Dataset by Olist  
> **Tables:** 9  
> **Profiling scope:** column definitions, data types, null counts, distinct counts, descriptive statistics, PK/FK relationships

---

## Table of Contents

1. [Schema Overview & Relationships](#1-schema-overview--relationships)
2. [olist_customers_dataset_dataset](#2-olist_customers_dataset_dataset)
3. [olist_orders_dataset_dataset](#3-olist_orders_dataset_dataset)
4. [olist_order_items_dataset_dataset](#4-olist_order_items_dataset_dataset)
5. [olist_order_payments_dataset_dataset](#5-olist_order_payments_dataset_dataset)
6. [olist_order_reviews_dataset](#6-olist_order_reviews_dataset)
7. [olist_products_dataset](#7-olist_products_dataset)
8. [olist_sellers_dataset](#8-olist_sellers_dataset)
9. [olist_geolocation_dataset](#9-olist_geolocation_dataset)
10. [product_category_name_translation](#10-product_category_name_translation)

---

## 1. Schema Overview & Relationships

### Entity Relationship Diagram (text)

```
product_category_name_translation
  └── product_category_name (PK)
            │
            ▼
      olist_products_dataset
        └── product_id (PK)
                  │
                  ▼
          olist_order_items_dataset_dataset ◄──── olist_sellers_dataset
            ├── order_id (FK)                └── seller_id (PK)
            ├── product_id (FK)
            └── seller_id (FK)
                  │
              order_id
                  │
          ┌───────┼────────────────────┐
          ▼       ▼                    ▼
  olist_orders_dataset_dataset     olist_order_payments_dataset_dataset
    ├── order_id (PK)         └── order_id (FK)
    └── customer_id (FK)
          │                   olist_order_reviews_dataset
          ▼                     └── order_id (FK)
  olist_customers_dataset_dataset
    └── customer_id (PK)
          │
    customer_zip_code_prefix (soft ref)
          │
          ▼
  olist_geolocation_dataset
    └── geolocation_zip_code_prefix
```

### Key Relationships Summary

| FK Table | FK Column | PK Table | PK Column | Relationship |
|---|---|---|---|---|
| `olist_orders_dataset` | `customer_id` | `olist_customers_dataset` | `customer_id` | Many-to-One |
| `olist_order_items_dataset` | `order_id` | `olist_orders_dataset` | `order_id` | Many-to-One |
| `olist_order_items_dataset` | `product_id` | `olist_products_dataset` | `product_id` | Many-to-One |
| `olist_order_items_dataset` | `seller_id` | `olist_sellers_dataset` | `seller_id` | Many-to-One |
| `olist_order_payments_dataset` | `order_id` | `olist_orders_dataset` | `order_id` | Many-to-One |
| `olist_order_reviews_dataset` | `order_id` | `olist_orders_dataset` | `order_id` | Many-to-One |
| `olist_products_dataset` | `product_category_name` | `product_category_name_translation` | `product_category_name` | Many-to-One |
| `olist_customers_dataset` | `customer_zip_code_prefix` | `olist_geolocation_dataset` | `geolocation_zip_code_prefix` | Soft ref (no FK constraint) |
| `olist_sellers_dataset` | `seller_zip_code_prefix` | `olist_geolocation_dataset` | `geolocation_zip_code_prefix` | Soft ref (no FK constraint) |

---

## 2. olist_customers_dataset_dataset

**Rows:** 99,441 | **Columns:** 5

### 2.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `customer_id` | STRING | **PK** | Unique key per order — links to `olist_orders_dataset.customer_id` |
| `customer_unique_id` | STRING | — | True unique customer identifier (one person can have multiple `customer_id`s) |
| `customer_zip_code_prefix` | INT64 | Soft FK | 5-digit zip prefix; links to `olist_geolocation_dataset.geolocation_zip_code_prefix` |
| `customer_city` | STRING | — | Customer's city name |
| `customer_state` | STRING | — | 2-letter Brazilian state abbreviation |

### 2.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `customer_id` | 0 | 0.00% | 99,441 |
| `customer_unique_id` | 0 | 0.00% | 96,096 |
| `customer_zip_code_prefix` | 0 | 0.00% | 14,994 |
| `customer_city` | 0 | 0.00% | 4,119 |
| `customer_state` | 0 | 0.00% | 27 |

> **Note:** `customer_id` has 99,441 distinct values (all unique) but `customer_unique_id` has only 96,096 — meaning ~3,345 customers placed more than one order under different `customer_id` values.

### 2.3 Statistical Profile

**Numeric columns:**

| Stat | `customer_zip_code_prefix` |
|---|---|
| Min | 1,003 |
| Max | 99,990 |
| Mean | 35,137.47 |
| Median | 24,416 |
| Std Dev | 29,797.94 |
| Mode | 22,790 |

**Categorical columns:**

| Column | Mode | Top 3 Values |
|---|---|---|
| `customer_city` | `sao paulo` | sao paulo, rio de janeiro, belo horizonte |
| `customer_state` | `SP` | SP, RJ, MG |

---

## 3. olist_orders_dataset_dataset

**Rows:** 99,441 | **Columns:** 8

### 3.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `order_id` | STRING | **PK** | Unique order identifier |
| `customer_id` | STRING | **FK** | Links to `olist_customers_dataset.customer_id` |
| `order_status` | STRING | — | Order lifecycle status (8 possible values) |
| `order_purchase_timestamp` | TIMESTAMP | — | When customer placed the order |
| `order_approved_at` | TIMESTAMP | — | When payment was approved |
| `order_delivered_carrier_date` | TIMESTAMP | — | When order was handed to the carrier |
| `order_delivered_customer_date` | TIMESTAMP | — | When customer received the order |
| `order_estimated_delivery_date` | TIMESTAMP | — | Estimated delivery date shown to customer at purchase |

### 3.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `order_id` | 0 | 0.00% | 99,441 |
| `customer_id` | 0 | 0.00% | 99,441 |
| `order_status` | 0 | 0.00% | 8 |
| `order_purchase_timestamp` | 0 | 0.00% | 98,875 |
| `order_approved_at` | 160 | **0.16%** | 90,733 |
| `order_delivered_carrier_date` | 1,783 | **1.79%** | 81,018 |
| `order_delivered_customer_date` | 2,965 | **2.98%** | 95,664 |
| `order_estimated_delivery_date` | 0 | 0.00% | 459 |

> **Note:** Nulls in delivery columns are expected — they correspond to orders that are `shipped`, `canceled`, `invoiced`, or `processing` status and have not yet reached those lifecycle stages.

### 3.3 Statistical Profile

**Categorical columns:**

| Column | Mode | Top 3 Values |
|---|---|---|
| `order_status` | `delivered` | delivered, shipped, canceled |
| `order_purchase_timestamp` | `2017-11-20 10:59:08` | (high-volume event days) |
| `order_estimated_delivery_date` | `2017-12-20 00:00:00` | 459 distinct estimated dates |

---

## 4. olist_order_items_dataset_dataset

**Rows:** 112,650 | **Columns:** 7

### 4.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `order_id` | STRING | **FK** | Links to `olist_orders_dataset.order_id` |
| `order_item_id` | INT64 | **PK (composite)** | Sequential item number within an order (1–21) |
| `product_id` | STRING | **FK** | Links to `olist_products.product_id` |
| `seller_id` | STRING | **FK** | Links to `olist_sellers.seller_id` |
| `shipping_limit_date` | TIMESTAMP | — | Deadline for seller to hand item to carrier |
| `price` | FLOAT64 | — | Item price in BRL |
| `freight_value` | FLOAT64 | — | Shipping cost for the item in BRL |

> **Composite PK:** (`order_id`, `order_item_id`) — together they uniquely identify one line item within an order.

### 4.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `order_id` | 0 | 0.00% | 98,666 |
| `order_item_id` | 0 | 0.00% | 21 |
| `product_id` | 0 | 0.00% | 32,951 |
| `seller_id` | 0 | 0.00% | 3,095 |
| `shipping_limit_date` | 0 | 0.00% | 93,318 |
| `price` | 0 | 0.00% | 5,968 |
| `freight_value` | 0 | 0.00% | 6,999 |

> **Note:** 112,650 rows vs 98,666 distinct `order_id`s — confirms that many orders have multiple items.

### 4.3 Statistical Profile

| Stat | `order_item_id` | `price` (BRL) | `freight_value` (BRL) |
|---|---|---|---|
| Min | 1 | 0.85 | 0.00 |
| Max | 21 | 6,735.00 | 409.68 |
| Mean | 1.20 | 120.65 | 19.99 |
| Median | 1 | 74.99 | 16.26 |
| Std Dev | 0.71 | 183.63 | 15.81 |
| Mode | 1 | 59.90 | 15.10 |

> **Note:** `price` has a heavily right-skewed distribution — median (74.99) is well below mean (120.65), driven by high-value outliers. `freight_value = 0` likely represents pickup or free shipping orders.

---

## 5. olist_order_payments_dataset_dataset

**Rows:** 103,886 | **Columns:** 5

### 5.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `order_id` | STRING | **FK** | Links to `olist_orders_dataset.order_id` |
| `payment_sequential` | INT64 | **PK (composite)** | Sequential number when multiple payment methods used per order |
| `payment_type` | STRING | — | Payment method (credit_card, boleto, voucher, debit_card, not_defined) |
| `payment_installments` | INT64 | — | Number of installments chosen (0–24) |
| `payment_value` | FLOAT64 | — | Amount paid in this payment row (BRL) |

> **Composite PK:** (`order_id`, `payment_sequential`)

### 5.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `order_id` | 0 | 0.00% | 99,440 |
| `payment_sequential` | 0 | 0.00% | 29 |
| `payment_type` | 0 | 0.00% | 5 |
| `payment_installments` | 0 | 0.00% | 24 |
| `payment_value` | 0 | 0.00% | 29,077 |

> **Note:** 103,886 rows vs 99,440 distinct `order_id`s — some orders have multiple payment rows (e.g., partial payment by voucher + rest by credit card).

### 5.3 Statistical Profile

| Stat | `payment_sequential` | `payment_installments` | `payment_value` (BRL) |
|---|---|---|---|
| Min | 1 | 0 | 0.00 |
| Max | 29 | 24 | 13,664.08 |
| Mean | 1.09 | 2.85 | 154.10 |
| Median | 1 | 1 | 100.00 |
| Std Dev | 0.71 | 2.69 | 217.49 |
| Mode | 1 | 1 | 50.00 |

**Payment type distribution:**

| Column | Mode | Top 3 Values |
|---|---|---|
| `payment_type` | `credit_card` | credit_card, boleto, voucher |

> **Note:** `payment_installments = 0` might indicate voucher-only payments. The max of 24 installments reflects Brazil's common parcelamento (installment) credit culture.

---

## 6. olist_order_reviews_dataset

**Rows:** 99,224 | **Columns:** 7

### 6.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `review_id` | STRING | **PK** | Unique review identifier |
| `order_id` | STRING | **FK** | Links to `olist_orders_dataset.order_id` |
| `review_score` | INT64 | — | Rating from 1 (worst) to 5 (best) |
| `review_comment_title` | STRING | — | Optional short title of the review |
| `review_comment_message` | STRING | — | Optional longer review body |
| `review_creation_date` | TIMESTAMP | — | When the review survey was sent to the customer |
| `review_answer_timestamp` | TIMESTAMP | — | When the customer submitted the review |

### 6.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `review_id` | 0 | 0.00% | 98,410 |
| `order_id` | 0 | 0.00% | 98,673 |
| `review_score` | 0 | 0.00% | 5 |
| `review_comment_title` | 87,656 | **88.34%** | 4,527 |
| `review_comment_message` | 58,247 | **58.70%** | 36,159 |
| `review_creation_date` | 0 | 0.00% | 636 |
| `review_answer_timestamp` | 0 | 0.00% | 98,248 |

> **Note:** `review_comment_title` and `review_comment_message` are optional fields — most customers only provided a star rating. The 88% null rate on titles is expected behavior, not a data quality issue.

### 6.3 Statistical Profile

| Stat | `review_score` |
|---|---|
| Min | 1 |
| Max | 5 |
| Mean | 4.09 |
| Median | 5 |
| Std Dev | 1.35 |
| Mode | 5 |

**Categorical columns:**

| Column | Mode | Notes |
|---|---|---|
| `review_comment_title` | `Recomendo` | Portuguese for "I recommend" |
| `review_comment_message` | `Muito bom` | Portuguese for "Very good" |

> **Note:** Mean score (4.09) and mode (5) indicate a strongly positive review distribution, typical of e-commerce datasets with survivorship/response bias.

---

## 7. olist_products_dataset

**Rows:** 32,951 | **Columns:** 9

### 7.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `product_id` | STRING | **PK** | Unique product identifier |
| `product_category_name` | STRING | **FK** | Links to `product_category_name_translation.product_category_name` |
| `product_name_lenght` | FLOAT64 | — | Character count of product name (note: typo in original — "lenght") |
| `product_description_lenght` | FLOAT64 | — | Character count of product description |
| `product_photos_qty` | FLOAT64 | — | Number of product photos listed |
| `product_weight_g` | FLOAT64 | — | Product weight in grams |
| `product_length_cm` | FLOAT64 | — | Package length in cm |
| `product_height_cm` | FLOAT64 | — | Package height in cm |
| `product_width_cm` | FLOAT64 | — | Package width in cm |

### 7.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `product_id` | 0 | 0.00% | 32,951 |
| `product_category_name` | 610 | **1.85%** | 73 |
| `product_name_lenght` | 610 | **1.85%** | 66 |
| `product_description_lenght` | 610 | **1.85%** | 2,960 |
| `product_photos_qty` | 610 | **1.85%** | 19 |
| `product_weight_g` | 2 | 0.01% | 2,204 |
| `product_length_cm` | 2 | 0.01% | 99 |
| `product_height_cm` | 2 | 0.01% | 102 |
| `product_width_cm` | 2 | 0.01% | 95 |

> **Note:** The 610-row block of nulls across category + name/description/photos columns suggests a batch of products that were registered without full metadata. The 2-row null in dimensional columns is likely individual data entry errors.

### 7.3 Statistical Profile

| Stat | `product_name_lenght` | `product_description_lenght` | `product_photos_qty` | `product_weight_g` | `product_length_cm` | `product_height_cm` | `product_width_cm` |
|---|---|---|---|---|---|---|---|
| Min | 5 | 4 | 1 | 0 | 7 | 2 | 6 |
| Max | 76 | 3,992 | 20 | 40,425 | 105 | 105 | 118 |
| Mean | 48.48 | 771.50 | 2.19 | 2,276.47 | 30.82 | 16.94 | 23.20 |
| Median | 51 | 595 | 1 | 700 | 25 | 13 | 20 |
| Std Dev | 10.25 | 635.12 | 1.74 | 4,282.04 | 16.91 | 13.64 | 12.08 |
| Mode | 60 | 404 | 1 | 200 | 16 | 10 | 11 |

**Categorical columns:**

| Column | Mode | Top 3 Categories |
|---|---|---|
| `product_category_name` | `cama_mesa_banho` | cama_mesa_banho (bed/bath), esporte_lazer (sports), moveis_decoracao (furniture/decor) |

> **Note:** `product_weight_g` has a max of 40,425g (≈40kg), which could be heavy industrial items or data entry outliers. The strong right skew (median=700g vs mean=2,276g) is worth investigating.

---

## 8. olist_sellers_dataset

**Rows:** 3,095 | **Columns:** 4

### 8.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `seller_id` | STRING | **PK** | Unique seller identifier |
| `seller_zip_code_prefix` | INT64 | Soft FK | 5-digit zip prefix; links to `olist_geolocation` |
| `seller_city` | STRING | — | Seller's city name |
| `seller_state` | STRING | — | 2-letter Brazilian state abbreviation |

### 8.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `seller_id` | 0 | 0.00% | 3,095 |
| `seller_zip_code_prefix` | 0 | 0.00% | 2,246 |
| `seller_city` | 0 | 0.00% | 611 |
| `seller_state` | 0 | 0.00% | 23 |

### 8.3 Statistical Profile

| Stat | `seller_zip_code_prefix` |
|---|---|
| Min | 1,001 |
| Max | 99,730 |
| Mean | 32,291.06 |
| Median | 14,940 |
| Std Dev | 32,713.45 |
| Mode | 14,940 |

**Categorical columns:**

| Column | Mode | Top 3 Values |
|---|---|---|
| `seller_city` | `sao paulo` | sao paulo, curitiba, rio de janeiro |
| `seller_state` | `SP` | SP, PR, MG |

> **Note:** Sellers are spread across 23 of 27 Brazilian states, heavily concentrated in São Paulo (SP). 3,095 unique sellers serve 99,441 orders — sellers have high reuse across orders.

---

## 9. olist_geolocation_dataset

**Rows:** 1,000,163 | **Columns:** 5

### 9.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `geolocation_zip_code_prefix` | INT64 | **Logical PK** (non-unique) | 5-digit zip prefix — multiple lat/lng coordinates per zip |
| `geolocation_lat` | FLOAT64 | — | Latitude coordinate |
| `geolocation_lng` | FLOAT64 | — | Longitude coordinate |
| `geolocation_city` | STRING | — | City name for that zip area |
| `geolocation_state` | STRING | — | 2-letter state abbreviation |

> **Warning:** This table is **not normalized** — each zip code appears multiple times (average ~52 rows per zip). It functions as a coordinate lookup table. When joining, use `GROUP BY zip / AVG(lat, lng)` or a deduplication CTE to avoid row explosion.

### 9.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `geolocation_zip_code_prefix` | 0 | 0.00% | 19,015 |
| `geolocation_lat` | 0 | 0.00% | 717,360 |
| `geolocation_lng` | 0 | 0.00% | 717,613 |
| `geolocation_city` | 0 | 0.00% | 8,011 |
| `geolocation_state` | 0 | 0.00% | 27 |

> **Note:** 1,000,163 rows but only 19,015 distinct zip codes = average ~53 coordinate entries per zip. The 717k+ distinct lat/lng pairs confirm these are precise GPS points (not zip centroids).

### 9.3 Statistical Profile

| Stat | `geolocation_zip_code_prefix` | `geolocation_lat` | `geolocation_lng` |
|---|---|---|---|
| Min | 1,001 | -36.61 | -101.47 |
| Max | 99,990 | 45.07 | 121.11 |
| Mean | 36,574.17 | -21.18 | -46.39 |
| Median | 26,530 | -22.92 | -46.64 |
| Std Dev | 30,549.34 | 5.72 | 4.27 |
| Mode | 24,220 | -27.10 | -48.63 |

> **Data Quality Alert:** `geolocation_lat` max = 45.07° and `geolocation_lng` max = 121.11° are outside Brazil's geographic bounds (lat: -33.75° to 5.27°, lng: -73.99° to -34.79°). These rows are likely geocoding errors and should be filtered before spatial analysis.

**Categorical columns:**

| Column | Mode | Top 3 Values |
|---|---|---|
| `geolocation_city` | `sao paulo` | sao paulo, rio de janeiro, belo horizonte |
| `geolocation_state` | `SP` | SP, MG, RJ |

---

## 10. product_category_name_translation

**Rows:** 71 | **Columns:** 2

### 10.1 Column Definitions

| Column | Data Type | Role | Description |
|---|---|---|---|
| `product_category_name` | STRING | **PK** | Category name in Portuguese — links to `olist_products.product_category_name` |
| `product_category_name_english` | STRING | — | English translation of the category name |

### 10.2 Null & Distinct Counts

| Column | Null Count | Null % | Distinct Count |
|---|---|---|---|
| `product_category_name` | 0 | 0.00% | 71 |
| `product_category_name_english` | 0 | 0.00% | 71 |

### 10.3 Statistical Profile

No numeric columns. All 71 rows are fully populated with unique values in both columns — clean 1:1 translation mapping.

> **Coverage Note:** `olist_products` has **73** distinct category names but this table only has **71** translation entries — 2 Portuguese categories have no English translation and will produce NULLs on a LEFT JOIN from products.

---

## Appendix — Quick Reference

### Row Counts by Table

| Table | Row Count |
|---|---|
| `olist_geolocation_dataset` | 1,000,163 |
| `olist_order_items_dataset_dataset` | 112,650 |
| `olist_order_payments_dataset_dataset` | 103,886 |
| `olist_orders_dataset_dataset` | 99,441 |
| `olist_customers_dataset_dataset` | 99,441 |
| `olist_order_reviews_dataset` | 99,224 |
| `olist_products_dataset` | 32,951 |
| `olist_sellers_dataset` | 3,095 |
| `product_category_name_translation` | 71 |

### Tables with Notable Nulls

| Table | Column | Null Count | Null % | Comment |
|---|---|---|---|---|
| `olist_order_reviews` | `review_comment_title` | 87,656 | 88.34% | Optional field |
| `olist_order_reviews` | `review_comment_message` | 58,247 | 58.70% | Optional field |
| `olist_orders_dataset` | `order_delivered_customer_date` | 2,965 | 2.98% | Orders not yet delivered |
| `olist_orders_dataset` | `order_delivered_carrier_date` | 1,783 | 1.79% | Orders not yet shipped |
| `olist_products` | `product_category_name` | 610 | 1.85% | Incomplete product records |
| `olist_orders_dataset` | `order_approved_at` | 160 | 0.16% | Unpaid/canceled orders |

### Primary Keys Summary

| Table | Primary Key | Uniqueness Check |
|---|---|---|
| `olist_customers_dataset` | `customer_id` | ✅ 99,441 / 99,441 |
| `olist_orders_dataset` | `order_id` | ✅ 99,441 / 99,441 |
| `olist_order_items_dataset` | (`order_id`, `order_item_id`) | ✅ Composite PK |
| `olist_order_payments_dataset` | (`order_id`, `payment_sequential`) | ✅ Composite PK |
| `olist_order_reviews` | `review_id` | ⚠️ 98,410 / 99,224 — 814 duplicate review IDs |
| `olist_products` | `product_id` | ✅ 32,951 / 32,951 |
| `olist_sellers` | `seller_id` | ✅ 3,095 / 3,095 |
| `olist_geolocation` | `geolocation_zip_code_prefix` | ❌ Non-unique (19,015 zips / 1M rows) |
| `product_category_name_translation` | `product_category_name` | ✅ 71 / 71 |

---

*Generated from raw CSV profiling using pandas. All statistics computed on source data as-is, without imputation or transformation.*