/*****************************

3rd step , Date Exploration :->

lets find out the boundary of order date like first date of order vs last date of order 

*****************************/

-- ============================
-- CUSTOMER AGE RELATED ANALYSIS
-- ============================

SELECT
	MIN(birthdate) oldest_man,                                    -- Find the earliest birthdate (oldest customer)
	MAX(birthdate) youngest_man,                                  -- Find the latest birthdate (youngest customer)
	DATEDIFF(YEAR , MIN(birthdate) , GETDATE()) oldest_age ,      -- Calculate the current age of the oldest customer
	DATEDIFF(YEAR , MAX(birthdate) , GETDATE()) youngest_age ,    -- Calculate the current age of the youngest customer
	DATEDIFF(YEAR , MIN(birthdate) , MAX(birthdate)) age_distribution  -- Show the age difference between oldest and youngest
FROM gold.dim_customers


-- ============================
-- ORDER DATE RELATED ANALYSIS
-- ============================

SELECT
	MIN(order_date) first_order_date,                                          -- Find the very first order date
	MAX(order_date) last_order_date,                                           -- Find the most recent order date
	DATEDIFF(YEAR , MIN(order_date) , MAX(order_date)) order_lifespan_year ,   -- Difference between first and last order in years
	DATEDIFF(MONTH , MIN(order_date) , MAX(order_date)) order_lifespan_month , -- Difference in months
	DATEDIFF(DAY , MIN(order_date) , MAX(order_date)) order_lifespan_day       -- Difference in days (total span)
FROM gold.fact_sales




-- ============================
-- AVERAGE LIFESPAN OF CATEGORY
-- ============================

WITH initial AS
(
	SELECT
		p.product_key ,
		p.category,
		MIN(f.order_date) first_order_date,
		MAX(f.order_date) last_order_date,
		DATEDIFF(MONTH , MIN(f.order_date) , MAX(f.order_date)) product_lifespan_months
	FROM gold.fact_sales f
	left join gold.dim_products p
	on f.product_key = p.product_key
	WHERE order_date IS NOT NULL 
	GROUP BY p.product_key , p.category 
)

SELECT 
	category ,
	AVG(product_lifespan_months) avg_lifespan_months
FROM initial 
GROUP BY category;
GO
