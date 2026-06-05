# Multi-Channel Marketing Data Pipeline & Dashboard
**Candidate:** Gulnar  
**Role Application:** Middle+ Marketing Data Analyst  

This repository contains the production-ready data pipeline and quality assurance (QA) framework developed for the Improvado technical assignment. The goal of this project is to extract raw performance data from Facebook, Google, and TikTok, unify it inside a centralized data warehouse, and build an automated reporting layer.

## 🏗️ Project Architecture
1. **Extraction & Ingestion Layer:** Raw CSV data uploaded directly into a staging environment inside Google BigQuery (`marketing_staging`).
2. **Transformation & Data Modeling Layer (`data_model.sql`):** Consolidated disparate schemas, standardized metric naming conventions (e.g., standardizing `spend` vs `cost`), applied explicit data typing, and engineered downstream analytical KPIs (CTR, CPC, CAC, Conversion Rate). ## 🏗️ Project Architecture
...
2. **Transformation & Data Modeling Layer:** Enforces the target analytical schema ([`data_model.sql`](./data_model.sql)) and executes the multi-channel ETL unification pipeline. 

<details>
<summary><b>▶ Click to view production Pipeline SQL Code</b></summary>

```sql
-- =========================================================================
-- DATA PIPELINE LAYER: MULTI-CHANNEL DATA UNIFICATION MODEL
-- =========================================================================
CREATE OR REPLACE TABLE `analytics.fact_marketing_performance` AS
WITH unified_data AS (
...
3. **Data Quality Layer (`qa_framework.sql`):** A strict 3-phase automated testing framework ensuring absolute data integrity before dashboard loading.
4. **Semantic/BI Layer:** Final performance metrics exposed via Google Looker Studio for executive decision-making.

## 🛠️ Tech Stack & Tools
* **Data Warehouse:** Google BigQuery (SQL)
* **Version Control:** Git & GitHub
* **Business Intelligence:** Google Looker Studio

## 📈 Key Business Insights Found During Modeling
* **Platform Budget Dominance:** TikTok accounts for the highest media spend allocation across the datasets ($74,266.70), followed by Google ($37,686.20) and Facebook ($18,292.00).
* **Data Integrity Note:** During the semantic QA phase, instances were flagged where ad spend occurred with 0 recorded clicks on specific platform days, which highlights tracking or attribution gaps that should be addressed with the engineering team.
