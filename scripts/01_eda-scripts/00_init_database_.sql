/********************************************************************************************
    Project Name : Bike Sales Supply Chain Database Setup
    Description  : 
        This script creates a clean environment for the BikeSalesSupplyChainDB project.
        It checks if a previous version of the database exists, forces disconnection of 
        all users, drops the existing database, and then recreates it with a fresh schema.

    ⚠️  CAUTION :
        - This script will permanently DROP the existing 'BikeSalesSupplyChainDB' database.
        - All data inside it will be lost and cannot be recovered.
        - Execute this script only if you are sure you want to reset the environment.

    Notes :
        - Run this script in the 'master' context.
        - Requires sufficient privileges to drop and create databases.
        - All project tables will be created under the 'gold' schema.
        - When using BULK INSERT, update the file paths to match your own local directory.

    File Sections :
        1. Drop existing database (if exists)
        2. Create new database
        3. Switch to new database context
        4. Create schema 'gold'
        5. Create and load all project tables
********************************************************************************************/


/*=====================================================================================
                               1st PART — DATABASE SETUP
=====================================================================================*/

-- Switch the current context to the 'master' database.  
-- You cannot drop a database while you are using it.
USE master;
GO


/* Check if a database named 'BikeSalesSupplyChainDB' already exists
   in the system catalog. */
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikeSalesSupplyChainDB')
BEGIN
	-- Set the database to SINGLE_USER mode.
	-- This disconnects all other users and ensures only your session has access.
	-- The 'ROLLBACK IMMEDIATE' option cancels all open transactions and 
	-- disconnects users immediately.
	ALTER DATABASE BikeSalesSupplyChainDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	-- After safely disconnecting users and rolling back transactions, 
	-- drop (delete) the database completely. 
	DROP DATABASE BikeSalesSupplyChainDB;
END;
GO


-- Create a new empty database named 'BikeSalesSupplyChainDB'.
CREATE DATABASE BikeSalesSupplyChainDB;
GO

-- Switch to the newly created database.
USE BikeSalesSupplyChainDB;
GO

-- Create a new schema named 'gold' under which all project tables will be stored.
CREATE SCHEMA gold;
GO


/*=====================================================================================
                               1st PART END
=====================================================================================*/






/*=====================================================================================
                               2nd PART — TABLE CREATION
=====================================================================================*/

-- ============================================================
-- Each IF block checks if a table already exists before creating it.
-- OBJECT_ID('table_name', 'U') checks for a User Table (U = user-defined table).
-- If it exists, it is dropped first to avoid duplication errors.
-- ============================================================


-- ============================================================
-- DIMENSION TABLE: CUSTOMERS
-- ============================================================
IF OBJECT_ID ('gold.dim_customers' , 'U') IS NOT NULL 
    DROP TABLE gold.dim_customers ;
GO

CREATE TABLE gold.dim_customers
(
     customer_key      int              -- Surrogate key (primary key candidate)
    ,customer_id       varchar(50)      -- Natural key or source system ID
    ,customer_number   varchar(50)      -- Unique customer number from source
    ,first_name        varchar(50)      -- Customer's first name
    ,last_name         varchar(50)      -- Customer's last name
    ,country           varchar(50)      -- Country of residence
    ,marital_status    varchar(50)      -- Married, Single, etc.
    ,gender            varchar(50)      -- Male, Female, Other
    ,birthdate         date             -- Date of birth (date only)
    ,create_date       datetime2        -- Record creation timestamp
) ;
GO


-- ============================================================
-- DIMENSION TABLE: PRODUCTS
-- ============================================================
IF OBJECT_ID ('gold.dim_products' , 'U') IS NOT NULL 
    DROP TABLE gold.dim_products ;
GO

CREATE TABLE gold.dim_products
(
     product_key       int              -- Surrogate key (primary key candidate)
    ,product_id        int              -- Natural key from source system
    ,product_number    varchar(50)      -- Product number from source
    ,product_name      varchar(50)      -- Product name or description
    ,category_id       varchar(50)      -- Category identifier
    ,category          varchar(50)      -- Category name
    ,subcategory       varchar(50)      -- Subcategory name
    ,maintenance       varchar(50)      -- Maintenance type or info
    ,cost              int              -- Product cost
    ,product_line      varchar(50)      -- Product line or family
    ,start_date        date             -- Date when product became active
) ;
GO


-- ============================================================
-- FACT TABLE: SALES
-- ============================================================
IF OBJECT_ID ('gold.fact_sales' , 'U') IS NOT NULL 
    DROP TABLE gold.fact_sales ;
GO

CREATE TABLE gold.fact_sales
(
     order_number      varchar(50)      -- Sales order number
    ,product_key       int              -- FK referencing dim_products
    ,customer_key      int              -- FK referencing dim_customers
    ,order_date        date             -- Order date
    ,shipping_date     date             -- Shipment date
    ,due_date          date             -- Expected delivery/payment due date
    ,sales_amount      int              -- Total sale amount
    ,quantity          int              -- Quantity sold
    ,price             int              -- Unit price
) ;
GO


-- ============================================================
-- SCHEMA SUMMARY:
--   - dim_customers and dim_products are dimension tables.
--   - fact_sales is the fact table linking both via keys.
-- ============================================================


/*=====================================================================================
                               2nd PART END
=====================================================================================*/






/*=====================================================================================
                               3rd PART — DATA LOADING
=====================================================================================*/

-- ============================================================
-- BULK DATA LOAD SCRIPT FOR GOLD SCHEMA TABLES
-- ============================================================
-- This section performs a TRUNCATE followed by BULK INSERT
-- for each table in the 'gold' schema.
--
-- TRUNCATE TABLE: removes all rows quickly and resets identity values.
-- BULK INSERT: efficiently loads data from external CSV files.
--
-- ⚠️ IMPORTANT:
--   - Update the 'FROM' file paths below to match your own system location.
--   - Example: 'C:\Users\<YourName>\Documents\datasets\dim_customers.csv'
--
-- The WITH() options:
--   FIRSTROW = 2         → Skip header row in the CSV file.
--   FIELDTERMINATOR = ',' → Columns separated by commas.
--   TABLOCK               → Locks entire table during load for performance.
-- ============================================================


-- ============================================================
-- LOAD DATA INTO gold.dim_customers
-- ============================================================
TRUNCATE TABLE gold.dim_customers ;
GO

BULK INSERT gold.dim_customers
FROM 'D:\all-data-analysis-project\eda-ada-prj-1\datasets\gold.dim_customers.csv'  -- ⚠️ Replace with your file path
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
) ;
GO


-- ============================================================
-- LOAD DATA INTO gold.dim_products
-- ============================================================
TRUNCATE TABLE gold.dim_products ;
GO

BULK INSERT gold.dim_products
FROM 'D:\all-data-analysis-project\eda-ada-prj-1\datasets\gold.dim_products.csv'  -- ⚠️ Replace with your file path
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
) ;
GO


-- ============================================================
-- LOAD DATA INTO gold.fact_sales
-- ============================================================
TRUNCATE TABLE gold.fact_sales ;
GO

BULK INSERT gold.fact_sales
FROM 'D:\all-data-analysis-project\eda-ada-prj-1\datasets\gold.fact_sales.csv'  -- ⚠️ Replace with your file path
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
) ;
GO


-- ============================================================
-- END OF SCRIPT SUMMARY:
-- Each table in the 'gold' schema is truncated and reloaded
-- from the respective CSV file, ensuring fresh, clean data.
-- ============================================================

/*=====================================================================================
                               3rd PART END
=====================================================================================*/
