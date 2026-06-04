-- =========================================================================
-- DATA PIPELINE LAYER: MULTI-CHANNEL DATA UNIFICATION MODEL
-- Objective: Union platform data, standardize schemas, and calculate KPIs
-- Target Table: analytics.fact_marketing_performance
-- Developer: Gulnar
-- =========================================================================

CREATE OR REPLACE TABLE `analytics.fact_marketing_performance` AS

WITH unified_data AS (
    -- 1. Facebook Data Standardized
    SELECT
        CAST(date AS DATE) AS date,
        'Facebook' AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(ad_set_id AS STRING) AS sub_campaign_id,
        CAST(ad_set_name AS STRING) AS sub_campaign_name,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(spend AS FLOAT64) AS cost,
        CAST(conversions AS INT64) AS conversions,
        CAST(video_views AS INT64) AS video_views
    FROM `marketing_staging.raw_facebook_ads`

    UNION ALL

    -- 2. Google Data Standardized
    SELECT
        CAST(date AS DATE) AS date,
        'Google' AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(ad_group_id AS STRING) AS sub_campaign_id,
        CAST(ad_group_name AS STRING) AS sub_campaign_name,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(cost AS FLOAT64) AS cost,
        CAST(conversions AS INT64) AS conversions,
        0 AS video_views -- Native default padding for missing platform metrics
    FROM `marketing_staging.raw_google_ads`

    UNION ALL

    -- 3. TikTok Data Standardized
    SELECT
        CAST(date AS DATE) AS date,
        'TikTok' AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(adgroup_id AS STRING) AS sub_campaign_id,
        CAST(adgroup_name AS STRING) AS sub_campaign_name,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(cost AS FLOAT64) AS cost,
        CAST(conversions AS INT64) AS conversions,
        CAST(video_views AS INT64) AS video_views
    FROM `marketing_staging.raw_tiktok_ads`
)

-- Calculated Marketing Layers utilizing Zero-Division Guardrails
SELECT
    date,
    platform,
    campaign_id,
    campaign_name,
    sub_campaign_id,
    sub_campaign_name,
    impressions,
    clicks,
    cost,
    conversions,
    video_views,
    IF(impressions = 0, 0.0, clicks / impressions) AS ctr,
    IF(clicks = 0, 0.0, cost / clicks) AS cpc,
    IF(conversions = 0, 0.0, cost / conversions) AS cac,
    IF(clicks = 0, 0.0, conversions / clicks) AS conversion_rate
FROM unified_data;