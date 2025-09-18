/********************************************************************************************
 Script:       ETL_Load_Silver_CRM_Prd_Info.sql
 Purpose:      Load data from bronze.crm_prd_info into silver.crm_prd_info
               - Transforms product key into category and product key parts
               - Cleans product line codes into readable names
               - Ensures cost defaults to 0 when NULL
               - Calculates product end date as 1 day before the next product start date
               - Casts all dates to DATE
               
 WARNING:      This script will insert transformed data into [silver].[crm_prd_info].
               Make sure the table exists with the correct schema before running.
********************************************************************************************/

-- Insert transformed data into silver.crm_prd_info
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(
        DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) 
        AS DATE
    ) AS prd_end_dt
FROM bronze.crm_prd_info;
