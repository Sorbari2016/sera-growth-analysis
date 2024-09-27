-- Data Analysis in sql 

-- Retrieving the columns in the view - 'sales' created 
SELECT * 
FROM sales;

-- Important Data analytical questions

-- 1. How many transactions occurred?
SELECT COUNT(*) AS total_transaction
FROM sales; 

-- 2. What is the period covered in the analysis?
SELECT MAX(datetime) - MIN(datetime)
FROM sales;  -- The number of days between the earliest date, and the latest date = 511 days.

SELECT -- The number of year, months and days that make up 511 days 
    EXTRACT(YEAR FROM age(MAX(datetime), MIN(datetime))) AS year,
    EXTRACT(MONTH FROM age(MAX(datetime), MIN(datetime))) AS months,
    EXTRACT(DAY FROM age(MAX(datetime), MIN(datetime))) AS days
FROM sales;


-- 3. Show the transaction count by status along with percentage of total?
SELECT status,
    COUNT(*) AS count,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER ()) * 100, 2) AS perc_total
FROM sales
GROUP BY status;

-- 4. Show the monthly subscription revenue split by channel. Assume that the exchange rate NGN/USD is 950.
SELECT
    DATE_TRUNC('month', datetime) AS month,
	channel,
    ROUND(SUM(CASE WHEN currency = 'USD' THEN amount*950.0 ELSE amount END),2) AS revenue_ngn
FROM sales
GROUP BY month, channel
ORDER BY month; 

-- 4b. Which month-year had the highest revenue?= October-2022
SELECT
    month_year,
    SUM(revenue_ngn) AS total_revenue
FROM (
    SELECT
        CONCAT(TO_CHAR(DATE_TRUNC('month', datetime), 'FMMonth'), '-', EXTRACT(YEAR FROM datetime)) AS month_year,
        channel,
        ROUND(SUM(CASE WHEN currency = 'USD' THEN amount*950.0 ELSE amount END),2) AS revenue_ngn
    FROM sales
    GROUP BY EXTRACT(YEAR FROM datetime), TO_CHAR(DATE_TRUNC('month', datetime), 'FMMonth'), channel
) AS monthly_revenue
GROUP BY month_year
ORDER BY total_revenue DESC
LIMIT 1;

-- 4c. What trend do you generally notice?
-- In the top 10 month-year, only once did a month in 2022 appear, which was October-2022. 
SELECT
    month_year,
    SUM(revenue_ngn) AS total_revenue
FROM (
    SELECT
        CONCAT(TO_CHAR(DATE_TRUNC('month', datetime), 'FMMonth'), '-', EXTRACT(YEAR FROM datetime)) AS month_year,
        channel,
        ROUND(SUM(CASE WHEN currency = 'USD' THEN amount*950.0 ELSE amount END),2) AS revenue_ngn
    FROM sales
    GROUP BY EXTRACT(YEAR FROM datetime), TO_CHAR(DATE_TRUNC('month', datetime), 'FMMonth'), channel
) AS monthly_revenue
GROUP BY month_year
ORDER BY total_revenue DESC;

-- 5. Show the monthly subscription revenue split by channel.
SELECT DATE_TRUNC('month', datetime) AS month, channel, COUNT(*) AS total_txn,
COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned, 
COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed 
FROM sales
GROUP BY channel, month; 

-- 5b. Which channel has the highest rate of success?
SELECT channel 
FROM  
(SELECT channel, COUNT(*) AS total_txn,
COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful 
FROM sales
GROUP BY channel
ORDER BY total_successful DESC
LIMIT 1);

-- 5c. Which channel has the highest rate of failure?
SELECT channel 
FROM  
(SELECT channel, COUNT(*) AS total_txn,
COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed 
FROM sales
GROUP BY channel
ORDER BY total_failed DESC
LIMIT 1); -- card has both the highest rate of success, as well as the highest rate of failure.

-- 6. How many subscribers are there in total? A subscriber is a user with a successful payment.
SELECT 
COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful
FROM sales; 

SELECT COUNT(user_id) -- We can still query it this way as well 
FROM sales 
WHERE status = 'success';

-- 7. Generate a list of users showing their number of active months, total successful, abandoned, and failed transactions.
WITH user_activity AS (
    -- Step I: Get the month of each transaction and count transactions per status
    SELECT 
        user_id,
        DATE_TRUNC('month', datetime) AS active_month,
        COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
        COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,
        COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed
    FROM 
        sales
    GROUP BY 
        user_id, DATE_TRUNC('month', datetime)
),

-- Step II: Aggregate by user_id to count active months and sum transactions
user_summary AS (
    SELECT
        user_id,
        COUNT(DISTINCT active_month) AS months_active,
        SUM(total_successful) AS total_successful,
        SUM(total_abandoned) AS total_abandoned,
        SUM(total_failed) AS total_failed
    FROM
        user_activity
    GROUP BY
        user_id
)

-- Step III: Select the result
SELECT
    user_id,
    months_active,
    total_successful,
    total_abandoned,
    total_failed
FROM
    user_summary
ORDER BY
    months_active DESC;

-- 8. Identify the users with more than 1 active month without a successful transaction.
SELECT user_id 
FROM (
WITH user_activity AS (
    -- Step a: Get the month of each transaction and count transactions per status
    SELECT 
        user_id,
        DATE_TRUNC('month', datetime) AS active_month,
        COUNT(CASE WHEN status = 'success' THEN 1 END) AS total_successful,
        COUNT(CASE WHEN status = 'abandoned' THEN 1 END) AS total_abandoned,
        COUNT(CASE WHEN status = 'failed' THEN 1 END) AS total_failed
    FROM 
        sales
    GROUP BY 
        user_id, DATE_TRUNC('month', datetime)
),

-- Step b: Aggregate by user_id to count active months and sum transactions
user_summary AS (
    SELECT
        user_id,
        COUNT(DISTINCT active_month) AS months_active,
        SUM(total_successful) AS total_successful,
        SUM(total_abandoned) AS total_abandoned,
        SUM(total_failed) AS total_failed
    FROM
        user_activity
    GROUP BY
        user_id
)

-- Step c: Filter users with more than 1 active month and 0 successful transactions
SELECT
    user_id,
    months_active,
    total_successful,
    total_abandoned,
    total_failed
FROM
    user_summary
WHERE
    months_active > 1  -- More than 1 active month
    AND total_successful = 0  -- No successful transactions
ORDER BY
    months_active DESC
);
