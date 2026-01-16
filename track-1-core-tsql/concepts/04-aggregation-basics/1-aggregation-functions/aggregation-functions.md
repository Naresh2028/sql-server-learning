# Aggregate functions (COUNT, SUM, AVG, MIN, MAX)

## What are Aggregate functions?
Aggregate functions perform a calculation on a set of values and return a single value. 
Instead of looking at individual rows, they look at the "big picture."

## Analogy
Imagine a Classroom Teacher.
  A. The teacher doesn't just look at one student's grade; they calculate the Class Average.

  B. They count How many students are present.

  C. They find the Highest and Lowest scores on the test. Each student is a "row," but the final report card for the class is the "aggregate."
  
## Syntax
SELECT FUNCTION_NAME(ColumnName) 
FROM TableName 
WHERE Condition;

## When to Use
A. Reporting: Calculating total revenue for a month.

B. Dashboards: Showing the number of active users in your Angular app.

C. Inventory: Checking the lowest stock levels to trigger a reorder.


## When NOT to Use
1. Detailed Lists: You cannot easily mix aggregate functions (like SUM) with individual row data (like ProductName) without using a GROUP BY clause

2. Non-Numeric Data: You can't use SUM or AVG on text columns (like "Names"). 

## What Problem Does It Solve?
It solves Information Overload. Humans can't make sense of 1,000,000 individual sales records. 
Aggregates summarize that data into a single "Total Sales" figure that a manager can actually use to make decisions.

## Common Misconceptions
A. "Aggregates include NULLs": False. Most aggregate functions (except COUNT(*)) ignore NULL values entirely.

B. "You can use them in a WHERE clause": False. You cannot do WHERE SUM(Price) > 100. You must use HAVING for that.

## COUNT

## What is COUNT
It returns the number of items in a group.

A. COUNT(*): Counts every row.

B. COUNT(Column): Counts only rows where that column is NOT NULL.

## Example
-- How many products do we have in our California warehouse?
    
    SELECT COUNT(*) AS TotalProducts 
    FROM Inventory 
    WHERE Warehouse_ID = 3;

## When to Use
Use this for pagination (to know how many total pages exist) or to check the size of a dataset.

## SUM

## What is SUM
It calculates the total addition of all numeric values in a column.

## Example
-- What is the total value of all items in Toronto?

    SELECT SUM(BasePrice) AS TotalValue 
    FROM Products 
    WHERE CategoryID = 1;

## When to Use
Use this for financial totals, total points, or total weight of shipments.

##  AVG
## What is AVG
It calculates the mathematical mean (average) of a numeric column.

## Example
-- What is the average price of a laptop in our inventory?
  
    SELECT AVG(BasePrice) AS AveragePrice 
    FROM Products;

## When to Use
Use this for performance metrics, average user ratings, or temperature averages.

##  MIN &  MAX

## What are MIN &  MAX
A. MIN: Returns the smallest value in a column.

B. MAX: Returns the largest value in a column.

## Example
-- Find the cheapest and most expensive items we sell

    SELECT 
    MIN(BasePrice) AS CheapestItem, 
    MAX(BasePrice) AS MostExpensiveItem 
    FROM Products;

## When to Use
Use these for price ranges, finding the "Oldest" or "Newest" date, or identifying the top performer in a sales team.
