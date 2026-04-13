IF OBJECT_ID('dbo.CalculatePerformanceScore', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CalculatePerformanceScore;
GO

CREATE PROCEDURE dbo.CalculatePerformanceScore
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BlockingCount INT = 0;
    DECLARE @LongRunningCount INT = 0;
    DECLARE @HighCPUCount INT = 0;
    DECLARE @FailedJobCount INT = 0;
    DECLARE @FinalScore INT = 100;
    DECLARE @Recommendation NVARCHAR(500);

    SELECT @BlockingCount = COUNT(*)
    FROM dbo.HealthCheckLog
    WHERE IssueType = 'Blocking'
      AND CaptureTime >= DATEADD(MINUTE, -15, GETDATE());

    SELECT @LongRunningCount = COUNT(*)
    FROM dbo.HealthCheckLog
    WHERE IssueType = 'LongRunningQuery'
      AND CaptureTime >= DATEADD(MINUTE, -15, GETDATE());

    SELECT @HighCPUCount = COUNT(*)
    FROM dbo.HealthCheckLog
    WHERE IssueType = 'HighCPU'
      AND CaptureTime >= DATEADD(MINUTE, -15, GETDATE());

    SELECT @FailedJobCount = COUNT(*)
    FROM dbo.HealthCheckLog
    WHERE IssueType = 'JobFailure'
      AND CaptureTime >= DATEADD(MINUTE, -15, GETDATE());

    -- Deduction rules
    SET @FinalScore = @FinalScore - (@BlockingCount * 10);
    SET @FinalScore = @FinalScore - (@LongRunningCount * 8);
    SET @FinalScore = @FinalScore - (@HighCPUCount * 7);
    SET @FinalScore = @FinalScore - (@FailedJobCount * 12);

    IF @FinalScore < 0
        SET @FinalScore = 0;

    SET @Recommendation =
        CASE
            WHEN @FinalScore >= 90 THEN 'Healthy system. Continue regular monitoring.'
            WHEN @FinalScore >= 75 THEN 'Moderate issues detected. Review blocking and query performance.'
            WHEN @FinalScore >= 50 THEN 'Performance degradation detected. Investigate immediately.'
            ELSE 'Critical health score. Urgent action required.'
        END;

    INSERT INTO dbo.PerformanceScoreLog
    (
        BlockingCount,
        LongRunningCount,
        HighCPUCount,
        FailedJobCount,
        FinalScore,
        Recommendation
    )
    VALUES
    (
        @BlockingCount,
        @LongRunningCount,
        @HighCPUCount,
        @FailedJobCount,
        @FinalScore,
        @Recommendation
    );
END;
GO
