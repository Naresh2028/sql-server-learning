-- Table Creation
CREATE TABLE Tb_Products_Groupby (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryID INT,
    UnitsInStock INT
);


-- Table Insertion
INSERT INTO Tb_Products_Groupby (ProductID, ProductName, CategoryID, UnitsInStock)
VALUES
(1, 'Laptop', 1, 50),
(2, 'Smartphone', 1, 70),
(3, 'Novel', 2, 40),
(4, 'Textbook', 2, 30),
(5, 'T-Shirt', 3, 25),
(6, 'Jeans', 3, 20),
(7, 'Football', 4, 60),
(8, 'Basketball', 4, 55),
(9, 'Headphones', 1, 20);


-- Only show categories that have more than 100 items in stock
SELECT CategoryID, SUM(UnitsInStock) AS TotalStock
FROM Tb_Products_Groupby
GROUP BY CategoryID
HAVING SUM(UnitsInStock) > 100;

-- Find the total stock count for each category
SELECT CategoryID, SUM(UnitsInStock) AS TotalStock
FROM Tb_Products_Groupby
GROUP BY CategoryID;
