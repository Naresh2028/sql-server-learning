# LOCKING & BLOCKING

## What are Locking & Blocking?

Locking is the mechanism SQL Server uses to manage concurrency. When one process modifies data, it "locks" 
that row, page, or table to prevent others from messing with it until the transaction is done.

Blocking is the side effect of locking. It happens when Process B wants to read/write data that Process A has currently locked. 
Process B must wait (is blocked) until Process A finishes.

## Analogy

Think of a Store Fitting Room.

The Lock: When you enter a fitting room, you lock the door. This ensures no one walks in while you are changing (Data Integrity).

Blocking: If someone else wants to use that specific room, they have to stand outside and wait. They are "blocked" by you.

Deadlock: Two people trying to enter the same room from opposite doors at the exact same time, and neither will step back.

## Syntax

You rarely "write" lock code (it's automatic), but you use syntax to monitor or influence it.

1. To See Who is Blocking Who:

```sql
-- The classic monitoring command
EXEC sp_who2;
-- Look at the 'BlkBy' (Blocked By) column.
```

2. To Bypass Locks (Dangerous but fast):

```sql
-- "Dirty Read" - Reads data even if it is currently locked/being updated
SELECT * FROM Orders WITH (NOLOCK)
WHERE OrderDate = '2026-01-01';
```

## When to Use

High-Traffic Systems: In an e-commerce app (Amazon/Shopify style), thousands of users buy items simultaneously. Locking ensures the last "PS5" isn't sold to two different people at once.

Long Transactions: If you run a report that takes 10 minutes inside a transaction, you might accidentally block everyone else from updating the table.

## When NOT to Use

Over-optimizing: Don't sprinkle WITH (NOLOCK) everywhere just to make queries faster. It can return data that doesn't exist (e.g., a transaction that was halfway through an update and then rolled back).

Explicit Table Locks: Avoid writing TABLOCKX (Exclusive Table Lock) unless you are doing a massive bulk load and want to stop everyone else from accessing the table.

## What Problem Does It Solve?

Strictly speaking, Locking solves the problem (Data Consistency). Blocking is the symptom or cost of that solution.

The Problem: "The Lost Update" (or Race Conditions). Without locking, if two users try to update the same row at the exact same time, the last one to finish would silently overwrite the first one's work.

The Solution (Locking): SQL Server forces the second user to wait (Blocking) until the first user is finished.

Where is the Blocking? The Blocking is the waiting period. It is the necessary evil that ensures User 1's data is safely saved before User 2 touches it.

## Common Misconceptions / Important Notes	
 
"Blocking is a Bug": False. Blocking is normal and healthy database behavior. It only becomes a problem when the wait time is excessive (e.g., > 5 seconds).

"NOLOCK is magic speed": Risky. It reads "Dirty Data." It might read a row that is being deleted. Only use it for non-critical reports where 100% accuracy isn't required.

Escalation: If you lock thousands of individual rows, SQL Server might decide it's too much memory overhead and upgrade it to a Table Lock, suddenly blocking everyone.

## Example

Example: LOCKING
Scenario: Imagine a bank transaction. We need to deduct $100 from Alice's account. To ensure no one else messes with Alice's balance while 
we are doing the math, SQL Server LOCKS that specific row.

The Code (The Lock Owner):

```sql
-- 1. Start a Transaction
BEGIN TRANSACTION;

-- 2. Perform the Update
-- CRITICAL MOMENT: The instant this line runs, SQL Server places an 
-- "Exclusive Lock (X)" on the row where AccountID = 10.
UPDATE BankAccounts 
SET Balance = Balance - 100 
WHERE AccountID = 10;

-- At this point, the row is LOCKED. 
-- No one else can read or write to AccountID 10.
-- The lock remains active until we run COMMIT or ROLLBACK.

-- 3. Finish
COMMIT TRANSACTION; 
-- The Lock is released.

```

Without this Lock:

You start deducting the $100.

A millisecond later (before you finish), a generic "Monthly Report" query runs.

The report reads the balance in the middle of your calculation (maybe it sees the old balance, or a partial state).

The report is now wrong (inaccurate financial data).

Example: The "Blocking" Scenario
Here is a concrete code example you can run in two separate query windows to see Blocking happen in real-time.

Step 1: Open Query Window A (The Blocker) Run this to start a transaction but do not finish it.

```sql
-- Window A
BEGIN TRANSACTION;

-- We update the price, but we DO NOT Commit yet.
-- This places an Exclusive Lock (X) on the row for Product 101.
UPDATE Products 
SET Price = 99.99 
WHERE ProductID = 101;

-- Now wait... (Imagine the user went to get coffee)
```

Step 2: Open Query Window B (The Blocked Victim) Run this immediately after Step 1.

```sql

-- Window B
-- This query tries to read the row locked by Window A.
SELECT Price 
FROM Products 
WHERE ProductID = 101;

-- RESULT: ⏳ The query just spins and spins. 
-- It is BLOCKED. It is waiting for Window A to release the lock.

```

Step 3: The Resolution Go back to Window A and run:

```sql
COMMIT TRANSACTION;
```

The moment you run this, Window A releases the lock.

Window B immediately wakes up, reads the new value (99.99), and finishes.

