# 1NF, 2NF, 3NF

This is one of the most important theoretical topics in SQL because it governs how you structure your tables to avoid data anomalies.

## What is a 1NF 

First Normal Form (1NF) is the foundational rule of database design. It ensures that the table is "flat" and structured correctly. To be in 1NF, a table must meet three rules:

Atomic Values: Each cell must contain a single value (no comma-separated lists like "Red, Blue, Green").

Unique Column Names: No repeated columns (like Phone1, Phone2, Phone3).

Unique Rows: Each row must be identifiable (usually by a Primary Key).

<img width="340" height="390" alt="image" src="https://github.com/user-attachments/assets/460b0d62-cad1-4731-a516-2c1aa694283e" />


## Analogy

Think of an Excel Spreadsheet.

Bad (Not 1NF): You write "John Smith" in cell A1, and then in cell B1 you cram in "555-0100, 555-0101, 555-0102" because he has three phone numbers. You can't filter or sort by just one number.

Good (1NF): You create three separate rows for John Smith, each with one phone number. Now the spreadsheet is clean and sortable.

## Example

Problem Table (Un-Normalized): 

| Student | Subjects | | :--- | :--- | | John | Math, Science, English | | Jane | Math |

Solution (1NF): 

| Student | Subject | | :--- | :--- | | John | Math | | John | Science | | John | English | | Jane | Math |

## Notes
Why? SQL cannot efficiently search inside a comma-separated string (e.g., WHERE Subjects LIKE '%Math%' is slow and error-prone).

Key Takeaway: "One value per cell."

## What is a 2NF 
## Analogy
## Visual Representaion
## Example
## Notes


## What is a 3NF 
## Analogy
## Visual Representaion
## Example
## Notes
