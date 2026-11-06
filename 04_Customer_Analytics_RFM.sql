
-- =====================================================
-- PROJECT: E-COMMERCE BUSINESS ANALYTICS
-- FILE: 04_Customer_Analytics_RFM.sql
-- OBJECTIVE: Customer Behaviour Analysis
-- =====================================================

USE ecommerce_analytics;


-- QUERY 1: Customer Revenue and Purchase Frequency

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Revenue), 2) AS total_spending,
    SUM(Quantity) AS total_units_purchased,
    MIN(InvoiceDate) AS first_purchase_date,
    MAX(InvoiceDate) AS last_purchase_date
FROM sales_transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_spending DESC
LIMIT 20;


-- QUERY 2: Top 10 Customers by Revenue

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM sales_transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 3: Repeat Customer Analysis

SELECT
    CASE
        WHEN customer_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS customer_orders
    FROM sales_transactions
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) AS customer_summary
GROUP BY customer_type;


-- QUERY 4: Average Order Value by Customer

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(
        SUM(Revenue) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS average_order_value
FROM sales_transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY average_order_value DESC
LIMIT 20;


-- QUERY 5: Customer Revenue Ranking

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(Revenue) DESC
    ) AS customer_rank
FROM sales_transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY customer_rank
LIMIT 20;


-- =====================================================
-- QUERY 6: RFM CUSTOMER SEGMENTATION
-- =====================================================

USE ecommerce_analytics;

WITH customer_rfm AS (

    SELECT
        CustomerID,

        DATEDIFF(
            (SELECT MAX(InvoiceDate)
             FROM sales_transactions),
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(SUM(Revenue), 2) AS Monetary

    FROM sales_transactions

    WHERE CustomerID IS NOT NULL

    GROUP BY CustomerID
),

rfm_scores AS (

    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS R_Score,

        NTILE(5) OVER (
            ORDER BY Frequency ASC
        ) AS F_Score,

        NTILE(5) OVER (
            ORDER BY Monetary ASC
        ) AS M_Score

    FROM customer_rfm
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,

    CASE
        WHEN R_Score >= 4
         AND F_Score >= 4
         AND M_Score >= 4
        THEN 'Champions'

        WHEN F_Score >= 4
         AND M_Score >= 3
        THEN 'Loyal Customers'

        WHEN R_Score >= 4
         AND F_Score BETWEEN 2 AND 3
        THEN 'Potential Loyalists'

        WHEN R_Score <= 2
         AND F_Score >= 3
        THEN 'At Risk'

        WHEN R_Score <= 2
         AND F_Score <= 2
        THEN 'Lost Customers'

        ELSE 'Others'

    END AS Customer_Segment

FROM rfm_scores

ORDER BY
    R_Score DESC,
    F_Score DESC,
    M_Score DESC;



-- END OF CUSTOMER ANALYSIS

-- QUERY 7: CUSTOMER SEGMENT SUMMARY

USE ecommerce_analytics;

WITH customer_rfm AS (

    SELECT
        CustomerID,

        DATEDIFF(
            (SELECT MAX(InvoiceDate)
             FROM sales_transactions),
            MAX(InvoiceDate)
        ) AS Recency,

        COUNT(DISTINCT InvoiceNo) AS Frequency,

        ROUND(SUM(Revenue), 2) AS Monetary

    FROM sales_transactions
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),

rfm_scores AS (

    SELECT *,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM customer_rfm
),

customer_segments AS (

    SELECT *,
        CASE
            WHEN R_Score >= 4 AND F_Score >= 4
                 AND M_Score >= 4 THEN 'Champions'

            WHEN F_Score >= 4 AND M_Score >= 3
                 THEN 'Loyal Customers'

            WHEN R_Score >= 4 AND F_Score BETWEEN 2 AND 3
                 THEN 'Potential Loyalists'

            WHEN R_Score <= 2 AND F_Score >= 3
                 THEN 'At Risk'

            WHEN R_Score <= 2 AND F_Score <= 2
                 THEN 'Lost Customers'

            ELSE 'Others'
        END AS Customer_Segment
    FROM rfm_scores
)

SELECT
    Customer_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(AVG(Monetary), 2) AS Average_Customer_Spend

FROM customer_segments

GROUP BY Customer_Segment

ORDER BY Total_Revenue DESC;

