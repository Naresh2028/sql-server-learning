# INCLUDE

In the context of SQL Server performance tuning, INCLUDE is the secret weapon for creating "Covering Indexes." It is a feature specific to Non-Clustered Indexes.

## What is Inlucde?
The INCLUDE clause allows you to attach additional columns to the leaf level of a Non-Clustered Index.

Crucially, these columns are not part of the index key. This means they are not used for sorting or searching (the B-Tree structure), but they are stored in the index solely to be retrieved in the final result.

## Analogy

Think of a Glossary at the back of a textbook.

Standard Non-Clustered Index: The main Index. It lists "Photosynthesis" and says "See Page 42." You have to flip to Page 42 to read the definition.

Index with INCLUDE: A Glossary. It lists "Photosynthesis" (The Key) and prints the definition right next to it (The Included Column). You get the answer immediately without ever having to flip back to the main pages of the book.

## Syntax

```sql

CREATE NONCLUSTERED INDEX IX_IndexName
ON TableName (KeyColumn) -- Used for Searching/Sorting
INCLUDE (PayloadColumn1, PayloadColumn2); -- Just hanging on for the ride

```

## When to Use

Covering Indexes: This is the #1 use case. You use it when you want a query to get all its data from the index alone, without touching the main table.

Avoiding Lookups: When your Execution Plan shows a generic "Key Lookup" (which is expensive), adding the missing columns to the INCLUDE list removes that step.

Large Data Types: You cannot put VARCHAR(MAX) or XML columns in the Key of an index, but you can put them in the INCLUDE clause.

## When NOT to Use

"Select All" Queries: If you try to INCLUDE every single column in the table, you are essentially duplicating the entire table on the hard drive. This wastes massive space and destroys write performance.

Unused Columns: Don't include columns "just in case." Only include columns that are frequently strictly retrieved in your SELECT clause.

## What Problem Does It Solve?

It solves the "Key Lookup" (or RID Lookup) Bottleneck. Without INCLUDE, if an index finds the row but doesn't have the PhoneNumber column you asked for, the engine has to "jump" from the index to the main table to fetch it.
This jump is slow. INCLUDE puts the PhoneNumber right in the index, eliminating the jump.

## Common Misconceptions / Important Notes	

Sorting: Included columns are not sorted. You cannot effectively ORDER BY an included column. Only the main Key columns are sorted.

Size Limits: The Index Key is limited to 1,700 bytes (approx). Included columns do not count towards this limit. You can include large data just fine.

Performance Balance: While INCLUDE speeds up reads (SELECT), it slows down writes (UPDATE) because the database has to update the copy of the data in the index too.

## Example

Scenario: You frequently run a query to get a user's Email and Phone Number by searching their Name.

```sql

-- The Query we want to optimize:
SELECT Email, PhoneNumber 
FROM Users 
WHERE LastName = 'Smith';

```

Option A (Standard Index - Good): CREATE INDEX IX_Name ON Users (LastName);

Result: SQL finds "Smith" in the index, but then performs a Key Lookup to the table to get Email and PhoneNumber.

Option B (With INCLUDE - Best):

```sql

CREATE NONCLUSTERED INDEX IX_Name_Includes
ON Users (LastName)       -- The Key (Used for searching "Smith")
INCLUDE (Email, PhoneNumber); -- The Payload (Returned instantly)

```

Result: SQL finds "Smith" and sees Email and PhoneNumber sitting right there. It returns the data immediately. 0 Table Reads.
