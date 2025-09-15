-- =====================================================================
-- Learning Management System Database
-- Comprehensive Database Schema for LMS Features
-- Database Server: N3THUNT3R-SOCIA
-- Created based on Admin frontend analysis
-- =====================================================================

USE [master]
GO

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'LearningManagementSystem')
BEGIN
    CREATE DATABASE [LearningManagementSystem]
    ON 
    ( NAME = 'LearningManagementSystem', 
      FILENAME = 'C:\Database\LearningManagementSystem.mdf' )
    LOG ON 
    ( NAME = 'LearningManagementSystem_Log', 
      FILENAME = 'C:\Database\LearningManagementSystem_Log.ldf' )
END
GO

USE [LearningManagementSystem]
GO

-- =====================================================================
-- 1. CORE USERS AND AUTHENTICATION TABLES
-- =====================================================================

-- Admins table (for admin authentication)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Admins' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Admins] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL UNIQUE,
        [Email] NVARCHAR(100) NOT NULL UNIQUE,
        [Password] NVARCHAR(100) NOT NULL,
        [FullName] NVARCHAR(100) NOT NULL,
        [Phone] NVARCHAR(20),
        [ProfilePicture] NVARCHAR(255),
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [LastLoginDate] DATETIME,
        [CreatedBy] INT,
        [UpdatedDate] DATETIME,
        [UpdatedBy] INT
    )
END
GO

-- Users table (for students and teachers)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Users] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserType] NVARCHAR(20) NOT NULL CHECK ([UserType] IN ('Student', 'Teacher')),
        [Username] NVARCHAR(50) NOT NULL UNIQUE,
        [Email] NVARCHAR(100) NOT NULL UNIQUE,
        [Password] NVARCHAR(100) NOT NULL,
        [FullName] NVARCHAR(100) NOT NULL,
        [Phone] NVARCHAR(20),
        [ProfilePicture] NVARCHAR(255),
        [Department] NVARCHAR(100),
        [Programme] NVARCHAR(100),
        [Level] INT, -- For students (100, 200, 300, 400)
        [EmployeeId] NVARCHAR(50), -- For teachers
        [IsActive] BIT DEFAULT 1,
        [EnrollmentDate] DATETIME DEFAULT GETDATE(),
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [UpdatedDate] DATETIME,
        [UpdatedBy] INT
    )
END
GO

-- =====================================================================
-- 2. COURSES AND CURRICULUM MANAGEMENT
-- =====================================================================

-- Courses table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Courses] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseCode] NVARCHAR(20) NOT NULL UNIQUE,
        [CourseName] NVARCHAR(200) NOT NULL,
        [Description] NTEXT,
        [Department] NVARCHAR(100) NOT NULL,
        [CreditHours] INT DEFAULT 3,
        [Level] INT, -- Course level (100, 200, 300, 400)
        [Semester] NVARCHAR(20), -- Fall, Spring, Summer
        [AcademicYear] NVARCHAR(10), -- 2023/2024
        [InstructorId] INT, -- Foreign key to Users (Teacher)
        [MaxEnrollment] INT DEFAULT 50,
        [CurrentEnrollment] INT DEFAULT 0,
        [Status] NVARCHAR(20) DEFAULT 'Active' CHECK ([Status] IN ('Active', 'Inactive', 'Draft')),
        [StartDate] DATETIME,
        [EndDate] DATETIME,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [UpdatedDate] DATETIME,
        [UpdatedBy] INT,
        FOREIGN KEY ([InstructorId]) REFERENCES [Users]([Id])
    )
END
GO

-- Course Sections table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CourseSections' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[CourseSections] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseId] INT NOT NULL,
        [SectionName] NVARCHAR(100) NOT NULL,
        [Description] NTEXT,
        [OrderIndex] INT DEFAULT 0,
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id])
    )
END
GO

-- Student Course Enrollments
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Enrollments' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Enrollments] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [StudentId] INT NOT NULL,
        [CourseId] INT NOT NULL,
        [EnrollmentDate] DATETIME DEFAULT GETDATE(),
        [Status] NVARCHAR(20) DEFAULT 'Active' CHECK ([Status] IN ('Active', 'Dropped', 'Completed')),
        [FinalGrade] NVARCHAR(10),
        [GPA] DECIMAL(3,2),
        [CompletionDate] DATETIME,
        [CreatedBy] INT,
        FOREIGN KEY ([StudentId]) REFERENCES [Users]([Id]),
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id]),
        UNIQUE ([StudentId], [CourseId])
    )
END
GO

-- =====================================================================
-- 3. QUIZ AND ASSESSMENT SYSTEM
-- =====================================================================

-- Quizzes table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Quizzes' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Quizzes] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseId] INT NOT NULL,
        [SectionId] INT,
        [QuizTitle] NVARCHAR(200) NOT NULL,
        [Description] NTEXT,
        [Instructions] NTEXT,
        [TimeLimit] INT, -- in minutes
        [TotalMarks] INT DEFAULT 100,
        [PassingMarks] INT DEFAULT 50,
        [MaxAttempts] INT DEFAULT 1,
        [StartDate] DATETIME,
        [EndDate] DATETIME,
        [IsRandomize] BIT DEFAULT 0,
        [ShowResults] BIT DEFAULT 1,
        [ShowCorrectAnswers] BIT DEFAULT 0,
        [Status] NVARCHAR(20) DEFAULT 'Draft' CHECK ([Status] IN ('Draft', 'Published', 'Closed')),
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [UpdatedDate] DATETIME,
        [UpdatedBy] INT,
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id]),
        FOREIGN KEY ([SectionId]) REFERENCES [CourseSections]([Id])
    )
END
GO

-- Quiz Questions table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='QuizQuestions' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[QuizQuestions] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [QuizId] INT NOT NULL,
        [QuestionText] NTEXT NOT NULL,
        [QuestionType] NVARCHAR(20) DEFAULT 'MultipleChoice' CHECK ([QuestionType] IN ('MultipleChoice', 'TrueFalse', 'ShortAnswer', 'Essay')),
        [OptionA] NTEXT,
        [OptionB] NTEXT,
        [OptionC] NTEXT,
        [OptionD] NTEXT,
        [CorrectAnswer] NVARCHAR(10), -- A, B, C, D, or text for other types
        [Marks] INT DEFAULT 1,
        [OrderIndex] INT DEFAULT 0,
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        FOREIGN KEY ([QuizId]) REFERENCES [Quizzes]([Id])
    )
END
GO

-- Quiz Attempts table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='QuizAttempts' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[QuizAttempts] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [QuizId] INT NOT NULL,
        [StudentId] INT NOT NULL,
        [AttemptNumber] INT DEFAULT 1,
        [StartTime] DATETIME DEFAULT GETDATE(),
        [EndTime] DATETIME,
        [TotalMarks] INT,
        [ObtainedMarks] INT DEFAULT 0,
        [Percentage] DECIMAL(5,2),
        [Status] NVARCHAR(20) DEFAULT 'InProgress' CHECK ([Status] IN ('InProgress', 'Completed', 'TimeOut', 'Submitted')),
        [SubmittedDate] DATETIME,
        [TimeTaken] INT, -- in minutes
        [IsPassed] BIT DEFAULT 0,
        [Feedback] NTEXT,
        FOREIGN KEY ([QuizId]) REFERENCES [Quizzes]([Id]),
        FOREIGN KEY ([StudentId]) REFERENCES [Users]([Id])
    )
END
GO

-- Quiz Answers table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='QuizAnswers' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[QuizAnswers] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [AttemptId] INT NOT NULL,
        [QuestionId] INT NOT NULL,
        [SelectedAnswer] NTEXT,
        [IsCorrect] BIT DEFAULT 0,
        [MarksObtained] INT DEFAULT 0,
        [AnsweredAt] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY ([AttemptId]) REFERENCES [QuizAttempts]([Id]),
        FOREIGN KEY ([QuestionId]) REFERENCES [QuizQuestions]([Id])
    )
END
GO

-- =====================================================================
-- 4. MATERIALS AND RESOURCES
-- =====================================================================

-- Course Materials table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='CourseMaterials' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[CourseMaterials] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseId] INT NOT NULL,
        [SectionId] INT,
        [MaterialType] NVARCHAR(20) DEFAULT 'Document' CHECK ([MaterialType] IN ('Document', 'Video', 'Audio', 'Image', 'Link', 'PDF')),
        [Title] NVARCHAR(200) NOT NULL,
        [Description] NTEXT,
        [FileName] NVARCHAR(255),
        [FilePath] NVARCHAR(500),
        [FileSize] BIGINT, -- in bytes
        [ExternalLink] NVARCHAR(500),
        [OrderIndex] INT DEFAULT 0,
        [IsRequired] BIT DEFAULT 0,
        [IsActive] BIT DEFAULT 1,
        [UploadedDate] DATETIME DEFAULT GETDATE(),
        [UploadedBy] INT,
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id]),
        FOREIGN KEY ([SectionId]) REFERENCES [CourseSections]([Id]),
        FOREIGN KEY ([UploadedBy]) REFERENCES [Users]([Id])
    )
END
GO

-- =====================================================================
-- 5. ASSIGNMENTS AND SUBMISSIONS
-- =====================================================================

-- Assignments table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Assignments' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Assignments] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [CourseId] INT NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Description] NTEXT,
        [Instructions] NTEXT,
        [TotalMarks] INT DEFAULT 100,
        [DueDate] DATETIME,
        [SubmissionFormat] NVARCHAR(50), -- File, Text, Both
        [MaxFileSize] INT, -- in MB
        [AllowedFileTypes] NVARCHAR(100), -- .pdf,.doc,.docx
        [Status] NVARCHAR(20) DEFAULT 'Active' CHECK ([Status] IN ('Active', 'Closed', 'Draft')),
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [UpdatedDate] DATETIME,
        [UpdatedBy] INT,
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id])
    )
END
GO

-- Assignment Submissions table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AssignmentSubmissions' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AssignmentSubmissions] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [AssignmentId] INT NOT NULL,
        [StudentId] INT NOT NULL,
        [SubmissionText] NTEXT,
        [FileName] NVARCHAR(255),
        [FilePath] NVARCHAR(500),
        [FileSize] BIGINT,
        [SubmissionDate] DATETIME DEFAULT GETDATE(),
        [IsLate] BIT DEFAULT 0,
        [MarksObtained] INT,
        [Grade] NVARCHAR(10),
        [Feedback] NTEXT,
        [Status] NVARCHAR(20) DEFAULT 'Submitted' CHECK ([Status] IN ('Submitted', 'Graded', 'Returned')),
        [GradedDate] DATETIME,
        [GradedBy] INT,
        FOREIGN KEY ([AssignmentId]) REFERENCES [Assignments]([Id]),
        FOREIGN KEY ([StudentId]) REFERENCES [Users]([Id]),
        FOREIGN KEY ([GradedBy]) REFERENCES [Users]([Id])
    )
END
GO

-- =====================================================================
-- 6. ANALYTICS AND REPORTING
-- =====================================================================

-- User Analytics table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserAnalytics' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[UserAnalytics] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserId] INT NOT NULL,
        [ActivityType] NVARCHAR(50) NOT NULL, -- Login, CourseAccess, QuizAttempt, MaterialDownload
        [ActivityDetails] NTEXT,
        [CourseId] INT,
        [SessionDuration] INT, -- in minutes
        [IPAddress] NVARCHAR(45),
        [UserAgent] NVARCHAR(500),
        [ActivityDate] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY ([UserId]) REFERENCES [Users]([Id]),
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id])
    )
END
GO

-- System Analytics table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemAnalytics' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[SystemAnalytics] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [MetricType] NVARCHAR(50) NOT NULL, -- DailyLogins, CourseEnrollments, QuizCompletions
        [MetricValue] INT NOT NULL,
        [MetricDate] DATE NOT NULL,
        [AdditionalData] NTEXT, -- JSON format for extra details
        [CreatedDate] DATETIME DEFAULT GETDATE()
    )
END
GO

-- =====================================================================
-- 7. NOTIFICATIONS AND MESSAGING
-- =====================================================================

-- Notifications table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Notifications] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserId] INT NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Message] NTEXT NOT NULL,
        [NotificationType] NVARCHAR(50) DEFAULT 'Info' CHECK ([NotificationType] IN ('Info', 'Warning', 'Success', 'Error', 'Assignment', 'Quiz', 'Grade')),
        [IsRead] BIT DEFAULT 0,
        [Priority] NVARCHAR(20) DEFAULT 'Normal' CHECK ([Priority] IN ('Low', 'Normal', 'High', 'Urgent')),
        [ExpiryDate] DATETIME,
        [RelatedId] INT, -- Related course, assignment, or quiz ID
        [RelatedType] NVARCHAR(50), -- Course, Assignment, Quiz
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [ReadDate] DATETIME,
        FOREIGN KEY ([UserId]) REFERENCES [Users]([Id])
    )
END
GO

-- =====================================================================
-- 8. SETTINGS AND CONFIGURATION
-- =====================================================================

-- System Settings table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SystemSettings' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[SystemSettings] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [SettingKey] NVARCHAR(100) NOT NULL UNIQUE,
        [SettingValue] NTEXT,
        [SettingType] NVARCHAR(20) DEFAULT 'String' CHECK ([SettingType] IN ('String', 'Integer', 'Boolean', 'JSON')),
        [Description] NVARCHAR(500),
        [Category] NVARCHAR(50), -- System, Email, Security, etc.
        [IsReadOnly] BIT DEFAULT 0,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [UpdatedDate] DATETIME,
        [UpdatedBy] INT
    )
END
GO

-- =====================================================================
-- 9. REPORTS AND GRADES
-- =====================================================================

-- Grade Reports table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GradeReports' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[GradeReports] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [StudentId] INT NOT NULL,
        [CourseId] INT NOT NULL,
        [Semester] NVARCHAR(20) NOT NULL,
        [AcademicYear] NVARCHAR(10) NOT NULL,
        [QuizTotal] DECIMAL(5,2) DEFAULT 0,
        [AssignmentTotal] DECIMAL(5,2) DEFAULT 0,
        [ParticipationTotal] DECIMAL(5,2) DEFAULT 0,
        [FinalExamTotal] DECIMAL(5,2) DEFAULT 0,
        [OverallGrade] NVARCHAR(10),
        [GPA] DECIMAL(3,2),
        [Status] NVARCHAR(20) DEFAULT 'InProgress' CHECK ([Status] IN ('InProgress', 'Completed', 'Failed')),
        [GeneratedDate] DATETIME DEFAULT GETDATE(),
        [GeneratedBy] INT,
        FOREIGN KEY ([StudentId]) REFERENCES [Users]([Id]),
        FOREIGN KEY ([CourseId]) REFERENCES [Courses]([Id])
    )
END
GO

-- =====================================================================
-- 10. ACTIVITY TRACKING
-- =====================================================================

-- Recent Activities table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RecentActivities' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[RecentActivities] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [UserId] INT NOT NULL,
        [ActivityType] NVARCHAR(50) NOT NULL,
        [ActivityDescription] NVARCHAR(500) NOT NULL,
        [RelatedEntityType] NVARCHAR(50), -- Course, Quiz, Assignment, User
        [RelatedEntityId] INT,
        [ActivityDate] DATETIME DEFAULT GETDATE(),
        [IPAddress] NVARCHAR(45),
        [IsSystemActivity] BIT DEFAULT 0,
        FOREIGN KEY ([UserId]) REFERENCES [Users]([Id])
    )
END
GO

-- =====================================================================
-- 11. INSERT SAMPLE DATA
-- =====================================================================

-- Insert sample admin
IF NOT EXISTS (SELECT * FROM Admins WHERE Username = 'admin')
BEGIN
    INSERT INTO [Admins] ([Username], [Email], [Password], [FullName], [Phone], [IsActive])
    VALUES ('admin', 'admin@lms.edu', 'admin123', 'System Administrator', '+233501234567', 1)
END
GO

-- Insert sample departments and programs data
IF NOT EXISTS (SELECT * FROM SystemSettings WHERE SettingKey = 'DEPARTMENTS')
BEGIN
    INSERT INTO [SystemSettings] ([SettingKey], [SettingValue], [SettingType], [Description], [Category])
    VALUES 
    ('DEPARTMENTS', '["Computer Science","Mathematics","English","Science","Business","Education"]', 'JSON', 'Available departments', 'Academic'),
    ('PROGRAMMES', '["Computer Science","Information Technology","Mathematics","Education","Business Administration"]', 'JSON', 'Available programmes', 'Academic'),
    ('SEMESTER_CURRENT', 'Fall 2024', 'String', 'Current semester', 'Academic'),
    ('ACADEMIC_YEAR_CURRENT', '2024/2025', 'String', 'Current academic year', 'Academic'),
    ('SYSTEM_NAME', 'Learning Management System', 'String', 'System name', 'System'),
    ('SYSTEM_VERSION', '1.0.0', 'String', 'System version', 'System')
END
GO

-- Insert sample users (Students and Teachers)
IF NOT EXISTS (SELECT * FROM Users WHERE Email = 'student1@lms.edu')
BEGIN
    INSERT INTO [Users] ([UserType], [Username], [Email], [Password], [FullName], [Phone], [Department], [Programme], [Level], [IsActive])
    VALUES 
    ('Student', 'student1', 'student1@lms.edu', 'student123', 'John Doe', '+233502345678', 'Computer Science', 'Computer Science', 300, 1),
    ('Student', 'student2', 'student2@lms.edu', 'student123', 'Jane Smith', '+233503456789', 'Mathematics', 'Mathematics', 200, 1),
    ('Student', 'student3', 'student3@lms.edu', 'student123', 'Alice Johnson', '+233504567890', 'Computer Science', 'Information Technology', 400, 1),
    ('Teacher', 'teacher1', 'teacher1@lms.edu', 'teacher123', 'Dr. Robert Wilson', '+233505678901', 'Computer Science', NULL, NULL, 1),
    ('Teacher', 'teacher2', 'teacher2@lms.edu', 'teacher123', 'Prof. Sarah Davis', '+233506789012', 'Mathematics', NULL, NULL, 1)
END
GO

-- Insert sample courses
IF NOT EXISTS (SELECT * FROM Courses WHERE CourseCode = 'CS101')
BEGIN
    INSERT INTO [Courses] ([CourseCode], [CourseName], [Description], [Department], [CreditHours], [Level], [Semester], [AcademicYear], [InstructorId], [Status])
    VALUES 
    ('CS101', 'Introduction to Computer Science', 'Basic concepts of computer science and programming', 'Computer Science', 3, 100, 'Fall', '2024/2025', 4, 'Active'),
    ('MATH201', 'Calculus II', 'Advanced calculus concepts and applications', 'Mathematics', 4, 200, 'Fall', '2024/2025', 5, 'Active'),
    ('CS301', 'Data Structures and Algorithms', 'Advanced data structures and algorithmic design', 'Computer Science', 3, 300, 'Fall', '2024/2025', 4, 'Active')
END
GO

-- Insert sample course sections
IF NOT EXISTS (SELECT * FROM CourseSections WHERE CourseId = 1)
BEGIN
    INSERT INTO [CourseSections] ([CourseId], [SectionName], [Description], [OrderIndex])
    VALUES 
    (1, 'Introduction to Programming', 'Basic programming concepts', 1),
    (1, 'Variables and Data Types', 'Understanding variables and data types', 2),
    (1, 'Control Structures', 'Loops and conditional statements', 3),
    (2, 'Limits and Continuity', 'Mathematical limits and continuity', 1),
    (2, 'Derivatives', 'Derivative calculations and applications', 2),
    (3, 'Arrays and Linked Lists', 'Basic data structures', 1),
    (3, 'Sorting Algorithms', 'Various sorting techniques', 2)
END
GO

-- Insert sample enrollments
IF NOT EXISTS (SELECT * FROM Enrollments WHERE StudentId = 1)
BEGIN
    INSERT INTO [Enrollments] ([StudentId], [CourseId], [Status])
    VALUES 
    (1, 1, 'Active'), -- John Doe enrolled in CS101
    (1, 3, 'Active'), -- John Doe enrolled in CS301
    (2, 2, 'Active'), -- Jane Smith enrolled in MATH201
    (3, 1, 'Active'), -- Alice Johnson enrolled in CS101
    (3, 3, 'Active')  -- Alice Johnson enrolled in CS301
END
GO

-- Insert sample quizzes
IF NOT EXISTS (SELECT * FROM Quizzes WHERE QuizTitle = 'Programming Basics Quiz')
BEGIN
    INSERT INTO [Quizzes] ([CourseId], [SectionId], [QuizTitle], [Description], [TimeLimit], [TotalMarks], [PassingMarks], [Status], [CreatedBy])
    VALUES 
    (1, 1, 'Programming Basics Quiz', 'Test your understanding of basic programming concepts', 30, 20, 12, 'Published', 4),
    (1, 2, 'Variables Quiz', 'Quiz on variables and data types', 20, 15, 9, 'Published', 4),
    (2, 1, 'Limits Quiz', 'Understanding mathematical limits', 45, 25, 15, 'Published', 5),
    (3, 1, 'Data Structures Quiz', 'Basic data structures assessment', 40, 30, 18, 'Published', 4)
END
GO

-- Insert sample quiz questions
IF NOT EXISTS (SELECT * FROM QuizQuestions WHERE QuizId = 1)
BEGIN
    INSERT INTO [QuizQuestions] ([QuizId], [QuestionText], [QuestionType], [OptionA], [OptionB], [OptionC], [OptionD], [CorrectAnswer], [Marks], [OrderIndex])
    VALUES 
    (1, 'What is a variable in programming?', 'MultipleChoice', 'A container for storing data', 'A type of loop', 'A function', 'A class', 'A', 2, 1),
    (1, 'Which of the following is a programming language?', 'MultipleChoice', 'HTML', 'Python', 'CSS', 'SQL', 'B', 2, 2),
    (1, 'Programming is only about writing code.', 'TrueFalse', 'True', 'False', NULL, NULL, 'B', 1, 3),
    (2, 'What keyword is used to declare a variable in C#?', 'MultipleChoice', 'var', 'int', 'string', 'All of the above', 'D', 3, 1),
    (3, 'What is the limit of f(x) = 2x as x approaches 3?', 'MultipleChoice', '6', '5', '2', '3', 'A', 5, 1),
    (4, 'What is the time complexity of linear search?', 'MultipleChoice', 'O(1)', 'O(n)', 'O(log n)', 'O(n²)', 'B', 5, 1)
END
GO

-- Insert sample recent activities
IF NOT EXISTS (SELECT * FROM RecentActivities WHERE UserId = 1)
BEGIN
    INSERT INTO [RecentActivities] ([UserId], [ActivityType], [ActivityDescription], [RelatedEntityType], [RelatedEntityId])
    VALUES 
    (1, 'LOGIN', 'Student logged into the system', 'System', NULL),
    (1, 'COURSE_ACCESS', 'Accessed CS101 course materials', 'Course', 1),
    (1, 'QUIZ_ATTEMPT', 'Started Programming Basics Quiz', 'Quiz', 1),
    (4, 'LOGIN', 'Teacher logged into the system', 'System', NULL),
    (4, 'QUIZ_CREATE', 'Created new quiz for CS101', 'Quiz', 1),
    (2, 'ENROLLMENT', 'Enrolled in MATH201 course', 'Course', 2)
END
GO

-- Insert sample notifications
IF NOT EXISTS (SELECT * FROM Notifications WHERE UserId = 1)
BEGIN
    INSERT INTO [Notifications] ([UserId], [Title], [Message], [NotificationType], [Priority], [RelatedId], [RelatedType])
    VALUES 
    (1, 'Welcome to LMS', 'Welcome to the Learning Management System! Start exploring your courses.', 'Info', 'Normal', NULL, NULL),
    (1, 'New Quiz Available', 'A new quiz "Programming Basics Quiz" is now available in CS101.', 'Quiz', 'High', 1, 'Quiz'),
    (1, 'Assignment Due Soon', 'Your CS101 assignment is due in 3 days.', 'Assignment', 'High', 1, 'Course'),
    (2, 'Grade Posted', 'Your grade for MATH201 quiz has been posted.', 'Grade', 'Normal', 3, 'Quiz')
END
GO

-- =====================================================================
-- 12. CREATE INDEXES FOR PERFORMANCE
-- =====================================================================

-- Indexes on frequently queried columns
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Users_Email')
    CREATE INDEX IX_Users_Email ON Users(Email)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Users_UserType')
    CREATE INDEX IX_Users_UserType ON Users(UserType)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Courses_Department')
    CREATE INDEX IX_Courses_Department ON Courses(Department)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Enrollments_StudentCourse')
    CREATE INDEX IX_Enrollments_StudentCourse ON Enrollments(StudentId, CourseId)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_QuizAttempts_QuizStudent')
    CREATE INDEX IX_QuizAttempts_QuizStudent ON QuizAttempts(QuizId, StudentId)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_UserAnalytics_Date')
    CREATE INDEX IX_UserAnalytics_Date ON UserAnalytics(ActivityDate)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Notifications_User')
    CREATE INDEX IX_Notifications_User ON Notifications(UserId, IsRead)
GO

-- =====================================================================
-- 13. CREATE VIEWS FOR COMMON QUERIES
-- =====================================================================

-- View for course statistics
IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_CourseStatistics')
BEGIN
    EXEC('CREATE VIEW vw_CourseStatistics AS
    SELECT 
        c.Id,
        c.CourseCode,
        c.CourseName,
        c.Department,
        c.InstructorId,
        u.FullName AS InstructorName,
        COUNT(DISTINCT e.StudentId) AS EnrolledStudents,
        COUNT(DISTINCT q.Id) AS TotalQuizzes,
        COUNT(DISTINCT a.Id) AS TotalAssignments,
        c.Status
    FROM Courses c
    LEFT JOIN Users u ON c.InstructorId = u.Id
    LEFT JOIN Enrollments e ON c.Id = e.CourseId AND e.Status = ''Active''
    LEFT JOIN Quizzes q ON c.Id = q.CourseId
    LEFT JOIN Assignments a ON c.Id = a.CourseId
    GROUP BY c.Id, c.CourseCode, c.CourseName, c.Department, c.InstructorId, u.FullName, c.Status')
END
GO

-- View for student progress
IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_StudentProgress')
BEGIN
    EXEC('CREATE VIEW vw_StudentProgress AS
    SELECT 
        s.Id AS StudentId,
        s.FullName AS StudentName,
        s.Email,
        c.Id AS CourseId,
        c.CourseCode,
        c.CourseName,
        e.EnrollmentDate,
        COUNT(DISTINCT qa.Id) AS QuizzesAttempted,
        AVG(CAST(qa.Percentage AS FLOAT)) AS AverageQuizScore,
        COUNT(DISTINCT sub.Id) AS AssignmentsSubmitted
    FROM Users s
    INNER JOIN Enrollments e ON s.Id = e.StudentId
    INNER JOIN Courses c ON e.CourseId = c.Id
    LEFT JOIN QuizAttempts qa ON s.Id = qa.StudentId AND qa.Status = ''Completed''
    LEFT JOIN Quizzes q ON qa.QuizId = q.Id AND q.CourseId = c.Id
    LEFT JOIN AssignmentSubmissions sub ON s.Id = sub.StudentId
    LEFT JOIN Assignments a ON sub.AssignmentId = a.Id AND a.CourseId = c.Id
    WHERE s.UserType = ''Student'' AND e.Status = ''Active''
    GROUP BY s.Id, s.FullName, s.Email, c.Id, c.CourseCode, c.CourseName, e.EnrollmentDate')
END
GO

-- =====================================================================
-- 14. STORED PROCEDURES FOR COMMON OPERATIONS
-- =====================================================================

-- Procedure to get dashboard statistics
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetDashboardStats')
    DROP PROCEDURE sp_GetDashboardStats
GO
CREATE PROCEDURE sp_GetDashboardStats
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM Users WHERE UserType = 'Student' AND IsActive = 1) AS TotalStudents,
        (SELECT COUNT(*) FROM Users WHERE UserType = 'Teacher' AND IsActive = 1) AS TotalTeachers,
        (SELECT COUNT(*) FROM Users WHERE IsActive = 1) AS TotalUsers,
        (SELECT COUNT(*) FROM Courses WHERE Status = 'Active') AS TotalCourses,
        (SELECT COUNT(*) FROM Quizzes WHERE Status = 'Published') AS TotalQuizzes,
        (SELECT COUNT(*) FROM Enrollments WHERE Status = 'Active') AS TotalEnrollments,
        (SELECT COUNT(*) FROM QuizAttempts 
            WHERE Status = 'Completed' 
            AND CAST(SubmittedDate AS DATE) = CAST(GETDATE() AS DATE)) AS TodayQuizAttempts,
        (SELECT COUNT(*) FROM UserAnalytics 
            WHERE ActivityType = 'LOGIN' 
            AND CAST(ActivityDate AS DATE) = CAST(GETDATE() AS DATE)) AS TodayLogins
END

GO

-- Procedure to get recent activities for dashboard
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetRecentActivities')
    DROP PROCEDURE sp_GetRecentActivities
GO

CREATE PROCEDURE sp_GetRecentActivities
    @Count INT = 10
AS
BEGIN
    SELECT TOP (@Count)
        ra.ActivityDescription,
        ra.ActivityDate,
        u.FullName AS UserName,
        u.UserType,
        ra.ActivityType
    FROM RecentActivities ra
    INNER JOIN Users u ON ra.UserId = u.Id
    ORDER BY ra.ActivityDate DESC
END
GO

-- =====================================================================
-- 15. FINAL VERIFICATION
-- =====================================================================

PRINT 'Database creation completed successfully!'
PRINT 'Tables created:'
PRINT '- Admins'
PRINT '- Users (Students & Teachers)'
PRINT '- Courses'
PRINT '- CourseSections'
PRINT '- Enrollments'
PRINT '- Quizzes'
PRINT '- QuizQuestions'
PRINT '- QuizAttempts'
PRINT '- QuizAnswers'
PRINT '- CourseMaterials'
PRINT '- Assignments'
PRINT '- AssignmentSubmissions'
PRINT '- UserAnalytics'
PRINT '- SystemAnalytics'
PRINT '- Notifications'
PRINT '- SystemSettings'
PRINT '- GradeReports'
PRINT '- RecentActivities'
PRINT ''
PRINT 'Sample data inserted:'
PRINT '- 1 Admin user (admin/admin123)'
PRINT '- 5 Users (3 Students, 2 Teachers)'
PRINT '- 3 Courses with sections'
PRINT '- Sample quizzes and questions'
PRINT '- Recent activities and notifications'
PRINT ''
PRINT 'Views and stored procedures created for dashboard functionality'
PRINT ''
PRINT 'Database ready for use with Learning Management System!'

-- Show table counts
SELECT 
    'Admins' AS TableName, COUNT(*) AS RecordCount FROM Admins
UNION ALL
SELECT 'Users', COUNT(*) FROM Users
UNION ALL
SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL
SELECT 'CourseSections', COUNT(*) FROM CourseSections
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM Enrollments
UNION ALL
SELECT 'Quizzes', COUNT(*) FROM Quizzes
UNION ALL
SELECT 'QuizQuestions', COUNT(*) FROM QuizQuestions
UNION ALL
SELECT 'RecentActivities', COUNT(*) FROM RecentActivities
UNION ALL
SELECT 'Notifications', COUNT(*) FROM Notifications
UNION ALL
SELECT 'SystemSettings', COUNT(*) FROM SystemSettings
ORDER BY TableName
