/********************************************************************************************
 WARNING: 
 This stored procedure will truncate and reload all Bronze Layer tables in the 
 [DataWarehouse] database. Running this will result in loss of existing data 
 in those tables before reloading from source files. Use with caution in 
 production environments.

 PURPOSE: 
 This procedure [bronze].[load_bronze] automates the loading of CRM and ERP 
 source CSV files into the Bronze Layer tables. It also logs the load duration 
 for each table as well as the total batch duration.
********************************************************************************************/

USE [DataWarehouse]
GO
/****** Object:  StoredProcedure [bronze].[load_bronze]    Script Date: 17-09-2025 18:33:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [bronze].[load_bronze] 
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Loading the bronze layer...';
        PRINT '================================================';
        
        PRINT'------------------------------------';
        PRINT'Loading CRM Tables....';
        PRINT'------------------------------------';

        -- crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\lenovo\Desktop\DataWarehousProject\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>-------------------';

        -- crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\lenovo\Desktop\DataWarehousProject\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>-------------------';

        -- crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\lenovo\Desktop\DataWarehousProject\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>-------------------';


        PRINT'------------------------------------';
        PRINT'Loading ERP Tables....';
        PRINT'------------------------------------';

        -- erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\lenovo\Desktop\DataWarehousProject\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>-------------------';

        -- erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\lenovo\Desktop\DataWarehousProject\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>-------------------';

        -- erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\lenovo\Desktop\DataWarehousProject\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>-------------------';

        -- Total Layer Duration
        SET @batch_end_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '================================================';

    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT '================================================';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error Line   : ' + CAST(ERROR_LINE() AS NVARCHAR(10));
    END CATCH
END
GO
