create database ecomm_oct2019;

USE ecomm_oct2019;

SELECT * FROM ecomm_oct2019;

USE ecomm_oct2019;
SHOW TABLES;

-- Query 1: Total Rows
select count(*)
from ecomm_oct2019;


-- Query 2: Event Types
DESCRIBE ecomm_oct2019;

-- Query 3: Sample Data
select * from ecomm_oct2019
limit 10;

SELECT DISTINCT event_type
FROM ecomm_oct2019;

-- Query 4: Null Values
select count(*) total_rows,

SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) AS null_event_time,

SUM(CASE WHEN event_type IS NULL THEN 1 ELSE 0 END) AS null_event_type,

SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,

SUM(CASE WHEN category_id IS NULL THEN 1 ELSE 0 END) AS null_category_id,

SUM(CASE WHEN category_code IS NULL THEN 1 ELSE 0 END) AS null_category_code,

SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS null_brand,

SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,

SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,

SUM(CASE WHEN user_session IS NULL THEN 1 ELSE 0 END) AS null_user_session
FROM ecomm_oct2019;

-- Ouery 5: duplicates
SELECT event_time, event_type, product_id, user_id, user_session,
COUNT(*) cnt
FROM ecomm_oct2019
GROUP BY event_time, event_type, product_id, user_id, user_session
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT event_time, event_type, product_id, user_id, user_session
    FROM ecomm_oct2019
    GROUP BY event_time, event_type, product_id, user_id, user_session
    HAVING COUNT(*) > 1
) d;

-- duplicate rows count
SELECT SUM(cnt - 1) AS duplicate_rows
FROM (
    SELECT event_time, event_type, product_id, user_id, user_session,
    COUNT(*) cnt
    FROM ecomm_oct2019
    GROUP BY event_time, event_type, product_id, user_id, user_session
    HAVING COUNT(*) > 1
) d;

-- check duplicate sample(challenge)
SELECT * FROM ecomm_oct2019
WHERE (event_time, event_type, product_id, user_id, user_session) IN 
(
   SELECT event_time, event_type, product_id,user_id, user_session
   FROM ecomm_oct2019
   GROUP BY event_time, event_type, product_id, user_id, user_session
   HAVING COUNT(*) > 1
)
LIMIT 20;

SELECT VERSION();

SELECT event_time, event_type, product_id, user_id, user_session,
COUNT(*) cnt
FROM ecomm_oct2019
GROUP BY event_time, event_type, product_id, user_id, user_session
HAVING COUNT(*) > 1
LIMIT 10;

-- create clean table -Cleaning start
CREATE TABLE ecommerce_clean AS
SELECT *
FROM ecomm_oct2019;

SELECT COUNT(*)
FROM ecommerce_clean;

-- 2 Duplicate identification
SELECT *,
ROW_NUMBER() OVER(PARTITION BY event_time,
             event_type, product_id, user_id, user_session
ORDER BY event_time
) AS rn
FROM ecommerce_clean;

-- 3 Count Duplicates via ROW_NUMBER
SELECT COUNT(*) FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY event_time,
             event_type, product_id, user_id, user_session
ORDER BY event_time
) AS rn
FROM ecommerce_clean
) t
WHERE rn > 1;

-- 4 Create Final Deduplicated Table
CREATE TABLE ecommerce_clean_final AS
SELECT * FROM (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY event_time, event_type, product_id, user_id, user_session
ORDER BY event_time
) AS rn
FROM ecommerce_clean
) t
WHERE rn = 1;

SELECT COUNT(*)
FROM ecommerce_clean_final;

-- Exploratory Data Analysis (EDA)

-- Event Distribution Analysis
SELECT event_type, COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY event_type;

-- Unique Users by Event Type
SELECT event_type, COUNT(DISTINCT user_id) AS unique_users
FROM ecomm_oct2019
GROUP BY event_type;

-- Funnel Conversion Analysis
-- View → Cart Conversion
-- 716 / 2526 × 100 = 28.35%

-- Cart → Purchase Conversion
-- 149 / 716 × 100 = 20.81%

-- Overall Conversion
-- 149 / 2526 × 100 = 5.90%

-- Top Categories by Events
SELECT category_code, COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY category_code
ORDER BY total_events DESC
LIMIT 10;

-- Category-wise Event Breakdown
SELECT category_code, event_type,
COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY category_code, event_type
ORDER BY category_code;

-- Top brands by Events
SELECT brand, COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY brand
ORDER BY total_events DESC
LIMIT 10;

-- Top product by Events
SELECT product_id, COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY product_id
ORDER BY total_events DESC
LIMIT 10;

-- Prodcut metrics
-- Product Conversion Analysis SKIP
SELECT product_id,
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS viewed_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchased_users,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) * 100.0 /
        NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END), 0), 2) AS conversion_rate
FROM ecomm_oct2019
GROUP BY product_id
HAVING viewed_users >= 10
ORDER BY conversion_rate DESC;

-- Category Conversion Analysis
SELECT category_code,
    COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS views,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS purchases,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event_type = 'view' THEN 1 END), 0), 2) AS conversion_rate
FROM ecomm_oct2019
WHERE category_code IS NOT NULL
GROUP BY category_code
ORDER BY conversion_rate DESC;

-- Brand Conversion Analysis
SELECT brand,
    COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS views,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS purchases,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event_type = 'view' THEN 1 END), 0), 2
) AS conversion_rate
FROM ecomm_oct2019
WHERE brand IS NOT NULL
GROUP BY brand
ORDER BY conversion_rate DESC;

-- Funnel Analysis

-- Funnel users
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) AS viewed_users,
    COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchased_users
FROM ecomm_oct2019;

-- Funnel conversion
SELECT 
  ROUND(COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type='view' THEN user_id END),2) AS view_to_cart_conversion,

    ROUND(
        COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END),2) AS cart_to_purchase_conversion,

    ROUND(
        COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type='view' THEN user_id END),2) AS overall_conversion
FROM ecomm_oct2019;

-- Cart Abandonment Analysis
SELECT
    COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END) AS cart_users,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS purchased_users,
    COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END)
    -
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS abandoned_users,
    
    ROUND(
        (COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END)
        -
        COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END)) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END), 2) AS cart_abandonment_rate
FROM ecomm_oct2019;

-- Time analysis
-- Events by Day
SELECT DATE(event_time) AS event_date,
    COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY event_date
ORDER BY event_date;

-- Purchase by Day - oct data 
SELECT DATE(event_time) AS purchase_date,
    COUNT(*) AS purchases
FROM ecomm_oct2019
WHERE event_type = 'purchase'
GROUP BY purchase_date
ORDER BY purchase_date;

-- Events by Hour
SELECT HOUR(event_time) AS hour_of_day,
    COUNT(*) AS total_events
FROM ecomm_oct2019
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Purchases by Hour
SELECT HOUR(event_time) AS hour_of_day,
    COUNT(*) AS purchases
FROM ecomm_oct2019
WHERE event_type = 'purchase'
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Returning vs New Users
SELECT
    COUNT(*) AS total_users,
    SUM(CASE WHEN session_count = 1 THEN 1 ELSE 0 END) AS one_session_users,
    SUM(CASE WHEN session_count > 1 THEN 1 ELSE 0 END) AS returning_users
FROM (
    SELECT
        user_id,
        COUNT(DISTINCT user_session) AS session_count
    FROM ecomm_oct2019
    GROUP BY user_id
) t;
