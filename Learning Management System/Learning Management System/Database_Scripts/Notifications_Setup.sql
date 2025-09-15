-- Notifications Table Structure for Learning Management System
-- This script creates the table structure needed for the Notifications functionality

USE [LearningManagementSystem]
GO

-- Drop Notifications Table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
BEGIN
    DROP TABLE [dbo].[Notifications]
    PRINT 'Existing Notifications table dropped.'
END
GO

-- Create Notifications Table
CREATE TABLE [dbo].[Notifications] (
    [NotificationId] [int] IDENTITY(1,1) NOT NULL,
    [Title] [nvarchar](255) NOT NULL,
    [Message] [nvarchar](max) NOT NULL,
    [Type] [nvarchar](50) NOT NULL, -- 'system', 'user', 'security', 'update', 'warning'
    [Priority] [nvarchar](20) NOT NULL, -- 'low', 'medium', 'high'
    [TargetUserId] [nvarchar](50) NULL, -- NULL for global notifications, specific userId for targeted
    [IsRead] [bit] NOT NULL DEFAULT(0),
    [CreatedDate] [datetime] NOT NULL DEFAULT(GETDATE()),
    [ReadDate] [datetime] NULL,
    [ExpiryDate] [datetime] NULL,
    [CreatedBy] [nvarchar](50) NULL,
    [Category] [nvarchar](50) NULL,
    [ActionUrl] [nvarchar](500) NULL, -- URL to redirect when notification is clicked
    [IconClass] [nvarchar](100) NULL, -- FontAwesome icon class
    [IsActive] [bit] NOT NULL DEFAULT(1),
    
    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotificationId] ASC)
);
GO

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX [IX_Notifications_TargetUserId] ON [dbo].[Notifications] ([TargetUserId]);
CREATE NONCLUSTERED INDEX [IX_Notifications_Type] ON [dbo].[Notifications] ([Type]);
CREATE NONCLUSTERED INDEX [IX_Notifications_IsRead] ON [dbo].[Notifications] ([IsRead]);
CREATE NONCLUSTERED INDEX [IX_Notifications_CreatedDate] ON [dbo].[Notifications] ([CreatedDate] DESC);
GO

-- Insert sample notifications for demonstration
INSERT INTO [dbo].[Notifications] ([Title], [Message], [Type], [Priority], [TargetUserId], [Category], [IconClass]) VALUES
('Welcome to the System', 'Welcome to the Learning Management System! Please take a moment to complete your profile.', 'system', 'low', NULL, 'welcome', 'fas fa-hand-wave'),
('System Maintenance Scheduled', 'Scheduled maintenance will occur on Sunday, August 10, 2025 from 2:00 AM to 4:00 AM EST.', 'system', 'medium', NULL, 'maintenance', 'fas fa-wrench'),
('Security Alert', 'Unusual login activity detected. Please review your account security settings.', 'security', 'high', NULL, 'security', 'fas fa-shield-alt'),
('New User Registration', 'A new user has registered and is awaiting approval.', 'user', 'medium', NULL, 'registration', 'fas fa-user-plus'),
('System Update Available', 'Version 2.1.4 is available with security improvements and bug fixes.', 'update', 'medium', NULL, 'update', 'fas fa-download'),
('Daily Backup Completed', 'Daily backup has been completed successfully. All data is secure.', 'system', 'low', NULL, 'backup', 'fas fa-database'),
('High Course Enrollment', 'Advanced Data Structures course is nearing capacity. Consider opening additional sections.', 'user', 'medium', NULL, 'enrollment', 'fas fa-graduation-cap'),
('Server Performance Warning', 'Server resources are running high. Please monitor system performance.', 'system', 'high', NULL, 'performance', 'fas fa-exclamation-triangle');
GO

-- Create a view for notification statistics
CREATE VIEW [dbo].[vw_NotificationStats] AS
SELECT 
    COUNT(*) as TotalNotifications,
    SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as UnreadNotifications,
    SUM(CASE WHEN Priority = 'high' THEN 1 ELSE 0 END) as HighPriorityNotifications,
    SUM(CASE WHEN CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) as TodayNotifications,
    SUM(CASE WHEN Type = 'security' THEN 1 ELSE 0 END) as SecurityNotifications,
    SUM(CASE WHEN Type = 'system' THEN 1 ELSE 0 END) as SystemNotifications,
    SUM(CASE WHEN Type = 'user' THEN 1 ELSE 0 END) as UserNotifications,
    SUM(CASE WHEN Type = 'update' THEN 1 ELSE 0 END) as UpdateNotifications
FROM [dbo].[Notifications]
WHERE IsActive = 1;
GO

-- Stored procedure to create new notification
CREATE PROCEDURE [dbo].[sp_CreateNotification]
    @Title NVARCHAR(255),
    @Message NVARCHAR(MAX),
    @Type NVARCHAR(50),
    @Priority NVARCHAR(20),
    @TargetUserId NVARCHAR(50) = NULL,
    @Category NVARCHAR(50) = NULL,
    @ActionUrl NVARCHAR(500) = NULL,
    @IconClass NVARCHAR(100) = NULL,
    @CreatedBy NVARCHAR(50) = NULL,
    @ExpiryDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[Notifications] 
    ([Title], [Message], [Type], [Priority], [TargetUserId], [Category], [ActionUrl], [IconClass], [CreatedBy], [ExpiryDate])
    VALUES 
    (@Title, @Message, @Type, @Priority, @TargetUserId, @Category, @ActionUrl, @IconClass, @CreatedBy, @ExpiryDate);
    
    SELECT SCOPE_IDENTITY() as NotificationId;
END
GO

-- Stored procedure to mark notification as read
CREATE PROCEDURE [dbo].[sp_MarkNotificationAsRead]
    @NotificationId INT,
    @UserId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [dbo].[Notifications] 
    SET IsRead = 1, ReadDate = GETDATE()
    WHERE NotificationId = @NotificationId 
    AND (TargetUserId = @UserId OR TargetUserId IS NULL);
    
    SELECT @@ROWCOUNT as RowsAffected;
END
GO

-- Stored procedure to get notifications for a user
CREATE PROCEDURE [dbo].[sp_GetUserNotifications]
    @UserId NVARCHAR(50),
    @Type NVARCHAR(50) = NULL,
    @IsRead BIT = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        NotificationId,
        Title,
        Message,
        Type,
        Priority,
        IsRead,
        CreatedDate,
        ReadDate,
        Category,
        ActionUrl,
        IconClass
    FROM [dbo].[Notifications]
    WHERE (TargetUserId = @UserId OR TargetUserId IS NULL)
    AND IsActive = 1
    AND (@Type IS NULL OR Type = @Type)
    AND (@IsRead IS NULL OR IsRead = @IsRead)
    AND (ExpiryDate IS NULL OR ExpiryDate > GETDATE())
    ORDER BY 
        CASE WHEN Priority = 'high' THEN 1 WHEN Priority = 'medium' THEN 2 ELSE 3 END,
        CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- Function to get notification count for user
CREATE FUNCTION [dbo].[fn_GetUnreadNotificationCount](@UserId NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;
    
    SELECT @Count = COUNT(*)
    FROM [dbo].[Notifications]
    WHERE (TargetUserId = @UserId OR TargetUserId IS NULL)
    AND IsRead = 0
    AND IsActive = 1
    AND (ExpiryDate IS NULL OR ExpiryDate > GETDATE());
    
    RETURN ISNULL(@Count, 0);
END
GO

PRINT 'Notifications table structure and sample data created successfully!';
