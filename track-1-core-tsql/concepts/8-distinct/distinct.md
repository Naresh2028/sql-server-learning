# DISTINCT

## What is DISTINCT?
The DISTINCT keyword is used in the SELECT clause to remove duplicate rows from the result set. 
It ensures that every row returned is unique based on the columns you have selected.

## Analogy
Imagine you have a Bag of Marbles. There are 5 Red marbles, 3 Blue marbles, and 2 Green marbles.
  1. If you ask SQL for the marbles, it gives you all 10.
     
  3. If you ask for DISTINCT colors, it gives you just 3: {Red, Blue, Green}.
     It doesn't care how many there are; it only cares about the unique types available.

## Syntax
SELECT DISTINCT Column1, Column2
FROM TableName;

## When to Use
A. Value Discovery: When you want to see all unique categories or cities represented in a table (e.g., "Which countries do our customers come from?").

B. Cleaning Data: When joining tables results in "Fan-out" (duplicate rows) and you only need the unique parent records.

C. Dropdowns: In your Angular frontend, when populating a "Category" filter dropdown with values from your database.

## When NOT to Use
A. When you need counts: If you use DISTINCT, you lose the information about how many times a value appeared.

B. To fix a bad JOIN: If your query has duplicates because your JOIN logic is wrong, using DISTINCT is a "band-aid" 
fix that can hide serious logic errors and slow down the query.

C. On Large Text/BLOBs: Using DISTINCT on very long strings is extremely slow because the database has to compare every character 
to find duplicates.

## What Problem Does It Solve?
A. Redundancy: It cleans up your results so you don't have to scroll through 100 "Electronics" labels to see the next category.

B. Accuracy in Discovery: It helps you understand the "breadth" of your data (e.g., "We have 10,000 orders, but they only come from 4 different states").

## Example
-- This shows every unique category name currently linked to a product
SELECT DISTINCT 
    c.CategoryName 
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;

## Common Misconceptions
1. "DISTINCT only applies to the first column": False. DISTINCT applies to the entire row in your SELECT list. If you select DISTINCT City, State,
SQL will return unique combinations of City and State.

2. "DISTINCT is the same as GROUP BY": Mostly True. While they often produce the same result, DISTINCT is for filtering the output, while GROUP BY
is intended for doing math (aggregations) on those groups.

3. "DISTINCT is free": False. To find duplicates, SQL Server has to Sort the data or build a Hash Table in memory. If you use DISTINCT on
a massive table without an index, it can be very performance-heavy.
