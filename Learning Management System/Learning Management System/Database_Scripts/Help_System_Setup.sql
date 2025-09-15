-- Help System Database Structure for Learning Management System
-- This script creates the tables needed for the Help & Support functionality

USE [LearningManagementSystem]
GO

-- Create Support Tickets Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SupportTickets' AND xtype='U')
CREATE TABLE [dbo].[SupportTickets] (
    [TicketId] [nvarchar](20) NOT NULL,
    [Category] [nvarchar](50) NOT NULL,
    [Priority] [nvarchar](20) NOT NULL, -- 'Low', 'Medium', 'High', 'Critical'
    [Subject] [nvarchar](255) NOT NULL,
    [Description] [nvarchar](max) NOT NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT('Open'), -- 'Open', 'In Progress', 'Waiting', 'Closed'
    [CreatedBy] [nvarchar](50) NOT NULL,
    [AssignedTo] [nvarchar](50) NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
    [ResolvedDate] [datetime] NULL,
    [LastUpdateDate] [datetime] NULL,
    [Resolution] [nvarchar](max) NULL,
    [SatisfactionRating] [int] NULL, -- 1-5 rating
    [Tags] [nvarchar](500) NULL,
    [Attachments] [nvarchar](max) NULL, -- JSON array of attachment file paths
    
    CONSTRAINT [PK_SupportTickets] PRIMARY KEY CLUSTERED ([TicketId] ASC)
);
GO

-- Create Help Articles Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HelpArticles' AND xtype='U')
CREATE TABLE [dbo].[HelpArticles] (
    [ArticleId] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](255) NOT NULL,
    [Content] [nvarchar](max) NOT NULL,
    [Category] [nvarchar](100) NOT NULL,
    [SubCategory] [nvarchar](100) NULL,
    [Tags] [nvarchar](500) NULL,
    [Author] [nvarchar](100) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
    [ModifiedDate] [datetime] NULL,
    [PublishedDate] [datetime] NULL,
    [IsPublished] [bit] NOT NULL DEFAULT(0),
    [ViewCount] [int] NOT NULL DEFAULT(0),
    [HelpfulCount] [int] NOT NULL DEFAULT(0),
    [NotHelpfulCount] [int] NOT NULL DEFAULT(0),
    [SearchKeywords] [nvarchar](max) NULL,
    [Difficulty] [nvarchar](20) NULL, -- 'Beginner', 'Intermediate', 'Advanced'
    [EstimatedReadTime] [int] NULL, -- in minutes
    
    CONSTRAINT [PK_HelpArticles] PRIMARY KEY CLUSTERED ([ArticleId] ASC)
);
GO

-- Create Help Search History Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='HelpSearchHistory' AND xtype='U')
CREATE TABLE [dbo].[HelpSearchHistory] (
    [SearchId] [int] IDENTITY(1,1) NOT NULL,
    [UserId] [nvarchar](50) NOT NULL,
    [SearchTerm] [nvarchar](255) NOT NULL,
    [SearchDate] [datetime] NOT NULL DEFAULT(GETDATE()),
    [ResultsCount] [int] NULL,
    [ClickedArticleId] [int] NULL,
    [SessionId] [nvarchar](100) NULL,
    
    CONSTRAINT [PK_HelpSearchHistory] PRIMARY KEY CLUSTERED ([SearchId] ASC)
);
GO

-- Create FAQ Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='FAQ' AND xtype='U')
CREATE TABLE [dbo].[FAQ] (
    [FAQId] [int] IDENTITY(1,1) NOT NULL,
    [Question] [nvarchar](500) NOT NULL,
    [Answer] [nvarchar](max) NOT NULL,
    [Category] [nvarchar](100) NOT NULL,
    [DisplayOrder] [int] NOT NULL DEFAULT(0),
    [IsActive] [bit] NOT NULL DEFAULT(1),
    [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
    [ModifiedDate] [datetime] NULL,
    [ViewCount] [int] NOT NULL DEFAULT(0),
    [HelpfulCount] [int] NOT NULL DEFAULT(0),
    [Tags] [nvarchar](300) NULL,
    
    CONSTRAINT [PK_FAQ] PRIMARY KEY CLUSTERED ([FAQId] ASC)
);
GO

-- Create Video Tutorials Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='VideoTutorials' AND xtype='U')
CREATE TABLE [dbo].[VideoTutorials] (
    [VideoId] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](255) NOT NULL,
    [Description] [nvarchar](max) NULL,
    [Category] [nvarchar](100) NOT NULL,
    [VideoUrl] [nvarchar](500) NOT NULL,
    [ThumbnailUrl] [nvarchar](500) NULL,
    [Duration] [int] NULL, -- in seconds
    [Difficulty] [nvarchar](20) NULL, -- 'Beginner', 'Intermediate', 'Advanced'
    [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
    [PublishedDate] [datetime] NULL,
    [IsActive] [bit] NOT NULL DEFAULT(1),
    [ViewCount] [int] NOT NULL DEFAULT(0),
    [LikeCount] [int] NOT NULL DEFAULT(0),
    [Tags] [nvarchar](500) NULL,
    [Transcript] [nvarchar](max) NULL,
    
    CONSTRAINT [PK_VideoTutorials] PRIMARY KEY CLUSTERED ([VideoId] ASC)
);
GO

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX [IX_SupportTickets_CreatedBy] ON [dbo].[SupportTickets] ([CreatedBy]);
CREATE NONCLUSTERED INDEX [IX_SupportTickets_Status] ON [dbo].[SupportTickets] ([Status]);
CREATE NONCLUSTERED INDEX [IX_SupportTickets_Priority] ON [dbo].[SupportTickets] ([Priority]);
CREATE NONCLUSTERED INDEX [IX_SupportTickets_CreatedDate] ON [dbo].[SupportTickets] ([CreatedDate] DESC);

CREATE NONCLUSTERED INDEX [IX_HelpArticles_Category] ON [dbo].[HelpArticles] ([Category]);
CREATE NONCLUSTERED INDEX [IX_HelpArticles_IsPublished] ON [dbo].[HelpArticles] ([IsPublished]);
CREATE NONCLUSTERED INDEX [IX_HelpArticles_ViewCount] ON [dbo].[HelpArticles] ([ViewCount] DESC);

CREATE NONCLUSTERED INDEX [IX_HelpSearchHistory_UserId] ON [dbo].[HelpSearchHistory] ([UserId]);
CREATE NONCLUSTERED INDEX [IX_HelpSearchHistory_SearchDate] ON [dbo].[HelpSearchHistory] ([SearchDate] DESC);
GO

-- Insert sample FAQ data
INSERT INTO [dbo].[FAQ] ([Question], [Answer], [Category], [DisplayOrder], [Tags]) VALUES
('How do I reset a user''s password?', 'To reset a user''s password: 1) Go to User Management, 2) Find the user in the list, 3) Click the "Actions" dropdown, 4) Select "Reset Password", 5) The user will receive an email with a temporary password that they must change on first login.', 'User Management', 1, 'password,reset,user,email'),
('How can I create a new course?', 'To create a new course: 1) Navigate to Course Management, 2) Click "Add New Course", 3) Fill in the course details (name, description, credits), 4) Set the enrollment dates and capacity, 5) Assign instructors, 6) Configure course settings, 7) Save and publish the course.', 'Course Management', 2, 'course,create,management,enrollment'),
('How do I generate enrollment reports?', 'To generate enrollment reports: 1) Go to Reports & Analytics, 2) Select "Enrollment Reports", 3) Choose the date range and courses, 4) Select report format (PDF, Excel, CSV), 5) Click "Generate Report". The report will be downloaded to your computer or emailed to you.', 'Reports', 3, 'reports,enrollment,analytics,export'),
('What should I do if the system is running slowly?', 'If the system is slow: 1) Check the server status in System Monitoring, 2) Review recent user activity logs, 3) Clear browser cache and cookies, 4) Check for any scheduled maintenance, 5) If issues persist, contact technical support with specific details about the slowness.', 'Troubleshooting', 4, 'performance,slow,troubleshooting,server'),
('How do I backup the system data?', 'System backups are automated daily at 2:00 AM. To manually create a backup: 1) Go to System Settings > Backup, 2) Click "Create Manual Backup", 3) Select what to include (database, files, configurations), 4) Choose backup location, 5) Click "Start Backup". Monitor progress in the notifications panel.', 'System Administration', 5, 'backup,data,system,manual'),
('How can I manage user permissions and roles?', 'To manage permissions: 1) Navigate to User Management > Roles & Permissions, 2) Select the role to modify or create a new one, 3) Check/uncheck permissions for different modules, 4) Set access levels (View, Edit, Delete, Admin), 5) Save changes. Users with that role will automatically get updated permissions.', 'User Management', 6, 'permissions,roles,access,security');
GO

-- Insert sample help articles
INSERT INTO [dbo].[HelpArticles] ([Title], [Content], [Category], [Author], [IsPublished], [SearchKeywords], [Difficulty], [EstimatedReadTime]) VALUES
('Getting Started with Admin Dashboard', '<h2>Welcome to the LMS Admin Dashboard</h2><p>This comprehensive guide will help you navigate the main features...</p>', 'Getting Started', 'System Administrator', 1, 'dashboard,navigation,admin,overview', 'Beginner', 5),
('User Management Best Practices', '<h2>Managing Users Effectively</h2><p>Learn the best practices for managing users in your LMS...</p>', 'User Management', 'System Administrator', 1, 'users,management,best practices,roles', 'Intermediate', 8),
('Course Creation Workflow', '<h2>Creating Courses Step by Step</h2><p>Follow this detailed workflow to create engaging courses...</p>', 'Course Management', 'System Administrator', 1, 'courses,creation,workflow,setup', 'Intermediate', 12),
('System Security Guidelines', '<h2>Maintaining System Security</h2><p>Important security measures every administrator should know...</p>', 'Security', 'System Administrator', 1, 'security,guidelines,best practices,safety', 'Advanced', 15),
('Troubleshooting Common Issues', '<h2>Solving Common Problems</h2><p>Quick solutions to frequently encountered issues...</p>', 'Troubleshooting', 'System Administrator', 1, 'troubleshooting,problems,solutions,fixes', 'Beginner', 7);
GO

-- Insert sample video tutorials
INSERT INTO [dbo].[VideoTutorials] ([Title], [Description], [Category], [VideoUrl], [Duration], [Difficulty], [IsActive], [Tags]) VALUES
('Admin Dashboard Overview', 'Get familiar with the admin dashboard layout and navigation', 'Getting Started', '/videos/admin-dashboard-overview.mp4', 300, 'Beginner', 1, 'dashboard,overview,navigation'),
('Creating and Managing Users', 'Learn how to add new users and manage their permissions', 'User Management', '/videos/user-management.mp4', 480, 'Intermediate', 1, 'users,permissions,management'),
('Course Setup and Configuration', 'Step-by-step guide to creating and configuring courses', 'Course Management', '/videos/course-setup.mp4', 720, 'Intermediate', 1, 'courses,setup,configuration'),
('System Backup and Maintenance', 'Important procedures for system backup and maintenance', 'System Administration', '/videos/backup-maintenance.mp4', 600, 'Advanced', 1, 'backup,maintenance,system');
GO

-- Create stored procedures for help system

-- Procedure to get support tickets for a user
CREATE PROCEDURE [dbo].[sp_GetUserSupportTickets]
    @UserId NVARCHAR(50),
    @Status NVARCHAR(20) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        TicketId, Category, Priority, Subject, Description, Status,
        CreatedDate, ResolvedDate, SatisfactionRating
    FROM SupportTickets
    WHERE CreatedBy = @UserId
    AND (@Status IS NULL OR Status = @Status)
    ORDER BY CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- Procedure to search help articles
CREATE PROCEDURE [dbo].[sp_SearchHelpArticles]
    @SearchTerm NVARCHAR(255),
    @Category NVARCHAR(100) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        ArticleId, Title, Category, Author, CreatedDate,
        EstimatedReadTime, Difficulty, ViewCount
    FROM HelpArticles
    WHERE IsPublished = 1
    AND (Title LIKE '%' + @SearchTerm + '%' 
         OR Content LIKE '%' + @SearchTerm + '%'
         OR SearchKeywords LIKE '%' + @SearchTerm + '%')
    AND (@Category IS NULL OR Category = @Category)
    ORDER BY 
        CASE WHEN Title LIKE '%' + @SearchTerm + '%' THEN 1 ELSE 2 END,
        ViewCount DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- Function to get help statistics
CREATE FUNCTION [dbo].[fn_GetHelpStatistics]()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        (SELECT COUNT(*) FROM SupportTickets WHERE CreatedDate >= DATEADD(month, -1, GETDATE())) as TicketsThisMonth,
        (SELECT COUNT(*) FROM SupportTickets WHERE Status = 'Open') as OpenTickets,
        (SELECT COUNT(*) FROM HelpArticles WHERE IsPublished = 1) as PublishedArticles,
        (SELECT COUNT(*) FROM VideoTutorials WHERE IsActive = 1) as ActiveVideos,
        (SELECT AVG(CAST(SatisfactionRating as FLOAT)) FROM SupportTickets WHERE SatisfactionRating IS NOT NULL) as AvgSatisfaction
);
GO

PRINT 'Help system database structure created successfully!';
