
-- =====================================================
-- PROJECT: E-COMMERCE BUSINESS ANALYTICS
-- FILE: 02_Top_10_Products.sql
-- DATABASE: ecommerce_analytics
-- OBJECTIVE: Product Performance Analysis
-- =====================================================

USE ecommerce_analytics;


-- QUERY 1: Top 10 Products by Revenue

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
GROUP BY
    StockCode,
    Description
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 2: Top 10 Physical Products by Revenue
-- Exclude postage and manual adjustment descriptions.

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
WHERE
    Description NOT LIKE '%POSTAGE%'
    AND Description NOT LIKE '%MANUAL%'
GROUP BY
    StockCode,
    Description
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 3: Top 10 Best-Selling Products by Quantity

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales_transactions
WHERE
    Description NOT LIKE '%POSTAGE%'
    AND Description NOT LIKE '%MANUAL%'
GROUP BY
    StockCode,
    Description
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- QUERY 4: Products Generating the Lowest Revenue

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales_transactions
GROUP BY
    StockCode,
    Description
HAVING SUM(Revenue) > 0
ORDER BY total_revenue ASC
LIMIT 10;


-- QUERY 5: Product Revenue Contribution Percentage

SELECT
    StockCode,
    Description,
    ROUND(SUM(Revenue), 2) AS product_revenue,
    ROUND(
        SUM(Revenue) * 100.0 /
        (SELECT SUM(Revenue)
         FROM sales_transactions),
        2
    ) AS revenue_contribution_percentage
FROM sales_transactions
GROUP BY
    StockCode,
    Description
ORDER BY product_revenue DESC
LIMIT 10;


-- END OF PRODUCT PERFORMANCE ANALYSIS
