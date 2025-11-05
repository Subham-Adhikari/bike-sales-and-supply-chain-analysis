/*
	-------------------------------------------------
	STEP 4 → MEASURES EXPLORATION
	-------------------------------------------------
	This section explores the **key business metrics**
	or **KPIs (Key Performance Indicators)** 
	that help evaluate the company’s performance.
*/

-------------------------------------------------
-- 1. TOTAL REVENUE
-------------------------------------------------
SELECT 
	SUM(sales_amount) AS total_revenue
FROM gold.fact_sales;
GO


-------------------------------------------------
-- 2. TOTAL COST OF GOODS SOLD (COGS)
-------------------------------------------------
SELECT
	SUM(cost) AS total_cogs
FROM gold.dim_products;
GO


-------------------------------------------------
-- 3. TOTAL NUMBER OF ITEMS SOLD
-------------------------------------------------
SELECT 
	SUM(quantity) AS total_items_sold
FROM gold.fact_sales;
GO


-------------------------------------------------
-- 4. HIGHEST & LOWEST SELLING PRICE
-------------------------------------------------
SELECT 
	MAX(sales_amount) AS highest_price
FROM gold.fact_sales;
GO

SELECT 
	MIN(sales_amount) AS lowest_price
FROM gold.fact_sales;
GO


-------------------------------------------------
-- 5. AVERAGE SELLING PRICE
-------------------------------------------------
SELECT 
	AVG(sales_amount) AS avg_price
FROM gold.fact_sales;
GO


-------------------------------------------------
-- 6. TOTAL NUMBER OF ORDERS
-- DISTINCT used because a single order_number 
-- can contain multiple line items.
-------------------------------------------------
SELECT 
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;
GO


-------------------------------------------------
-- 7. TOTAL NUMBER OF PRODUCTS
-- product_key is unique in product dimension.
-------------------------------------------------
SELECT 
	COUNT(product_key) AS total_products
FROM gold.dim_products;
GO


-------------------------------------------------
-- 8. TOTAL NUMBER OF CUSTOMERS
-- customer_key is unique in customer dimension.
-------------------------------------------------
SELECT 
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers;
GO


-------------------------------------------------
-- 9. TOTAL NUMBER OF CUSTOMERS WHO PLACED AN ORDER
-- DISTINCT ensures a customer counted once even if 
-- they made multiple purchases.
-------------------------------------------------
SELECT 
	COUNT(DISTINCT customer_key) AS active_customers
FROM gold.fact_sales;
GO


-------------------------------------------------
-- 10. KEY BUSINESS METRICS REPORT
-- Combines all important measures into one result.
-------------------------------------------------
SELECT 
	'total revenue' AS measure_name, 
	SUM(sales_amount) AS measure_value 
FROM gold.fact_sales 

UNION ALL

SELECT 
	'total cogs', 
	SUM(cost) 
FROM gold.dim_products

UNION ALL

SELECT 
	'gross profit', 
	(SELECT SUM(sales_amount) FROM gold.fact_sales) -
	(SELECT SUM(cost) FROM gold.dim_products)

UNION ALL

SELECT 
	'average price', 
	AVG(sales_amount) 
FROM gold.fact_sales 

UNION ALL

SELECT 
	'total no. of customers', 
	COUNT(customer_key) 
FROM gold.dim_customers 

UNION ALL

SELECT 
	'total no. of orders', 
	COUNT(DISTINCT order_number) 
FROM gold.fact_sales 

UNION ALL

SELECT 
	'total no. of products', 
	COUNT(product_key) 
FROM gold.dim_products;
GO


-------------------------------------------------
-- 11. DATA INTEGRITY CHECK
-- Finds products present in FACT but missing in PRODUCT dimension.
-------------------------------------------------
SELECT *
FROM gold.fact_sales AS F
LEFT JOIN gold.dim_products AS P
	ON F.product_key = P.product_key
WHERE P.product_key IS NULL;


-------------------------------------------------
-- 12. PRODUCTS NOT YET SOLD
-- Finds items that exist in PRODUCT table 
-- but do not appear in FACT table.
-------------------------------------------------
SELECT
	SUM(P.cost) AS unsold_product_cost
FROM gold.dim_products AS P
LEFT JOIN gold.fact_sales AS F
	ON P.product_key = F.product_key
WHERE F.product_key IS NULL;


-------------------------------------------------
-- 13. PER CUSTOMER PURCHASE SUMMARY
-- Shows total spending by each customer 
-- from highest to lowest.
-------------------------------------------------
SELECT
	C.customer_key,
	C.customer_id,
	C.customer_number,
	C.first_name,
	C.last_name,
	SUM(F.sales_amount) AS total_purchase_amount
FROM gold.fact_sales AS F
LEFT JOIN gold.dim_customers AS C
	ON F.customer_key = C.customer_key
GROUP BY 
	C.customer_key,
	C.customer_id,
	C.customer_number,
	C.first_name,
	C.last_name
ORDER BY total_purchase_amount DESC;
GO


-------------------------------------------------
-- 14. CATEGORY-WISE TOTAL SALES
-- Shows sales distribution by product category.
-- Can also group by product name, subcategory, etc.
-------------------------------------------------
SELECT
	P.product_key,
	P.product_id,
	P.product_number,
	P.category,
	SUM(F.sales_amount) AS total_sales
FROM gold.fact_sales AS F
LEFT JOIN gold.dim_products AS P
	ON F.product_key = P.product_key
GROUP BY 
	P.product_key,
	P.product_id,
	P.product_number,
	P.category
ORDER BY total_sales DESC;
GO
