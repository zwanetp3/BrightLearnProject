-- ============================================================
-- Bright Coffee Shop Analysis – Consolidated Query
-- ============================================================

-- 0. Quick Look at the Table
SELECT *
FROM workspace.default.`1773682225332_bright_coffee_shop_analysis_case_study_1`
LIMIT 10;

-- 1. Date Range Checks
SELECT MIN(transaction_date) AS min_date,
       MAX(transaction_date) AS latest_date
FROM workspace.default.`1773682225332_bright_coffee_shop_analysis_case_study_1`;

-- 2. Store Information
SELECT DISTINCT store_location
FROM workspace.default.`1773682225332_bright_coffee_shop_analysis_case_study_1`;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM workspace.default.`1773682225332_bright_coffee_shop_analysis_case_study_1`;

-- 3. Product Information
SELECT DISTINCT product_category, product_detail, product_type
FROM workspace.default.`1773682225332_bright_coffee_shop_analysis_case_st

-- ============================================================
-- Bright Coffee Shop Analysis – Consolidated Query (Final Fixed)
-- ============================================================

SELECT 
    -- Identifiers
    transaction_id,
    store_id,
    product_id,

    -- Transaction Details
    transaction_date AS purchase_date,
    transaction_time,
    store_location,
    
    -- Product Details
    product_category,
    product_type,
    product_detail,

    -- Pricing & Revenue (force numeric types)
    CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) AS clean_unit_price,
    CAST(transaction_qty AS INT) AS transaction_qty,
    CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) * CAST(transaction_qty AS INT) AS total_amount,

    -- Date Breakdown
    dayname(transaction_date) AS day_name,
    monthname(transaction_date) AS month_name,
    dayofmonth(transaction_date) AS day_of_month,

    -- Day Classification
    CASE 
        WHEN dayname(transaction_date) IN ('Sat','Sun') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,

    -- Time Buckets
    CASE
        WHEN hour(transaction_time) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN hour(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN hour(transaction_time) >= 17 THEN 'Evening'
    END AS time_bucket,

    -- Spend Buckets (Daily Revenue Classification)
    CASE
        WHEN SUM(CAST(transaction_qty AS INT) * CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) 
             OVER (PARTITION BY transaction_date) <= 50 THEN 'Low Spend'
        WHEN SUM(CAST(transaction_qty AS INT) * CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) 
             OVER (PARTITION BY transaction_date) BETWEEN 51 AND 100 THEN 'Medium Spend'
        ELSE 'High Spend'
    END AS spend_bucket,

    -- Daily Averages
    AVG(CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) * CAST(transaction_qty AS INT)) 
        OVER (PARTITION BY transaction_date) AS avg_transaction_value,
    AVG(CAST(transaction_qty AS INT)) OVER (PARTITION BY transaction_date) AS avg_basket_size,

    -- Cumulative Trends
    SUM(CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) * CAST(transaction_qty AS INT)) 
        OVER (PARTITION BY product_type ORDER BY transaction_date, transaction_time) AS cumulative_revenue,
    SUM(CAST(transaction_qty AS INT)) 
        OVER (PARTITION BY product_type ORDER BY transaction_date, transaction_time) AS cumulative_units_sold,

    -- Revenue Contribution %
    SUM(CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) * CAST(transaction_qty AS INT)) 
        OVER (PARTITION BY transaction_date, product_type) * 100.0 /
        SUM(CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2)) * CAST(transaction_qty AS INT)) 
        OVER (PARTITION BY transaction_date) AS revenue_contribution_pct

FROM workspace.default.`1773682225332_bright_coffee_shop_analysis_case_study_1`;


