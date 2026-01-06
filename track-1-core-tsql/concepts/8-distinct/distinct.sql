-- Categories table
CREATE TABLE Tb_Categories_Distinct (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL
);

-- Products table
CREATE TABLE Tb_Products_Distinct (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    BasePrice DECIMAL(10,2),
    UnitsInStock INT,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID)
);

INSERT INTO Tb_Categories_Distinct (CategoryID, CategoryName)
VALUES (1, 'Ontario');


-- Insert 50 dummy products all linked to Ontario
DECLARE @i INT = 1;

WHILE @i <= 50
BEGIN
    INSERT INTO Tb_Products_Distinct (ProductID, ProductName, BasePrice, UnitsInStock, CategoryID)
    VALUES (@i, CONCAT('Product_', @i), 100 + @i, 10 + @i, 1);

    SET @i = @i + 1;
END;

-- With DISTINCT
SELECT DISTINCT 
    c.CategoryName 
FROM Products p
JOIN Tb_Categories_Distinct c ON p.CategoryID = c.CategoryID;

-- OUTPUT : (1 row affected)

-- Without DISTINCT
SELECT  
    c.CategoryName 
FROM Products p
JOIN Tb_Categories_Distinct c ON p.CategoryID = c.CategoryID;

-- OUTPUT : (2 rows affected)
