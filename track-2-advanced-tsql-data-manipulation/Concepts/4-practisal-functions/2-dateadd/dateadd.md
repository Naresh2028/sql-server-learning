# DATEADD

In our .NET Core development career, you will constantly deal with "Expirations," "Trial Periods," and "Scheduled Tasks." DATEADD is the function you will use to calculate these future (or past) milestones.

## What is DATEADD?

DATEADD is a function that adds a specific number interval (like days, months, or years) to a starting date and returns the new date. You can also use it to subtract time by providing a negative number.

## Analogy

Think of a Calendar "Plus/Minus" Button. If you are looking at a calendar and someone says, "Your project is due in exactly 3 months," you don't manually count every day. You simply skip forward three pages in the calendar. DATEADD is that "skip forward" or "skip backward" action.

## Syntax

    DATEADD (datepart , number , date)

datepart: The unit of time (e.g., year, month, day, hour, minute).

number: The amount to add (use a positive integer to go forward, negative to go back).

date: The starting date (a column, variable, or string).

## When to Use

Expirations: Calculating when a user's subscription expires (e.g., Today + 30 days).

Aging Reports: Finding records from "3 months ago" to see inactive users.

Schedules: Calculating the next delivery date for a recurring order in your Angular dashboard.

Timezone Adjustments: Adding hours to convert UTC time to a local time.

## When NOT to Use

Simple Comparisons: If you just want to see if a date is older than another, you don't need DATEADD; just use >.

Extracting Parts: If you just want to know what "Year" it is, use YEAR(date) or DATEPART instead of adding zero years.

## What Problem Does It Solve?

It solves the "Irregular Month/Year" problem. Not every month has 30 days, and leap years exist. DATEADD handles all the complex calendar logic for you, so you don't accidentally calculate "February 30th."

## Common Misconceptions / Important Notes

Over-adding: If you add 1 month to January 31st, SQL Server is smart enough to return February 28th (or 29th) because February 31st doesn't exist.

Dateparts: You can use abbreviations (e.g., yy for year, mm for month, dd for day).

Data Types: Adding time to a DATE type returns a DATE. Adding time to a DATETIME returns a DATETIME.

## Example

Scenario: A company offers a 14-day free trial for their software. You need to calculate when each user's trial will end based on their SignupDate.

    SELECT 
      UserName,
      SignupDate,
      DATEADD(day, 14, SignupDate) AS TrialExpiryDate,
      DATEADD(month, -1, GETDATE()) AS OneMonthAgo -- Using a negative number to look back
    FROM Users;
