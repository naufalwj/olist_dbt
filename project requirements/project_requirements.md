# 1. Olist Marketplace Analytics
## Project Requirements

### Primary Business Question
> **Which sellers** are delivering the **best customer experience**, and **what operational factors** drive performance differences across the marketplace?

### [Technical] Project Goals
- Build a **reliable, repeatable analytics foundation** for Olist's marketplace data
- Provide **actionable insights** to stakeholders on seller performance, delivery SLAs, and customer experience
- Enable **self-service analytics** for future ad-hoc questions and dashboards

### [Personal] Project Goals
- To demonstrate my ability to design and implement an **analytics engineering pipeline** using modern tools and best practices
- For my personal portfolio, to showcase my skills in **analytics engineering, data modeling, and visualization** using a real-world dataset
  
### Project Outputs

| Output | Technology | Purpose |
|--------|------------|---------|
| Bronze Delta Tables | Databricks | Raw source layer - CSV ingested as it is |
| Silver dbt Models | dbt + Databricks | Cleaned, confirmed, validated data |
| Gold dbt Models | dbt + Databricks | Dimensional model (facts + dims) |
| dbt Docs Site | dbt docs generate | Lineage, schema docs, test results |
| Tableau Dashboard | Tableau | Seller performance analytics for stakeholders |
| GitHub Repository | GitHub | Public portfolio with README and CI |

---

## Dataset Overview
**Olist dataset** is a publicly available Brazilian e-commerce dataset released on Kaggle. It covers approximately **100,000 orders** placed **between 2016 and 2018** across multiple marketplaces in **Brazil**. The dataset includes order-level, customer, seller, product, review, payment, and geolocation data. It's structured as a normalized relational schema that closely mirrors a real e-commerce platform's operational database.

### Data Sources
#### Source Tables

| Table | Rows (approx.) | Description |
|-------|----------------|-------------|
| olist_orders_dataset | ~99,441 | Core order lifecycle (status, timestamps, estimated vs actual delivery) |
| olist_order_items_dataset | ~112,650 | Line items per order (seller, product, price, freight value) |
| olist_customers_dataset | ~99,441 | Customer records (city, state, zip code) |
| olist_sellers_dataset | ~3,095 | Seller registry (location data) |
| olist_products_dataset | ~32,951 | Product catalog (category, dimensions, weight) |
| olist_order_reviews_dataset | ~99,224 | Customer review scores and text comments |
| olist_order_payments_dataset | ~103,886 | Payment method and installment details per order |
| olist_geolocation_dataset | ~1M+ | Zip code to lat/long mapping (contains duplicates) |
| product_category_name_translation | ~71 | Portuguese-to-English category name mapping |

##### Key Data Characteristics and Found Issues
- **Geolocation table** has multiple rows per zip code prefix (**requires deduplication**)
- **Orders table** has some **NULL delivery timestamps**. Some orders may have been cancelled before shipment
- **Product category names** are **in Portuguese** by default. **Translation table must be handled**
- **Review creation date** can **precede the order delivery date** due to early review submissions
- **Freight value** sits at the **order item level**, not the order level (**requires aggregation for order-level analysis**)
- **Order status** shows that **~3% of orders have status other than 'delivered'**. It's possibly a failed transactions or cancelled orders. These should be **excluded from delivery performance analysis**.

---

## Problem Statement
**Olist** operates as a marketplace **connecting sellers to customers across Brazil**. The platform's growth depends on **consistently high-quality seller performance** such as:
- On-Time deliveries
- Accurate product listings
- Positive customer experiences

Without a centralized, **reliable analytics layer**, it is difficult to answer fundamental operational questions at scale
- Which sellers are **underperforming**
- Which categories drive the **most customer complaints**
- How does **geography affect delivery SLAs**

    >**Note:**
    >The 3 Phases of Delivery SLAs:
    >- **Processing Time**: The duration from when an order is placed to when it is packaged and handed over to a courier.
    >- **Transit Time**: The actual time the courier spends moving the package from the origin to the destination.
    >- **Delivery Confirmation**: The final step, which defines the timeframe for completing the delivery and securing Proof of Delivery (POD).

---

## Solution Blueprint

> This blueprint designs the key areas of focus for improving seller performance, delivery logistics, and customer experience.
> Other than that, it also defines the **final output** of the project, which is **to answer** and **summarize** how seller performance, delivery SLAs, and freight costs affect customer experience and marketplace health.

### Question Breakdown
**Seller Performance**
- Which sellers have the **highest late delivery rate** in the last 12 months?
- What is each seller's **average review score**, and how does it **correlate with on-time rate**?
- Which sellers generate the most **revenue** but have declining **review scores**?
- How many **current active vs. inactive sellers** are on the platform by region?

**Delivery & Logistics**

- What is the **average gap between estimated delivery date** and **actual delivery date** by seller state?
- Which product categories have the **highest average delivery time**?
- How does **order volume** and **delivery performance** change over time (monthly trend)?

**Customer Experience**

- What is the distribution of **review scores** across delivered orders?
- Which product categories receive the most **1-star reviews**?
- Is there a measurable relationship between **freight cost** and **review score**?

### Answer Breakdown
**Final output is to answer and summarize**
- How does seller performance (reviews, on-time delivery, review score, revenue) affect the overall customer experience and marketplace health?
  - Does seller location (state, city) affect delivery performance?
  - Does review impact seller revenue and retention?
  - Does review and revenue impact seller retention and marketplace health? (e.g. if a seller has low reviews, do they lose revenue or get deactivated?)
- How does Delivery SLA (processing time, transit time, delivery confirmation) affect customer experience and seller performance?
  - Does (again) seller location (state, city) affect delivery performance?
  - Does specific product category affect delivery performance (could be not avail in inventory, or hard to procure, etc) ?
  - Does order volume affect delivery performance? (could be due to seller capacity, courier capacity, etc)
- How does freight cost affect customer experience and seller performance?
  - Does customer location (state, city) affect delivery performance? (could be due to courier capacity, distance, etc)
  - Does most of the review scores because of the delivery performance or because of the product quality? (comparison between product review (freight cost, quality, etc) vs delivery review)
  
---

## Technical Architecture
The project implements a **medallion lakehouse architecture** on **Databricks**. Data flows from raw CSV files through three structured layers before reaching the **visualization layer in Tableau**

### Stack & Tools
|Component | Tool / Technology|
|---|---|
|Data Source | [Kaggle Olist Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)|
|Storage Layer | **Databricks** Delta Lake (Unity Catalog)|
|Transformation | **dbt Core** connected to Databricks SQL Warehouse|
|Orchestration | **Databricks Workflows** / **Airflow**|
|Version Control | **GitHub** (public repository)|
|CI / CD | **GitHub Actions** - dbt build on push to main|
|Documentation | **dbt docs generate** (served via GitHub Pages)|
|Visualization | **Tableau Public**|
|Testing | **dbt tests**|

---
