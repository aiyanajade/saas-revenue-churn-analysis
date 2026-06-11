SELECT * FROM monthly_revenue;

SELECT * FROM subscriptions;

-- monthly MRR over time

SELECT month, total_mrr
FROM monthly_revenue
ORDER BY month;

-- Calculating Net Revenue Retention
WITH signupmrr AS (
	SELECT date_format(signup_date, '%Y-%m-01') as month, round(sum(monthly_revenue),2) as new_mrr
	FROM subscriptions
	GROUP BY month
    ),

churnmrr as( 
	SELECT date_format(churn_date, '%Y-%m-01') as month, round(sum(monthly_revenue),2) as churned_mrr
	FROM subscriptions
	WHERE churned = 'Yes'
	GROUP BY month
    )

SELECT *, round((new_mrr - churned_mrr),2) as nrr
FROM signupmrr as s
LEFT JOIN churnmrr as c
ON s.month = c.month
ORDER BY nrr;

-- Calculating month on month growth percent for identifying unusual spikes or dips

WITH growth AS(
	SELECT month, total_mrr, LAG(total_mrr) OVER (ORDER BY month) AS prev_mrr
    FROM monthly_revenue
    )

SELECT month, round(((total_mrr - prev_mrr)/NULLIF(prev_mrr,0))*100, 2) as growth_pct
FROM growth
ORDER BY growth_pct;