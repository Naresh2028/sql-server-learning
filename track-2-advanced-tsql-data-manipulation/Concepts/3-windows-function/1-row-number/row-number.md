# ROW_NUMBER

## What is ROW_NUMBER?

1. ROW_NUMBER is a temporary ranking function that assigns a unique, sequential integer to each row in a result set. The numbering starts at 1 for the first row in every "window" or partition.

2. Unlike IDENTITY columns, ROW_NUMBER is calculated at runtime based on how you sort the data in the query, not how it's stored on the disk.

## Analogy
Scenario 1: One Big Queue

Think of a railway ticket counter at Chennai Central.
    
    Everyone stands in a single line.
    The clerk gives tokens: 1, 2, 3, 4… continuously.
    
That’s like ROW_NUMBER() without PARTITION BY.

Scenario 2: Separate Queues

Now imagine there are two counters:

    One for General Tickets
    One for Platform Tickets
    At each counter, numbering starts again from 1:
    General Tickets line → 1, 2, 3, 4…
    Platform Tickets line → 1, 2, 3, 4…

That’s like ROW_NUMBER() OVER (PARTITION BY CounterType ORDER BY …).

## Syntax

    SELECT 
    Column1, 
    ROW_NUMBER() OVER (
        [PARTITION BY Column2] -- Optional: Resets the count
        ORDER BY Column3       -- Mandatory: Decides the sequence
    ) AS RowNum
    FROM TableName;

## When to Use

A. Pagination: Essential for web apps to show "Results 1 to 10" on Page 1.

B. Finding the Latest Record: Getting the single most recent order for every customer.

C. Deduplication: Identifying and deleting duplicate rows by selecting everything where RowNumber > 1.

D. Ranking: Assigning a unique place to participants in a competition.

## When NOT to Use

1. When you want gaps: If two people have the same score and you want them both to be "#1," use RANK or DENSE_RANK instead.

2. Permanent IDs: Never use ROW_NUMBER as a Primary Key. It changes if your ORDER BY changes or if data is filtered.

## What Problem Does It Solve?
It solves the "Top 1 per Group" problem. Before ROW_NUMBER, finding the most recent record for 1,000 different users required very slow and complex subqueries. Now, it can be done in a single pass.

## Common Misconceptions / Important Notes	

1. ORDER BY is Mandatory: You cannot use ROW_NUMBER without an ORDER BY clause inside the OVER() parentheses.

2. It doesn't affect the final sort: The ORDER BY inside ROW_NUMBER only determines how the numbers are assigned. If you want the final result set sorted, you still need an ORDER BY at the very end of the query.

3. No Gaps: ROW_NUMBER will always be 1, 2, 3... regardless of whether the values in the ORDER BY column are the same (ties).

## Example
Scenario: You have a list of products and their prices. You want to number the products from most expensive to cheapest within each category.

    SELECT 
    CategoryName,
    ProductName,
    BasePrice,
    ROW_NUMBER() OVER (
        PARTITION BY CategoryName -- Starts the count over for each category
        ORDER BY BasePrice DESC   -- The most expensive gets #1
    ) AS PriceRank
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID;
