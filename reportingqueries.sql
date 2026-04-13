-- Latest performance score
SELECT TOP 1
    ScoreID,
    CaptureTime,
    BlockingCount,
    LongRunningCount,
    HighCPUCount,
    FailedJobCount,
    FinalScore,
    Recommendation
FROM dbo.PerformanceScoreLog
ORDER BY CaptureTime DESC;
GO

-- Score trend
SELECT
    CAST(CaptureTime AS DATE) AS ScoreDate,
    AVG(FinalScore) AS AverageScore
FROM dbo.PerformanceScoreLog
GROUP BY CAST(CaptureTime AS DATE)
ORDER BY ScoreDate DESC;
GO

-- Issue count by type
SELECT
    IssueType,
    COUNT(*) AS IssueCount
FROM dbo.HealthCheckLog
GROUP BY IssueType
ORDER BY IssueCount DESC;
GO

-- Recent health issues
SELECT TOP 50
    LogID,
    CaptureTime,
    IssueType,
    SessionID,
    BlockingSessionID,
    JobName,
    WaitType,
    WaitTimeMs,
    CPUTimeMs,
    TotalElapsedTimeMs,
    DatabaseName,
    Details
FROM dbo.HealthCheckLog
ORDER BY CaptureTime DESC;
GO
