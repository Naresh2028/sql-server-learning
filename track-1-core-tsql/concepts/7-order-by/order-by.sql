-- Create the Products table
CREATE TABLE Tb_Products_Orderby (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    BasePrice DECIMAL(10,2) NOT NULL,
    UnitsInStock INT NOT NULL
);

-- Insert realistic sample data (electronics store style)
INSERT INTO Tb_Products_Orderby (ProductName, BasePrice, UnitsInStock) VALUES
('MacBook Pro 16" M3 Max', 3499.99, 12),
('MacBook Pro 14" M3 Pro', 2399.00, 18),
('iPhone 15 Pro Max', 1199.99, 45),
('iPad Pro 12.9" M2', 1099.00, 0),           -- Out of stock (will be filtered out)
('MacBook Air M2 15"', 1299.00, 25),
('AirPods Max', 549.00, 30),
('Apple Watch Ultra 2', 799.00, 22),
('Magic Keyboard for iPad', 299.00, 60),
('iPhone 15', 799.99, 80),
('Studio Display 27"', 1599.00, 8),
('Mac Studio M2 Ultra', 3999.99, 5),
('HomePod mini', 99.00, 150),
('AirTag (4-pack)', 99.00, 0),               -- Out of stock (will be filtered out)
('Thunderbolt 4 Cable', 129.00, 75),
('MacBook Pro 16" M2 Pro', 2499.00, 10);


SELECT
    ProductName,
    BasePrice,
    UnitsInStock
FROM Tb_Products_Orderby
WHERE UnitsInStock > 0
ORDER BY BasePrice DESC, ProductName ASC;
