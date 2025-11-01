/********************************************************************************************
    Script Name  : Database Exploration
    Description  : 
        This script helps explore the structure of the database. 
        It retrieves a list of all available tables and detailed metadata 
        (column names, data types, and constraints) for specific tables.

    Purpose :
        - Understand database structure and schema organization.
        - Inspect individual table definitions and their columns.
    
    System Views Used :
        - INFORMATION_SCHEMA.TABLES   → Provides list of tables and views.
        - INFORMATION_SCHEMA.COLUMNS  → Provides column-level metadata.

    Notes :
        - Replace 'fact_sales' with the desired table name to inspect its columns.
        - Optionally, filter by schema using: AND TABLE_SCHEMA = 'gold'

********************************************************************************************/


/*=========================================================================================
   1. Retrieve a list of all tables and views in the current database
=========================================================================================*/

SELECT 
    TABLE_CATALOG       AS [Database_Name],
    TABLE_SCHEMA        AS [Schema_Name],
    TABLE_NAME          AS [Table_Name],
    TABLE_TYPE          AS [Object_Type]   -- 'BASE TABLE' or 'VIEW'
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO



/*=========================================================================================
   2. Retrieve column metadata for a specific table
   - Modify the WHERE clause to explore other tables as needed
=========================================================================================*/

SELECT 
    TABLE_SCHEMA                AS [Schema_Name],
    TABLE_NAME                  AS [Table_Name],
    COLUMN_NAME                 AS [Column_Name],
    DATA_TYPE                   AS [Data_Type],
    IS_NULLABLE                 AS [Nullable],
    CHARACTER_MAXIMUM_LENGTH    AS [Max_Length]
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
-- AND TABLE_SCHEMA = 'gold'   -- Uncomment to narrow by schema
ORDER BY ORDINAL_POSITION;
GO
