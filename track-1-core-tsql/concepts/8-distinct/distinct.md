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

C. Continue here
## When NOT to Use
## What Problem Does It Solve?
## Example
## Common Misconceptions
