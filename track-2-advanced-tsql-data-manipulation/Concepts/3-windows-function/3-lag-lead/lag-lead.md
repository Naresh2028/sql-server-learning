# LAG & LEAD

## What are LAG & LEAD?

LAG and LEAD are window functions that allow you to access data from a different row relative to the current row, without using a self-join.

A. LAG: "Looks back" at a previous row.

B. LEAD: "Looks forward" at a subsequent row

## Analogy

Think of a Relay Race.

If you are the runner currently holding the baton:

A. LAG is the person who just handed the baton to you (The Past).

B. LEAD is the person waiting ahead of you to take the baton next (The Future).

You can see both runners without leaving your spot on the track.

## Syntax

    LAG(expression [, offset] [, default_value]) 
    OVER ( [PARTITION BY partition_column] ORDER BY order_column )

    LEAD(expression [, offset] [, default_value]) 
    OVER ( [PARTITION BY partition_column] ORDER BY order_column )

expression → column/value you want previous/next value of

offset → how many rows back/forward (default = 1)

default_value → what to return if no previous/next row exists (default = NULL)

PARTITION BY → optional – reset calculation per group

ORDER BY → mandatory – defines the sequence

## When to Use

1. Year-over-Year (YoY) Analysis: Comparing this month's sales to last month's.

2. Difference Calculations: Finding the price change between the current item and the previous one.

3. Session Tracking: In web analytics, finding the time difference between a user's current click and their previous click.

4. Detecting Status Changes: Comparing the current "Status" of an order to its "Previous Status."

## When NOT to Use

1. Unordered Data: Never use them without a meaningful ORDER BY. Looking at the "previous row" is useless if the rows are in a random order.

2. Complex Dependencies: If you need to look back based on a complex logic (like "the last row where Status was 'Paid'"), a Correlated Subquery or CROSS APPLY might be more appropriate.

## What Problem Does It Solve?
It solves the "Inter-row Comparison" problem. Traditionally, to compare a row to the one before it, you had to perform a Self-JOINs can be harder to read and may be less efficient than window functions, depending on data size, indexes, and execution plan. and hard to read. LAG/LEAD perform this in a single pass over the data ($O(n \log n)$ due to sorting).

## Common Misconceptions / Important Notes

A. They aren't just for numbers: You can use them on strings, dates, or any data type.

B. The "Default" matters: If you are calculating a difference (Current - Previous), the first row will result in NULL unless you provide a 0 as the DefaultValue.

C. Physical vs. Logical: These functions look at the physical position of rows in the result set after the ORDER BY is applied.

## Example

Sales Trend Analysis – "Day-over-Day Change"

Problem:
You want to know for each day:

How many units were sold today
How many were sold yesterday (previous day) → using LAG
How many will be sold tomorrow (next day) → using LEAD
And calculate the day-over-day difference (growth/decline)

This is extremely common in sales reporting, inventory forecasting, and performance dashboards.


    SELECT 
    SaleDate,
    Product,
    UnitsSold                          AS TodayUnits,
    
    LAG(UnitsSold) OVER (ORDER BY SaleDate) 
        AS YesterdayUnits,
        
    UnitsSold - LAG(UnitsSold) OVER (ORDER BY SaleDate) 
        AS DayOverDayChange,
        
    CASE 
        WHEN UnitsSold > LAG(UnitsSold) OVER (ORDER BY SaleDate) THEN '↑ Growth'
        WHEN UnitsSold < LAG(UnitsSold) OVER (ORDER BY SaleDate) THEN '↓ Drop'
        ELSE '→ Same'
    END AS Trend,
    
    LEAD(UnitsSold) OVER (ORDER BY SaleDate) 
        AS TomorrowUnits,
        
    -- Bonus: Percentage change from yesterday
    ROUND(
        CASE 
            WHEN LAG(UnitsSold) OVER (ORDER BY SaleDate) = 0 THEN NULL
            ELSE 
                (CAST(UnitsSold AS DECIMAL) - LAG(UnitsSold) OVER (ORDER BY SaleDate)) 
                / LAG(UnitsSold) OVER (ORDER BY SaleDate) * 100
        END, 1) AS PercentChangeFromYesterday

    FROM DailySales
    ORDER BY SaleDate;
