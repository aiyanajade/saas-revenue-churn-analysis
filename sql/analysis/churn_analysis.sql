SELECT * FROM subscriptions;

-- overall churn rate = 52.17%

SELECT round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS overall_churn_rate
FROM subscriptions;

-- churn rate by plan

SELECT plan, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS plan_churn_rate
FROM subscriptions
GROUP BY plan
ORDER BY plan_churn_rate DESC;

-- churn rate by billing_cycle

SELECT billing_cycle, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS bcycle_churn_rate
FROM subscriptions
GROUP BY billing_cycle
ORDER BY bcycle_churn_rate DESC;

-- churn rate by acquisition_channel

SELECT acquisition_channel, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS ac_churn_rate
FROM subscriptions
GROUP BY acquisition_channel
ORDER BY ac_churn_rate DESC;

-- churn rate by company_size

SELECT company_size, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS csize_churn_rate
FROM subscriptions
GROUP BY company_size
ORDER BY csize_churn_rate DESC;

-- popular reasons for churn

SELECT churn_reason, count(churn_reason) AS CNT
FROM subscriptions
WHERE churn_reason IS NOT NULL
GROUP BY churn_reason
ORDER BY CNT DESC;

-- finding highest risk segments through churn rate by plan and billing cycle

SELECT plan, billing_cycle, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS churn_rate
FROM subscriptions
GROUP BY plan, billing_cycle
ORDER BY churn_rate DESC;

-- finding highest risk segments through churn rate by plan and company_size

SELECT plan, company_size, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS churn_rate
FROM subscriptions
GROUP BY plan, company_size
ORDER BY churn_rate DESC;

-- finding highest risk segments through churn rate by plan and acquisition_channel

SELECT plan, acquisition_channel, count(*) as total_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS churn_rate
FROM subscriptions
GROUP BY plan, acquisition_channel
ORDER BY churn_rate DESC;
