
# SELECT Statement

## What is SELECT?
The SELECT statement is the primary "DQL" (Data Query Language) command in T-SQL. 
It acts as a projection operator, allowing you to choose specific columns or compute values from one or more tables. 
Think of it as a "filter" for columns (vertical filtering), whereas WHERE is a filter for rows (horizontal filtering).

## Analogy
Think of a spreadsheet:
- SELECT → choosing which columns to view
- WHERE → filtering rows

## Syntax
SELECT column1, column2, expression
FROM table_name
WHERE condition;

## when to Use 
Data Retrieval: When you need to view raw data stored in tables.

Reporting: When aggregating data (e.g., using SUM or COUNT) for business insights.

Application Data Flow: When your .NET/node.js/python./java backend needs to fetch specific user or product details to display on an Angular/React frontend.

Data Transformation: When you need to format data on the fly (e.g., concatenating FirstName and LastName).


## when NOT to Use
Large Binary Objects (BLOBs): Avoid selecting VARBINARY(MAX) (images/files) unless absolutely necessary, as it kills network performance.

SELECT * in Production: Never use SELECT * in production code. It increases I/O overhead and can break our .NET/any backend DTOs if the schema changes.

Trigger Logic: Avoid heavy SELECT statements inside Triggers, as they can significantly slow down INSERT/UPDATE operations and cause deadlocks.

## What Problem Does SELECT Solve?
Without SELECT, a database would be a "black box." SELECT enables safe data access, allowing multiple users to read data simultaneously without modifying it. 

It also enables Data Minimization, ensuring that an application only pulls the 2KB of data it needs rather than the 2GB available in the table.

## Common Misconceptions
A. SELECT is the first thing the database processes: False. 

Logical Query Procecssing Order
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. ORDER BY

Logically, SQL Server processes FROM and JOIN first, then WHERE, then GROUP BY. 
SELECT is actually one of the last steps. This is why you cannot use a column alias defined in the SELECT clause within the WHERE clause.

B. SELECT doesn't lock tables: False. 
By default, a SELECT statement places Shared (S) Locks on rows or pages. 
If a long-running UPDATE is happening, your SELECT might be blocked unless you use isolation levels like READ COMMITTED SNAPSHOT.



## Example
    SELECT 
    OrderID, 
    OrderDate,
    TotalAmount,
    (TotalAmount * 0.13) AS HST_Tax, -- 13% Ontario HST calculation
    'CAD' AS Currency
    FROM Sales
    WHERE Status = 'Shipped'
    ORDER BY OrderDate DESC;
