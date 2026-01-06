# JOINs
### This is the "heart" of SQL. In a relational database, data is split into different tables (Normalization) to stay organized.
JOINs are how we stitch those pieces back together to tell a complete story.

## Visual Representaion
![SQL INNER JOIN Venn Diagram](https://i.sstatic.net/UI25E.jpg)

## What is JOINs?
A JOIN is a clause used to combine rows from two or more tables based on a related column between them
(usually a Primary Key from one table and a Foreign Key from another).

## Analogy
Think of a Jigsaw Puzzle. Table A is one piece, and Table B is another. A JOIN is the "tab and slot" that connects them. 
Without the connection, you just have random pieces; with the JOIN, you see the whole picture.

## Syntax
SELECT TableA.Column, TableB.Column
FROM TableA
[TYPE OF JOIN] TableB 
ON TableA.Key = TableB.Key;

## When to Use
A. When you need data that lives in separate places (e.g., getting a Customer's Name from the Customers table and their Order Total from the Orders table).

B. When building complex reports for your .NET Core backend.

## When NOT to Use
A. If the data is already in one table.

B. If you are joining too many tables (e.g., 20+ tables) at once, it can destroy performance. Sometimes multiple small queries are better.

## What Problem Does It Solve?
It solves Data Redundancy. Instead of typing the Category Name "Electronics" next to every single product (which wastes space), 
we store "Electronics" once in a Categories table and JOIN it when needed.

## Common Misconceptions
A. "Joins make queries slow": Not if you have proper indexes! Joins are what relational databases are built for.

B. "You can only join on IDs": While common, you can join on any columns with matching data types (like joining on Email addresses).

## INNER JOIN
### The "Perfect Match"

## What is INNER JOIN
The most common join. It returns records only when there is a match in both tables. If a Product doesn't have a Category, 
or a Category has no Products, those rows are ignored.

## EXAMPLE
SELECT p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;

## WHEN TO USE
Use this for "Required" relationships—like showing orders that definitely belong to a customer.

## LEFT JOIN
### The "Keep Everything on the Left"

## What is LEFT JOIN
Returns all records from the left table, and the matched records from the right table. If there is no match, the right side results in NULL.

## EXAMPLE
-- Show ALL products, even if they don't have a category assigned
SELECT p.ProductName, c.CategoryName
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID;

## WHEN TO USE
Use this when the relationship is "Optional." For example, showing a list of all Employees and their Office Number 
(some employees might not have an office yet).

## RIGHT JOIN
### The "Keep Everything on the Right"

## What is RIGHT JOIN
The exact opposite of a LEFT JOIN. It returns all records from the right table and matches from the left.

## EXAMPLE
-- Show ALL categories, even those that have zero products
SELECT p.ProductName, c.CategoryName
FROM Products p
RIGHT JOIN Categories c ON p.CategoryID = c.CategoryID;

## WHEN TO USE
Rarely used in practice, as most developers find it easier to read a LEFT JOIN by just swapping the table order. 
It’s useful when adding a table to a long existing query.

## FULL JOIN
### The "Include Everyone"

## What is FULL JOIN
Returns all records when there is a match in either the left or the right table. It’s a combination of LEFT and RIGHT join.

## EXAMPLE
-- Show all products AND all categories, regardless of whether they link
SELECT p.ProductName, c.CategoryName
FROM Products p
FULL OUTER JOIN Categories c ON p.CategoryID = c.CategoryID;

## WHEN TO USE
Use this for Data Auditing. It helps you find "orphaned" data—products without categories AND categories without products at the same time.

