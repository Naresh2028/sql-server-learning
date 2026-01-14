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
## When to Use
## When NOT to Use
## What Problem Does It Solve?
## Common Misconceptions / Important Notes
## Example

