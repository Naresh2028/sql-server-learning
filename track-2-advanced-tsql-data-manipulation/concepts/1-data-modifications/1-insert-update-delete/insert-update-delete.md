# INSERT, UPDATE, DELETE

## What are INSERT, UPDATE, & DELETE?
These are the three primary DML (Data Manipulation Language) commands used to manage the data within your tables.
1. INSERT: Adds new rows.

2. UPDATE: Modifies existing data in rows.

3. DELETE: Removes rows from a table.

## Analogy
Think of a Library Card Catalog.
1. INSERT: Buying a new book and filing a new card in the cabinet.

2. UPDATE: Realizing a book's title was misspelled on its card and erasing it to write the correct one.

3. DELETE: Tearing up the card because the book was lost or destroyed.

## Syntax
-- INSERT
INSERT INTO TableName (Col1, Col2) VALUES (Val1, Val2);

-- UPDATE
UPDATE TableName SET Col1 = Val1 WHERE Condition;

-- DELETE
DELETE FROM TableName WHERE Condition;

## When to Use
1. INSERT: When a new user signs up on your Angular frontend.

2. UPDATE: When that user changes their password or shipping address in California.

3. DELETE: When a user closes their account and you need to remove their personal data (essential for GDPR/Privacy laws in Canada).

## When NOT to Use
1. UPDATE without a WHERE clause: Unless you want to change every single row in the database (this is a common "nightmare" scenario).

2. DELETE for "Archiving": If you want to keep the data for history but hide it from the UI,
use a "Soft Delete" (an IsActive column) and an UPDATE instead of a hard DELETE.

## What Problem Does It Solve?
It allows your database to be Dynamic. Without these commands, a database would be a static, read-only list. 
These allow your application to react to real-world changes.

## Example
Scenario: Managing a shipment in a warehouse.

-- 1. Add a new product
INSERT INTO Inventory (ItemName, Warehouse_ID) VALUES ('Gaming Chair', 2);

-- 2. Correct the item name
UPDATE Inventory SET ItemName = 'Pro Gaming Chair' WHERE ItemName = 'Gaming Chair';

-- 3. Remove the item if it's sold out and discontinued
DELETE FROM Inventory WHERE Item_ID = 50;

## Common Misconceptions
1. "DELETE resets Identity seeds": False. If you delete ID #10, the next insert will still be #11. Use TRUNCATE if you want to reset the counter.

2. "INSERT is always fast": If a table has 20 indexes, every INSERT or DELETE forces the database to update all 20 index trees, which can slow down your .NET API.

3. "Updates are safe": Without a WHERE clause, an UPDATE is a "database killer." Always run a SELECT with your WHERE clause first to verify which rows will be affected.
