/*******************************************
    6th Step :-> Ranking Analysis
********************************************

FOR ALL TABLES, FIRST CHECK THE REFERENTIAL INTEGRITY.
EXAMPLE:

    SELECT customer_key 
    FROM gold.fact_sales 
    WHERE customer_key NOT IN (SELECT customer_key FROM gold.dim_customers);

*******************************************/



/*
    -------------------------------------------
                INDEX SUMMARY
    -------------------------------------------

    1. Clustered Primary Key on dim_products(product_key)
       → Defines unique identifier for each product.
       → Physically orders the table by product_key.
       → Speeds up joins and lookups from fact tables.

    2. Nonclustered Index on fact_sales(product_key)
       → Optimizes join operations with dim_products.
       → Allows SQL Server to perform index seeks instead of scans.

    3. (Optional) Clustered Columnstore Index on fact_sales
       → Designed for large analytical workloads.
       → Greatly improves aggregation and compression efficiency.

    4. Clustered Primary Key on dim_customer(customer_key)
       → Defines unique identifier for each customer.
       → Physically orders the table by customer_key.
       → Speeds up joins and lookups from fact tables.

       * Used a special stored procedure called sp_help 'table_name',
         to know if some column is nullable or not.
*/



/*******************************************
    TOP 5 PRODUCTS BY HIGHEST REVENUE
********************************************/

-- Or: Find the top 5 best-performing products.
-- (Use ASC for worst-performing products)
-- First check the integrity if all products are present in the fact (already done).

SELECT TOP 5
    P.product_name AS product_name,
    SUM(F.sales_amount) AS total_revenue
FROM gold.fact_sales AS F
JOIN gold.dim_products AS P
    ON F.product_key = P.product_key 
GROUP BY P.product_name 
ORDER BY total_revenue DESC;
GO



/*******************************************
    FLEXIBLE RANKING USING WINDOW FUNCTIONS
********************************************/

SELECT 
    product_name,
    total_revenue
FROM (
    SELECT
        P.product_name AS product_name,
        SUM(F.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(F.sales_amount) DESC) AS rank_revenue
    FROM gold.fact_sales AS F
    JOIN gold.dim_products AS P 
        ON F.product_key = P.product_key 
    GROUP BY P.product_name
) AS ranked_products
WHERE rank_revenue <= 5;
GO



/*******************************************
    5 WORST-PERFORMING PRODUCTS BY REVENUE
********************************************/

SELECT TOP 5
    P.product_name AS product_name,
    SUM(F.sales_amount) AS total_revenue
FROM gold.fact_sales AS F
JOIN gold.dim_products AS P
    ON F.product_key = P.product_key 
GROUP BY P.product_name 
ORDER BY total_revenue;
GO



/*******************************************
    TOP 10 CUSTOMERS BY TOTAL REVENUE
********************************************/

-- First checked integrity if all customers are present in the fact table.
-- Use INNER JOIN after ensuring that all customers are present in fact,
-- because it is faster.
-- We can also check the worst-performing customers.

SELECT TOP 10 WITH TIES
    C.customer_key,
    C.first_name,
    C.last_name,
    SUM(F.sales_amount) AS total_revenue
FROM gold.fact_sales AS F
JOIN gold.dim_customers AS C
    ON F.customer_key = C.customer_key
GROUP BY 
    C.customer_key,
    C.first_name,
    C.last_name
ORDER BY total_revenue DESC;
GO



/*******************************************
    TOP 3 CUSTOMERS BY TOTAL ORDERS PLACED
********************************************/

-- We can also count fewest orders placed.

SELECT TOP 10 WITH TIES
    C.customer_key,
    C.first_name,
    C.last_name,
    COUNT(DISTINCT F.order_number) AS total_orders
FROM gold.fact_sales AS F
JOIN gold.dim_customers AS C
    ON F.customer_key = C.customer_key
GROUP BY 
    C.customer_key,
    C.first_name,
    C.last_name
ORDER BY total_orders DESC;
GO
