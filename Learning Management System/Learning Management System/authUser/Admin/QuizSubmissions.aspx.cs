using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data.SqlClient;
using System.Configuration;


namespace Learning_Management_System.authUser.Admin
{
    public partial class QuizSubmissions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object SaveManualGrade(int submissionId, double score, string comments, bool notify)
{
    try
    {
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            // Update the submission with the new score, status, and comments
            string updateQuery = @"
                UPDATE QuizSubmissions
                SET Score = @Score,
                    Status = 'completed',
                    Comments = @Comments,
                    GradedAt = @GradedAt,
                    GradedBy = @GradedBy
                WHERE SubmissionId = @SubmissionId";
            using (var cmd = new SqlCommand(updateQuery, conn))
            {
                cmd.Parameters.AddWithValue("@Score", score);
                cmd.Parameters.AddWithValue("@Comments", (object)comments ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@GradedAt", DateTime.Now);
                cmd.Parameters.AddWithValue("@GradedBy", HttpContext.Current.User.Identity.Name ?? "Manual");
                cmd.Parameters.AddWithValue("@SubmissionId", submissionId);
                cmd.ExecuteNonQuery();
            }
        }

        // Optionally, send notification to student if 'notify' is true
        // (Implement your notification logic here if needed)

        return new { success = true };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetCourses()
{
    var courses = new List<object>();
    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    using (var conn = new SqlConnection(connStr))
    {
        conn.Open();
        string query = "SELECT CourseID, CourseCode, CourseName FROM Courses WHERE IsActive = 1 ORDER BY CourseName";
        using (var cmd = new SqlCommand(query, conn))
        {
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    courses.Add(new
                    {
                        id = reader["CourseID"].ToString(),
                        code = reader["CourseCode"].ToString(),
                        name = reader["CourseName"].ToString()
                    });
                }
            }
        }
    }
    return new { success = true, data = courses };
}

[System.Web.Services.WebMethod]
[System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
public static object GetQuizzes(string courseCode)
{
    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

    var quizzes = new List<object>();
    using (var conn = new SqlConnection(connStr))
    {
        conn.Open();
        string query = "SELECT QuizId, Title FROM Quizzes";
        if (!string.IsNullOrEmpty(courseCode))
        {
            query += " WHERE CourseId = (SELECT CourseID FROM Courses WHERE CourseCode = @CourseCode)";
        }
        using (var cmd = new SqlCommand(query, conn))
        {
            if (!string.IsNullOrEmpty(courseCode))
                cmd.Parameters.AddWithValue("@CourseCode", courseCode);

            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    quizzes.Add(new
                    {
                        id = reader["QuizId"],
                        title = reader["Title"].ToString()
                    });
                }
            }
        }
    }
    return new { success = true, data = quizzes };
}

        [WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetQuizSubmissions()
{
    try
    {
        var submissions = new List<object>();
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = @"
    SELECT s.SubmissionId, s.UserId, u.FullName, u.Email,
           s.QuizId, q.Title AS QuizTitle, q.CourseId, c.CourseCode,
           ISNULL(qq.TotalPoints, 0) AS MaxScore, q.Duration,
           s.Score, s.Status, s.SubmittedAt, s.Duration AS SubmissionDuration, s.Attempt, q.MaxAttempts
    FROM QuizSubmissions s
    JOIN Users u ON s.UserId = u.UserID
    JOIN Quizzes q ON s.QuizId = q.QuizId
    JOIN Courses c ON q.CourseId = c.CourseID
    OUTER APPLY (
        SELECT SUM(Points) AS TotalPoints
        FROM QuizQuestions
        WHERE QuizId = q.QuizId
    ) qq
    ORDER BY s.SubmittedAt DESC";
            using (var cmd = new SqlCommand(query, conn))
            {
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        submissions.Add(new
                        {
                            id = reader["SubmissionId"],
                            student = new {
                                name = reader["FullName"].ToString(),
                                id = reader["UserId"].ToString(),
                                email = reader["Email"].ToString()
                            },
                            quiz = new {
                                id = reader["QuizId"],
                                title = reader["QuizTitle"].ToString(),
                                course = reader["CourseCode"].ToString(),
                                maxScore = reader["MaxScore"] != DBNull.Value ? Convert.ToInt32(reader["MaxScore"]) : 0,
                                // If you want to show number of questions, you can query for it separately
                                questions = 0
                            },
                            score = reader["Score"] != DBNull.Value ? Convert.ToInt32(reader["Score"]) : 0,
                            percentage = reader["Score"] != DBNull.Value && reader["MaxScore"] != DBNull.Value && Convert.ToInt32(reader["MaxScore"]) > 0
                                ? (int)Math.Round(100.0 * Convert.ToInt32(reader["Score"]) / Convert.ToInt32(reader["MaxScore"]))
                                : 0,
                            status = reader["Status"].ToString(),
                            submittedAt = reader["SubmittedAt"] != DBNull.Value ? ((DateTime)reader["SubmittedAt"]).ToString("yyyy-MM-ddTHH:mm:ss") : null,
                            duration = reader["SubmissionDuration"].ToString(),
                            attempt = reader["Attempt"] != DBNull.Value ? Convert.ToInt32(reader["Attempt"]) : 1,
                            maxAttempts = reader["MaxAttempts"] != DBNull.Value ? Convert.ToInt32(reader["MaxAttempts"]) : 1
                        });
                    }
                }
            }
        }
        return new { success = true, data = submissions };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.ToString() };
    }
}
    }
}