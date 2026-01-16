# GROUP BY, HAVING
These clauses transform you from someone who just "pulls data" into someone who "analyzes data

## What are GROUP BY & HAVING?
GROUP BY: This clause collapses multiple rows into "buckets" or groups based on shared values in one or more columns.

HAVING: This is a filter that acts after the data has been grouped. While WHERE filters individual rows, 
HAVING filters the results of an aggregate (like "only show groups with a sum > 100").

## Analogy
Imagine a Laundry Room.

A GROUP BY: You take a giant pile of clothes and sort them into buckets: "Whites," "Colors," and "Delicates."

B Aggregate: You count how many items are in each bucket.

C HAVING: You decide, "I will only start the washing machine for buckets that have more than 5 items." The HAVING clause is that final check on the bucket size.

## Syntax
SELECT ColumnA, SUM(ColumnB)
FROM TableName
WHERE IndividualCondition -- 1. Filter rows
GROUP BY ColumnA          -- 2. Create buckets
HAVING SUM(ColumnB) > 100 -- 3. Filter buckets
ORDER BY ColumnA;         -- 4. Sort results

## When to Use
1. Summarizing Data: Getting total sales per city or average rating per product.

2. Duplicate Detection: Finding email addresses that appear more than once in a table.

3. Reporting: Creating data for charts (Pie charts, Bar graphs) in your Angular dashboard.

## When NOT to Use
A. Single Rows: If you need to see every individual transaction detail, don't use GROUP BY.

B. Performance: Don't group by high-cardinality columns (like UniqueID or Timestamp) unless necessary, as it creates too many tiny buckets and slows down the server.

## What Problem Does It Solve?
It solves the "Total per X" problem. Without it, you would have to run 50 separate queries to find the total sales for 50 different Canadian provinces. 
With GROUP BY, you do it in one single query.

## GROUP BY
It tells the database to stop looking at rows one-by-one and start looking at them in chunks based on a specific column value.

## Example
Using our Products and Categories table:
-- Find the total stock count for each category
SELECT CategoryID, SUM(UnitsInStock) AS TotalStock
FROM Products
GROUP BY CategoryID;

## When to Use
Use it whenever your requirement includes the word "Each" or "Per" (e.g., "Sales per Month," "Students per Class").

## HAVING (The Bucket Filter)

## What is HAVING
HAVING is the "WHERE clause for groups." Because the WHERE clause is processed before the computer knows the sum or count of a group,
we need HAVING to filter based on those calculated numbers.

## Example
-- Only show categories that have more than 100 items in stock
SELECT CategoryID, SUM(UnitsInStock) AS TotalStock
FROM Products
GROUP BY CategoryID
HAVING SUM(UnitsInStock) > 100;

## When to Use
Use it to find outliers or specific thresholds (e.g., "Customers who spent more than $500," "Products that are nearly out of stock").

## Common Misconceptions
1. "I can use aliases in HAVING": False. Just like the WHERE clause, HAVING is processed before the SELECT list.
You must repeat the function: HAVING SUM(Price) > 10 is correct; HAVING MyAlias > 10 will fail.

2. "WHERE and HAVING are interchangeable": False. * WHERE filters Rows (before grouping).
HAVING filters Groups (after grouping).

3. "Every column in SELECT must be in GROUP BY": True! (Unless that column is inside an aggregate function). This is the #1 error beginners make.
4.  If you select Name, City, SUM(Sales), you must group by Name, City.
