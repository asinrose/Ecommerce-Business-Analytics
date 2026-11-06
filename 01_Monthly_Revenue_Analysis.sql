
-- =====================================================
-- PROJECT: E-COMMERCE BUSINESS ANALYTICS
-- FILE: 01_Monthly_Revenue_Analysis.sql
-- DATABASE: ecommerce_analytics
-- OBJECTIVE: Monthly Revenue Analysis
-- =====================================================

USE ecommerce_analytics;


-- QUERY 1: Monthly Revenue and Sales Performance

SELECT
    YEAR(InvoiceDate) AS sales_year,
    MONTH(InvoiceDate) AS sales_month,
    MONTHNAME(InvoiceDate) AS month_name,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    SUM(Quantity) AS total_units_sold,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate),
    MONTHNAME(InvoiceDate)
ORDER BY
    sales_year,
    sales_month;


-- QUERY 2: Top 10 Revenue-Generating Months

SELECT
    YEAR(InvoiceDate) AS sales_year,
    MONTHNAME(InvoiceDate) AS month_name,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate),
    MONTHNAME(InvoiceDate)
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 3: Year-Wise Revenue Comparison

SELECT
    YEAR(InvoiceDate) AS sales_year,
    ROUND(SUM(Revenue), 2) AS annual_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_units_sold
FROM sales_transactions
GROUP BY YEAR(InvoiceDate)
ORDER BY sales_year;


-- QUERY 4: Average Monthly Revenue

SELECT
    ROUND(AVG(monthly_revenue), 2) AS average_monthly_revenue
FROM (
    SELECT
        YEAR(InvoiceDate) AS sales_year,
        MONTH(InvoiceDate) AS sales_month,
        SUM(Revenue) AS monthly_revenue
    FROM sales_transactions
    GROUP BY
        YEAR(InvoiceDate),
        MONTH(InvoiceDate)
) AS monthly_sales;


-- QUERY 5: Monthly Average Order Value (AOV)

SELECT
    YEAR(InvoiceDate) AS sales_year,
    MONTHNAME(InvoiceDate) AS month_name,
    ROUND(
        SUM(Revenue) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0), 2
    ) AS average_order_value
FROM sales_transactions
GROUP BY
    YEAR(InvoiceDate),
    MONTH(InvoiceDate),
    MONTHNAME(InvoiceDate)
ORDER BY
    sales_year,
    MONTH(InvoiceDate);


-- END OF MONTHLY REVENUE ANALYSIS
