Imagine you are a Junior Developer at "MapleTech Solutions". Your manager gives you two tables that aren't perfectly clean—they have some "orphaned" data.

The Scenario: Inventory & Sales Audit

You have two tables:

1. Warehouses: Locations where we store goods.

2. Inventory: The actual items we have.

The "Real World" Problems in these tables:

  A. We have a New Warehouse in San Francisco that is currently empty (no inventory yet).

  B. We have "Ghost Items" in our inventory list that aren't assigned to any Warehouse yet (waiting in a truck).

-- Create Scenario Tables
CREATE TABLE Warehouses (
    W_ID INT PRIMARY KEY,
    Location NVARCHAR(50)
);

CREATE TABLE Inventory (
    Item_ID INT PRIMARY KEY,
    ItemName NVARCHAR(50),
    Warehouse_ID INT -- This links to W_ID
);

-- Insert Data
INSERT INTO Warehouses VALUES (1, 'Toronto'), (2, 'Vancouver'), (3, 'San Francisco');

INSERT INTO Inventory VALUES 
(10, 'Maple Syrup', 1),   -- In Toronto
(20, 'Winter Boots', 2),  -- In Vancouver
(30, 'Tesla Battery', NULL); -- "Ghost Item" (No warehouse yet)


Problem Solving with JOINs

Your manager asks you four specific questions. Here is how you solve them:

Q1: "Show me only the Items that are safely stored in a Warehouse."
  
Solution: INNER JOIN This ignores the empty warehouse and ignores the "Ghost Item." It only returns the "Perfect Matches."

SELECT I.ItemName, W.Location
FROM Inventory I
INNER JOIN Warehouses W ON I.Warehouse_ID = W.W_ID;

Q2: "Show me ALL items we own, even if they are still on a truck (no warehouse)."
  
Solution: LEFT JOIN We put Inventory on the left because we want all of them.

SELECT I.ItemName, W.Location
FROM Inventory I
LEFT JOIN Warehouses W ON I.Warehouse_ID = W.W_ID;

Q3: "I need a list of ALL our warehouses, even the empty ones, to check capacity."
  
Solution: RIGHT JOIN (or Left Join with Warehouse on the left) This ensures 'San Francisco' stays in the list even though it has 0 items.

SELECT I.ItemName, W.Location
FROM Inventory I
RIGHT JOIN Warehouses W ON I.Warehouse_ID = W.W_ID;

Q4: "Give me a complete Audit. I want to see every item and every warehouse, matching or not."

Solution: FULL OUTER JOIN This shows the "Ghost Item" AND the "Empty Warehouse" in one big list.

SELECT I.ItemName, W.Location
FROM Inventory I
FULL OUTER JOIN Warehouses W ON I.Warehouse_ID = W.W_ID;







