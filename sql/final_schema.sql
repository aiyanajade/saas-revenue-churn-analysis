-- schema for subscriptions dataset
CREATE TABLE `subscriptions` (
  `customer_id` text,
  `plan` text,
  `billing_cycle` text,
  `industry` text,
  `company_size` text,
  `seats` int DEFAULT NULL,
  `monthly_revenue` double DEFAULT NULL,
  `acquisition_channel` text,
  `region` text,
  `signup_date` date DEFAULT NULL,
  `churned` text,
  `churn_date` date DEFAULT NULL,
  `churn_reason` text,
  `support_tickets_12mo` int DEFAULT NULL,
  `nps_score` int DEFAULT NULL,
  `feature_usage_pct` int DEFAULT NULL,
  `upgraded` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- schema for monthly_revenue dataset

CREATE TABLE `monthly_revenue` (
  `month` date DEFAULT NULL,
  `total_active_customers` int DEFAULT NULL,
  `new_customers` int DEFAULT NULL,
  `churned_customers` int DEFAULT NULL,
  `monthly_churn_rate_pct` double DEFAULT NULL,
  `total_mrr` double DEFAULT NULL,
  `avg_revenue_per_customer` double DEFAULT NULL,
  `customer_acquisition_cost` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
