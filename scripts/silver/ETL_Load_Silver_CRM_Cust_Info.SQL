/********************************************************************************************
 WARNING: 
 This script will insert cleaned and deduplicated data into the [silver].[crm_cust_info] table 
 from the Bronze Layer. Running this will overwrite the table with transformed records. 
 Use with caution in production environments. 

 PURPOSE: 
 This script performs the Silver Layer load for CRM Customer Info by:
   1. Selecting the most recent record for each customer (deduplication using ROW_NUMBER).
   2. Cleaning string fields (TRIM).
   3. Standardizing gender and marital status values.
   4. Inserting data into the Silver Layer table with automatic dwh_create_date population.
********************************************************************************************/

USE DataWarehouse;

-- ============================================
-- Load Silver Layer: CRM Customer Info
-- ============================================
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id 
               ORDER BY cst_create_date DESC
           ) AS flag_last
    FROM bronze.crm_cust_info
) AS cst_recent_created_date
WHERE cst_recent_created_date.flag_last = 1
  AND cst_recent_created_date.cst_id IS NOT NULL;

-- ============================================
-- Validate Load
-- ============================================
SELECT * 
FROM silver.crm_cust_info;
