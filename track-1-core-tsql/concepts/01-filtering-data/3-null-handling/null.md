# NULL handling (IS NULL, IS NOT NULL, ISNULL, COALESCE)

## What is NULL ?
In SQL, NULL is not a value. It is a placeholder indicating the absence of data. It doesn't mean "Zero" or "Empty String"—it means "Unknown" or "N/A."

## Analogy
Imagine filling out a paper form for customer details:

Name: John Doe
Phone: 555-1234
Middle Name: __________________ (left blank)

The blank field for "Middle Name" isn't "empty string" ('') and isn't zero (0)—it's simply no information provided. 
We don't know if the person has no middle name, forgot to write it, or it doesn't apply.

In SQL:
  A. NULL represents absence of a value.

  B. Any math or comparison with NULL usually results in NULL (unknown):

  SELECT NULL OR TRUE;     -- TRUE
  SELECT NULL OR FALSE;   -- NULL
  SELECT NULL AND TRUE;   -- NULL
  SELECT NULL AND FALSE;  -- FALSE

  
This shows why functions like ISNULL() or COALESCE() exist—to handle "null" safely.

## Syntax
-- Checking for existence
WHERE Column IS NULL 
-- Replacing during selection
SELECT ISNULL(Column, 'Replacement')

## When to Use
For optional fields (e.g., MiddleName or DiscountCode).
When data is unknown at the time of entry (e.g., ShippedDate for an order that just placed).

## When NOT to Use
For Primary Keys (they must always have a value).
When a default value makes more sense (e.g., instead of NULL for ActiveStatus, use 1).

## What Problem Does It Solve?
It allows the database to distinguish between "The value is zero" and "We haven't recorded a value yet," which is vital for accurate math and reporting.

## Common Misconceptions
"NULL = NULL": In SQL, this is False. Since NULL is unknown, you cannot compare it to another unknown. You must use IS NULL.
"NULL takes up no space": Actually, SQL Server uses a "null bitmap" to track which columns are null, which takes a tiny bit of storage metadata.

## IS NULL

## What is IS NULL
This is a comparison operator used to filter rows where the data is missing.

## Example
-- Finding products that don't have a category assigned yet
SELECT ProductName FROM Products
WHERE CategoryID IS NULL;

## When to Use
Use this when you want to find "Incomplete" records or "To-Do" items in your database.

## IS NOT NULL

## What is IS NOT NULL
The opposite of IS NULL. It filters rows to only show records that do have data.

## Example
-- Finding only products that have been priced
SELECT ProductName, BasePrice FROM Products
WHERE BasePrice IS NOT NULL;

## When to Use
Use this when generating reports where "Unknown" data would break the logic or look unprofessional.

## ISNULL

## What is ISNULL
ISNULL(check_expression, replacement_value) is a built-in function that lets you swap a NULL for a specific value on the fly.

## Example
-- If RegionTaxRate is NULL, assume 0.0
SELECT 
    CategoryName, 
    ISNULL(RegionTaxRate, 0.0) AS TaxRate 
FROM Categories;

## When to Use
Use this when you need a "Fallback" value. It is very common when passing data to a C# variable that doesn't allow nulls.

## COALESCE

## What is COALESCE
COALESCE is like ISNULL on steroids. It takes a list of values and returns the first one that isn't NULL.

## Example
-- Try to get the SalePrice, if NULL get the BasePrice, if NULL return 0
SELECT 
    ProductName, 
    COALESCE(SalePrice, BasePrice, 0) AS CurrentPrice
FROM Products;

## When to Use
When checking multiple columns for a value.

It is ANSI SQL Standard (meaning it works in Postgres and MySQL too, whereas ISNULL is specific to SQL Server).
