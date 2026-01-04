-- Create the Products table
CREATE TABLE Product_Examples (
    ProductID INT PRIMARY KEY IDENTITY(1,1),  
    ProductName NVARCHAR(100),
    BasePrice DECIMAL(10,2),
    UnitsInStock INT
);

-- Insert sample data
INSERT INTO Product_Examples (ProductName, BasePrice, UnitsInStock) VALUES
('iPhone 15', 999.99, 50),
('MacBook Pro 16"', 2499.00, 15),
('AirPods Pro', 249.00, 100),
('MacBook Air M2', 1199.00, 20),
('iPad Pro', 799.00, 0),                  -- Out of stock
('Dell XPS 13', 1200.00, 30),             -- Not a MacBook
('MacBook Pro 14"', 1999.00, 8),
('Surface Laptop', 899.00, 25),
('Old MacBook 2015', 450.00, 5),          -- Price <= 500
('New MacBook Pro Max', 3499.99, 12);

-- Execute the query
SELECT
    ProductName,
    BasePrice,
    UnitsInStock
FROM Product_Examples
WHERE BasePrice > 500          -- Condition 1: Price threshold
  AND UnitsInStock > 0         -- Condition 2: Must be available
  AND ProductName LIKE '%MacBook%';  -- Condition 3: Specific search pattern

-- Output
ProductName	BasePrice	UnitsInStock
MacBook Pro 16"	2499.00	15
MacBook Air M2	1199.00	20
MacBook Pro 14"	1999.00	8
New MacBook Pro Max	3499.99	12
