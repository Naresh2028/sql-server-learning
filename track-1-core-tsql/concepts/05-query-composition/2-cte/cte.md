# CTE

## What is CTE?
A Common Table Expression (CTE) is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. 
Think of it as a temporary table that exists only for the duration of a single query.

## Analogy
Think of a Cooking Recipe. Instead of trying to chop vegetables, boil water, and 
sear meat all in one tiny pot at the exact same time (Subquery), you:
  1. Prep the veggies in one bowl (CTE 1).

  2. Prep the sauce in another bowl (CTE 2).

  3. Combine everything in the main pan to finish the dish (Main Query).

     It makes the process organized and easy to follow.

## Syntax
WITH CTEName AS (
    SELECT Column1, Column2
    FROM TableName
    WHERE Condition
)
SELECT * FROM CTEName; -- You use it right after defining it

## When to Use
1. Readability: When a query has complex logic that is hard to read using subqueries.

2. Aggregating Aggregates: When you need to perform a calculation on a result that was already calculated (e.g., finding the average of a sum).

3. Replacing Subqueries: Almost any time you would use a subquery in the FROM clause, a CTE is better.

## When NOT to Use
1. Reusability across scripts: A CTE only lasts for one query. If you need the data for multiple different queries in a
script, use a Temporary Table (#Temp) instead.

2. Recursion (Simple level): For very simple filters, a CTE might be "overkill."

## What Problem Does It Solve?
It solves "Code Spaghetti." Subqueries can be nested inside each other like Russian dolls, making them impossible to debug. 
CTEs allow you to write your logic top-to-bottom in a logical sequence.

## Example
Problem: Your manager wants a report showing the Total Sales per Category, but she only wants to see categories 
that are performing better than the average category.

-- Step 1: Define the CTE to get Category Totals
    
    WITH CategorySales AS (
    SELECT 
        CategoryID, 
        SUM(BasePrice * UnitsInStock) AS InventoryValue
    FROM Products
    GROUP BY CategoryID
    )

-- Step 2: Use the CTE to filter against the average

    SELECT CategoryID, InventoryValue
    FROM CategorySales
    WHERE InventoryValue > (SELECT AVG(InventoryValue) FROM CategorySales);

## Common Misconceptions
1. "CTEs are stored in the database": False. They are purely "in-memory" and disappear the moment the query finishes. They don't take up permanent disk space.

2. "You can only have one WITH per query": False. You can define multiple CTEs separated by commas using only one WITH keyword:
WITH CTE1 AS (...),
     CTE2 AS (...)
SELECT * FROM CTE1 JOIN CTE2...
