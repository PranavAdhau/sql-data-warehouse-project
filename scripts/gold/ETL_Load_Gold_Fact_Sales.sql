/********************************************************************************************
WARNING: This script will drop and recreate the [gold].[fact_sales] view if it exists. 
Running this will replace the existing view definition. Use with caution in production 
environments.

PURPOSE: This script creates the Gold Layer Fact View for Sales in the 
DataWarehouse database. It joins CRM sales details with Customer and Product 
dimensions from the Gold Layer for analytical reporting.
********************************************************************************************/
USE DataWarehouse;
GO

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id; 
