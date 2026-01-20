# DATA TYPES

In the world of .NET Core and SQL Server, choosing the right Data Type is the first step in database design. 
If you choose the wrong type (like storing a Date in a String column), you lose performance, sorting ability, and data integrity.

## What is Data Types?

A Data Type is an attribute that specifies the kind of data that can be stored inside a column. 
It tells the database engine how much space to allocate, how to sort the data, and what operations (math, text manipulation) are allowed.

## Analogy

Think of Tupperware Containers.

You have specific containers for specific things: a long box for spaghetti (Text), a watertight jug for liquids (Decimals), and a tiny box for spices (Bit/Boolean).

You could put water in the spaghetti box, but it would leak and be hard to measure. Data types ensure you put the "Liquid" in the "Jug" so it behaves correctly.

## Syntax

    CREATE TABLE TableName (
    ColumnName DATA_TYPE(Size) [NULL | NOT NULL]
    );

## When to Use

Always. Every single column in every table must have a defined data type.

## When NOT to Use

N/A: You cannot create a column without a data type. However, avoid using "generic" types like SQL_VARIANT unless absolutely necessary,
as they hurt performance.

## What Problem Does It Solve?

It solves the Integrity and Efficiency problem.

Integrity: It stops someone from entering "Hello" into a Price column.

Efficiency: It ensures the database doesn't waste 1GB of space to store the number "1".

## Common Misconceptions / Important Notes

"Size doesn't matter": False. Defining a column as VARCHAR(MAX) for everything "just in case" destroys performance because it prevents the database from optimizing storage on the page.

Mapping: Every SQL Data Type maps to a specific C# .NET type (e.g., BIT = bool, INT = int).


## Example

    CREATE TABLE Employees (
    EmployeeID INT,          -- Integer number
    FirstName VARCHAR(50),   -- Text
    IsActive BIT,            -- True/False
    HiredDate DATETIME2      -- Date and Time
    );

# VARCHAR

## What it is

VARCHAR stands for Variable Character. It stores non-Unicode (ASCII) text data. The "Variable" means it only uses as much space as the data requires, plus 2 bytes for overhead.

VARCHAR(50) holding "Bob" uses only 5 bytes (3 for "Bob" + 2 overhead).

CHAR(50) holding "Bob" uses 50 bytes (it pads the rest with spaces).

## Example

    DECLARE @Name VARCHAR(20) = 'John';
    
-- Stored physically as: 'John' (4 bytes + 2 bytes overhead)

## When to Use

English Text: Names, Cities, Codes that only use standard English letters (A-Z, 0-9).

Efficiency: When you want to save space and know you won't need special characters (like Chinese or Arabic).

## When Not to Use

Multilingual Apps: If your app is used in Canada (French accents like 'é') or global markets, VARCHAR might corrupt the data. Use NVARCHAR instead.

Fixed Length: If storing a 2-character State Code (CA, NY, ON), use CHAR(2) instead for slightly better performance.

# NVARCHAR

## What it is

NVARCHAR stands for National Variable Character. It stores Unicode data. It uses 2 bytes per character instead of 
1. This allows it to store characters from any language in the world (Chinese, Arabic, Emojis 🚀).

## Example



## When to Use

# INT

## What it is

## Example

## When to Use

# DECIMAL

## What it is

## Example

## When to Use

# BIT

## What it is

## Example

## When to Use

# DATETIME2

## What it is

## Example

## When to Use

# INT

## What it is

## Example

## When to Use





