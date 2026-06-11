-- CLEANING SUBSCRIPTIONS DATASET

SELECT * FROM rcanalysis.subscriptions;

-- converting signup_date datatype from text to date

SELECT STR_TO_DATE(signup_date, '%Y-%m-%d') AS signup_date
FROM subscriptions;

ALTER TABLE subscriptions
MODIFY COLUMN signup_date DATE;

-- converting churn_date datatype from text to date after handling blank values by replacing them with NULL

SELECT str_to_date(churn_date, '%Y-%m-%d') AS churn_date
FROM subscriptions;

SELECT churn_date
FROM subscriptions
WHERE churn_date IS NOT NULL
  AND STR_TO_DATE(churn_date, '%Y-%m-%d') IS NULL;
  
SELECT length(churn_date)
FROM subscriptions
WHERE churn_date IS NOT NULL
  AND STR_TO_DATE(churn_date, '%Y-%m-%d') IS NULL;
  
UPDATE subscriptions
SET churn_date = NULL
WHERE churn_date = '';

ALTER TABLE subscriptions
MODIFY COLUMN churn_date DATE;

-- replacing blanks in churn_reason with NULL
 
SELECT churn_reason
FROM subscriptions
WHERE churn_reason = '';

UPDATE subscriptions
SET churn_reason = NULL
WHERE churn_reason = '';

-- checking for NULLs and duplicates (found none)

SELECT customer_id
FROM subscriptions
WHERE customer_id IS NULL;

SELECT customer_id, count(*) as cnt
FROM subscriptions
GROUP BY customer_id
having cnt > 1;

-- CLEANING MONTHLY_REVENUE DATASET

SELECT * FROM rcanalysis.monthly_revenue;

-- converting month datatype from text to date

SELECT STR_TO_DATE(CONCAT(month,'-01'), '%Y-%m-%d') AS revenue_month
FROM monthly_revenue;

UPDATE monthly_revenue
SET month = STR_TO_DATE(CONCAT(month,'-01'), '%Y-%m-%d');

ALTER TABLE monthly_revenue
MODIFY COLUMN month DATE;

-- checking for duplicates and NULLs (found none)

SELECT month, count(*) AS cnt
FROM monthly_revenue
GROUP BY month
having cnt > 1;

SELECT month
FROM monthly_revenue
WHERE month IS NULL;