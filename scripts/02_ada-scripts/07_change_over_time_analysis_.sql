

-- Changes over time analysis :->
/*
	Analyze how a measure evolves over time . Helps track trends and seasonality
	of our data.
*/



-- 01. Analyze the sales performance over time (year , month or day) :->


-- only year basis
SELECT
	YEAR(order_date) yearly_basis ,
	SUM(sales_amount) sales_amount
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY YEAR(order_date)
ORDER BY yearly_basis ;
GO


-- month & year basis
SELECT
	YEAR(order_date) yearly_basis ,
	MONTH(order_date) yearly_basis ,
	SUM(sales_amount) sales_amount
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY YEAR(order_date) , MONTH(order_date)
ORDER BY 1,2 ;
GO

-- OR ,

-- IT IS BETTER THAN YEAR + MONTH
SELECT
	DATETRUNC(MONTH ,order_date) yearly_basis ,
	SUM(sales_amount) sales_amount
FROM gold.fact_sales 
WHERE order_date IS NOT NULL 
GROUP BY DATETRUNC(MONTH ,order_date)
ORDER BY 1,2 ;
GO
