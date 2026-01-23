# STORED PROCEDURES

In the context of .NET Core development, Stored Procedures (SP) are often the "boundary" between your C# application and the raw database. They are heavily used in enterprise environments for security and performance.

## What is Stored Procedure?

A Stored Procedure is a named, stored collection of SQL statements whose execution plan is compiled and cached by SQL Server, typically on first execution.

Unlike a standard SELECT query which is sent as raw text every time, a Stored Procedure is parsed, optimized, and compiled by the database engine ahead of time (mostly).

## Analogy

Think of Ordering Food at a Restaurant.

Ad-Hoc Query: You say, "I want two slices of bread, a beef patty cooked medium, a slice of cheddar cheese, lettuce, and tomato." (You have to list every ingredient every time).

Stored Procedure: You say, "I'll have the #1 Combo."

It is Faster: You say fewer words (less network traffic).

It is Pre-defined: The kitchen knows exactly how to make it efficiently.

A Stored Procedure is a named, stored collection of SQL statements whose execution plan is compiled and cached by SQL Server, typically on first execution.

## Syntax

        CREATE PROCEDURE ProcedureName
    @Parameter1 DataType,
    @Parameter2 DataType = DefaultValue -- Optional
    AS
    BEGIN
    SET NOCOUNT ON; -- Optimization: Stops the "1 row affected" network message

    -- Logic goes here
    SELECT * FROM TableName WHERE Column = @Parameter1;
    END

## When to Use

Complex Logic: When an operation involves 10 steps, 3 tables, and multiple updates (e.g., "Process Monthly Payroll"). Doing this in one SP call is much faster than 10 separate API calls from C#.

Security: Prevents SQL Injection. You can grant users permission to execute the procedure without giving them permission to read/write the actual tables.

Performance: Reduces network traffic. Instead of sending 1,000 lines of SQL text over the wire, you send EXEC sp_Name.

## When NOT to Use

Simple CRUD: If you are just doing SELECT * FROM Users WHERE ID = 1, using Entity Framework (LINQ) is easier to maintain and test. Writing an SP for every single select is overkill ("Spaghetti SQL").

Business Logic: Avoid putting core business rules (e.g., "Calculate Insurance Risk Score") inside SQL. That logic belongs in your C# domain layer where it can be unit tested and version controlled.

Portability: If you plan to switch from SQL Server to PostgreSQL later, rewriting hundreds of SPs is a nightmare.

## What Problem Does It Solve?

It solves the Network Latency and Security problem.

Latency: It bundles multiple steps into one round-trip to the server.

Security: It acts as a shield. Even if a hacker finds your API, they can't run DROP TABLE if the SP only allows SELECT.

## Common Misconceptions / Important Notes

"They are always faster": False. A poorly written SP is just as slow as a poorly written query.

Parameter Sniffing: This is a classic bug. SQL Server creates an execution plan based on the first parameter you send (e.g., ID=1). If you later send ID=1,000,000, that plan might be terrible. (Fix: Use WITH RECOMPILE or optimize queries).

SET NOCOUNT ON: Always include this at the top. It stops SQL from sending the "X rows affected" message for every internal statement, slightly improving performance.

## Example

Scenario: We want to update a product's price and keep a history log of the old price in a single atomic action.

```sql

CREATE PROCEDURE sp_UpdateProductPrice
    @ProductID INT,
    @NewPrice DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Log the old price
        INSERT INTO PriceHistory (ProductID, OldPrice, ChangeDate)
        SELECT ProductID, Price, GETDATE() 
        FROM Products WHERE ProductID = @ProductID;

        -- 2. Update to new price
        UPDATE Products 
        SET Price = @NewPrice 
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH
END

Usage: EXEC sp_UpdateProductPrice @ProductID = 101, @NewPrice = 19.99;
