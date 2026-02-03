# BACKUP & RECOVERY

## What is Backup & Recovery?
Backup is the process of creating a copy of your data to protect against data loss (accidental deletion, hardware failure, or corruption). 

Recovery (Restore) is the process of taking that copy and overwriting the current database (or creating a new one) to bring the data back to a specific point in time.


## Analogy
Think of Video Game Save Points.

Full Backup: A "Hard Save" at the start of a level. You save everything (Inventory, Health, Location). It takes a while, but it's safe.

Differential Backup: A "Quick Save" halfway through the level. It only saves what changed since the start (e.g., "I picked up 2 potions"). It's faster.

Transaction Log: A "Replay Recording" of every button you pressed. If the game crashes, you can replay the recording to get back to the exact second before the crash.

## 1. The Backup Process

## Visual Representation

### Step by Step Guide

1. Open SSMS.

2. In Object Explorer, expand Databases.

3. Right-click the specific database (e.g., MyDatabase) → Tasks → Back Up...

<img width="853" height="1003" alt="image" src="https://github.com/user-attachments/assets/21ede938-832d-4735-85ef-a248b19062ff" />

4. Configure the Dialog:

Backup type: Choose Full (for a complete copy).

5. Destination: Ensure it points to a disk path (e.g., C:\Backups\MyDatabase.bak). If a path exists, usually you remove the old one and "Add" a new one to ensure a clean file.

Click OK.

<img width="974" height="834" alt="image" src="https://github.com/user-attachments/assets/ca03cd03-a45a-4870-985e-81dd8b09b8c4" />

6. You should see a success message: "The backup of database '...' completed successfully."

## 2. The Restore Process (Step-by-Step)

## Visual Representation

### Steps to Restore a Database

1. Open SSMS.

2. Right-click the Databases folder (the root folder) → Restore Database...

<img width="456" height="469" alt="image" src="https://github.com/user-attachments/assets/ae7b6c2d-f707-494f-b90a-989422a233b6" />

Source Section:

Select Device.

Click the ... (Browse) button.

3. Click Add and navigate to your .bak file (e.g., C:\Backups\MyDatabase.bak). Click OK.

Destination Section:

4. The "Database" field will auto-fill. You can change this name if you want to restore it as a copy (e.g., MyDatabase_Copy).

<img width="938" height="773" alt="image" src="https://github.com/user-attachments/assets/b40f0d45-14bf-4392-adc0-88d35dea148d" />

### Important Before Restore 

Don't for to uncheck the tail log log option before click ok.

<img width="853" height="747" alt="image" src="https://github.com/user-attachments/assets/aaf792bd-e3a4-4d4a-9747-7cc326c2d31b" />

**Click OK.**

5. The database will appear in your Object Explorer list.

## Notes

The ".bak" File: This is the standard file extension for SQL Server backups.

Don't overwrite live data: Be very careful when restoring. If you restore over a production database, the current data is gone forever. Always restore to a new name (e.g., Prod_Test) first to check the data.

Recovery Models:

Simple: You can only restore to the last backup (no specific time). Good for Dev/Test.

Full: You can restore to a specific second (Point-in-Time). Requires Transaction Log backups. Used for Production.

"Database is in use" Error: You cannot restore a database if users are connected to it. You must check the box "Close existing connections to destination database" in the Options tab of the Restore dialog to force it.


