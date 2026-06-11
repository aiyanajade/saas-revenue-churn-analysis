SELECT *
FROM subscriptions;

-- analyzing relationship between NPS and churn

SELECT churned, round(AVG(nps_score),2) as avg_nps
FROM subscriptions
GROUP BY churned;

-- analyzing relationship between feature usage and churn

SELECT churned, round(AVG(feature_usage_pct),2) as avg_feature_usage
FROM subscriptions
GROUP BY churned;

-- analyzing churn to find at-risk threshold based on feature usage percentage through feature usage buckets

SELECT (
	CASE 
		WHEN feature_usage_pct < 26 THEN "0-25%"
        WHEN feature_usage_pct < 31 THEN "26-30%"
        WHEN feature_usage_pct < 36 THEN "31-35%"
        WHEN feature_usage_pct < 41 THEN "36-40%"
        WHEN feature_usage_pct < 46 THEN "41-45%"
		WHEN feature_usage_pct < 51 THEN "46-50%"
        WHEN feature_usage_pct < 76 THEN "51-75%"
        ELSE "76-100%"
        END
	) AS feature_usage_bucket, count(*) as customer, round((count(CASE WHEN churned = 'Yes' THEN 1 END)/count(*))*100,2) as churn_rate
FROM subscriptions
GROUP BY feature_usage_bucket
ORDER BY feature_usage_bucket;

-- number and percentage of at-risk customers based on 50% risk threshold of feature usage

SELECT count(*) AS at_risk_customers, round((count(*)*100)/(SELECT count(*) FROM subscriptions WHERE churned = 'No'),2) as percent_at_risk
FROM subscriptions
WHERE feature_usage_pct < 51 AND churned = 'No';