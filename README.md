# 🚲 Bike Sales Supply Chain Analytics (EDA & ADA using SQL)

## 📌 Project Overview
SQL-based analytics project built using **T-SQL (MS SQL Server)** to analyze bike sales and supply chain performance.  
The project converts raw transactional data into **dashboard-ready analytical views** for fast insight generation and business decision-making.

---

## 🏢 Business Context
- **Domain:** 🚲 Bike Sales & Supply Chain Analytics  
- **Primary Consumers:** 📊 Dashboards, business users, analysts  
- **Objective:** Enable quick performance monitoring and insight discovery without additional data transformation

---

## 🗂 Dataset Summary
- Company-like mock dataset
- ~**60,000** sales records
- Data period: **late 2010 – early 2014**
- Star schema model:
  - `fact_sales`
  - `dim_products`
  - `dim_customers`

---

## 🔍 Analysis Coverage

### Exploratory Data Analysis (EDA)
- Time-based sales and revenue trends
- Category and product contribution
- Order volume and quantity distribution
- Customer purchasing patterns

### Advanced Data Analysis (ADA)
- Product and customer-level aggregations
- Revenue-based performance segmentation
- Product lifecycle and recency analysis
- KPI calculation for reporting and dashboards

---

## 📊 Demo Business Metrics (Sample Insights)

> ⚠️ *Figures shown below are representative demo values for illustration.  
Actual values will be updated based on final outputs.*

### 🔹 Overall Sales Performance
- Sales records analyzed: **~60,000**
- Total revenue generated: **~₹29.36 Million**
- Average Order Revenue (AOR): **~₹1,061**
- Average Monthly Revenue (AMR): **~₹XX,XXX**

---

### 🔹 Product Performance
- Products analyzed: **~XXX**
- High-performing products contribution: **~XX% of total revenue**
- Mid-performing products contribution: **~XX% of sales volume**
- Low-performing products: **consistent but lower revenue impact**

---

### 🔹 Product Lifecycle Metrics
- Product lifespan range: **~X – ~XX months**
- Long-lifecycle products: **higher AMR**
- Early-stage products: **faster initial revenue growth**

---

### 🔹 Recency Metrics
- Products sold in last 12 months: **~XX%**
- Recently sold products: **higher AOR**
- Dormant products: **declining monthly revenue trend**

---

### 🔹 Customer Metrics (Customer-Level View)
- Unique customers: **~18,484**
- Revenue from repeat customers: **avgerage ~1000**
  
---

## 🧱 Reporting Layer (Final Output)

Two reusable analytical views were created:

### 🧾 Product-Level View
- Revenue, quantity, and order metrics
- Product segmentation (High / Mid / Low)
- Product lifespan and recency KPIs

### 👥 Customer-Level View
- Customer order frequency and value
- Recency indicators
- Supports retention and behavioral analysis

These views act as a **semantic layer** and can be directly connected to **Power BI / Tableau**.

---

## 🛠 SQL & Analytics Techniques Used
- CTE-based transformations
- Multi-level aggregations
- Date intelligence using `DATEDIFF`
- Safe KPI calculations using `NULLIF`
- Reusable analytical view design

---

## 🎯 Why This Project
- Demonstrates SQL-only end-to-end analytics
- Focuses on metrics businesses actually track
- Built with dashboard and reporting consumption in mind
- Mirrors real-world analytics workflows

---

## 💻 Tools & Technologies
- MS SQL Server (T-SQL)
- Relational Data Modeling
- Analytical SQL Design

---

## 📝 Notes
- Dataset is a **company-like mock dataset**
