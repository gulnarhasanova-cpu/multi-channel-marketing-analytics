-- data_model.sql
-- Unified multi-channel marketing performance model

CREATE OR REPLACE VIEW `project-dba23f91-0adc-4db0-a7d.analytics.fact_marketing_performance` AS

SELECT 
  date,
  'Facebook' AS platform,
  CASE WHEN campaign_name = 'Traffic_Canipaign' THEN 'Traffic_Campaign' ELSE campaign_name END AS campaign_name,
  spend AS cost,
  impressions,
  clicks,
  conversions
FROM `project-dba23f91-0adc-4db0-a7d.raw_facebook_ads`

UNION ALL

SELECT 
  date,
  'Google' AS platform,
  CASE WHEN campaign_name = 'Traffic_Canipaign' THEN 'Traffic_Campaign' ELSE campaign_name END AS campaign_name,
  cost,
  impressions,
  clicks,
  conversions
FROM `project-dba23f91-0adc-4db0-a7d.raw_google_ads`

UNION ALL

SELECT 
  date,
  'TikTok' AS platform,
  CASE WHEN campaign_name = 'Traffic_Canipaign' THEN 'Traffic_Campaign' ELSE campaign_name END AS campaign_name,
  cost,
  impressions,
  clicks,
  conversions
FROM `project-dba23f91-0adc-4db0-a7d.raw_tiktok_ads`;
