-- Query 04: Conversion rate by traffic source in 2017 (Order by conversion_rate DESC)

-- STEP 1: Collect visits and transactions by traffic source
-- STEP 2: Calculate conversion rate for each traffic source
-- STEP 3: Filter traffic sources with at least 50 transactions
-- STEP 4: Sort by conversion rate in descending order

WITH source_visits_transaction AS (
    SELECT
        trafficSource.source AS source,
        SUM(totals.visits) AS visits,
        SUM(IFNULL(totals.transactions, 0)) AS transactions
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
    WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20171231'
    GROUP BY source
)

SELECT
    source,
    visits,
    transactions,
    CONCAT(
        CAST(ROUND(SAFE_DIVIDE(transactions, visits) * 100, 2) AS STRING),
        '%'
    ) AS conversion_rate
FROM source_visits_transaction
WHERE transactions >= 50
ORDER BY conversion_rate DESC;
