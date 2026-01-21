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

NVARCHAR stands for National Variable Character.

National: It uses the Unicode standard (UCS-2 or UTF-16), meaning it can store characters from virtually any written language in the world, plus symbols and emojis.

Variable: It uses only as much storage space as the data requires, plus 2 bytes for the length information.

Storage Cost: It consumes 2 bytes per character. This is double the space of VARCHAR (which uses 1 byte).

## Example

Scenario: Storing a user's display name that might include emojis or accents.

    CREATE TABLE UserProfiles (
    DisplayName NVARCHAR(100)
    );

    INSERT INTO UserProfiles VALUES (N'José 🚀'); 
    
'J', 'o', 's', 'é', ' ', '🚀' 

Uses approx 12-14 bytes depending on the exact surrogate pair for the emoji.

Note the 'N' prefix (N'String') which tells SQL this is Unicode!

## When to Use

Internationalization: If your application is available in Canada (English/French) or California (English/Spanish/Asian languages), this is mandatory for names, addresses, and comments.

User Input: Any field where a user types free text. You cannot predict if they will copy-paste a symbol or accent.

Modern Default: In .NET Core development, string maps to NVARCHAR by default in Entity Framework because memory is cheap, but data corruption (seeing ??? instead of text) is expensive to fix.

# INT

## What it is

INT (Integer) is a standard 4-byte whole number.

Range: -2,147,483,648 to 2,147,483,647.

Storage: Always occupies exactly 4 bytes, regardless of whether the value is 1 or 2,000,000.

## Example

Scenario: Storing a primary key ID or a quantity count.
    
    CREATE TABLE OrderLines (
    OrderLineID INT IDENTITY(1,1), -- Standard Primary Key
    Quantity INT
    );

    INSERT INTO OrderLines (Quantity) VALUES (500);

## When to Use

Primary Keys: It is the most common data type for IDs because 4 bytes is very small, making indexes fast and compact.

Counts: Items in stock, number of views, days since login.

Foreign Keys: Linking to other tables (e.g., CustomerID INT).

# DECIMAL

## What it is

DECIMAL (also known as NUMERIC) is an exact fixed-point number. It does not round values; it stores them exactly as you define.

Precision (p): The total number of digits (both left and right of the dot).

Scale (s): The number of digits after the decimal point.

Storage: Variable (5 to 17 bytes) depending on precision.

## Example

Scenario: Storing financial values where accuracy is legally required.
DECIMAL(19, 4) is the standard for currency (19 total digits, 4 decimal places).
Max value: 999,999,999,999,999.9999

    CREATE TABLE Products (
    Price DECIMAL(19, 4)
    );

    INSERT INTO Products VALUES (19.99); -- Stored exactly as 19.9900

## When to Use

Money: Salaries, Product Prices, Tax Rates, Invoices.

Scientific Stats: Where precision is non-negotiable (e.g., "Latitude/Longitude" often uses DECIMAL(9,6)).

Avoid: Do not use FLOAT for money. FLOAT uses "floating point math" which can result in 19.99 becoming 19.9900000001 inside the processor.

# BIT

## What it is

BIT is the SQL equivalent of a Boolean.

Values: It can hold 1 (True), 0 (False), or NULL (Unknown).

Efficiency: SQL Server optimizes this incredibly well. If you have multiple BIT columns in a table (up to 8), the engine packs them all into a single byte of storage.

## Example

-- Scenario: Simple flags (True/False)

    CREATE TABLE Emails (
    IsVerified BIT,
    IsSubscribed BIT
    );

-- In C# / .NET Core:
-- public bool IsVerified { get; set; } maps directly to this column.

## When to Use

Toggles: Active/Inactive, Visible/Hidden, Yes/No.

Permission Flags: IsAdmin, CanEdit.

# DATETIME2

## What it is

DATETIME2 is the modern, high-precision upgrade to the old DATETIME.

Range: 0001-01-01 through 9999-12-31. (Old DATETIME crashed on dates before 1753).

Precision: accurate to 100 nanoseconds.

Storage: Variable (6 to 8 bytes), often smaller than the old DATETIME (8 bytes).

## Example

-- Scenario: Audit logs requiring exact timing.
    
    CREATE TABLE AccessLogs (
    LogTime DATETIME2(7) -- (7) denotes max precision
    );

    INSERT INTO AccessLogs VALUES ('2026-01-21 14:30:05.1234567');

## When to Use

Always: For any new development in .NET Core 6+, this should be your default for timestamps.

Audit Trails: When you need to know exactly what order events happened in, down to the nanosecond (e.g., High-frequency trading).

Historical Data: If storing birthdays or historical events (e.g., "Shakespeare born in 1564"), DATETIME2 works; the old DATETIME would fail.





