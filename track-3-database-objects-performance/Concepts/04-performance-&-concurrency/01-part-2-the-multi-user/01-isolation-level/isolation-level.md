# ISOLLATION LEVEL

In the world of .NET Core and Enterprise Databases, Isolation Levels are the knobs you turn to balance Data Accuracy against Performance Speed.

## What is a isolation level?

An Isolation Level is a setting that defines how a transaction interacts with other concurrent transactions. It controls:

Visibility: Can I see data that someone else is currently changing?

Locking: How long do I hold my locks, and how strictly do I block others?

It is strictly a trade-off:

Lower Isolation (e.g., Read Uncommitted): Higher Concurrency (Fast), Lower Consistency (Risky).

Higher Isolation (e.g., Serializable): Lower Concurrency (Slow/Blocking), Higher Consistency (Safe).

## Analogy

Think of Editing a Shared Google Doc.

Read Uncommitted (Lowest): You can see my typos as I am typing them. If I delete the sentence 5 seconds later, you saw something that "never really happened."

Read Committed (Default): You only see the paragraph after I finish typing it and press "Save." You don't see my messy work-in-progress.

Serializable (Highest): I lock the entire document. You cannot even open the file to read it until I am completely finished and have closed the browser.

## Syntax

````sql
-- Set it at the start of your transaction or query window
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
-- Options: READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE, SNAPSHOT

BEGIN TRAN;
-- Your queries here...
COMMIT;
````

## When to Use

READ UNCOMMITTED:

Use for: Analytics, "ballpark" counting, or reports where exact precision doesn't matter but speed is critical (No locking).

READ COMMITTED (The Default):

Use for: 99% of standard applications. It prevents reading "Dirty Data" (uncommitted changes) but doesn't stop data from changing between two reads.

REPEATABLE READ:

Use for: When you need to read a row twice in one transaction and guarantee it hasn't changed in between (e.g., verifying inventory before and after a calculation).

SERIALIZABLE:

Use for: Critical financial transactions. It prevents "Phantom Reads" (new rows appearing). It effectively turns the database into a single-lane road.

## When NOT to Use

Serializable: Avoid using this unless strictly necessary. It causes massive Blocking and frequently leads to Deadlocks because it locks entire ranges of data.

Read Uncommitted: Never use this for financial calculations (e.g., checking a balance). You might read a balance that is in the middle of a transfer that eventually fails.

## What Problem Does It Solve?

It solves specific Read Phenomena (Concurrency Side Effects):

Dirty Read: Reading data that hasn't been committed yet (Solved by Read Committed).

Non-Repeatable Read: You read a row, someone updates it, you read it again and it's different (Solved by Repeatable Read).

Phantom Read: You count 5 employees. Someone inserts a new employee. You count again and get 6 (Solved by Serializable).

## Common Misconceptions / Important Notes	

"Snapshot Isolation": There is a special level called SNAPSHOT. It uses "Versioning" (storing copies of old rows in tempdb) instead of Locking. It gives you the consistency of Serializable without the blocking, but it costs more Memory/CPU.

The Trade-off: There is no "Best" level.

High Isolation = High Safety, Low Speed (Blocking).

Low Isolation = Low Safety, High Speed (No Blocking).

## Example

Scenario: We want to count how many orders exist.

Option A: The "Fast & Dangerous" Way (Read Uncommitted)

````sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRAN;
    -- This will read rows even if they are currently being inserted/locked 
    -- by another user. It will not wait.
    SELECT COUNT(*) FROM Orders; 
COMMIT;
````

Option B: The "Safe & Slow" Way (Serializable)

````sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
    -- This locks the entire range. No one can insert a new Order 
    -- until I finish this transaction. I am blocking everyone.
    SELECT COUNT(*) FROM Orders;
COMMIT;
````
