
-- =====================================================
-- PROJECT: E-COMMERCE BUSINESS ANALYTICS
-- FILE: 03_Country_Wise_Analysis.sql
-- DATABASE: ecommerce_analytics
-- OBJECTIVE: Geographical Sales Analysis
-- =====================================================

USE ecommerce_analytics;


-- QUERY 1: Country-Wise Sales Performance

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    COUNT(DISTINCT CustomerID) AS total_customers,
    SUM(Quantity) AS total_units_sold
FROM sales_transactions
GROUP BY Country
ORDER BY total_revenue DESC;


-- QUERY 2: Top 10 Revenue-Generating Countries

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 3: Country-Wise Average Order Value

SELECT
    Country,
    ROUND(
        SUM(Revenue) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS average_order_value,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
GROUP BY Country
ORDER BY average_order_value DESC;


-- QUERY 4: Customer Distribution by Country

SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS total_customers,
    ROUND(SUM(Revenue), 2) AS total_revenue
FROM sales_transactions
GROUP BY Country
ORDER BY total_customers DESC;


-- QUERY 5: Country-Wise Revenue Contribution

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS country_revenue,
    ROUND(
        SUM(Revenue) * 100.0 /
        (SELECT SUM(Revenue)
         FROM sales_transactions),
        2
    ) AS revenue_percentage
FROM sales_transactions
GROUP BY Country
ORDER BY country_revenue DESC;


-- END OF COUNTRY-WISE ANALYSIS
