-- Create Products Table
CREATE TABLE TB_Products (
    ProductName NVARCHAR(100),
    BasePrice DECIMAL(10, 2),
    UnitsInStock INT
);


-- Insert Sample Records
INSERT INTO TB_Products (ProductName, BasePrice, UnitsInStock) VALUES
('Laptop Pro', 2500.00, 15),
('Wireless Mouse', 45.00, 100),
('Mechanical Keyboard', 150.00, 5),
('Ultra HD Monitor', 800.00, 20),
('External SSD 1TB', 120.00, 0),
('Budget Webcam', 60.00, 8),
('Gaming Chair', 350.00, 3),
('Premium Headphones', 1200.00, 12),
('Cheap USB Cable', 5.00, 50),
('High-End GPU', 3000.00, 2);


SELECT
    ProductName,
    BasePrice,
    CASE
        WHEN BasePrice > 2000 AND UnitsInStock > 10 THEN 'Priority Air'
        WHEN BasePrice > 500 THEN 'Standard Ground'                     -- Searched case
        WHEN UnitsInStock = 0 THEN 'Backordered'                        -- Simple case
        ELSE 'Eco Shipping'
    END AS ShippingMethod
FROM TB_Products
ORDER BY BasePrice DESC;  

