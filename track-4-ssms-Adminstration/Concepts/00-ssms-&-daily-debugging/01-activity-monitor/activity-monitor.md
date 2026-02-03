# ACTIVITY MONITOR

## What is a Activity Monitor
Activity Monitor is a built-in graphical "Dashboard" in SQL Server Management Studio (SSMS). It provides a real-time view of the server's health and current workload. It allows you to instantly see how much CPU and Memory the server is using, and—most importantly—identify exactly which users or queries are blocked or stuck.

## Analogy

Think of the Vital Signs Monitor in a Hospital ICU.

The Server: Is the Patient.

Activity Monitor: Is the screen beeping with heart rate (CPU), blood pressure (Disk I/O), and oxygen levels (Memory).

The Usage: If the lines go flat or spike dangerously high, the doctor (DBA) looks at this monitor first to diagnose the immediate problem before doing surgery.

## Visual Representaion

<img width="1914" height="875" alt="image" src="https://github.com/user-attachments/assets/6843aecc-db85-4a2d-ae10-0b8f7fae3d84" />

Shortcut: Press Ctrl + Alt + A to open it instantly.


## Notes

The "Processes" Pane: This is your best friend. Look at the Wait Type column.

LCK_M...: Means Blocking (someone is locking a table).

PAGEIOLATCH...: Means Disk Issues (hard drive is too slow).

Kill Switch: You can Right-Click a stuck process in this list and select "Kill Process" to force it to stop (use carefully!).

Performance: Do not leave this open 24/7 on a production server; the monitoring itself uses a small amount of server resources. Close it when you are done fixing the issue.
