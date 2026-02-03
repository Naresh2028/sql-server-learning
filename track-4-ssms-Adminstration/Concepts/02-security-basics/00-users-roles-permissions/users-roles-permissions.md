# USER, ROLES, & PERMISSIONS 

## What is a USER

A User is a security principal that exists inside a specific database. While a "Login" allows you to connect to the SQL Server instance (the server itself), the "User" allows you to actually enter and work with a specific database (like SalesDB). You maps a Server Login to a Database User.

## Analogy

Think of an Office Building ID Card.

The Login: Is passing the security guard at the front door. You are allowed into the Lobby (The Server).

The User: Is the specific access coding on your badge. It lets you open the door to the 3rd Floor Finance Department (The Database). Without this, you are stuck in the lobby.

## Visual Representaion

Expand Databases -> YourDatabase -> Security -> Users.
<img width="497" height="687" alt="image" src="https://github.com/user-attachments/assets/ccb30aa5-fa9f-4081-bf5a-77a72d7f1681" />

## Notes

Login vs. User: This is the #1 confusion.

Login: Server Level (Authentication).

User: Database Level (Authorization).

Orphaned Users: If you delete a Login but forget to delete the User in the database, that User becomes "orphaned" and breaks.

dbo: Stands for "Database Owner". It is the default user with full power.

## What is a Roles

A Role is a container (group) that holds a set of permissions. Instead of assigning 50 different permissions to 50 different users individually, you assign the permissions to one Role, and then simply add the users to that Role.

## Analogy

Think of Job Titles.

Instead of telling the security guard: "Allow Bob to open the broom closet, the chemical supply room, and the trash compactor," you simply say: "Bob is a Janitor."

The "Janitor" Role already has keys to all those rooms. If you hire Alice, you just tag her as "Janitor" too.

## Visual Representaion

Expand Databases -> YourDatabase -> Security -> Roles -> Database Roles.

<img width="548" height="852" alt="image" src="https://github.com/user-attachments/assets/473eb614-62a0-4fce-8e28-c9bbff8f81c9" />

## Notes

Built-in Roles: SQL Server comes with pre-made roles:

db_datareader: Can read (SELECT) everything.

db_datawriter: Can write (INSERT, UPDATE) everything.

db_owner: God mode for that specific database.

Best Practice: Always assign permissions to Roles, not individual Users. It makes managing team changes much easier.

## What is a Permissions

Permissions are the granular "rights" to perform specific actions on specific objects. They are the atomic units of security. Examples include SELECT, INSERT, UPDATE, DELETE, EXECUTE (for Stored Procedures), or ALTER (to change table structure).

## Analogy

Think of the Actual Keys.

Having the Role of "Manager" is the title.

The Permission is the shiny metal key that physically unlocks "Office 101."

Even if you are a "Manager," if you don't have the "Key to the Safe" (Permission), you can't open it.

## Visual Representaion

Right-click a Table (e.g., Users) -> Properties.

Click the Permissions tab on the left.

<img width="948" height="820" alt="image" src="https://github.com/user-attachments/assets/bf58cd53-4ade-44ef-985e-b616578d1e2d" />

## Notes

Grant: "You can do this."

Deny: "You absolutely CANNOT do this." (Overrides everything else).

Revoke: "I am taking back the permission I gave you" (Neutral state).

Hierarchy: If a user is in a Role that has GRANT SELECT, but individually they have DENY SELECT, the DENY wins.
