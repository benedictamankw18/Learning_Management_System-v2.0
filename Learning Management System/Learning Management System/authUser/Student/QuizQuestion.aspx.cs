using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

namespace Learning_Management_System.authUser.Student
{
    public partial class QuizQuestion : System.Web.UI.Page
    {
        protected string QuizId;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                QuizId = Request.QueryString["quizId"];
                // Set quiz start time if not already set
                if (Session["QuizStartTime"] == null)
                {
                    Session["QuizStartTime"] = DateTime.Now;
                }
                // Optionally: Load quiz info and user attempts for client-side rendering
            }
        }

        [WebMethod(EnableSession = true)]
        public static string GetQuizInfo(string quizId)
        {
            var result = new Dictionary<string, object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Get quiz info
                SqlCommand cmd = new SqlCommand("SELECT Title, Description, Duration, MaxAttempts, Type, StartDate, EndDate, IsActivated FROM Quizzes WHERE QuizId = @QuizId", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        result["Title"] = dr["Title"].ToString();
                        result["Description"] = dr["Description"].ToString();
                        result["Duration"] = dr["Duration"].ToString();
                        result["MaxAttempts"] = dr["MaxAttempts"].ToString();
                        result["Type"] = dr["Type"].ToString();
                        result["StartDate"] = Convert.ToDateTime(dr["StartDate"]).ToString("yyyy-MM-dd");
                        result["EndDate"] = Convert.ToDateTime(dr["EndDate"]).ToString("yyyy-MM-dd");
                        result["IsActivated"] = dr["IsActivated"].ToString();
                    }
                }
                // Get number of questions
                cmd = new SqlCommand("SELECT COUNT(*) FROM QuizQuestions WHERE QuizId = @QuizId", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                result["NumQuestions"] = (int)cmd.ExecuteScalar();
                // Get user attempts
                string userId = System.Web.HttpContext.Current.Session["UserId"]?.ToString();
                cmd = new SqlCommand("SELECT COUNT(*) FROM QuizSubmissions WHERE QuizId = @QuizId AND UserId = @UserId", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                result["AttemptsDone"] = (int)cmd.ExecuteScalar();
            }
            return new JavaScriptSerializer().Serialize(result);
        }

        [WebMethod(EnableSession = true)]
        public static string GetQuizQuestion(string quizId, int questionIndex)
        {
            // Returns the question at the given index (0-based) with its options
            var result = new Dictionary<string, object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Get the question at the given index
                SqlCommand cmd = new SqlCommand(@"SELECT * FROM (
                        SELECT ROW_NUMBER() OVER (ORDER BY QuestionId) AS RowNum, * FROM QuizQuestions WHERE QuizId = @QuizId
                    ) AS Q WHERE Q.RowNum = @RowNum", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@RowNum", questionIndex + 1);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        result["QuestionId"] = dr["QuestionId"].ToString();
                        result["QuestionText"] = dr["QuestionText"].ToString();
                        result["QuestionType"] = dr["QuestionType"].ToString();
                        result["Points"] = dr["Points"].ToString();
                        result["Difficulty"] = dr["Difficulty"].ToString();
                        result["Explanation"] = dr["Explanation"].ToString();
                        result["Options"] = new List<Dictionary<string, object>>();
                        // Parse options from JSON in Options column for MCQ/TrueFalse
                        string optionsJson = dr["Options"] == DBNull.Value ? null : dr["Options"].ToString();
                        if ((result["QuestionType"].ToString() == "multiple-choice" || result["QuestionType"].ToString() == "true-false") && !string.IsNullOrWhiteSpace(optionsJson))
                        {
                            var optionsList = (List<Dictionary<string, object>>)result["Options"];
                            var serializer = new JavaScriptSerializer();
                            var dict = serializer.Deserialize<Dictionary<string, string>>(optionsJson);
                            string[] labels = new string[] { "A", "B", "C", "D" };
                            foreach (var label in labels)
                            {
                                dict.TryGetValue(label, out string optText);
                                optionsList.Add(new Dictionary<string, object> {
                                    { "OptionId", label },
                                    { "OptionLabel", label },
                                    { "OptionText", optText ?? "" }
                                });
                            }
                        }
                    }
                    else
                    {
                        return new JavaScriptSerializer().Serialize(null); // No more questions
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(result);
        }
        [WebMethod(EnableSession = true)]
        public static string SubmitQuiz(string quizId, Dictionary<string, object> answers)
        {
            var result = new Dictionary<string, object>();
            try
            {
                string userId = System.Web.HttpContext.Current.Session["UserId"]?.ToString();
                if (string.IsNullOrEmpty(userId))
                {
                    result["success"] = false;
                    result["message"] = "User not logged in.";
                    return new JavaScriptSerializer().Serialize(result);
                }

                string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Calculate duration (in seconds) from session start to now
                    DateTime submittedAt = DateTime.Now;
                    DateTime? quizStart = System.Web.HttpContext.Current.Session["QuizStartTime"] as DateTime?;
                    int durationMinutes = 0;
                    if (quizStart.HasValue)
                    {
                        durationMinutes = (int)Math.Ceiling((submittedAt - quizStart.Value).TotalMinutes);
                    }
                    // Insert submission record (QuizSubmissions)
                    SqlCommand cmd = new SqlCommand(@"INSERT INTO QuizSubmissions (QuizId, UserId, SubmittedAt, Status, Attempt, Duration) 
                        OUTPUT INSERTED.SubmissionId 
                        VALUES (@QuizId, @UserId, @SubmittedAt, @Status, @Attempt, @Duration)", conn);
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@SubmittedAt", submittedAt);
                    cmd.Parameters.AddWithValue("@Status", "completed");
                    // Calculate Attempt number
                    SqlCommand attemptCmd = new SqlCommand("SELECT COUNT(*) FROM QuizSubmissions WHERE QuizId = @QuizId AND UserId = @UserId", conn);
                    attemptCmd.Parameters.AddWithValue("@QuizId", quizId);
                    attemptCmd.Parameters.AddWithValue("@UserId", userId);
                    int attempt = (int)attemptCmd.ExecuteScalar() + 1;
                    cmd.Parameters.AddWithValue("@Attempt", attempt);
                    cmd.Parameters.AddWithValue("@Duration", durationMinutes);
                    int submissionId = (int)cmd.ExecuteScalar();

                    int score = 0;
                    // Insert answers and auto-mark
                    foreach (var entry in answers)
                    {
                        string questionId = entry.Key;
                        string answer = entry.Value == null ? "" : entry.Value.ToString();
                        // Get correct answer from QuizQuestions
                        SqlCommand correctCmd = new SqlCommand("SELECT CorrectAnswer FROM QuizQuestions WHERE QuestionId = @QuestionId", conn);
                        correctCmd.Parameters.AddWithValue("@QuestionId", questionId);
                        object correctObj = correctCmd.ExecuteScalar();
                        string correctAnswer = correctObj == null ? "" : correctObj.ToString();
                        // Compare (case-insensitive, trimmed)
                        if (!string.IsNullOrEmpty(correctAnswer) && answer.Trim().Equals(correctAnswer.Trim(), StringComparison.OrdinalIgnoreCase))
                        {
                            score++;
                        }
                        SqlCommand ansCmd = new SqlCommand(@"INSERT INTO QuizSubmissionAnswers (SubmissionId, QuestionId, Answer) VALUES (@SubmissionId, @QuestionId, @Answer)", conn);
                        ansCmd.Parameters.AddWithValue("@SubmissionId", submissionId);
                        ansCmd.Parameters.AddWithValue("@QuestionId", questionId);
                        ansCmd.Parameters.AddWithValue("@Answer", answer);
                        ansCmd.ExecuteNonQuery();
                    }
                    // Update score in QuizSubmissions
                    SqlCommand updateScoreCmd = new SqlCommand("UPDATE QuizSubmissions SET Score = @Score WHERE SubmissionId = @SubmissionId", conn);
                    updateScoreCmd.Parameters.AddWithValue("@Score", score);
                    updateScoreCmd.Parameters.AddWithValue("@SubmissionId", submissionId);
                    updateScoreCmd.ExecuteNonQuery();
                }
                result["success"] = true;
                result["message"] = "Quiz submitted and marked successfully.";
            }
            catch (Exception ex)
            {
                result["success"] = false;
                result["message"] = "Error: " + ex.Message;
            }
            return new JavaScriptSerializer().Serialize(result);
        }
    }
}
        