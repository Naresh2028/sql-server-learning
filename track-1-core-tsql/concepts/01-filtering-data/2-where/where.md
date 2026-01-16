## FILTER(in-between-like)

## What is Filter?
Filtering is the act of picking out only the items you want from a large group. 
In SQL, we do this in the WHERE clause to tell the database, "Don't show me everything; only show me these specific rows."

## Analogy
Imagine a big box of LEGO bricks.
Filtering is like saying: "I only want the blue ones, that are long, and have the shiny texture."
You are ignoring the thousands of other bricks to focus on the few you need to build your castle.

## Syntax
WHERE Column IN (value1, value2, ...)
WHERE Column BETWEEN start AND end
WHERE Column LIKE pattern


## When to Use
A. When you have a specific list of items (IN).

B. When you are looking for a range of numbers or dates (BETWEEN).

C. When you only remember part of a name or word (LIKE).

## When NOT to Use
A. Don't use them if you are looking for a single, exact match (just use =).

Don’t use LIKE with a leading wildcard ('%Name') on large tables if you can avoid it, because it prevents index usage and can be slow.

## What Problem Does It Solve?
It prevents "Data Noise." Instead of a human or an Angular app having to look through 1 million rows to find 5 products,
the database does the hard work and only sends the 5 correct ones.

## Common Misconceptions
A. "BETWEEN doesn't include the end numbers": False. 
In SQL Server, BETWEEN 1 AND 10 includes both 1 and 10.

B. "LIKE is case-sensitive": Usually False. 
In most SQL Server setups, LIKE 'a%' will find 'Apple' and 'apple'. 
However, this depends on the "Collation" settings of your database.

C. "IN is faster than OR": False. 
SQL Server often treats IN and multiple OR conditions similarly.
IN is mainly used for readability, not guaranteed performance.

## IN

## What
IN allows you to specify multiple values in a WHERE clause. It’s a shorthand for multiple OR conditions.

## Example
-- Finding products for specific tech hubs
SELECT ProductName FROM Products
WHERE CategoryID IN (1, 2, 5); 
-- (This is like saying CategoryID = 1 OR CategoryID = 2 OR CategoryID = 5)

## When to Use
Use IN when you have a discrete list of "options" (like specific IDs, Cities, or Categories).

## BETWEEN

## What is BETWEEN
BETWEEN selects values within a given range. The values can be numbers, text, or dates. 
Crucial: It is inclusive, meaning it includes the start and end values.

## Example
-- Finding mid-range priced items for a Canada store
SELECT ProductName, BasePrice FROM Products
WHERE BasePrice BETWEEN 100 AND 500;
-- (Includes products that cost exactly 100 and exactly 500)
-- Note: For datetime columns, BETWEEN can be tricky due to time portions

## When to Use
Use BETWEEN for continuous scales, like Prices, Dates, or Ages.

## LIKE

## What is LIKE
LIKE is used to search for a specified pattern in a column. It uses "Wildcards":
% (Percent sign): Represents zero, one, or multiple characters.
_ (Underscore): Represents a single character.

## Example
-- Finding all MacBook models
SELECT ProductName FROM Products
WHERE ProductName LIKE 'MacBook%'; 
-- (Finds 'MacBook Pro', 'MacBook Air', etc.)

## When to Use
Use LIKE for search bars in your .NET/Angular apps where users might only type "Mac" or "Pro" instead of the full name.
