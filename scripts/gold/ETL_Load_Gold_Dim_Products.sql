/********************************************************************************************
WARNING: This script will drop and recreate the [gold].[dim_products] view if it exists. 
Running this will replace the existing view definition. Use with caution in production 
environments.

PURPOSE: This script creates the Gold Layer Dimension View for Products in the 
DataWarehouse database. It enriches CRM product info with ERP category details 
from the Silver Layer and excludes historical (ended) products.
********************************************************************************************/
USE DataWarehouse;
GO

CREATE OR ALTER VIEW gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;  -- corrected column reference
