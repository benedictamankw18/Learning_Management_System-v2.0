using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Configuration;
using System.Collections.Generic;
using System.Data.SqlClient;


namespace Learning_Management_System.authUser.Admin
{
    public partial class CourseDetails : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetCourseDetails(int courseId)
{
    try
    {
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = @"
                SELECT TOP 1 
                    c.[CourseID], c.[CourseCode], c.[CourseName], c.[Description], c.[Credits], 
                    c.[Status], c.[StartDate], c.[EndDate], c.[IsActive], c.[UserID],
                    u.[FullName] AS InstructorName
                FROM [Courses] c
                LEFT JOIN [Users] u ON c.UserID = u.UserID
                WHERE c.CourseID = @CourseID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new
                        {
                            success = true,
                            data = new
                            {
                                id = (int)reader["CourseID"],
                                code = reader["CourseCode"]?.ToString(),
                                name = reader["CourseName"]?.ToString(),
                                description = reader["Description"]?.ToString(),
                                credits = reader["Credits"] != DBNull.Value ? (int?)reader["Credits"] : null,
                                status = reader["Status"]?.ToString(),
                                startDate = reader["StartDate"] != DBNull.Value ? ((DateTime)reader["StartDate"]).ToString("yyyy-MM-dd") : "",
                                endDate = reader["EndDate"] != DBNull.Value ? ((DateTime)reader["EndDate"]).ToString("yyyy-MM-dd") : "",
                                isActive = reader["IsActive"] != DBNull.Value ? (bool)reader["IsActive"] : false,
                                instructor = reader["InstructorName"]?.ToString() ?? "-"
                            }
                        };
                    }
                }
            }
        }
        return new { success = false, message = "Course not found." };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

        [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object AddSection(int courseId, string sectionName, string description, int orderIndex)
    {
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"INSERT INTO CourseSections (CourseId, SectionName, Description, OrderIndex, IsActive, CreatedDate)
                             VALUES (@CourseId, @SectionName, @Description, @OrderIndex, 1, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@SectionName", sectionName);
                    cmd.Parameters.AddWithValue("@Description", description ?? "");
                    cmd.Parameters.AddWithValue("@OrderIndex", orderIndex);

                    int rows = cmd.ExecuteNonQuery();
                    return new { success = rows > 0 };
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
public static object GetCourseStats(int courseId)
{
    try
    {
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        int totalSections = 0;
        int totalMaterials = 0;
        int enrolledStudents = 0;
        double completionRate = 0.0;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            // Total Sections
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM CourseSections WHERE CourseId = @CourseId", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                totalSections = (int)cmd.ExecuteScalar();
            }

            // Total Materials
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM CourseMaterials WHERE CourseId = @CourseId", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                totalMaterials = (int)cmd.ExecuteScalar();
            }

            // Enrolled Students (students only)
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT COUNT(DISTINCT uc.UserID)
                FROM UserCourses uc
                INNER JOIN Users u ON uc.UserID = u.UserID
                WHERE uc.CourseID = @CourseId AND u.UserType = 'student'", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                enrolledStudents = (int)cmd.ExecuteScalar();
            }

            // Completion Rate (students only)
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    CASE WHEN COUNT(*) = 0 THEN 0 ELSE
                        CAST(SUM(CASE WHEN uc.IsCompleted = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100
                    END
                FROM UserCourses uc
                INNER JOIN Users u ON uc.UserID = u.UserID
                WHERE uc.CourseID = @CourseId AND u.UserType = 'student'", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                object result = cmd.ExecuteScalar();
                completionRate = result != DBNull.Value ? Convert.ToDouble(result) : 0.0;
            }
        }

        return new
        {
            success = true,
            data = new
            {
                totalSections,
                totalMaterials,
                enrolledStudents,
                completionRate
            }
        };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCourseSections(int courseId)
        {
            try
            {
                var sections = new List<object>();
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"SELECT s.CourseSectionsId, s.SectionName, s.Description,
                                (SELECT COUNT(*) FROM CourseMaterials WHERE SectionId = s.CourseSectionsId) AS Materials
                         FROM CourseSections s WHERE s.CourseId = @CourseID ORDER BY s.OrderIndex, s.CourseSectionsId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                sections.Add(new
                                {
                                    id = reader["CourseSectionsId"],
                                    name = reader["SectionName"] == DBNull.Value ? "" : reader["SectionName"].ToString(),
                                    description = reader["Description"] == DBNull.Value ? "" : reader["Description"].ToString(),
                                    materials = reader["Materials"] == DBNull.Value ? 0 : Convert.ToInt32(reader["Materials"])
                                });
                            }
                        }
                    }
                }
                return new { success = true, data = sections };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

     public class CourseUpdateRequest
{
    public int id { get; set; }
    public string name { get; set; }
    public string code { get; set; }
    public string description { get; set; }
    public int? credits { get; set; }
    public int? departmentId { get; set; }
    public int? levelId { get; set; }
    public int? programmeId { get; set; }
    public string status { get; set; }
    public string startDate { get; set; }
    public string endDate { get; set; }
    public bool? isActive { get; set; }
    public int? userId { get; set; }
}

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object UpdateCourse(CourseUpdateRequest request)
{
    try
    {
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = @"UPDATE Courses SET 
                                CourseName = @CourseName,
                                CourseCode = @CourseCode,
                                Description = @Description,
                                Credits = @Credits,
                                DepartmentID = @DepartmentID,
                                LevelID = @LevelID,
                                ProgrammeID = @ProgrammeID,
                                Status = @Status,
                                StartDate = @StartDate,
                                EndDate = @EndDate,
                                ModifiedDate = GETDATE(),
                                IsActive = @IsActive,
                                UserID = @UserID
                            WHERE CourseID = @CourseID";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@CourseID", request.id);
                cmd.Parameters.AddWithValue("@CourseName", request.name ?? "");
                cmd.Parameters.AddWithValue("@CourseCode", request.code ?? "");
                cmd.Parameters.AddWithValue("@Description", request.description ?? "");
                cmd.Parameters.AddWithValue("@Credits", (object)request.credits ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@DepartmentID", (object)request.departmentId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@LevelID", (object)request.levelId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@ProgrammeID", (object)request.programmeId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Status", request.status ?? "active");
                cmd.Parameters.AddWithValue("@StartDate", string.IsNullOrEmpty(request.startDate) ? (object)DBNull.Value : request.startDate);
                cmd.Parameters.AddWithValue("@EndDate", string.IsNullOrEmpty(request.endDate) ? (object)DBNull.Value : request.endDate);
                cmd.Parameters.AddWithValue("@IsActive", request.isActive ?? true);
                cmd.Parameters.AddWithValue("@UserID", (object)request.userId ?? DBNull.Value);

                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

    }
}