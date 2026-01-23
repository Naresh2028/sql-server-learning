# VIEWS

In .NET Core development, Views are often used to simplify the data access layer. Instead of writing a complex 20-line SQL query inside your C# code, you can simply call SELECT * FROM ViewName

## What is Views?

A View is a virtual table based on the result-set of an SQL statement. It contains rows and columns, just like a real table. The fields in a view are fields from one or more real tables in the database.

Crucially, standard views do not store data physically. They save the query logic. Every time you select from a view, SQL Server runs the underlying query on the fly to fetch the fresh data.

## Analogy

Think of a "Saved Search" or a "Smart Playlist".

The Tables: These are your actual MP3 music files on the hard drive.

The View: This is a playlist called "Best 90s Rock." It doesn't duplicate the MP3 files; it just points to the specific songs that match your criteria. If you delete a song from the hard drive (Table), it disappears from the playlist (View) too.

## Syntax

    CREATE VIEW ViewName AS
    SELECT Column1, Column2
    FROM TableName
    WHERE Condition;

## When to Use

Security (Row/Column Level): To give a user access to the Employees table but hide the Salary column. You create a view selecting only Name and Email and grant access to the View, not the Table.

Simplification: To wrap a complex query with 5 JOINs into a single object. Your C# developers can just query AllOrderDetails without knowing the complex logic underneath.

Backward Compatibility: If you rename a table from Users to AppUsers, legacy code might break. You can create a View named Users that points to AppUsers so the old code keeps working.

## When NOT to Use

Performance Magic: Don't use a view just thinking it makes queries faster. It doesn't. It runs the exact same underlying query every time.

Heavy Nesting: Avoid creating "Views of Views of Views." This creates a "Tower of Babel" that is impossible to debug and kills performance.

## What Problem Does It Solve?

It solves the Abstraction and Security problem. It decouples your application code from your database schema. If the table structure changes, you can just update the View definition without recompiling your C# code.

## Common Misconceptions / Important Notes

"Views store data": False. Standard views are just stored queries. (Exception: Indexed Views or Materialized Views do store data, but those are advanced/special cases).

"Views are read-only": Partially False. You can update data through a simple view (affecting one table), but it is generally safer and cleaner to treat them as read-only.

"ORDER BY usage": You cannot use ORDER BY inside a View definition unless you also use TOP or OFFSET. Sorting should be done when selecting from the view, not defining it.

## Example

Scenario: We have an Employees table with sensitive salary data. We want the HR Intern to see the names but not the money.

1. Create the View (Virtual Table)

       CREATE VIEW vw_PublicEmployeeInfo AS
       SELECT EmployeeID, FirstName, LastName, Email
       FROM Employees;
 
Notice: We deliberately excluded the 'Salary' column.

2. The Intern runs this:

        SELECT * FROM vw_PublicEmployeeInfo;

Result: The intern sees the data as if it were a table, but the sensitive columns are physically impossible for them to query.
