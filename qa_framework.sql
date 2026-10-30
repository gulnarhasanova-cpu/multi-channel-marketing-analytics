-- qa_framework.sql
-- Phase 1: Verify campaign name harmonization
SELECT DISTINCT campaign_name
FROM `project-dba23f91-0adc-4db0-a7d.analytics.fact_marketing_performance`
WHERE campaign_name LIKE '%Canipaign%'; -- Should return 0 rows

-- Phase 2: Validate calculated ratios at aggregate level
SELECT 
  platform,
  SUM(cost) AS total_spend,
  SUM(conversions) AS total_conversions,
  SAFE_DIVIDE(SUM(cost), SUM(conversions)) AS calculated_cac,
  SAFE_DIVIDE(SUM(clicks), SUM(impressions)) AS calculated_ctr
FROM `project-dba23f91-0adc-4db0-a7d.analytics.fact_marketing_performance`
GROUP BY platform;
