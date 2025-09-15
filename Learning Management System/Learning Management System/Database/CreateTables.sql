-- Learning Management System Database Creation Script
-- University of Education, Winneba

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'LearningManagementSystem')
BEGIN
    CREATE DATABASE LearningManagementSystem;
END
GO

USE LearningManagementSystem;
GO

-- Users Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
BEGIN
    CREATE TABLE Users (
        UserID int IDENTITY(1,1) PRIMARY KEY,
        FullName nvarchar(255) NOT NULL,
        Email nvarchar(255) UNIQUE NOT NULL,
        Phone nvarchar(20),
        UserType nvarchar(50) NOT NULL, -- 'Student', 'Teacher', 'Admin'
        Department nvarchar(100),
        Level nvarchar(10), -- For students: '100', '200', '300', '400'
        Programme nvarchar(100),
        ProfilePicture nvarchar(500),
        EmployeeID nvarchar(50), -- For teachers/admin
        PasswordHash nvarchar(255),
        IsActive bit DEFAULT 1,
        CreatedDate datetime DEFAULT GETDATE(),
        ModifiedDate datetime,
        LastLoginDate datetime
    );
END
GO

-- Courses Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
BEGIN
    CREATE TABLE Courses (
        CourseID int IDENTITY(1,1) PRIMARY KEY,
        CourseCode nvarchar(20) UNIQUE NOT NULL,
        CourseName nvarchar(255) NOT NULL,
        Description ntext,
        Department nvarchar(100),
        Credits int DEFAULT 3,
        InstructorName nvarchar(255),
        Status nvarchar(20) DEFAULT 'Active', -- 'Active', 'Inactive', 'Draft'
        StartDate datetime,
        EndDate datetime,
        CreatedDate datetime DEFAULT GETDATE(),
        ModifiedDate datetime
    );
END
GO

-- Check if old Courses table exists and needs updating
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courses')
BEGIN
    -- Add new columns if they don't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courses' AND COLUMN_NAME = 'InstructorName')
        ALTER TABLE Courses ADD InstructorName nvarchar(255);
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courses' AND COLUMN_NAME = 'Status')
        ALTER TABLE Courses ADD Status nvarchar(20) DEFAULT 'Active';
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courses' AND COLUMN_NAME = 'StartDate')
        ALTER TABLE Courses ADD StartDate datetime;
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courses' AND COLUMN_NAME = 'EndDate')
        ALTER TABLE Courses ADD EndDate datetime;
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Courses' AND COLUMN_NAME = 'ModifiedDate')
        ALTER TABLE Courses ADD ModifiedDate datetime;
    
    -- Update existing records with default values if needed
    UPDATE Courses SET InstructorName = 'TBD' WHERE InstructorName IS NULL;
    UPDATE Courses SET Status = 'Active' WHERE Status IS NULL;
END
GO

-- Enrollments Table (to track course enrollments separately)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Enrollments' AND xtype='U')
BEGIN
    CREATE TABLE Enrollments (
        EnrollmentID int IDENTITY(1,1) PRIMARY KEY,
        StudentID int NOT NULL,
        CourseCode nvarchar(20) NOT NULL,
        EnrollmentDate datetime DEFAULT GETDATE(),
        Status nvarchar(20) DEFAULT 'Active', -- 'Active', 'Completed', 'Dropped', 'Pending'
        Grade nvarchar(5),
        FOREIGN KEY (StudentID) REFERENCES Users(UserID),
        FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode),
        UNIQUE(StudentID, CourseCode)
    );
END
GO

-- UserCourses Table (Many-to-Many relationship)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserCourses' AND xtype='U')
BEGIN
    CREATE TABLE UserCourses (
        UserCourseID int IDENTITY(1,1) PRIMARY KEY,
        UserID int NOT NULL,
        CourseID int NOT NULL,
        EnrollmentDate datetime DEFAULT GETDATE(),
        Status nvarchar(20) DEFAULT 'Active', -- 'Active', 'Completed', 'Dropped'
        FOREIGN KEY (UserID) REFERENCES Users(UserID),
        FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
        UNIQUE(UserID, CourseID)
    );
END
GO

-- ActivityLogs Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ActivityLogs' AND xtype='U')
BEGIN
    CREATE TABLE ActivityLogs (
        LogID int IDENTITY(1,1) PRIMARY KEY,
        UserID int,
        Activity nvarchar(500) NOT NULL,
        Timestamp datetime DEFAULT GETDATE(),
        IPAddress nvarchar(50),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
    );
END
GO

-- ErrorLogs Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ErrorLogs' AND xtype='U')
BEGIN
    CREATE TABLE ErrorLogs (
        ErrorID int IDENTITY(1,1) PRIMARY KEY,
        ErrorMessage nvarchar(1000) NOT NULL,
        StackTrace ntext,
        Timestamp datetime DEFAULT GETDATE(),
        UserID int,
        PageName nvarchar(255),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
    );
END
GO

-- Notifications Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
BEGIN
    CREATE TABLE Notifications (
        NotificationID int IDENTITY(1,1) PRIMARY KEY,
        UserID int,
        Title nvarchar(255) NOT NULL,
        Message ntext NOT NULL,
        Type nvarchar(50) DEFAULT 'info', -- 'info', 'warning', 'success', 'error'
        IsRead bit DEFAULT 0,
        CreatedDate datetime DEFAULT GETDATE(),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
    );
END
GO

-- Insert sample data

-- Insert admin user
IF NOT EXISTS (SELECT * FROM Users WHERE Email = 'admin@uew.edu.gh')
BEGIN
    INSERT INTO Users (FullName, Email, Phone, UserType, Department, Programme, EmployeeID, PasswordHash)
    VALUES ('System Administrator', 'admin@uew.edu.gh', '+233 20 123 4567', 'Admin', 'IT Department', 'Administration', 'ADMIN001', 'admin123');
END
GO

-- Insert sample departments and courses
IF NOT EXISTS (SELECT * FROM Courses WHERE CourseCode = 'CS101')
BEGIN
    INSERT INTO Courses (CourseCode, CourseName, Description, Department, Credits, InstructorName, Status, StartDate, EndDate)
    VALUES 
    ('CS101', 'Introduction to Computer Science', 'Basic concepts of computer science and programming', 'Computer Science', 3, 'Dr. Kwame Asante', 'Active', '2024-01-15', '2024-05-15'),
    ('MATH201', 'Calculus II', 'Advanced calculus concepts and applications', 'Mathematics', 4, 'Prof. Sarah Johnson', 'Active', '2024-01-15', '2024-05-15'),
    ('ENG101', 'English Composition', 'Academic writing and communication skills', 'English', 3, 'Dr. Mary Williams', 'Active', '2024-01-15', '2024-05-15'),
    ('BUS205', 'Business Ethics', 'Ethical principles in business practices', 'Business', 3, 'Prof. Akosua Darko', 'Active', '2024-01-15', '2024-05-15'),
    ('EDU301', 'Educational Psychology', 'Psychological principles in education', 'Education', 3, 'Dr. Joseph Mensah', 'Active', '2024-02-01', '2024-06-01'),
    ('CS301', 'Data Structures and Algorithms', 'Advanced programming concepts', 'Computer Science', 4, 'Dr. Kwame Asante', 'Active', '2024-02-01', '2024-06-01'),
    ('MATH101', 'Basic Mathematics', 'Fundamental mathematical concepts', 'Mathematics', 3, 'Prof. Sarah Johnson', 'Active', '2024-01-15', '2024-05-15'),
    ('SCI201', 'General Science', 'Introduction to scientific methods', 'Science', 3, 'Dr. Robert Brown', 'Inactive', '2023-09-01', '2023-12-15'),
    ('CS401', 'Software Engineering', 'Software development methodologies', 'Computer Science', 4, 'TBD', 'Draft', NULL, NULL),
    ('BUS301', 'Marketing Principles', 'Fundamentals of marketing', 'Business', 3, 'Prof. Akosua Darko', 'Active', '2024-02-01', '2024-06-01');
END
GO

-- Insert sample users
IF NOT EXISTS (SELECT * FROM Users WHERE Email = 'benedict.osei@uew.edu.gh')
BEGIN
    INSERT INTO Users (FullName, Email, Phone, UserType, Department, Level, Programme, PasswordHash)
    VALUES 
    ('Benedict Amankwa Osei', 'benedict.osei@uew.edu.gh', '+233 54 444 4333', 'Student', 'Computer Science', '300', 'Computer Science', 'student123'),
    ('Dr. Kwame Asante', 'kwame.asante@uew.edu.gh', '+233 50 123 4567', 'Teacher', 'Computer Science', NULL, 'Computer Science', 'teacher123'),
    ('Ama Osei Mensah', 'ama.mensah@uew.edu.gh', '+233 55 987 6543', 'Student', 'Mathematics', '200', 'Mathematics', 'student123'),
    ('Prof. Akosua Darko', 'akosua.darko@uew.edu.gh', '+233 24 456 7890', 'Teacher', 'Business', NULL, 'Business Administration', 'teacher123'),
    ('Kofi Mensah', 'kofi.mensah@uew.edu.gh', '+233 20 345 6789', 'Student', 'Education', '400', 'Education', 'student123'),
    ('Grace Adjei', 'grace.adjei@uew.edu.gh', '+233 26 567 8901', 'Student', 'Computer Science', '200', 'Computer Science', 'student123'),
    ('Samuel Osei', 'samuel.osei@uew.edu.gh', '+233 55 234 5678', 'Student', 'Business', '300', 'Business Administration', 'student123'),
    ('Esther Boateng', 'esther.boateng@uew.edu.gh', '+233 24 345 6789', 'Student', 'Mathematics', '400', 'Mathematics', 'student123');
END
GO

-- Insert sample course enrollments
IF NOT EXISTS (SELECT * FROM Enrollments WHERE StudentID = 2 AND CourseCode = 'CS101')
BEGIN
    -- Enroll Benedict in Computer Science courses
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'CS101', 'Active'
    FROM Users u WHERE u.Email = 'benedict.osei@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'CS301', 'Active'
    FROM Users u WHERE u.Email = 'benedict.osei@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'MATH201', 'Active'
    FROM Users u WHERE u.Email = 'benedict.osei@uew.edu.gh';

    -- Enroll Ama in mathematics courses
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'MATH201', 'Active'
    FROM Users u WHERE u.Email = 'ama.mensah@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'MATH101', 'Active'
    FROM Users u WHERE u.Email = 'ama.mensah@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'ENG101', 'Active'
    FROM Users u WHERE u.Email = 'ama.mensah@uew.edu.gh';

    -- Enroll Kofi in education course
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'EDU301', 'Active'
    FROM Users u WHERE u.Email = 'kofi.mensah@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'ENG101', 'Active'
    FROM Users u WHERE u.Email = 'kofi.mensah@uew.edu.gh';
    
    -- Enroll Grace in CS courses
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'CS101', 'Active'
    FROM Users u WHERE u.Email = 'grace.adjei@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'MATH101', 'Active'
    FROM Users u WHERE u.Email = 'grace.adjei@uew.edu.gh';
    
    -- Enroll Samuel in business courses
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'BUS205', 'Active'
    FROM Users u WHERE u.Email = 'samuel.osei@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'BUS301', 'Active'
    FROM Users u WHERE u.Email = 'samuel.osei@uew.edu.gh';
    
    -- Enroll Esther in math courses
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'MATH201', 'Active'
    FROM Users u WHERE u.Email = 'esther.boateng@uew.edu.gh';
    
    INSERT INTO Enrollments (StudentID, CourseCode, Status)
    SELECT u.UserID, 'MATH101', 'Active'
    FROM Users u WHERE u.Email = 'esther.boateng@uew.edu.gh';
END
GO

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX IX_Users_Email ON Users(Email);
CREATE NONCLUSTERED INDEX IX_Users_UserType ON Users(UserType);
CREATE NONCLUSTERED INDEX IX_Courses_CourseCode ON Courses(CourseCode);
CREATE NONCLUSTERED INDEX IX_Courses_Department ON Courses(Department);
CREATE NONCLUSTERED INDEX IX_Courses_Status ON Courses(Status);
CREATE NONCLUSTERED INDEX IX_Enrollments_StudentID ON Enrollments(StudentID);
CREATE NONCLUSTERED INDEX IX_Enrollments_CourseCode ON Enrollments(CourseCode);
CREATE NONCLUSTERED INDEX IX_Enrollments_Status ON Enrollments(Status);
CREATE NONCLUSTERED INDEX IX_UserCourses_UserID ON UserCourses(UserID);
CREATE NONCLUSTERED INDEX IX_UserCourses_CourseID ON UserCourses(CourseID);
CREATE NONCLUSTERED INDEX IX_ActivityLogs_UserID ON ActivityLogs(UserID);
CREATE NONCLUSTERED INDEX IX_ErrorLogs_Timestamp ON ErrorLogs(Timestamp);

PRINT 'Database schema created successfully!';
PRINT 'Sample data inserted successfully!';
PRINT 'Learning Management System database is ready for use.';
