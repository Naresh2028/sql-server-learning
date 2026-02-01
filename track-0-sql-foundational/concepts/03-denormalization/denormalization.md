# DENORMALIZATION

## What is Denormalization?

Denormalization is the intentional process of adding redundancy (duplicate data) back into a database that has already been normalized. 
While Normalization focuses on Write Speed and Data Integrity (by eliminating duplicates), Denormalization focuses on Read Speed (by eliminating complex Joins). 
It involves combining columns from multiple tables into a single table so the database doesn't have to work as hard to fetch the data.

## Analogy

<img width="1024" height="559" alt="image" src="https://github.com/user-attachments/assets/cefeef57-10f7-49b5-9d88-9f8c4b8d6cc8" />


Think of Packing a Lunchbox.

Normalized (Cooking Fresh): Every day at noon, you go to the fridge, get bread, get cheese, get meat, slice them, and assemble a sandwich.

Pro: Ingredients are fresh and stored efficiently.

Con: It takes 15 minutes to "assemble" (Join) your lunch every day.

Denormalized (Pre-packed): On Sunday night, you make 5 sandwiches and put them in tupperware.

Pro: At noon, you just grab a box. Instant lunch.

Con: If the bread goes moldy, all 5 sandwiches are ruined (Data Update Anomaly). You also need more fridge space.

## Syntax

There is no special keyword like DENORMALIZE. It is simply the act of adding a column to a table that technically "doesn't belong there" according to strict 3NF rules.

-- The "Strict" Normalized Way (3NF)
-- To get the Total, we must calculate it every time.


````sql
SELECT OrderID, (Quantity * UnitPrice) as Total 
FROM OrderDetails;

-- The "Denormalized" Way
-- We add a 'TotalAmount' column to the table and save the calculation once.
ALTER TABLE OrderDetails ADD TotalAmount DECIMAL(10,2);

-- Now the read is instant (no math required during SELECT)
SELECT OrderID, TotalAmount 
FROM OrderDetails;

````

## When to Use

Reporting / Data Warehousing (OLAP): In Star Schemas, we almost always denormalize dimensions to speed up reports.

Heavy Read Workloads: If you have a query that runs 1 million times a day and joins 5 tables, denormalizing those 5 tables into 1 might save massive CPU power.

Computed Columns: Storing a calculated value (like Total = Price * Qty) so you don't have to recalculate it for every single row, every single time.

## When NOT to Use

OLTP Systems (Banking/Transactional): Do not use this in a high-write environment. If you store a user's address in 5 different tables, and they move houses, 
you have to update 5 tables. If you miss one, your data is corrupt.

To fix "Bad Coding": Don't denormalize just because you are too lazy to write a JOIN. Only do it if performance metrics prove you need it.

## What Problem Does It Solve?

It solves the "Expensive Read" problem. In a normalized database, retrieving a simple "User Profile" might require joining Users, Addresses, 
Emails, Phones, and Preferences tables. This consumes high CPU. Denormalization flattens this into one UserProfileView table, making the read instant.

## Common Misconceptions / Important Notes	

"It means Un-normalized": False. You start with a Normalized design. You only denormalize specific parts that are causing performance bottlenecks. 
It is a targeted optimization, not a sloppy design.

Storage Space: Yes, it uses more disk space, but in 2026, disk space is cheap. The real cost is the Maintenance Nightmare (keeping the duplicate data in sync).

## Example

Scenario: A website displays the "Author Name" next to every blog post.

Normalized (3NF):

Posts table has AuthorID.

Authors table has AuthorID, Name.

Query: 

````sql

SELECT P.Title, A.Name FROM Posts P JOIN Authors A ON P.AuthorID = A.AuthorID

````

Cost: The DB must look up the Author table for every single post displayed.

Denormalized:

We add a AuthorName column directly to the Posts table.

Query: 

````sql

SELECT Title, AuthorName FROM Posts

````

Benefit: No Join required. Super fast.

Risk: If the Author changes their name, we must update the Authors table AND thousands of rows in the Posts table.



