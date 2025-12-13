# Bike Sales Supply Chain Analytics (EDA & ADA using SQL)

## Project Overview
This project focuses on analyzing bike sales supply chain data using **pure SQL (T-SQL on MS SQL Server)**.  
The objective is to transform raw transactional data into **business-ready analytical views** that support dashboards, fast insights, and decision-making.

The project covers both **Exploratory Data Analysis (EDA)** and **Advanced Data Analysis (ADA)** and is designed to reflect how analytics is performed in a real company environment.

---

## Business Context
- **Domain:** Bike Sales & Supply Chain Analytics  
- **Target Audience:** Business stakeholders and dashboard users  
- **Primary Use Case:**  
  Enable quick insight discovery, performance monitoring, and BI dashboard consumption without additional data transformation.

---

## Dataset Summary
- Company-like mock data (realistic business structure)
- Approximately **60,000 sales records**
- Time period: **late 2010 to early 2014**
- Star schema design:
  - `fact_sales` – transactional sales data
  - `dim_products` – product master data
  - `dim_customers` – customer attributes

---

## Analysis Performed

### Exploratory Data Analysis (EDA)
- Sales trends over time (year / month level)
- Revenue and quantity distribution
- Product and category contribution analysis
- Order volume behavior
- Customer purchasing patterns

EDA was used to understand **data behavior, seasonality, and business drivers** before deriving KPIs.

---

### Advanced Data Analysis (ADA)
- Product-level performance aggregation
- Customer-level behavioral aggregation
- Revenue-based product segmentation
  - High / Mid / Low performers
- Product lifecycle analysis
- Recency analysis (time since last sale)
- Key business KPIs:
  - Average Order Revenue (AOR)
  - Average Monthly Revenue (AMR)
  - Customer reach (unique customers)
  - Order frequency

---

## Reporting Layer (Final Deliverables)

This project produces **two reusable analytical views**:

### 1. Product-Level Reporting View
- Product performance metrics
- Revenue segmentation
- Product lifespan and recency
- KPIs suitable for executive dashboards

### 2. Customer-Level Reporting View
- Customer purchasing behavior
- Order frequency and value
- Recency indicators
- Supports customer analytics and retention insights

These views act as a **semantic layer** and can be directly connected to BI tools such as **Power BI or Tableau**.

---

## Key SQL Concepts Used
- Common Table Expressions (CTEs)
- Multi-level aggregations
- Date intelligence using `DATEDIFF`
- Safe calculations using `NULLIF`
- Business KPI derivation
- Reusable view design
- Schema-based organization

---

## Why This Project Matters
- Demonstrates end-to-end analytical thinking using SQL only
- Shows ability to move from raw data to business-ready reporting
- Reflects real-world analytics workflows used in companies
- Emphasizes clarity, scalability, and dashboard readiness

---

## Intended Audience
- Data Analysts
- Business Analysts
- BI Developers
- Hiring Managers evaluating SQL and analytical skills

---

## Career Context
This project was built as part of preparing for a **first Data Analyst role after a career gap**.  
It reflects strong SQL fundamentals, business understanding, and the ability to build structured analytical outputs suitable for real organizations.

---

## Tools & Technologies
- SQL Server (T-SQL)
- Relational Data Modeling
- Analytical SQL Design

---

## Notes
- Dataset is a **company-like mock dataset** created for learning and portfolio purposes
- No real customer or company data is used
