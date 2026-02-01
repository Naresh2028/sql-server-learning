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

## Notes


## What is Consistency

Consistency ensures that a transaction takes the database from one valid state to another. It guarantees that the data satisfies all 
defined rules, constraints (like Unique Keys, Foreign Keys), and cascades. If a transaction attempts to violate a rule 
(e.g., entering text into a number field), the entire transaction is rejected.

## Analogy

Think of a Vending Machine.

The Rule: The machine only dispenses a soda if you insert exactly $1.50.

The Attempt: You insert a button instead of a coin.

The Result: The machine rejects the button instantly. It doesn't accept the button and then crash; it maintains its "Consistency" by refusing bad input. The machine's state (money inside) remains valid.

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/10f2d2c7-96ab-442c-a700-3aae05a561dd" />


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

# Transaction Isolation Example

## Step 1: Create Table
```sql
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2)
);

-- Insert initial data
INSERT INTO Employees VALUES (1, 'Bob', 50000);

````
Step 2: Without Isolation (Race Condition)

````sql
-- Manager A transaction
BEGIN TRANSACTION;
SELECT Salary FROM Employees WHERE EmpID = 1;  -- Reads 50000
UPDATE Employees SET Salary = 55000 WHERE EmpID = 1; -- Adds 5000
COMMIT;

-- Manager B transaction (running at same time)
BEGIN TRANSACTION;
SELECT Salary FROM Employees WHERE EmpID = 1;  -- Reads 50000 (stale)
UPDATE Employees SET Salary = 60000 WHERE EmpID = 1; -- Adds 10000
COMMIT;

-- Final result (Manager A's raise lost)
SELECT * FROM Employees;
-- Output: Bob, 60000

````

Step 3: With Isolation (Serializable or Repeatable Read)

````sql
-- Manager A transaction
BEGIN TRANSACTION;
SELECT Salary FROM Employees WHERE EmpID = 1;  -- Reads 50000
UPDATE Employees SET Salary = Salary + 5000 WHERE EmpID = 1;
COMMIT;

-- Manager B transaction (forced to wait until A finishes)
BEGIN TRANSACTION;
SELECT Salary FROM Employees WHERE EmpID = 1;  -- Reads 55000
UPDATE Employees SET Salary = Salary + 10000 WHERE EmpID = 1;
COMMIT;

-- Final result (both raises applied correctly)
SELECT * FROM Employees;
-- Output: Bob, 65000

````

### Key Takeaway
Without isolation: Last writer wins → Bob ends up with $60,000.

With isolation: Transactions are serialized → Bob ends up with $65,000.

Use proper isolation levels (SERIALIZABLE, REPEATABLE READ) to prevent lost updates.

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

