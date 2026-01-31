# BULK INSERT IMPORT / EXPORT

## What is Bulk Insert?

BULK INSERT is a powerful T-SQL command designed exclusively for speed. It allows you to import a data file (like a CSV or Text file) directly into a database table. It bypasses many of the standard transaction logging and checking mechanisms to insert data significantly faster than standard INSERT statements.

## Analogy

Think of Unloading a Moving Truck.

Standard INSERT: You take one box out of the truck, walk it into the house, place it on the shelf, and write down "I moved 1 box." Then you go back for the next one. (Slow).

BULK INSERT: You back the truck up to a window, tilt the bed, and slide all the boxes into the living room at once. You only write down "I moved the whole truck." (Fast).

## Visual Representaion

Create a simple .csv file on your C:\ drive (e.g., data.csv).

Open a Query Window in SSMS.

Type the BULK INSERT command (see example below).

BULK INSERT dbo.ImportTest
FROM 'D:\Database\Text_file\data.txt'
WITH (
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '\n',   
    FIRSTROW = 1            
);

<img width="1473" height="661" alt="image" src="https://github.com/user-attachments/assets/23947993-4e50-407a-82c9-b92d5133692d" />

## Notes

Speed: This is arguably the fastest way to get data into SQL Server.

Permissions: You usually need ADMINISTER BULK OPERATIONS permission to run this.

Limitations: It expects the file to be on the server's disk (or accessible network share), not necessarily your local laptop if you are connecting remotely.

Error Handling: It’s "all or nothing" by default, but you can set a MAXERRORS parameter to allow a few bad rows (like bad formatting) without stopping the whole load.

## What is the Import / Export wizard?

The SQL Server Import and Export Wizard is a graphical tool (GUI) that guides you through moving data between different sources. It is extremely flexible: you can move data from Excel to SQL, SQL to Text, Oracle to SQL, or even Database A to Database B.

## Analogy

Think of a Universal Adapter / Translator.

You have a plug from Europe (Excel) and a socket in the US (SQL Server).

The Wizard is the adapter that sits in the middle, reshapes the electricity (Data Types), and allows the power to flow safely from one side to the other.

## Visual Representaion

### The Import Wizard (GUI)

Right-click your database (Ring...).

Select Tasks -> Import Flat File... (It is enabled in your screenshot!).

Introduction: Click Next.

Specify Input File: Browse to your C:\SQLData\data.csv.

New Table Name: It will suggest data. Change it to ImportTest_GUI if you want.

Preview Data: It shows you the columns. Click Next.

Modify Columns: It guesses the data types (e.g., int, nvarchar). You can adjust them here if needed.

Summary: Click Finish.

<img width="950" height="973" alt="image" src="https://github.com/user-attachments/assets/6bbe2828-26ff-492a-af6f-ce1e1a06f51e" />

## Notes

Under the Hood: This wizard actually creates a mini SSIS (SQL Server Integration Services) package in the background to do the work.

Mapping: It allows you to "Map" columns. If your Excel column is named "First Name" and your SQL table is FirstName, you can manually draw a line connecting them in the wizard.

New Tables: A cool feature is that it can create the destination table for you if it doesn't exist yet, automatically guessing the data types based on the input.
