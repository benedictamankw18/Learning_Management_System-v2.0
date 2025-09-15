using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{
    public partial class Assignments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static string GetAllAssignments()
        {
            var result = new List<Dictionary<string, object>>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            string userId = null;
            if (HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session["UserID"] != null)
                userId = HttpContext.Current.Session["UserID"].ToString();
            if (string.IsNullOrEmpty(userId))
                return new JavaScriptSerializer().Serialize(result);

            // 1. Get all CourseIDs for this user
            var courseIds = new List<string>();
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT CourseID FROM UserCourses WHERE UserID = @UserID", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                        courseIds.Add(dr["CourseID"].ToString());
                }
            }
            if (courseIds.Count == 0)
                return new JavaScriptSerializer().Serialize(result);

            // 2. Get all assignments for those courses, join with Courses for course name
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand($@"
                    SELECT a.AssignmentID, a.Title, a.CourseID, a.DueDate, a.Status, a.Description, a.FilePath, a.CreatedDate, a.ModifiedDate, c.CourseName
                    FROM Assignments a
                    INNER JOIN Courses c ON a.CourseID = c.CourseID
                    WHERE a.CourseID IN ({string.Join(",", courseIds.ConvertAll(id => "'" + id + "'"))})
                    ORDER BY a.DueDate DESC
                ", conn);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        var a = new Dictionary<string, object>();
                        string assignmentId = dr["AssignmentID"].ToString();
                        a["AssignmentID"] = assignmentId;
                        a["Title"] = dr["Title"].ToString();
                        a["CourseID"] = dr["CourseID"].ToString();
                        a["CourseName"] = dr["CourseName"].ToString();
                        a["DueDate"] = dr["DueDate"] == DBNull.Value ? null : ((DateTime)dr["DueDate"]).ToString("yyyy-MM-dd");
                        a["Status"] = dr["Status"].ToString();
                        a["Description"] = dr["Description"].ToString();
                        a["FilePath"] = dr["FilePath"] == DBNull.Value ? null : dr["FilePath"].ToString();
                        a["CreatedDate"] = dr["CreatedDate"] == DBNull.Value ? null : ((DateTime)dr["CreatedDate"]).ToString("yyyy-MM-dd");
                        a["ModifiedDate"] = dr["ModifiedDate"] == DBNull.Value ? null : ((DateTime)dr["ModifiedDate"]).ToString("yyyy-MM-dd");
                        // Check if user has submitted this assignment
                        bool hasSubmitted = false;
                        using (var subConn = new SqlConnection(connStr))
                        {
                            subConn.Open();
                            var subCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", subConn);
                            subCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                            subCmd.Parameters.AddWithValue("@StudentID", userId);
                            int count = (int)subCmd.ExecuteScalar();
                            hasSubmitted = count > 0;
                        }
                        a["HasSubmitted"] = hasSubmitted;
                        result.Add(a);
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(result);
        }
    }
}