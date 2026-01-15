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




--==============
--	FROM CHATGPT
--==============
	
/*
	“Which types of customers are actually driving our revenue?”
	Can we group customers into high-value, medium-value, and low-value segments
	based on how much they spend and how often they purchase (purchase frequency)?
*/


-- Step 1: Calculate customer-level metrics
WITH customer_metrics AS
(
    SELECT
        C.customer_id,
        SUM(F.sales_amount) AS total_revenue,
        COUNT(DISTINCT F.order_number) AS purchase_frequency
    FROM gold.fact_sales F
    INNER JOIN gold.dim_customers C
        ON F.customer_key = C.customer_key
    GROUP BY C.customer_id
),

-- Step 2: Rank customers based on revenue
customer_rank AS
(
    SELECT
        customer_id,
        total_revenue,
        purchase_frequency,
        ROUND(
            CUME_DIST() OVER(ORDER BY total_revenue DESC) * 100, 0
        ) AS customer_segment_bucket
    FROM customer_metrics
),

-- Step 3: Assign value segments
customer_segment AS
(
    SELECT
        customer_id,
        total_revenue,
        purchase_frequency,
        CASE
            WHEN customer_segment_bucket <= 33 THEN 'high-value'
            WHEN customer_segment_bucket <= 66 THEN 'medium-value'
            ELSE 'low-value'
        END AS customer_segmentation
    FROM customer_rank
)

-- Step 4: Aggregate results at segment level
SELECT
    customer_segmentation,
    COUNT(customer_id) AS customer_count, -- grouping done before
    SUM(total_revenue) AS total_revenue,
    SUM(purchase_frequency) AS total_orders,
    ROUND(
        CAST(SUM(total_revenue) AS float) / SUM(SUM(total_revenue)) OVER()*100
        , 2) AS revenue_pct
FROM customer_segment
GROUP BY customer_segmentation
ORDER BY 
    CASE customer_segmentation
        WHEN 'high-value' THEN 1
        WHEN 'medium-value' THEN 2
        ELSE 3
    END;
GO



/*
    ---------
    Insights:
    ---------
    Our revenue is heavily driven by high-value customers, who make up about a third of
    our customer base but generate nearly 88% of sales. Medium-value customers contribute
    a small portion of revenue despite a similar number of orders, while low-value customers
    contribute very little. This indicates that focusing on retaining high-value customers
    and upselling medium-value customers could significantly impact overall revenue.


    ---------------
    Recommendation:
    ---------------
    Revenue is highly concentrated among high-value customers, so retention and targeted
    upselling should be our top priorities, while minimizing spend on low-value segments.



*/

--=============================================================================================================================================================
--=============================================================================================================================================================
	


/*
2. “Are different customer groups buying differently?”

Do customers with different demographics (age group, gender, marital status, country) 
show meaningful differences in purchasing behavior or revenue contribution?

***
	i did only on the basis of age group, if i want other demographic then simply change the 
	age group to desired demographics.

*/
WITH base_data AS
(
    SELECT
        F.customer_key,
        CASE
            WHEN C.birthdate IS NULL THEN 'n/a'
            WHEN (
                DATEDIFF(YEAR, C.birthdate, GETDATE())
                - CASE 
                    WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, C.birthdate, GETDATE()),
                        C.birthdate
                    ) > GETDATE()
                    THEN 1 ELSE 0
                  END
            ) > 55 THEN '55+'
            WHEN (
                DATEDIFF(YEAR, C.birthdate, GETDATE())
                - CASE 
                    WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, C.birthdate, GETDATE()),
                        C.birthdate
                    ) > GETDATE()
                    THEN 1 ELSE 0
                  END
            ) BETWEEN 46 AND 55 THEN '46-55'
            WHEN (
                DATEDIFF(YEAR, C.birthdate, GETDATE())
                - CASE 
                    WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, C.birthdate, GETDATE()),
                        C.birthdate
                    ) > GETDATE()
                    THEN 1 ELSE 0
                  END
            ) BETWEEN 36 AND 45 THEN '36-45'
            WHEN (
                DATEDIFF(YEAR, C.birthdate, GETDATE())
                - CASE 
                    WHEN DATEADD(
                        YEAR,
                        DATEDIFF(YEAR, C.birthdate, GETDATE()),
                        C.birthdate
                    ) > GETDATE()
                    THEN 1 ELSE 0
                  END
            ) BETWEEN 26 AND 35 THEN '26-35'
            ELSE '18-25'
        END AS age_group,
        F.order_number,
        F.sales_amount
    FROM gold.fact_sales F
    INNER JOIN gold.dim_customers C
        ON F.customer_key = C.customer_key
)

SELECT
    age_group,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_revenue,
	ROUND(
		CAST(SUM(sales_amount) AS float) / COUNT(DISTINCT customer_key)
		, 0) avg_revenue_per_customer,
	ROUND(
		CAST(SUM(sales_amount) AS float) / COUNT(DISTINCT order_number)
		, 0) avg_order_value --it is average amount of money each customer spends per order
FROM base_data
GROUP BY age_group
ORDER BY total_revenue DESC;
GO

/*
    ---------
    Insights:
    ---------
    Customers aged 55+ bring the highest total revenue (~$12.7M), showing strong loyalty.
    Customers aged 46–55 spend the most per person (~$1,785), making them the most valuable group.
    Customers aged 36–45 spend less on average, but they represent a clear growth opportunity.
    A small group with missing age data shows unusually high spending, which points to data quality issues.

    ---------------
    Recommendation:
    ---------------
    Focus on retaining and rewarding customers aged 46–55 with loyalty programs and premium offers.
    Keep 55+ customers engaged by making shopping easy, trustworthy, and reliable.
    Upsell customers aged 36–45 with bundles and upgrades to increase their value.
    Fix missing age data to improve personalization and ensure accurate insights.
*/







