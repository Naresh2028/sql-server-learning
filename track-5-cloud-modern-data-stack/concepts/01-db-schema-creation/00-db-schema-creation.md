````sql
GO
CREATE DATABASE TicketBookingMasterLiveDB
GO
````


--→ Defines what is allowed (cities, routes, seat types, payment modes)
````sql
Go
CREATE SCHEMA ref;
Go
````


--→ Records business truth (bookings, cancellations, payments)
````sql
Go
CREATE SCHEMA core;
Go
````

--→ Tracks system behavior (locks, retries, failures, events)
````sql
Go
CREATE SCHEMA ops;
Go
````
