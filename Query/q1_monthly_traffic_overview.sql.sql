-- Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)

  -- Step 1: Convert the date field into monthly format (YYYYMM).
  -- Step 2: Filter data month(Jan, Feb and March).
  -- Step 3: Calculate total visit, pageview, transaction by month and order by month ASC.

SELECT  
  FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
  , SUM(totals.visits) AS visits
  , SUM(totals.pageviews) AS pageviews
  , SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE 
  _table_suffix BETWEEN '0101' AND '0331'
GROUP BY
  month
ORDER BY 
  month