-- Query 06: Average number of transactions per user that made a purchase in July 2017

-- STEP 1: Select sessions from July 2017 and identify purchasing activity
-- STEP 2: Calculate average transactions per unique purchasing user
-- STEP 3: Filter sessions containing transactions and product revenue
-- STEP 4: Group results by month


SELECT
  FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS Month
  , ROUND(
      SUM(totals.transactions) / COUNT(DISTINCT fullVisitorId)
      , 9
    ) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  , UNNEST (hits) AS hits
  , UNNEST (hits.product) AS product 
WHERE
  totals.transactions >= 1
  AND product.productRevenue IS NOT NULL
GROUP BY 
  Month