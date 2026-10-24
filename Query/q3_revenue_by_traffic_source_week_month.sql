-- Query 3: Revenue by traffic source by week, by month in June 2017
WITH time_time_type AS(
  SELECT
    'Month' AS time_type
    , FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
    , trafficSource.source 
    , product.productRevenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
  UNNEST (hits) AS hits,
  UNNEST (hits.product) AS product
  WHERE product.productRevenue IS NOT NULL
  
  UNION ALL

  SELECT   
    trafficSource.source
    , FORMAT_DATE('%Y%W', PARSE_DATE('%Y%m%d', date)) AS time
    , 'Week'AS time_type
    , product.productRevenue
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
  UNNEST (hits) AS hits,
  UNNEST (hits.product) AS product
  WHERE product.productRevenue IS NOT NULL
)
SELECT 
  time_type
  , time 
  , source
  , ROUND(SUM(productRevenue) / 1000000, 4) AS revenue
FROM time_time_type
GROUP BY
  time_type
  , time
  , source
ORDER BY
  revenue DESC
