/********************************************************************************************
WARNING: This script will drop and recreate the [gold].[dim_customers] view if it exists. 
Running this will replace the existing view definition. Use with caution in production 
environments.

PURPOSE: This script creates the Gold Layer Dimension View for Customers in the 
DataWarehouse database. It combines CRM and ERP source data from the Silver Layer 
to produce a clean dimension view for analysis.
********************************************************************************************/
USE DataWarehouse;
GO

CREATE OR ALTER VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
