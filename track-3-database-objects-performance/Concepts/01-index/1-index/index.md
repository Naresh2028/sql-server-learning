# Index

## What is Index?
An index is a performance-tuning structure created on a table or view. It is a copy of specific columns from your table, organized in a very specific sorted order (usually a B-Tree structure).

Internally, SQL Server stores indexes using a Balanced Tree (B-Tree) structure.

A. Root Node → Entry point

B. Intermediate Nodes → Navigation paths

C. Leaf Nodes → Actual data pointers (or data itself for clustered indexes)

This structure guarantees predictable performance, allowing SQL Server to locate rows in logarithmic time (O(log n)), even as tables grow to millions of rows.

Its primary purpose is to allow the SQL Server database engine to find data without scanning every single row in the table.

## Analogy
Think of a Public Library.

Without an Index (Table Scan): To find a specific book by "J.K. Rowling," you would have to start at the first shelf, pick up every single book one by one, and check the author's name until you find it. This takes forever.

With an Index (Index Seek): You go to the Computer Catalog (The Index). You type "J.K. Rowling," and it tells you exactly which Aisle and Shelf to go to. You walk directly there and grab the book.

## Syntax

-- Basic syntax for creating an index on a column

    CREATE INDEX IX_IndexName
    ON TableName (ColumnName);

## When to Use

Search Columns: On columns frequently used in the WHERE clause (e.g., WHERE Email = '...').

Join Keys: On columns used to join tables (e.g., Foreign Keys like CustomerID, OrderID).

Sorting: On columns frequently used in ORDER BY. Since the index is already sorted, the database skips the expensive "Sort" operation.

## When NOT to Use

Small Tables: If a table has less than 1,000 rows, scanning the whole table is often faster than reading the index.

High Write Volume: Every time you INSERT, UPDATE, or DELETE, SQL Server must update the table AND every single index. Too many indexes will make your saving operations slow.

Low Selectivity: On columns with very few unique values (like Gender, IsActive, or Status). If an index returns 50% of the rows, the engine will ignore it and scan the table anyway.

Optimizer Cost Decisions: Even if an index exists, SQL Server may choose a scan if it estimates that most rows will be returned. This is why indexes on low-selectivity columns (like Status or IsActive) are often ignored.

## What Problem Does It Solve?

It solves the I/O (Input/Output) Bottleneck. Reading data from the hard drive (Disk I/O) is the slowest part of any database operation. An index reduces the amount of data the engine needs to read from millions of pages down to just a handful.

Indexes allow SQL Server to perform an Index Seek instead of an Index Scan or Table Scan.

  Table Scan → Reads every row in the table (worst case)

  Index Scan → Reads every row in the index (better, but still expensive)

  Index Seek → Navigates directly to matching rows using the B-Tree (best case)

The Query Optimizer always prefers a Seek when the index is selective enough.

## Common Misconceptions / Important Notes

"More Indexes = Faster Reads": True, but "More Indexes = Slower Writes". You must find the balance.

"I created it, so it's used": False. The Query Optimizer decides whether to use your index based on cost. If it thinks the index is inefficient for a specific query, it will ignore it.

Maintenance: Indexes can get "fragmented" over time (like a disorganized bookshelf) and need to be Rebuilt or Reorganized periodically.

Covering Queries: If all required columns exist in the index (either as key columns or INCLUDED columns), SQL Server can avoid looking up the base table entirely, making the query even faster.

## Example

Scenario: Searching for a customer by their email address is taking 5 seconds. Solution: Create an index on the Email column.

-- 1. Create the index
    
    CREATE INDEX IX_Customers_Email 
    ON Customers (Email);

-- 2. Run the query

    SELECT * FROM Customers WHERE Email = 'bob@example.com';

-- result: The database now performs an "Index Seek" (Fast) 
-- instead of a "Table Scan" (Slow).
