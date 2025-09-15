using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

namespace Learning_Management_System.authUser.Student
{
    public partial class QuizAnswer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static string GetSubmissionDetail(string quizId)
        {
            var result = new Dictionary<string, object>();
            string userId = System.Web.HttpContext.Current.Session["UserId"]?.ToString();
            if (string.IsNullOrEmpty(userId))
                return new JavaScriptSerializer().Serialize(result);
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Get latest submission for this user and quiz
                SqlCommand cmd = new SqlCommand(@"SELECT TOP 1 SubmissionId, Score, Attempt FROM QuizSubmissions WHERE QuizId = @QuizId AND UserId = @UserId ORDER BY SubmittedAt DESC", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                int submissionId = 0;
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        result["Score"] = dr["Score"] == DBNull.Value ? null : dr["Score"].ToString();
                        result["Attempt"] = dr["Attempt"] == DBNull.Value ? 1 : Convert.ToInt32(dr["Attempt"]);
                        submissionId = dr["SubmissionId"] == DBNull.Value ? 0 : Convert.ToInt32(dr["SubmissionId"]);
                    }
                }
                // Get all questions, answers, and explanations for this submission
                var questions = new List<Dictionary<string, object>>();
                cmd = new SqlCommand(@"SELECT q.QuestionText, q.CorrectAnswer, q.Explanation, q.Points, a.Answer AS UserAnswer FROM QuizQuestions q LEFT JOIN QuizSubmissionAnswers a ON q.QuestionId = a.QuestionId AND a.SubmissionId = @SubmissionId WHERE q.QuizId = @QuizId ORDER BY q.QuestionId", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@SubmissionId", submissionId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        var q = new Dictionary<string, object>();
                        q["QuestionText"] = dr["QuestionText"].ToString();
                        q["CorrectAnswer"] = dr["CorrectAnswer"] == DBNull.Value ? null : dr["CorrectAnswer"].ToString();
                        q["UserAnswer"] = dr["UserAnswer"] == DBNull.Value ? null : dr["UserAnswer"].ToString();
                        q["Explanation"] = dr["Explanation"] == DBNull.Value ? null : dr["Explanation"].ToString();
                        q["Points"] = dr["Points"] == DBNull.Value ? null : dr["Points"].ToString();
                        questions.Add(q);
                    }
                }
                result["Questions"] = questions;
            }
            return new JavaScriptSerializer().Serialize(result);
        }
    }
}