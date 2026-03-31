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
