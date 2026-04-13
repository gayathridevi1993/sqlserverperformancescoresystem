# SQL Server Performance Score System

## Overview

This project builds a simple SQL Server monitoring system that calculates a performance score based on common production issues.

The system checks:

- Blocking sessions
- Long-running queries
- High CPU requests
- Failed SQL Agent jobs

It stores health events in a log table and calculates a score out of 100 to give a quick view of database health.

## Why This Project

In many environments, SQL Server issues are checked manually and separately. This project combines multiple checks into a single scoring model, making performance monitoring easier and more actionable.

## How It Works

1. Capture health issues into a log table
2. Count issue severity
3. Deduct points based on rules
4. Store final score and recommendation

## Files

- `01_create_tables.sql` → creates the required tables
- `02_create_health_capture_procedure.sql` → captures health issues
- `03_create_score_calculation_procedure.sql` → calculates performance score
- `04_reporting_queries.sql` → reports health score and issue breakdown
- `05_sql_agent_job_steps.md` → schedule automation steps

## Scoring Logic

The score starts at 100 and deductions are applied for:

- Blocking sessions
- Long-running queries
- High CPU requests
- Failed jobs

## Example

- Health Score: 78/100
- Issues:
  - 2 blocking sessions
  - 1 long-running query
  - 1 failed job

## Future Improvements

- Add deadlock score deduction
- Add disk space monitoring
- Add email alerts
- Add dashboard reporting in Power BI
