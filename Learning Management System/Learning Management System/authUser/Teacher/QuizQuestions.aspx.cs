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
    public partial class QuizQuestions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod]
        public static string GetQuizQuestions(int quizId)
        {
            if (HttpContext.Current.Session["UserID"] == null)
                return new JavaScriptSerializer().Serialize(new { success = false, message = "User not logged in." });

            int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            var questions = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT qq.QuestionID, qq.QuestionText, qq.QuestionType, qq.Points, qq.Difficulty, 
                qq.Explanation, qq.Options, qq.CorrectAnswer, q.Type
                FROM QuizQuestions qq
                join Quizzes q on q.QuizId = qq.QuizId
                join Courses c on c.CourseID = q.CourseId
                WHERE qq.QuizID = @QuizID and c.UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // Parse options JSON as Dictionary<string, string>
                            Dictionary<string, string> options = null;
                            var optionsStr = reader["Options"]?.ToString();
                            if (!string.IsNullOrEmpty(optionsStr))
                            {
                                try { options = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(optionsStr); }
                                catch { options = null; }
                            }
                            questions.Add(new
                            {
                                id = reader["QuestionID"],
                                text = reader["QuestionText"].ToString(),
                                type = reader["QuestionType"].ToString(),
                                points = Convert.ToInt32(reader["Points"]),
                                difficulty = reader["Difficulty"].ToString(),
                                explanation = reader["Explanation"].ToString(),
                                options = options,
                                quizType = reader["Type"].ToString(),
                                answer = reader["CorrectAnswer"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(questions);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object AddQuizQuestion(int quizId, string text, string type, int points, string difficulty, string explanation, string options, string answer)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"INSERT INTO QuizQuestions
                           (QuizId, QuestionText, QuestionType, Points, Difficulty, Explanation, Options, CorrectAnswer)
                           VALUES (@QuizId, @Text, @Type, @Points, @Difficulty, @Explanation, @Options, @Answer)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.Parameters.AddWithValue("@Text", text);
                        cmd.Parameters.AddWithValue("@Type", type);
                        cmd.Parameters.AddWithValue("@Points", points);
                        cmd.Parameters.AddWithValue("@Difficulty", difficulty);
                        cmd.Parameters.AddWithValue("@Explanation", explanation ?? "");
                        cmd.Parameters.AddWithValue("@Options", options ?? "");
                        cmd.Parameters.AddWithValue("@Answer", answer);
                        conn.Open();
                        int rows = cmd.ExecuteNonQuery();
                        return new { success = rows > 0 };
                    }
                }
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(@"C:\temp\quiz_error.txt", ex.ToString());
                return new { success = false, message = ex.Message };
            }
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object EditQuizQuestion(int questionId, string text, string type, int points, string difficulty, string explanation, string options, string answer)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"UPDATE QuizQuestions
                       SET QuestionText=@Text, QuestionType=@Type, Points=@Points, Difficulty=@Difficulty, Explanation=@Explanation, Options=@Options, CorrectAnswer=@Answer
                       WHERE QuestionID=@QuestionId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Text", text);
                        cmd.Parameters.AddWithValue("@Type", type);
                        cmd.Parameters.AddWithValue("@Points", points);
                        cmd.Parameters.AddWithValue("@Difficulty", difficulty);
                        cmd.Parameters.AddWithValue("@Explanation", explanation ?? "");
                        cmd.Parameters.AddWithValue("@Options", !string.IsNullOrEmpty(options) ? options : (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Answer", answer);
                        cmd.Parameters.AddWithValue("@QuestionId", questionId);
                        conn.Open();
                        int rows = cmd.ExecuteNonQuery();
                        return new { success = rows > 0 };
                    }
                }
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(@"C:\temp\quiz_error.txt", ex.ToString());
                return new { success = false, message = ex.Message };
            }
        }


        [System.Web.Services.WebMethod(EnableSession = true)]
        public static object DeleteQuizQuestion(int questionId)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "DELETE FROM QuizQuestions WHERE QuestionID=@QuestionId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuestionId", questionId);
                        conn.Open();
                        int rows = cmd.ExecuteNonQuery();
                        return new { success = rows > 0 };
                    }
                }
            }
            catch (Exception ex)
            {
                System.IO.File.AppendAllText(@"C:\temp\quiz_error.txt", ex.ToString());
                return new { success = false, message = ex.Message };
            }

        } 
   }
}