using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{
    public partial class Quiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string courseId = Request.QueryString["courseId"];
                if (!string.IsNullOrEmpty(courseId))
                {
                    BindQuizzes(courseId);
                }
            }
        }

        private void BindQuizzes(string courseId)
        {
            var quizzes = new List<QuizViewModel>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT QuizId, Title, Description, Duration, MaxAttempts, Status, Type, IsActivated, StartDate, EndDate, CreatedDate
                                FROM Quizzes
                                WHERE CourseId = @CourseID and IsActivated = 1 and Status = 'active'
                                ORDER BY CreatedDate DESC";
                using (var cmd = new System.Data.SqlClient.SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            quizzes.Add(new QuizViewModel
                            {
                                QuizID = reader["QuizId"].ToString(),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                Duration = reader["Duration"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["Duration"]),
                                MaxAttempts = reader["MaxAttempts"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["MaxAttempts"]),
                                Status = reader["Status"].ToString(),
                                Type = reader["Type"].ToString(),
                                IsActivated = reader["IsActivated"] == DBNull.Value ? false : Convert.ToBoolean(reader["IsActivated"]),
                                StartDate = reader["StartDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["StartDate"]),
                                EndDate = reader["EndDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["EndDate"]),
                                CreatedDate = reader["CreatedDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["CreatedDate"])
                            });
                        }
                    }
                }
            }
            rptQuizzes.DataSource = quizzes;
            rptQuizzes.DataBind();
        }

       public class QuizViewModel
{
    public string QuizID { get; set; }
    public string Title { get; set; }
    public string Description { get; set; }
    public int? Duration { get; set; }
    public int? MaxAttempts { get; set; }
    public string Status { get; set; }
    public string Type { get; set; }
    public bool IsActivated { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public DateTime? CreatedDate { get; set; }
}
    }
}