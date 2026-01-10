# RANK & DENSE_RANK

---In T-SQL, RANK and DENSE_RANK are the "competitive" siblings of ROW_NUMBER

## What are RANK & DENSE_RANK?

These are window functions used to assign a rank to each row within a partition.

1. RANK(): Assigns a rank but leaves gaps in the numbering if there is a tie.

2. DENSE_RANK(): Assigns a rank and leaves no gaps; the next number is always the immediate next integer.

## Analogy
Think of a Standard High School Race:

    A. RANK (With Gaps):
    Two runners finish at the exact same time and both receive Rank 1.
    The next runner is assigned Rank 3 because two people are ranked ahead.
    Rank 2 is skipped.

    B. DENSE_RANK (No Gaps):
    Two runners finish at the same time and both receive Rank 1.
    The next runner is assigned Rank 2.
    No rank numbers are skipped.


## Syntax
    SELECT 
    Column1, 
    RANK() OVER (ORDER BY Column2 DESC) AS Rank_Gap,
    DENSE_RANK() OVER (ORDER BY Column2 DESC) AS Rank_Dense
    FROM TableName;

## When to Use

A. Leaderboards: Showing who is in 1st, 2nd, and 3rd place in a sales competition.

B. Price Tiers: Grouping products into "Price Levels" where multiple products share the same level.

C. Academic Grading: Determining class standings where multiple students have the same GPA.

## When NOT to Use

1. Pagination: Never use these for pagination because you might get multiple "Page 1s" if there are ties, which will break your Angular logic. Use ROW_NUMBER for that.

2. Unique Row Identification: If you need a unique number for every row, these will fail you because they assign the same number to ties.

## What Problem Does It Solve?

1. It solves the problem of ranking data fairly when ties exist.
 
2. In many real-world scenarios (scores, prices, performance metrics), multiple rows can have the same value.

3. RANK and DENSE_RANK allow those rows to share the same position instead of forcing an artificial unique order.

## Common Misconceptions / Important Notes

1. Performance Cost:
RANK and DENSE_RANK can be slightly more expensive than ROW_NUMBER because the database must evaluate ties while computing the window function. This usually involves additional sorting or comparison work during query execution.

2. Partitioning: Just like ROW_NUMBER, you can use PARTITION BY with these to find the top performers per department or per region.

## ⚖️ Difference Between RANK vs. DENSE_RANK

This is a very common interview question.

| Function    | Handling of Ties                  | Resulting Sequence Example |
|-------------|-----------------------------------|----------------------------|
| ROW_NUMBER  | Unique number for every row       | 1, 2, 3, 4, 5              |
| RANK        | Same number for ties; skips next  | 1, 1, 3, 4, 4, 6           |
| DENSE_RANK  | Same number for ties; no skips    | 1, 1, 2, 3, 3, 4           |


## Example

Scenario: You have a list of developers and their total completed "tickets." You want to see their standing in the company. Note that "Sarah" and "Mike" have both finished 50 tickets.

```sql
SELECT 
    DeveloperName,
    TicketsFinished,
    RANK() OVER (ORDER BY TicketsFinished DESC) AS Total_Rank,
    DENSE_RANK() OVER (ORDER BY TicketsFinished DESC) AS Dense_Standing
FROM CompanyPerformance;
