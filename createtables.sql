IF OBJECT_ID('dbo.HealthCheckLog', 'U') IS NOT NULL
    DROP TABLE dbo.HealthCheckLog;
GO

CREATE TABLE dbo.HealthCheckLog
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    CaptureTime DATETIME NOT NULL DEFAULT GETDATE(),
    IssueType NVARCHAR(100) NOT NULL,
    SessionID INT NULL,
    BlockingSessionID INT NULL,
    JobName NVARCHAR(200) NULL,
    WaitType NVARCHAR(120) NULL,
    WaitTimeMs INT NULL,
    CPUTimeMs INT NULL,
    TotalElapsedTimeMs INT NULL,
    DatabaseName NVARCHAR(128) NULL,
    Details NVARCHAR(MAX) NULL
);
GO

IF OBJECT_ID('dbo.PerformanceScoreLog', 'U') IS NOT NULL
    DROP TABLE dbo.PerformanceScoreLog;
GO

CREATE TABLE dbo.PerformanceScoreLog
(
    ScoreID INT IDENTITY(1,1) PRIMARY KEY,
    CaptureTime DATETIME NOT NULL DEFAULT GETDATE(),
    BlockingCount INT NOT NULL,
    LongRunningCount INT NOT NULL,
    HighCPUCount INT NOT NULL,
    FailedJobCount INT NOT NULL,
    FinalScore INT NOT NULL,
    Recommendation NVARCHAR(500) NULL
);
GO
