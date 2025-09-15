using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace Learning_Management_System.authUser.Teacher
{
    public partial class QuizSubmission : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        { }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetTeacherCourses()
        {
            var courses = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseID, CourseName FROM Courses WHERE UserID = @TeacherId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new
                            {
                                id = reader["CourseID"],
                                name = reader["CourseName"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(courses);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetQuizzesByCourse(int courseId)
        {
            var quizzes = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT QuizID, Title FROM Quizzes WHERE CourseID = @CourseId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            quizzes.Add(new
                            {
                                id = reader["QuizID"],
                                name = reader["Title"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(quizzes);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetQuizSubmissions(int? courseId, int? quizId)
        {
            try
            {
                var submissions = new List<object>();
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                string teacherId = HttpContext.Current.Session["UserID"]?.ToString();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"
            SELECT 
                s.SubmissionId AS SubmissionID,
                s.UserId AS StudentID,
                u.FullName,
                u.Email,
                s.QuizId AS QuizID,
                q.Title AS QuizTitle,
                q.CourseId,
                c.CourseCode AS CourseName,
                ISNULL(qq.TotalPoints, 0) AS MaxScore,
                q.Duration,
                s.Score,
                s.Status,
                s.SubmittedAt,
                s.Duration AS SubmissionDuration,
                s.Attempt,
                q.MaxAttempts
            FROM QuizSubmissions s
            JOIN Users u ON s.UserId = u.UserID
            JOIN Quizzes q ON s.QuizId = q.QuizId
            JOIN Courses c ON q.CourseId = c.CourseID
            OUTER APPLY (
                SELECT SUM(Points) AS TotalPoints
                FROM QuizQuestions
                WHERE QuizId = q.QuizId
            ) qq
            WHERE c.UserID = @TeacherId "
                        + (courseId.HasValue ? " AND c.CourseID = @CourseId" : "")
                        + (quizId.HasValue ? " AND q.QuizID = @QuizId" : "")
                        + " ORDER BY s.SubmittedAt DESC";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                        if (courseId.HasValue)
                            cmd.Parameters.AddWithValue("@CourseId", courseId.Value);
                        if (quizId.HasValue)
                            cmd.Parameters.AddWithValue("@QuizId", quizId.Value);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                submissions.Add(new
                                {
                                    id = reader["SubmissionID"],
                                    student = new
                                    {
                                        id = reader["StudentID"],
                                        name = reader["FullName"].ToString()
                                    },
                                    quiz = new
                                    {
                                        id = reader["QuizID"],
                                        title = reader["QuizTitle"].ToString(),
                                        course = reader["CourseName"].ToString(),
                                        courseId = reader["CourseId"], // <-- ADD THIS LINE
                                        maxScore = reader["MaxScore"]
                                    },
                                    score = reader["Score"],
                                    percentage = (reader["Score"] != DBNull.Value && reader["MaxScore"] != DBNull.Value && Convert.ToDouble(reader["MaxScore"]) > 0)
                                                ? Math.Round(Convert.ToDouble(reader["Score"]) / Convert.ToDouble(reader["MaxScore"]) * 100, 2)
                                                : 0,
                                    status = reader["Status"].ToString(),
                                    submittedAt = reader["SubmittedAt"] != DBNull.Value ? ((DateTime)reader["SubmittedAt"]).ToString("s") : null,
                                    duration = reader["SubmissionDuration"]?.ToString()
                                });
                            }
                        }
                    }
                }
                return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(submissions);
            }
            catch (Exception ex)
            {
                // Return error to frontend for debugging
                return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                    new { error = true, message = ex.Message }
                );
            }
        }

[System.Web.Services.WebMethod(EnableSession = true)]
public static string SaveManualGrade(int submissionId, int score, double percentage, string comments, bool notify)
{
    try
    {
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            string sql = @"
                UPDATE QuizSubmissions
                SET 
                    Score = @Score,
                    Status = 'completed',
                    Comments = @Comments,
                    GradedAt = @GradedAt,
                    GradedBy = @GradedBy
                WHERE SubmissionId = @SubmissionId";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Score", score);
                cmd.Parameters.AddWithValue("@Comments", comments ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@GradedAt", DateTime.Now);
                cmd.Parameters.AddWithValue("@GradedBy", "Manual");
                cmd.Parameters.AddWithValue("@SubmissionId", submissionId);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                // Optionally, send notification to student if notify == true
                // (implement your notification logic here)
                return new JavaScriptSerializer().Serialize(new { success = rows > 0 });
            }
        }
    }
    catch (Exception ex)
    {
        return new JavaScriptSerializer().Serialize(new { error = true, message = ex.Message });
    }
}





    }
}