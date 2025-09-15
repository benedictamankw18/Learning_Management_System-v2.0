# Zoom Video Support Integration Setup Guide

## Overview
This guide will help you set up the Zoom video calling integration for the Help & Support Center.

## Prerequisites
- Active Zoom Pro, Business, or Enterprise account
- SQL Server database access
- ASP.NET application deployed and running

## Setup Steps

### 1. Database Setup
Run the SQL script to create the required database table:

```sql
-- Execute the following script in SQL Server Management Studio
-- File: App_Data/ZoomMeetings_Table.sql
```

**Database Requirements:**
- `ZoomMeetings` table for meeting tracking
- `Notifications` table should have a `Category` column

### 2. Zoom App Configuration
1. Go to [Zoom Marketplace](https://marketplace.zoom.us/)
2. Sign in with your Zoom account
3. Click "Develop" → "Build App"
4. Choose "SDK App" type
5. Fill in app details:
   - App Name: "LMS Support Integration"
   - Short Description: "Video support for Learning Management System"
   - Company Name: Your institution name

### 3. Get Zoom Credentials
After creating the app, you'll get:
- **API Key** (Client ID)
- **API Secret** (Client Secret) 
- **Account ID**

### 4. Update Web.config
Replace the placeholder values in `Web.config`:

```xml
<appSettings>
    <!-- Replace with your actual Zoom credentials -->
    <add key="ZoomApiKey" value="your_actual_zoom_api_key"/>
    <add key="ZoomApiSecret" value="your_actual_zoom_api_secret"/>
    <add key="ZoomAccountId" value="your_actual_zoom_account_id"/>
    <add key="ZoomWebhookSecret" value="your_zoom_webhook_secret"/>
</appSettings>
```

### 5. Test the Integration

#### Option A: Full Production Test
1. Navigate to Admin → Help & Support
2. Click "Live Video Support"
3. Select support type and click "Start Video Call"
4. Verify meeting creation and join process

#### Option B: Demo Mode Test
If you encounter connection errors:
1. Click "Live Video Support"
2. If connection fails, click "View Demo"
3. Test the demo interface to see expected functionality

## Troubleshooting

### Common Issues

#### 1. "Connection Error - Unable to start video call"
**Cause:** WebMethod not responding or database issues
**Solution:** 
- Check if ZoomMeetings table exists
- Verify Web.config Zoom credentials
- Check server logs for compilation errors

#### 2. "WebMethod not found"
**Cause:** Help.aspx.cs compilation issues
**Solution:**
- Rebuild the application
- Check for syntax errors in Help.aspx.cs
- Ensure using statements are included

#### 3. "Server returned HTML instead of JSON"
**Cause:** ASP.NET compilation errors
**Solution:**
- Check for syntax errors in Help.aspx.cs
- Verify all required references are included
- Check web.config for compilation settings

#### 4. "Database table missing"
**Cause:** ZoomMeetings table not created
**Solution:**
- Run the SQL script: `App_Data/ZoomMeetings_Table.sql`
- Verify database connection string
- Ensure database user has CREATE/INSERT permissions

### Error Logs
Check these locations for detailed error information:
- Browser Console (F12 → Console)
- Server Application Event Log
- IIS Error Logs
- SQL Server Error Log

## Features Available

### For Administrators
- **Live Video Support**: Direct Zoom meeting creation
- **Meeting History**: View all past support sessions
- **Demo Mode**: Test interface when server unavailable
- **Alternative Options**: Fallback to phone/email/tickets

### For Support Agents
- **Notification System**: Automatic alerts for new meetings
- **Meeting Tracking**: Duration, status, and feedback tracking
- **Multiple Support Types**: General, Technical, Training, Emergency

### For Users
- **Easy Access**: One-click video support from Help page
- **Flexible Joining**: Zoom app or browser options
- **Meeting History**: View past support sessions
- **Fallback Options**: Alternative contact methods when needed

## Production Deployment Checklist

- [ ] ZoomMeetings table created in production database
- [ ] Zoom API credentials configured in Web.config
- [ ] Application compiled and deployed without errors
- [ ] Test video call creation with real Zoom account
- [ ] Support team trained on new video calling system
- [ ] Backup contact methods verified (phone, email, tickets)
- [ ] Demo mode tested as fallback option

## Security Considerations

1. **API Credentials**: Store Zoom credentials securely
2. **Meeting Passwords**: Auto-generated and secure
3. **Session Tracking**: Complete audit trail maintained
4. **User Authentication**: Only authenticated users can create meetings

## Support

If you need assistance with this setup:
1. Check the troubleshooting section above
2. Test with demo mode to verify interface functionality
3. Review server logs for specific error details
4. Contact your system administrator for database/server issues

---

**Last Updated:** August 8, 2025
**Version:** 1.0
**Status:** Production Ready
