## Column Aliases & Expressions


## What are Column Aliases & Expressions
Column Aliases: These are temporary names assigned to a column or an expression in the result set of a query. 
They do not rename the column in the actual database table; they only change the header in your output.

Expressions: These are combinations of symbols and operators (mathematical, string, or logical) that SQL Server evaluates to obtain a single data value.

## Syntax
-- Column Alias Syntax (Recommended)
SELECT ColumnName AS NewName FROM Table;

-- Column Alias Syntax (Without AS – Valid but less readable)
SELECT ColumnName NewName FROM Table;

-- Expression Syntax
SELECT (ColumnA + ColumnB) AS SumResult FROM Table;


## Analogy
Imagine a Language Translator:
- The original column name is the source language
- The alias is the translated, user-friendly output


## When to Use
A. Renaming for Clarity: When the original column name is cryptic (e.g., renaming QTY_ON_HND to StockQuantity).

B. Calculated Fields: When performing math (e.g., Price * Discount) or string manipulation.

C.Aggregations: When using functions like SUM or AVG, SQL Server returns "(No column name)" unless you provide an alias.

D. API Mapping: When your SQL output needs to match the exact property names of a C# DTO (Data Transfer Object).

## When NOT to Use
A. In the WHERE Clause: 
You cannot use an alias in a WHERE clause because the SELECT list is processed after the filtering occurs.

B. Reserved Keywords:
Avoid using SQL keywords (e.g., DATE, ORDER, TABLE) as aliases.
If unavoidable, wrap them in square brackets, but prefer meaningful names.

## What problem Does it solve?
Readability: It turns raw, technical data into business-friendly information.

Ambiguity: When joining two tables that both have a column named ID, aliases help distinguish between UserID and AccountID.

## Example
SELECT 
    p.ProductName AS ItemName,                               -- Simple Alias
    p.BasePrice,
    p.UnitsInStock AS InventoryCount,                        -- Clarity Alias
    (p.BasePrice * p.UnitsInStock) AS GrossInventoryValue,    -- Math Expression
    (p.BasePrice * c.RegionTaxRate) AS EstimatedTaxPerUnit,   -- Cross-table Expression
    (p.BasePrice + (p.BasePrice * c.RegionTaxRate)) AS FinalConsumerPrice -- Complex Expression
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;


## Common Misconceptions
A. "Aliases rename the table columns": No. It is strictly a "display name" for that specific query execution.

B. "Using AS slows down the query": No. Aliases are handled during the parsing phase.


