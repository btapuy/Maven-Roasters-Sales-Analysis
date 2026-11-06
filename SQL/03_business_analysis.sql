
USE coffee_shop_analysis;

-- =====================================================
-- MAVEN ROASTERS | BUSINESS PERFORMANCE ANALYSIS
-- January - June 2023
-- =====================================================

-- 1. OVERALL SALES PERFORMANCE
-- Calculate revenue, transactions, items sold,
-- and average transaction value.

SELECT
    ROUND(SUM(transaction_qty * unit_price), 2)
        AS total_revenue,
    COUNT(DISTINCT transaction_id)
        AS total_transactions,
    SUM(transaction_qty)
        AS total_items_sold,
    ROUND(
        SUM(transaction_qty * unit_price) /
        NULLIF(COUNT(DISTINCT transaction_id), 0), 2
    ) AS avg_transaction_value
FROM coffee_sales_clean;


-- 2. MONTHLY REVENUE TRENDS
-- Identify revenue and transaction growth over time.

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m')
        AS sales_month,
    ROUND(SUM(transaction_qty * unit_price), 2)
        AS monthly_revenue,
    COUNT(DISTINCT transaction_id)
        AS total_transactions,
    SUM(transaction_qty)
        AS items_sold
FROM coffee_sales_clean
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY sales_month;


-- 3. MONTH-OVER-MONTH REVENUE GROWTH
-- Use a window function to measure monthly growth.

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m')
            AS sales_month,
        SUM(transaction_qty * unit_price)
            AS revenue
    FROM coffee_sales_clean
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
),
growth_analysis AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month)
            AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2)
        AS previous_month_revenue,
    ROUND(
        100 * (revenue - previous_month_revenue) /
        NULLIF(previous_month_revenue, 0), 2
    ) AS revenue_growth_pct
FROM growth_analysis
ORDER BY sales_month;


-- 4. REVENUE BY STORE LOCATION
-- Compare performance across NYC locations.

SELECT
    store_location,
    ROUND(SUM(transaction_qty * unit_price), 2)
        AS total_revenue,
    COUNT(DISTINCT transaction_id)
        AS total_transactions,
    ROUND(
        SUM(transaction_qty * unit_price) /
        NULLIF(COUNT(DISTINCT transaction_id), 0), 2
    ) AS avg_transaction_value
FROM coffee_sales_clean
GROUP BY store_location
ORDER BY total_revenue DESC;


-- 5. PRODUCT CATEGORY PERFORMANCE
-- Identify the highest-revenue product categories.

SELECT
    product_category,
    ROUND(SUM(transaction_qty * unit_price), 2)
        AS total_revenue,
    SUM(transaction_qty)
        AS items_sold,
    ROUND(
        100 * SUM(transaction_qty * unit_price) /
        NULLIF(
            (SELECT SUM(transaction_qty * unit_price)
             FROM coffee_sales_clean), 0
        ), 2
    ) AS revenue_share_pct
FROM coffee_sales_clean
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 6. TRANSACTIONS BY HOUR
-- Identify peak customer purchasing periods.

SELECT
    HOUR(transaction_time) AS hour_of_day,
    COUNT(DISTINCT transaction_id)
        AS total_transactions,
    ROUND(SUM(transaction_qty * unit_price), 2)
        AS total_revenue
FROM coffee_sales_clean
GROUP BY HOUR(transaction_time)
ORDER BY hour_of_day;


-- 7. TRANSACTIONS BY DAY OF WEEK
-- Identify weekly purchasing patterns.

SELECT
    DAYNAME(transaction_date) AS day_of_week,
    WEEKDAY(transaction_date) AS weekday_number,
    COUNT(DISTINCT transaction_id)
        AS total_transactions,
    ROUND(SUM(transaction_qty * unit_price), 2)
        AS total_revenue
FROM coffee_sales_clean
GROUP BY
    DAYNAME(transaction_date),
    WEEKDAY(transaction_date)
ORDER BY weekday_number;
