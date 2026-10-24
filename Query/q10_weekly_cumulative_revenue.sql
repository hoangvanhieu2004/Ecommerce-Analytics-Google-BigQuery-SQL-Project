-- Query 10: Calculate revenue by week from May to July 2017 and culmulative revenue.

-- STEP 1: Calculate weekly revenue from May to July 2017
-- STEP 2: Convert product revenue from micros to the standard currency unit
-- STEP 3: Group revenue by week
-- STEP 4: Calculate cumulative revenue using a window function
-- STEP 5: Round weekly and cumulative revenue to 2 decimal places
-- STEP 6: Sort results chronologically by week

WITH weekly_by_revenue AS (
    SELECT
        FORMAT_DATE(
            '%G-%V',
            PARSE_DATE('%Y%m%d', date)
        ) AS week,
        SUM(product.productRevenue) / 1000000 AS weekly_revenue
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
    UNNEST(hits) AS hits,
    UNNEST(hits.product) AS product
    WHERE
        _TABLE_SUFFIX BETWEEN '0501' AND '0731'
        AND product.productRevenue IS NOT NULL
    GROUP BY week
)

SELECT
    week,
    ROUND(weekly_revenue, 2) AS weekly_revenue,
    ROUND(
        SUM(weekly_revenue) OVER (
            ORDER BY week
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM weekly_by_revenue
ORDER BY week;
