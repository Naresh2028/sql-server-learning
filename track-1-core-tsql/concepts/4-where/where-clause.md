## WHERE

## What is WHERE?
The WHERE clause is a filter used to extract only those records that fulfill a specified condition. 
It acts as a gatekeeper for the data. In the logical processing of a query, it happens after the FROM and JOIN clauses but before GROUP BY and SELECT.

## Analogy
Think of a Bouncer at a Club. 

The FROM clause is the line of people outside. 
The WHERE clause is the bouncer checking IDs.
  "Are you over 21?" ( Age >= 21 )
  "Are you on the VIP list?" ( Status = 'VIP' ) 
If you don't meet the criteria, you don't get into the result set (the club).

## Syntax
SELECT Column1, Column2
FROM TableName
WHERE Condition1 [AND | OR] Condition2;

## When to Use
A. Targeted Retrieval: When you only need a specific record (e.g., WHERE UserID = 101).
B. Range Filtering: Finding data within dates or prices (e.g., WHERE OrderDate >= '2026-01-01').
C. Pattern Matching: Finding names starting with a specific letter (e.g., WHERE CustomerName LIKE 'A%').
D. Security & Multi-tenancy: Ensuring a user only sees their own data (e.g., WHERE TenantID = @CurrentTenant).

## When NOT to Use
A. Filtering Groups: Do not use WHERE for conditions on aggregated data (e.g., SUM(Sales) > 1000). For that, you must use the HAVING clause.
B. Complex Logic on Indexed Columns: Avoid using functions on columns in the WHERE clause (e.g., WHERE YEAR(OrderDate) = 2026), 
as this can prevent SQL Server from using an index (SARGability).
  -- Bad (non-SARGable)
  WHERE YEAR(OrderDate) = 2026

  -- Good (SARGable)
  WHERE OrderDate >= '2026-01-01'
  AND OrderDate <  '2027-01-01'

## What Problem Does It Solve?
A. Performance: It reduces the amount of data SQL Server has to read from the disk and send over the network.
B. Precision: It prevents "Information Overload" by hiding irrelevant records.
C. Application Logic: It allows your .NET Core backend to fetch exactly what the user requested in the Angular search bar.

## Example
SELECT 
    ProductName, 
    BasePrice, 
    UnitsInStock
FROM Products
WHERE BasePrice > 500              -- Condition 1: Price threshold
  AND UnitsInStock > 0             -- Condition 2: Must be available
  AND ProductName LIKE '%MacBook%';-- Condition 3: Specific search pattern

## Common Misconceptions
A. "WHERE filters the columns": No. WHERE only filters rows. If you want to limit columns, change your SELECT list.

B. "WHERE can use column aliases": False. 
Because WHERE is processed before SELECT, it doesn't know about the aliases you created.
Incorrect: SELECT Price AS P FROM Products WHERE P > 10
Correct: SELECT Price AS P FROM Products WHERE Price > 10

C. Three-Valued Logic (TRUE, FALSE, UNKNOWN)
Comparisons involving NULL result in UNKNOWN, not TRUE or FALSE.

Example:
WHERE Column = NULL  -- always false
Correct:
WHERE Column IS NULL

D. WHERE vs HAVING
WHERE filters rows before aggregation
HAVING filters groups after aggregation


