-- Create ClientErrorLogs table to track client-side JavaScript errors
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ClientErrorLogs')
BEGIN
    CREATE TABLE ClientErrorLogs (
        ErrorId INT IDENTITY(1,1) PRIMARY KEY,
        ErrorMessage NVARCHAR(MAX) NOT NULL,
        ErrorSource NVARCHAR(500),
        LineNumber INT,
        ColumnNumber INT,
        StackTrace NVARCHAR(MAX),
        UserAgent NVARCHAR(500),
        PageUrl NVARCHAR(500),
        AdminId NVARCHAR(128),
        Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
        IsResolved BIT NOT NULL DEFAULT 0,
        ResolvedDate DATETIME NULL,
        ResolvedBy NVARCHAR(128) NULL,
        ResolutionNotes NVARCHAR(MAX) NULL
    );
    
    PRINT 'ClientErrorLogs table created successfully.';
END
ELSE
BEGIN
    PRINT 'ClientErrorLogs table already exists.';
END

-- Create index for faster searches
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ClientErrorLogs_Timestamp' AND object_id = OBJECT_ID('ClientErrorLogs'))
BEGIN
    CREATE INDEX IX_ClientErrorLogs_Timestamp ON ClientErrorLogs(Timestamp);
    PRINT 'Index created on Timestamp column.';
END

-- Create index for AdminId
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ClientErrorLogs_AdminId' AND object_id = OBJECT_ID('ClientErrorLogs'))
BEGIN
    CREATE INDEX IX_ClientErrorLogs_AdminId ON ClientErrorLogs(AdminId);
    PRINT 'Index created on AdminId column.';
END

-- Add a stored procedure to get recent errors
IF NOT EXISTS (SELECT * FROM sys.procedures WHERE name = 'GetRecentClientErrors')
BEGIN
    EXEC('
    CREATE PROCEDURE GetRecentClientErrors
        @Hours INT = 24,
        @MaxResults INT = 100
    AS
    BEGIN
        SET NOCOUNT ON;
        
        SELECT TOP (@MaxResults)
            ErrorId,
            ErrorMessage,
            ErrorSource,
            LineNumber,
            ColumnNumber,
            LEFT(StackTrace, 500) AS StackTraceSummary, -- Truncate for readability
            UserAgent,
            PageUrl,
            AdminId,
            Timestamp,
            IsResolved
        FROM 
            ClientErrorLogs
        WHERE 
            Timestamp > DATEADD(HOUR, -@Hours, GETDATE())
        ORDER BY 
            Timestamp DESC;
    END
    ');
    
    PRINT 'GetRecentClientErrors stored procedure created.';
END
ELSE
BEGIN
    PRINT 'GetRecentClientErrors stored procedure already exists.';
END

-- Add a stored procedure to mark errors as resolved
IF NOT EXISTS (SELECT * FROM sys.procedures WHERE name = 'MarkClientErrorAsResolved')
BEGIN
    EXEC('
    CREATE PROCEDURE MarkClientErrorAsResolved
        @ErrorId INT,
        @AdminId NVARCHAR(128),
        @ResolutionNotes NVARCHAR(MAX) = NULL
    AS
    BEGIN
        SET NOCOUNT ON;
        
        UPDATE ClientErrorLogs
        SET 
            IsResolved = 1,
            ResolvedDate = GETDATE(),
            ResolvedBy = @AdminId,
            ResolutionNotes = @ResolutionNotes
        WHERE 
            ErrorId = @ErrorId;
            
        SELECT @@ROWCOUNT AS AffectedRows;
    END
    ');
    
    PRINT 'MarkClientErrorAsResolved stored procedure created.';
END
ELSE
BEGIN
    PRINT 'MarkClientErrorAsResolved stored procedure already exists.';
END

PRINT 'Client error logging system setup complete.';
