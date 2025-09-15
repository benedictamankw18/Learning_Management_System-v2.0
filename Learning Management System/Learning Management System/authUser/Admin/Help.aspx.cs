using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net.Http;
using System.Text;
using System.Security.Cryptography;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Help : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if admin is logged in
                if (Session["AdminId"] == null)
                {
                    //Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }

                LoadHelpData();
            }
        }

        private void LoadHelpData()
        {
            try
            {
                // Load any dynamic help content from database
                // For now, most content is static in the HTML
                
                // You could load personalized help content based on user role
                string adminId = Session["AdminId"].ToString();
                
                // Example: Load user's recent help searches or bookmarked articles
                /*
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT SearchTerm, SearchDate 
                        FROM HelpSearchHistory 
                        WHERE UserId = @AdminId 
                        ORDER BY SearchDate DESC";
                    
                    // Load search history for suggestions
                }
                */
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading help data: {ex.Message}");
            }
        }

        [System.Web.Services.WebMethod]
        public static string SearchHelpArticles(string searchTerm)
        {
            try
            {
                // In a real implementation, this would search through help articles in database
                var mockResults = new List<object>
                {
                    new { Title = "User Management Guide", Category = "Users", Relevance = 95 },
                    new { Title = "Creating Courses", Category = "Courses", Relevance = 87 },
                    new { Title = "System Settings Overview", Category = "Settings", Relevance = 73 }
                };

                // Filter based on search term
                var filteredResults = mockResults.Where(r => 
                    r.GetType().GetProperty("Title").GetValue(r).ToString().ToLower().Contains(searchTerm.ToLower()) ||
                    r.GetType().GetProperty("Category").GetValue(r).ToString().ToLower().Contains(searchTerm.ToLower())
                ).ToList();

                return Newtonsoft.Json.JsonConvert.SerializeObject(filteredResults);
            }
            catch (Exception ex)
            {
                return "Error searching help articles: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string CreateSupportTicket(string category, string priority, string subject, string description)
        {
            try
            {
                string adminId = HttpContext.Current.Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                // Generate ticket ID
                string ticketId = "TKT" + DateTime.Now.ToString("yyyyMMdd") + new Random().Next(1000, 9999).ToString();

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO SupportTickets 
                        (TicketId, Category, Priority, Subject, Description, CreatedBy, CreatedDate, Status)
                        VALUES 
                        (@TicketId, @Category, @Priority, @Subject, @Description, @CreatedBy, GETDATE(), 'Open')";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@TicketId", ticketId);
                        command.Parameters.AddWithValue("@Category", category);
                        command.Parameters.AddWithValue("@Priority", priority);
                        command.Parameters.AddWithValue("@Subject", subject);
                        command.Parameters.AddWithValue("@Description", description);
                        command.Parameters.AddWithValue("@CreatedBy", adminId);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Create notification for support team
                            CreateNotificationForSupportTeam(ticketId, subject, priority);
                            
                            return $"success|{ticketId}";
                        }
                        else
                        {
                            return "Failed to create support ticket.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error creating support ticket: " + ex.Message;
            }
        }

        private static void CreateNotificationForSupportTeam(string ticketId, string subject, string priority)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Notifications 
                        (Title, Message, Type, Priority, TargetUserId, CreatedDate, IsRead, Category)
                        VALUES 
                        (@Title, @Message, 'support', @Priority, NULL, GETDATE(), 0, 'support-ticket')";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Title", $"New Support Ticket: {ticketId}");
                        command.Parameters.AddWithValue("@Message", $"A new {priority.ToLower()} priority support ticket has been created: {subject}");
                        command.Parameters.AddWithValue("@Priority", priority.ToLower());

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error creating support notification: {ex.Message}");
            }
        }

        [System.Web.Services.WebMethod]
        public static string LogHelpSearch(string searchTerm)
        {
            try
            {
                string adminId = HttpContext.Current.Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO HelpSearchHistory (UserId, SearchTerm, SearchDate)
                        VALUES (@UserId, @SearchTerm, GETDATE())";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", adminId);
                        command.Parameters.AddWithValue("@SearchTerm", searchTerm);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "Error logging search: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetSystemStatus()
        {
            try
            {
                // In a real implementation, this would check actual system components
                var systemStatus = new
                {
                    Database = new { Status = "Online", ResponseTime = "12ms", LastCheck = DateTime.Now },
                    ApplicationServer = new { Status = "Online", CPU = "45%", Memory = "62%", LastCheck = DateTime.Now },
                    FileStorage = new { Status = "Online", FreeSpace = "1.2TB", LastCheck = DateTime.Now },
                    EmailService = new { Status = "Delayed", QueueSize = 23, LastCheck = DateTime.Now },
                    BackupService = new { Status = "Online", LastBackup = DateTime.Now.AddDays(-1), LastCheck = DateTime.Now }
                };

                return Newtonsoft.Json.JsonConvert.SerializeObject(systemStatus);
            }
            catch (Exception ex)
            {
                return "Error getting system status: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetHelpStatistics()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            COUNT(*) as TotalTickets,
                            SUM(CASE WHEN Status = 'Open' THEN 1 ELSE 0 END) as OpenTickets,
                            SUM(CASE WHEN Priority = 'High' OR Priority = 'Critical' THEN 1 ELSE 0 END) as HighPriorityTickets,
                            AVG(CASE WHEN Status = 'Closed' AND ResolvedDate IS NOT NULL 
                                THEN DATEDIFF(hour, CreatedDate, ResolvedDate) END) as AvgResolutionHours
                        FROM SupportTickets 
                        WHERE CreatedDate >= DATEADD(month, -3, GETDATE())";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                var stats = new
                                {
                                    TotalTickets = reader["TotalTickets"],
                                    OpenTickets = reader["OpenTickets"],
                                    HighPriorityTickets = reader["HighPriorityTickets"],
                                    AvgResolutionHours = reader["AvgResolutionHours"] != DBNull.Value ? 
                                        Convert.ToDouble(reader["AvgResolutionHours"]) : 0
                                };

                                return Newtonsoft.Json.JsonConvert.SerializeObject(stats);
                            }
                        }
                    }
                }

                return "{}";
            }
            catch (Exception ex)
            {
                return "Error getting help statistics: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string InitiateManualBackup()
        {
            try
            {
                // In a real implementation, this would trigger the backup process
                // For now, we'll simulate it and create a notification

                string adminId = HttpContext.Current.Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Notifications 
                        (Title, Message, Type, Priority, TargetUserId, CreatedDate, IsRead, Category)
                        VALUES 
                        (@Title, @Message, 'system', 'medium', @AdminId, GETDATE(), 0, 'backup')";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Title", "Manual Backup Initiated");
                        command.Parameters.AddWithValue("@Message", $"Manual backup started at {DateTime.Now:yyyy-MM-dd HH:mm:ss}. You will be notified when it completes.");
                        command.Parameters.AddWithValue("@AdminId", adminId);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "Error initiating backup: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string CreateZoomMeeting(string supportType, object userInfo)
        {
            try
            {
                // Zoom API Configuration (These should be in Web.config or environment variables)
                string zoomApiKey = ConfigurationManager.AppSettings["ZoomApiKey"] ?? "your_zoom_api_key";
                string zoomApiSecret = ConfigurationManager.AppSettings["ZoomApiSecret"] ?? "your_zoom_api_secret";
                string zoomAccountId = ConfigurationManager.AppSettings["ZoomAccountId"] ?? "your_zoom_account_id";

                // For demo purposes, we'll create a mock meeting response
                // In production, you would make actual API calls to Zoom
                
                string meetingId = GenerateMeetingId();
                string password = GeneratePassword();
                string topic = $"Support Session - {supportType}";
                string hostName = GetAvailableSupportAgent(supportType);
                
                // Generate Zoom signature (required for Web SDK)
                string signature = GenerateZoomSignature(zoomApiKey, zoomApiSecret, meetingId, 0); // 0 for host

                var meetingData = new
                {
                    success = true,
                    meetingId = meetingId,
                    password = password,
                    topic = topic,
                    hostName = hostName,
                    joinUrl = $"https://us04web.zoom.us/j/{meetingId}?pwd={password}",
                    startUrl = $"https://us04web.zoom.us/s/{meetingId}?zak=token",
                    signature = signature,
                    apiKey = zoomApiKey,
                    created = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
                };

                // Log the meeting creation in database
                LogZoomMeeting(meetingId, supportType, HttpContext.Current.Session["AdminId"].ToString());

                // Create notification for support team
                CreateSupportNotification(meetingId, supportType, hostName);

                return Newtonsoft.Json.JsonConvert.SerializeObject(new 
                { 
                    success = true, 
                    meetingData = Newtonsoft.Json.JsonConvert.SerializeObject(meetingData) 
                });
            }
            catch (Exception ex)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new 
                { 
                    success = false, 
                    error = $"Failed to create Zoom meeting: {ex.Message}" 
                });
            }
        }

        private static string GenerateMeetingId()
        {
            // Generate a realistic meeting ID (11 digits)
            Random random = new Random();
            return random.Next(100, 999).ToString() + 
                   random.Next(1000, 9999).ToString() + 
                   random.Next(1000, 9999).ToString();
        }

        private static string GeneratePassword()
        {
            // Generate a 6-character alphanumeric password
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            Random random = new Random();
            return new string(Enumerable.Repeat(chars, 6)
                .Select(s => s[random.Next(s.Length)]).ToArray());
        }

        private static string GetAvailableSupportAgent(string supportType)
        {
            // In a real implementation, this would check agent availability
            var agents = new Dictionary<string, string[]>
            {
                ["general"] = new[] { "Sarah Johnson", "Mike Chen", "Lisa Rodriguez" },
                ["technical"] = new[] { "David Kim", "Alex Thompson", "Maria Santos" },
                ["training"] = new[] { "Jennifer Wilson", "Robert Taylor", "Emily Davis" },
                ["emergency"] = new[] { "Emergency Support Team", "Senior Tech Lead" }
            };

            if (agents.ContainsKey(supportType))
            {
                var availableAgents = agents[supportType];
                return availableAgents[new Random().Next(availableAgents.Length)];
            }

            return "Support Agent";
        }

        private static string GenerateZoomSignature(string apiKey, string apiSecret, string meetingId, int role)
        {
            // Generate Zoom Web SDK signature
            long timestamp = DateTimeOffset.UtcNow.ToUnixTimeSeconds() * 1000;
            
            string message = $"{apiKey}{meetingId}{timestamp}{role}";
            
            using (var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(apiSecret)))
            {
                byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(message));
                string signature = Convert.ToBase64String(hash);
                
                return $"{apiKey}.{meetingId}.{timestamp}.{role}.{signature}";
            }
        }

        private static void LogZoomMeeting(string meetingId, string supportType, string userId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO ZoomMeetings 
                        (MeetingId, SupportType, RequestedBy, CreatedDate, Status)
                        VALUES 
                        (@MeetingId, @SupportType, @RequestedBy, GETDATE(), 'Created')";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@MeetingId", meetingId);
                        command.Parameters.AddWithValue("@SupportType", supportType);
                        command.Parameters.AddWithValue("@RequestedBy", userId);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error logging Zoom meeting: {ex.Message}");
            }
        }

        private static void CreateSupportNotification(string meetingId, string supportType, string hostName)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Notifications 
                        (Title, Message, Type, Priority, TargetUserId, CreatedDate, IsRead, Category)
                        VALUES 
                        (@Title, @Message, 'support', 'high', NULL, GETDATE(), 0, 'zoom-meeting')";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Title", $"New Zoom Support Session: {meetingId}");
                        command.Parameters.AddWithValue("@Message", $"A new {supportType} support session has been requested. Meeting ID: {meetingId}. Assigned to: {hostName}");

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error creating support notification: {ex.Message}");
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetZoomMeetingHistory()
        {
            try
            {
                string userId = HttpContext.Current.Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 10 MeetingId, SupportType, CreatedDate, Status, Duration
                        FROM ZoomMeetings 
                        WHERE RequestedBy = @UserId 
                        ORDER BY CreatedDate DESC";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);

                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            var meetings = new List<object>();
                            while (reader.Read())
                            {
                                meetings.Add(new
                                {
                                    MeetingId = reader["MeetingId"].ToString(),
                                    SupportType = reader["SupportType"].ToString(),
                                    CreatedDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd HH:mm:ss"),
                                    Status = reader["Status"].ToString(),
                                    Duration = reader["Duration"] != DBNull.Value ? reader["Duration"].ToString() : "N/A"
                                });
                            }

                            return Newtonsoft.Json.JsonConvert.SerializeObject(meetings);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error retrieving meeting history: " + ex.Message;
            }
        }
    }
}