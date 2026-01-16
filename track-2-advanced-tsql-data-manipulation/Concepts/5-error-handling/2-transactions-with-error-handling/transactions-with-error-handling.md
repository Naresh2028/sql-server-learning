# TRANSACTIONS With Error Handling

## What is TRANSACTIONS With Error Handling?

It is the combination of Transaction Control (BEGIN, COMMIT, ROLLBACK) and Error Handling (TRY...CATCH). It ensures that a group of SQL statements either completes successfully as a single unit or, if any error occurs, the entire unit is undone to prevent "partial data" from staying in your tables.

## Analogy

Think of a Standard Mail Delivery with a Return-to-Sender Policy. You are sending a package that contains a Glass Vase and a Greeting Card.

The Transaction: You want both the vase and the card to arrive together.

The Error Handling: If the delivery truck crashes and breaks the vase (Error), the post office doesn't just deliver the card alone. Instead, they "Catch" the problem and return everything—including the card—back to you (Rollback). You are back to exactly where you started, rather than having a half-delivered mess.

## Syntax

    SET XACT_ABORT ON;
    
    BEGIN TRY
    BEGIN TRANSACTION;

    -- Step 1: Perform first action
    -- Step 2: Perform second action

    COMMIT TRANSACTION; -- Only reached if no errors occur
    END TRY
    BEGIN CATCH
    -- Check if there is an active transaction to roll back
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Log error details
    PRINT 'Transaction failed. Error: ' + ERROR_MESSAGE();
    END CATCH;

## When to Use

Banking/Finance: Moving money from one account to another (Debit A, then Credit B).

Order Processing: Deducting stock from Inventory and creating a record in Orders.

User Registration: Creating a User record and then setting up their Permissions or Profile.

## When NOT to Use

Read-Only Queries: You don't need transactions or complex error handling for simple SELECT statements.

Non-Critical Bulk Loads: If you are importing 1 million rows of logs and it doesn't matter if 5 fail, wrapping the whole thing in one transaction might be too slow and lock the database for too long.

## What Problem Does It Solve?

It solves the "Inconsistent State" problem. Without this, if your code crashes after step 1 but before step 2, you end up with "ghost data" (e.g., money disappeared from Account A but never arrived in Account B). This pattern guarantees Atomicity (the 'A' in ACID).

## Common Misconceptions / Important Notes

@@TRANCOUNT: This is a global variable that tracks how many active transactions your current session has. Using it in the CATCH block is a "Pro" move to ensure you don't try to ROLLBACK a transaction that never actually started.

Deadlocks: Even correct SQL can fail due to a deadlock. TRY...CATCH allows SQL Server to detect and report the error. Retry logic must be implemented in the application layer (e.g., .NET).

Implicit vs Explicit: By default, SQL Server treats every single statement as a transaction. We use BEGIN TRANSACTION to make it Explicit, grouping multiple statements together.

## Example

Scenario: A customer is purchasing a digital course. We need to deduct the balance from their wallet and grant them access to the course. If the "Grant Access" part fails, we must give them their money back immediately.

```sql

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Deduct $50 from User Wallet
    UPDATE Wallets WITH (UPDLOCK, ROWLOCK)
    SET Balance = Balance - 50 
    WHERE UserID = 101 AND Balance >= 50;

    -- Check if the update actually happened (e.g., sufficient funds)
    IF @@ROWCOUNT = 0
        THROW 50001, 'Insufficient funds or user not found.', 1;

    -- 2. Grant Access to Course (Imagine this table has a bug or constraint)
    INSERT INTO UserCourses (UserID, CourseID, AccessDate)
    VALUES (101, 202, GETDATE());

    -- Success!
    COMMIT TRANSACTION;
    PRINT 'Transaction Completed Successfully.';

END TRY
BEGIN CATCH
    -- Something went wrong!
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Output the specific error for the developer
    SELECT 
        ERROR_NUMBER() AS ErrorID,
        ERROR_MESSAGE() AS DetailedMessage;
END CATCH;
