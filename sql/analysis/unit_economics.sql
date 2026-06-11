SELECT * FROM subscriptions;

SELECT * FROM monthly_revenue;

-- 1. computing average customer lifespan and average MRR by plan to calculate average CLV by plan
-- 2. comparing CLV to CAC to determine CLV:CAC ratio

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
