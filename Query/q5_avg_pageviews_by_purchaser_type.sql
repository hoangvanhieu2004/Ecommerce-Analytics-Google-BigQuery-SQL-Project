-- Query 05: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.

-- STEP 1: Calculate average pageviews per purchasing user
-- STEP 2: Calculate average pageviews per non-purchasing user
-- STEP 3: Combine purchaser and non-purchaser results by month
-- STEP 4: Sort results chronologically

WITH purchaser AS(
  SELECT
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
    , SUM(totals.pageviews) AS total_pageview1
    , COUNT(DISTINCT fullVisitorId) AS number_unique_user1
    , SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_purchase
  FROM`bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    , UNNEST (hits) AS hits
    , UNNEST (hits.product) AS product
  WHERE 
    _table_suffix BETWEEN '0601' AND '0731'
    AND totals.transactions >= 1
    AND product.productRevenue IS NOT NULL
  GROUP BY month
)
, non_purchaser AS(
  SELECT
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month 
    , SUM(totals.pageviews) AS total_pageview2 
    , COUNT(DISTINCT fullVisitorId) AS number_unique_user2
    , SUM(totals.pageviews) / COUNT(DISTINCT fullVisitorId) AS avg_pageviews_non_purchase
  FROM`bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    , UNNEST (hits) AS hits
    , UNNEST (hits.product) AS product
  WHERE 
    _table_suffix BETWEEN '0601' AND '0731'
    AND totals.transactions IS NULL
    AND product.productRevenue IS NULL
  GROUP BY month 
)

SELECT 
  p.month
  , ROUND(avg_pageviews_purchase, 7) AS avg_pageviews_purchase
  , ROUND(avg_pageviews_non_purchase, 7) AS avg_pageviews_non_purchase
FROM purchaser AS p
INNER JOIN non_purchaser AS n
  ON p.month = n.month
ORDER BY month