# Subqueries (scalar, correlated, EXISTS)

## What are Subqueries (scalar, correlated, EXISTS)?
A subquery (or inner query) is a query nested inside another SQL statement. 
The result of the inner query is passed to the outer query as a filter or a value.

## Analogy
Think of a Personal Assistant. You ask your assistant: "Find me the phone number of the person who won the 'Employee of the Month' award."

  1. The assistant first looks at the award list to find the Name (Inner Query).
  2. Then, the assistant looks up that specific Phone Number in the directory (Outer Query)

## Syntax
SELECT ColumnList 
FROM Table 
WHERE Column = (SELECT Column FROM Table WHERE Condition);


## When to Use
1. When a value for a filter is dynamic and must be calculated at runtime.

2. When checking for existence without returning actual data.

3. When performing calculations that depend on the data in the same table (Self-comparison).

## When NOT to Use
1. If a JOIN can achieve the same result, a JOIN is usually more readable and often faster.

2. If the subquery returns millions of rows, it can drastically slow down the outer query.

## What Problem Does It Solve?
It solves the problem of Multi-Step Logic. 
Without subqueries, you would have to run one query, copy the result manually, and paste it into a second query.

## Common Misconceptions
1. "Subqueries are always slower than Joins": Not always. modern SQL Server versions, the optimizer often turns subqueries into joins automatically.

2. "Subqueries can only be in the WHERE clause": False. They can be in the SELECT, FROM, and HAVING clauses too.

## Scalar

## What is Scalar
A scalar subquery is one that returns exactly one value (one column and one row).

## Example
Scenario: You want to list all products that are priced higher than the average product price in your warehouse.

SELECT ProductName, BasePrice
FROM Products
WHERE BasePrice > (SELECT AVG(BasePrice) FROM Products); 
-- The inner query returns a single number (e.g., 500.00)

## When to Use
Use this for simple comparisons against a single calculated "benchmark" value.

## correlated

## What is correlated
A correlated subquery is an inner query that refers to a column from the outer query. It is like a foreach loop; 
it runs once for every row processed by the outer query.

## Example
Scenario: Find products that have a higher price than the average price within their own category.

 SELECT p1.ProductName, p1.BasePrice, p1.CategoryID
FROM Products p1
WHERE p1.BasePrice > (
    SELECT AVG(p2.BasePrice) 
    FROM Products p2 
    WHERE p2.CategoryID = p1.CategoryID -- This links the inner to the outer
);

## When to Use
Use this for "Row-by-Row" relative comparisons, such as finding the latest order for every customer.

## EXISTS

## What is EXISTS
EXISTS is a logical operator that checks for the presence of rows. It doesn't return data; it only returns TRUE or FALSE. 
It stops searching as soon as it finds the first match (making it very fast).

## Example
Scenario: You are an admin in a Vancouver office. You need to find all Categories that actually have at least one Product in stock.

```markdown
```sql
SELECT CategoryName
FROM Categories c
WHERE EXISTS (
    SELECT 1
    FROM Products p
    WHERE p.CategoryID = c.CategoryID
      AND p.UnitsInStock > 0
);
-- End of Example

## When to Use
Use this for "Semi-Joins"—when you need to filter Table A based on Table B, but you don't actually need any data from Table B in your final report.

