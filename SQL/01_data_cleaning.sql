
USE coffee_shop_analysis;

-- Create a cleaned view of the original coffee sales data.
-- Standardizes transaction dates and product descriptions.

CREATE OR REPLACE VIEW coffee_sales_clean AS
SELECT
    transaction_id,
    STR_TO_DATE(transaction_date, '%c/%e/%y') AS transaction_date,
    transaction_time,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    unit_price,
    product_category,
    product_type,
    TRIM(
        REPLACE(
            REPLACE(product_detail, CHAR(13), ''),
            CHAR(10), ''
        )
    ) AS product_detail
FROM coffee_sales;
