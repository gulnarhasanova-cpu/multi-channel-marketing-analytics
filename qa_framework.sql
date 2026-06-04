-- =========================================================================
-- DATA QUALITY LAYER: 3-PHASE AUTOMATED QA FRAMEWORK
-- Objective: Mathematically guarantee zero data loss, leakages, or anomalies
-- Developer: Gulnar
-- =========================================================================

-- -------------------------------------------------------------------------
-- PHASE 1: INGESTION SANITY CHECK
-- Target: Staging Data Ingestion Verification
-- Expected Results: FB: 110 rows ($18,292) | GG: 110 rows ($37,686.2) | TT: 110 rows ($74,266.7)
-- -------------------------------------------------------------------------
SELECT 
  'Facebook' AS platform, 
  COUNT(*) AS row_count, 
  SUM(CAST(spend AS FLOAT64)) AS total_spend_or_cost 
FROM `marketing_staging.raw_facebook_ads`

UNION ALL

SELECT 
  'Google' AS platform, 
  COUNT(*) AS row_count, 
  SUM(CAST(cost AS FLOAT64)) AS total_spend_or_cost 
FROM `marketing_staging.raw_google_ads`

UNION ALL

SELECT 
  'TikTok' AS platform, 
  COUNT(*) AS row_count, 
  SUM(CAST(cost AS FLOAT64)) AS total_spend_or_cost 
FROM `marketing_staging.raw_tiktok_ads`;


-- -------------------------------------------------------------------------
-- PHASE 2: PIPELINE RECONCILIATION CHECK
-- Target: Source vs. Production Model Variance Test
-- Expected Success Matrix: All variances must result in exactly 0.00
-- -------------------------------------------------------------------------
WITH raw_summary AS (
  SELECT 'Facebook' AS platform, SUM(spend) AS raw_cost, SUM(clicks) AS raw_clicks FROM `marketing_staging.raw_facebook_ads`
  UNION ALL
  SELECT 'Google', SUM(cost), SUM(clicks) FROM `marketing_staging.raw_google_ads`
  UNION ALL
  SELECT 'TikTok', SUM(cost), SUM(clicks) FROM `marketing_staging.raw_tiktok_ads`
),
model_summary AS (
  SELECT 
    platform, 
    SUM(cost) AS model_cost,
    SUM(clicks) AS model_clicks
  FROM `analytics.fact_marketing_performance`
  GROUP BY platform
)
SELECT 
  r.platform,
  r.raw_cost,
  m.model_cost,
  ROUND((r.raw_cost - m.model_cost), 4) AS cost_variance,
  r.raw_clicks,
  m.model_clicks,
  (r.raw_clicks - m.model_clicks) AS clicks_variance
FROM raw_summary r
JOIN model_summary m ON r.platform = m.platform;


-- -------------------------------------------------------------------------
-- PHASE 3: BUSINESS LOGIC ANOMALY CLEANSE
-- Target: Outlier & Tracking Bug Assessment Suite
-- Expected Matrix: Zero flags. Any flags point to upstream platform reporting bugs.
-- -------------------------------------------------------------------------
SELECT
  platform,
  COUNTIF(cost < 0) AS rows_with_negative_spend,
  COUNTIF(ctr > 1.0) AS rows_with_impossible_ctr,
  COUNTIF(clicks > impressions) AS rows_where_clicks_exceed_impressions,
  COUNTIF(conversions > clicks) AS rows_where_conversions_exceed_clicks,
  COUNTIF(cost > 0 AND clicks = 0) AS rows_with_spend_but_zero_clicks
FROM `analytics.fact_marketing_performance`
GROUP BY platform;