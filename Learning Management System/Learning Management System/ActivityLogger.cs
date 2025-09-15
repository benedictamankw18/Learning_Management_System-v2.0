using System;
using System.Data.SqlClient;
using System.Web;

namespace Learning_Management_System.Helpers
{
    /// <summary>
    /// Handles logging of user activities, login attempts, and system errors into the LMS database.
    /// Includes fallback file logging if the database is unavailable.
    /// </summary>
    public static class ActivityLogger
    {
        /// <summary>
        /// Logs general system activities (e.g. course creation, enrollment, etc.)
        /// </summary>
        public static void Log(string activityType, string description)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager
                                    .ConnectionStrings["LMSConnection"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "INSERT INTO ActivityLog (ActivityType, Description, CreatedDate) " +
                                   "VALUES (@type, @desc, GETDATE())";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@type", activityType);
                        cmd.Parameters.AddWithValue("@desc", description);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                WriteToFile("ActivityLog Failure", ex);
            }
        }

        /// <summary>
        /// Logs system errors to the database with user/session context.
        /// </summary>
        public static void LogError(string errorMessage, Exception ex)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager
                                    .ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO ErrorLogs (ErrorMessage, StackTrace, Timestamp, UserID, PageName)
                        VALUES (@ErrorMessage, @StackTrace, GETDATE(), @UserID, @PageName)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        var userId = HttpContext.Current?.Session?["UserID"];
                        cmd.Parameters.AddWithValue("@ErrorMessage", $"{errorMessage}: {ex.Message}");
                        cmd.Parameters.AddWithValue("@StackTrace", ex.StackTrace ?? "");
                        cmd.Parameters.AddWithValue("@UserID", userId ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@PageName",
                            HttpContext.Current?.Request?.Url?.AbsolutePath ?? "Unknown");

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception innerEx)
            {
                WriteToFile($"LogError Failure: {errorMessage}", innerEx);
            }
        }

        /// <summary>
        /// Logs login attempts, whether successful or failed.
        /// </summary>
        public static void LogLoginActivity(string email, string status)
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager
                                    .ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO LoginActivity (Email, Status, LoginTime, IPAddress, UserAgent)
                        VALUES (@Email, @Status, GETDATE(), @IPAddress, @UserAgent)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        var request = HttpContext.Current?.Request;
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@IPAddress", request?.UserHostAddress ?? "");
                        cmd.Parameters.AddWithValue("@UserAgent", request?.UserAgent ?? "");
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                WriteToFile("LogLoginActivity Failure", ex);
            }
        }

        /// <summary>
        /// Writes errors to a fallback log file if database logging fails.
        /// </summary>
        private static void WriteToFile(string title, Exception ex)
        {
            try
            {
                string logPath = HttpContext.Current.Server.MapPath("~/App_Data/FallbackLogs.txt");
                string message = $"{DateTime.Now:u} | {title}: {ex.Message}{Environment.NewLine}{ex.StackTrace}{Environment.NewLine}";

                System.IO.File.AppendAllText(logPath, message);
            }
            catch
            {
                // If file logging also fails, do nothing (silent fail).
            }
        }
    }
}
