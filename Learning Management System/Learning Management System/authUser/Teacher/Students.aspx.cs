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
    public partial class Students : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class StudentInfo
        {
            public string Name { get; set; }
            public string StudentID { get; set; }
            public string CourseCode { get; set; }
            public string Email { get; set; }
            public string Phone { get; set; }
            public string Department { get; set; }
            public string Level { get; set; }
            public string Programme { get; set; }
            public string Status { get; set; }
            public string Img { get; set; }
        }

        [WebMethod(EnableSession = true)]
        public static string GetStudents(string search = "", string courseCode = "")
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var students = new List<StudentInfo>();

            if (string.IsNullOrEmpty(teacherId))
                return "[]";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT u.FullName, u.UserID AS StudentID, c.CourseCode, u.Email, u.Phone, d.DepartmentName, l.LevelName, p.ProgrammeName, u.IsActive,
                           ISNULL(u.ProfilePicture, '../../Assest/Images/ProfileUew.png') AS Img
                    FROM Users u
                    INNER JOIN UserCourses uc ON uc.UserID = u.UserID
                    INNER JOIN Courses c ON c.CourseID = uc.CourseID
                    LEFT JOIN Department d ON d.DepartmentID = u.DepartmentID
                    LEFT JOIN Level l ON l.LevelID = u.LevelID
                    LEFT JOIN Programme p ON p.ProgrammeID = u.ProgrammeID
                    WHERE  u.UserType = 'student' and c.UserID = @TeacherId
                ";

                if (!string.IsNullOrEmpty(search))
                    sql += " AND (u.FullName LIKE @Search OR u.UserID LIKE @Search OR u.Email LIKE @Search)";

                if (!string.IsNullOrEmpty(courseCode))
                    sql += " AND c.CourseCode = @CourseCode";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    if (!string.IsNullOrEmpty(search))
                        cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                    if (!string.IsNullOrEmpty(courseCode))
                        cmd.Parameters.AddWithValue("@CourseCode", courseCode);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            students.Add(new StudentInfo
                            {
                                Name = reader["FullName"].ToString(),
                                StudentID = reader["StudentID"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                Email = reader["Email"].ToString(),
                                Phone = reader["Phone"].ToString(),
                                Department = reader["DepartmentName"].ToString(),
                                Level = reader["LevelName"].ToString(),
                                Programme = reader["ProgrammeName"].ToString(),
                                Status = (reader["IsActive"] != DBNull.Value && (bool)reader["IsActive"]) ? "Active" : "Inactive",
                                Img = reader["Img"].ToString()
                            });
                        }
                    }
                }
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(students);
        }

        public class CourseOption
        {
            public string CourseCode { get; set; }
            public string CourseName { get; set; }
        }

[WebMethod(EnableSession = true)]
public static string GetTeacherCourses()
{
    string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
    var courses = new List<CourseOption>();

    if (string.IsNullOrEmpty(teacherId))
        return "[]";

    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    using (SqlConnection conn = new SqlConnection(connStr))
    {
        string sql = @"
            SELECT DISTINCT c.CourseCode, c.CourseName
            FROM Courses c
            WHERE c.UserID = @TeacherId AND c.IsActive = 1
        ";
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
    }
}