using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Course : System.Web.UI.Page
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Any initialization code if needed
            }
        }

       
       [WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetCourses(int pageNumber, int pageSize)
{
    try
    {
        List<object> courses = new List<object>();
        int totalCourses = 0;

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();

            // Get total count for pagination
            string countQuery = "SELECT COUNT(*) FROM Courses";
            using (SqlCommand countCmd = new SqlCommand(countQuery, conn))
            {
                totalCourses = (int)countCmd.ExecuteScalar();
            }

            // Use OFFSET-FETCH for paging (SQL Server 2012+)
            string query = @"
                SELECT c.CourseID, c.CourseCode, c.CourseName, c.Description, c.Credits, 
                       d.DepartmentName, l.LevelName, p.ProgrammeName , u.FullName, c.Status,
                       c.StartDate, c.EndDate, c.CreatedDate, c.ModifiedDate, c.IsActive,
                       ISNULL(e.EnrolledCount, 0) as EnrolledCount
                FROM Courses c
                LEFT JOIN (
                    SELECT CourseID, COUNT(*) as EnrolledCount 
                    FROM UserCourses 
                    GROUP BY CourseID
                ) e ON c.CourseID = e.CourseID 
                LEFT JOIN Department d ON d.DepartmentID = c.DepartmentID 
                LEFT JOIN Users u ON c.UserID = u.UserID
                LEFT JOIN Level l ON l.LevelID = c.LevelID
                LEFT JOIN Programme p ON p.ProgrammeID = c.ProgrammeID
                ORDER BY c.CreatedDate DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                int offset = (pageNumber - 1) * pageSize;
                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        courses.Add(new
                        {
                            courseId = Convert.ToInt32(reader["CourseID"]),
                            courseCode = reader["CourseCode"].ToString(),
                            courseName = reader["CourseName"].ToString(),
                            department = reader["DepartmentName"].ToString(),
                            credits = Convert.ToInt32(reader["Credits"]),
                            instructor = reader["FullName"].ToString(),
                            status = reader["Status"].ToString(),
                            description = reader["Description"].ToString(),
                            startDate = reader["StartDate"] != DBNull.Value ?
                                Convert.ToDateTime(reader["StartDate"]).ToString("yyyy-MM-dd") : "",
                            endDate = reader["EndDate"] != DBNull.Value ?
                                Convert.ToDateTime(reader["EndDate"]).ToString("yyyy-MM-dd") : "",
                            enrolledCount = Convert.ToInt32(reader["EnrolledCount"]),
                            isActive = Convert.ToBoolean(reader["IsActive"])
                        });
                    }
                }
            }
        }

        return new { success = true, data = courses, totalCount = totalCourses };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

public class BulkUpdateRequest
{
    public List<string> courseIds { get; set; }
    public string newStatus { get; set; }
}

        [WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object BulkUpdateCourseStatus(BulkUpdateRequest request)
{
    try
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            foreach (var courseId in request.courseIds)
            {
                string query = "UPDATE Courses SET Status = @Status WHERE CourseCode = @CourseCode";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", request.newStatus);
                    cmd.Parameters.AddWithValue("@CourseCode", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        return new { success = true };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


public class BulkDeleteRequest
{
    public List<string> courseIds { get; set; }
}

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object BulkDeleteCourses(BulkDeleteRequest request)
{
    try
    {
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            foreach (var courseId in request.courseIds)
            {
                string query = "DELETE FROM Courses WHERE CourseCode = @CourseCode";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseCode", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        return new { success = true };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object AddCourse(string courseCode, string courseName, string department, 
            int credits, string instructor, string status, string description, 
            string startDate, string endDate)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check if course code already exists
                    string checkQuery = "SELECT COUNT(*) FROM Courses WHERE CourseCode = @CourseCode";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@CourseCode", courseCode);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            return new { success = false, message = "Course code already exists!" };
                        }
                    }
                    
                    // Verify instructor exists in Users table
                    string checkInstructorQuery = @"
                        SELECT COUNT(*) 
                        FROM Users
                        WHERE UserID = @UserID 
                          AND UserType != 'Admin' 
                          AND UserType != 'Student'";
                    using (SqlCommand checkInstructorCmd = new SqlCommand(checkInstructorQuery, conn))
                    {
                        try {
                            // Convert instructor to integer for the User ID
                            checkInstructorCmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(instructor));
                            int count = (int)checkInstructorCmd.ExecuteScalar();
                            if (count == 0)
                            {
                                return new { success = false, message = "Selected instructor is not valid! (ID: " + instructor + ")" };
                            }
                        }
                        catch (FormatException) {
                            return new { success = false, message = "Invalid instructor ID format. Please select a valid instructor." };
                        }
                    }
                    
                    string insertQuery = @"
                        INSERT INTO Courses (CourseCode, CourseName, Description, Credits, DepartmentID, 
                                           UserID, Status, StartDate, EndDate, CreatedDate, IsActive)
                        VALUES (@CourseCode, @CourseName, @Description, @Credits, @DepartmentID, 
                                @UserID, @Status, @StartDate, @EndDate, GETDATE(), 1)";
                    
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseCode", courseCode);
                        cmd.Parameters.AddWithValue("@CourseName", courseName);
                        cmd.Parameters.AddWithValue("@Description", description ?? "");
                        cmd.Parameters.AddWithValue("@Credits", credits);
                        cmd.Parameters.AddWithValue("@DepartmentID", Convert.ToInt32(department));
                        cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(instructor));
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@StartDate", !string.IsNullOrEmpty(startDate) ? 
                            (object)DateTime.Parse(startDate) : DBNull.Value);
                        cmd.Parameters.AddWithValue("@EndDate", !string.IsNullOrEmpty(endDate) ? 
                            (object)DateTime.Parse(endDate) : DBNull.Value);
                        
                        try 
                        {
                            int result = cmd.ExecuteNonQuery();
                            if (result > 0)
                            {
                                return new { success = true, message = "Course added successfully!" };
                            }
                            else
                            {
                                return new { success = false, message = "Failed to add course." };
                            }
                        }
                        catch (SqlException sqlEx)
                        {
                            if (sqlEx.Message.Contains("FOREIGN KEY constraint"))
                            {
                                if (sqlEx.Message.Contains("User"))
                                {
                                    return new { success = false, message = "The selected instructor cannot be assigned to this course. Error: " + sqlEx.Message };
                                }
                                else if (sqlEx.Message.Contains("Department"))
                                {
                                    return new { success = false, message = "The selected department does not exist. Error: " + sqlEx.Message };
                                }
                                return new { success = false, message = "Foreign key constraint violation: " + sqlEx.Message };
                            }
                            throw;  // Re-throw if it's not a foreign key constraint error
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object UpdateCourse(string courseCode, string courseName, string department, 
            int credits, string instructor, string status, string description, 
            string startDate, string endDate)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Verify instructor exists in Users table
                    string checkUserQuery = @"
                        SELECT COUNT(*) 
                        FROM Users
                        WHERE UserID = @UserID 
                          AND UserType != 'Admin' 
                          AND UserType != 'Student'";
                    using (SqlCommand checkUserCmd = new SqlCommand(checkUserQuery, conn))
                    {
                        try {
                            checkUserCmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(instructor));
                            int count = (int)checkUserCmd.ExecuteScalar();
                            if (count == 0)
                            {
                                return new { success = false, message = "Selected instructor is not valid! (ID: " + instructor + ")" };
                            }
                        }
                        catch (FormatException) {
                            return new { success = false, message = "Invalid instructor ID format. Please select a valid instructor." };
                        }
                    }
                    
                    
                    string updateQuery = @"
                        UPDATE Courses 
                        SET CourseName = @CourseName, Description = @Description, Credits = @Credits,
                            DepartmentID = @DepartmentID, UserID = @UserID, Status = @Status,
                            StartDate = @StartDate, EndDate = @EndDate, ModifiedDate = GETDATE()
                        WHERE CourseCode = @CourseCode";
                    
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseCode", courseCode);
                        cmd.Parameters.AddWithValue("@CourseName", courseName);
                        cmd.Parameters.AddWithValue("@Description", description ?? "");
                        cmd.Parameters.AddWithValue("@Credits", credits);
                        cmd.Parameters.AddWithValue("@DepartmentID", Convert.ToInt32(department));
                        cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(instructor));
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@StartDate", !string.IsNullOrEmpty(startDate) ? 
                            (object)DateTime.Parse(startDate) : DBNull.Value);
                        cmd.Parameters.AddWithValue("@EndDate", !string.IsNullOrEmpty(endDate) ? 
                            (object)DateTime.Parse(endDate) : DBNull.Value);
                        
                        try 
                        {
                            int result = cmd.ExecuteNonQuery();
                            if (result > 0)
                            {
                                return new { success = true, message = "Course updated successfully!" };
                            }
                            else
                            {
                                return new { success = false, message = "Course not found or no changes made." };
                            }
                        }
                        catch (SqlException sqlEx)
                        {
                            if (sqlEx.Message.Contains("FOREIGN KEY constraint"))
                            {
                                if (sqlEx.Message.Contains("User"))
                                {
                                    return new { success = false, message = "The selected instructor cannot be assigned to this course. Please check database mappings." };
                                }
                                else if (sqlEx.Message.Contains("Department"))
                                {
                                    return new { success = false, message = "The selected department does not exist." };
                                }
                                return new { success = false, message = "Foreign key constraint violation: " + sqlEx.Message };
                            }
                            throw;  // Re-throw if it's not a foreign key constraint error
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object DeleteCourse(string courseCode)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Get CourseID from CourseCode
                    string getIdQuery = "SELECT CourseID FROM Courses WHERE CourseCode = @CourseCode";
                    int courseId = 0;
                    
                    using (SqlCommand getIdCmd = new SqlCommand(getIdQuery, conn))
                    {
                        getIdCmd.Parameters.AddWithValue("@CourseCode", courseCode);
                        object result = getIdCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            courseId = Convert.ToInt32(result);
                        }
                        else
                        {
                            return new { success = false, message = "Course not found." };
                        }
                    }
                    
                    // Check if course has enrollments
                    string checkQuery = "SELECT COUNT(*) FROM UserCourses WHERE CourseID = @CourseID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@CourseID", courseId);
                        int enrollmentCount = (int)checkCmd.ExecuteScalar();
                        if (enrollmentCount > 0)
                        {
                            return new { success = false, message = "Cannot delete course with active enrollments!" };
                        }
                    }
                    
                    string deleteQuery = "DELETE FROM Courses WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        int result = cmd.ExecuteNonQuery();
                        
                        if (result > 0)
                        {
                            return new { success = true, message = "Course deleted successfully!" };
                        }
                        else
                        {
                            return new { success = false, message = "Course not found." };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCourseStatistics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT 
                            COUNT(*) as TotalCourses,
                            COUNT(CASE WHEN Status = 'Active' THEN 1 END) as ActiveCourses,
                            COUNT(CASE WHEN Status = 'Inactive' THEN 1 END) as InactiveCourses,
                            COUNT(CASE WHEN Status = 'Draft' THEN 1 END) as DraftCourses,
                            (SELECT COUNT(*) FROM UserCourses) as TotalEnrollments
                        FROM Courses";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return new
                                {
                                    success = true,
                                    data = new
                                    {
                                        totalCourses = Convert.ToInt32(reader["TotalCourses"]),
                                        activeCourses = Convert.ToInt32(reader["ActiveCourses"]),
                                        inactiveCourses = Convert.ToInt32(reader["InactiveCourses"]),
                                        draftCourses = Convert.ToInt32(reader["DraftCourses"]),
                                        totalEnrollments = Convert.ToInt32(reader["TotalEnrollments"])
                                    }
                                };
                            }
                        }
                    }
                }
                
                return new { success = false, message = "Unable to fetch statistics" };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object SearchCourses(string searchTerm, string department, string status)
        {
            try
            {
                List<object> courses = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    System.Diagnostics.Debug.WriteLine($"SearchCourses called with parameters: searchTerm={searchTerm}, department={department}, status={status}");
                    
                    string whereClause = "WHERE 1=1";
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        whereClause += " AND (c.CourseCode LIKE @SearchTerm OR c.CourseName LIKE @SearchTerm OR c.Description LIKE @SearchTerm)";
                    }
                    if (!string.IsNullOrEmpty(department) && department != "All")
                    {
                        // Use DepartmentID instead of DepartmentCode
                        whereClause += " AND d.DepartmentID = @Department";
                    }
                    if (!string.IsNullOrEmpty(status) && status != "All")
                    {
                        whereClause += " AND c.Status = @Status";
                    }
                    
                    string query = $@"
                        SELECT c.CourseID, c.CourseCode, c.CourseName, c.Description, c.Credits, 
                               d.DepartmentName, l.LevelName, p.ProgrammeName , u.FullName, c.Status,
                               c.StartDate, c.EndDate, c.CreatedDate, c.ModifiedDate, c.IsActive,
                               ISNULL(e.EnrolledCount, 0) as EnrolledCount
                        FROM Courses c
                        LEFT JOIN (
                            SELECT CourseID, COUNT(*) as EnrolledCount 
                            FROM UserCourses 
                            GROUP BY CourseID
                        ) e ON c.CourseID = e.CourseID LEFT JOIN Department d ON
                        d.DepartmentID = c.DepartmentID LEFT JOIN Users u ON c.UserID = u.UserID
                        LEFT JOIN Level l ON l.LevelID = c.LevelID
                        LEFT JOIN Programme p ON p.ProgrammeID = c.ProgrammeID
                        {whereClause}
                        ORDER BY c.CreatedDate DESC";
                    
                    System.Diagnostics.Debug.WriteLine($"SQL Query: {query}");
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                        }
                        if (!string.IsNullOrEmpty(department) && department != "All")
                        {
                            cmd.Parameters.AddWithValue("@Department", Convert.ToInt32(department));
                        }
                        if (!string.IsNullOrEmpty(status) && status != "All")
                        {
                            cmd.Parameters.AddWithValue("@Status", status);
                        }
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                courses.Add(new
                                {
                                    courseId = Convert.ToInt32(reader["CourseID"]),
                                    courseCode = reader["CourseCode"].ToString(),
                                    courseName = reader["CourseName"].ToString(),
                                    department = reader["DepartmentName"].ToString(),
                                    credits = Convert.ToInt32(reader["Credits"]),
                                    instructor = reader["FullName"].ToString(),
                                    status = reader["Status"].ToString(),
                                    description = reader["Description"].ToString(),
                                    startDate = reader["StartDate"] != DBNull.Value ? 
                                        Convert.ToDateTime(reader["StartDate"]).ToString("yyyy-MM-dd") : "",
                                    endDate = reader["EndDate"] != DBNull.Value ? 
                                        Convert.ToDateTime(reader["EndDate"]).ToString("yyyy-MM-dd") : "",
                                    enrolledCount = Convert.ToInt32(reader["EnrolledCount"]),
                                    isActive = Convert.ToBoolean(reader["IsActive"])
                                });
                            }
                        }
                    }
                }
                
                System.Diagnostics.Debug.WriteLine($"SearchCourses completed successfully. Found {courses.Count} courses.");
                return new { success = true, data = courses };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in SearchCourses: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                return new { success = false, message = $"Failed to filter courses: {ex.Message}", errorDetails = ex.ToString() };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCourseDetails(string courseCode)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT c.CourseID, c.CourseCode, c.CourseName, c.Description, c.Credits, 
                               d.DepartmentName, d.DepartmentId, l.LevelName, p.ProgrammeName , u.FullName, c.UserID as 'InstructorId', c.Status,
                               c.StartDate, c.EndDate, c.CreatedDate, c.ModifiedDate, c.IsActive,
                               ISNULL(e.EnrolledCount, 0) as EnrolledCount
                        FROM Courses c
                        LEFT JOIN (
                            SELECT CourseID, COUNT(*) as EnrolledCount 
                            FROM UserCourses 
                            GROUP BY CourseID
                        ) e ON c.CourseID = e.CourseID LEFT JOIN Department d ON
                        d.DepartmentID = c.DepartmentID LEFT JOIN Users u ON c.UserID = u.UserID
                        LEFT JOIN Level l ON l.LevelID = c.LevelID
                        LEFT JOIN Programme p ON p.ProgrammeID = c.ProgrammeID
                        WHERE c.CourseCode = @CourseCode
                        ORDER BY c.CreatedDate DESC
                        ";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseCode", courseCode);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return new
                                {
                                    success = true,
                                    data = new
                                    {
                                        courseCode = reader["CourseCode"].ToString(),
                                        courseName = reader["CourseName"].ToString(),
                                        department = reader["DepartmentName"] != DBNull.Value ? reader["DepartmentName"].ToString() : "",
                                        departmentId = reader["DepartmentId"] != DBNull.Value ? Convert.ToInt32(reader["DepartmentId"]) : 0,
                                        credits = Convert.ToInt32(reader["Credits"]),
                                        instructor = reader["FullName"] != DBNull.Value ? reader["FullName"].ToString() : "",
                                        instructorId = reader["InstructorId"] != DBNull.Value ? Convert.ToInt32(reader["InstructorId"]) : 0,
                                        status = reader["Status"].ToString(),
                                        description = reader["Description"].ToString(),
                                        startDate = reader["StartDate"] != DBNull.Value ? 
                                            Convert.ToDateTime(reader["StartDate"]).ToString("yyyy-MM-dd") : "",
                                        endDate = reader["EndDate"] != DBNull.Value ? 
                                            Convert.ToDateTime(reader["EndDate"]).ToString("yyyy-MM-dd") : "",
                                        enrolledCount = Convert.ToInt32(reader["EnrolledCount"])
                                    }
                                };
                            }
                        }
                    }
                }
                
                return new { success = false, message = "Course not found" };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
        
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetInstructors()
        {
            try
            {
                List<object> instructors = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Get instructors from Users table where they're not Admin or Student
                    string query = @"
                        SELECT
                            u.UserID,
                            u.FullName
                        FROM [LearningManagementSystem].[dbo].[Users] u
                        WHERE u.[UserType] != 'Admin' 
                          AND u.[UserType] != 'Student'
                          AND u.IsActive = 1
                        ORDER BY u.FullName";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                instructors.Add(new
                                {
                                    id = Convert.ToInt32(reader["UserID"]),  // Use UserID for the Courses table
                                    name = reader["FullName"].ToString()
                                });
                            }
                        }
                    }
                    
                    // If we don't have any instructors, add some default ones
                    if (instructors.Count == 0)
                    {
                        instructors.Add(new { id = 1, name = "Dr. John Smith" });
                        instructors.Add(new { id = 2, name = "Prof. Mary Johnson" });
                        instructors.Add(new { id = 3, name = "Dr. Kwame Asante" });
                        instructors.Add(new { id = 4, name = "Prof. David Chen" });
                    }
                }
                
                return new { success = true, data = instructors };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetInstructors: {ex.Message}");
                return new { success = false, message = ex.Message };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetDepartments()
        {
            try
            {
                List<object> departments = new List<object>();
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Try to fetch from Department table
                    try
                    {
                        string query = @"
                            SELECT DepartmentID, DepartmentName, Description,
                                   ISNULL(DepartmentCode, LOWER(REPLACE(DepartmentName, ' ', '-'))) AS DepartmentCode
                            FROM Department 
                            WHERE ISNULL(IsActive, 1) = 1 
                            ORDER BY DepartmentName";
                        
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    departments.Add(new
                                    {
                                        id = Convert.ToInt32(reader["DepartmentID"]),
                                        code = reader["DepartmentCode"].ToString(),
                                        name = reader["DepartmentName"].ToString()
                                    });
                                }
                            }
                        }
                        
                        // If we got departments from the table, return them
                        if (departments.Count > 0)
                        {
                            return new { success = true, data = departments };
                        }
                    }
                    catch (SqlException ex)
                    {
                        // Log the error
                        System.Diagnostics.Debug.WriteLine($"Error fetching from Department table: {ex.Message}");
                    }
                    
                    // Fallback: Get unique departments from the Courses table
                    string fallbackQuery = @"
                        SELECT DISTINCT Department as DepartmentName, 
                               LOWER(REPLACE(Department, ' ', '-')) as DepartmentCode
                        FROM Courses 
                        WHERE Department IS NOT NULL 
                        ORDER BY Department";
                    
                    using (SqlCommand cmd = new SqlCommand(fallbackQuery, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            int id = 1;
                            while (reader.Read())
                            {
                                departments.Add(new
                                {
                                    id = id++,
                                    code = reader["DepartmentCode"].ToString(),
                                    name = reader["DepartmentName"].ToString()
                                });
                            }
                        }
                    }
                    
                    // If we still don't have any departments, add default ones
                    if (departments.Count == 0)
                    {
                        departments.Add(new { id = 1, code = "computer-science", name = "Computer Science" });
                        departments.Add(new { id = 2, code = "mathematics", name = "Mathematics" });
                        departments.Add(new { id = 3, code = "education", name = "Education" });
                        departments.Add(new { id = 4, code = "business", name = "Business" });
                    }
                }
                
                return new { success = true, data = departments };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in GetDepartments: {ex.Message}");
                return new { success = false, message = ex.Message };
            }
        }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object UpdateCoursesStatus(List<string> courseIds, string status)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    int updatedCount = 0;
                    
                    foreach (string courseId in courseIds)
                    {
                        string updateQuery = @"
                            UPDATE Courses 
                            SET Status = @Status, ModifiedDate = GETDATE()
                            WHERE CourseCode = @CourseCode";
                        
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@CourseCode", courseId);
                            cmd.Parameters.AddWithValue("@Status", status);
                            updatedCount += cmd.ExecuteNonQuery();
                        }
                    }
                    
                    if (updatedCount > 0)
                    {
                        return new { 
                            success = true, 
                            message = $"Successfully updated {updatedCount} course(s)",
                            updatedCount = updatedCount 
                        };
                    }
                    else
                    {
                        return new { 
                            success = false, 
                            message = "No courses were updated. Please check the course codes." 
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = $"Error updating courses: {ex.Message}" };
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object DeleteCourses(List<string> courseIds)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    int deletedCount = 0;
                    List<string> errorMessages = new List<string>();
                    
                    // Use a transaction to ensure atomicity
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            foreach (string courseId in courseIds)
                            {
                                // First check for enrollments
                                string checkQuery = @"
                                    SELECT COUNT(*) 
                                    FROM UserCourses uc
                                    JOIN Courses c ON uc.CourseID = c.CourseID
                                    WHERE c.CourseCode = @CourseCode";
                                
                                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn, transaction))
                                {
                                    checkCmd.Parameters.AddWithValue("@CourseCode", courseId);
                                    int enrollmentCount = (int)checkCmd.ExecuteScalar();
                                    
                                    if (enrollmentCount > 0)
                                    {
                                        errorMessages.Add($"Course {courseId} has active enrollments and cannot be deleted");
                                        continue;
                                    }
                                }
                                
                                // If no enrollments, proceed with deletion
                                string deleteQuery = "DELETE FROM Courses WHERE CourseCode = @CourseCode";
                                using (SqlCommand cmd = new SqlCommand(deleteQuery, conn, transaction))
                                {
                                    cmd.Parameters.AddWithValue("@CourseCode", courseId);
                                    deletedCount += cmd.ExecuteNonQuery();
                                }
                            }
                            
                            // If some courses were deleted and there were no errors, commit
                            if (deletedCount > 0 && errorMessages.Count == 0)
                            {
                                transaction.Commit();
                                return new { 
                                    success = true, 
                                    message = $"Successfully deleted {deletedCount} course(s)",
                                    deletedCount = deletedCount 
                                };
                            }
                            // If some courses were deleted but there were also errors
                            else if (deletedCount > 0)
                            {
                                transaction.Commit();
                                return new { 
                                    success = true, 
                                    message = $"Deleted {deletedCount} course(s). Some courses could not be deleted: {String.Join(", ", errorMessages)}",
                                    deletedCount = deletedCount,
                                    errors = errorMessages
                                };
                            }
                            // If no courses were deleted
                            else
                            {
                                transaction.Rollback();
                                return new { 
                                    success = false, 
                                    message = errorMessages.Count > 0 ? 
                                        $"No courses were deleted. Errors: {String.Join(", ", errorMessages)}" : 
                                        "No courses were deleted. Please check the course codes.",
                                    errors = errorMessages
                                };
                            }
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            throw; // Re-throw to be caught by outer catch
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = $"Error deleting courses: {ex.Message}" };
            }
        }
    }
}