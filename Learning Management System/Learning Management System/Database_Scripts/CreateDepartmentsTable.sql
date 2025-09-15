-- Script to use the existing Department table and ensure it has the necessary data
USE LearningManagementSystem;
GO

-- Department table already exists with columns: [DepartmentID], [DepartmentName], [Description]
-- We need to ensure it has all the departments we need

-- Add additional departments if needed
-- Check if specific departments exist and add them if they don't
DECLARE @departments TABLE (DepartmentName NVARCHAR(100));
INSERT INTO @departments VALUES 
    ('Computer Science'),
    ('Mathematics'),
    ('Education'),
    ('Business');

-- Insert departments that don't already exist
INSERT INTO Department (DepartmentName, Description)
SELECT d.DepartmentName, 'Added by automated script' 
FROM @departments d
WHERE NOT EXISTS (
    SELECT 1 FROM Department WHERE DepartmentName = d.DepartmentName
);

-- Add DepartmentCode column if it doesn't exist (for backward compatibility with our code)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Department') AND name = 'DepartmentCode')
BEGIN
    ALTER TABLE Department ADD DepartmentCode NVARCHAR(50);
    PRINT 'Added DepartmentCode column to Department table';
END
GO

-- Update DepartmentCode values in a separate batch to avoid "invalid column name" error
UPDATE Department 
SET DepartmentCode = LOWER(REPLACE(DepartmentName, ' ', '-'))
WHERE DepartmentCode IS NULL;
GO

-- Add IsActive column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Department') AND name = 'IsActive')
BEGIN
    ALTER TABLE Department ADD IsActive BIT DEFAULT 1;
    PRINT 'Added IsActive column to Department table';
END
GO

-- Set all existing departments to active in a separate batch
UPDATE Department SET IsActive = 1 WHERE IsActive IS NULL;
GO

PRINT 'Department table updated successfully!';
GO

-- Create index for better performance if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Department_DepartmentName' AND object_id = OBJECT_ID('Department'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Department_DepartmentName ON Department(DepartmentName);
    PRINT 'Created index on Department table';
END
GO
