using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{
    public partial class Assignment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

   [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetCourseName(string courseId)
        {
            string courseName = "Course";
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new System.Data.SqlClient.SqlCommand("SELECT CourseName FROM Courses WHERE CourseID = @CourseID", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                var result = cmd.ExecuteScalar();
                if (result != null && result != System.DBNull.Value)
                {
                    courseName = result.ToString();
                }
            }
            return courseName;
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetAssignments(string courseId)
        {
            var result = new List<Dictionary<string, object>>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            // Get current user ID from session
            string userId = null;
            if (HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session["UserID"] != null)
                userId = HttpContext.Current.Session["UserID"].ToString();
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new System.Data.SqlClient.SqlCommand(@"SELECT AssignmentID, Title, CourseID, DueDate, Status, Description, FilePath, CreatedDate, ModifiedDate FROM Assignments WHERE CourseID = @CourseID ORDER BY DueDate DESC", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        var a = new Dictionary<string, object>();
                        string assignmentId = dr["AssignmentID"].ToString();
                        a["AssignmentID"] = assignmentId;
                        a["Title"] = dr["Title"].ToString();
                        a["CourseID"] = dr["CourseID"].ToString();
                        a["DueDate"] = dr["DueDate"] == System.DBNull.Value ? null : ((DateTime)dr["DueDate"]).ToString("yyyy-MM-dd");
                        a["Status"] = dr["Status"].ToString();
                        a["Description"] = dr["Description"].ToString();
                        if (dr["FilePath"] == System.DBNull.Value)
                        {
                            a["FilePath"] = null;
                        }
                        else
                        {
                            string filePath = dr["FilePath"].ToString();
                            if (filePath.StartsWith("~/"))
                                filePath = filePath.Substring(1);
                            a["FilePath"] = filePath;
                        }
                        a["CreatedDate"] = dr["CreatedDate"] == System.DBNull.Value ? null : ((DateTime)dr["CreatedDate"]).ToString("yyyy-MM-dd");
                        a["ModifiedDate"] = dr["ModifiedDate"] == System.DBNull.Value ? null : ((DateTime)dr["ModifiedDate"]).ToString("yyyy-MM-dd");
                        // Check if user has submitted this assignment
                        bool hasSubmitted = false;
                        if (!string.IsNullOrEmpty(userId))
                        {
                            using (var subConn = new System.Data.SqlClient.SqlConnection(connStr))
                            {
                                subConn.Open();
                                var subCmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", subConn);
                                subCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                                subCmd.Parameters.AddWithValue("@StudentID", userId);
                                int count = (int)subCmd.ExecuteScalar();
                                hasSubmitted = count > 0;
                            }
                        }
                        a["HasSubmitted"] = hasSubmitted;
                        result.Add(a);
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
        }
    }
}