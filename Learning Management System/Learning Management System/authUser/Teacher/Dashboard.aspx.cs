using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace Learning_Management_System.authUser.Teacher
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null ?
            ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString : null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in and is a teacher
                if (Session["UserID"] == null && Session["admin"] == null)
                {
                    Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }
                else
                {
                    string teacherId = Session["UserID"]?.ToString();
                    lblTeacherName.Text = Session["FullName"]?.ToString() ?? "Teacher";
                    lblTotalCourses.Text = GetTotalCourses(teacherId).ToString();
                    lblTotalStudents.Text = GetTotalStudents(teacherId).ToString();
                    lblActiveAssignments.Text = GetActiveAssignments(teacherId).ToString();
                    lblPendingSubmissions.Text = GetPendingReviews(teacherId).ToString();

                }

            }
        }

        private void LogError(string message, Exception ex)
        {
            try
            {
                if (!string.IsNullOrEmpty(connectionString))
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string query = @"
                            INSERT INTO SystemLogs (LogType, Message, Exception, Timestamp, IPAddress)
                            VALUES ('Error', @Message, @Exception, GETDATE(), @IPAddress)";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@Message", message);
                            cmd.Parameters.AddWithValue("@Exception", ex.ToString());
                            cmd.Parameters.AddWithValue("@IPAddress", Request.UserHostAddress);

                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch
            {
                // Fail silently for logging errors
            }
        }


        private int GetTotalCourses(string teacherId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString))
            {
                conn.Open();
                string sql = "SELECT COUNT(*) FROM Courses WHERE UserId = @TeacherID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private int GetTotalStudents(string teacherId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString))
            {
                conn.Open();
                string sql = @"SELECT COUNT(DISTINCT sc.UserID)
                           FROM UserCourses sc
                           INNER JOIN Courses c ON sc.CourseID = c.CourseID
                           join Users u on u.UserID = sc.UserID
                           WHERE u.UserType='Student'  and c.UserId = @TeacherID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private int GetActiveAssignments(string teacherId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString))
            {
                conn.Open();
                string sql = @"SELECT COUNT(*)
                           FROM Assignments a
                           INNER JOIN Courses c ON a.CourseID = c.CourseID
                           WHERE c.UserId = @TeacherID AND a.Status = 'Open'";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private int GetPendingReviews(string teacherId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString))
            {
                conn.Open();
                string sql = @"SELECT COUNT(*) FROM AssignmentSubmissions s
                           INNER JOIN Assignments a ON s.AssignmentID = a.AssignmentID
                           INNER JOIN UserCourses tc ON a.CourseID = tc.CourseID
                           WHERE tc.UserID = @TeacherID AND (s.Score IS NULL OR s.Score = 0)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public static string GetPerformanceChartData()
        {
            var teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var result = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"
                        SELECT 
                DATEPART(week, s.SubmittedAt) AS WeekNum,
                s.CourseID,
                AVG(CAST(s.Score AS FLOAT)) AS AvgScore,
                COUNT(s.SubmissionID) * 100.0 / NULLIF((SELECT COUNT(*) FROM UserCourses uc WHERE uc.CourseID = s.CourseID), 0) AS SubmissionRate
            FROM AssignmentSubmissions s
            INNER JOIN Assignments a ON s.AssignmentID = a.AssignmentID
            INNER JOIN UserCourses tc ON a.CourseID = tc.CourseID
            WHERE tc.UserID = @TeacherID
            GROUP BY DATEPART(week, s.SubmittedAt), s.CourseID
            ORDER BY WeekNum";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new
                            {
                                week = "Week " + reader["WeekNum"].ToString(),
                                avgScore = reader["AvgScore"] == DBNull.Value ? 0 : Math.Round(Convert.ToDouble(reader["AvgScore"]), 1),
                                submissionRate = reader["SubmissionRate"] == DBNull.Value ? 0 : Math.Round(Convert.ToDouble(reader["SubmissionRate"]), 1)
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
        }

        [WebMethod(EnableSession = true)]
        public static string GetRecentActivity()
        {
            var teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var result = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Assignment submissions
                string sqlSubmissions = @"
            SELECT TOP 5 
                u.FullName AS StudentName,
                a.Title AS AssignmentTitle,
                c.CourseName,
                s.SubmittedAt,
                s.Score,
                'submission' AS ActivityType
            FROM AssignmentSubmissions s
            INNER JOIN Assignments a ON s.AssignmentID = a.AssignmentID
            INNER JOIN Courses c ON a.CourseID = c.CourseID
            INNER JOIN Users u ON s.StudentID = u.UserID
            WHERE c.UserId = @TeacherID
            ORDER BY s.SubmittedAt DESC";
                using (SqlCommand cmd = new SqlCommand(sqlSubmissions, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new
                            {
                                type = "submission",
                                student = reader["StudentName"].ToString(),
                                assignment = reader["AssignmentTitle"].ToString(),
                                course = reader["CourseName"].ToString(),
                                submittedAt = reader["SubmittedAt"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(reader["SubmittedAt"]).ToString("dd MMM yyyy, HH:mm"),
                                score = reader["Score"] == DBNull.Value ? "Ungraded" : reader["Score"].ToString()
                            });
                        }
                    }
                }

                // 2. Student enrollments
                string sqlEnrollments = @"
            SELECT TOP 5 
                u.FullName AS StudentName,
                c.CourseName,
                sc.EnrollmentDate,
                'enrollment' AS ActivityType
            FROM UserCourses sc
            INNER JOIN Courses c ON sc.CourseID = c.CourseID
            INNER JOIN Users u ON sc.UserID = u.UserID
            WHERE c.UserId = @TeacherID AND u.UserType = 'Student'
            ORDER BY sc.EnrollmentDate DESC";
                using (SqlCommand cmd = new SqlCommand(sqlEnrollments, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new
                            {
                                type = "enrollment",
                                student = reader["StudentName"].ToString(),
                                course = reader["CourseName"].ToString(),
                                enrolledAt = reader["EnrollmentDate"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(reader["EnrollmentDate"]).ToString("dd MMM yyyy, HH:mm")
                                 });
                        }
                    }
                }

                // 3. Quiz posts
                string sqlQuizPosts = @"
            SELECT TOP 5 
                q.Title AS QuizTitle,
                c.CourseName,
                q.CreatedDate,
                'quiz_post' AS ActivityType
            FROM Quizzes q
            INNER JOIN Courses c ON q.CourseID = c.CourseID
            WHERE c.UserId = @TeacherID
            ORDER BY q.CreatedDate DESC";
                using (SqlCommand cmd = new SqlCommand(sqlQuizPosts, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new
                            {
                                type = "quiz_post",
                                quiz = reader["QuizTitle"].ToString(),
                                course = reader["CourseName"].ToString(),
                                createdAt = reader["CreatedDate"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(reader["CreatedDate"]).ToString("dd MMM yyyy, HH:mm"),
                            });
                        }
                    }
                }

                // 4. Assignment deadlines
                string sqlDeadlines = @"
            SELECT TOP 5 
                a.Title AS AssignmentTitle,
                c.CourseName,
                a.DueDate,
                'deadline' AS ActivityType
            FROM Assignments a
            INNER JOIN Courses c ON a.CourseID = c.CourseID
            WHERE c.UserId = @TeacherID AND a.DueDate > GETDATE()
            ORDER BY a.DueDate ASC";
                using (SqlCommand cmd = new SqlCommand(sqlDeadlines, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new
                            {
                                type = "deadline",
                                assignment = reader["AssignmentTitle"].ToString(),
                                course = reader["CourseName"].ToString(),
                                dueDate = reader["DueDate"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(reader["DueDate"]).ToString("dd MMM yyyy, HH:mm")
                            });
                        }
                    }
                }

                // 5. Quiz submissions
                string sqlQuizSubmissions = @"
            SELECT TOP 5 
                u.FullName AS StudentName,
                q.Title AS QuizTitle,
                c.CourseName,
                s.SubmittedAt,
                s.Score,
                'quiz_submission' AS ActivityType
            FROM QuizSubmissions s
            INNER JOIN Quizzes q ON s.QuizID = q.QuizID
            INNER JOIN Courses c ON q.CourseID = c.CourseID
            INNER JOIN Users u ON s.UserId = u.UserID
            WHERE c.UserId = @TeacherID
            ORDER BY s.SubmittedAt DESC";
                using (SqlCommand cmd = new SqlCommand(sqlQuizSubmissions, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(new
                            {
                                type = "quiz_submission",
                                student = reader["StudentName"].ToString(),
                                quiz = reader["QuizTitle"].ToString(),
                                course = reader["CourseName"].ToString(),
                                submittedAt = reader["SubmittedAt"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(reader["SubmittedAt"]).ToString("dd MMM yyyy, HH:mm"),
                                score = reader["Score"] == DBNull.Value ? "Ungraded" : reader["Score"].ToString()
                            });
                        }
                    }
                }
            }

            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
        }

    }
}
