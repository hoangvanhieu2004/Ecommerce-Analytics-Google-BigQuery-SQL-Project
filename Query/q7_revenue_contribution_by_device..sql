-- Query 07: Revenue contribution by device (desktop,mobile...) in 2017(order by ratio desc)

-- STEP 1: Calculate revenue for each device category
-- STEP 2: Calculate total revenue across all device categories
-- STEP 3: Calculate each device's revenue contribution percentage
-- STEP 4: Rank devices by revenue contribution in descending order


WITH by_device AS(
  SELECT 
    device.deviceCategory AS device 
    , ROUND((SUM(product.productRevenue) / 1000000), 2) AS revenue_by_device
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
  UNNEST (hits) AS hits,
  UNNEST (hits.product) AS product
  WHERE
    totals.transactions IS NOT NULL 
    AND product.productRevenue IS NOT NULL
  GROUP BY
    device
)

, total AS(
  SELECT 
    ROUND(SUM(revenue_by_device), 2) AS total_revenue
  FROM by_device
)

SELECT 
  d.device,
  d.revenue_by_device,
  t.total_revenue,
  ROUND((SAFE_DIVIDE(d.revenue_by_device, t.total_revenue) * 100), 2) AS ratio
FROM by_device AS d
CROSS JOIN total AS t 
ORDER BY ratio DESC

