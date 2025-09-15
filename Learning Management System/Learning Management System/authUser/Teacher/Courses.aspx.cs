using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;


namespace Learning_Management_System.authUser.Teacher
{
    public partial class Courses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class TeacherCourse
        {
            public string Code { get; set; }
            public string Name { get; set; }
            public int Credit { get; set; }
            public string Desc { get; set; }
            public string Start { get; set; }
            public string End { get; set; }
            public int Students { get; set; }
            public string Status { get; set; }
            public string Semester { get; set; }
        }

     [WebMethod(EnableSession = true)]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static string GetAssignedCourses(string search, string semester)
{
    try
    {
        string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
        var courses = new List<TeacherCourse>();

        if (string.IsNullOrEmpty(teacherId))
            return "[]";

        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"
                SELECT 
                    c.CourseCode, 
                    c.CourseName, 
                    c.Credits, 
                    c.Description, 
                    c.StartDate, 
                    c.EndDate, 
                    c.Status,
                    CASE 
                        WHEN MONTH(c.StartDate) BETWEEN 1 AND 6 THEN '1'
                        WHEN MONTH(c.StartDate) BETWEEN 7 AND 12 THEN '2'
                        ELSE 'Other'
                    END AS Semester,
                    c.UserID,
                    ISNULL((
                        SELECT COUNT(*) 
                        FROM UserCourses uc
                        JOIN Users u ON u.UserID = uc.UserID
                        WHERE uc.CourseID = c.CourseID  
                        AND u.UserType = 'student'
                    ), 0) AS Students
                FROM Courses c
                JOIN Users u ON u.UserID = c.UserID
                WHERE c.IsActive = 1 AND c.UserID = @TeacherId
            ";

            if (!string.IsNullOrEmpty(search))
                sql += " AND (c.CourseName LIKE @Search OR c.CourseCode LIKE @Search)";

            if (!string.IsNullOrEmpty(semester))
                sql += @" AND CASE 
                                WHEN MONTH(c.StartDate) BETWEEN 1 AND 6 THEN '1'
                                WHEN MONTH(c.StartDate) BETWEEN 7 AND 12 THEN '2'
                                ELSE 'Other'
                            END  = @Semester";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                if (!string.IsNullOrEmpty(semester))
                    cmd.Parameters.AddWithValue("@Semester", semester);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        courses.Add(new TeacherCourse
                        {
                            Code = reader["CourseCode"].ToString(),
                            Name = reader["CourseName"].ToString(),
                            Credit = reader["Credits"] != DBNull.Value ? Convert.ToInt32(reader["Credits"]) : 0,
                            Desc = reader["Description"].ToString(),
                            Start = reader["StartDate"] != DBNull.Value ? Convert.ToDateTime(reader["StartDate"]).ToString("yyyy-MM-dd") : "",
                            End = reader["EndDate"] != DBNull.Value ? Convert.ToDateTime(reader["EndDate"]).ToString("yyyy-MM-dd") : "",
                            Students = reader["Students"] != DBNull.Value ? Convert.ToInt32(reader["Students"]) : 0,
                            Status = reader["Status"].ToString(),
                            Semester = reader["Semester"].ToString()
                        });
                    }
                }
            }
        }

        JavaScriptSerializer js = new JavaScriptSerializer();
        return js.Serialize(courses);
    }
    catch (Exception ex)
    {
        return "{\"error\": \"" + ex.Message.Replace("\"", "'") + "\"}";
    }
}

    }
}
