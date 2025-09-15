-- LearningManagementSystem Database Schema

CREATE DATABASE LearningManagementSystem;
GO

USE LearningManagementSystem;
GO

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    UserType NVARCHAR(50) NOT NULL,
    DepartmentID INT,
    LevelID INT,
    ProgrammeID INT,
    EmployeeID INT,
    ProfilePicture varbinary(MAX),
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (LevelID) REFERENCES Level(LevelID),
    FOREIGN KEY (ProgrammeID) REFERENCES Programme(ProgrammeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
);

CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    CourseCode NVARCHAR(20) NOT NULL UNIQUE,
    CourseName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Credits INT NOT NULL,
    DepartmentID INT,
    LevelID INT,
    ProgrammeID INT,
    EmployeeID INT,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',
    StartDate DATETIME NOT NULL DEFAULT GETDATE(),
    EndDate DATETIME,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (LevelID) REFERENCES Level(LevelID),
    FOREIGN KEY (ProgrammeID) REFERENCES Programme(ProgrammeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNumber NVARCHAR(50) NOT NULL,
    EmployeeName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(100),
    HireDate DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1
);

-- Department Table
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

-- Level Table
CREATE TABLE Level (
    LevelID INT IDENTITY(1,1) PRIMARY KEY,
    LevelName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255)
);

-- Programme Table
CREATE TABLE Programme (
    ProgrammeID INT IDENTITY(1,1) PRIMARY KEY,
    ProgrammeName NVARCHAR(100) NOT NULL,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    Description NVARCHAR(255)
);
-- Login Table for user authentication
CREATE TABLE Login (
    LoginID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    LastLogin DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CourseCode NVARCHAR(20) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    EnrolledDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseCode) REFERENCES Courses(CourseCode)
);

CREATE TABLE UserCourses (
    UserCourseID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE AdminNotifications (
    NotificationId INT IDENTITY(1,1) PRIMARY KEY,
    AdminId INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Message NVARCHAR(500) NOT NULL,
    NotificationType NVARCHAR(50),
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    IsRead BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (AdminId) REFERENCES Users(UserID)
);

CREATE TABLE AdminActivityLog (
    ActivityLogId INT IDENTITY(1,1) PRIMARY KEY,
    AdminId INT NOT NULL,
    Activity NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50),
    Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    IPAddress NVARCHAR(50),
    FOREIGN KEY (AdminId) REFERENCES Users(UserID)
);

CREATE TABLE SystemLogs (
    LogId INT IDENTITY(1,1) PRIMARY KEY,
    LogType NVARCHAR(50) NOT NULL,
    Message NVARCHAR(500) NOT NULL,
    Exception NVARCHAR(1000),
    Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    AdminId INT,
    FOREIGN KEY (AdminId) REFERENCES Users(UserID)
);

CREATE TABLE ActivityLogs (
    ActivityLogId INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    Activity NVARCHAR(255) NOT NULL,
    Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    IPAddress NVARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE ErrorLogs (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY,
    ErrorMessage NVARCHAR(500) NOT NULL,
    StackTrace NVARCHAR(2000),
    Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
    UserID INT NOT NULL,
    PageName NVARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table for tracking database backup history
CREATE TABLE BackupHistory (
    BackupId INT IDENTITY(1,1) PRIMARY KEY,
    BackupName NVARCHAR(100) NOT NULL,
    BackupDate DATETIME NOT NULL DEFAULT GETDATE(),
    BackupFilePath NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    CreatedBy INT NOT NULL,
    CompletionDate DATETIME,
    Details NVARCHAR(500),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);
