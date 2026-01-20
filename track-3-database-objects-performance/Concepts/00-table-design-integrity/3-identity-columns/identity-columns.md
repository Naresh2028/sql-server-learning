# IDENTITY COLUMNS

## What is Identity Columns?

An IDENTITY column is a special property assigned to a numeric column (usually INT or BIGINT) in a table. 
It tells SQL Server to automatically generate a sequence of numbers for that column whenever a new row is inserted.

You do not provide a value for this column; the database engine handles it for you to ensure it is unique and sequential.

## Analogy

Think of a "Take-a-Number" Ticket Dispenser at a government office or deli.

When you walk in, you pull a ticket.

You get #401. The next person gets #402.

You don't get to choose your number (you can't say "I want #500").

If you pull ticket #403 but then decide to leave the store without being served (a Cancelled Transaction), 
that ticket is in the trash. The next person still gets #404. The number #403 is gone forever.

## Syntax

    ColumnName DataType IDENTITY ( Seed , Increment )

Seed: The starting number (usually 1).

Increment: How much to add each time (usually 1).

## When to Use

Surrogate Keys: When your data doesn't have a natural unique ID (like a "Log Entry" or "Shopping Cart Item").

Performance: INT Identity columns make excellent Clustered Indexes because they are small, unique, and strictly increasing, which minimizes "Fragmentation" on your hard drive.

Simplicity: When you want the database to handle the math of "what ID comes next" so your C# code doesn't have to.

## When NOT to Use

Distributed Systems: If you are merging data from multiple different databases (e.g., one in Toronto, one in Vancouver), Identities will collide (both will have ID #1). Use GUIDs (UUIDs) instead.

Business Intelligence: If the ID needs to carry meaning (e.g., "INV-2026-001"), do not use Identity. Use a calculated column or custom logic.

When Gaps are Forbidden: If legal compliance requires strict numbering without any gaps (e.g., Invoice Numbers), Identity is risky because failed inserts create gaps.

## What Problem Does It Solve?

It solves the Concurrency Race Condition. Without IDENTITY, if two users try to register at the exact same millisecond, your code might calculate MAX(ID) + 1 for both of them, resulting in both getting ID #100. This causes a crash. IDENTITY handles this atomically—locking the number generator for a microsecond so duplicates are impossible.

## Common Misconceptions / Important Notes

"The Sequence is Unbroken": False. If an INSERT statement fails or is rolled back, that Identity value is "burned" and never reused. You will have gaps (1, 2, 4, 5...).

"I cannot manually insert a value": False. You can use SET IDENTITY_INSERT TableName ON to force a specific ID (useful for data migrations), but you must turn it OFF immediately after.

"DELETE resets the counter": False. If you delete all rows, the next insert continues from the highest number ever reached. Only TRUNCATE TABLE resets the Identity back to the seed.

The "Last ID" Trap: Never use @@IDENTITY to find the ID you just created (it might give you a trigger's ID). Always use SCOPE_IDENTITY().

## Example

Scenario: Creating a standard Orders table where Order IDs start at 1000 and go up by 1.

    -- 1. Create the table
    CREATE TABLE Orders (
    OrderID INT IDENTITY(1000, 1) PRIMARY KEY, -- Starts at 1000, increments by 1
    CustomerName VARCHAR(50),
    Amount DECIMAL(10, 2)
    );

    -- 2. Insert rows (Notice we DO NOT supply the OrderID)
    INSERT INTO Orders (CustomerName, Amount) VALUES ('Alice', 50.00);
    INSERT INTO Orders (CustomerName, Amount) VALUES ('Bob', 75.50);

    -- 3. Check the result
    SELECT * FROM Orders;
