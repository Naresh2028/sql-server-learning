# TRY CATCH

In modern T-SQL development, especially when building robust backends for .NET Core applications, you cannot assume everything will go perfectly. Databases run into "Deadlocks," "Divide-by-Zero" errors, or "Constraint Violations." TRY...CATCH is your safety net.

## What are TRY, CATCH?

TRY...CATCH is an error-handling construct.

TRY block: You wrap the SQL statements you want to execute inside this block.

CATCH block: If an error occurs in the TRY block, execution immediately jumps to this block, where you can handle the error (log it, notify a user, or roll back a transaction).

## Analogy

Think of an Acrobat and a Safety Net. The acrobat performing the stunt is the TRY block. As long as everything goes well, the acrobat finishes the show and leaves. The CATCH block is the safety net below. The safety net does nothing while the acrobat is successful; it only "activates" if the acrobat falls (an error occurs), catching them and preventing a total disaster.

## Syntax
    
    BEGIN TRY
    -- Statements that might cause an error
    INSERT INTO Orders (OrderID, Total) VALUES (1, 100);
    END TRY
    BEGIN CATCH
    -- Code to handle the error
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;

## When to Use

Transactions: Essential when using BEGIN TRANSACTION to ensure you ROLLBACK if something fails.

Complex Inserts: When inserting data into multiple related tables where a failure in one should stop the whole process.

Data Cleanup: When running bulk updates where some rows might violate rules (like foreign keys).

## When NOT to Use

Performance Tracking: Don't use it for standard "If/Else" logic. It should be reserved for exceptional errors, not expected business logic.

Inside Functions: T-SQL does not allow TRY...CATCH inside User-Defined Functions (UDFs).

Minor Errors: If a simple IF EXISTS(...) check can prevent the error, use the check instead. It's "cheaper" than catching an exception.

## What Problem Does It Solve?

It solves the "Abrupt Termination" problem. Without TRY...CATCH, if a SQL script hits an error on line 5 of 100, the whole process crashes, and your .NET application might receive a "500 Internal Server Error." TRY...CATCH allows the script to fail gracefully and provide a meaningful error message.

## Common Misconceptions / Important Notes

Severity Levels: TRY...CATCH only catches errors with a severity higher than 10 that do not terminate the database connection.

The Error Functions: Inside the CATCH block, you have access to special functions like ERROR_LINE(), ERROR_PROCEDURE(), and ERROR_SEVERITY().

XACT_STATE(): This function is often used inside CATCH to check if a transaction is still "committable" or if it’s "doomed" and must be rolled back.

## Example

Scenario: You are trying to divide a budget among departments. Some departments might have "0" employees, which would cause a "Divide by Zero" error and crash the report.

    BEGIN TRY
    DECLARE @TotalBudget INT = 10000;
    DECLARE @DeptEmployees INT = 0; -- This will cause an error

    SELECT @TotalBudget / @DeptEmployees AS BudgetPerPerson;
    END TRY
    BEGIN CATCH
        
      -- Instead of crashing, we return a custom message
      PRINT 'Error Detected: You cannot divide a budget by zero employees.';
    
    SELECT 
        ERROR_NUMBER() AS ErrorNo,
        ERROR_MESSAGE() AS Msg;
    END CATCH;



