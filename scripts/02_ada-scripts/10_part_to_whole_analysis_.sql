/*===============================================================================
    Part-to-Whole Analysis
=================================================================================

Purpose:
    - Understand how much each segment contributes to total business performance.
    - Compare metrics across different dimensions (category, country, product, etc.).
    - Identify top-performing groups and measure their business impact.
    - Useful for A/B testing, regional comparisons, and portfolio analysis.

Concept:
    - SUM() aggregates values for each group.
    - Window Function SUM() OVER() calculates overall sales across all groups.
    - Percentage contribution shows each segment’s share of total sales.

=================================================================================*/


/*===============================================================================
    Q1. Which category is contributing most sales to the business?
=================================================================================*/

SELECT 
    category,
    sales_amount,
    overall_sales,
    ROUND((CONVERT(float, sales_amount) / overall_sales) * 100, 2) AS percentage_contribution
FROM
(
    SELECT
        P.category,
        SUM(F.sales_amount) AS sales_amount,
        SUM(SUM(F.sales_amount)) OVER() AS overall_sales     -- Window function for total sales
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_products P
        ON F.product_key = P.product_key
    GROUP BY P.category                                     -- Aggregating by category
) T
ORDER BY percentage_contribution DESC;                      -- Highest contribution first
GO



/*===============================================================================
    Q2. Which sub-category is contributing most sales to the business?
=================================================================================*/

SELECT 
    subcategory,
    sales_amount,
    overall_sales,
    ROUND((CONVERT(float, sales_amount) / overall_sales) * 100, 2) AS percentage_contribution
FROM
(
    SELECT
        P.subcategory,
        SUM(F.sales_amount) AS sales_amount,
        SUM(SUM(F.sales_amount)) OVER() AS overall_sales     -- Total sales across all subcategories
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_products P
        ON F.product_key = P.product_key
    GROUP BY P.subcategory                                   -- Aggregating by subcategory
) T
ORDER BY percentage_contribution DESC;
GO



/*===============================================================================
    Q3. Which country is contributing most sales to the business?
=================================================================================*/

SELECT 
    country,
    sales_amount,
    overall_sales,
    ROUND((CONVERT(float, sales_amount) / overall_sales) * 100, 2) AS percentage_contribution
FROM
(
    SELECT
        C.country,
        SUM(F.sales_amount) AS sales_amount,
        SUM(SUM(F.sales_amount)) OVER() AS overall_sales     -- Total sales across countries
    FROM gold.fact_sales F
    LEFT JOIN gold.dim_customers C
        ON F.customer_key = C.customer_key
    GROUP BY C.country                                       -- Aggregating by country
) T
ORDER BY percentage_contribution DESC;
GO
