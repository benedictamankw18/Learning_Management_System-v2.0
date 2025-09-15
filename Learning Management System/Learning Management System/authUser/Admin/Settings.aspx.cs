using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;
using System.Net;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Settings : System.Web.UI.Page
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

                LoadSystemSettings();
                LoadSecuritySettings();
                LoadNotificationSettings();
                LoadBackupSettings();
            }
        }

        private void LoadSystemSettings()
        {
            try
            {
                // Load general system settings from database or configuration
                // This could include institution info, localization settings, etc.
                
                // Example: Load from web.config or database
                string institutionName = ConfigurationManager.AppSettings["InstitutionName"] ?? "University of Education, Winneba";
                string institutionCode = ConfigurationManager.AppSettings["InstitutionCode"] ?? "UEW";
                string contactEmail = ConfigurationManager.AppSettings["ContactEmail"] ?? "admin@uew.edu.gh";
                
                // Log system settings loaded
                LogActivity("System settings loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading system settings", ex);
            }
        }

        private void LoadSecuritySettings()
        {
            try
            {
                // Load security configurations
                bool twoFactorEnabled = bool.Parse(ConfigurationManager.AppSettings["TwoFactorEnabled"] ?? "true");
                bool strongPasswordPolicy = bool.Parse(ConfigurationManager.AppSettings["StrongPasswordPolicy"] ?? "true");
                int sessionTimeout = int.Parse(ConfigurationManager.AppSettings["SessionTimeout"] ?? "30");
                
                LogActivity("Security settings loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading security settings", ex);
            }
        }

        private void LoadNotificationSettings()
        {
            try
            {
                // Load notification and email settings
                string smtpServer = ConfigurationManager.AppSettings["SMTPServer"] ?? "smtp.gmail.com";
                string smtpPort = ConfigurationManager.AppSettings["SMTPPort"] ?? "587";
                string smtpUsername = ConfigurationManager.AppSettings["SMTPUsername"] ?? "noreply@uew.edu.gh";
                
                LogActivity("Notification settings loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading notification settings", ex);
            }
        }

        private void LoadBackupSettings()
        {
            try
            {
                // Load backup configuration
                string backupFrequency = ConfigurationManager.AppSettings["BackupFrequency"] ?? "daily";
                string backupTime = ConfigurationManager.AppSettings["BackupTime"] ?? "23:30";
                int retentionPeriod = int.Parse(ConfigurationManager.AppSettings["BackupRetentionDays"] ?? "30");
                
                LogActivity("Backup settings loaded successfully");
            }
            catch (Exception ex)
            {
                LogError("Error loading backup settings", ex);
            }
        }

        [System.Web.Services.WebMethod]
        public static string SaveGeneralSettings(string institutionName, string institutionCode, 
            string contactEmail, string contactPhone, string address, string language, 
            string timeZone, string dateFormat, string currency)
        {
            try
            {
                // Comprehensive server-side validation
                var validationResult = ValidateGeneralSettings(institutionName, institutionCode, 
                    contactEmail, contactPhone, address, language, timeZone, dateFormat, currency);
                
                if (!validationResult.IsValid)
                {
                    return "validation_error: " + string.Join("; ", validationResult.Errors);
                }

                // Sanitize inputs
                institutionName = SanitizeInput(institutionName);
                institutionCode = SanitizeInput(institutionCode).ToUpper();
                contactEmail = SanitizeInput(contactEmail).ToLower();
                contactPhone = SanitizeInput(contactPhone);
                address = SanitizeInput(address);

                // Save general settings to database or configuration
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        UPDATE SystemSettings 
                        SET InstitutionName = @InstitutionName,
                            InstitutionCode = @InstitutionCode,
                            ContactEmail = @ContactEmail,
                            ContactPhone = @ContactPhone,
                            Address = @Address,
                            DefaultLanguage = @Language,
                            TimeZone = @TimeZone,
                            DateFormat = @DateFormat,
                            Currency = @Currency,
                            LastModified = GETDATE()
                        WHERE SettingId = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@InstitutionName", institutionName);
                        cmd.Parameters.AddWithValue("@InstitutionCode", institutionCode);
                        cmd.Parameters.AddWithValue("@ContactEmail", contactEmail);
                        cmd.Parameters.AddWithValue("@ContactPhone", contactPhone);
                        cmd.Parameters.AddWithValue("@Address", address);
                        cmd.Parameters.AddWithValue("@Language", language);
                        cmd.Parameters.AddWithValue("@TimeZone", timeZone);
                        cmd.Parameters.AddWithValue("@DateFormat", dateFormat);
                        cmd.Parameters.AddWithValue("@Currency", currency);

                        cmd.ExecuteNonQuery();
                    }
                }

                LogActivity($"General settings updated: {institutionName}");
                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error saving general settings", ex);
                return "error: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string SaveSecuritySettings(bool twoFactorAuth, bool strongPassword, 
            bool sessionTimeout, int timeoutMinutes, int maxLoginAttempts)
        {
            try
            {
                // Comprehensive server-side validation
                var validationResult = ValidateSecuritySettings(twoFactorAuth, strongPassword, 
                    sessionTimeout, timeoutMinutes, maxLoginAttempts);
                
                if (!validationResult.IsValid)
                {
                    return "validation_error: " + string.Join("; ", validationResult.Errors);
                }

                // Save security settings
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        UPDATE SecuritySettings 
                        SET TwoFactorEnabled = @TwoFactorEnabled,
                            StrongPasswordPolicy = @StrongPasswordPolicy,
                            SessionTimeoutEnabled = @SessionTimeoutEnabled,
                            SessionTimeoutMinutes = @TimeoutMinutes,
                            MaxLoginAttempts = @MaxLoginAttempts,
                            LastModified = GETDATE()
                        WHERE SettingId = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@TwoFactorEnabled", twoFactorAuth);
                        cmd.Parameters.AddWithValue("@StrongPasswordPolicy", strongPassword);
                        cmd.Parameters.AddWithValue("@SessionTimeoutEnabled", sessionTimeout);
                        cmd.Parameters.AddWithValue("@TimeoutMinutes", timeoutMinutes);
                        cmd.Parameters.AddWithValue("@MaxLoginAttempts", maxLoginAttempts);

                        cmd.ExecuteNonQuery();
                    }
                }

                LogActivity($"Security settings updated by admin");
                return "success";
            }
            catch (Exception ex)
            {
                LogError("Error saving security settings", ex);
                return "error: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string RegenerateApiKey()
        {
            try
            {
                // Check authorization
                if (!IsAuthorizedAdmin())
                {
                    return "error: Unauthorized access";
                }

                // Generate new API key
                string newApiKey = GenerateSecureApiKey();
                
                // Save to database
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    // First, invalidate old keys
                    string invalidateQuery = @"
                        UPDATE ApiKeys 
                        SET IsActive = 0, 
                            DeactivatedDate = GETDATE() 
                        WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(invalidateQuery, con))
                    {
                        cmd.ExecuteNonQuery();
                    }

                    // Insert new API key
                    string insertQuery = @"
                        INSERT INTO ApiKeys (KeyValue, CreatedDate, ExpiryDate, IsActive, CreatedBy, KeyType, RateLimit)
                        VALUES (@KeyValue, GETDATE(), DATEADD(YEAR, 1, GETDATE()), 1, @CreatedBy, 'Admin', 1000)";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@KeyValue", newApiKey);
                        cmd.Parameters.AddWithValue("@CreatedBy", HttpContext.Current.Session["adminId"] ?? 0);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Log the action
                LogActivity($"API key regenerated by admin");

                return "success: " + newApiKey;
            }
            catch (Exception ex)
            {
                LogError("Error regenerating API key", ex);
                return "error: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetCurrentApiKey()
        {
            try
            {
                if (!IsAuthorizedAdmin())
                {
                    return "error: Unauthorized access";
                }

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT TOP 1 KeyValue, CreatedDate, ExpiryDate, LastUsed, TotalRequests, RequestsToday
                        FROM ApiKeys 
                        WHERE IsActive = 1 
                        ORDER BY CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                var keyInfo = new
                                {
                                    keyValue = reader["KeyValue"].ToString(),
                                    createdDate = reader["CreatedDate"].ToString(),
                                    expiryDate = reader["ExpiryDate"].ToString(),
                                    lastUsed = reader["LastUsed"]?.ToString() ?? "Never",
                                    totalRequests = reader["TotalRequests"]?.ToString() ?? "0",
                                    requestsToday = reader["RequestsToday"]?.ToString() ?? "0"
                                };

                                return "success: " + Newtonsoft.Json.JsonConvert.SerializeObject(keyInfo);
                            }
                        }
                    }
                }

                return "error: No active API key found";
            }
            catch (Exception ex)
            {
                LogError("Error retrieving API key", ex);
                return "error: " + ex.Message;
            }
        }

        private static string GenerateSecureApiKey()
        {
            // Generate a cryptographically secure API key
            using (var rng = new System.Security.Cryptography.RNGCryptoServiceProvider())
            {
                // Create components for the API key
                string prefix = "lms_api";
                string timestamp = DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString("x");
                
                // Generate random bytes for the key
                byte[] randomBytes = new byte[32];
                rng.GetBytes(randomBytes);
                string randomPart = Convert.ToBase64String(randomBytes)
                    .Replace("+", "")
                    .Replace("/", "")
                    .Replace("=", "")
                    .Substring(0, 32);

                // Generate additional entropy
                byte[] entropyBytes = new byte[16];
                rng.GetBytes(entropyBytes);
                string entropy = Convert.ToBase64String(entropyBytes)
                    .Replace("+", "")
                    .Replace("/", "")
                    .Replace("=", "")
                    .Substring(0, 16);

                // Create checksum
                string dataToHash = timestamp + randomPart + entropy;
                string checksum = ComputeChecksum(dataToHash);

                // Combine all parts
                return $"{prefix}_{timestamp}_{randomPart}_{entropy}_{checksum}";
            }
        }

        private static bool IsAuthorizedAdmin()
        {
            var session = HttpContext.Current.Session;
            return session != null && session["admin"] != null;
        }

        private static string ComputeChecksum(string input)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] hashBytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(input));
                return Convert.ToBase64String(hashBytes)
                    .Replace("+", "")
                    .Replace("/", "")
                    .Replace("=", "")
                    .Substring(0, 12);
            }
        }

        [System.Web.Services.WebMethod]
        public static string TestEmailConnection(string smtpServer, int smtpPort, 
            string username, string password, bool enableSSL)
        {
            try
            {
                using (SmtpClient client = new SmtpClient(smtpServer, smtpPort))
                {
                    client.EnableSsl = enableSSL;
                    client.Credentials = new NetworkCredential(username, password);
                    client.Timeout = 10000; // 10 seconds timeout

                    // Create a test message
                    MailMessage testMessage = new MailMessage();
                    testMessage.From = new MailAddress(username);
                    testMessage.To.Add(username); // Send to self for testing
                    testMessage.Subject = "LMS Email Configuration Test";
                    testMessage.Body = "This is a test email to verify SMTP configuration.";

                    client.Send(testMessage);
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string CreateSystemBackup()
        {
            try
            {
                // Validate backup configuration first
                var configValidation = ValidateBackupConfiguration();
                if (!configValidation.IsValid)
                {
                    return "validation_error: " + string.Join("; ", configValidation.Errors);
                }

                // Check authorization
                if (!IsAuthorizedAdmin())
                {
                    return "error: Unauthorized access";
                }

                // Get backup configuration
                var backupConfig = GetBackupConfiguration();
                
                // Validate storage availability
                if (!ValidateStorageLocation(backupConfig.StorageLocation))
                {
                    return "error: Storage location is not available or insufficient space";
                }

                string backupPath = PrepareBackupPath(backupConfig.StorageLocation);
                
                if (!Directory.Exists(Path.GetDirectoryName(backupPath)))
                {
                    Directory.CreateDirectory(Path.GetDirectoryName(backupPath));
                }

                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string backupFileName = $"LMS_Backup_{timestamp}.bak";
                string fullBackupPath = Path.Combine(backupPath, backupFileName);

                // Create database backup with validation
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    // First validate database state
                    if (!ValidateDatabaseState(con))
                    {
                        return "error: Database is not in a valid state for backup";
                    }
                    
                    string backupQuery = $@"
                        BACKUP DATABASE LearningManagementSystem 
                        TO DISK = '{fullBackupPath}'
                        WITH FORMAT, INIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10,
                        CHECKSUM, VERIFY";

                    using (SqlCommand cmd = new SqlCommand(backupQuery, con))
                    {
                        cmd.CommandTimeout = 1800; // 30 minutes timeout
                        cmd.ExecuteNonQuery();
                    }

                    // Verify backup was created successfully
                    if (!File.Exists(fullBackupPath))
                    {
                        return "error: Backup file was not created successfully";
                    }

                    // Get backup file info
                    FileInfo backupFile = new FileInfo(fullBackupPath);
                    long backupSizeBytes = backupFile.Length;
                    string backupSizeMB = (backupSizeBytes / (1024.0 * 1024.0)).ToString("F1");

                    // Record backup in database
                    RecordBackupInDatabase(backupFileName, backupSizeBytes, fullBackupPath, backupConfig);
                }

                // Log backup creation
                LogBackupActivity($"Manual backup created: {backupFileName}");

                return "success: " + backupFileName;
            }
            catch (Exception ex)
            {
                LogError("Error creating system backup", ex);
                return "error: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string ValidateBackupConfigurationWeb()
        {
            try
            {
                var validation = ValidateBackupConfiguration();
                var result = new
                {
                    isValid = validation.IsValid,
                    errors = validation.Errors,
                    warnings = GetBackupWarnings()
                };

                return "success: " + Newtonsoft.Json.JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                LogError("Error validating backup configuration", ex);
                return "error: " + ex.Message;
            }
        }

        private static ValidationResult ValidateBackupConfiguration()
        {
            var result = new ValidationResult { IsValid = true };

            try
            {
                // Check if backup settings exist
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT StorageLocation, RetentionDays, BackupFrequency 
                        FROM BackupSettings 
                        WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storageLocation = reader["StorageLocation"]?.ToString();
                                int retentionDays = Convert.ToInt32(reader["RetentionDays"] ?? 30);
                                string frequency = reader["BackupFrequency"]?.ToString();

                                // Validate storage location
                                if (string.IsNullOrEmpty(storageLocation))
                                {
                                    result.IsValid = false;
                                    result.Errors.Add("Storage location is not configured");
                                }

                                // Validate retention period
                                if (retentionDays < 7 || retentionDays > 365)
                                {
                                    result.IsValid = false;
                                    result.Errors.Add("Retention period must be between 7 and 365 days");
                                }

                                // Validate storage space
                                if (!ValidateStorageSpace(storageLocation))
                                {
                                    result.IsValid = false;
                                    result.Errors.Add("Insufficient storage space for backup");
                                }
                            }
                            else
                            {
                                result.IsValid = false;
                                result.Errors.Add("Backup configuration not found");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                result.IsValid = false;
                result.Errors.Add("Error validating configuration: " + ex.Message);
            }

            return result;
        }

        private static List<string> GetBackupWarnings()
        {
            var warnings = new List<string>();

            try
            {
                // Check disk space
                var drives = DriveInfo.GetDrives();
                foreach (var drive in drives)
                {
                    if (drive.IsReady && drive.DriveType == DriveType.Fixed)
                    {
                        long freeSpaceGB = drive.TotalFreeSpace / (1024 * 1024 * 1024);
                        if (freeSpaceGB < 5)
                        {
                            warnings.Add($"Low disk space on {drive.Name} ({freeSpaceGB}GB free)");
                        }
                    }
                }

                // Check last backup age
                DateTime lastBackup = GetLastBackupDate();
                if ((DateTime.Now - lastBackup).TotalDays > 7)
                {
                    warnings.Add("Last backup is more than 7 days old");
                }

                // Check database size
                long dbSizeGB = GetDatabaseSizeGB();
                if (dbSizeGB > 10)
                {
                    warnings.Add($"Large database size ({dbSizeGB}GB) - backup may take longer");
                }
            }
            catch (Exception ex)
            {
                warnings.Add("Warning: Could not validate all backup prerequisites");
            }

            return warnings;
        }

        private static BackupConfiguration GetBackupConfiguration()
        {
            var config = new BackupConfiguration();

            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        SELECT StorageLocation, RetentionDays, BackupFrequency, BackupTime 
                        FROM BackupSettings 
                        WHERE IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                config.StorageLocation = reader["StorageLocation"]?.ToString() ?? "local";
                                config.RetentionDays = Convert.ToInt32(reader["RetentionDays"] ?? 30);
                                config.Frequency = reader["BackupFrequency"]?.ToString() ?? "daily";
                                config.Time = reader["BackupTime"]?.ToString() ?? "23:30";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("Error getting backup configuration", ex);
                // Use default values
                config.StorageLocation = "cloud";
                config.RetentionDays = 30;
                config.Frequency = "daily";
                config.Time = "23:30";
            }

            return config;
        }

        private static bool ValidateStorageLocation(string location)
        {
            try
            {
                switch (location?.ToLower())
                {
                    case "local":
                        string localPath = HttpContext.Current.Server.MapPath("~/App_Data/Backups/");
                        return Directory.Exists(Path.GetDirectoryName(localPath)) || 
                               TryCreateDirectory(localPath);

                    case "cloud":
                        // In a real implementation, validate cloud storage credentials
                        return ValidateCloudStorage();

                    case "external":
                        // In a real implementation, check if external drive is connected
                        return ValidateExternalStorage();

                    default:
                        return false;
                }
            }
            catch
            {
                return false;
            }
        }

        private static bool ValidateStorageSpace(string location)
        {
            try
            {
                long requiredSpaceBytes = GetEstimatedBackupSize();
                
                switch (location?.ToLower())
                {
                    case "local":
                        string path = HttpContext.Current.Server.MapPath("~/App_Data/Backups/");
                        DriveInfo drive = new DriveInfo(Path.GetPathRoot(path));
                        return drive.TotalFreeSpace > requiredSpaceBytes * 1.2; // 20% buffer

                    case "cloud":
                        return ValidateCloudStorageSpace(requiredSpaceBytes);

                    case "external":
                        return ValidateExternalStorageSpace(requiredSpaceBytes);

                    default:
                        return false;
                }
            }
            catch
            {
                return false;
            }
        }

        private static bool ValidateDatabaseState(SqlConnection connection)
        {
            try
            {
                string query = "SELECT DATABASEPROPERTYEX('LearningManagementSystem', 'Status')";
                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    string status = cmd.ExecuteScalar()?.ToString();
                    return status?.ToUpper() == "ONLINE";
                }
            }
            catch
            {
                return false;
            }
        }

        private static void RecordBackupInDatabase(string fileName, long sizeBytes, string path, BackupConfiguration config)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        INSERT INTO BackupHistory (FileName, FilePath, SizeBytes, CreatedDate, BackupType, Status, StorageLocation)
                        VALUES (@FileName, @FilePath, @SizeBytes, GETDATE(), 'Manual', 'Success', @StorageLocation)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@FileName", fileName);
                        cmd.Parameters.AddWithValue("@FilePath", path);
                        cmd.Parameters.AddWithValue("@SizeBytes", sizeBytes);
                        cmd.Parameters.AddWithValue("@StorageLocation", config.StorageLocation);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("Error recording backup in database", ex);
            }
        }

        // Helper methods and classes
        public class BackupConfiguration
        {
            public string StorageLocation { get; set; }
            public int RetentionDays { get; set; }
            public string Frequency { get; set; }
            public string Time { get; set; }
        }

        private static string PrepareBackupPath(string storageLocation)
        {
            switch (storageLocation?.ToLower())
            {
                case "local":
                    return HttpContext.Current.Server.MapPath("~/App_Data/Backups/");
                case "cloud":
                    return GetCloudBackupPath();
                case "external":
                    return GetExternalBackupPath();
                default:
                    return HttpContext.Current.Server.MapPath("~/App_Data/Backups/");
            }
        }

        private static bool TryCreateDirectory(string path)
        {
            try
            {
                Directory.CreateDirectory(path);
                return true;
            }
            catch
            {
                return false;
            }
        }

        private static bool ValidateCloudStorage() => true; // Implement cloud validation
        private static bool ValidateExternalStorage() => true; // Implement external storage validation
        private static bool ValidateCloudStorageSpace(long required) => true; // Implement cloud space check
        private static bool ValidateExternalStorageSpace(long required) => true; // Implement external space check
        private static long GetEstimatedBackupSize() => 3L * 1024 * 1024 * 1024; // 3GB estimate
        private static DateTime GetLastBackupDate() => DateTime.Now.AddDays(-1); // Get from database
        private static long GetDatabaseSizeGB() => 2; // Get actual database size
        private static string GetCloudBackupPath() => "~/App_Data/Backups/"; // Cloud path logic
        private static string GetExternalBackupPath() => "~/App_Data/Backups/"; // External path logic

        [System.Web.Services.WebMethod]
        public static string ClearSystemCache()
        {
            try
            {
                // Clear application cache
                HttpContext.Current.Cache.Insert("CacheCleared", DateTime.Now);
                
                // Clear session cache if needed
                // HttpContext.Current.Session.Clear(); // Be careful with this

                // Clear temporary files
                string tempPath = HttpContext.Current.Server.MapPath("~/App_Data/Temp/");
                if (Directory.Exists(tempPath))
                {
                    DirectoryInfo di = new DirectoryInfo(tempPath);
                    foreach (FileInfo file in di.GetFiles())
                    {
                        if (file.CreationTime < DateTime.Now.AddDays(-1)) // Delete files older than 1 day
                        {
                            file.Delete();
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

        [System.Web.Services.WebMethod]
        public static string OptimizeDatabase()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    // Update statistics
                    string updateStatsQuery = "EXEC sp_updatestats";
                    using (SqlCommand cmd = new SqlCommand(updateStatsQuery, con))
                    {
                        cmd.CommandTimeout = 300;
                        cmd.ExecuteNonQuery();
                    }

                    // Rebuild indexes
                    string rebuildIndexQuery = @"
                        DECLARE @TableName NVARCHAR(255)
                        DECLARE table_cursor CURSOR FOR
                        SELECT TABLE_NAME 
                        FROM INFORMATION_SCHEMA.TABLES 
                        WHERE TABLE_TYPE = 'BASE TABLE'

                        OPEN table_cursor
                        FETCH NEXT FROM table_cursor INTO @TableName

                        WHILE @@FETCH_STATUS = 0
                        BEGIN
                            EXEC('ALTER INDEX ALL ON ' + @TableName + ' REBUILD')
                            FETCH NEXT FROM table_cursor INTO @TableName
                        END

                        CLOSE table_cursor
                        DEALLOCATE table_cursor";

                    using (SqlCommand cmd = new SqlCommand(rebuildIndexQuery, con))
                    {
                        cmd.CommandTimeout = 600; // 10 minutes timeout
                        cmd.ExecuteNonQuery();
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetSystemHealthStatus()
        {
            try
            {
                var healthStatus = new
                {
                    DatabaseStatus = CheckDatabaseHealth(),
                    DiskSpace = GetDiskSpaceInfo(),
                    MemoryUsage = GetMemoryUsage(),
                    ActiveSessions = GetActiveSessionCount(),
                    SystemUptime = GetSystemUptime()
                };

                return Newtonsoft.Json.JsonConvert.SerializeObject(healthStatus);
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        private static bool CheckDatabaseHealth()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }

        private static string GetDiskSpaceInfo()
        {
            try
            {
                DriveInfo drive = new DriveInfo(Path.GetPathRoot(HttpContext.Current.Server.MapPath("~")));
                long totalSpace = drive.TotalSize;
                long freeSpace = drive.TotalFreeSpace;
                double usagePercentage = ((double)(totalSpace - freeSpace) / totalSpace) * 100;
                
                return $"{usagePercentage:F1}% used";
            }
            catch
            {
                return "Unknown";
            }
        }

        private static string GetMemoryUsage()
        {
            try
            {
                long workingSet = System.Diagnostics.Process.GetCurrentProcess().WorkingSet64;
                return $"{workingSet / (1024 * 1024)} MB";
            }
            catch
            {
                return "Unknown";
            }
        }

        private static int GetActiveSessionCount()
        {
            try
            {
                // This is a simplified count - in a real application, you'd query your session store
                return HttpContext.Current.Session.Count;
            }
            catch
            {
                return 0;
            }
        }

        private static string GetSystemUptime()
        {
            try
            {
                TimeSpan uptime = TimeSpan.FromMilliseconds(Environment.TickCount);
                return $"{uptime.Days}d {uptime.Hours}h {uptime.Minutes}m";
            }
            catch
            {
                return "Unknown";
            }
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

        private static void LogBackupActivity(string activity)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    
                    string query = @"
                        INSERT INTO BackupLogs (Activity, Timestamp, Status)
                        VALUES (@Activity, GETDATE(), 'Success')";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Activity", activity);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Fail silently for logging errors
            }
        }

        // Validation Helper Classes and Methods
        public class ValidationResult
        {
            public bool IsValid { get; set; }
            public List<string> Errors { get; set; } = new List<string>();
        }

        private static ValidationResult ValidateGeneralSettings(string institutionName, string institutionCode,
            string contactEmail, string contactPhone, string address, string language,
            string timeZone, string dateFormat, string currency)
        {
            var result = new ValidationResult { IsValid = true };

            // Institution Name validation
            if (string.IsNullOrWhiteSpace(institutionName) || institutionName.Length < 3 || institutionName.Length > 100)
            {
                result.IsValid = false;
                result.Errors.Add("Institution name must be between 3 and 100 characters");
            }

            // Institution Code validation
            if (string.IsNullOrWhiteSpace(institutionCode) || institutionCode.Length < 2 || institutionCode.Length > 10)
            {
                result.IsValid = false;
                result.Errors.Add("Institution code must be between 2 and 10 characters");
            }
            else if (!System.Text.RegularExpressions.Regex.IsMatch(institutionCode, @"^[A-Z0-9]+$"))
            {
                result.IsValid = false;
                result.Errors.Add("Institution code must contain only uppercase letters and numbers");
            }

            // Email validation
            if (!string.IsNullOrWhiteSpace(contactEmail) && !IsValidEmail(contactEmail))
            {
                result.IsValid = false;
                result.Errors.Add("Contact email is not in a valid format");
            }

            // Phone validation
            if (!string.IsNullOrWhiteSpace(contactPhone) && !IsValidPhone(contactPhone))
            {
                result.IsValid = false;
                result.Errors.Add("Contact phone number is not in a valid format");
            }

            // Address validation
            if (string.IsNullOrWhiteSpace(address) || address.Length < 10 || address.Length > 500)
            {
                result.IsValid = false;
                result.Errors.Add("Address must be between 10 and 500 characters");
            }

            // Language validation
            var validLanguages = new[] { "en", "tw", "ga", "fr" };
            if (!validLanguages.Contains(language))
            {
                result.IsValid = false;
                result.Errors.Add("Invalid language selection");
            }

            // Currency validation
            var validCurrencies = new[] { "GHS", "USD", "EUR", "GBP" };
            if (!validCurrencies.Contains(currency))
            {
                result.IsValid = false;
                result.Errors.Add("Invalid currency selection");
            }

            return result;
        }

        private static ValidationResult ValidateSecuritySettings(bool twoFactorAuth, bool strongPassword,
            bool sessionTimeout, int timeoutMinutes, int maxLoginAttempts)
        {
            var result = new ValidationResult { IsValid = true };

            // Session timeout validation
            if (sessionTimeout && (timeoutMinutes < 5 || timeoutMinutes > 480))
            {
                result.IsValid = false;
                result.Errors.Add("Session timeout must be between 5 and 480 minutes");
            }

            // Max login attempts validation
            if (maxLoginAttempts < 3 || maxLoginAttempts > 10)
            {
                result.IsValid = false;
                result.Errors.Add("Maximum login attempts must be between 3 and 10");
            }

            return result;
        }

        private static bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private static bool IsValidPhone(string phone)
        {
            if (string.IsNullOrWhiteSpace(phone)) return false;
            
            // Remove common formatting characters
            string cleanPhone = System.Text.RegularExpressions.Regex.Replace(phone, @"[\s\-\(\)]", "");
            
            // Check if it's a valid international or local format
            return System.Text.RegularExpressions.Regex.IsMatch(cleanPhone, @"^[\+]?[0-9]{10,15}$");
        }

        private static string SanitizeInput(string input)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            
            // Remove potentially dangerous characters
            input = input.Trim();
            input = System.Text.RegularExpressions.Regex.Replace(input, @"[<>""']", "");
            
            // Limit length to prevent buffer overflow attacks
            if (input.Length > 1000)
            {
                input = input.Substring(0, 1000);
            }
            
            return input;
        }
    }
}