IF OBJECT_ID('dbo.RunHealthCheck', 'P') IS NOT NULL
    DROP PROCEDURE dbo.RunHealthCheck;
GO

CREATE PROCEDURE dbo.RunHealthCheck
AS
BEGIN
    SET NOCOUNT ON;

    -- Blocking sessions
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        SessionID,
        BlockingSessionID,
        WaitType,
        WaitTimeMs,
        DatabaseName,
        Details
    )
    SELECT
        'Blocking',
        r.session_id,
        r.blocking_session_id,
        r.wait_type,
        r.wait_time,
        DB_NAME(r.database_id),
        'Blocked session detected'
    FROM sys.dm_exec_requests r
    WHERE r.blocking_session_id <> 0;

    -- Long-running queries
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        SessionID,
        WaitType,
        TotalElapsedTimeMs,
        DatabaseName,
        Details
    )
    SELECT
        'LongRunningQuery',
        r.session_id,
        r.wait_type,
        r.total_elapsed_time,
        DB_NAME(r.database_id),
        'Query running longer than 10 seconds'
    FROM sys.dm_exec_requests r
    WHERE r.total_elapsed_time > 10000;

    -- High CPU requests
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        SessionID,
        CPUTimeMs,
        DatabaseName,
        Details
    )
    SELECT
        'HighCPU',
        r.session_id,
        r.cpu_time,
        DB_NAME(r.database_id),
        'Request with high CPU usage'
    FROM sys.dm_exec_requests r
    WHERE r.cpu_time > 5000;

    -- Failed SQL Agent jobs in last 15 minutes
    INSERT INTO dbo.HealthCheckLog
    (
        IssueType,
        JobName,
        Details
    )
    SELECT
        'JobFailure',
        j.name,
        h.message
    FROM msdb.dbo.sysjobhistory h
    INNER JOIN msdb.dbo.sysjobs j
        ON h.job_id = j.job_id
    WHERE h.run_status = 0
      AND msdb.dbo.agent_datetime(h.run_date, h.run_time) >= DATEADD(MINUTE, -15, GETDATE());
END;
GO
