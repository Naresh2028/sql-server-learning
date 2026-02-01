# 1 TO 1, 1 TO MANY, MANY TO MANY

## What is One to One

In a One-to-One relationship, a single record in the first table is related to only one record in the second table, and vice-versa. 
This is the simplest type of relationship and is often used to split a large table into smaller, more manageable ones, or to store optional data.

## Analogy

Think of a Person and their Passport.

A single person can have only one valid passport.

A single passport can belong to only one person. The relationship is unique in both directions.

### Visual Representation
<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/4063647e-17e8-4bdc-a4b5-088d33ef0aa7" />


## Example

Let's say we have a Users table and we want to store extra, optional details about them in a separate UserDetails table.

```sql

-- 1. Create the main Users table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50)
);

-- 2. Create the UserDetails table
-- The Primary Key of this table is ALSO a Foreign Key to the Users table.
CREATE TABLE UserDetails (
    UserID INT PRIMARY KEY, -- This guarantees the 1:1 relationship
    Address VARCHAR(100),
    PhoneNumber VARCHAR(20),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Inserting data
INSERT INTO Users VALUES (1, 'john_doe');
INSERT INTO UserDetails VALUES (1, '123 Main St', '555-0100');

-- This would fail because UserID 1 already exists in UserDetails
-- INSERT INTO UserDetails VALUES (1, '456 Oak Ave', '555-0101');

```

## Notes

Implementation: A 1:1 relationship is typically implemented by having the primary key of one table also serve as a foreign key referencing the primary key of the other table.

Use Cases:

Security: Storing sensitive data (like passwords or social security numbers) in a separate table with stricter access controls.

Partitioning: Splitting a table with many columns into two smaller tables for better performance or organization.

Optional Data: Storing data that doesn't apply to every record in the main table to avoid null values.

## What is One to Many

In a One-to-Many relationship, a single record in the first table (the "parent" or "one" side) can be related to one or 
more records in the second table (the "child" or "many" side). However, each record in the "many" table is related to only 
one record in the "one" table. This is the most common type of relationship.

## Analogy

Think of a Mother and her Children.

One mother can have multiple children.

Each child has only one biological mother. The relationship is "one" from the mother's perspective and "many" from the children's perspective.

### Visual Representaion

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/d9063f73-4a1f-45c4-90a4-77b0c18a789e" />

## Example

Consider a classic e-commerce example with Customers and their Orders.

````sql

-- 1. Create the "One" side table (Customers)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- 2. Create the "Many" side table (Orders)
-- This table has a Foreign Key column pointing to the Customers table.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    Amount DECIMAL(10, 2),
    CustomerID INT, -- Foreign Key column
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Inserting data
INSERT INTO Customers VALUES (1, 'Alice Smith');
-- Alice can place multiple orders
INSERT INTO Orders VALUES (101, '2023-01-15', 50.00, 1);
INSERT INTO Orders VALUES (102, '2023-02-10', 75.50, 1);

````

## Notes

Implementation: The foreign key is always placed on the "many" side of the relationship. In the example, the CustomerID is in the Orders table.

Parent-Child: This is often called a parent-child relationship. The "one" table is the parent, and the "many" table is the child.

Referential Integrity: The database ensures that you cannot have an order for a non-existent customer.

## What is Many to Many

In a Many-to-Many relationship, a single record in the first table can be related to one or more records in the second table,
AND a single record in the second table can be related to one or more records in the first table.

## Analogy

Think of Students and Courses.

A single student can enroll in many different courses.

A single course can have many different students enrolled in it. The relationship is "many" in both directions.

### Visual Representaion

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/9c801218-b0f7-4b53-8f1a-c92419ff3c4c" />

## Example

You cannot implement a many-to-many relationship directly in a relational database. You must use a third table, often called a 
junction table, associative entity, or linking table, to break it down into two one-to-many relationships.

````sql

-- 1. Create the first table (Students)
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100)
);

-- 2. Create the second table (Courses)
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100)
);

-- 3. Create the Junction Table (StudentCourses)
-- This table contains foreign keys to both parent tables.
CREATE TABLE StudentCourses (
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    PRIMARY KEY (StudentID, CourseID), -- Composite Primary Key
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Inserting data
INSERT INTO Students VALUES (1, 'John'), (2, 'Jane');
INSERT INTO Courses VALUES (101, 'Math'), (102, 'Science');

-- John is in Math and Science
INSERT INTO StudentCourses VALUES (1, 101, '2023-09-01');
INSERT INTO StudentCourses VALUES (1, 102, '2023-09-01');
-- Jane is in Math
INSERT INTO StudentCourses VALUES (2, 101, '2023-09-01');

````

## Notes

Junction Table: The junction table (StudentCourses in the example) sits between the two main tables. It contains the primary keys from both tables, which serve as foreign keys.

Composite Key: The junction table often uses a composite primary key made up of the two foreign key columns to ensure that each pair (e.g., Student 1 and Course 101) is unique.

Extra Data: The junction table can also hold extra information about the relationship itself, such as the EnrollmentDate in the example.
