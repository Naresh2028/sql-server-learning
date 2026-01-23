# NON CLUSTERED

## What is Non Clustered?
A Non-Clustered Index is an index structure separate from the data rows. It contains the "Index Key" values and a pointer to the actual data row in the table.

Unlike a Clustered Index (which is the table), the Non-Clustered index is a side-list. You can have many non-clustered indexes on a single table (up to 999), creating multiple ways to look up data efficiently.

Internally, a non-clustered index stores its data in a B-Tree structure where:

The leaf level contains the index key values

Along with a pointer to the actual data row

The type of pointer depends on the table:

Clustered table → pointer is the Clustered Key

Heap (no clustered index) → pointer is a RID (Row Identifier)

### Non-Clustered Index (Pointer Based)
![Non Clustered Index Lookup](../../assets/indexes/non-clustered-index-lookup.png)

## Analogy

Think of the Index at the Back of a Textbook.

The Textbook itself (the pages with the actual content) is organized by Chapter order (This is the Clustered Index).

The Index at the back lists keywords alphabetically (e.g., "Photosynthesis") and gives you a page number (e.g., "Page 42").

To find info: You look up the word in the back (Index Seek), get the page number (Pointer), and then flip to the actual page to read the paragraph (Key Lookup).

This extra step of jumping from the index to the actual page in the book is exactly what SQL Server calls a Key Lookup.

## Syntax

    CREATE NONCLUSTERED INDEX IX_IndexName 
    ON TableName (ColumnName)
    INCLUDE (IncludedColumnName); -- Optional: Adds extra data to the leaf node

## When to Use

Foreign Keys: Always index your Foreign Keys (CustomerID, ProductID) to speed up JOIN operations.

Search Fields: Columns users frequently search by (e.g., LastName, Email, PhoneNumber).

Covering Queries: When a query only needs a few specific columns, you can create an index containing all of them (using INCLUDE), allowing the engine to answer the query solely from the index without touching the main table.

## When NOT to Use

Returning All Columns (SELECT *): If you select every column in the table, the Non-Clustered index is usually ignored. The engine knows it would be faster to just scan the whole table than to jump back and forth between the index and the table for every single row.

Low Selectivity Columns: Don't put it on a column like Gender (Male/Female). It's not efficient to "jump" to the table for 50% of the rows.

INCLUDE columns are stored only at the leaf level of the index.
They do not affect sorting but allow SQL Server to satisfy a query without performing a Key Lookup, turning a seek + lookup into a single seek.

## What Problem Does It Solve?

It solves the "Multiple Search Paths" problem. A table can only be physically sorted one way (Clustered). But users search in many ways (by Name, by Date, by Price). Non-Clustered indexes allow you to have virtually sorted lists for all these different search patterns without duplicating the massive table data.

How it works at runtime:

SQL Server performs an Index Seek on the non-clustered index B-Tree.

It finds matching index keys.

For each match, it uses the stored pointer to locate the actual row.

If required columns are missing, it performs a Key Lookup to fetch them from the base table.

## Common Misconceptions / Important Notes

The "Key Lookup" Cost: Using a Non-Clustered index often requires a second step called a Key Lookup (or RID Lookup) to retrieve columns that aren't in the index. If this "jumping" becomes too expensive, the optimizer will stop using your index.

Size Overhead: While smaller than the table, these indexes still take up disk space. On massive tables, adding too many can bloat your storage.

Updates: If you update a column that is part of an index key, SQL has to move the row in the index structure, which adds overhead to your UPDATE statements.

## Example

Scenario: You frequently look up orders by OrderDate, but the table is physically sorted by OrderID.

-- 1. Create the Non-Clustered Index

    CREATE NONCLUSTERED INDEX IX_Orders_OrderDate
    ON Orders (OrderDate);

-- 2. Run the Query

-- This query will cause a Key Lookup
-- because CustomerName is not in the index

    SELECT OrderID, CustomerName 
    FROM Orders 
    WHERE OrderDate = '2026-01-21';

-- Mechanism:

1. SQL looks at IX_Orders_OrderDate to find '2026-01-21'.

2. It finds the pointer (OrderID) for those rows.

3. It jumps to the main table to grab 'CustomerName'.

