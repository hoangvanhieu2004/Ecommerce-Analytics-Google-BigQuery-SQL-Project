-- Query 09: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase. Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level.

-- STEP 1: Collect product view, add-to-cart, and purchase data by month
-- STEP 2: Calculate the number of product views, add-to-cart actions, and purchases
-- STEP 3: Filter data to include only January, February, and March 2017
-- STEP 4: Calculate add-to-cart rate and purchase rate based on product views
-- STEP 5: Display monthly results and conversion rates

WITH product_data AS(
  SELECT
    FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d',DATE)) AS month
    , COUNT(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) AS num_product_view
    , COUNT(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) AS num_add_to_cart
    , COUNT(CASE WHEN eCommerceAction.action_type = '6' AND product.productRevenue IS NOT NULL THEN product.v2ProductName END) AS num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    , UNNEST(hits) AS hits
    , UNNEST (hits.product) AS product
  WHERE _table_suffix BETWEEN '20170101' AND '20170331'
  AND eCommerceAction.action_type IN ('2','3','6')
  GROUP BY month
  ORDER BY month
)

SELECT
  month
  , num_product_view
  , num_add_to_cart
  , num_purchase
  , ROUND(num_add_to_cart/num_product_view * 100, 2) AS add_to_cart_rate
  , ROUND(num_purchase/num_product_view * 100, 2) AS purchase_rate
FROM product_data;



