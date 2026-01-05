CREATE TABLE Tb_Products_Null (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    BasePrice DECIMAL(10,2) NULL,
    SalePrice DECIMAL(10,2) NULL,
    UnitsInStock INT NULL
);

-- Insert sample records
INSERT INTO Tb_Products_Null (ProductName, BasePrice, SalePrice, UnitsInStock)
VALUES
('Laptop', 1200.00, 1100.00, 50),   -- SalePrice present
('Mouse', 25.00, NULL, 200),        -- SalePrice missing → fallback to BasePrice
('Keyboard', 45.00, NULL, 150),     -- SalePrice missing
('Monitor', NULL, NULL, 80),        -- Both missing → fallback to 0
('Printer', 150.00, 140.00, 30);    -- SalePrice present

CREATE TABLE Tb_Categories_Null (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    RegionTaxRate DECIMAL(5,2) NULL
);

-- Insert sample records
INSERT INTO Tb_Categories_Null (CategoryName, RegionTaxRate)
VALUES
('Electronics', 18.00),   -- Tax rate present
('Stationery', NULL),     -- Tax rate missing → fallback to 0.0
('Furniture', 12.50),     -- Tax rate present
('Clothing', NULL);       -- Tax rate missing

--COALESCE example
SELECT 
    ProductName, 
    COALESCE(SalePrice, BasePrice, 0) AS CurrentPrice
FROM Tb_Products_Null;


--ISNULL example
SELECT 
    CategoryName, 
    ISNULL(RegionTaxRate, 0.0) AS TaxRate 
FROM Tb_Categories_Null;


-- Filtering non-NULL BasePrice
SELECT ProductName, BasePrice 
FROM Tb_Products_Null
WHERE BasePrice IS NOT NULL;
