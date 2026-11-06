
USE coffee_shop_analysis;

-- =====================================================
-- MAVEN ROASTERS | EXPLORATORY DATA ANALYSIS
-- =====================================================

-- 1. Preview the cleaned dataset
SELECT *
FROM coffee_sales_clean
LIMIT 10;

-- 2. Count total transactions
SELECT
    COUNT(DISTINCT transaction_id) AS total_transactions
FROM coffee_sales_clean;

-- 3. Identify the transaction date range
SELECT
    MIN(transaction_date) AS first_date,
    MAX(transaction_date) AS last_date
FROM coffee_sales_clean;

-- 4. Identify store locations
SELECT
    store_location,
    COUNT(DISTINCT transaction_id) AS transactions
FROM coffee_sales_clean
GROUP BY store_location
ORDER BY transactions DESC;

-- 5. Check for missing values in key fields
SELECT
    SUM(transaction_date IS NULL) AS missing_dates,
    SUM(transaction_qty IS NULL) AS missing_quantities,
    SUM(unit_price IS NULL) AS missing_prices,
    SUM(product_category IS NULL) AS missing_categories
FROM coffee_sales_clean;

-- 6. Identify product categories
SELECT
    product_category,
    COUNT(*) AS records
FROM coffee_sales_clean
GROUP BY product_category
ORDER BY records DESC;
