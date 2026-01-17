# CONSTRAINTS

## What is Constraints?

Constraints are rules enforced by the database engine to protect data integrity.
They ensure that invalid, inconsistent, or logically impossible data never enters the table, regardless of what the application tries to insert.

Key idea:

1. Constraints are the last line of defense.
2. Even if your .NET code has a bug, the database still stays correct.

## Analogy

Think of a High-Security Office Building:

PRIMARY KEY → Employee ID badge (must exist, must be unique)

FOREIGN KEY → Visitor must belong to a registered company

UNIQUE → Only one person can use a specific email ID

CHECK → Age must be ≥ 18 to enter

DEFAULT → If you don’t say your country, it assumes “USA”

Constraints are the security guards, not the receptionist (application code).

## Syntax

    CREATE TABLE Orders (
    OrderId INT PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderAmount DECIMAL(10,2) CHECK (OrderAmount > 0),
    Status VARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
    );

## When to Use

Always: Every table should have at least a Primary Key.

Relationships: Use Foreign Keys whenever one table refers to data in another to prevent "orphaned" records.

Data Sanitization: Use Check and Unique constraints at the database level as a final line of defense, even if you have validation in your C# code.

## When NOT to Use

1. High-Volume Inserts/ETL Jobs:

Bulk data loads can slow down if every row is validated against constraints.

Example: nightly data warehouse imports.

2. Staging Tables / Temporary Data:

When data is raw and will be cleaned later, constraints may block ingestion.

Example: logs, sensor data, or external feeds.

3. High-Volume Logging:

In extreme "Big Data" scenarios, Foreign Keys are sometimes omitted to speed up massive bulk inserts, but this is a rare exception for specific performance needs.

## What Problem Does It Solve?

Garbage In, Garbage Out: It prevents invalid data from ever being saved.

Referential Integrity: It ensures that if you have an Order for "Customer 10," "Customer 10" actually exists.

Consistency: It ensures that every developer on the team follows the same data rules, regardless of which app or script they use to access the DB.

## Common Misconceptions / Important Notes

Unique vs. Primary Key: A table can only have one Primary Key, but it can have multiple Unique constraints.

Performance: Constraints actually help the database engine. For example, the query optimizer uses Foreign Key information to create better execution plans.

GitHub Tip: When pushing your SQL scripts to GitHub, always include your Constraint names (e.g., CONSTRAINT PK_User...) rather than letting the system auto-generate them. This makes your migrations predictable across different environments.

## 1. PRIMARY KEY

## What it is

A Primary Key is a column (or a group of columns) that uniquely identifies every row in a table. 
It acts as the "Social Security Number" for your data record. It cannot be NULL and must be unique.

## Example

    CREATE TABLE Products (
    ProductID INT PRIMARY KEY, -- This uniquely identifies each product
    ProductName VARCHAR(100)
    );

## When to USE

In every table: As a standard rule, every table should have one Primary Key to allow for easy searching, updating, and deleting of specific records.

Relationships: Use it when you need to "link" this table to another table.

## 2. FOREGIN KEY

## What it is

A Foreign Key is a column that points to the Primary Key of another table. It establishes a link between the data 
in two tables and ensures Referential Integrity (meaning you can't have a "child" record that points to a non-existent "parent").

## Example

    CREATE TABLE Orders (
    OrderId INT PRIMARY KEY,
    ProductID INT,
    -- Links the ProductID in this table to the ProductID in the Products table
    CONSTRAINT FK_ProductOrder FOREIGN KEY (ProductID) 
    REFERENCES Products(ProductID)
    );

## When to USE

Parent-Child relationships: When one entity "belongs to" or "is associated with" another (e.g., an Order belongs to a Customer).

Data Consistency: Use it to prevent "orphan records" (e.g., deleting a Product while it is still being used in an active Order).

## 3. UNIQUE

## What it is

The Unique constraint ensures that all values in a column are different from one another. Unlike a Primary Key, 
you can have multiple Unique constraints per table, and in most databases, you are allowed one NULL value.

## Example

    CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Email VARCHAR(255) UNIQUE -- Prevents two employees from having the same email
    );
    
## When to USE

Secondary Identifiers: For data that isn't the "ID" but still must be one-of-a-kind, such as Email addresses, Phone numbers, or Username.

Alternate Keys: When you want to ensure no duplicates exist without making the column the main relationship key.

## 4. CHECK

## What it is

A Check constraint defines a logical condition that every row must satisfy before it can be saved. If the condition is False, 
the database rejects the data.

## Example

    CREATE TABLE Inventory (
    ItemId INT PRIMARY KEY,
    StockQuantity INT,
    Price DECIMAL(10,2),
    CONSTRAINT CHK_Price CHECK (Price > 0),      -- Price must be positive
    CONSTRAINT CHK_Stock CHECK (StockQuantity >= 0) -- Stock cannot be negative
    );

## When to USE

1. Domain Integrity: When a column has a specific range or set of valid values (e.g., Age must be 18-99, or Status must be 'Pending', 'Shipped', or 'Delivered').

2. Safety Net: To prevent "impossible" data from entering the database due to bugs in the application-project.

## 5. DEFAULT

## What it is

A Default constraint provides a value for a column when the insert statement doesn't provide one. It ensures that the column is 
populated even if the backend project omits it.

## Example

    CREATE TABLE UserLogs (
    LogId INT PRIMARY KEY IDENTITY(1,1),
    LogMessage TEXT,
    LogDate DATETIME DEFAULT GETDATE(), -- Automatically sets the current time
    IsDeleted BIT DEFAULT 0             -- Automatically sets to False (0)
    );

## When to USE

Metadata/Timestamps: For "CreatedDate" or "ModifiedDate" columns.

Status Flags: When most records start with a specific state (e.g., IsActive = 1).

Optional Fields: When you want to avoid NULLs by providing a standard fallback value (e.g., setting a Country to 'Unknown' if not specified).
