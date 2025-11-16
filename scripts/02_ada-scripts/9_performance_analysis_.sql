/*
	Performance Analysis :-> (YOY & MOM analysis)

	Comparing the current value with a target value helps measure success 
	and understand performance shifts over time.
*/

/*
	Goal:
	Analyze the yearly performance of each product by comparing:
	1) Current year's sales
	2) Product's overall average sales
	3) Previous year's sales (YoY trend)
*/

WITH initial_data AS
-- Stage 1: Aggregate raw sales data to yearly sales per product
(
	SELECT
		DATETRUNC(YEAR, F.order_date) AS order_date_year,   -- Extract year
		P.product_name,                                     -- Product name
		SUM(F.sales_amount) AS current_sales_amount         -- Total yearly sales
	FROM gold.fact_sales F
	LEFT JOIN gold.dim_products P 
		ON F.product_key = P.product_key
	WHERE F.order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, F.order_date), P.product_name
),

ready_for_analysis AS
-- Stage 2: Apply window functions for comparisons and trends
(
	/*
		Note:
		Products can appear across multiple years.
		Partitioning must be done using product_name to calculate 
		product-specific averages and year-to-year changes.
	*/
	SELECT
		product_name,
		order_date_year,
		current_sales_amount,

		-- Average yearly sales for this product (lifetime average)
		AVG(current_sales_amount) OVER(
			PARTITION BY product_name
		) AS avg_sales,

		-- Previous year's sales (YoY comparison)
		LAG(current_sales_amount) OVER(
			PARTITION BY product_name 
			ORDER BY order_date_year
		) AS previous_sales_amount
	FROM initial_data
)

-- Final query: classify and interpret performance
SELECT
	product_name,
	order_date_year,
	current_sales_amount,

	-- Segment based on comparison with average performance
	CASE
		WHEN current_sales_amount > avg_sales THEN 'Above average'
		WHEN current_sales_amount < avg_sales THEN 'Below average'
		ELSE 'Average sales'
	END AS avg_sales_segmentation,

	/*
		Interpret sales trends compared to previous year:
		- If previous year doesn't exist → first recorded year
		- Otherwise compare current vs previous
	*/
	CASE
		WHEN previous_sales_amount IS NULL THEN 'First-year sales' 
		WHEN current_sales_amount > previous_sales_amount THEN 'Sales increased'
		WHEN current_sales_amount < previous_sales_amount THEN 'Sales decreased'
		ELSE 'No change in sales'
	END AS sales_trend

FROM ready_for_analysis
ORDER BY product_name, order_date_year;

GO
