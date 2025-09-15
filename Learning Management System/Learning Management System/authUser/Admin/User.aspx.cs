using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;

namespace Learning_Management_System.authUser.Admin
{
    public partial class User : System.Web.UI.Page
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null 
            ? ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString 
            : "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";

        // Utility method to get a configured JavaScriptSerializer with high maxJsonLength
        private static JavaScriptSerializer GetConfiguredSerializer()
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = 50000000; // Set to 50MB
            return serializer;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Check if user is authenticated and has admin privileges
                if (Session["UserID"] == null || (Session["UserRole"] != null && Session["UserRole"].ToString() != "Admin"))
                {
                    //Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }

                // Users are loaded via JavaScript
                if (!IsPostBack)
                {
                    // Initialize page data
                    ActivityLogger.Log("UserVisit","User Management page accessed");
                }
            }
            catch (Exception ex)
            {
                LogError("User Page Load Error", ex);
                // Don't redirect on error, just log it
            }
        }

        [WebMethod]
public static string GetAllUsers(string userType = "")
{
    try
    {
        List<object> users = new List<object>();
        
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            
            string query = @"
                SELECT 
                    u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                    u.DepartmentID, d.DepartmentName AS Department, 
                    u.LevelID, l.LevelName AS Level, 
                    u.ProgrammeID, p.ProgrammeName AS Programme, 
                    u.ProfilePicture, 
                    u.EmployeeID, u.CreatedDate, u.IsActive,
                    STRING_AGG(COALESCE(c.CourseCode, ''), ', ') as AssignedCourses
                FROM Users u
                LEFT JOIN Department d ON u.DepartmentID = d.DepartmentID
                LEFT JOIN Level l ON u.LevelID = l.LevelID
                LEFT JOIN Programme p ON u.ProgrammeID = p.ProgrammeID
                LEFT JOIN UserCourses uc ON u.UserID = uc.UserID
                LEFT JOIN Courses c ON uc.CourseID = c.CourseID
                WHERE u.IsActive = 1 " + 
                (string.IsNullOrEmpty(userType) ? "" : "AND u.UserType = @UserType") + @"
                GROUP BY u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                        u.DepartmentID, d.DepartmentName, 
                        u.LevelID, l.LevelName, 
                        u.ProgrammeID, p.ProgrammeName, 
                        u.ProfilePicture, u.EmployeeID, u.CreatedDate, u.IsActive
                ORDER BY u.FullName";
            
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (!string.IsNullOrEmpty(userType))
                {
                    cmd.Parameters.AddWithValue("@UserType", userType);
                }
                
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                       // When reading profilePic from the database:
            string profilePic = reader["ProfilePicture"] != DBNull.Value && !string.IsNullOrWhiteSpace(reader["ProfilePicture"].ToString())
            ? reader["ProfilePicture"].ToString()
            : GetDefaultProfilePic(reader["FullName"].ToString());

                        users.Add(new
                        {
                            id = Convert.ToInt32(reader["UserID"]),
                            fullName = reader["FullName"].ToString(),
                            email = reader["Email"].ToString(),
                            phone = reader["Phone"].ToString(),
                            userType = reader["UserType"].ToString().ToLower(),
                            department = reader["Department"].ToString(),
                            level = reader["Level"]?.ToString() ?? "",
                            programme = reader["Programme"].ToString(),
                            profilePic = profilePic,
                            employeeId = reader["EmployeeID"]?.ToString() ?? "",
                            courses = reader["AssignedCourses"]?.ToString()?.Split(',').Where(c => !string.IsNullOrEmpty(c.Trim())).ToArray() ?? new string[0],
                            createdDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd"),
                            isActive = Convert.ToBoolean(reader["IsActive"])
                        });
                    }
                }
            }
        }
        
        return GetConfiguredSerializer().Serialize(new { success = true, data = users });
    }
    catch (Exception ex)
    {
        LogError("GetAllUsers Error", ex);
        return GetConfiguredSerializer().Serialize(new { success = false, message = "Error retrieving users: " + ex.Message });
    }
}

        [WebMethod]
        public static string SaveUser(string userData)
        {
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                dynamic user = serializer.DeserializeObject(userData);
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            int userId = 0;
                            
                            if (user["id"] != null && Convert.ToInt32(user["id"]) > 0)
                            {
                                // Update existing user
                                userId = Convert.ToInt32(user["id"]);
                                string updateQuery = @"
                                    UPDATE Users SET 
                                        FullName = @FullName, Email = @Email, Phone = @Phone, 
                                        UserType = @UserType, DepartmentID = @DepartmentID, LevelID = @LevelID, 
                                        ProgrammeID = @ProgrammeID, 
                                        ProfilePicture = @ProfilePicture,
                                        EmployeeID = @EmployeeID, ModifiedDate = GETDATE()
                                    WHERE UserID = @UserID";
                                
                                using (SqlCommand cmd = new SqlCommand(updateQuery, conn, trans))
                                {
                                    AddUserParameters(cmd, user);
                                    cmd.Parameters.AddWithValue("@UserID", userId);
                                    cmd.ExecuteNonQuery();
                                }
                                ActivityLogger.Log("UserRegistered", $"Update User registered: {user["id"]}");

                            }
                            else
                            {
                                // Insert new user
                                string insertQuery = @"
                                    INSERT INTO Users (FullName, Email, Phone, UserType, DepartmentID, LevelID, 
                                                     ProgrammeID, ProfilePicture, EmployeeID, CreatedDate, IsActive)
                                    OUTPUT INSERTED.UserID
                                    VALUES (@FullName, @Email, @Phone, @UserType, @DepartmentID, @LevelID, 
                                           @ProgrammeID, 
                                           @ProfilePicture,
                                           @EmployeeID, GETDATE(), 1)";
                                
                                using (SqlCommand cmd = new SqlCommand(insertQuery, conn, trans))
                                {
                                    AddUserParameters(cmd, user);
                                    userId = (int)cmd.ExecuteScalar();
                                }
                            }
                            
                            // Update course assignments
                            if (user["courses"] != null)
                            {
                                // Clear existing course assignments
                                string deleteCourses = "DELETE FROM UserCourses WHERE UserID = @UserID";
                                using (SqlCommand cmd = new SqlCommand(deleteCourses, conn, trans))
                                {
                                    cmd.Parameters.AddWithValue("@UserID", userId);
                                    cmd.ExecuteNonQuery();
                                }
                                
                                // Add new course assignments
                                object[] courses = (object[])user["courses"];
                                foreach (string courseCode in courses)
                                {
                                    if (!string.IsNullOrEmpty(courseCode))
                                    {
                                        string insertCourse = @"
                                            INSERT INTO UserCourses (UserID, CourseID)
                                            SELECT @UserID, CourseID FROM Courses WHERE CourseCode = @CourseCode";
                                        
                                        using (SqlCommand cmd = new SqlCommand(insertCourse, conn, trans))
                                        {
                                            cmd.Parameters.AddWithValue("@UserID", userId);
                                            cmd.Parameters.AddWithValue("@CourseCode", courseCode.Trim());
                                            cmd.ExecuteNonQuery();
                                        }
                                    }
                                }
                            }
                            
                            trans.Commit();
                            
                            // Log the activity
                            string action = user["id"] != null && Convert.ToInt32(user["id"]) > 0 ? "updated" : "created";
                            ActivityLogger.Log("UserLogin", $"User {action}: {user["fullName"]} ({user["userType"]})");
                            
                            return new JavaScriptSerializer().Serialize(new { 
                                success = true, 
                                message = $"User {action} successfully!",
                                userId = userId 
                            });
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("SaveUser Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error saving user: " + ex.Message });
            }
        }

        [WebMethod]
        public static string DeleteUser(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            // Get user name for logging
                            string userName = "";
                            string getUserQuery = "SELECT FullName FROM Users WHERE UserID = @UserID";
                            using (SqlCommand cmd = new SqlCommand(getUserQuery, conn, trans))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                userName = cmd.ExecuteScalar()?.ToString() ?? "Unknown User";
                            }
                            
                            // Soft delete - mark as inactive instead of hard delete
                            string deleteQuery = "UPDATE Users SET IsActive = 0, ModifiedDate = GETDATE() WHERE UserID = @UserID";
                            using (SqlCommand cmd = new SqlCommand(deleteQuery, conn, trans))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                int affected = cmd.ExecuteNonQuery();
                                
                                if (affected == 0)
                                {
                                    throw new Exception("User not found or already deleted");
                                }
                            }
                            
                            // Remove course assignments
                            string removeCourses = "DELETE FROM UserCourses WHERE UserID = @UserID";
                            using (SqlCommand cmd = new SqlCommand(removeCourses, conn, trans))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                cmd.ExecuteNonQuery();
                            }
                            
                            trans.Commit();
                            
                            ActivityLogger.Log("UserDeleted",$"User deleted: {userName}");
                            
                            return new JavaScriptSerializer().Serialize(new { 
                                success = true, 
                                message = "User deleted successfully!" 
                            });
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("DeleteUser Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error deleting user: " + ex.Message });
            }
        }

        [WebMethod]
        public static string GetUserDetails(int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT 
                            u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                            u.DepartmentID, d.DepartmentName AS Department, 
                            u.LevelID, l.LevelName AS Level, 
                            u.ProgrammeID, p.ProgrammeName AS Programme, 
                            u.ProfilePicture, u.EmployeeID, u.CreatedDate, u.IsActive,
                            STRING_AGG(COALESCE(c.CourseCode, ''), ', ') as AssignedCourses
                        FROM Users u
                        LEFT JOIN Department d ON u.DepartmentID = d.DepartmentID
                        LEFT JOIN Level l ON u.LevelID = l.LevelID
                        LEFT JOIN Programme p ON u.ProgrammeID = p.ProgrammeID
                        LEFT JOIN UserCourses uc ON u.UserID = uc.UserID
                        LEFT JOIN Courses c ON uc.CourseID = c.CourseID
                        WHERE u.UserID = @UserID
                        GROUP BY u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                                u.DepartmentID, d.DepartmentName, 
                                u.LevelID, l.LevelName, 
                                u.ProgrammeID, p.ProgrammeName,
                                u.ProfilePicture, u.EmployeeID, u.CreatedDate, u.IsActive";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                               // When reading profilePic from the database:
string profilePic = reader["ProfilePicture"] != DBNull.Value && !string.IsNullOrWhiteSpace(reader["ProfilePicture"].ToString())
    ? reader["ProfilePicture"].ToString()
    : GetDefaultProfilePic(reader["FullName"].ToString());
                                // Get course assignments as array
                                string[] courses = reader["AssignedCourses"]?.ToString()?.Split(',')
                                    .Where(c => !string.IsNullOrEmpty(c.Trim()))
                                    .ToArray() ?? new string[0];
                                
                                var user = new {
                                    id = Convert.ToInt32(reader["UserID"]),
                                    fullName = reader["FullName"].ToString(),
                                    email = reader["Email"].ToString(),
                                    phone = reader["Phone"].ToString(),
                                    userType = reader["UserType"].ToString().ToLower(),
                                    departmentId = reader["DepartmentID"] != DBNull.Value ? Convert.ToInt32(reader["DepartmentID"]) : 0,
                                    department = reader["Department"].ToString(),
                                    levelId = reader["LevelID"] != DBNull.Value ? Convert.ToInt32(reader["LevelID"]) : 0,
                                    level = reader["Level"]?.ToString() ?? "",
                                    programmeId = reader["ProgrammeID"] != DBNull.Value ? Convert.ToInt32(reader["ProgrammeID"]) : 0,
                                    programme = reader["Programme"].ToString(),
                                    profilePic = profilePic,
                                    employeeId = reader["EmployeeID"]?.ToString() ?? "",
                                    courses = courses,
                                    createdDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd"),
                                    isActive = Convert.ToBoolean(reader["IsActive"])
                                };
                                
                                return new JavaScriptSerializer().Serialize(new { success = true, data = user });
                            }
                            else
                            {
                                return new JavaScriptSerializer().Serialize(new { success = false, message = "User not found" });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("GetUserDetails Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error retrieving user details: " + ex.Message });
            }
        }

        [WebMethod]
        public static string GetAvailableCourses()
        {
            try
            {
                List<object> courses = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT c.CourseID, c.CourseCode, c.CourseName, d.DepartmentName AS Department, c.Credits
                        FROM Courses c
                        LEFT JOIN Department d ON c.DepartmentID = d.DepartmentID
                        WHERE c.IsActive = 1 
                        ORDER BY c.CourseCode";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courses.Add(new
                                {
                                    id = Convert.ToInt32(reader["CourseID"]),
                                    code = reader["CourseCode"].ToString(),
                                    name = reader["CourseName"].ToString(),
                                    department = reader["Department"].ToString(),
                                    credits = Convert.ToInt32(reader["Credits"]),
                                    display = $"{reader["CourseCode"]} - {reader["CourseName"]}"
                                });
                            }
                        }
                    }
                }
                
                return new JavaScriptSerializer().Serialize(new { success = true, data = courses });
            }
            catch (Exception ex)
            {
                LogError("GetAvailableCourses Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error retrieving courses: " + ex.Message });
            }
        }

        [WebMethod]
        public static string SearchUsers(string searchTerm, string userType = "")
        {
            try
            {
                if (string.IsNullOrEmpty(searchTerm))
                {
                    return GetAllUsers(userType);
                }
                
                List<object> users = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    string query = @"
                        SELECT 
                            u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                            u.DepartmentID, d.DepartmentName AS Department, 
                            u.LevelID, l.LevelName AS Level, 
                            u.ProgrammeID, p.ProgrammeName AS Programme, 
                            u.ProfilePicture, 
                            u.EmployeeID, u.CreatedDate, u.IsActive,
                            STRING_AGG(COALESCE(c.CourseCode, ''), ', ') as AssignedCourses
                        FROM Users u
                        LEFT JOIN Department d ON u.DepartmentID = d.DepartmentID
                        LEFT JOIN Level l ON u.LevelID = l.LevelID
                        LEFT JOIN Programme p ON u.ProgrammeID = p.ProgrammeID
                        LEFT JOIN UserCourses uc ON u.UserID = uc.UserID
                        LEFT JOIN Courses c ON uc.CourseID = c.CourseID
                        WHERE u.IsActive = 1 
                            AND (u.FullName LIKE @SearchTerm 
                                OR u.Email LIKE @SearchTerm 
                                OR d.DepartmentName LIKE @SearchTerm
                                OR p.ProgrammeName LIKE @SearchTerm)" +
                        (string.IsNullOrEmpty(userType) ? "" : " AND u.UserType = @UserType") + @"
                        GROUP BY u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                                u.DepartmentID, d.DepartmentName, 
                                u.LevelID, l.LevelName, 
                                u.ProgrammeID, p.ProgrammeName, 
                                u.ProfilePicture, u.EmployeeID, u.CreatedDate, u.IsActive
                        ORDER BY u.FullName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                        if (!string.IsNullOrEmpty(userType))
                        {
                            cmd.Parameters.AddWithValue("@UserType", userType);
                        }
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                users.Add(new
                                {
                                    id = Convert.ToInt32(reader["UserID"]),
                                    fullName = reader["FullName"].ToString(),
                                    email = reader["Email"].ToString(),
                                    phone = reader["Phone"].ToString(),
                                    userType = reader["UserType"].ToString().ToLower(),
                                    department = reader["Department"].ToString(),
                                    level = reader["Level"]?.ToString() ?? "",
                                    programme = reader["Programme"].ToString(),
                                    profilePic = reader["ProfilePicture"] != DBNull.Value && !string.IsNullOrWhiteSpace(reader["ProfilePicture"].ToString())
    ? reader["ProfilePicture"].ToString()
    : GetDefaultProfilePic(reader["FullName"].ToString()),
                                    employeeId = reader["EmployeeID"]?.ToString() ?? "",
                                    courses = reader["AssignedCourses"]?.ToString()?.Split(',').Where(c => !string.IsNullOrEmpty(c.Trim())).ToArray() ?? new string[0],
                                    createdDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd"),
                                    isActive = Convert.ToBoolean(reader["IsActive"])
                                });
                            }
                        }
                    }
                }
                
                return new JavaScriptSerializer().Serialize(new { success = true, data = users });
            }
            catch (Exception ex)
            {
                LogError("SearchUsers Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error searching users: " + ex.Message });
            }
        }

        [WebMethod]
        public static string GetNotifications(string lastFetchTime = null)
        {
            try
            {
                // Return a very simple response to isolate the issue
                return new JavaScriptSerializer().Serialize(new { 
                    success = true, 
                    data = new object[] { 
                        new { 
                            id = 1, 
                            title = "System Notification", 
                            message = "Welcome to the LMS", 
                            type = "info", 
                            createdDate = "2023-05-15 14:30:00", 
                            isRead = false 
                        } 
                    } 
                });
            }
            catch (Exception ex)
            {
                LogError("GetNotifications Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error loading notifications: " + ex.Message });
            }
        }
        
        [WebMethod]
        public static string MarkNotificationAsRead(int notificationId)
        {
            try
            {
                // In a real system, update the notification in the database
                return new JavaScriptSerializer().Serialize(new { success = true });
            }
            catch (Exception ex)
            {
                LogError("MarkNotificationAsRead Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error marking notification as read: " + ex.Message });
            }
        }
        
        [WebMethod]
        public static string MarkAllNotificationsAsRead()
        {
            try
            {
                // In a real system, update all notifications in the database
                return new JavaScriptSerializer().Serialize(new { success = true });
            }
            catch (Exception ex)
            {
                LogError("MarkAllNotificationsAsRead Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error marking all notifications as read: " + ex.Message });
            }
        }

        [WebMethod]
        public static string GetDepartments()
        {
            try
            {
                List<object> departments = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT DepartmentID, DepartmentName FROM Department ORDER BY DepartmentName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                departments.Add(new
                                {
                                    id = Convert.ToInt32(reader["DepartmentID"]),
                                    name = reader["DepartmentName"].ToString()
                                });
                            }
                        }
                    }
                }
                
                return new JavaScriptSerializer().Serialize(new { success = true, data = departments });
            }
            catch (Exception ex)
            {
                LogError("GetDepartments Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error retrieving departments: " + ex.Message });
            }
        }

        [WebMethod]
        public static string GetLevels()
        {
            try
            {
                List<object> levels = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT LevelID, LevelName FROM Level ORDER BY LevelName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                levels.Add(new
                                {
                                    id = Convert.ToInt32(reader["LevelID"]),
                                    name = reader["LevelName"].ToString()
                                });
                            }
                        }
                    }
                }
                
                return new JavaScriptSerializer().Serialize(new { success = true, data = levels });
            }
            catch (Exception ex)
            {
                LogError("GetLevels Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error retrieving levels: " + ex.Message });
            }
        }

        [WebMethod]
        public static string GetProgrammes()
        {
            try
            {
                List<object> programmes = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT ProgrammeID, ProgrammeName, DepartmentID FROM Programme ORDER BY ProgrammeName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                programmes.Add(new
                                {
                                    id = Convert.ToInt32(reader["ProgrammeID"]),
                                    name = reader["ProgrammeName"].ToString(),
                                    departmentId = reader["DepartmentID"] != DBNull.Value ? Convert.ToInt32(reader["DepartmentID"]) : 0
                                });
                            }
                        }
                    }
                }
                
                return new JavaScriptSerializer().Serialize(new { success = true, data = programmes });
            }
            catch (Exception ex)
            {
                LogError("GetProgrammes Error", ex);
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Error retrieving programmes: " + ex.Message });
            }
        }

        private static void AddUserParameters(SqlCommand cmd, dynamic user)
{
    cmd.Parameters.AddWithValue("@FullName", user["fullName"]?.ToString() ?? "");
    cmd.Parameters.AddWithValue("@Email", user["email"]?.ToString() ?? "");
    cmd.Parameters.AddWithValue("@Phone", user["phone"]?.ToString() ?? "");
    cmd.Parameters.AddWithValue("@UserType", user["userType"]?.ToString() ?? "");

    // DepartmentID
    int deptId = 0;
    if (user["departmentId"] != null && int.TryParse(user["departmentId"].ToString(), out deptId) && deptId > 0)
        cmd.Parameters.AddWithValue("@DepartmentID", deptId);
    else
    {
        string deptName = user["department"]?.ToString() ?? "";
        deptId = GetDepartmentId(deptName);
        cmd.Parameters.AddWithValue("@DepartmentID", deptId > 0 ? (object)deptId : DBNull.Value);
    }

    // LevelID
    int levelId = 0;
    if (user["levelId"] != null && int.TryParse(user["levelId"].ToString(), out levelId) && levelId > 0)
        cmd.Parameters.AddWithValue("@LevelID", levelId);
    else
    {
        string levelName = user["level"]?.ToString() ?? "";
        levelId = GetLevelId(levelName);
        cmd.Parameters.AddWithValue("@LevelID", levelId > 0 ? (object)levelId : DBNull.Value);
    }

    // ProgrammeID
    int progId = 0;
    if (user["programmeId"] != null && int.TryParse(user["programmeId"].ToString(), out progId) && progId > 0)
        cmd.Parameters.AddWithValue("@ProgrammeID", progId);
    else
    {
        string progName = user["programme"]?.ToString() ?? "";
        progId = GetProgrammeId(progName);
        cmd.Parameters.AddWithValue("@ProgrammeID", progId > 0 ? (object)progId : DBNull.Value);
    }

    // ProfilePicture as URL/path
    string profilePic = user["profilePic"]?.ToString() ?? "";
    if (string.IsNullOrEmpty(profilePic) || profilePic.Contains("user.png"))
        cmd.Parameters.AddWithValue("@ProfilePicture", DBNull.Value);
    else
        cmd.Parameters.AddWithValue("@ProfilePicture", profilePic);

    // EmployeeID
    string employeeId = user["employeeId"]?.ToString() ?? "";
    if (string.IsNullOrEmpty(employeeId))
        cmd.Parameters.AddWithValue("@EmployeeID", DBNull.Value);
    else if (EmployeeExists(employeeId))
        cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
    else
        cmd.Parameters.AddWithValue("@EmployeeID", DBNull.Value);
}
        private static int GetDepartmentId(string departmentName)
        {
            if (string.IsNullOrEmpty(departmentName))
                return 0;
                
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT DepartmentID FROM Department WHERE DepartmentName = @DepartmentName";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@DepartmentName", departmentName);
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
            }
            catch
            {
                return 0;
            }
        }
        
        private static int GetLevelId(string levelName)
        {
            if (string.IsNullOrEmpty(levelName))
                return 0;
                
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT LevelID FROM Level WHERE LevelName = @LevelName";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@LevelName", levelName);
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
            }
            catch
            {
                return 0;
            }
        }
        
        private static int GetProgrammeId(string programmeName)
        {
            if (string.IsNullOrEmpty(programmeName))
                return 0;
                
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT ProgrammeID FROM Programme WHERE ProgrammeName = @ProgrammeName";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ProgrammeName", programmeName);
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
            }
            catch
            {
                return 0;
            }
        }
        
        private static bool EmployeeExists(string employeeId)
        {
            if (string.IsNullOrEmpty(employeeId))
                return false;
                
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM Employee WHERE EmployeeID = @EmployeeID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmployeeID", employeeId);
                        int count = Convert.ToInt32(cmd.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch
            {
                return false;
            }
        }


[WebMethod]
public static string UploadProfilePicture(string imageData, string fileName)
{
    try
    {
        if (string.IsNullOrEmpty(imageData) || string.IsNullOrEmpty(fileName))
            throw new Exception("No image data or file name provided.");

        // Remove the data:image/...;base64, part if present
        var base64Data = imageData.Contains(",") ? imageData.Split(',')[1] : imageData;
        byte[] bytes = Convert.FromBase64String(base64Data);

        string folderPath = HttpContext.Current.Server.MapPath("~/Uploads/ProfilePictures/");
        if (!System.IO.Directory.Exists(folderPath))
            System.IO.Directory.CreateDirectory(folderPath);

        string uniqueFileName = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fileName);
        string filePath = System.IO.Path.Combine(folderPath, uniqueFileName);
        System.IO.File.WriteAllBytes(filePath, bytes);

        // Return the relative URL
        string url = "/Uploads/ProfilePictures/" + uniqueFileName;
        return new JavaScriptSerializer().Serialize(new { success = true, filePath = url });
    }
    catch (Exception ex)
    {
        return new JavaScriptSerializer().Serialize(new { success = false, message = ex.Message });
    }
}


        private static string GetDefaultProfilePic(string fullName)
        {
            if (string.IsNullOrEmpty(fullName))
                return "../../../Assest/Images/user.png";

            string initials = "";
            string[] names = fullName.Split(' ');
            if (names.Length >= 2)
            {
                initials = names[0].Substring(0, 1) + names[1].Substring(0, 1);
            }
            else if (names.Length == 1 && names[0].Length >= 2)
            {
                initials = names[0].Substring(0, 2);
            }
            else
            {
                initials = "U";
            }


            return $"https://placehold.co/600x400/EEE/31343C?font=roboto&text={initials.ToUpper()}";
        }


        [WebMethod]
    /* Duplicate GetAllUsersWithIds method removed to resolve compile error. */

        private static void LogError(string errorMessage, Exception ex)
        {

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO ErrorLogs (ErrorMessage, StackTrace, Timestamp, UserID, PageName)
                        VALUES (@ErrorMessage, @StackTrace, GETDATE(), @UserID, @PageName)";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ErrorMessage", errorMessage + ": " + ex.Message);
                        cmd.Parameters.AddWithValue("@StackTrace", ex.StackTrace ?? "");
                        cmd.Parameters.AddWithValue("@UserID", HttpContext.Current.Session["UserID"] ?? 0);
                        cmd.Parameters.AddWithValue("@PageName", "User.aspx");
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Silent fail for error logging
            }
        }

        private static string GetClientIPAddress()
        {
            string ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (string.IsNullOrEmpty(ipAddress))
                ipAddress = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            if (string.IsNullOrEmpty(ipAddress))
                ipAddress = HttpContext.Current.Request.UserHostAddress;
            return ipAddress ?? "Unknown";
        }

}
}