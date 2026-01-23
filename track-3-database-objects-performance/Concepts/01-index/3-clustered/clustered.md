# CLUSTERED INDEX

## What is Clustered Index?

A Clustered Index sorts and stores the data rows of the table or view in order based on the Clustered Index key.

Because the data rows themselves are sorted and stored in the index, the Clustered Index IS the table. For this reason, there can be only one Clustered Index per table (because data cannot be physically sorted in two different ways at the same time).

Physically, SQL Server stores table data on 8 KB data pages.
A clustered index defines the physical order of these pages on disk based on the clustered key.

This means:

A. Rows with nearby clustered key values are stored next to each other

B.  Range scans (BETWEEN, >, <) can read data sequentially with minimal disk I/O

## Visual Representation

![Clustered Index Physical Ordering](./images/clustered-physical-order.png)

A clustered index defines the physical order of rows on disk.
Because data itself is sorted, only one clustered index can exist per table.


## Analogy

The phone book is not just a list of names; the entire physical book is organized alphabetically by name.

If you want to find "Smith," you flip to the 'S' section.

You cannot create a second Clustered Index on "Phone Number" because you cannot physically rip out the pages and re-arrange them to be sorted by number and name simultaneously.

## Syntax

-- Explicitly creating a Clustered Index

    CREATE CLUSTERED INDEX IX_Clustered_IndexName 
    ON TableName (ColumnName);

-- OR (Most Common)
-- It is usually created automatically when you define a Primary Key

    ALTER TABLE TableName 
    ADD CONSTRAINT PK_TableName PRIMARY KEY CLUSTERED (ID);

Important:

1. If a table already has a clustered index, creating a PRIMARY KEY will create it as NONCLUSTERED by default

2. SQL Server creates a clustered index for the PRIMARY KEY only if no clustered index already exists

## When to Use

Primary Key: It is standard practice to put the Clustered Index on the Primary Key (e.g., ID or EmployeeID).

Range Queries: On columns often used in BETWEEN, >, < queries (e.g., OrderDate). Since the data is physically sitting next to each other on the disk, reading a range of dates is incredibly fast.

Sorted Output: On columns frequently used in ORDER BY.

## When NOT to Use

Volatile Columns: Do not use it on a column that changes frequently (like a "Status" or "LastLogin"). If you change a Clustered Index value, the database has to physically move the row to a new page to keep the sort order correct. This is called Page Splitting and causes fragmentation.

GUIDs (UUIDs): Using a random GUID (NEWID()) as a Clustered Key is generally bad practice. Because GUIDs are random, new rows are inserted into the middle of the table rather than the end, causing massive fragmentation and slower performance.

Large Columns: Don't use long strings (e.g., VARCHAR(500)). The Clustered Key is copied into every Non-Clustered index as a pointer. If your key is huge, your entire database bloats.

## What Problem Does It Solve?

It solves the Sequential Access problem. It minimizes Disk I/O by keeping related data (like orders from the same month) physically close to each other on the hard drive. It also eliminates the need for a "Key Lookup" because once you find the key in the index, you already have the full data row.

## Common Misconceptions / Important Notes

"Primary Key is always Clustered": True by default, but not mandatory. You can configure a table to have a Non-Clustered Primary Key and a Clustered Index on a different column (e.g., Date), though this is an advanced technique.

"Heap": A table without a Clustered Index is called a Heap. Data is stored in no particular order, which makes retrieval very slow for large datasets.

Logical vs Physical Order:

ORDER BY controls the logical output order of a query.
The clustered index controls the physical storage order on disk.
They are related but not the same thing.

## Example

Scenario: You have an Employees table. You almost always look up employees by their EmployeeID.

-- By setting this as the PRIMARY KEY, SQL Server automatically 
-- creates a Clustered Index on EmployeeID.

    CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY, 
    LastName VARCHAR(50),
    FirstName VARCHAR(50)
    );

When you run: SELECT * FROM Employees WHERE EmployeeID = 105;

The engine goes straight to the specific page in the B-Tree 
and reads the row immediately.
