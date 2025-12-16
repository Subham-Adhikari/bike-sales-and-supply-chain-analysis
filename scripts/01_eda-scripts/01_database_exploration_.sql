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




/********************************************************************************************
    Extra  : Combined Database Structure Overview
    Description  : 
        This query combines INFORMATION_SCHEMA.TABLES and INFORMATION_SCHEMA.COLUMNS 
        to show both table-level and column-level metadata in a single result set.

    Purpose :
        - Explore table details and their columns together.
        - Useful for quick schema inspection or documentation.
    
    System Views Used :
        - INFORMATION_SCHEMA.TABLES   → Contains list of all tables and views.
        - INFORMATION_SCHEMA.COLUMNS  → Contains column details for each table.

    Notes :
        - Replace 'fact_sales' with any table name you want to inspect.
        - You can remove the WHERE clause to list all tables and their columns.
********************************************************************************************/
    
SELECT
    T.TABLE_CATALOG            database_name        , 
    T.TABLE_SCHEMA             schema_name          ,
    T.TABLE_NAME               table_name           ,
    T.TABLE_TYPE               object_type          ,
    C.COLUMN_NAME              column_name          ,
    C.IS_NULLABLE              is_null              ,
    C.DATA_TYPE                data_type            ,
    C.CHARACTER_MAXIMUM_LENGTH character_max_length 
FROM INFORMATION_SCHEMA.TABLES  T
INNER JOIN 
     INFORMATION_SCHEMA.COLUMNS C
ON 
    T.TABLE_CATALOG = C.TABLE_CATALOG AND
    T.TABLE_SCHEMA  = C.TABLE_SCHEMA  AND
    T.TABLE_NAME    = C.TABLE_NAME
WHERE 
    T.TABLE_NAME   = 'fact_sales' --AND -- to check individual table informations.
    --T.TABLE_SCHEMA = 'gold' -- optional for schema level filtering 
ORDER BY
    database_name , schema_name , table_name ;
GO

