-- Create ZoomMeetings table for tracking Zoom support sessions
USE [LearningManagementSystem]
GO

-- Check if table exists and drop if needed
IF OBJECT_ID(N'[dbo].[ZoomMeetings]', N'U') IS NOT NULL
    DROP TABLE [dbo].[ZoomMeetings]
GO

-- Create ZoomMeetings table
CREATE TABLE [dbo].[ZoomMeetings](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [MeetingId] [nvarchar](50) NOT NULL,
    [SupportType] [nvarchar](50) NOT NULL,
    [RequestedBy] [nvarchar](50) NOT NULL,
    [AssignedAgent] [nvarchar](100) NULL,
    [Topic] [nvarchar](200) NULL,
    [Password] [nvarchar](20) NULL,
    [JoinUrl] [nvarchar](500) NULL,
    [StartUrl] [nvarchar](500) NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT (GETDATE()),
    [StartTime] [datetime] NULL,
    [EndTime] [datetime] NULL,
    [Duration] [int] NULL, -- Duration in minutes
    [Status] [nvarchar](20) NOT NULL DEFAULT ('Created'),
    [Notes] [nvarchar](1000) NULL,
    [Rating] [int] NULL, -- 1-5 star rating
    [Feedback] [nvarchar](500) NULL,
    CONSTRAINT [PK_ZoomMeetings] PRIMARY KEY CLUSTERED ([Id] ASC)
)
GO

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX [IX_ZoomMeetings_MeetingId] ON [dbo].[ZoomMeetings] 
(
    [MeetingId] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_ZoomMeetings_RequestedBy] ON [dbo].[ZoomMeetings] 
(
    [RequestedBy] ASC
)
GO

CREATE NONCLUSTERED INDEX [IX_ZoomMeetings_CreatedDate] ON [dbo].[ZoomMeetings] 
(
    [CreatedDate] DESC
)
GO

-- Insert sample data for testing
INSERT INTO [dbo].[ZoomMeetings] 
([MeetingId], [SupportType], [RequestedBy], [AssignedAgent], [Topic], [Status], [StartTime], [EndTime], [Duration], [Rating], [Feedback])
VALUES 
('123456789012', 'technical', 'admin', 'David Kim', 'Technical Support Session', 'Completed', DATEADD(hour, -2, GETDATE()), DATEADD(hour, -1, GETDATE()), 45, 5, 'Excellent support, issue resolved quickly'),
('234567890123', 'general', 'admin', 'Sarah Johnson', 'General Inquiry Session', 'Completed', DATEADD(day, -1, GETDATE()), DATEADD(day, -1, DATEADD(minute, 30, GETDATE())), 30, 4, 'Very helpful, clear explanations'),
('345678901234', 'training', 'admin', 'Jennifer Wilson', 'Training Support Session', 'In Progress', DATEADD(minute, -15, GETDATE()), NULL, NULL, NULL, NULL),
('456789012345', 'emergency', 'admin', 'Emergency Support Team', 'Emergency Support Session', 'Scheduled', NULL, NULL, NULL, NULL, NULL)
GO

-- Update Notifications table to support Zoom meeting categories (if not already exists)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[Notifications]') AND name = 'Category')
BEGIN
    ALTER TABLE [dbo].[Notifications]
    ADD [Category] [nvarchar](50) NULL
END
GO

-- Add sample notifications for Zoom meetings
INSERT INTO [dbo].[Notifications] 
([Title], [Message], [Type], [Priority], [TargetUserId], [CreatedDate], [IsRead], [Category])
VALUES 
('Zoom Meeting History Available', 'Your previous support sessions are now available in the meeting history section.', 'info', 'low', NULL, GETDATE(), 0, 'zoom-meeting'),
('Video Support Enhancement', 'We have upgraded our support system with Zoom video calling for better assistance.', 'success', 'medium', NULL, DATEADD(hour, -1, GETDATE()), 0, 'zoom-meeting')
GO

PRINT 'ZoomMeetings table and related data created successfully!'
