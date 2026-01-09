# Transaction
A database without transactions is like a bank that deducts money from your account but "forgets" to add it to the receiver's account because the power went out.

## What is Transaction?
A transaction is a single unit of work. It ensures that either all the steps in a process happen successfully, or none of them do. In T-SQL, we control this using BEGIN TRANSACTION, COMMIT, and ROLLBACK.

## Analogy
Think of an ATM Withdrawal.

A. You enter your PIN.

B. The bank checks your balance.

C. The bank deducts $100 from your account.

D. The machine dispenses $100 in cash.

If the machine jams at step 4, the bank must "Rollback" step 3, or you lose your money. The transaction ensures steps 3 and 4 are treated as one single "all-or-nothing" event.

## Syntax
BEGIN TRANSACTION; -- Start the "all-or-nothing" block

BEGIN TRY
    -- Step 1: Update Account A
    -- Step 2: Update Account B
    
  COMMIT TRANSACTION; -- Save changes permanently
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION; -- Undo everything if an error occurs
END CATCH

## When to Use
A. Multi-Table Updates: When an action affects two or more tables that must stay in sync (e.g., creating an Order and decreasing Inventory).

B. Financial Operations: Transferring money, applying discounts, or processing payments.

C. Complex Deletes: When deleting a user and all their related activity logs.

## When NOT to Use
A. Simple SELECTs: You don't need a transaction just to read data (usually).

B. Long-Running Processes: Avoid keeping a transaction open while waiting for a user to click a button or for an external API to respond. This "locks" the tables and stops other people from working.

## What Problem Does It Solve?
It solves Data Corruption and Partial Updates. It ensures the database stays in a "Consistent" state, even if the server crashes or the code hits an error in the middle of a process.

## Common Misconceptions
A. "Transactions make queries faster": False. They actually add a little bit of overhead because the database has to track the "undo" information in the Transaction Log (LDF file).

B. "SQL handles this automatically": Only for single statements. If you have two UPDATE statements, SQL treats them as separate unless you wrap them in a BEGIN TRANSACTION.

C. "COMMIT is optional": False. If you BEGIN but never COMMIT, the rows stay "locked," and no one else in your company can edit them until you close your connection!

## Example
Scenario: A customer in California buys a MacBook. We must decrease stock AND record the sale.
```sql
BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Deduct Inventory
    UPDATE Products 
    SET UnitsInStock = UnitsInStock - 1 
    WHERE ProductID = 101;

    -- 2. Record the Order
    INSERT INTO Orders (ProductID, OrderDate, Amount)
    VALUES (101, GETDATE(), 3200.00);

    -- If we reach here, everything worked!
    COMMIT TRANSACTION;
    PRINT 'Transaction Successful';
END TRY
BEGIN CATCH
    -- If ANY step failed, undo everything
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred. Changes rolled back.';
END CATCH
