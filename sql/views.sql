-- CHURN VIEWS
-- used for churn dashboard visuals

CREATE VIEW vw_plan_churn AS
SELECT plan, count(*) as total_customers, count(CASE WHEN churned = 'Yes' THEN 1 END) AS churned_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS plan_churn_rate
FROM subscriptions
GROUP BY plan;

CREATE VIEW vw_billing_cycle_churn AS
SELECT billing_cycle, count(*) as total_customers, count(CASE WHEN churned = 'Yes' THEN 1 END) AS churned_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS billing_cycle_churn_rate
FROM subscriptions
GROUP BY billing_cycle;

CREATE VIEW vw_company_size_churn AS
SELECT company_size, count(*) as total_customers, count(CASE WHEN churned = 'Yes' THEN 1 END) AS churned_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS company_size_churn_rate
FROM subscriptions
GROUP BY company_size;

CREATE VIEW vw_acquisition_channel_churn AS
SELECT acquisition_channel, count(*) as total_customers, count(CASE WHEN churned = 'Yes' THEN 1 END) AS churned_customers, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) AS acquisition_channel_churn_rate
FROM subscriptions
GROUP BY acquisition_channel;

CREATE VIEW vw_churn_reason AS
SELECT churn_reason, count(churn_reason) AS churn_count
FROM subscriptions
WHERE churn_reason IS NOT NULL
GROUP BY churn_reason;

-- REVENUE TRENDS VIEW
-- used for MRR growth analysis

CREATE VIEW vw_revenue_trends AS
WITH growth AS(
	SELECT month, total_mrr, LAG(total_mrr) OVER (ORDER BY month) AS prev_mrr
    FROM monthly_revenue
    )
    
SELECT month, total_mrr, round(((total_mrr - prev_mrr)/NULLIF(prev_mrr,0))*100, 2) as growth_pct
FROM growth;

-- PLAN CLV VIEW
-- used for CLV:CAC dashboard

CREATE VIEW vw_plan_clv_cac AS
WITH clv_derive AS(
	SELECT plan, round(AVG(datediff(churn_date, signup_date)),2) as customer_lifespan, round(AVG(monthly_revenue),2) as avg_mrr
	FROM subscriptions
	WHERE churn_date IS NOT NULL
	GROUP BY plan
    ),
derive_cac AS(
	SELECT round(AVG(customer_acquisition_cost),2) AS avg_cac
    FROM monthly_revenue
    )
    
SELECT plan,customer_lifespan, avg_mrr, round((customer_lifespan/30.44) * avg_mrr,2) AS CLV, avg_cac, round(((customer_lifespan/30.44) * avg_mrr)/avg_cac,2) AS clv_cac_ratio
FROM clv_derive
CROSS JOIN derive_cac;

-- AT-RISK CUSTOMERS VIEW
-- used for customer health dashboard

CREATE VIEW vw_at_risk_customers AS
SELECT customer_id, plan, billing_cycle, company_size, region, nps_score, feature_usage_pct,
	(CASE
		WHEN (feature_usage_pct <=50 AND nps_score <=6)
        THEN "At Risk"
        ELSE "Healthy"
	END) AS risk_status
FROM subscriptions
WHERE churned = "No";