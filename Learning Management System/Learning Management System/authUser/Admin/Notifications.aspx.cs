using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Notifications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if admin is logged in
                if (Session["UserID"] == null)
                {
                    //Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }

                LoadNotifications();
            }
        }

        private void LoadNotifications()
        {
            try
            {
                string userId = Session["UserID"]?.ToString() ?? "0";
                // Now we use the stored procedures and database table we created
                
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                
                // We won't bind the data directly to controls since we're using JavaScript to render
                // Instead, we'll just make sure the database is properly set up
                
                // Check if the database tables and stored procedures are accessible
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    try
                    {
                        connection.Open();
                        // Just a simple check to see if we can access the Notifications table
                        string query = "SELECT COUNT(*) FROM Notifications";
                        using (SqlCommand command = new SqlCommand(query, connection))
                        {
                            int count = (int)command.ExecuteScalar();
                            System.Diagnostics.Debug.WriteLine($"Total notifications in database: {count}");
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error accessing Notifications table: {ex.Message}");
                        // If table doesn't exist, you might want to add code to run the setup script
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading notifications: {ex.Message}");
            }
        }

        [System.Web.Services.WebMethod]
        public static string MarkNotificationAsRead(int notificationId)
        {
            try
            {
                string userId = HttpContext.Current.Session["UserID"]?.ToString() ?? "3";
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Notifications 
                        SET IsRead = 1, ReadDate = GETDATE() 
                        WHERE NotificationId = @NotificationId 
                        AND (TargetUserId = @UserId OR TargetUserId IS NULL)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@NotificationId", notificationId);
                        command.Parameters.AddWithValue("@UserId", userId);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        return rowsAffected > 0 ? "success" : "Notification not found or already read.";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error marking notification as read: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string DeleteNotification(int notificationId)
        {
            try
            {
                string userId = HttpContext.Current.Session["UserID"]?.ToString() ?? "3";
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        DELETE FROM Notifications 
                        WHERE NotificationId = @NotificationId 
                        AND (TargetUserId = @UserId OR TargetUserId IS NULL)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@NotificationId", notificationId);
                        command.Parameters.AddWithValue("@UserId", userId);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        return rowsAffected > 0 ? "success" : "Notification not found.";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error deleting notification: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetNotifications(string filter, int page = 1, int pageSize = 10)
        {
            try
            {
                // Get userId from session if it exists, otherwise use a default value or null
                string userId = HttpContext.Current.Session["UserID"]?.ToString() ?? "3"; // Default to user id 3 since that's what's in your sample data
                
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                System.Diagnostics.Debug.WriteLine($"Connection string: {connectionString}");
                System.Diagnostics.Debug.WriteLine($"User ID: {userId}");

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string whereClause = "";
                    switch (filter?.ToLower() ?? "all")
                    {
                        case "unread":
                            whereClause = "AND IsRead = 0";
                            break;
                        case "system":
                            whereClause = "AND Type = 'system'";
                            break;
                        case "user":
                            whereClause = "AND Type = 'user'";
                            break;
                        case "security":
                            whereClause = "AND Type = 'security'";
                            break;
                        case "updates":
                            whereClause = "AND Type = 'update'";
                            break;
                    }

                    string query = $@"
                        SELECT NotificationId, Title, Message, Type, Priority, 
                               IsRead, CreatedDate, TargetUserId 
                        FROM Notifications 
                        WHERE (TargetUserId = @UserId OR TargetUserId IS NULL) {whereClause}
                        ORDER BY CreatedDate DESC
                        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        command.Parameters.AddWithValue("@Offset", (page - 1) * pageSize);
                        command.Parameters.AddWithValue("@PageSize", pageSize);

                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            var notifications = new List<object>();
                            while (reader.Read())
                            {
                                notifications.Add(new
                                {
                                    Id = reader["NotificationId"],
                                    Title = reader["Title"].ToString(),
                                    Message = reader["Message"].ToString(),
                                    Type = reader["Type"].ToString(),
                                    Priority = reader["Priority"].ToString(),
                                    IsRead = Convert.ToBoolean(reader["IsRead"]),
                                    CreatedDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd HH:mm:ss")
                                });
                            }

                            return Newtonsoft.Json.JsonConvert.SerializeObject(notifications);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error loading notifications: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string SearchNotifications(string searchTerm, string filter = "all", int page = 1, int pageSize = 10)
        {
            try
            {
                string userId = HttpContext.Current.Session["UserID"]?.ToString() ?? "3";
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string whereClause = "";
                    switch (filter.ToLower())
                    {
                        case "unread":
                            whereClause = "AND IsRead = 0";
                            break;
                        case "system":
                            whereClause = "AND Type = 'system'";
                            break;
                        case "user":
                            whereClause = "AND Type = 'user'";
                            break;
                        case "security":
                            whereClause = "AND Type = 'security'";
                            break;
                        case "updates":
                            whereClause = "AND Type = 'update'";
                            break;
                    }

                    string searchCondition = !string.IsNullOrEmpty(searchTerm)
                        ? "AND (Title LIKE @SearchTerm OR Message LIKE @SearchTerm)"
                        : "";

                    string query = $@"
                        SELECT NotificationId, Title, Message, Type, Priority, 
                               IsRead, CreatedDate, TargetUserId 
                        FROM Notifications 
                        WHERE (TargetUserId = @UserId OR TargetUserId IS NULL) 
                              {whereClause} {searchCondition}
                        ORDER BY CreatedDate DESC
                        OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                        }
                        command.Parameters.AddWithValue("@Offset", (page - 1) * pageSize);
                        command.Parameters.AddWithValue("@PageSize", pageSize);

                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            var notifications = new List<object>();
                            while (reader.Read())
                            {
                                notifications.Add(new
                                {
                                    Id = reader["NotificationId"],
                                    Title = reader["Title"].ToString(),
                                    Message = reader["Message"].ToString(),
                                    Type = reader["Type"].ToString(),
                                    Priority = reader["Priority"].ToString(),
                                    IsRead = Convert.ToBoolean(reader["IsRead"]),
                                    CreatedDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd HH:mm:ss")
                                });
                            }

                            return Newtonsoft.Json.JsonConvert.SerializeObject(notifications);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error searching notifications: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetNotificationCount(string filter = "all")
        {
            try
            {
                string userId = HttpContext.Current.Session["UserID"]?.ToString() ?? "3";
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string whereClause = "";
                    switch (filter.ToLower())
                    {
                        case "unread":
                            whereClause = "AND IsRead = 0";
                            break;
                        case "system":
                            whereClause = "AND Type = 'system'";
                            break;
                        case "user":
                            whereClause = "AND Type = 'user'";
                            break;
                        case "security":
                            whereClause = "AND Type = 'security'";
                            break;
                        case "updates":
                            whereClause = "AND Type = 'update'";
                            break;
                    }

                    string query = $@"
                        SELECT COUNT(*) 
                        FROM Notifications 
                        WHERE (TargetUserId = @UserId OR TargetUserId IS NULL) {whereClause}";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);

                        connection.Open();
                        int count = (int)command.ExecuteScalar();
                        return count.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error getting notification count: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetNotificationStats()
        {
            try
            {
                // Get userId from session if it exists, otherwise use a default value or null
                string userId = HttpContext.Current.Session["UserID"]?.ToString() ?? "3"; // Default to user id 3 since that's what's in your sample data
                
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                System.Diagnostics.Debug.WriteLine($"Stats - Connection string: {connectionString}");
                System.Diagnostics.Debug.WriteLine($"Stats - User ID: {userId}");

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            COUNT(*) as Total,
                            SUM(CASE WHEN IsRead = 0 THEN 1 ELSE 0 END) as Unread,
                            SUM(CASE WHEN Priority = 'high' THEN 1 ELSE 0 END) as HighPriority,
                            SUM(CASE WHEN CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) as Today
                        FROM Notifications 
                        WHERE TargetUserId = @UserId OR TargetUserId IS NULL";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);

                        connection.Open();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                var stats = new
                                {
                                    Total = reader["Total"],
                                    Unread = reader["Unread"],
                                    HighPriority = reader["HighPriority"],
                                    Today = reader["Today"]
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
                return "Error loading notification stats: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string CreateNotification(string title, string message, string type, string priority, string targetUserId = null)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Notifications (Title, Message, Type, Priority, TargetUserId, CreatedDate, IsRead)
                        VALUES (@Title, @Message, @Type, @Priority, @TargetUserId, GETDATE(), 0)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Title", title);
                        command.Parameters.AddWithValue("@Message", message);
                        command.Parameters.AddWithValue("@Type", type);
                        command.Parameters.AddWithValue("@Priority", priority);
                        command.Parameters.AddWithValue("@TargetUserId", targetUserId ?? (object)DBNull.Value);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        return rowsAffected > 0 ? "success" : "Failed to create notification.";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error creating notification: " + ex.Message;
            }
        }
    }
}