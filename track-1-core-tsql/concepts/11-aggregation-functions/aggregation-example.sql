-- Products table
CREATE TABLE Tb_Products_Aggregate (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryID INT,
    BasePrice DECIMAL(10,2)
);

-- Inventory table
CREATE TABLE Tb_Inventory_Aggregate (
    InventoryID INT PRIMARY KEY,
    ProductID INT,
    Warehouse_ID INT,
    Quantity INT
);


-- Insert Products
INSERT INTO Tb_Products_Aggregate (ProductID, ProductName, CategoryID, BasePrice)
VALUES
(1, 'Laptop', 1, 1200.00),
(2, 'Smartphone', 1, 800.00),
(3, 'Novel', 2, 15.50),
(4, 'T-Shirt', 3, 25.00),
(5, 'Football', 4, 60.00),
(6, 'Headphones', 1, 150.00);

-- Insert Inventory
INSERT INTO Tb_Inventory_Aggregate (InventoryID, ProductID, Warehouse_ID, Quantity)
VALUES
(101, 1, 3, 50),   -- Laptop in Warehouse 3
(102, 2, 3, 100),  -- Smartphone in Warehouse 3
(103, 3, 2, 200),  -- Novel in Warehouse 2
(104, 4, 3, 75),   -- T-Shirt in Warehouse 3
(105, 5, 1, 40),   -- Football in Warehouse 1
(106, 6, 3, 30);   -- Headphones in Warehouse 3


--AVG
SELECT AVG(BasePrice) AS AveragePrice FROM Tb_Products_Aggregate;


--SUM
SELECT SUM(BasePrice) AS TotalValue 
FROM Tb_Products_Aggregate 
WHERE CategoryID = 1;

--COUNT
SELECT COUNT(*) AS TotalProducts 
FROM Tb_Inventory_Aggregate 
WHERE Warehouse_ID = 3;
  
