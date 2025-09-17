/* 
====================================================================
 Script Purpose:
 This script creates a new database named 'DataWarehouse'. 
 If the database already exists, it will be dropped and recreated.
 After creation, the script sets up three schemas within the database:
 'bronze', 'silver', and 'gold'.

 WARNING:
 Running this script will drop the entire 'DataWarehouse' database 
 if it exists. All data in the database will be permanently deleted. 
 Proceed with caution.
====================================================================
*/

USE master;
GO

-- WARNING: This will drop the database if it already exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DataWarehouse')
BEGIN
    PRINT 'Dropping existing DataWarehouse database...';
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
    PRINT 'Database DataWarehouse dropped successfully.';
END
GO

-- Create new database
CREATE DATABASE DataWarehouse;
PRINT 'Database DataWarehouse created successfully.';
GO

-- Switch to the new database
USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO
PRINT 'Schema bronze created.';
GO

CREATE SCHEMA silver;
GO
PRINT 'Schema silver created.';
GO

CREATE SCHEMA gold;
GO
PRINT 'Schema gold created.';
GO
