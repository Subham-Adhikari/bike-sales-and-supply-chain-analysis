/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Data segmentation means dividing data into groups or buckets.
    - These groups help you analyse patterns more easily.
    - Example: Grouping by cost ranges, customer categories, or regions.

Why we do segmentation:
    - To understand trends in each group.
    - To compare performance between segments.
    - To see correlations between measures (example: cost vs number of products).

SQL Functions Used:
    - CASE: Used to create custom categories or "segments".
    - GROUP BY: Used to group data based on the segments created.

===============================================================================
*/


-- Q. Segment products into cost ranges and count how many products fall into each segment ?

SELECT 
    cost_segment ,
    COUNT(product_name) total_products
FROM
(
    SELECT
        product_name ,
        cost ,
        CASE
            WHEN cost > 1000                   THEN 'Above 1000'
            WHEN cost >= 500 AND cost <= 1000  THEN 'Between 500 and 1000'
            WHEN cost >= 100 AND cost < 500    THEN 'Between 100 and 499'
            ELSE 'Below 100'
        END cost_segment
    FROM gold.dim_products 
)t
GROUP BY cost_segment
ORDER BY total_products DESC ;
GO




-- Q.
/*
    Objective:
        Divide customers into 3 categories based on how long they have been buying
        and how much they have spent.

    Segmentation Rules:
        - VIP:
            * Customer history: At least 12 months
            * Spending: More than €5,000
        
        - Regular:
            * Customer history: At least 12 months
            * Spending: €5,000 or less
        
        - New:
            * Customer history: Less than 12 months

    Final Goal:
        Count how many customers fall into each of these 3 groups.
*/

WITH customer_lifespan_sales AS
(
	SELECT 
		C.customer_key ,
		-- Getting total sales of each customer
		SUM(F.sales_amount) sales_amount ,

		-- Calculating how many months a customer has been active
		DATEDIFF(MONTH , MIN(F.order_date) , MAX(F.order_date)) customer_lifespan_months
	FROM gold.fact_sales F
	LEFT JOIN gold.dim_customers C
	ON F.customer_key = C.customer_key
	GROUP BY C.customer_key 
) ,

customer_segmented AS 
(
	SELECT
		customer_key , sales_amount , customer_lifespan_months ,
		CASE
			WHEN customer_lifespan_months >= 12 AND sales_amount > 5000  THEN 'VIP'
			WHEN customer_lifespan_months >= 12 AND sales_amount <= 5000 THEN 'Regular'
			ELSE 'New'
		END customer_segmentation
	FROM customer_lifespan_sales
)


SELECT
	customer_segmentation ,
	COUNT(customer_key) total_customers 
FROM customer_segmented
GROUP BY customer_segmentation
ORDER BY total_customers DESC ; 
GO
