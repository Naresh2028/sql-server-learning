# QUERY OPTIMIZATION (SARGable)

In the context of .NET Core and SQL Server, SARGable is the most critical concept for writing high-performance SQL. If your queries are not SARGable, your Indexes are useless.

## What is Query Optmization?

SARGable stands for "Search ARGument ABLE".

A query is SARGable if it is written in a way that allows the SQL Server Query Engine to utilize an Index effectively (specifically an "Index Seek") instead of scanning every single row in the table ("Index Scan" or "Table Scan").

If you wrap a column in a function (e.g., WHERE YEAR(Date) = 2026), the query becomes Non-SARGable. The engine cannot look up the "Year" in the index; it has to calculate the year for every single row to check if it matches.

## Analogy

Think of a Phone Book.

SARGable Query: "Find everyone whose last name starts with 'S'."

You go straight to the 'S' section. (Fast).

Non-SARGable Query: "Find everyone whose last name ends with 'th'."

You cannot use the alphabetical order. You have to read every single name in the book from A to Z to check the last two letters. (Slow).

## Syntax

The Golden Rule: Never manipulate the column side of the comparison. Manipulate the value side instead.

```sql

-- ❌ BAD (Non-SARGable)
-- The engine must apply the function to every row.
WHERE YEAR(OrderDate) = 2026;

-- ✅ GOOD (SARGable)
-- The engine searches the raw range directly in the index.
WHERE OrderDate >= '2026-01-01' AND OrderDate < '2027-01-01';

```

## When to Use

Always. Writing SARGable queries should be your default coding standard in C# (LINQ) and SQL.

Filtering: Anytime you use a WHERE clause.

Joining: Anytime you use an ON clause in a JOIN.

## When NOT to Use

Small Tables: On a table with 50 rows, the difference is negligible (microseconds).

Business Logic constraints: Sometimes complex logic (e.g., hash comparisons) is unavoidable, but 99% of queries should be SARGable.

## What Problem Does It Solve?

It solves the "Index Suppression" problem. You might have spent hours designing the perfect Index, but a Non-SARGable query forces the database to ignore that index and revert to a brute-force Table Scan. This causes High CPU usage and slow response times.

## Common Misconceptions / Important Notes	

Leading Wildcards: LIKE '%Smith' is Non-SARGable. It forces a scan because you don't know the first letter. LIKE 'Smith%' is SARGable.

Implicit Conversions: Comparing a VARCHAR column to an NVARCHAR parameter (Unicode) can implicitly convert the column, making it Non-SARGable. Always match your C# types to SQL types.

Functions: UPPER(), LOWER(), ABS(), ISNULL() on the column usually kill performance.

## Example

Scenario: We need to find all users named "John" (case-insensitive).

1. The Non-SARGable Way (Slow)

````sql
-- The engine has to convert 'Name' to Upper Case for 1 million rows 
-- BEFORE it can check if it equals 'JOHN'.
SELECT * FROM Users 
WHERE UPPER(FirstName) = 'JOHN'; 

-- Result: Index Scan (Reads 1,000,000 rows).

````
2. The SARGable Way (Fast)

````sql
-- SQL Server is case-insensitive by default. 
-- We search the raw column directly.
SELECT * FROM Users 
WHERE FirstName = 'John';

-- Result: Index Seek (Reads 5 rows).

````


