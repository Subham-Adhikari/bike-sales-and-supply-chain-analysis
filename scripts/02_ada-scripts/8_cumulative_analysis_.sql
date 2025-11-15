/*
    CUMULATIVE ANALYSIS
    --------------------
    These queries demonstrate how to calculate cumulative (running) totals
    for business metrics like sales amount and quantity. Cumulative analysis
    helps reveal long‑term trends — whether performance is accelerating,
    slowing down, or staying stable over time.
*/

-- View the full dataset
SELECT *
FROM gold.fact_sales;
GO


/*
    YEARLY SALES + RUNNING TOTAL
    ----------------------------
    Step 1: Aggregate total sales per YEAR using DATETRUNC.
    Step 2: Apply a window function (SUM OVER ORDER BY) to compute
            the running trend of yearly sales. This shows how
            revenue accumulates year after year.
*/
SELECT *,
       SUM(yearwise_sales_amount) OVER (ORDER BY order_date) AS trendover_year_bySalesAmount
FROM (
        SELECT
            DATETRUNC(YEAR, order_date) AS order_date,
            SUM(sales_amount) AS yearwise_sales_amount
        FROM gold.fact_sales
        WHERE order_date IS NOT NULL
        GROUP BY DATETRUNC(YEAR, order_date)
     ) AS T;


/*
    MONTHLY QUANTITY + RUNNING TOTAL
    --------------------------------
    Step 1: Aggregate the total QUANTITY per MONTH.
    Step 2: Use a cumulative SUM window to understand how
            overall quantity grows month by month.
*/
SELECT *,
       SUM(quantity) OVER (ORDER BY order_date) AS overall_growth_by_quantity
       -- AVG(quantity) OVER(ORDER BY order_date) AS overall_growth_by_quantity -- optional example
FROM (
        SELECT
            DATETRUNC(MONTH, order_date) AS order_date,
            SUM(quantity) AS quantity
        FROM gold.fact_sales
        WHERE order_date IS NOT NULL
        GROUP BY DATETRUNC(MONTH, order_date)
     ) AS T;
