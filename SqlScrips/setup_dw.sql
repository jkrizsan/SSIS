-- ==========================================
-- 1. DATABASE CREATION
-- ==========================================
CREATE DATABASE Retail_DataWarehouse;
GO

USE Retail_DataWarehouse;
GO

-- ==========================================
-- 2. TARGET TABLES (THE LOAD LAYER)
-- ==========================================
-- Dimension Table: Products
CREATE TABLE Dim_Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductSKU VARCHAR(50) NOT NULL UNIQUE,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL
);

-- Fact Table: Sales Transactions
CREATE TABLE Fact_Sales (
    FactSalesID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID VARCHAR(50) NOT NULL,
    TransactionDate DATE NOT NULL,
    ProductID INT NOT NULL, -- Will be mapped via SSIS Lookup
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    TotalPrice AS (Quantity * UnitPrice),
    CustomerEmail VARCHAR(150) NOT NULL,
    LoadDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Dim_Products(ProductID)
);

-- ==========================================
-- 3. SEED DATA FOR LOOKUP VALUE
-- ==========================================
INSERT INTO Dim_Products (ProductSKU, ProductName, Category) VALUES
('PROD-1001', 'Wireless Mouse', 'Electronics'),
('PROD-1002', 'Mechanical Keyboard', 'Electronics'),
('PROD-1003', 'USB-C Hub', 'Accessories'),
('PROD-1004', 'Ergonomic Desk Chair', 'Furniture');
GO

--Fixes
ALTER TABLE Fact_Sales ALTER COLUMN TransactionDate DATE NULL;