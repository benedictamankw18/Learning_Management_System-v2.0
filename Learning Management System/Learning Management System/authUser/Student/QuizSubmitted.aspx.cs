using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

namespace Learning_Management_System.authUser.Student
{
    public partial class QuizSubmitted : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static string GetSubmissionResult(string quizId)
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
                SqlCommand cmd = new SqlCommand(@"SELECT TOP 1 Score, Attempt FROM QuizSubmissions WHERE QuizId = @QuizId AND UserId = @UserId ORDER BY SubmittedAt DESC", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        result["Score"] = dr["Score"] == DBNull.Value ? null : dr["Score"].ToString();
                        result["Attempt"] = dr["Attempt"] == DBNull.Value ? 1 : Convert.ToInt32(dr["Attempt"]);
                    }
                }
                // Get max attempts
                cmd = new SqlCommand("SELECT MaxAttempts FROM Quizzes WHERE QuizId = @QuizId", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                int maxAttempts = (int)cmd.ExecuteScalar();
                // Get attempts done
                cmd = new SqlCommand("SELECT COUNT(*) FROM QuizSubmissions WHERE QuizId = @QuizId AND UserId = @UserId", conn);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@UserId", userId);
                int attemptsDone = (int)cmd.ExecuteScalar();
                result["AttemptsLeft"] = maxAttempts - attemptsDone;
            }
            return new JavaScriptSerializer().Serialize(result);
        }
    }
}
