# PARTITION BY

## What is PARTITION BY?

A. PARTITION BY is a sub-clause used within the OVER() clause of a window function. It divides the result set into partitions (groups) and performs the calculation separately for each group.

B. Unlike GROUP BY, which collapses rows into a single summary line, PARTITION BY allows you to keep every individual row while still performing "group-level" math next to it.

## Analogy

### Scenario 1: Without Partitioning

Imagine a worldwide marathon.

All runners, from every country, are placed in one giant ranking list.

The fastest runner overall gets Rank #1, the second fastest gets Rank #2, and so on.

That’s like RANK() or ROW_NUMBER() without PARTITION BY — one continuous sequence across everyone.

### Scenario 2: With Partitioning

Now imagine the same marathon, but results are announced per country.

In India, the fastest runner gets Rank #1.

In Canada, the fastest runner also gets Rank #1.

In Japan, again the fastest runner gets Rank #1.

The numbering restarts for each country, instead of continuing globally.

That’s exactly what PARTITION BY Country does — it resets the ranking inside each group.

## Syntax

    ROW_NUMBER() OVER (
    PARTITION BY Category        -- resets per category
    ORDER BY Price DESC          -- mandatory for ranking
    ) AS RankInCategory


## When to Use

Top-N per Group: Finding the top 3 most expensive products in every category.

Running Totals per Department: Calculating how much budget has been spent so far within each specific project.

Deduplication: When you have duplicates and want to keep the "latest" record for each unique UserID.

Comparative Reporting: Showing an employee's salary right next to the Average Salary for their specific department.

## When NOT to Use

Grand Totals: If you need a calculation across the entire table (e.g., total company revenue), don't partition; use a window aggregate without PARTITION BY (e.g., SUM(...) OVER())

Simple Grouping: If you don't need to see the individual rows (e.g., just a list of Categories and their Sums), a standard GROUP BY is faster and more readable.

## What Problem Does It Solve?

It solves the "Row vs. Group" conflict. Usually, SQL forces you to choose: either see every row OR see a group summary. PARTITION BY lets you see both. It eliminates the need for expensive self-joins and messy subqueries to compare a row to its "siblings."

## Common Misconceptions / Important Notes

It is NOT GROUP BY: GROUP BY reduces the number of rows returned. PARTITION BY never changes the row count; it only adds a calculated value to each existing row.

Multiple Columns: You can partition by multiple columns (e.g., PARTITION BY Region, Year).

Logical Order: Partitioning happens in-memory after the WHERE clause has finished. This means you are partitioning the filtered data.

## Example

Scenario: You are building a dashboard for a company with multiple warehouses. For each item, you want to show the Maximum Price found in that specific item's warehouse so the manager can see how prices compare locally.

```sql
SELECT 
    WarehouseName,
    ItemName,
    BasePrice,
    -- This calculates the MAX price per warehouse without losing row detail
    MAX(BasePrice) OVER(PARTITION BY WarehouseName) AS MaxPriceInThisWarehouse,
    -- This shows the difference between the item and its warehouse peak
    (MAX(BasePrice) OVER(PARTITION BY WarehouseName) - BasePrice) AS PriceGap
FROM Inventory;

