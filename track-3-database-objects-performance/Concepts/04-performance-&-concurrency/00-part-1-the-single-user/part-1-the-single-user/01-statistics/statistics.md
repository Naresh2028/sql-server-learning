# STATISTICS

In the context of SQL Server Performance Tuning, Statistics are the brain behind the Query Optimizer. If Execution Plans are the "Map," then Statistics are the "Traffic Report."

## What is Statistics?

Statistics are binary objects (BLOBs) that contain mathematical summaries about the distribution of values in a column.

The core of a Statistic object is a Histogram. This Histogram tells the database engine: "How many rows contain the value 'A'? How many contain 'B'? Are the values unique or highly repeated?"

SQL Server uses this data to estimate how many rows a query will return (Cardinality Estimation). This estimate decides whether to use a fast Index Seek or a slow Table Scan.

## Analogy

Think of a Traffic Report (or Waze/Google Maps Data).

The Goal: Drive to the office.

The Reality: There are two routes. Route A is usually fast, but Route B is shorter.

The Statistics: The Traffic Report says, "Route A is currently jammed with 5,000 cars. Route B has 10 cars."

The Decision: Based on that report, you choose Route B.

If the Statistics are outdated (from last Sunday), you might choose Route A and get stuck in traffic (Poor Performance).

## Syntax

Statistics are usually created and updated automatically, but you can manage them manually.

```sql
-- 1. Update statistics for a specific table manually
UPDATE STATISTICS TableName;

-- 2. View the histogram details (The "Traffic Report")
DBCC SHOW_STATISTICS ('TableName', 'IndexName');
```

## When to Use

After Bulk Inserts: If you just imported 1 million rows, the auto-stats might not have triggered yet. The database thinks the table is empty. Run UPDATE STATISTICS.

Troubleshooting Slow Queries: If a query was fast yesterday but slow today, check if the data distribution changed significantly.

Skewed Data: If you have a column where one value appears 99% of the time (e.g., "Active Users") and another appears 1% ("Banned Users"), accurate stats are critical to treat those two queries differently.

## When NOT to Use

Micro-Management: Do not write scripts to update statistics every 5 minutes. Updating stats causes queries to recompile, which uses CPU. Let the default "Auto Update Statistics" setting handle 99% of cases.

## What Problem Does It Solve?

It solves the "Cost Estimation" problem. To choose a plan, the Optimizer asks: "Will WHERE City = 'London' return 5 rows or 5 million rows?"

If 5 rows: Use an Index Seek (Pinpoint pickup).

If 5 million rows: Use a Table Scan (Read everything). Statistics provide the answer to that question.

## Common Misconceptions / Important Notes

Sampling: By default, SQL Server scans a random sample of rows to build stats (not the whole table). On huge tables, this sample might be inaccurate. You can force a FULLSCAN update if needed.

Stale Stats: If stats are "Stale" (old), the execution plan will be optimized for the old data, leading to terrible performance on the new data.

Filtered Statistics: You can create statistics for just a subset of rows (e.g., WHERE Date > '2025') to give the optimizer hyper-accurate info for recent data.

## Example

Scenario: We have a Status column.

'Active' = 1,000,000 rows.

'Closed' = 10 rows.

The Query: SELECT * FROM Orders WHERE Status = @Input

The Impact of Statistics:

If Input is 'Closed': Statistics tell SQL "This is rare (10 rows)." SQL chooses an Index Seek (Fast).

If Input is 'Active': Statistics tell SQL "This is huge (1M rows)." SQL chooses a Table Scan (Efficient for bulk reads).

If Stats are Missing: SQL might guess wrong, trying to Index Seek 1,000,000 rows, which would be catastrophically slow.
