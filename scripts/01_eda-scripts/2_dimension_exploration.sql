-- ============================================================================
-- STEP 2: DIMENSION EXPLORATION
-- Purpose: To understand the granularity and distinct values within each 
-- dimension table (customers and products). 
-- This helps us identify the level of detail available in our data model 
-- and ensures consistency across joins in later stages.
-- ============================================================================


-- ============================================================
-- Check unique countries from the customer dimension table
-- This shows the geographical distribution of customers
-- ============================================================
SELECT DISTINCT 
	country  -- Geographical spread of our customers
FROM gold.dim_customers 
WHERE country IS NOT NULL;
GO


-- ============================================================
-- Inspect all columns from the product dimension table
-- Helps us understand available attributes for products
-- ============================================================
SELECT * 
FROM gold.dim_products;


-- ============================================================
-- Check if product names are unique in the products table
-- Ensures that each product name represents one unique product
-- ============================================================
SELECT COUNT(DISTINCT PRODUCT_NAME) 
FROM gold.dim_products;
GO


-- ============================================================
-- Explore product categories
-- Reveals how the business is divided into high-level segments
-- ============================================================
SELECT DISTINCT	
	category  -- Business divided into 4 main categories
FROM gold.dim_products
WHERE category IS NOT NULL;
GO


-- ============================================================
-- Explore product subcategories
-- Subcategories provide a more granular view under each category
-- ============================================================
SELECT DISTINCT	
	subcategory
FROM gold.dim_products
WHERE subcategory IS NOT NULL;
GO


-- ============================================================
-- Count distinct subcategories under each category
-- GROUP BY already implies DISTINCT, so no need for additional DISTINCT
-- This shows how diverse each product category is
-- ============================================================
SELECT	
	category , 
	COUNT(DISTINCT subcategory) AS distinct_subcategories
FROM gold.dim_products
GROUP BY category  
HAVING category IS NOT NULL;


-- ============================================================
-- Explore the full hierarchy: category → subcategory → product
-- Helps validate relationships and confirm product uniqueness within hierarchy
-- ============================================================
SELECT DISTINCT	
	category ,
	subcategory ,
	product_name
FROM gold.dim_products
WHERE category IS NOT NULL;
