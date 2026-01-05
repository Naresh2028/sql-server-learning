# CASE-EXPRESSION

## What is a case-expression?
The CASE expression is a scalar expression that returns a value based on conditional logic. 
It evaluates a list of conditions and returns one of multiple possible result expressions.

  > Important: CASE is an expression, not a statement.
  > It must always return a value.


## Analogy
Think of a Traffic Light Controller.
  IF the light is Green -> Action: "Go"
  ELSE IF the light is Yellow -> Action: "Caution"
  ELSE (Red) -> Action: "Stop"
  The controller evaluates the state of the light and outputs a specific command based on that state.

## Syntax
There are two formats for CASE:

1. Simple CASE (Compares one expression to static values):
SELECT ProductName,
    CASE CategoryID
        WHEN 1 THEN 'Tech'
        WHEN 2 THEN 'Service'
        ELSE 'General'
    END AS CategoryType
FROM Products;

2. Searched CASE (Allows complex logic/ranges in each WHEN):
SELECT ProductName,
    CASE 
        WHEN UnitsInStock = 0 THEN 'Out of Stock'
        WHEN UnitsInStock < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS InventoryStatus
FROM Products;

## When to Use

### Data Categorization: Labeling numerical ranges (e.g., $0-500$ = 'Cheap', $501+$ = 'Expensive').
### Dynamic Formatting: Displaying 1 as 'Active' and 0 as 'Inactive'.
### Conditional Aggregation: Using CASE inside a SUM() to count only specific items (e.g., SUM(CASE WHEN Status='Paid' THEN 1 ELSE 0 END)).
### Avoiding Errors: Preventing "Divide by Zero" errors by checking the denominator first.


## When NOT to Use
A. Filtering Rows: Don't use CASE in a WHERE clause for simple filtering; use standard boolean logic (AND/OR) for better performance.
B. CASE in WHERE Clause (Bad Practise)
CASE can be used in WHERE, but it is usually harder to read and less efficient than direct boolean logic.
  Prefer:
  WHERE Status = 'Active'

  Avoid:
  WHERE CASE WHEN Status = 'Active' THEN 1 ELSE 0 END = 1


## What Problem Does It Solve?
A. Logic at the Source: It prevents you from having to write complex foreach loops in your C# code or Angular pipes just to display a simple status label.
B. Null Handling: It provides more flexibility than ISNULL for replacing empty values with specific text based on multiple conditions.

## Example
SELECT 
    ProductName,
    BasePrice,
    CASE 
        WHEN BasePrice > 2000 AND UnitsInStock > 10 THEN 'Priority Air'
        WHEN BasePrice > 500 THEN 'Standard Ground'
        WHEN UnitsInStock = 0 THEN 'Backordered'
        ELSE 'Eco Shipping'
    END AS ShippingMethod
FROM Products;

## Common Misconceptions
A. It works like a Switch statement in C#: Only the Simple CASE works like a switch. 
The Searched CASE is much more powerful, behaving like an if-else if-else chain.

B. "The order of WHEN doesn't matter": False. 
CASE stops evaluating as soon as it finds the first true condition. Always put your most specific conditions at the top.

C. "It can return different data types": False. 
All possible results in a CASE expression must have the same (or compatible) data types. You cannot return a String in one WHEN and an Integer in another.
