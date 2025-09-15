using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;
        
namespace Learning_Management_System.authUser.Teacher
{
    public partial class Assignments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod(EnableSession = true)]
        public static string GetTeacherCourses()
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var courses = new List<CourseOption>();
            if (string.IsNullOrEmpty(teacherId)) return "[]";
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT DISTINCT c.CourseCode, c.CourseName FROM Courses c WHERE c.UserID = @TeacherId AND c.IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new CourseOption
                            {
                                CourseCode = reader["CourseCode"].ToString(),
                                CourseName = reader["CourseName"].ToString()
                            });
                        }
                    }
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(courses);
        }
        public class CourseOption
        {
            public string CourseCode { get; set; }
            public string CourseName { get; set; }
        }


      public class AssignmentInfo
{
    public int AssignmentID { get; set; }
    public string Title { get; set; }
    public string CourseCode { get; set; }
    public string DueDate { get; set; }
    public string Status { get; set; }
    public string Description { get; set; }
    public string FilePath { get; set; } 
}


        [WebMethod(EnableSession = true)]
        public static string GetAssignments(string courseCode = "", string search = "")
        {
            try
            {
                string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
                var assignments = new List<AssignmentInfo>();
                if (string.IsNullOrEmpty(teacherId)) return "[]";
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {

                    string updateSql = "UPDATE Assignments SET Status='Closed' WHERE DueDate < CAST(GETDATE() AS DATE) AND Status='Open'";
                    using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }

                    string sql = @"
                    SELECT a.AssignmentID, a.Title, c.CourseCode, a.DueDate, a.Status, a.Description, a.FilePath
                    FROM Assignments a
                    INNER JOIN Courses c ON c.CourseID = a.CourseID
                    WHERE c.UserID = @TeacherId
                ";
                    if (!string.IsNullOrEmpty(courseCode))
                        sql += " AND c.CourseCode = @CourseCode";
                    if (!string.IsNullOrEmpty(search))
                        sql += " AND (a.Title LIKE @Search OR a.Description LIKE @Search)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        if (!string.IsNullOrEmpty(courseCode))
                            cmd.Parameters.AddWithValue("@CourseCode", courseCode);
                        if (!string.IsNullOrEmpty(search))
                            cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                assignments.Add(new AssignmentInfo
                                {
                                    AssignmentID = (int)reader["AssignmentID"],
                                    Title = reader["Title"].ToString(),
                                    CourseCode = reader["CourseCode"].ToString(),
                                    DueDate = reader["DueDate"] != DBNull.Value ? Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-dd") : "",
                                    Status = reader["Status"].ToString(),
                                    Description = reader["Description"].ToString(),
                                    FilePath = reader["FilePath"]?.ToString()
                                });
                            }
                        }
                    }


                }
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(assignments);
             }
    catch (Exception ex)
    {
        return "{\"error\": \"" + ex.Message.Replace("\"", "'") + "\"}";
    }
        }

        [WebMethod(EnableSession = true)]
        public static string AddAssignment(string title, string courseCode, string dueDate, string description, string status, string filePath)
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(teacherId)) return "{\"success\":false,\"message\":\"Not logged in.\"}";
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Get CourseID from CourseCode and TeacherID
                string getCourseSql = "SELECT CourseID FROM Courses WHERE CourseCode = @CourseCode AND UserID = @TeacherId";
                int courseId = 0;
                using (SqlCommand cmd = new SqlCommand(getCourseSql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseCode", courseCode);
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    var result = cmd.ExecuteScalar();
                    if (result == null) return "{\"success\":false,\"message\":\"Course not found.\"}";
                    courseId = Convert.ToInt32(result);
                    conn.Close();
                }
                string sql = @"INSERT INTO Assignments (Title, CourseID, DueDate, Status, Description, FilePath) 
                   VALUES (@Title, @CourseID, @DueDate, @Status, @Description, @FilePath)";
    using (SqlCommand cmd = new SqlCommand(sql, conn))
    {
        cmd.Parameters.AddWithValue("@Title", title);
        cmd.Parameters.AddWithValue("@CourseID", courseId);
        cmd.Parameters.AddWithValue("@DueDate", dueDate);
        cmd.Parameters.AddWithValue("@Status", status);
        cmd.Parameters.AddWithValue("@Description", description ?? "");
        cmd.Parameters.AddWithValue("@FilePath", filePath ?? "");
        conn.Open();
        cmd.ExecuteNonQuery();
    }
    return "{\"success\":true}";
}
}

        // Edit Assignment
        [WebMethod(EnableSession = true)]
public static string EditAssignment(int assignmentId, string title, string dueDate, string description, string status, string filePath)
{
    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    using (SqlConnection conn = new SqlConnection(connStr))
    {
        string sql = @"UPDATE Assignments SET Title=@Title, DueDate=@DueDate, Description=@Description, Status=@Status"
                   + (string.IsNullOrEmpty(filePath) ? "" : ", FilePath=@FilePath")
                   + " WHERE AssignmentID=@AssignmentID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@Title", title);
            cmd.Parameters.AddWithValue("@DueDate", dueDate);
            cmd.Parameters.AddWithValue("@Description", description ?? "");
            cmd.Parameters.AddWithValue("@Status", status);
            if (!string.IsNullOrEmpty(filePath))
                cmd.Parameters.AddWithValue("@FilePath", filePath);
            cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }
    return "{\"success\":true}";
}
        // Delete Assignment
        [WebMethod(EnableSession = true)]
        public static string DeleteAssignment(int assignmentId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"DELETE FROM Assignments WHERE AssignmentID=@AssignmentID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            return "{\"success\":true}";
        }





    }
}
