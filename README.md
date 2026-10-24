# Ecommerce Analytics | Google BigQuery SQL Project

## 1. Project Overview

This project explores ecommerce analytics using **Google BigQuery (GoogleSQL / Standard SQL)** and the **Google Analytics 360 sample dataset**. 10 SQL queries investigate website traffic, acquisition channels, customer purchasing behavior, product interactions, revenue, and conversion funnels.

> **Scope:** Each analysis uses the specific date range required by its question, primarily periods in 2017. This is an educational SQL analysis project, not a deployed operational dashboard. Query outputs have not been independently validated by executing them in BigQuery.

## 2. Business Objectives

- Monitor monthly website visits, pageviews, and transactions.
- Evaluate acquisition channels using bounce rate and conversion rate.
- Analyze revenue by traffic source, device, and time period.
- Compare browsing behavior between purchasers and non-purchasers.
- Explore cross-selling opportunities and product funnel interactions.
- Track weekly revenue and cumulative revenue.

## 3. Technology Stack and Dataset

| Component | Description |
|---|---|
| Platform | Google Cloud BigQuery |
| SQL dialect | GoogleSQL (Standard SQL) |
| Public dataset | `bigquery-public-data.google_analytics_sample` |
| Source tables | `ga_sessions_*` (date-sharded session tables) |
| Analysis periods | Selected months in 2017, depending on the query |
| Techniques | CTEs, `UNNEST`, joins, `UNION ALL`, aggregations, date functions, window functions |

### Key Fields

| Field | Meaning |
|---|---|
| `date` | Session date in `YYYYMMDD` format |
| `fullVisitorId` | Visitor identifier |
| `totals.visits` | Recorded visits |
| `totals.pageviews` | Pageviews |
| `totals.transactions` | Transactions |
| `totals.bounces` | Bounced sessions |
| `trafficSource.source` | Traffic acquisition source |
| `device.deviceCategory` | Device category |
| `hits.eCommerceAction.action_type` | Ecommerce action type |
| `hits.product.v2ProductName` | Product name |
| `hits.product.productQuantity` | Product quantity |
| `hits.product.productRevenue` | Product revenue, stored in units of 10⁻⁶ of the currency unit |

## 4. Repository Structure

```text
Ecommerce-Analytics/
├── Query/
|   ├── q1_monthly_traffic_overview.sql
│   ├── q2_bounce_rate_by_traffic_source.sql
│   ├── ...
│   ├── q10_weekly_cumulative_revenue.sql
| 
├── Result/
│   ├── result_q1.png
│   ├── result_q2.png
│   ├── ....
│   ├── result_q10.png
│
└── README.md
```

## 5. SQL Query Overview

| Query | Analysis | Date range | Main output |
|---|---|---|---|
| 01 | Monthly website traffic overview | Jan–Mar 2017 | Visits, pageviews, transactions |
| 02 | Bounce rate by traffic source | Jul 2017 | Visits, bounces, bounce rate (%) |
| 03 | Revenue by traffic source, week and month | Jun 2017 | Time granularity, period, source, revenue |
| 04 | Conversion rate by traffic source | 2017 | Visits, transactions, conversion rate (%) |
| 05 | Average pageviews by purchaser type | Jun–Jul 2017 | Average pageviews per visitor |
| 06 | Average transactions per purchaser | Jul 2017 | Transactions per purchaser |
| 07 | Revenue contribution by device | 2017 | Device revenue and share (%) |
| 08 | Cross-selling products by customer | Jul 2017 | Related product names and quantities |
| 09 | Product view-to-purchase funnel | Jan–Mar 2017 | Views, add-to-cart, purchases, rates |
| 10 | Weekly cumulative revenue | May–Jul 2017 | Weekly and cumulative revenue |

### A. Website Traffic and Acquisition (Queries 01–04)

These queries assess traffic volume, acquisition channel quality, and the extent to which visits translate into transactions.

- **Bounce Rate (%)** = Bounces / Visits × 100.
- **Conversion Rate (%)** = Transactions / Visits × 100 (transaction-per-visit definition used in this exercise).
- **Revenue by Source** = Sum of `productRevenue` / 1,000,000, grouped by source and reporting period.

### B. Customer Behavior (Queries 05–06)

These queries compare page browsing between purchasers and non-purchasers and calculate the average number of transactions among purchasing visitors.

- **Average Pageviews per Visitor** = Total pageviews / Distinct visitors.
- **Average Transactions per Purchaser** = Total transactions / Distinct purchasing visitors.

### C. Product and Revenue Analysis (Queries 07–10)

These queries examine device revenue contribution, products purchased by customers who bought **YouTube Men's Vintage Henley**, ecommerce funnel events, and cumulative weekly revenue.

- **Revenue Share (%)** = Device revenue / Total revenue × 100.
- **Add-to-Cart Rate (%)** = Add-to-cart actions / Product-view actions × 100.
- **Purchase Rate (%)** = Purchase actions / Product-view actions × 100.
- **Cumulative Revenue** = Running total of weekly revenue.

> Query 09 currently aggregates by **month**, rather than by individual product or SKU. Its funnel rates compare action counts, not true user-cohort conversion probabilities.

## 6. SQL Skills Demonstrated

- **Aggregation:** `SUM`, `COUNT`, `COUNT(DISTINCT)`, `GROUP BY`.
- **Date processing:** `PARSE_DATE`, `FORMAT_DATE`, `_TABLE_SUFFIX` filters.
- **Nested records:** `UNNEST(hits)` and `UNNEST(hits.product)`.
- **Query organization:** Common Table Expressions (`WITH`).
- **Data combination:** `UNION ALL`, `INNER JOIN`, `CROSS JOIN`.
- **Conditional logic:** `CASE WHEN`, `IFNULL`.
- **Defensive calculations:** `SAFE_DIVIDE`, `ROUND`.
- **Window analytics:** `SUM(...) OVER (ORDER BY ...)` for running totals.

## 7. How to Run

1. Open the [BigQuery Console](https://console.cloud.google.com/bigquery) and select a Google Cloud project with query permissions.
2. Open the relevant `.sql` file.
3. Paste its contents into the SQL editor and select **GoogleSQL**.
4. Execute the query and compare the output columns against the accompanying Excel instructions.
5. Review and validate query logic and metrics before using the results for business decisions.

**Source dataset:** `bigquery-public-data.google_analytics_sample`.


## 8. Business Value

The analyses provide a starting point for questions such as: Which acquisition channels drive traffic? Which have high bounce rates? Which devices generate the most revenue? How do purchasing and non-purchasing visitors behave? Where do users drop out of the shopping funnel? How does revenue accumulate over time?

The results could inform marketing optimization, website experience improvements, sales performance evaluation, and cross-selling analysis. **No quantitative business conclusions are claimed here**, because complete query outputs have not been executed and validated.
