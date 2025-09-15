-- Learning Management System Database Setup Script
-- Run this script in SQL Server Management Studio

-- Create Database
IF NOT EXISTS(SELECT name FROM sys.databases WHERE name = 'LearningManagementSystem')
BEGIN
    CREATE DATABASE LearningManagementSystem;
END
GO

USE LearningManagementSystem;
GO

-- Create Users Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
BEGIN
    CREATE TABLE Users (
        UserId INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(255) UNIQUE NOT NULL,
        Password NVARCHAR(255) NOT NULL,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Admin', 'Teacher', 'Student')),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        LastLoginDate DATETIME NULL
    );
    
    PRINT 'Users table created successfully';
END
GO

-- Create Admins Table (for backwards compatibility)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Admins' AND xtype='U')
BEGIN
    CREATE TABLE Admins (
        AdminId INT IDENTITY(1,1) PRIMARY KEY,
        Email NVARCHAR(255) UNIQUE NOT NULL,
        Password NVARCHAR(255) NOT NULL,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        LastLoginDate DATETIME NULL
    );
    
    PRINT 'Admins table created successfully';
END
GO

-- Create Courses Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
BEGIN
    CREATE TABLE Courses (
        CourseId INT IDENTITY(1,1) PRIMARY KEY,
        CourseCode NVARCHAR(20) UNIQUE NOT NULL,
        CourseName NVARCHAR(255) NOT NULL,
        Description NTEXT,
        Credits INT NOT NULL,
        TeacherId INT,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (TeacherId) REFERENCES Users(UserId)
    );
    
    PRINT 'Courses table created successfully';
END
GO

-- Create Enrollments Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Enrollments' AND xtype='U')
BEGIN
    CREATE TABLE Enrollments (
        EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
        StudentId INT NOT NULL,
        CourseId INT NOT NULL,
        EnrollmentDate DATETIME DEFAULT GETDATE(),
        Grade NVARCHAR(5) NULL,
        Status NVARCHAR(20) DEFAULT 'Active',
        FOREIGN KEY (StudentId) REFERENCES Users(UserId),
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
        UNIQUE(StudentId, CourseId)
    );
    
    PRINT 'Enrollments table created successfully';
END
GO

-- Create Assignments Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Assignments' AND xtype='U')
BEGIN
    CREATE TABLE Assignments (
        AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
        CourseId INT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Description NTEXT,
        DueDate DATETIME,
        MaxPoints INT DEFAULT 100,
        CreatedDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
    );
    
    PRINT 'Assignments table created successfully';
END
GO

-- Create LoginActivity Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='LoginActivity' AND xtype='U')
BEGIN
    CREATE TABLE LoginActivity (
        LogId INT IDENTITY(1,1) PRIMARY KEY,
        UserId INT NULL,
        Email NVARCHAR(255) NOT NULL,
        LoginAttempt DATETIME DEFAULT GETDATE(),
        IsSuccessful BIT NOT NULL,
        IPAddress NVARCHAR(45),
        UserAgent NVARCHAR(500),
        FOREIGN KEY (UserId) REFERENCES Users(UserId)
    );
    
    PRINT 'LoginActivity table created successfully';
END
GO

-- Insert Sample Data
-- Insert Admin User
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'admin@lms.edu')
BEGIN
    INSERT INTO Users (Email, Password, FirstName, LastName, Role, IsActive)
    VALUES ('admin@lms.edu', 'admin123', 'System', 'Administrator', 'Admin', 1);
    
    PRINT 'Admin user created: admin@lms.edu / admin123';
END
GO

-- Insert Admin in Admins table too (for backwards compatibility)
IF NOT EXISTS (SELECT 1 FROM Admins WHERE Email = 'admin@lms.edu')
BEGIN
    INSERT INTO Admins (Email, Password, FirstName, LastName, IsActive)
    VALUES ('admin@lms.edu', 'admin123', 'System', 'Administrator', 1);
    
    PRINT 'Admin user created in Admins table: admin@lms.edu / admin123';
END
GO

-- Insert Sample Teacher
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'teacher@lms.edu')
BEGIN
    INSERT INTO Users (Email, Password, FirstName, LastName, Role, IsActive)
    VALUES ('teacher@lms.edu', 'teacher123', 'John', 'Smith', 'Teacher', 1);
    
    PRINT 'Teacher user created: teacher@lms.edu / teacher123';
END
GO

-- Insert Sample Student
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'student@lms.edu')
BEGIN
    INSERT INTO Users (Email, Password, FirstName, LastName, Role, IsActive)
    VALUES ('student@lms.edu', 'student123', 'Jane', 'Doe', 'Student', 1);
    
    PRINT 'Student user created: student@lms.edu / student123';
END
GO

-- Insert Sample Course
DECLARE @TeacherId INT = (SELECT UserId FROM Users WHERE Email = 'teacher@lms.edu');

IF NOT EXISTS (SELECT 1 FROM Courses WHERE CourseCode = 'CS101')
BEGIN
    INSERT INTO Courses (CourseCode, CourseName, Description, Credits, TeacherId, IsActive)
    VALUES ('CS101', 'Introduction to Computer Science', 'Basic concepts of computer science and programming', 3, @TeacherId, 1);
    
    PRINT 'Sample course created: CS101';
END
GO

-- Enroll Student in Course
DECLARE @StudentId INT = (SELECT UserId FROM Users WHERE Email = 'student@lms.edu');
DECLARE @CourseId INT = (SELECT CourseId FROM Courses WHERE CourseCode = 'CS101');

IF NOT EXISTS (SELECT 1 FROM Enrollments WHERE StudentId = @StudentId AND CourseId = @CourseId)
BEGIN
    INSERT INTO Enrollments (StudentId, CourseId, Status)
    VALUES (@StudentId, @CourseId, 'Active');
    
    PRINT 'Student enrolled in CS101';
END
GO

-- Create Sample Assignment
IF NOT EXISTS (SELECT 1 FROM Assignments WHERE Title = 'First Programming Assignment')
BEGIN
    DECLARE @CourseId INT = (SELECT CourseId FROM Courses WHERE CourseCode = 'CS101');
    
    INSERT INTO Assignments (CourseId, Title, Description, DueDate, MaxPoints)
    VALUES (@CourseId, 'First Programming Assignment', 'Write a simple Hello World program', DATEADD(day, 7, GETDATE()), 100);
    
    PRINT 'Sample assignment created';
END
GO

PRINT 'Database setup completed successfully!';
PRINT 'You can now login with:';
PRINT '  Admin: admin@lms.edu / admin123';
PRINT '  Teacher: teacher@lms.edu / teacher123';
PRINT '  Student: student@lms.edu / student123';
