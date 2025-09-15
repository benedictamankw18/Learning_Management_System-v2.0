using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;
using System.Web.Services;
using System.Data;
using System.IO.Compression;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Backup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is authenticated and is admin
                if (Session["admin"] == null)
                {
                    //Response.Redirect("../Login.aspx");
                    return;
                }

                LoadBackupStatistics();
                LoadBackupHistory();
                LoadBackupConfiguration();
            }
        }

        private void LoadBackupStatistics()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    // Get backup statistics
                    string query = @"
                        SELECT 
                            COUNT(*) as TotalBackups,
                            SUM(CASE WHEN BackupSize IS NOT NULL THEN BackupSize ELSE 0 END) as TotalSize,
                            MAX(CreatedDate) as LastBackupDate,
                            COUNT(CASE WHEN Status = 'Success' THEN 1 END) as SuccessfulBackups,
                            COUNT(CASE WHEN Status = 'Failed' THEN 1 END) as FailedBackups
                        FROM BackupHistory 
                        WHERE CreatedDate >= DATEADD(month, -1, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Statistics will be used by JavaScript/client-side
                                ViewState["TotalBackups"] = reader["TotalBackups"];
                                ViewState["TotalSize"] = reader["TotalSize"];
                                ViewState["LastBackupDate"] = reader["LastBackupDate"];
                                ViewState["SuccessfulBackups"] = reader["SuccessfulBackups"];
                                ViewState["FailedBackups"] = reader["FailedBackups"];
                            }
                        }
                    }
                }

                LogActivity("Backup statistics loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading backup statistics", ex);
            }
        }

        private void LoadBackupHistory()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT TOP 20
                            BackupId,
                            BackupName,
                            BackupType,
                            CreatedDate,
                            BackupSize,
                            Duration,
                            Status,
                            FilePath,
                            Description
                        FROM BackupHistory 
                        ORDER BY CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            ViewState["BackupHistory"] = dt;
                        }
                    }
                }

                LogActivity("Backup history loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading backup history", ex);
            }
        }

        private void LoadBackupConfiguration()
        {
            try
            {
                // Load backup configuration from database or web.config
                string frequency = ConfigurationManager.AppSettings["BackupFrequency"] ?? "daily";
                string backupTime = ConfigurationManager.AppSettings["BackupTime"] ?? "02:00";
                int retentionDays = int.Parse(ConfigurationManager.AppSettings["BackupRetentionDays"] ?? "30");
                string storageLocation = ConfigurationManager.AppSettings["BackupStorageLocation"] ?? "local";

                ViewState["BackupFrequency"] = frequency;
                ViewState["BackupTime"] = backupTime;
                ViewState["RetentionDays"] = retentionDays;
                ViewState["StorageLocation"] = storageLocation;

                LogActivity("Backup configuration loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading backup configuration", ex);
            }
        }

        [WebMethod]
        public static string CreateBackup(string backupName, string backupType, string description)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                string backupPath = HttpContext.Current.Server.MapPath("~/App_Data/Backups/");
                
                // Ensure backup directory exists
                if (!Directory.Exists(backupPath))
                {
                    Directory.CreateDirectory(backupPath);
                }

                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string fileName = $"{backupName}_{timestamp}.bak";
                string fullBackupPath = Path.Combine(backupPath, fileName);

                DateTime startTime = DateTime.Now;

                // Record backup start in database
                int backupId = InsertBackupRecord(backupName, backupType, description, "Running");

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    
                    string backupQuery = "";
                    
                    switch (backupType.ToLower())
                    {
                        case "full":
                            backupQuery = $@"
                                BACKUP DATABASE LearningManagementSystem 
                                TO DISK = '{fullBackupPath}'
                                WITH FORMAT, INIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10";
                            break;
                            
                        case "incremental":
                            backupQuery = $@"
                                BACKUP LOG LearningManagementSystem 
                                TO DISK = '{fullBackupPath}'
                                WITH NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10";
                            break;
                            
                        case "differential":
                            backupQuery = $@"
                                BACKUP DATABASE LearningManagementSystem 
                                TO DISK = '{fullBackupPath}'
                                WITH DIFFERENTIAL, FORMAT, INIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10";
                            break;
                    }

                    using (SqlCommand cmd = new SqlCommand(backupQuery, con))
                    {
                        cmd.CommandTimeout = 1800; // 30 minutes timeout
                        cmd.ExecuteNonQuery();
                    }
                }

                DateTime endTime = DateTime.Now;
                TimeSpan duration = endTime - startTime;
                
                // Get file size
                FileInfo fileInfo = new FileInfo(fullBackupPath);
                long fileSize = fileInfo.Length;

                // Update backup record with completion details
                UpdateBackupRecord(backupId, "Success", fileSize, duration, fullBackupPath);

                // Log successful backup
                LogBackupActivity($"Backup created successfully: {fileName}", "Success");

                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error creating backup", ex);
                return "error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string RestoreBackup(string backupName)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                
                // Get backup file path from database
                string backupFilePath = GetBackupFilePath(backupName);
                
                if (string.IsNullOrEmpty(backupFilePath) || !File.Exists(backupFilePath))
                {
                    return "error: Backup file not found";
                }

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    
                    // Set database to single user mode
                    string singleUserQuery = @"
                        ALTER DATABASE LearningManagementSystem 
                        SET SINGLE_USER WITH ROLLBACK IMMEDIATE";
                    
                    using (SqlCommand cmd = new SqlCommand(singleUserQuery, con))
                    {
                        cmd.ExecuteNonQuery();
                    }

                    // Restore database
                    string restoreQuery = $@"
                        RESTORE DATABASE LearningManagementSystem 
                        FROM DISK = '{backupFilePath}'
                        WITH REPLACE, STATS = 10";

                    using (SqlCommand cmd = new SqlCommand(restoreQuery, con))
                    {
                        cmd.CommandTimeout = 3600; // 1 hour timeout
                        cmd.ExecuteNonQuery();
                    }

                    // Set database back to multi-user mode
                    string multiUserQuery = @"
                        ALTER DATABASE LearningManagementSystem 
                        SET MULTI_USER";
                    
                    using (SqlCommand cmd = new SqlCommand(multiUserQuery, con))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }

                LogBackupActivity($"Database restored from backup: {backupName}", "Success");
                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error restoring backup", ex);
                return "error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string DeleteBackup(string backupName)
        {
            try
            {
                string backupFilePath = GetBackupFilePath(backupName);
                
                // Delete physical file
                if (!string.IsNullOrEmpty(backupFilePath) && File.Exists(backupFilePath))
                {
                    File.Delete(backupFilePath);
                }

                // Delete database record
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = "DELETE FROM BackupHistory WHERE BackupName = @BackupName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@BackupName", backupName);
                        cmd.ExecuteNonQuery();
                    }
                }

                LogBackupActivity($"Backup deleted: {backupName}", "Success");
                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error deleting backup", ex);
                return "error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string SaveBackupConfiguration(string frequency, string backupTime, 
            int retentionDays, string compressionLevel, string storageLocation, int maxBackupFiles)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        UPDATE BackupConfiguration 
                        SET Frequency = @Frequency,
                            BackupTime = @BackupTime,
                            RetentionDays = @RetentionDays,
                            CompressionLevel = @CompressionLevel,
                            StorageLocation = @StorageLocation,
                            MaxBackupFiles = @MaxBackupFiles,
                            LastModified = GETDATE()
                        WHERE ConfigId = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Frequency", frequency);
                        cmd.Parameters.AddWithValue("@BackupTime", backupTime);
                        cmd.Parameters.AddWithValue("@RetentionDays", retentionDays);
                        cmd.Parameters.AddWithValue("@CompressionLevel", compressionLevel);
                        cmd.Parameters.AddWithValue("@StorageLocation", storageLocation);
                        cmd.Parameters.AddWithValue("@MaxBackupFiles", maxBackupFiles);

                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        if (rowsAffected == 0)
                        {
                            // Insert if record doesn't exist
                            string insertQuery = @"
                                INSERT INTO BackupConfiguration 
                                (ConfigId, Frequency, BackupTime, RetentionDays, CompressionLevel, 
                                 StorageLocation, MaxBackupFiles, LastModified)
                                VALUES (1, @Frequency, @BackupTime, @RetentionDays, @CompressionLevel, 
                                        @StorageLocation, @MaxBackupFiles, GETDATE())";
                            
                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, con))
                            {
                                insertCmd.Parameters.AddWithValue("@Frequency", frequency);
                                insertCmd.Parameters.AddWithValue("@BackupTime", backupTime);
                                insertCmd.Parameters.AddWithValue("@RetentionDays", retentionDays);
                                insertCmd.Parameters.AddWithValue("@CompressionLevel", compressionLevel);
                                insertCmd.Parameters.AddWithValue("@StorageLocation", storageLocation);
                                insertCmd.Parameters.AddWithValue("@MaxBackupFiles", maxBackupFiles);
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                LogActivity("Backup configuration saved successfully");
                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error saving backup configuration", ex);
                return "error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string GetBackupStatistics()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT 
                            COUNT(*) as TotalBackups,
                            SUM(CASE WHEN BackupSize IS NOT NULL THEN BackupSize ELSE 0 END) as TotalSize,
                            MAX(CreatedDate) as LastBackupDate,
                            COUNT(CASE WHEN Status = 'Success' THEN 1 END) as SuccessfulBackups,
                            COUNT(CASE WHEN Status = 'Failed' THEN 1 END) as FailedBackups,
                            AVG(DATEDIFF(second, CreatedDate, CompletedDate)) as AverageDuration
                        FROM BackupHistory 
                        WHERE CreatedDate >= DATEADD(month, -1, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                var stats = new
                                {
                                    TotalBackups = reader["TotalBackups"],
                                    TotalSize = FormatFileSize(Convert.ToInt64(reader["TotalSize"] ?? 0)),
                                    LastBackupDate = reader["LastBackupDate"],
                                    SuccessfulBackups = reader["SuccessfulBackups"],
                                    FailedBackups = reader["FailedBackups"],
                                    AverageDuration = reader["AverageDuration"]
                                };

                                return Newtonsoft.Json.JsonConvert.SerializeObject(stats);
                            }
                        }
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string CleanupOldBackups()
        {
            try
            {
                int retentionDays = int.Parse(ConfigurationManager.AppSettings["BackupRetentionDays"] ?? "30");
                DateTime cutoffDate = DateTime.Now.AddDays(-retentionDays);

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    // Get old backup files
                    string selectQuery = @"
                        SELECT BackupName, FilePath 
                        FROM BackupHistory 
                        WHERE CreatedDate < @CutoffDate AND Status = 'Success'";

                    List<string> filesToDelete = new List<string>();
                    
                    using (SqlCommand cmd = new SqlCommand(selectQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@CutoffDate", cutoffDate);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string filePath = reader["FilePath"].ToString();
                                if (!string.IsNullOrEmpty(filePath))
                                {
                                    filesToDelete.Add(filePath);
                                }
                            }
                        }
                    }

                    // Delete physical files
                    int deletedFiles = 0;
                    foreach (string filePath in filesToDelete)
                    {
                        try
                        {
                            if (File.Exists(filePath))
                            {
                                File.Delete(filePath);
                                deletedFiles++;
                            }
                        }
                        catch
                        {
                            // Continue with other files if one fails
                        }
                    }

                    // Delete database records
                    string deleteQuery = @"
                        DELETE FROM BackupHistory 
                        WHERE CreatedDate < @CutoffDate";

                    using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@CutoffDate", cutoffDate);
                        int deletedRecords = cmd.ExecuteNonQuery();
                        
                        LogActivity($"Cleanup completed: {deletedRecords} records and {deletedFiles} files deleted");
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error during backup cleanup", ex);
                return "error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string VerifyBackupIntegrity(string backupName)
        {
            try
            {
                string backupFilePath = GetBackupFilePath(backupName);
                
                if (string.IsNullOrEmpty(backupFilePath) || !File.Exists(backupFilePath))
                {
                    return "error: Backup file not found";
                }

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string verifyQuery = $@"
                        RESTORE VERIFYONLY 
                        FROM DISK = '{backupFilePath}'";

                    using (SqlCommand cmd = new SqlCommand(verifyQuery, con))
                    {
                        cmd.CommandTimeout = 600; // 10 minutes timeout
                        cmd.ExecuteNonQuery();
                    }
                }

                LogActivity($"Backup integrity verified: {backupName}");
                return "success";
            }
            catch (Exception ex)
            {
                LogError($"Backup integrity check failed for {backupName}", ex);
                return "error: " + ex.Message;
            }
        }

        private static int InsertBackupRecord(string backupName, string backupType, string description, string status)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
            {
                con.Open();
                
                string query = @"
                    INSERT INTO BackupHistory 
                    (BackupName, BackupType, Description, Status, CreatedDate, CreatedBy)
                    OUTPUT INSERTED.BackupId
                    VALUES (@BackupName, @BackupType, @Description, @Status, GETDATE(), @UserId)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BackupName", backupName);
                    cmd.Parameters.AddWithValue("@BackupType", backupType);
                    cmd.Parameters.AddWithValue("@Description", description ?? "");
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@UserId", HttpContext.Current.Session["adminId"] ?? 0);

                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private static void UpdateBackupRecord(int backupId, string status, long fileSize, TimeSpan duration, string filePath)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
            {
                con.Open();
                
                string query = @"
                    UPDATE BackupHistory 
                    SET Status = @Status,
                        BackupSize = @BackupSize,
                        Duration = @Duration,
                        FilePath = @FilePath,
                        CompletedDate = GETDATE()
                    WHERE BackupId = @BackupId";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BackupId", backupId);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@BackupSize", fileSize);
                    cmd.Parameters.AddWithValue("@Duration", (int)duration.TotalSeconds);
                    cmd.Parameters.AddWithValue("@FilePath", filePath);

                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static string GetBackupFilePath(string backupName)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
            {
                con.Open();
                
                string query = "SELECT FilePath FROM BackupHistory WHERE BackupName = @BackupName";
                
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BackupName", backupName);
                    return cmd.ExecuteScalar()?.ToString();
                }
            }
        }

        private static string FormatFileSize(long bytes)
        {
            string[] suffixes = { "B", "KB", "MB", "GB", "TB" };
            int counter = 0;
            decimal number = bytes;
            
            while (Math.Round(number / 1024) >= 1)
            {
                number = number / 1024;
                counter++;
            }
            
            return string.Format("{0:n1} {1}", number, suffixes[counter]);
        }

        private static void LogActivity(string activity)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        INSERT INTO SystemLogs (LogType, Activity, Timestamp, UserId)
                        VALUES ('Info', @Activity, GETDATE(), @UserId)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Activity", activity);
                        cmd.Parameters.AddWithValue("@UserId", HttpContext.Current.Session["adminId"] ?? 0);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Fail silently for logging errors
            }
        }

        private static void LogError(string message, Exception ex)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        INSERT INTO SystemLogs (LogType, Activity, ErrorMessage, Timestamp, UserId)
                        VALUES ('Error', @Activity, @ErrorMessage, GETDATE(), @UserId)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Activity", message);
                        cmd.Parameters.AddWithValue("@ErrorMessage", ex.ToString());
                        cmd.Parameters.AddWithValue("@UserId", HttpContext.Current.Session["adminId"] ?? 0);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Fail silently for logging errors
            }
        }

        private static void LogBackupActivity(string activity, string status)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        INSERT INTO BackupLogs (Activity, Status, Timestamp, UserId)
                        VALUES (@Activity, @Status, GETDATE(), @UserId)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Activity", activity);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@UserId", HttpContext.Current.Session["adminId"] ?? 0);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Fail silently for logging errors
            }
        }
    }
}