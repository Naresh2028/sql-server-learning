# UNION & UNION ALL

## What are union & Union All?
These are "Set Operators" used to combine the result sets of two or more SELECT statements into a single result set.

A. UNION: Combines rows and removes du-plicates.

B. UNION ALL: Combines rows and keeps everything, including duplicates.

## Analogy
Think of Two Decks of Cards.
1. UNION: You take the two decks, put them together, but if you find two "Aces of Spades," you throw one away so you only have unique cards.

2. UNION ALL: You just stack one deck on top of the other. If you have two "Aces of Spades," you keep both. It’s faster because you don't stop to look for duplicates.

## Syntax
SELECT ColumnA, ColumnB FROM Table1
UNION [ALL]
SELECT ColumnA, ColumnB FROM Table2;

  Rules for Success:

  1. Both queries must have the same number of columns.

  2. The data types of corresponding columns must be compatible.

  3. Column names in the final result are taken from the first query.

## When to Use
1. Merging Similar Tables: Combining an ActiveCustomers table with an ArchivedCustomers table.

2. Report Consolidation: Showing sales from the Toronto branch and the San Francisco branch in one list.

## When NOT to Use
A. In place of a JOIN: Don't use UNION to get related data from different entities (e.g., Customers and Orders).

B. Different Structures: If Table A has 5 columns and Table B has 3, you cannot UNION them without padding the missing columns with NULL.

## What Problem Does It Solve?
It solves the problem of Segmented Data. Often, large companies split data into "Current" and "Historical" tables for performance. UNION allows you to query them as if they were one single table.

## Common Misconceptions
1. "UNION sorts the data": While UNION often sorts data to find duplicates, you should never rely on it. Always use an ORDER BY at the very end if you need a specific sequence.

2. "They are interchangeable": They are not. Using UNION when you don't have duplicates is a waste of server resources.

## Union

## What is Union
It performs a "Distinct" operation on the combined results. It is essentially a UNION ALL followed by a DISTINCT filter.

## Production Notes / Important Awareness (Advanced)
A. Performance Hit: Because the database must compare every row to find duplicates, UNION is significantly slower and more memory-intensive than UNION ALL.

B. Data Types: Be careful with Large Object (LOB) types like TEXT or NVARCHAR(MAX), as SQL Server may struggle to compare them for uniqueness.

## Union All

## What is Union ALL
It is a "Blind Append." It takes the results of Query A and sticks Query B underneath it without checking anything.

## Production Notes / Important Awareness (Advanced)
A. Efficiency: This is the preferred method for high-performance applications (like those in Silicon Valley) unless you are 100% sure you need to hide duplicates.

B. Minimal Logging: In some scenarios, UNION ALL can be optimized better by the query engine because it doesn't require a "Sort" or "Hash" operation.

## Example
--- Union
Imagine you want a list of all unique cities where we have either a Warehouse OR a Supplier.

--- UNION ALL (The "Whole List")
Imagine you need to count every single "Contact Point" in North America for an audit.

```sql
--- Union All
SELECT City FROM Warehouses -- Toronto, Vancouver, San Francisco
UNION
SELECT City FROM Suppliers;  -- Toronto, Seattle
-- Result: Toronto (once), Vancouver, San Francisco, Seattle.

--- Union All

SELECT City FROM Warehouses
UNION ALL
SELECT City FROM Suppliers;
-- Result: Toronto, Vancouver, San Francisco, Toronto, Seattle. 
-- (Toronto appears twice because it exists in both tables).
