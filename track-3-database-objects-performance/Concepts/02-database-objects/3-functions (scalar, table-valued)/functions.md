# FUNCTION

In SQL Server, Functions (User-Defined Functions or UDFs) are routines that accept parameters, perform an action (like a complex calculation), and return the result as a value.

## What is a Function?

A Function is a saved T-SQL routine that returns a value. Unlike Stored Procedures, functions are designed to be used inline within SQL statements (like SELECT, WHERE, or JOIN clauses).

## Analogy

Think of a Calculator Button.

You don't want to manually calculate (Fahrenheit - 32) * 5/9 every time you check the weather.

Instead, you program a "ToCelsius" button. You punch in a number (Input), hit the button (Function), and it instantly shows you the result (Output). You can use this result immediately in other larger calculations.

## Syntax

    CREATE FUNCTION fn_FunctionName (@Parameter DataType)
    RETURNS ReturnType
    AS
    BEGIN
      -- Logic
      RETURN @Result;
    END;

## When to Use

Calculations: For repetitive math or string manipulation (e.g., "FormatPhoneNumber" or "CalculateTax").

Inline Logic: When you need to transform data inside a SELECT statement (e.g., SELECT fn_GetAge(BirthDate) FROM Users).

## When NOT to Use

Changing Data: Functions generally cannot modify the database state. You cannot INSERT, UPDATE, or DELETE records inside a standard function.

Heavy Logic: Avoid putting slow functions inside a WHERE clause on a large table. It forces the database to run that function for every single row (a performance killer).

## What Problem Does It Solve?

It solves the "Repeatable Logic" problem. Instead of copying and pasting the same complex tax formula into 50 different reports, you write it once in a function. If the tax rate changes, you update only one place.

## Common Misconceptions / Important Notes

"Functions vs Stored Procedures": The main difference is usage. Functions must return a value and are used inside queries. Procedures can return values but are executed independently (EXEC sp_Name).

Deterministic vs Nondeterministic: A function is "Deterministic" if it always returns the same result for the same input (e.g., 2+2). It is "Nondeterministic" if the result changes (e.g., GETDATE()). SQL Server optimizes them differently.

## Example

      -- General usage in a query
    SELECT 
      OrderID, 
      fn_CalculateTax(SubTotal) AS TaxAmount -- Used right inside the SELECT
    FROM Orders;

# Types of Function

1. Scalar Function

2. Tabular Function

# SCALAR Function

## What it is
A Scalar Function takes one or more input parameters and returns a single value (a scalar). Think of it as a function that answers a specific question with one word or number.

## Example

Scenario: We need to format messy phone numbers into a standard (XXX) XXX-XXXX format.

      CREATE FUNCTION fn_FormatPhone (@RawNumber VARCHAR(20))
      RETURNS VARCHAR(20)
      AS
      BEGIN
          DECLARE @CleanNumber VARCHAR(20);
          -- Logic to add parenthesis and dashes...
          SET @CleanNumber = '(' + LEFT(@RawNumber, 3) + ')...'; 
          RETURN @CleanNumber;
    END;

Usage:

    SELECT Name, dbo.fn_FormatPhone(Phone) FROM Customers;
  
## When to Use

Formatting: Formatting Dates, Currencies, or Strings.

Math: converting units (Miles to Kilometers).

Single Value Lookups: Getting a "Status Name" from a Status ID (though a JOIN is usually better for performance).

# TABULAR Function

## What it is

A Table-Valued Function (TVF) returns a table as its result. It can be used just like a normal table in the FROM or JOIN clause.

There are two types:

Inline TVF: Contains a single SELECT statement (Very fast).

Multi-Statement TVF: Uses a BEGIN...END block to build a table variable (Slower).

## Example

Scenario: We want a function that returns all orders for a specific customer, just like a "Parameterized View."

      CREATE FUNCTION fn_GetOrdersByCustomer (@CustID INT)
      RETURNS TABLE
      AS
      RETURN (
          SELECT OrderID, OrderDate, TotalAmount
          FROM Orders
          WHERE CustomerID = @CustID
       );

-- Usage: Treat it like a table!

    SELECT * FROM fn_GetOrdersByCustomer(101) WHERE TotalAmount > 50;

## When to Use

Parameterized Views: When you want a View but need to pass a parameter (e.g., "Show me data for User X").

Complex Filtering: When you need to encapsulate complex filtering logic that returns a dataset, which you then want to JOIN to other tables.
