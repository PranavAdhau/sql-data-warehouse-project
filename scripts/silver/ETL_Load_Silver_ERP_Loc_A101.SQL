/********************************************************************************************
 Script:       ETL_Load_Silver_ERP_Loc_A101.sql
 Purpose:      Load data into silver.erp_loc_a101
               - Cleans customer ID values
               - Standardizes country codes to readable names
               - Handles NULL or empty country codes by assigning 'n/a'
               
 WARNING:      This script will insert transformed data into [silver].[erp_loc_a101].
               Ensure the source table exists and is correct before running.
********************************************************************************************/

INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT
    REPLACE(cid, '-', ''),
    CASE 
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101;
