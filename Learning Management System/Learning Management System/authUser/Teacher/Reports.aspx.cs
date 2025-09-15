using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Data.SqlClient;

namespace Learning_Management_System.authUser.Teacher
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

         public class CourseOption
        {
            public string CourseID { get; set; }
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
                string sql = @"SELECT DISTINCT c.CourseID, c.CourseName FROM Courses c WHERE c.UserID = @TeacherId AND c.IsActive = 1 ORDER BY c.CourseName";
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
                                CourseID = reader["CourseID"].ToString(),
                                CourseName = reader["CourseName"].ToString()
                            });
                        }
                    }
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(courses);
        }

        public class StudentReportInfo
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
        public static string GetStudentReports(string courseId = "", string status = "", string quiz = "")
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var students = new List<StudentReportInfo>();
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
                    WHERE u.UserType = 'student' and c.UserID = @TeacherId
                ";
                if (!string.IsNullOrEmpty(courseId))
                    sql += " AND c.CourseID = @CourseID";
                if (!string.IsNullOrEmpty(status))
                {
                    if (status == "completed")
                        sql += " AND uc.IsCompleted = 1";
                    else if (status == "incomplete")
                        sql += " AND uc.IsCompleted = 0";
                }
                // Quiz filter can be added here if needed

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    if (!string.IsNullOrEmpty(courseId))
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            students.Add(new StudentReportInfo
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

        public class CourseReportInfo
        {
            public string Code { get; set; }
            public string Name { get; set; }
            public int Students { get; set; }
            public string Status { get; set; }
            public string Quiz { get; set; }
        }

        [WebMethod(EnableSession = true)]
        public static string GetCourseReports(string courseId = "", string status = "", string quiz = "")
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var courses = new List<CourseReportInfo>();
            if (string.IsNullOrEmpty(teacherId))
                return "[]";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT c.CourseID, c.CourseCode, c.CourseName, 
                        ISNULL((SELECT COUNT(*) FROM UserCourses uc WHERE uc.CourseID = c.CourseID), 0) AS Students,
                        c.Status
                    FROM Courses c
                    WHERE c.UserID = @TeacherId AND c.IsActive = 1
                ";
                if (!string.IsNullOrEmpty(courseId))
                    sql += " AND c.CourseID = @CourseID";
                if (!string.IsNullOrEmpty(status))
                    sql += " AND c.Status = @Status";
                // Quiz filter can be added here if needed

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    if (!string.IsNullOrEmpty(courseId))
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                    if (!string.IsNullOrEmpty(status))
                        cmd.Parameters.AddWithValue("@Status", status);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new CourseReportInfo
                            {
                                Code = reader["CourseCode"].ToString(),
                                Name = reader["CourseName"].ToString(),
                                Students = reader["Students"] != DBNull.Value ? Convert.ToInt32(reader["Students"]) : 0,
                                Status = reader["Status"].ToString(),
                                Quiz = quiz // Placeholder, as quiz logic is not implemented
                            });
                        }
                    }
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(courses);
        }
 
 
         public class QuizOption
        {
            public string QuizID { get; set; }
            public string QuizTitle { get; set; }
        }

        [WebMethod(EnableSession = true)]
        public static string GetQuizzesForCourse(string courseId)
        {
            var quizzes = new List<QuizOption>();
            if (string.IsNullOrEmpty(courseId))
                return "[]";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                string sql = "SELECT QuizID, Title FROM Quizzes WHERE CourseID = 57 ORDER BY Title";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            quizzes.Add(new QuizOption
                            {
                                QuizID = reader["QuizID"].ToString(),
                                QuizTitle = reader["Title"].ToString()
                            });
                        }
                    }
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(quizzes);
        }
    }
}