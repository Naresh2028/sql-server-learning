# RANK & DENSE_RANK

## What are RANK & DENSE_RANK?

These are window functions used to assign a rank to each row within a partition.

1. RANK(): Assigns a rank but leaves gaps in the numbering if there is a tie.

2. DENSE_RANK(): Assigns a rank and leaves no gaps; the next number is always the immediate next integer.

## Analogy
Think of a Standard High School Race:

A. RANK (The Olympic Way): Two people finish at the exact same time for 1st place. They both get Gold (1). The next person to cross the line gets Bronze (3) because two people are ahead of them. The #2 spot is skipped.

B. DENSE_RANK (The "No Gaps" Way): Two people finish for 1st place. They both get #1. The next person to cross the line is simply the next "rank" of person, so they get #2.

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

1. Pagination: Never use these for pagination because you might get multiple "Page 1s" if there are ties, which will break your Angular logic. Use ROW_NUMBER for that.

2. Unique Row Identification: If you need a unique number for every row, these will fail you because they assign the same number to ties.

## Common Misconceptions / Important Notes

1. Memory Usage: Both are slightly more "expensive" than ROW_NUMBER because the database has to look at the value of the previous row to decide if the current row is a "tie."

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
