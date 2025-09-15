using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{

    public partial class Dashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LMSConnectionString"] != null ?
            ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString : null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in and is a student
                if (Session["UserID"] == null && Session["Student"] == null)
                {
                    Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }

                LoadDashboardData();
            }
        }

        [WebMethod]
        public static string GetUpcomingDeadlines()
        {
            int userId = 0;
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }
            var deadlines = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Assignments
                string sqlAssignments = @"
                    SELECT TOP 5 a.Title, c.CourseName, a.DueDate
                    FROM Assignments a
                    JOIN Courses c ON a.CourseID = c.CourseID
                    JOIN UserCourses uc ON uc.CourseID = c.CourseID
                    WHERE uc.UserID = @UserID AND a.DueDate >= GETDATE()
                    ORDER BY a.DueDate ASC";
                using (var cmd = new SqlCommand(sqlAssignments, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            deadlines.Add(new
                            {
                                type = "assignment",
                                title = reader["Title"].ToString(),
                                course = reader["CourseName"].ToString(),
                                date = ((DateTime)reader["DueDate"]).ToString("MMM dd, yyyy"),
                                icon = "fa-file-alt",
                                color = "rgba(255, 193, 7, 0.1)"
                            });
                        }
                    }
                }

                // Quizzes
                string sqlQuizzes = @"
                    SELECT TOP 3 q.Title, c.CourseName, q.StartDate
                    FROM Quizzes q
                    JOIN Courses c ON q.CourseId = c.CourseID
                    JOIN UserCourses uc ON uc.CourseID = c.CourseID
                    WHERE uc.UserID = @UserID AND q.Status = 'active' AND q.IsActivated = 1 AND q.StartDate >= GETDATE()
                    ORDER BY q.StartDate ASC";
                using (var cmd = new SqlCommand(sqlQuizzes, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            deadlines.Add(new
                            {
                                type = "quiz",
                                title = reader["Title"].ToString(),
                                course = reader["CourseName"].ToString(),
                                date = ((DateTime)reader["StartDate"]).ToString("MMM dd, yyyy"),
                                icon = "fa-clipboard-check",
                                color = "rgba(238, 28, 36, 0.1)"
                            });
                        }
                    }
                }

                // Schedules (classes)
                string sqlSchedules = @"
                    SELECT TOP 3 s.Title, c.CourseName, s.EventDate, s.StartTime
                    FROM Schedules s
                    JOIN Courses c ON s.CourseID = c.CourseID
                    JOIN UserCourses uc ON uc.CourseID = c.CourseID
                    WHERE uc.UserID = @UserID AND s.EventDate >= GETDATE()
                    ORDER BY s.EventDate ASC, s.StartTime ASC";
                using (var cmd = new SqlCommand(sqlSchedules, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            deadlines.Add(new
                            {
                                type = "schedule",
                                title = reader["Title"].ToString(),
                                course = reader["CourseName"].ToString(),
                                date = ((DateTime)reader["EventDate"]).ToString("MMM dd, yyyy") + " " + reader["StartTime"],
                                icon = "fa-calendar-alt",
                                color = "rgba(44, 43, 124, 0.1)"
                            });
                        }
                    }
                }
            }
            // Sort by date ascending
            // (If you want to ensure all deadlines are sorted together)
            //  deadlines = deadlines.OrderByDescending(d => DateTime.ParseExact(
            //      (string)d.GetType().GetProperty("date").GetValue(d), 
            //      "MMM dd, yyyy", 
            //      System.Globalization.CultureInfo.InvariantCulture,
            //      System.Globalization.DateTimeStyles.AllowWhiteSpaces
            //  )).ToList();
            return new JavaScriptSerializer().Serialize(deadlines);
        }

        [WebMethod]
        public static string GetPerformanceScores()
        {
            int userId = 0;
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }
            var scores = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Quiz Scores
                string sqlQuiz = @"
                    SELECT TOP 10 q.Title, c.CourseName, qs.Score
                    FROM QuizSubmissions qs
                    JOIN Quizzes q ON qs.QuizId = q.QuizId
                    JOIN Courses c ON q.CourseId = c.CourseID
                    WHERE qs.UserId = @UserID AND qs.Score IS NOT NULL
                    ORDER BY qs.SubmittedAt DESC";
                using (var cmd = new SqlCommand(sqlQuiz, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            scores.Add(new
                            {
                                type = "quiz",
                                title = reader["Title"].ToString(),
                                course = reader["CourseName"].ToString(),
                                score = reader["Score"] != DBNull.Value ? Convert.ToDecimal(reader["Score"]) : 0
                            });
                        }
                    }
                }
                // Assignment Scores
                string sqlAssignment = @"
                    SELECT TOP 10 a.Title, c.CourseName, asub.Score
                    FROM AssignmentSubmissions asub
                    JOIN Assignments a ON asub.AssignmentID = a.AssignmentID
                    JOIN Courses c ON a.CourseID = c.CourseID
                    WHERE asub.StudentID = @UserID AND asub.Score IS NOT NULL
                    ORDER BY asub.GradedAt DESC, asub.SubmittedAt DESC";
                using (var cmd = new SqlCommand(sqlAssignment, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            scores.Add(new
                            {
                                type = "assignment",
                                title = reader["Title"].ToString(),
                                course = reader["CourseName"].ToString(),
                                score = reader["Score"] != DBNull.Value ? Convert.ToDecimal(reader["Score"]) : 0
                            });
                        }
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(scores);
        }

        private void LoadDashboardData()
        {
            try
            {
                // Set student name
                if (Session["FullName"] != null)
                {
                    lblStudentName.Text = Session["FullName"].ToString();
                }
                else if (Session["FullName"] != null)
                {
                    lblStudentName.Text = Session["FullName"].ToString();
                }

                // Load statistics
                LoadStudentStatistics();
            }
            catch (Exception ex)
            {
                // Log error
                LogError("Dashboard Load Error", ex);
            }
        }



        [WebMethod]
        public static string GetStudentCourses()
        {
            int userId = 0;
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }
            var courses = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"
                    SELECT c.CourseID, c.CourseName, u.FullName AS InstructorName,
                        (
                            SELECT COUNT(*) FROM Assignments a WHERE a.CourseID = c.CourseID
                        ) AS TotalAssignments,
                        (
                            SELECT COUNT(*) FROM AssignmentSubmissions asub WHERE asub.CourseID = c.CourseID AND asub.StudentID = @UserID
                        ) AS CompletedAssignments
                    FROM UserCourses uc
                    JOIN Courses c ON uc.CourseID = c.CourseID
                    LEFT JOIN Users u ON c.UserID = u.UserID
                    WHERE uc.UserID = @UserID
                ";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int total = reader["TotalAssignments"] != DBNull.Value ? Convert.ToInt32(reader["TotalAssignments"]) : 0;
                            int completed = reader["CompletedAssignments"] != DBNull.Value ? Convert.ToInt32(reader["CompletedAssignments"]) : 0;
                            int progress = (total > 0) ? (int)Math.Round((completed * 100.0) / total) : 0;
                            courses.Add(new
                            {
                                id = reader["CourseID"].ToString(),
                                title = reader["CourseName"].ToString(),
                                instructor = reader["InstructorName"] != DBNull.Value ? reader["InstructorName"].ToString() : "-",
                                progress = progress
                            });
                        }
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(courses);
        }

        private void LoadStudentStatistics()
        {
            try
            {
                if (string.IsNullOrEmpty(connectionString))
                {
                    // Set default values if no database connection
                    lblEnrolledCourses.Text = "5";
                    lblPendingAssignments.Text = "3";
                    lblAverageGrade.Text = "85";
                    lblCompletionRate.Text = "75";
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string studentId = Session["UserID"] != null ? Session["UserID"].ToString() :
                                 (Session["UserID"] != null ? Session["UserID"].ToString() : null);

                    if (!string.IsNullOrEmpty(studentId))
                    {
                        // Get enrolled courses count
                        string coursesQuery = @"
                            SELECT COUNT(*) FROM UserCourses e
                            INNER JOIN Courses c ON e.CourseID = c.CourseID
                            INNER JOIN Users u ON u.UserID = e.UserID
                            WHERE e.UserID = @StudentID AND u.IsActive = 1 AND c.IsActive = 1";

                        using (SqlCommand cmd = new SqlCommand(coursesQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@StudentID", studentId);
                            object result = cmd.ExecuteScalar();
                            lblEnrolledCourses.Text = result != null ? result.ToString() : "0";
                        }

                        // Get pending assignments count
                        string assignmentsQuery = @"
                            SELECT COUNT(*) 
                            FROM Assignments a
                            INNER JOIN UserCourses e ON a.CourseID = e.CourseID
                            join Users u ON u.UserID = e.UserID
                            LEFT JOIN AssignmentSubmissions asub ON a.AssignmentID = asub.AssignmentID AND asub.StudentID = e.UserID
                            WHERE e.UserID = @StudentID AND u.IsActive = 1 
                            AND a.Status = 'Open' AND a.DueDate >= GETDATE()
                            AND asub.SubmissionID IS NULL";

                        using (SqlCommand cmd = new SqlCommand(assignmentsQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@StudentID", studentId);
                            object result = cmd.ExecuteScalar();
                            lblPendingAssignments.Text = result != null ? result.ToString() : "0";
                        }

                        // Get average grade
                        string gradeQuery = @"
                            SELECT AVG(CAST(asub.Score AS FLOAT)) 
                            FROM AssignmentSubmissions asub
                            INNER JOIN Assignments a ON asub.AssignmentID = a.AssignmentID
                            WHERE asub.StudentID = @StudentID AND asub.Score IS NOT NULL";

                        using (SqlCommand cmd = new SqlCommand(gradeQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@StudentID", studentId);
                            object result = cmd.ExecuteScalar();
                            if (result != null && result != DBNull.Value)
                            {
                                decimal avgGrade = Convert.ToDecimal(result);
                                lblAverageGrade.Text = Math.Round(avgGrade, 0).ToString();
                            }
                            else
                            {
                                lblAverageGrade.Text = "0";
                            }
                        }

                        // Calculate completion rate (simplified)
                        string completionQuery = @"
                            SELECT 
                                COUNT(CASE WHEN asub.SubmissionID IS NOT NULL THEN 1 END) as Completed,
                                COUNT(*) as Total
                            FROM Assignments a
                            INNER JOIN UserCourses e ON a.CourseID = e.CourseID
                            INNER JOIN Users u ON u.UserID = e.UserID
                            LEFT JOIN AssignmentSubmissions asub ON a.AssignmentID = asub.AssignmentID AND asub.StudentID = e.UserID
                            WHERE e.UserID = @StudentID AND u.IsActive = 1 AND a.Status = 'Open'";

                        using (SqlCommand cmd = new SqlCommand(completionQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@StudentID", studentId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    int completed = Convert.ToInt32(reader["Completed"]);
                                    int total = Convert.ToInt32(reader["Total"]);

                                    if (total > 0)
                                    {
                                        decimal completionRate = (decimal)completed / total * 100;
                                        lblCompletionRate.Text = Math.Round(completionRate, 0).ToString();
                                    }
                                    else
                                    {
                                        lblCompletionRate.Text = "0";
                                    }
                                }
                            }
                        }

                        // Get user name
                        string UserNameQuery = @"
                            SELECT FullName
                            FROM Users
                            WHERE UserID = @StudentID";

                        using (SqlCommand cmd = new SqlCommand(UserNameQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@StudentID", studentId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    lblStudentName.Text = reader["FullName"].ToString();
                                }
                                else
                                {
                                    lblStudentName.Text = "Unknown";
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Set default values on error
                lblEnrolledCourses.Text = "0";
                lblPendingAssignments.Text = "0";
                lblAverageGrade.Text = "0";
                lblCompletionRate.Text = "0";

                LogError("Statistics Load Error", ex);
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

        // Example: Place in Home.aspx.cs or a new StudentProfileService.aspx.cs
        [System.Web.Services.WebMethod]
        public static string LoadStudent()
        {
            int userId = 0;
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT FullName, ProfilePicture FROM Users WHERE UserID = @UserID";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new
                            {
                                username = dr["FullName"]?.ToString().Substring(0, dr["FullName"].ToString().IndexOf(" ")) ?? "Unknown",
                                FullName = dr["FullName"]?.ToString() ?? "Unknown",
                                ProfilePicture = dr["ProfilePicture"]?.ToString() ?? "~/Assets/Images/default-profile.png"
                            });
                        }
                    }
                }
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new
            {
                FullName = "Unknown",
                ProfilePicture = "~/Assets/Images/default-profile.png"
            });
        }

    }
}
