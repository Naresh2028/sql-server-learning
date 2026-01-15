# CAST & CONVERT

In the world of .NET Core development, data type mismatches are a frequent headache. You might receive a date as a string from an API or need to turn a decimal into a formatted string for an Angular UI. CAST and CONVERT are your two primary tools for making data types play nice together.

## What are CAST & CONVERT

Both are functions used to change an expression from one data type to another (e.g., turning the number 10 into the text '10').

  CAST: The ANSI-standard way to convert data. It is simpler and works across almost all SQL database types (PostgreSQL, MySQL, Oracle).

  CONVERT: A SQL Server-specific function. It does exactly what CAST does but adds a powerful Style parameter for formatting (especially     for dates and currency).
  
## Analogy

CAST: Think of a Universal Travel Adapter. It’s basic and works everywhere to make one plug fit into another socket. It doesn't have fancy features; it just connects them.

CONVERT: Think of a Professional Chef’s Food Processor. It not only changes the form of the food (from solid to liquid) but also allows you to choose the "Blade" (Style)—you can choose to slice, dice, or puree specifically how you want the output to look.

## Syntax

-- CAST Syntax (Simple)
  
    CAST ( expression AS data_type [ ( length ) ] )

-- CONVERT Syntax (Detailed)

    CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

## When to Use

CAST: Use this for simple conversions (Decimal to Int, Int to Varchar) when you want your code to be portable and clean.

CONVERT: Use this specifically when dealing with Dates or Money where you need a specific format (e.g., MM/DD/YYYY vs DD.MM.YYYY).

## When NOT to Use

Inside tight loops on massive tables: If you can store the data in the correct type to begin with, do it. Converting 10 million rows during a SELECT is slower than reading the correct type directly.

Mathematical Logic: Don't convert a string to a number in every WHERE clause; it prevents SQL from using indexes.

## What Problem Does It Solve?

CAST: Solves the Standardization Problem. It ensures that your SQL code follows international standards and is easy for any developer to read.

CONVERT: Solves the Formatting Problem. It allows the database to handle the visual "look" of data, saving you from writing complex string-manipulation logic in your C# backend.

## Common Misconceptions / Important Notes

Truncation:
When using CAST/CONVERT in a SELECT, SQL Server may silently truncate data.
However, during INSERT or UPDATE operations, truncation usually raises an error.

Performance: There is no significant performance difference between the two. The choice is purely about "Portability" (CAST) vs. "Formatting" (CONVERT).

Try_Cast / Try_Convert: In modern SQL, use these variants if you aren't sure the data can be converted. They return NULL instead of crashing the whole query if a conversion fails.

SARGability:
Avoid applying CAST or CONVERT on indexed columns inside WHERE clauses.

    Example (bad):
        WHERE CAST(OrderDate AS DATE) = '2026-01-01'

    Better:
    WHERE OrderDate >= '2026-01-01'
    AND OrderDate <  '2026-01-02'


## Example: CAST

Scenario: You have a decimal price and you want to concatenate it with a string for a simple label.

    SELECT 
    ProductName,
    'Price: ' + CAST(BasePrice AS VARCHAR(10)) AS PriceLabel
    FROM Products;


Example: CONVERT

Scenario: You need to display a "ShipDate" in a specific European format (DD/MM/YYYY) for a Canadian logistics report.

    SELECT 
    OrderID,
    CONVERT(VARCHAR, OrderDate, 103) AS EuropeanFormat, -- 103 is the style for DD/MM/YYYY
    CONVERT(VARCHAR, OrderDate, 101) AS USFormat       -- 101 is the style for MM/DD/YYYY
    FROM Orders;
