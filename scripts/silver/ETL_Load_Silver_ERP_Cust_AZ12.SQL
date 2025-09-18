/********************************************************************************************
 Script:       ETL_Load_Silver_ERP_Cust_AZ12.sql
 Purpose:      Load data into silver.erp_cust_az12
               - Cleans customer ID (removes NAS prefix if present)
               - Validates birthdate (sets NULL if date is in the future)
               - Standardizes gender values to 'Male', 'Female', or 'n/a'
               
 WARNING:      This script will insert transformed data into [silver].[erp_cust_az12].
               Ensure the source table exists and is correct before running.
********************************************************************************************/

INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;
