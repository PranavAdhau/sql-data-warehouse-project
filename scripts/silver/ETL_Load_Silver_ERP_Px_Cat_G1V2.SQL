/********************************************************************************************
 Script:   ETL_Load_Silver_ERP_Px_Cat_G1V2.sql
 Purpose:  Load data into silver.erp_px_cat_g1v2
           from bronze.erp_px_cat_g1v2
 WARNING:  This script inserts data into [silver].[erp_px_cat_g1v2].
********************************************************************************************/

INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;
