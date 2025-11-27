/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.

	2. Segments customers into categories (VIP, Regular, New) and age groups.

    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

WITH initial_data AS
(
	SELECT
		C.customer_key ,
		C.first_name , 
		C.last_name ,
		DATEDIFF(YEAR , C.birthdate , GETDATE()) customer_age ,
	    F.order_number,
		F.quantity ,
		F.product_key,
		F.sales_amount ,
		F.order_date
	FROM gold.fact_sales F
	LEFT JOIN gold.dim_customers C
	ON F.customer_key = C.customer_key
) ,
customer_level_aggregation AS
(
	SELECT
		customer_key ,
		first_name , 
		last_name ,
		customer_age ,
		COUNT(DISTINCT order_number) total_orders ,
		SUM(quantity) total_quantity ,
		COUNT(DISTINCT product_key) total_products,
		SUM(sales_amount) sales_amount ,
		DATEDIFF(MONTH , MIN(order_date) , MAX(order_date)) customer_lifespan_months
	FROM initial_data
	GROUP BY customer_key , 
			 first_name , 
			 last_name ,
			 customer_age
)

SELECT *
FROM customer_level_aggregation ;
GO



