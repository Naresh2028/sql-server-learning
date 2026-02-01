# 1NF, 2NF, 3NF

This is one of the most important theoretical topics in SQL because it governs how you structure your tables to avoid data anomalies.

## What is a 1NF 

First Normal Form (1NF) is the foundational rule of database design. It ensures that the table is "flat" and structured correctly. To be in 1NF, a table must meet three rules:

Atomic Values: Each cell must contain a single value (no comma-separated lists like "Red, Blue, Green").

Unique Column Names: No repeated columns (like Phone1, Phone2, Phone3).

Unique Rows: Each row must be identifiable (usually by a Primary Key).


## Analogy

Think of an Excel Spreadsheet.

Bad (Not 1NF): You write "John Smith" in cell A1, and then in cell B1 you cram in "555-0100, 555-0101, 555-0102" because he has three phone numbers. You can't filter or sort by just one number.

Good (1NF): You create three separate rows for John Smith, each with one phone number. Now the spreadsheet is clean and sortable.

## Example

**Problem Table (Un-Normalized):**

| Student | Subjects |
| :--- | :--- |
| John | Math, Science, English |
| Jane | Math |

**Solution (1NF):**

| Student | Subject |
| :--- | :--- |
| John | Math |
| John | Science |
| John | English |
| Jane | Math |

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/87e87d5d-d284-4666-b07f-92c2bdbc41ce" />


## Notes
Why? SQL cannot efficiently search inside a comma-separated string (e.g., WHERE Subjects LIKE '%Math%' is slow and error-prone).

Key Takeaway: "One value per cell."

## What is a 2NF 

Second Normal Form (2NF) builds on 1NF. To be in 2NF, a table must:

Be in 1NF.

Have No Partial Dependencies.

This applies mostly to tables with a Composite Primary Key (a key made of 2+ columns).

Rule: Every non-key column must depend on the entire Primary Key, not just part of it.

## Analogy

Think of a Classroom Schedule.

The Key: (Student, Course).

The Data: Teacher Name.

The Problem: The Teacher Name depends only on the Course (Math is always taught by Mr. Smith). It doesn't matter which Student is taking it.

The Fix: Move the Teacher Name to a separate "Course" list. Don't repeat "Mr. Smith" next to every single student in his class.

## Example

**Problem Table (Key = StudentID + CourseID):**

| StudentID | CourseID | TeacherName | Grade |
| :--- | :--- | :--- | :--- |
| 1 | Math | Mr. Smith | A |
| 2 | Math | Mr. Smith | B |

**Solution (2NF):**

**Table 1: Enrollment**

| StudentID | CourseID | Grade |
| :--- | :--- | :--- |
| 1 | Math | A |

**Table 2: Courses**

| CourseID | TeacherName |
| :--- | :--- |
| Math | Mr. Smith |

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/e8f0bc0c-4b8f-44ac-bd46-46d9932562d9" />


## Notes

Why? It prevents Update Anomalies. If Mr. Smith changes his name, you only update it in one place (Table 2), not 500 times in Table 1.

Key Takeaway: "Does this column describe the whole key?"

## What is a 3NF 

Third Normal Form (3NF) builds on 2NF. To be in 3NF, a table must:

Be in 2NF.

Have No Transitive Dependencies.

Rule: Non-key columns should not depend on other non-key columns.

A column should depend on "The Key, the Whole Key, and Nothing But the Key" (Bill Kent's definition).

## Analogy

Think of an Employee List.

The Key: EmployeeID.

The Data: City, ZipCode.

The Problem: City actually depends on ZipCode (e.g., Zip 90210 is always Beverly Hills). ZipCode depends on EmployeeID.

The Fix: Move Zip Code definitions to a separate "Zip Codes" reference list.

## Example

**Problem Table:**

| EmpID | Name | ZipCode | City |
| :--- | :--- | :--- | :--- |
| 101 | Alice | 10001 | New York |
| 102 | Bob | 10001 | New York |

**Solution (3NF):**

**Table 1: Employees**

| EmpID | Name | ZipCode |
| :--- | :--- | :--- |
| 101 | Alice | 10001 |

**Table 2: ZipCodes**

| ZipCode | City |
| :--- | :--- |
| 10001 | New York |

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/81448b39-1bec-46c8-8c8e-910c3fb940d4" />


## Notes

Why? Further reduces data redundancy.

The Trade-off: 3NF creates more tables and requires more JOINS, which can be slightly slower to read but much safer to write.

Key Takeaway: "No hidden dependencies between non-key columns."
