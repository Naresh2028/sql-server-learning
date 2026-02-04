GO
CREATE DATABASE TicketBookingMasterLiveDB
GO

--→ Defines what is allowed (cities, routes, seat types, payment modes)
Go
CREATE SCHEMA ref;
Go

--→ Records business truth (bookings, cancellations, payments)
Go
CREATE SCHEMA core;
Go

--→ Tracks system behavior (locks, retries, failures, events)
Go
CREATE SCHEMA ops;
Go
