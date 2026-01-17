# TABLE DESIGN

## What is Table Design?
Table design is the process of defining the physical structure of tables in a database.
It is the implementation phase of data modeling, where entities, columns, data types,
and relationships are translated into actual SQL tables.

## Analogy

Imagine you are organizing a Physical Filing Cabinet.

The Cabinet is the Database.

The Drawers are the Tables (e.g., "Invoices," "Customers").

The Folders inside are the Records (Rows).

The Labels/Fields on the folder (Date, Name, Amount) are the Columns. If you throw every piece of paper into one giant drawer,
you’ll never find anything. Table design is the art of deciding which drawer a piece of paper belongs in.

## Syntax

Creating a table involves defining the name, the columns, and their data types.

    CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    DateOfBirth DATE,
    CreatedAt DATETIME2 DEFAULT SYSDATETIME()
    );
  
## When to Use

Transactional Data: When you need to store persistent information (Orders, User profiles).

Relational Data: When data points have logical connections (An Order belongs to a Customer).

Standardization: When you want to ensure every record follows the exact same format.

## When NOT to Use

Unstructured Data: If you have data that changes shape constantly (e.g., social media feeds with random fields), a NoSQL database (like MongoDB) might be better.

Temporary Logs: If you are logging millions of lines of "temp" data that you’ll delete in an hour, a high-performance cache like Redis is often better than a formal SQL table.

## What Problem Does It Solve?

Data Redundancy: Prevents repeated data storage by applying normalization
(1NF, 2NF, 3NF) principles.

Data Integrity: Ensures you can't accidentally put a "Name" in a "Price" column.

Search Performance: A well-designed table allows the database engine to find specific data in milliseconds using indexes.

## Common Misconceptions / Important Notes

"One Big Table is Easier": Beginners often put everything in one table. This leads to "Update Anomalies" (e.g., if a user changes their name, you have to update 1,000 order rows).

NULLs are not free: Excessive NULLable columns complicate query logic,
index usage, and application-level validation. Use NOT NULL when a value
is logically mandatory.


Plural vs. Singular: There is a long debate, but consistency is key. (e.g., naming tables Users vs User). Most .NET developers prefer Users (plural) to match the DbSet<User> in EF Core.

## Example

E-Commerce Scenario : Instead of one "Sales" table, we split it to maintain integrity

| Table      | Purpose                          | Key Columns                          |
|------------|----------------------------------|--------------------------------------|
| Products   | Store catalog info               | ProductId, Name, Price               |
| Orders     | Store transaction header         | OrderId, OrderDate, CustomerId       |
| OrderItems | Store order line items           | OrderItemId, OrderId, ProductId, Qty |
