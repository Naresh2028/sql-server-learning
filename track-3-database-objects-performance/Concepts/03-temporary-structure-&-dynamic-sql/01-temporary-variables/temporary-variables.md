# TEMPORARY VARIABLES
In SQL Server, when developers say "Temporary Variable" in the context of storing datasets, they are almost always referring to a Table Variable. (If you meant a simple single-value variable like INT or VARCHAR, that is a "Scalar Variable").


## What is Temporary variable?
A Table Variable is a special type of local variable that can store an entire table of data (rows and columns) instead of just a single value.

Like a standard variable (DECLARE @x INT), it exists conceptually as a variable, but is physically stored in tempdb when needed.
only for the duration of the specific batch of code where it is defined. Once that specific block of code finishes running, the variable vanishes instantly.

## Analogy
Think of a Sticky Note (Post-it) on your desk.

Temp Table (#Table): A whiteboard on the wall. It's big, you can write a lot, and if you leave the room for a minute, it's still there until you erase it.

Table Variable (@Table): A small sticky note. It’s perfect for jotting down a quick list of 5 items. It is personal to you, very fast to grab, but you can't write a novel on it, and if you sneeze (the batch ends), it's gone.

## Syntax

    -- Defined using "DECLARE" instead of "CREATE"
    DECLARE @TodaySales TABLE (
    ProductID INT,
    Amount DECIMAL(10,2)
    );

    -- Insert data just like a real table
    INSERT INTO @TodaySales (ProductID, Amount)
    VALUES (101, 19.99), (102, 50.00);

    -- Query it
    SELECT * FROM @TodaySales;

## When to Use

Small Datasets: Perfect for holding small lists (e.g., less than 100 rows), like a list of IDs to filter by.

User-Defined Functions: You cannot use Temporary Tables (#Table) inside a Function, but you can use Table Variables.

Loop Processing: Table variables can be convenient inside loops because they do not cause recompilations like temp tables, but this benefit disappears as data size grows.

## When NOT to Use

Large Datasets: Table Variables do not support Statistics. This means SQL Server guesses that the table has only 1 row (even if it has 1 million). This leads to terrible Execution Plans for large data.

Complex Joins: If you need to join this variable to 5 other tables, use a Temp Table (#Table) instead so the optimizer can do its job properly.

Indexing: You cannot add an index after creating the variable. (Note: You can define a Primary Key / Unique constraint inline during declaration, which creates an index, but it's limited).

## What Problem Does It Solve?

It reduces recompilation overhead and simplifies short-lived data storage, but does not eliminate logging or tempdb usage. Temp Tables (#Table) require transaction logging and locking in the system database. Table Variables generate much less logging activity, making them extremely lightweight for quick, small operations.

## Common Misconceptions / Important Notes

"They are Memory-Only": False. If a Table Variable gets too big, SQL Server will silently write it to disk (TempDB), just like a Temp Table, but with none of the performance benefits of a Temp Table.

"Scope": The scope is the Batch, not the Session.

If you run DECLARE @T... and then in a separate window (or separate GO command) try to SELECT * FROM @T, it will fail.

A Temp Table (#T) would persist across batches.

Transactions: Table Variables do not participate in transactions. If you BEGIN TRAN, insert into a Table Variable, and then ROLLBACK, the data in the Table Variable remains. (This is a cool trick for "logging errors" even when a transaction fails!)

## Example

Scenario: We want to verify which of 3 specific Product IDs exist in our database.

        
    -- 1. Declare the variable
    DECLARE @MyList TABLE ( ItemID INT PRIMARY KEY );

    -- 2. Fill it with the IDs we care about
    INSERT INTO @MyList VALUES (101), (500), (999);

    -- 3. Use it to filter the real table
    SELECT p.ProductName, p.Price
    FROM Products p
    JOIN @MyList l ON p.ID = l.ItemID;
    
Result: Fast, clean, and no cleanup code (DROP TABLE) needed.

Summary: Temp Table (#) vs Table Variable (@)

| Feature      | Temp Table (#)                          | Table Variable (@)                          |
|--------------|-----------------------------------------|---------------------------------------------|
| Scope        | Session (Connection)                    | Batch (Code Block)                          |
| Performance  | Good for Large Data (Has Stats)         | Good for Small Data (<100 rows)             |
| Transactions | Yes (Rollback removes data)             | No (Rollback keeps data)                    |
| Indexes      | Yes (Can add anytime)                   | Limited (Only inline Constraints)           |

