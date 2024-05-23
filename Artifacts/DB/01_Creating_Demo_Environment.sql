-- Run this script to follow along with the demo.
USE [master];
GO

-- Checking to see if our database exists and if it does drop it.
IF DATABASEPROPERTYEX ('WiredBrainCoffee','Version') IS NOT NULL
BEGIN
	ALTER DATABASE [WiredBrainCoffee] SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [WiredBrainCoffee];
END
GO

-- Make sure you have at least 1GB to follow along.
CREATE DATABASE [WiredBrainCoffee]
 ON PRIMARY 
( NAME = N'WiredBrainCoffee', FILENAME = N'C:\Pluralsight\SQLFiles\WiredBrainCoffee.mdf' ,SIZE = 100000KB , FILEGROWTH = 100000KB)
 LOG ON 
( NAME = N'WiredBrainCoffee_log', FILENAME = N'C:\Pluralsight\SQLFiles\WiredBrainCoffee_log.ldf',SIZE = 100000KB , FILEGROWTH = 100000KB)
GO


ALTER DATABASE [WiredBrainCoffee] SET RECOVERY SIMPLE;
GO

USE [WiredBrainCoffee];
GO

CREATE SCHEMA [Sales];
GO

CREATE TABLE [Sales].[SalesPersonLevel] (
	[Id] int identity(1,1) NOT NULL,
	[LevelName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesPersonLevel] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
	VALUES	('President'),
			('Manager'),
			('Senior Staff'),
			('Staff');
GO
	
CREATE TABLE [Sales].[SalesPerson] (
	[Id] int identity(1,1) NOT NULL,
	[FirstName] nvarchar(500) NOT NULL,
	[LastName] nvarchar(500) NOT NULL,
	[SalaryHr] decimal(32,2) NULL,
	[ManagerId] int NULL,
	[LevelId] int NOT NULL,
	[Email] nvarchar(500) NULL,
	[StartDate] date NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesPerson] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_SalesPersonLevel] FOREIGN KEY ([LevelId]) REFERENCES [Sales].[SalesPersonLevel] ([Id]),
	CONSTRAINT [FK_SalesPersonManagerId] FOREIGN KEY ([ManagerId]) REFERENCES [Sales].[SalesPerson] ([Id]));
GO

INSERT INTO [Sales].[SalesPerson] ([FirstName],[LastName],[SalaryHr],[ManagerId],[LevelId],[Email],[StartDate]) 
	VALUES	('Tom','Jones',300,1,1,'Tom.Jones@WiredBrainCoffee.com','1/5/2016'),
			('Sally','Smith',175,1,2,'Sally.Smith@WiredBrainCoffee.com','1/7/2018'),
			('Bill','House',100,2,3,'Bill.House@WiredBrainCoffee.com','1/8/2018'),
			('Karen','Knocks',100,2,3,'Karen.Knocks@WiredBrainCoffee.com','1/15/2017'),
			('Lisa','James',75,2,3,'Lisa.James@WiredBrainCoffee.com','6/1/2018'),
			('Kerrie','Friend',125,2,3,'Kerrie.Friend@WiredBrainCoffee.com','8/14/2018'),
			('Arun','Seker',55,2,3,'Arun.Seker@WiredBrainCoffee.com','1/14/2017'),
			('Wanda','Jones',55,2,3,'Tom.Jones@WiredBrainCoffee.com','9/1/2017'),
			('Tammy','Smith',75,2,4,'Tammy.Smith@WiredBrainCoffee.com','2/5/2018'),
			('Sarah','Smith',100,1,2,'Sarah.Smith@WiredBrainCoffee.com','2/14/2018'),
			('Emmit','Wright',95,2,3,'Emmit.Wright@WiredBrainCoffee.com','4/15/2019'),
			('Chris','Jones',55,2,4,'Chris.Jones@WiredBrainCoffee.com','2/5/2018'),
			('Cathy','Morgan',85,2,3,'Cathy.Morgan@WiredBrainCoffee.com','8/14/2018'),
			('Dion','James',75,2,3,'Dion.James@WiredBrainCoffee.com','1/7/2018'),
			('Aakash','Kumar',96,2,3,'Aakash.Kumar@WiredBrainCoffee.com','9/1/2017');
GO


CREATE TABLE [Sales].[SalesTerritoryStatus] (
	[Id] int identity(1,1) NOT NULL,
	[StatusName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesTerritoryStatus] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesTerritoryStatus] ([StatusName])
	VALUES	('Active'),
			('Closing'),
			('In Review');
GO


CREATE TABLE [Sales].[SalesTerritory] (
	[Id] int identity(1,1) NOT NULL,
	[TerritoryName] nvarchar(500) NOT NULL,
	[Group] nvarchar(500) NULL,
	[StatusId] int NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesTerritory] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_StatusId] FOREIGN KEY ([StatusId]) REFERENCES [Sales].[SalesTerritoryStatus] ([Id]));
GO

INSERT INTO [Sales].[SalesTerritory] ([TerritoryName],[Group],[StatusId]) 
	VALUES	('Northwest','North America',1),
			('Northeast','North America',1),
			('Southwest','North America',1),
			('Southeast','North America',1),
			('Canada','North America',3),
			('France','Europe',1),
			('Germany','Europe',2),
			('Australia','Pacific',2),
			('United Kingdom','Europe',3),
			('Spain','Europe',1);
GO


CREATE TABLE [Sales].[SalesOrderStatus] (
	[Id] int identity(1,1) NOT NULL,
	[StatusName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesOrderStatus] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesOrderStatus] ([StatusName])
	VALUES	('Complete'),
			('In Progress'),
			('Returned');
GO

CREATE TABLE [Sales].[SalesOrder] (
	[Id] int identity(1,1) NOT NULL,
	[SalesPerson] int NOT NULL,
	[SalesAmount] decimal(36,2) NOT NULL,
	[SalesDate] date NOT NULL,
	[SalesTerritory] int NOT NULL,
	[SalesOrderStatus] int NOT NULL,
	[OrderDescription] nvarchar(MAX) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_SalesOrder] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_SalesPerson] FOREIGN KEY ([SalesPerson]) REFERENCES [Sales].[SalesPerson] ([Id]),
	CONSTRAINT [FK_SalesTerritory] FOREIGN KEY ([SalesTerritory]) REFERENCES [Sales].[SalesTerritory] ([Id]),
	CONSTRAINT [FK_SalesOrderStatus] FOREIGN KEY ([SalesOrderStatus]) REFERENCES [Sales].[SalesOrderStatus] ([Id]));
GO


-- Itzik Ben-Gan script to generate numbers table.
DROP TABLE IF EXISTS #NumbersTable;
GO

   WITH E00(N) AS (SELECT 1 UNION ALL SELECT 1),
        E02(N) AS (SELECT 1 FROM E00 a, E00 b),
        E04(N) AS (SELECT 1 FROM E02 a, E02 b),
        E08(N) AS (SELECT 1 FROM E04 a, E04 b),
        E16(N) AS (SELECT 1 FROM E08 a, E08 b),
        E32(N) AS (SELECT 1 FROM E16 a, E16 b),
   cteTally(N) AS (SELECT ROW_NUMBER() OVER (ORDER BY N) FROM E32)
 SELECT N
   INTO #NumbersTable
   FROM cteTally
  WHERE N <= 10000;
GO



DECLARE @Count int = 0;
WHILE (@Count < 350000)
BEGIN
INSERT INTO [Sales].[SalesOrder]
		([SalesPerson]
		,[SalesAmount]
		,[SalesDate]
		,[SalesTerritory]
		,[SalesOrderStatus]
		,[OrderDescription]) 
	SELECT	ABS(CHECKSUM(NEWID()) % 15) + 1 AS SalesPerson
			,ABS(CHECKSUM(NEWID()) % 50) + 1 AS SalesAmount
			,CASE	WHEN @Count <= 25000 THEN
					DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '1/1/2016', '12/31/2016')),'1/1/2016') 
					WHEN @Count > 25000 AND @Count <= 75000 THEN
					DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '1/1/2017', '12/31/2017')),'1/1/2017') 
					WHEN @Count > 75000 AND @Count <= 150000 THEN
					DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '1/1/2018', '12/31/2018')),'1/1/2018')
					WHEN @Count > 150000 THEN
					DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '1/1/2019', '09/30/2020')),'1/1/2019')
				END AS SalesDate
			,ABS(CHECKSUM(NEWID()) % 10) + 1 AS SalesTerritory
			,ABS(CHECKSUM(NEWID()) % 3) + 1 AS SalesOrderStatus
			,'I love selling coffee' AS SalesDescription
	FROM #NumbersTable nt
	SET @Count = @Count + @@ROWCOUNT;
END
GO

-- Clean up our numbers table.
DROP TABLE IF EXISTS #NumbersTable;
GO




-- Report Builder download.
-- https://www.microsoft.com/en-us/download/details.aspx?id=53613



-- SQL Reporting Services download.
-- https://docs.microsoft.com/en-us/sql/reporting-services/install-windows/install-reporting-services?view=sql-server-ver15


-- Download the latest version of SQL Server Management Studio.
-- https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15#download-ssms