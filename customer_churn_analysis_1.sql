-- ============================================================================
-- CUSTOMER CHURN ANALYSIS - SQL QUERIES
-- ============================================================================

-- 1. CREATE TABLE STRUCTURE
-- ============================================================================
CREATE TABLE customer_churn (
    CustomerID VARCHAR(50) PRIMARY KEY,
    Age INT,
    Gender VARCHAR(20),
    Region VARCHAR(50),
    SubscriptionPlan VARCHAR(50),
    TenureMonths INT,
    MonthlySpend DECIMAL(10, 2),
    SupportTickets INT,
    LastLoginDaysAgo INT,
    Churn INT -- 0 = Retained, 1 = Churned
);

-- ============================================================================
-- 2. DATA OVERVIEW QUERIES
-- ============================================================================

-- Get shape: Total rows and columns
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CustomerID) AS unique_customers
FROM customer_churn;

-- Get first 10 rows
SELECT * FROM customer_churn LIMIT 10;

-- Data types and info
SELECT 
    'CustomerID' AS column_name, 'VARCHAR' AS data_type, COUNT(*) AS non_null_count
FROM customer_churn WHERE CustomerID IS NOT NULL
UNION ALL
SELECT 'Age', 'INT', COUNT(*) FROM customer_churn WHERE Age IS NOT NULL
UNION ALL
SELECT 'Gender', 'VARCHAR', COUNT(*) FROM customer_churn WHERE Gender IS NOT NULL
UNION ALL
SELECT 'Region', 'VARCHAR', COUNT(*) FROM customer_churn WHERE Region IS NOT NULL
UNION ALL
SELECT 'SubscriptionPlan', 'VARCHAR', COUNT(*) FROM customer_churn WHERE SubscriptionPlan IS NOT NULL
UNION ALL
SELECT 'TenureMonths', 'INT', COUNT(*) FROM customer_churn WHERE TenureMonths IS NOT NULL
UNION ALL
SELECT 'MonthlySpend', 'DECIMAL', COUNT(*) FROM customer_churn WHERE MonthlySpend IS NOT NULL
UNION ALL
SELECT 'SupportTickets', 'INT', COUNT(*) FROM customer_churn WHERE SupportTickets IS NOT NULL
UNION ALL
SELECT 'LastLoginDaysAgo', 'INT', COUNT(*) FROM customer_churn WHERE LastLoginDaysAgo IS NOT NULL
UNION ALL
SELECT 'Churn', 'INT', COUNT(*) FROM customer_churn WHERE Churn IS NOT NULL;

-- ============================================================================
-- 3. NULL VALUES CHECK
-- ============================================================================
SELECT 
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS CustomerID_nulls,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_nulls,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Region_nulls,
    SUM(CASE WHEN SubscriptionPlan IS NULL THEN 1 ELSE 0 END) AS SubscriptionPlan_nulls,
    SUM(CASE WHEN TenureMonths IS NULL THEN 1 ELSE 0 END) AS TenureMonths_nulls,
    SUM(CASE WHEN MonthlySpend IS NULL THEN 1 ELSE 0 END) AS MonthlySpend_nulls,
    SUM(CASE WHEN SupportTickets IS NULL THEN 1 ELSE 0 END) AS SupportTickets_nulls,
    SUM(CASE WHEN LastLoginDaysAgo IS NULL THEN 1 ELSE 0 END) AS LastLoginDaysAgo_nulls,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Churn_nulls
FROM customer_churn;

-- ============================================================================
-- 4. DESCRIPTIVE STATISTICS
-- ============================================================================
SELECT 
    ROUND(COUNT(*), 0) AS count,
    ROUND(AVG(Age), 2) AS Age_mean,
    ROUND(STDDEV(Age), 2) AS Age_std,
    MIN(Age) AS Age_min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Age) AS Age_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Age) AS Age_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Age) AS Age_75pct,
    MAX(Age) AS Age_max,
    ROUND(AVG(TenureMonths), 2) AS TenureMonths_mean,
    ROUND(STDDEV(TenureMonths), 2) AS TenureMonths_std,
    MIN(TenureMonths) AS TenureMonths_min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY TenureMonths) AS TenureMonths_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY TenureMonths) AS TenureMonths_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY TenureMonths) AS TenureMonths_75pct,
    MAX(TenureMonths) AS TenureMonths_max,
    ROUND(AVG(MonthlySpend), 2) AS MonthlySpend_mean,
    ROUND(STDDEV(MonthlySpend), 2) AS MonthlySpend_std,
    MIN(MonthlySpend) AS MonthlySpend_min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MonthlySpend) AS MonthlySpend_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY MonthlySpend) AS MonthlySpend_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MonthlySpend) AS MonthlySpend_75pct,
    MAX(MonthlySpend) AS MonthlySpend_max,
    ROUND(AVG(SupportTickets), 2) AS SupportTickets_mean,
    ROUND(STDDEV(SupportTickets), 2) AS SupportTickets_std,
    MIN(SupportTickets) AS SupportTickets_min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY SupportTickets) AS SupportTickets_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY SupportTickets) AS SupportTickets_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY SupportTickets) AS SupportTickets_75pct,
    MAX(SupportTickets) AS SupportTickets_max,
    ROUND(AVG(LastLoginDaysAgo), 2) AS LastLoginDaysAgo_mean,
    ROUND(STDDEV(LastLoginDaysAgo), 2) AS LastLoginDaysAgo_std,
    MIN(LastLoginDaysAgo) AS LastLoginDaysAgo_min,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY LastLoginDaysAgo) AS LastLoginDaysAgo_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY LastLoginDaysAgo) AS LastLoginDaysAgo_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY LastLoginDaysAgo) AS LastLoginDaysAgo_75pct,
    MAX(LastLoginDaysAgo) AS LastLoginDaysAgo_max
FROM customer_churn;

-- ============================================================================
-- 5. CHURN COUNT AND PERCENTAGE
-- ============================================================================
-- Churn count
SELECT 
    Churn,
    COUNT(*) AS count
FROM customer_churn
GROUP BY Churn
ORDER BY Churn;

-- Churn percentage
SELECT 
    Churn,
    COUNT(*) AS count,
    ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM customer_churn
GROUP BY Churn
ORDER BY Churn;

-- ============================================================================
-- 6. UNIQUE VALUES CHECK
-- ============================================================================
SELECT DISTINCT Gender FROM customer_churn;
SELECT DISTINCT SubscriptionPlan FROM customer_churn;
SELECT DISTINCT SupportTickets FROM customer_churn ORDER BY SupportTickets;
SELECT DISTINCT Region FROM customer_churn;

-- ============================================================================
-- 7. CHURN PATTERNS & CORRELATIONS
-- ============================================================================

-- Average metrics by churn status
SELECT 
    Churn,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days
FROM customer_churn
GROUP BY Churn
ORDER BY Churn;

-- ============================================================================
-- 8. CHURN ANALYSIS BY GENDER
-- ============================================================================

-- Churn count by gender
SELECT 
    Gender,
    Churn,
    COUNT(*) AS count
FROM customer_churn
GROUP BY Gender, Churn
ORDER BY Gender, Churn;

-- Churned Females - Statistics
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days,
    ROUND(STDDEV(Age), 2) AS std_age,
    ROUND(STDDEV(TenureMonths), 2) AS std_tenure_months,
    ROUND(STDDEV(MonthlySpend), 2) AS std_monthly_spend,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Age) AS age_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Age) AS age_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Age) AS age_75pct
FROM customer_churn
WHERE Gender = 'Female' AND Churn = 1;

-- Churned Males - Statistics
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days,
    ROUND(STDDEV(Age), 2) AS std_age,
    ROUND(STDDEV(TenureMonths), 2) AS std_tenure_months,
    ROUND(STDDEV(MonthlySpend), 2) AS std_monthly_spend,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Age) AS age_25pct,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Age) AS age_median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Age) AS age_75pct
FROM customer_churn
WHERE Gender = 'Male' AND Churn = 1;

-- ============================================================================
-- 9. CHURN ANALYSIS BY REGION
-- ============================================================================

-- Churn count by region
SELECT 
    Region,
    Churn,
    COUNT(*) AS count
FROM customer_churn
GROUP BY Region, Churn
ORDER BY Region, Churn;

-- South Region - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days
FROM customer_churn
WHERE Region = 'South' AND Churn = 1;

-- North Region - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days
FROM customer_churn
WHERE Region = 'North' AND Churn = 1;

-- West Region - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days
FROM customer_churn
WHERE Region = 'West' AND Churn = 1;

-- East Region - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days
FROM customer_churn
WHERE Region = 'East' AND Churn = 1;

-- ============================================================================
-- 10. CHURN ANALYSIS BY SUBSCRIPTION PLAN
-- ============================================================================

-- Churn count by plan
SELECT 
    SubscriptionPlan,
    Churn,
    COUNT(*) AS count
FROM customer_churn
GROUP BY SubscriptionPlan, Churn
ORDER BY SubscriptionPlan, Churn;

-- Basic Plan - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days,
    ROUND(STDDEV(Age), 2) AS std_age,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY TenureMonths) AS median_tenure
FROM customer_churn
WHERE SubscriptionPlan = 'Basic' AND Churn = 1;

-- Standard Plan - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days,
    ROUND(STDDEV(Age), 2) AS std_age,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY TenureMonths) AS median_tenure
FROM customer_churn
WHERE SubscriptionPlan = 'Standard' AND Churn = 1;

-- Premium Plan - Churned Customers
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlySpend), 2) AS avg_monthly_spend,
    ROUND(AVG(SupportTickets), 2) AS avg_support_tickets,
    ROUND(AVG(LastLoginDaysAgo), 2) AS avg_last_login_days,
    ROUND(STDDEV(Age), 2) AS std_age,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY TenureMonths) AS median_tenure
FROM customer_churn
WHERE SubscriptionPlan = 'Premium' AND Churn = 1;

-- ============================================================================
-- 11. KEY INSIGHTS & BUSINESS RECOMMENDATIONS QUERIES
-- ============================================================================

-- High-risk churners (inactive 30+ days)
SELECT 
    COUNT(*) AS high_risk_count,
    ROUND(AVG(MonthlySpend), 2) AS avg_spend,
    Region,
    SubscriptionPlan
FROM customer_churn
WHERE Churn = 1 AND LastLoginDaysAgo >= 30
GROUP BY Region, SubscriptionPlan
ORDER BY high_risk_count DESC;

-- Premium users analysis
SELECT 
    COUNT(*) AS premium_count,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS premium_churned,
    ROUND((SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlySpend), 2) AS avg_spend,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure
FROM customer_churn
WHERE SubscriptionPlan = 'Premium';

-- Standard plan support issues (high tickets)
SELECT 
    COUNT(*) AS count,
    ROUND(AVG(SupportTickets), 2) AS avg_tickets,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_count,
    ROUND((SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS churn_rate
FROM customer_churn
WHERE SubscriptionPlan = 'Standard';

-- Customers by segment for targeted retention
SELECT 
    Region,
    SubscriptionPlan,
    Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND((SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(TenureMonths), 2) AS avg_tenure,
    ROUND(AVG(MonthlySpend), 2) AS avg_spend
FROM customer_churn
GROUP BY Region, SubscriptionPlan, Gender
ORDER BY churn_rate DESC;
