# TEMPORARY TABLES

In complex .NET Core applications, you often need to perform multi-step data processing that is too complicated for a single query but doesn't deserve a permanent table. Temporary Tables are the standard solution.

## What is Table Table?

A Temporary Table is a table that physically exists in the database (specifically in the system database called tempdb), but it is generally visible only to the user who created it and is automatically deleted when that user disconnects.

There are two main types:

Local Temp Table (#Name): Visible only to the current connection. (Most common).

Global Temp Table (##Name): Visible to everyone, deleted when the last connection referencing it closes. (Rarely used).

## Analogy
Think of a Whiteboard in a Meeting Room.

Permanent Table: This is a filing cabinet. The files stay there forever, even after you go home.

Temporary Table: This is the whiteboard. You walk in, write down some numbers to help you calculate a result during the meeting. When you leave the room (close the connection), the janitor comes in and wipes the board clean.


## Syntax

-- The '#' prefix tells SQL Server this is a Local Temp Table

    CREATE TABLE #TempUserStats (
    UserID INT,
    TotalSpent DECIMAL(10,2)
    );

-- OR (The shortcut "Select Into")

    SELECT UserID, SUM(Amount) as TotalSpent
    INTO #TempUserStats
    FROM Orders
    GROUP BY UserID;


## When to Use

Staging Data: When you need to massage data (clean it, validate it) before inserting it into a real table.

Complex Reporting: When a report requires 5 different steps. You save the result of Step 1 into a #Temp, then join Step 2 to #Temp, etc.

Performance Optimization: Unlike CTEs (which are just syntax sugar), Temp Tables allow you to create indexes on them. If you have a complex intermediate result set that you query multiple times, putting it in a specific Temp Table with an Index is often much faster.

## When NOT to Use

Simple Queries: If you can write it in a single SELECT or use a CTE, don't waste resources creating a temp table.

Persisting Data: Never rely on a temp table to store data for more than a few milliseconds/seconds. It will be gone if your code crashes or the connection drops.

Micro-Transactions: Creating and dropping tables has a cost. Doing this inside a loop that runs 1,000 times a second will slow down your server.

## What Problem Does It Solve?

It solves the "Divide and Conquer" problem. It allows you to break a massive, unreadable 500-line SQL query into 5 readable, manageable chunks. It also solves Performance Bottlenecks by allowing you to index intermediate results.

## Common Misconceptions / Important Notes

"They live in RAM": False. They live in the tempdb database on the hard drive (though SQL Server caches them in RAM if possible).

"Table Variables are better": It depends. Table Variables (@Table) are memory-only but cannot have indexes (mostly). For large datasets (>100 rows), Temp Tables (#Table) are usually faster because they support statistics and indexing.

Naming Collisions: You don't need to worry about two users creating #MyTable at the same time. SQL Server appends a random suffix internally to keep them separate for each user.

## Example

Scenario: We need to find the Top 10 Customers and then find which of those 10 bought "Bananas". Doing this in one query is messy.

```sql

-- 1. Create a Temp Table for the Top 10 Big Spenders
SELECT TOP 10 CustomerID, SUM(TotalAmount) AS TotalSpent
INTO #TopSpenders -- Creates the table automatically
FROM Orders
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- Optional: Add an index for speed!
CREATE INDEX IX_TopSpenders_ID ON #TopSpenders(CustomerID);

-- 2. Now join that small list to the OrderItems table
SELECT t.CustomerID, t.TotalSpent
FROM #TopSpenders t
JOIN OrderItems oi ON t.CustomerID = oi.CustomerID
WHERE oi.ItemName = 'Banana';

-- 3. Cleanup (Good practice, though automatic)
DROP TABLE #TopSpenders;
