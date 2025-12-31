-- =======================================================================================================
-- 📊 CHANGES OVER TIME ANALYSIS
-- -------------------------------------------------------------------------------------------------------
-- Purpose:
-- Analyze how a measure (like sales) evolves over time.
-- This helps track trends, seasonality, and overall business growth patterns.
-- =======================================================================================================


-- 01️⃣. SALES PERFORMANCE OVER TIME (Year, Month, or Day)
-- -------------------------------------------------------------------------------------------------------
-- Example 1: Yearly analysis
-- This query aggregates total sales per year.
-- Good for observing long-term growth trends.
-- -------------------------------------------------------------------------------------------------------
SELECT
	YEAR(order_date) AS yearly_basis,            -- Extracts the year from order_date
	SUM(sales_amount) AS sales_amount            -- Total sales in that year
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY YEAR(order_date)
ORDER BY yearly_basis;                          -- Sorts chronologically by year
GO


-- -------------------------------------------------------------------------------------------------------
-- Example 2: Month + Year analysis
-- Breaks sales down further by both year and month.
-- Useful for monthly trend visualization within each year.
-- -------------------------------------------------------------------------------------------------------
SELECT
	YEAR(order_date) AS yearly_basis,            -- Year component
	MONTH(order_date) AS monthly_basis,          -- Month component
	SUM(sales_amount) AS sales_amount            -- Total sales per month
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY 1, 2;                                  -- Orders by year first, then by month
GO


-- -------------------------------------------------------------------------------------------------------
-- Example 3: Using FORMAT()
-- Returns date as a formatted string like '2024 Jan'
-- ⚠️ NOTE: Sorting will not be truly chronological because FORMAT() outputs text.
-- -------------------------------------------------------------------------------------------------------
SELECT
	FORMAT(order_date, 'yyyy-MMM') AS order_date,  -- Converts date to 'YYYY Month' text
	SUM(sales_amount) AS sales_amount              -- Aggregates total sales
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY order_date;                              -- Sorts alphabetically, not by actual date
GO


-- -------------------------------------------------------------------------------------------------------
-- Example 4: Using DATETRUNC()
-- ✅ BEST PRACTICE for time-series analysis.
-- Groups data cleanly by month (preserving chronological order).
-- Includes unique customer count and quantity as extra metrics.
-- -------------------------------------------------------------------------------------------------------
SELECT
	DATETRUNC(MONTH, order_date) AS yearly_basis,  -- Truncates to the first day of each month
	COUNT(DISTINCT customer_key) AS total_customers, -- Unique customers in that month
	SUM(quantity) AS quantity,                       -- Total items sold
	SUM(sales_amount) AS sales_amount_current        -- Total sales amount
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY yearly_basis;                              -- Chronological order
GO


/* --------------------------------------------------------------------------------------------------------
🧱 PERFORMANCE TIP:
Creating a nonclustered index on order_date (with quantity and sales_amount as included columns)
can significantly speed up these time-based aggregations.

Example:
CREATE NONCLUSTERED INDEX indx_factSales_orderDate 
ON gold.fact_sales(order_date)
INCLUDE (quantity, sales_amount);
-------------------------------------------------------------------------------------------------------- */






-- extra, MOM

--> how sales change over the year or over the month

WITH cte_initial AS
(
SELECT
	order_date,
	FORMAT(order_date, 'yyyy-MMM') mom_basis,
	SUM(sales_amount) current_month_sale,
	LAG(SUM(sales_amount)) OVER(ORDER BY order_date) previous_month_sale,
	-- SUM(sales_amount) - LAG(SUM(sales_amount)) OVER(ORDER BY order_date) changes_from_previous_month,
	CASE
		WHEN
			SUM(sales_amount) - LAG(SUM(sales_amount)) OVER(ORDER BY order_date) IS NULL OR
			SUM(sales_amount) - LAG(SUM(sales_amount)) OVER(ORDER BY order_date) = 0 
				THEN 'nutral'
		WHEN 
			SUM(sales_amount) - LAG(SUM(sales_amount)) OVER(ORDER BY order_date) < 0 
				THEN 'loss'
		ELSE 'profit'
	END changes_from_previous_month_segment
FROM gold.fact_sales
WHERE order_date IS NOT NULL AND YEAR(order_date) IN ('2011', '2012', '2013')
GROUP BY order_date, FORMAT(order_date, 'yyyy-MMM')
)

SELECT
	changes_from_previous_month_segment,
	COUNT(changes_from_previous_month_segment) howManyTimesProfitOrLoss
FROM cte_initial
GROUP BY changes_from_previous_month_segment;
GO
