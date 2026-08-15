-- ============================================================
-- CUSTOMER 360° ANALYTICS & CHURN ANALYSIS
-- Database: customer360
-- Project: Customer 360° Analytics & Churn Prediction
-- Tools: MySQL + Python + Power BI
-- ============================================================

-- ============================================================
-- 1. CREATE / SELECT DATABASE
-- ============================================================

CREATE DATABASE IF NOT EXISTS customer360;
USE customer360;


-- ============================================================
-- 2. CREATE CUSTOMERS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    City VARCHAR(50),
    Gender VARCHAR(20),
    Age INT,
    Subscription_Plan VARCHAR(20),
    Tenure_Months INT,
    Total_Orders INT,
    Avg_Order_Value DECIMAL(10,2),
    Total_Spend DECIMAL(12,2),
    Support_Tickets INT,
    Satisfaction_Score DECIMAL(3,1),
    Days_Since_Last_Purchase INT,
    Churn VARCHAR(10),
    Age_Group VARCHAR(20),
    Customer_Segment VARCHAR(30),
    Purchase_Risk INT,
    Support_Risk INT,
    Satisfaction_Risk INT,
    Risk_Score INT,
    Risk_Level VARCHAR(20)
);


-- ============================================================
-- 3. TOTAL CUSTOMERS
-- ============================================================

SELECT COUNT(*) AS total_customers
FROM customers;


-- ============================================================
-- 4. TOTAL CHURNED CUSTOMERS
-- ============================================================

SELECT COUNT(*) AS churned_customers
FROM customers
WHERE Churn = 'Yes';


-- ============================================================
-- 5. CHURN RATE
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers;


-- ============================================================
-- 6. CHURN BY CITY
-- ============================================================

SELECT
    City,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY City
ORDER BY churn_rate DESC;


-- ============================================================
-- 7. CHURN BY SUBSCRIPTION PLAN
-- ============================================================

SELECT
    Subscription_Plan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY Subscription_Plan
ORDER BY churn_rate DESC;


-- ============================================================
-- 8. CHURN BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    Customer_Segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY Customer_Segment
ORDER BY churn_rate DESC;


-- ============================================================
-- 9. CUSTOMER RISK DISTRIBUTION
-- ============================================================

SELECT
    Risk_Level,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers),
        2
    ) AS percentage
FROM customers
GROUP BY Risk_Level
ORDER BY
    CASE Risk_Level
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Critical' THEN 4
        ELSE 5
    END;


-- ============================================================
-- 10. CHURN BY RISK LEVEL
-- ============================================================

SELECT
    Risk_Level,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY Risk_Level
ORDER BY
    CASE Risk_Level
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Critical' THEN 4
        ELSE 5
    END;


-- ============================================================
-- 11. HIGH & CRITICAL-RISK CUSTOMER COUNT
-- ============================================================

SELECT
    COUNT(*) AS high_critical_risk_customers
FROM customers
WHERE Risk_Level IN ('High', 'Critical');


-- ============================================================
-- 12. CRITICAL-RISK CUSTOMER COUNT
-- ============================================================

SELECT
    COUNT(*) AS critical_risk_customers
FROM customers
WHERE Risk_Level = 'Critical';


-- ============================================================
-- 13. CRITICAL-RISK CHURN RATE
-- ============================================================

SELECT
    COUNT(*) AS critical_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS critical_churned,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS critical_churn_rate
FROM customers
WHERE Risk_Level = 'Critical';


-- ============================================================
-- 14. HIGH & CRITICAL-RISK CUSTOMERS DETAIL
-- ============================================================

SELECT
    Customer_ID,
    City,
    Subscription_Plan,
    Customer_Segment,
    Total_Spend,
    Days_Since_Last_Purchase,
    Support_Tickets,
    Satisfaction_Score,
    Risk_Level,
    Churn
FROM customers
WHERE Risk_Level IN ('High', 'Critical')
ORDER BY
    CASE Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        ELSE 3
    END,
    Total_Spend DESC;


-- ============================================================
-- 15. CRITICAL-RISK CUSTOMERS DETAIL
-- ============================================================

SELECT
    Customer_ID,
    City,
    Subscription_Plan,
    Total_Spend,
    Support_Tickets,
    Satisfaction_Score,
    Days_Since_Last_Purchase,
    Risk_Score,
    Risk_Level,
    Churn
FROM customers
WHERE Risk_Level = 'Critical'
ORDER BY Risk_Score DESC, Total_Spend DESC;


-- ============================================================
-- 16. HIGH & CRITICAL-RISK CUSTOMERS BY CITY
-- ============================================================

SELECT
    City,
    COUNT(*) AS high_critical_customers
FROM customers
WHERE Risk_Level IN ('High', 'Critical')
GROUP BY City
ORDER BY high_critical_customers DESC;


-- ============================================================
-- 17. TOTAL CUSTOMER SPEND
-- ============================================================

SELECT
    ROUND(SUM(Total_Spend), 2) AS total_customer_spend
FROM customers;


-- ============================================================
-- 18. AVERAGE CUSTOMER SATISFACTION
-- ============================================================

SELECT
    ROUND(AVG(Satisfaction_Score), 2) AS average_satisfaction
FROM customers;


-- ============================================================
-- 19. HIGH-VALUE CUSTOMERS AT RISK
-- ============================================================

SELECT
    COUNT(*) AS high_value_customers_at_risk
FROM customers
WHERE Customer_Segment = 'High Value'
  AND Risk_Level IN ('High', 'Critical');


-- ============================================================
-- 20. HIGH-VALUE CUSTOMERS AT RISK - DETAIL
-- ============================================================

SELECT
    Customer_ID,
    City,
    Subscription_Plan,
    Total_Spend,
    Satisfaction_Score,
    Days_Since_Last_Purchase,
    Risk_Level,
    Churn
FROM customers
WHERE Customer_Segment = 'High Value'
  AND Risk_Level IN ('High', 'Critical')
ORDER BY Total_Spend DESC;


-- ============================================================
-- 21. CHURN BY AGE GROUP
-- ============================================================

SELECT
    Age_Group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY Age_Group
ORDER BY churn_rate DESC;


-- ============================================================
-- 22. CHURN BY GENDER
-- ============================================================

SELECT
    Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS churn_rate
FROM customers
GROUP BY Gender
ORDER BY churn_rate DESC;


-- ============================================================
-- END OF CUSTOMER 360° SQL ANALYSIS
-- ============================================================
