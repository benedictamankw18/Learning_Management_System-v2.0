using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{
    public partial class Course : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCourses();
            }
        }

        private void LoadCourses()
        {
            var studentId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(studentId)) return;
            var courses = new List<CourseViewModel>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT c.CourseID, c.CourseName, c.CourseCode, c.Description,
                                (SELECT COUNT(*) FROM CourseSections s WHERE s.CourseID = c.CourseID) AS SectionCount,
                                (SELECT COUNT(*) FROM CourseMaterials m WHERE m.CourseID = c.CourseID) AS MaterialCount
                                FROM Courses c
                                INNER JOIN UserCourses uc ON c.CourseID = uc.CourseID
                                WHERE uc.UserID = @StudentID";
                using (var cmd = new System.Data.SqlClient.SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new CourseViewModel
                            {
                                CourseID = reader["CourseID"].ToString(),
                                CourseName = reader["CourseName"].ToString(),
                                CourseCode = reader["CourseCode"].ToString(),
                                Description = reader["Description"].ToString(),
                                SectionCount = reader["SectionCount"] == System.DBNull.Value ? 0 : (int)reader["SectionCount"],
                                MaterialCount = reader["MaterialCount"] == System.DBNull.Value ? 0 : (int)reader["MaterialCount"]
                            });
                        }
                    }
                }
            }
            rptCourses.DataSource = courses;
            rptCourses.DataBind();
        }

        public class CourseViewModel
        {
            public string CourseID { get; set; }
            public string CourseName { get; set; }
            public string CourseCode { get; set; }
            public string Description { get; set; }
            public int SectionCount { get; set; }
            public int MaterialCount { get; set; }
        }
    }
}