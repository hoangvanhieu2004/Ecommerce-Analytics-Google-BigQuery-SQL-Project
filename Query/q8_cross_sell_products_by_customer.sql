-- Query 08: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.

-- STEP 1: Identify customers who purchased the target product
-- STEP 2: Retrieve other products purchased by the identified customers
-- STEP 3: Calculate the total quantity ordered for each produc
-- STEP 4: Filter purchases made by target customers
-- STEP 5: Group by product name and rank by quantity purchased

SELECT 
  product.v2ProductName AS other_purchased_products
  , SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
  , UNNEST (hits) AS hits
  , UNNEST (hits.product) AS product
WHERE 
  fullVisitorId IN (SELECT DISTINCT
                      fullVisitorId
                    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
                      , UNNEST (hits) AS hits
                      , UNNEST (hits.product) AS product
                    WHERE 
                      product.v2ProductName = "YouTube Men's Vintage Henley"
                      AND totals.transactions >= 1
                      AND product.productRevenue IS NOT NULL)
  AND product.v2ProductName != "YouTube Men's Vintage Henley"
  AND totals.transactions >= 1
  AND product.productRevenue IS NOT NULL
GROUP BY 
  other_purchased_products
ORDER BY 
  quantity DESC
