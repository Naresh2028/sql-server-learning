# MERGE

## What is MERGE?
The MERGE statement allows you to perform INSERT, UPDATE, and DELETE operations in a single statement. It compares a "Source" table with a "Target" table and decides what to do based on whether a match is found.

## Analogy
Think of Syncing your Phone Contacts. When you sync your phone to the cloud:

1. Match Found? Update the phone number (Update).

2. Not in Cloud? Add the new contact (Insert).

3. In Cloud but not on Phone? Maybe remove it (Delete). One "Sync" button handles all three actions.
   
## Syntax
MERGE TargetTable AS T
USING SourceTable AS S
ON T.ID = S.ID
WHEN MATCHED THEN
    UPDATE SET T.Name = S.Name
WHEN NOT MATCHED THEN
    INSERT (ID, Name) VALUES (S.ID, S.Name);
    
## When to Use
A. Data Warehousing: When you are loading daily sales data into a master table and need to handle both new records and changes to old ones.

B. Syncing Tables: Keeping two tables in different databases identical.

## When NOT to Use
A. Simple Logic: If you are only doing a single Insert or Update, MERGE is overkill.

B. High Concurrency: MERGE can sometimes cause "Deadlocks" in very busy databases. Many experts prefer writing a separate UPDATE then an INSERT.

## What Problem Does It Solve?
It solves the "Upsert" (Update + Insert) problem. Without MERGE, you would have to write two separate blocks of code and check IF EXISTS(...) for every single row.

## Common Misconceptions
A. "It’s always faster than separate statements": False. On very large datasets, separate optimized UPDATE and INSERT statements often outperform MERGE.

B. "It's mandatory to use DELETE": False. The WHEN NOT MATCHED BY SOURCE THEN DELETE part is optional. Most people only use the Insert and Update parts.

## Example
Scenario: Syncing a "Daily Sales" file into your main Inventory table in a San Francisco warehouse.

```sql
MERGE Inventory AS Target
USING DailyArrivals AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET Target.UnitsInStock = Target.UnitsInStock + Source.Quantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, UnitsInStock)
    VALUES (Source.ProductID, Source.ProductName, Source.Quantity);
