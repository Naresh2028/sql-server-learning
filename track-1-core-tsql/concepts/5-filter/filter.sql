-- Create the Products table 
CREATE TABLE Tb_Products_Filter (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    BasePrice DECIMAL(10,2) NOT NULL,
    CategoryID INT NULL  -- Foreign key to Categories (added for the IN example)
);

-- Create a simple Categories table 
CREATE TABLE Tb_Categories_Filter (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(50) NOT NULL
);

-- Insert realistic categories (tech-related for a store context)
INSERT INTO Tb_Categories_Filter (CategoryID, CategoryName) VALUES
(1, 'Laptops'),
(2, 'Smartphones'),
(3, 'Tablets'),
(4, 'Accessories'),
(5, 'Desktops'),
(6, 'Audio'),
(7, 'Wearables');

-- Insert realistic product data (electronics store style)
INSERT INTO Tb_Products_Filter (ProductName, BasePrice, CategoryID) VALUES
('MacBook Pro 14"', 1999.99, 1),
('MacBook Pro 16"', 2499.99, 1),
('MacBook Air M2', 1199.00, 1),
('MacBook Pro Max 16"', 3499.99, 1),
('iPhone 15 Pro', 1099.99, 2),
('iPhone 15', 799.99, 2),
('iPad Air', 599.00, 3),
('iPad Pro 12.9"', 1099.00, 3),
('AirPods Pro 2', 249.00, 6),
('Apple Watch Ultra 2', 799.00, 7),
('Magic Keyboard', 299.00, 4),
('Thunderbolt Display', 999.00, 5),
('Budget Bluetooth Speaker', 149.99, 6),
('Wireless Mouse', 79.99, 4),
('USB-C Hub', 89.99, 4),
('External SSD 1TB', 129.99, 4),
('Gaming Monitor 27"', 399.99, 5),
('Mechanical Keyboard', 149.00, 4),
('Webcam 4K', 199.99, 4),
('Studio Headphones', 349.00, 6);


-- 1. Finding all MacBook models (starts with 'MacBook')
SELECT ProductName FROM Tb_Products_Filter
WHERE ProductName LIKE 'MacBook%';

-- 2. Finding mid-range priced items (100 to 500 inclusive)
SELECT ProductName, BasePrice FROM Tb_Products_Filter
WHERE BasePrice BETWEEN 100 AND 500;

-- 3. Finding products for specific tech hubs (Laptops, Smartphones, Desktops)
SELECT ProductName FROM Tb_Products_Filter
WHERE CategoryID IN (1, 2, 5);
