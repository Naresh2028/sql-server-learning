# RECURSIVE CTE

## What is RECURSIVE-CTE?
A Recursive CTE is a CTE that references itself. It allows you to loop through data that has a parent-child relationship 
until a specific condition is met.

## Analogy
Think of a Family Tree.

1. You start with the Great-Grandfather (The Anchor).

2. You look for his Children (The Recursion).

3. Then you look for their children, and so on. You keep going down the branches until you reach the youngest generation (The Termination).

## Syntax
A Recursive CTE always has three parts:

1. The Anchor: The starting row(s) (e.g., the "Top Boss").

2. UNION ALL: The glue that connects the levels.

3. The Recursive Member: The query that joins the CTE back to the original table.

WITH RecursiveCTE AS (
    -- 1. Anchor Member
    SELECT ID, Name, ParentID, 1 AS Level
    FROM Table WHERE ParentID IS NULL
    
   UNION ALL
    
   -- 2. Recursive Member
    SELECT t.ID, t.Name, t.ParentID, r.Level + 1
    FROM Table t
    INNER JOIN RecursiveCTE r ON t.ParentID = r.ID
)
SELECT * FROM RecursiveCTE;

## When to Use
1. Org Charts: Finding everyone who reports to a specific manager.

2. BOM (Bill of Materials): Listing all parts inside a car, then all screws inside those parts.

3. Menu Systems: Multi-level navigation menus in your Angular app.

4. Folder Structures: Mapping out nested directories.

## When NOT to Use
1. Flat Data: If there is no parent-child relationship, a regular CTE is better.

2. Infinite Loops: If your data has a "cycle" (A reports to B, B reports to A), the query will crash unless you limit the "MAXRECURSION."

## What Problem Does It Solve?
It solves the problem of Unknown Depth. Without recursion, you would need 10 different JOINs to find someone 10 levels deep.
A Recursive CTE handles 2 levels or 200 levels with the same amount of code.

## Example
Problem: You are building a staff directory for your new office in San Francisco. You need to show the management hierarchy: 
who reports to whom and what "level" they are at.

-- Create the Employee Table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(50),
    ManagerID INT
);

-- Insert Hierarchy: CEO -> Manager -> Staff
INSERT INTO Employees VALUES (1, 'Alice (CEO)', NULL);
INSERT INTO Employees VALUES (2, 'Bob (Manager)', 1);
INSERT INTO Employees VALUES (3, 'Charlie (Staff)', 2);
INSERT INTO Employees VALUES (4, 'David (Staff)', 2);

-- The Recursive CTE
WITH OrgChart AS (
    -- Anchor: Start with the CEO
    SELECT EmpID, EmpName, ManagerID, 1 AS HierarchyLevel
    FROM Employees
    WHERE ManagerID IS NULL
    
  UNION ALL
    
  -- Recursion: Join employees to their managers
    SELECT e.EmpID, e.EmpName, e.ManagerID, o.HierarchyLevel + 1
    FROM Employees e
    INNER JOIN OrgChart o ON e.ManagerID = o.EmpID
)
SELECT * FROM OrgChart ORDER BY HierarchyLevel;

## Common Misconceptions

1. "It runs forever": By default, SQL Server limits recursion to 100 levels to prevent crashes. 
You can change this using OPTION (MAXRECURSION 0) for unlimited (use with caution!).

2. "It’s just a loop": While it acts like a loop, SQL Server optimizes this as a set-based operation, 
making it much faster than a WHILE loop in a Stored Procedure.

3. "Anchor and Recursive types can be different": False. The columns in both parts of the UNION ALL 
must match in number and data type perfectly.
