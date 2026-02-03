# ACID Properties

ACID is the set of four guarantees that a database makes to ensure that transactions are processed reliably.

## What is Atomicity (All or Nothing)

Atomicity guarantees that a transaction is treated as a single, indivisible unit of work. It follows the "all or nothing" rule. 
Either every step in the transaction succeeds and is saved to the database (Commit), or if any single step fails, the entire 
transaction is cancelled, and the database is returned to its state before the transaction started (Rollback).

## Analogy

Think of a Bank Transfer. If you transfer $100 from Account A to Account B, two things must happen:

Subtract $100 from A.

Add $100 to B.

If step 1 happens, but the power goes out before step 2, the system cannot leave Account A $100 poorer without Account B getting richer. 
Atomicity ensures that if step 2 fails, step 1 is undone instantly.

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/937eb3ad-4ea4-4964-a0c5-4ee7f70fd0ba" />

## Example

Scenario: A bank transfer of $500 from Alice to Bob.

This operation requires two distinct SQL steps:

Debit: Subtract $500 from Alice.

Credit: Add $500 to Bob.

Atomicity guarantees that if Step 2 fails (e.g., due to a system crash or an invalid account number), Step 1 is automatically undone. Alice gets her money back.

````sql

BEGIN TRANSACTION;

BEGIN TRY
    -- Step 1: Take money from Alice
    UPDATE Accounts SET Balance = Balance - 500 WHERE Name = 'Alice';

    -- Step 2: Give money to Bob
    -- (Imagine an error happens here, e.g., Bob's account is 'frozen')
    UPDATE Accounts SET Balance = Balance + 500 WHERE Name = 'Bob';

    -- If we get here, everything worked! Save it.
    COMMIT TRANSACTION;
    PRINT 'Transfer Successful';
END TRY
BEGIN CATCH
    -- If ANY error happened above, we jump here.
    -- Undo everything. Alice gets her $500 back.
    ROLLBACK TRANSACTION;
    PRINT 'Transfer Failed. Changes undone.';
END CATCH

````

## Notes

The "Undo" Button: The command ROLLBACK is the magic switch. It tells the database to forget everything that happened since BEGIN TRANSACTION.

Default Behavior: By default, SQL Server operates in "Auto-Commit" mode. Each individual statement is its own mini-transaction. You must explicitly use BEGIN TRANSACTION to group multiple steps together into an atomic unit.

Why it matters: Without Atomicity, you would have "Orphaned Data" or "Money vanishing into thin air," which destroys trust in the system.

## What is Consistency

Consistency ensures that a transaction takes the database from one valid state to another. It guarantees that the data satisfies all 
defined rules, constraints (like Unique Keys, Foreign Keys), and cascades. If a transaction attempts to violate a rule 
(e.g., entering text into a number field), the entire transaction is rejected.

## Analogy

Think of a Vending Machine.

The Rule: The machine only dispenses a soda if you insert exactly $1.50.

The Attempt: You insert a button instead of a coin.

The Result: The machine rejects the button instantly. It doesn't accept the button and then crash; it maintains its "Consistency" by refusing bad input. The machine's state (money inside) remains valid.

<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/e08affde-a7e6-4d92-8a9f-1232152602f0" />

## Example

Scenario : You have a table Users with a rule: Age must be > 18.

````sql

BEGIN TRANSACTION;
    -- This violates the rule!
    INSERT INTO Users (Name, Age) VALUES ('Kid', 10);
COMMIT TRANSACTION;

````

Result: The database rolls back immediately. No data is saved. The database remains "consistent" with its rules.

## Notes
Relation to App Logic: While the App layer validates input, the Database is the final enforcer. Consistency prevents "dirty data" from ever existing on the disk.

## What is Isolation

Isolation ensures that multiple transactions occurring at the same time do not interfere with each other. Each transaction acts as 
if it is the only one running on the system. The intermediate state of a transaction (e.g., halfway through a transfer) is invisible 
to other transactions until it is fully committed.

## Analogy

Think of Two People Editing the Same Google Doc Offline.

User A: Opens the document and deletes Paragraph 1.

User B: Opens the document at the same time.

The Isolation: User B still sees Paragraph 1 because User A hasn't "synced" (Committed) yet. User B is isolated from User A's incomplete changes. 
They don't see the text disappearing character-by-character.


<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/485bfe4a-7346-4458-a0f1-31e3c319b042" />


## Example

Scenario: Two managers try to give Bob a raise at the exact same second.

### Step 1: The Setup
````sql
-- 1. Create a dummy table
CREATE TABLE EmployeeSalaries (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT
);

-- 2. Insert Bob with $50,000
INSERT INTO EmployeeSalaries VALUES (1, 'Bob', 50000);

-- Check the data
SELECT * FROM EmployeeSalaries;

````

### Step 02: The "Lost Update" (What happens WITHOUT proper Isolation)

Note: In a real database, simulating "no isolation" is actually hard because SQL Server tries to protect you by default!

Manager A runs: SELECT Salary FROM EmployeeSalaries (Gets 50,000).

Manager B runs: SELECT Salary FROM EmployeeSalaries (Gets 50,000).

Manager A calculates 50k + 5k = 55k.

Manager A runs: UPDATE EmployeeSalaries SET Salary = 55000.

Manager B calculates 50k + 10k = 60k.

Manager B runs: UPDATE EmployeeSalaries SET Salary = 60000.

Result: Bob has $60,000. Manager A's $5,000 raise was completely overwritten.

### Step 03: The "With Isolation" Lab (The Fix)

Now, let's see how SQL Server uses Isolation (Locking) to force Manager B to wait.

1. Open Query Window #1 (Manager A)
Copy and paste this code, then Execute it. Note: This transaction will stay "open" for 15 seconds to simulate Manager A working slowly.

````sql

-- WINDOW 1 (Manager A)
BEGIN TRANSACTION;

    -- Manager A gives a $5,000 raise
    UPDATE EmployeeSalaries 
    SET Salary = Salary + 5000 
    WHERE ID = 1;

    PRINT 'Manager A has updated the salary... but has NOT committed yet.';
    
    -- We force the system to wait 15 seconds before saving
    WAITFOR DELAY '00:00:15';

COMMIT TRANSACTION;
PRINT 'Manager A finished!';

````

2. IMMEDIATELY Open Query Window #2 (Manager B)
While Window 1 is still running (within that 15 seconds), copy/paste and Execute this in a second window:

````sql
-- WINDOW 2 (Manager B)
BEGIN TRANSACTION;

    PRINT 'Manager B is trying to update...';

    -- Manager B tries to give a $10,000 raise
    -- SQL Server ISOLATION will force this line to PAUSE (Spin)
    UPDATE EmployeeSalaries 
    SET Salary = Salary + 10000 
    WHERE ID = 1;

COMMIT TRANSACTION;
PRINT 'Manager B finished!';

````

🕵️‍♂️ What did you see?
1. Window 1 started and printed "Manager A has updated...".

2. Window 2 started, printed "Manager B is trying...", and then FROZE. It showed "Executing query..." with a spinning wheel.

3. Why? Because of Isolation. Manager A has locked that row. The database forbids Manager B from touching it until Manager A is done.

4. After 15 seconds, Window 1 finished.

5. Instantly, Window 2 unfreezes, runs its update, and finishes.

Step 4: Verify the Final Result
Go back to any window and check the total.

````sql

SELECT * FROM EmployeeSalaries;

````

Result: You should see 65000.

Manager A made it 55,000.

Manager B waited, saw the new 55,000, and added 10,000.

Total: $65,000 (Correct!)

## Notes

Isolation Levels: You can adjust this. "Read Uncommitted" allows you to see dirty data (fast but dangerous), while "Serializable" forces strict waiting (safe but slower).

## What is Durability

Durability guarantees that once a transaction is committed, it remains committed—even in the event of a power loss, crash, or error. 
The changes are permanently recorded on the disk (non-volatile memory) and will survive a system restart.

## Analogy

Think of Taking a Photo vs. Memorizing a Scene.

Memorizing (Memory): You look at a sunset. If you fall asleep (Power Outage), you might forget the details.

Taking a Photo (Disk): You snap a picture and print it. Even if you fall asleep or the camera battery dies, the printed photo (Data) 
still exists physically when you wake up.

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/6f56c3be-bc6b-4c5f-9c09-c676e9a7fd36" />

## Example

````sql
BEGIN TRANSACTION;
    INSERT INTO Orders VALUES (101, 'Laptop');
COMMIT; -- The user sees "Success" message here.

````

Scenario: 0.1 seconds after the COMMIT message, the server room loses power.

Result: When the power comes back on, Order 101 must be there. The database writes to a "Transaction Log" on the hard drive before confirming success, 
ensuring the data is safe even if the memory is wiped.

## Notes

The Cost: Durability is why writing to a database is slower than writing to a variable in C#. The physical act of writing to the hard drive (I/O) takes time, 
but it is the price of safety.

