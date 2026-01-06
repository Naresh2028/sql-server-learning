CREATE TABLE Tb_Products_Top (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    BasePrice DECIMAL(10,2) NOT NULL,
    Store NVARCHAR(50) NOT NULL
);

-- Insert 30 products for California store
INSERT INTO Tb_Products_Top (ProductID, ProductName, BasePrice, Store)
VALUES
(1, 'Laptop', 1200.00, 'California'),
(2, 'Smartphone', 900.00, 'California'),
(3, 'Tablet', 600.00, 'California'),
(4, 'Monitor', 300.00, 'California'),
(5, 'Keyboard', 50.00, 'California'),
(6, 'Mouse', 25.00, 'California'),
(7, 'Printer', 200.00, 'California'),
(8, 'Camera', 800.00, 'California'),
(9, 'Headphones', 150.00, 'California'),
(10, 'Smartwatch', 400.00, 'California'),
(11, 'Router', 120.00, 'California'),
(12, 'Speaker', 180.00, 'California'),
(13, 'Projector', 700.00, 'California'),
(14, 'SSD Drive', 250.00, 'California'),
(15, 'External HDD', 100.00, 'California'),
(16, 'Gaming Console', 500.00, 'California'),
(17, 'VR Headset', 950.00, 'California'),
(18, 'Drone', 1100.00, 'California'),
(19, 'Mic', 80.00, 'California'),
(20, 'Webcam', 60.00, 'California'),
(21, 'Docking Station', 220.00, 'California'),
(22, 'Graphics Card', 1300.00, 'California'),
(23, 'Motherboard', 400.00, 'California'),
(24, 'RAM 16GB', 150.00, 'California'),
(25, 'Power Bank', 70.00, 'California'),
(26, 'Charger', 40.00, 'California'),
(27, 'Stylus Pen', 35.00, 'California'),
(28, 'E-Reader', 350.00, 'California'),
(29, 'Smart TV', 1000.00, 'California'),
(30, 'Bluetooth Adapter', 20.00, 'California');

-- 1. Get the 3 most expensive products
SELECT TOP (3) ProductName, BasePrice
FROM Tb_Products_Top
WHERE Store = 'California'
ORDER BY BasePrice DESC;


-- 2. Pagination (Skip 20, Take 10)
SELECT ProductName, BasePrice
FROM Tb_Products_Top
WHERE Store = 'California'
ORDER BY ProductID
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;
