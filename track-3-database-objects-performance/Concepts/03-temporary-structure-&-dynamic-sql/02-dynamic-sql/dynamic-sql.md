# DYNAMIC SQL

In the world of .NET Core, Dynamic SQL is a powerful tool, but it is also the most dangerous weapon in your arsenal. If used incorrectly, it opens the door to hackers (SQL Injection). If used correctly, it solves problems that standard SQL cannot touch.

## What is Dynamic SQL?
Dynamic SQL is a technique where the SQL statement is constructed as a string at runtime and then executed.

Instead of writing a fixed query like SELECT * FROM Users, you write code that builds the string 'SELECT * FROM ' + @TableName and then tells the database engine to run that string.

## Analogy

Think of "Mad Libs" (or a Fill-in-the-Blank letter).

Static SQL: A printed wedding invitation. The text is fixed. You cannot change the date or the venue once it's printed.

Dynamic SQL: A blank template where you write in the details after knowing who the guest is. "Dear [Name], please come to [Place] on [Date]." You build the message on the fly based on the situation.

## Syntax
There are two ways to run it. Always prefer the second one.

1. The "Bad" Way (EXEC)

        DECLARE @SQL NVARCHAR(MAX) = 'SELECT * FROM Users';
        EXEC(@SQL);

 2. The "Good" Way (sp_executesql)

        DECLARE @SQL NVARCHAR(MAX) = N'SELECT * FROM Users WHERE ID = @id';
        -- Runs the string but keeps it secure with parameters
        EXEC sp_executesql @SQL, N'@id INT', @id = 1;

## When to Use

Flexible Search Grids: When a user can search by Name, OR Date, OR Price, OR all three. Building a single static query for every combination is a nightmare; building the WHERE clause dynamically is efficient.

Dynamic Object Names: If you need to query a different table based on the year (e.g., Sales_2024, Sales_2025). Standard SQL cannot handle variables in the FROM clause (FROM @TableName fails). Dynamic SQL can.

Maintenance Scripts: looping through all databases to run a backup or rebuild indexes.

## When NOT to Use

Standard CRUD: If you are just inserting or selecting a record by ID, use standard SQL or Entity Framework. Dynamic SQL adds complexity and hurts debugging.

User Input (without parameters): Never concatenate user input directly into the string (e.g., '... WHERE Name = ''' + @UserInput + '''). This is how data breaches happen.

## What Problem Does It Solve?

It solves the "Optional Parameters" complexity. Without Dynamic SQL, you often end up writing "Kitchen Sink" queries (WHERE (@Name IS NULL OR Name = @Name) AND ...), which can suffer from terrible performance (parameter sniffing). Dynamic SQL allows you to execute only the specific filters requested.

## Common Misconceptions / Important Notes

SQL Injection: This is the biggest risk. If you simply paste strings together, a user can type '; DROP TABLE Users; -- into a search box and delete your database. Always use sp_executesql with parameters.

Plan Caching: sp_executesql is smart—it saves the execution plan so it can be reused. EXEC(@SQL) does not reuse plans well, leading to slower performance.

Permissions: Dynamic SQL executes under the caller's security context by default.
To avoid exposing table permissions, use ownership chaining or EXECUTE AS inside the stored procedure.

## Example

Scenario: A "Product Search" feature where the user might search by Color, Size, both, or neither.

```sql

CREATE PROCEDURE dbo.sp_SearchProducts
    @Color NVARCHAR(50) = NULL,
    @Size NVARCHAR(50) = NULL
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Params NVARCHAR(MAX);

    -- 1. Start with the base query
    SET @SQL = N'SELECT Name, Price FROM Products WHERE 1=1';

    -- 2. Dynamically add criteria ONLY if they were provided
    IF @Color IS NOT NULL
        SET @SQL = @SQL + N' AND Color = @pColor';

    IF @Size IS NOT NULL
        SET @SQL = @SQL + N' AND Size = @pSize';

    -- 3. Define the parameters
    SET @Params = N'@pColor NVARCHAR(50), @pSize NVARCHAR(50)';

    -- 4. Execute safely
    EXEC sp_executesql @SQL, @Params, @pColor = @Color, @pSize = @Size;
END

```

Result: If the user provides only "Red", the database executes SELECT... WHERE 1=1 AND Color = @pColor. It never even checks the "Size" column, making it efficient.
