# TRIGGER

In .NET Core development, Triggers are often seen as "Magic" because they happen behind the scenes. While powerful, they are hidden from your C# code, which can make debugging difficult. Use them wisely.

## What is Trigger?

A Trigger is a special type of stored procedure that automatically executes ("fires") when a specific event occurs in the database server. You cannot call a trigger manually; it only runs in response to data modification events like INSERT, UPDATE, or DELETE.

## Analogy

Think of a Motion Sensor Light.

You don't flip a switch to turn it on.

You simply walk into the room (The Event).

The sensor detects the movement and immediately turns on the light (The Trigger Action).

It happens automatically every single time the event occurs, whether you want it to or not.

## Syntax

    CREATE TRIGGER trg_TriggerName
    ON TableName
    AFTER INSERT, UPDATE -- The Events
    AS
    BEGIN
          -- Logic to execute
          PRINT 'Something changed in the table!';
    END;

## When to Use

Audit Trails: Automatically logging "Who changed what and when" into a separate History table.

Complex Validation: Enforcing rules that cannot be handled by simple Constraints (e.g., "You cannot withdraw money if the bank branch is closed").

Cascading Actions: When a row is updated in Table A, automatically update a calculated value in Table B.

## When NOT to Use

Business Logic: Do not hide core business rules (like "Calculate Discount") in triggers. It confuses developers who are looking at the C# code and can't figure out why the data is changing.

Simple Constraints: If you just need to ensure a value is not negative, use a CHECK constraint, not a trigger. Triggers are slower.

High-Volume Inserts: Triggers run per transaction. If you bulk load 1 million rows, the trigger adds massive overhead and can freeze your database.

## What Problem Does It Solve?

It solves the "Guaranteed Consistency" problem. No matter how the data is changed—whether by your API, a manual SQL script, or a different app—the Trigger always runs. It ensures that critical actions (like logging) are never forgotten.

## Common Misconceptions / Important Notes

The "Magic" Tables: Inside a trigger, you have access to two special virtual tables:

  1. INSERTED: Holds the new data being added.

  2. DELETED: Holds the old data being removed.

  3. (For an UPDATE, DELETED has the old values and INSERTED has the new values).

Hidden Costs: Triggers are part of the original transaction. If the trigger fails, the original INSERT fails too.

Recursive Triggers: Be careful! If Trigger A updates Table B, and Trigger B updates Table A, you can create an infinite loop that crashes the server.

## Example

Scenario: We want to enforce a rule that no one can delete a "VIP" customer.

    CREATE TRIGGER trg_PreventVIPDelete
    ON Customers
    INSTEAD OF DELETE
      AS
        BEGIN
    IF EXISTS (SELECT * FROM DELETED WHERE CustomerType = 'VIP')
    BEGIN
        RAISERROR('Cannot delete VIP customers!', 16, 1);
        ROLLBACK TRANSACTION; -- Cancel the delete
    END
    ELSE
    BEGIN
        -- Proceed with delete for non-VIPs
        DELETE FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM DELETED);
    END
    END;

# INSTEAD OF

## What it is

An INSTEAD OF trigger bypasses the standard action. When you try to INSERT, UPDATE, or DELETE, the database stops, runs your trigger logic instead, and cancels the original action unless you manually perform it inside the trigger.

## Example

Scenario: You have a View vw_EmployeeDetails that joins two tables. You want to allow users to INSERT into this View, which is normally impossible.

    CREATE TRIGGER trg_InsertIntoView
    ON vw_EmployeeDetails
    INSTEAD OF INSERT
      AS
      BEGIN
          -- We manually split the data and insert into the real tables
          INSERT INTO Employees (Name) SELECT Name FROM INSERTED;
          INSERT INTO EmployeeDetails (Address) SELECT Address FROM INSERTED;
    END;

## When to Use

Updatable Views: Making a complex View behave like a writable table.

Soft Deletes: When a user runs DELETE FROM Users, you intercept it and perform UPDATE Users SET IsDeleted = 1 instead.

# AFTER

## What it is

An AFTER trigger runs after the INSERT, UPDATE, or DELETE action has successfully completed, but before the transaction is committed. If the trigger fails, the whole action is rolled back. This is the default trigger type.

## Example

Scenario: Audit Logging. After a user's salary is updated, we save the old value to a history table.

    CREATE TRIGGER trg_LogSalaryChange
    ON Employees
    AFTER UPDATE
    AS
    BEGIN
        -- Only run if the Salary column was actually updated
    IF UPDATE(Salary) 
    BEGIN
        INSERT INTO SalaryHistory (EmpID, OldSalary, NewSalary, ChangeDate)
        SELECT 
            d.EmpID, 
            d.Salary, -- Old value from DELETED table
            i.Salary, -- New value from INSERTED table
            GETDATE()
        FROM DELETED d
        JOIN INSERTED i ON d.EmpID = i.EmpID;
    END
    END;

## When to Use

Auditing: Logging changes to a history table.

Notifications: Sending an email (via Database Mail) after a critical order is placed.

Calculated Summaries: Updating a "TotalSales" column in the Customers table whenever a new row is added to the Orders table.
