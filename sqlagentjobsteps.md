# SQL Server Agent Job Steps

## Job Name
SQL Server Performance Score Monitor

## Purpose
This job captures health issues and calculates a performance score automatically.

## Step 1
Execute:

```sql
EXEC dbo.RunHealthCheck;

