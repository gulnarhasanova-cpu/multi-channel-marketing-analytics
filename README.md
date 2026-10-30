# Multi-Channel Marketing Analytics Pipeline & Dashboard

## Overview
An end-to-end data pipeline and Looker Studio dashboard built in Google BigQuery. It unifies marketing campaign data across Facebook, Google, and TikTok to track performance for full-funnel real estate advertising campaigns.

## Key Performance Results
* **Total Ad Spend:** $130,244.90
* **Total Impressions:** 40.5M
* **Total Clicks:** 688.3K
* **Total Conversions:** 13,363
* **Blended CAC:** $9.75

## Channel Efficiency Highlights
* **Facebook:** Highest efficiency with a CAC of ~$7.64 (capturing 14% of spend).
* **Google:** Balanced reach and high intent with a CAC of ~$8.93 (Brand Search CTR > 5%).
* **TikTok:** Driven broad top-of-funnel reach with 10.5M impressions on influencer campaigns (57% budget share).

## Data Hygiene & Architecture
* **Data Cleansing:** Resolved string anomalies (e.g., `Traffic_Canipaign`) via SQL `CASE` statements.
* **Ratio Aggregations:** Enforced non-additive metric guardrails using `SUM(cost)/SUM(conversions)` for CAC and `SUM(clicks)/SUM(impressions)` for CTR to prevent mathematical aggregation errors.
