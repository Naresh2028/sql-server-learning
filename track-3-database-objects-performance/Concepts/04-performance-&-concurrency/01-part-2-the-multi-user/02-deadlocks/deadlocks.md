# DEADLOCKS

In the context of SQL Server databases, a Deadlock is widely considered the most frustrating concurrency issue because it results in the database engine forcibly killing one of the processes.

## What is a Deadlock?

A Deadlock occurs when two (or more) processes are blocking each other in a circular chain, such that neither process can proceed.

Process A holds a lock on Resource X and is waiting for Resource Y.

Process B holds a lock on Resource Y and is waiting for Resource X.

Since neither will give up their lock, they would theoretically wait forever. SQL Server detects this "infinite loop," picks one process as the "Victim," kills it (rollbacks its transaction), and allows the other process to finish.

## Analogy

Think of a Narrow One-Lane Bridge.

Car A enters from the North and gets halfway across.

Car B enters from the South and gets halfway across.

Now, they are face-to-face in the middle.

Car A cannot move forward because Car B is there.

Car B cannot move forward because Car A is there.

The Deadlock: Neither can move.

The Victim Selection: A police helicopter (SQL Server) swoops down, lifts Car B off the bridge (Kills the process), allowing Car A to drive through. Car B has to go back to the start and try again.

## Syntax

You do not "write" a deadlock; it is an error you must handle. The specific Error Number for a deadlock in SQL Server is 1205.

````sql

BEGIN TRY
    BEGIN TRANSACTION;
    -- Your Complex Queries Here
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Check if the error is a Deadlock (1205)
    IF ERROR_NUMBER() = 1205
    BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Deadlock detected. Retrying...';
    END
    ELSE
    BEGIN
        -- Handle other errors normally
        THROW;
    END
END CATCH;

````

## When to Use

High Concurrency Apps: In systems with high write volume (e.g., Ticket booking systems), deadlocks are sometimes unavoidable. You must implement "Retry Logic" in your C# or SQL code to handle Error 1205 gracefully.

## When NOT to Use

Intentional Creation: Never write code that intentionally creates deadlocks.

Ignoring the Error: Do not just catch the exception and swallow it. If a user's update failed because they were the "Victim," they need to know, or the system needs to retry automatically.

## What Problem Does It Solve?

The concept of a Deadlock Monitor (the background process that kills the query) solves the "Infinite Freeze" problem. Without this mechanism, the two processes (from the definition) would sit there waiting for each other literally forever (or until the server is rebooted). By sacrificing one process, the database ensures that at least one transaction completes successfully.

## Common Misconceptions / Important Notes	

"It's a Bug": Not always. Sometimes deadlocks are just a side effect of high traffic. However, frequent deadlocks usually indicate poor query design (e.g., not accessing tables in the same order).

"Locking vs Deadlocking":

Blocking: I am waiting for you to finish. (Normal).

Deadlocking: I am waiting for you, AND you are waiting for me. (Fatal).

The Fix - Access Order: The easiest way to prevent deadlocks is to ensure all stored procedures access tables in the same order.

Safe: Everyone updates Table A first, then Table B.

Risky: Proc 1 updates Table A then B. Proc 2 updates Table B then A.

## Example

Scenario: Two users, Alice and Bob, try to update the same two tables but in opposite order.

Step 1: Alice (Window 1)

````sql
BEGIN TRAN;
UPDATE Users SET Name = 'Alice' WHERE ID = 1;
-- Alice now holds a lock on User 1.
````

Step 2: Bob (Window 2)

````sql
BEGIN TRAN;
UPDATE Orders SET Amount = 100 WHERE ID = 99;
-- Bob now holds a lock on Order 99.
````

Step 3: Alice (Window 1)

````sql
-- Alice tries to update the Order Bob is holding.
-- She is now BLOCKED (Waiting for Bob).
UPDATE Orders SET Amount = 200 WHERE ID = 99;
````

Step 4: Bob (Window 2)

````sql
-- Bob tries to update the User Alice is holding.
-- He is now BLOCKED (Waiting for Alice).
UPDATE Users SET Name = 'Bob' WHERE ID = 1;

-- 💥 BOOM. 
-- SQL Server detects the circle.
-- It immediately kills Bob's transaction (Message: "Transaction was deadlocked...").
-- Alice's query in Step 3 unblocks and finishes.

````
