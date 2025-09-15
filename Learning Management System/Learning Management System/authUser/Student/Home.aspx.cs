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

namespace Learning_Management_System.authUser.Teacher
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadStudentName();
        }

        [WebMethod]
        public static string GetRecentActivity()
        {
            int userId = 0; // Replace with session logic
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }
            var activities = new List<Activity>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Recent Course Materials
                string sqlMaterials = @"
                SELECT TOP 3 cm.Title, c.CourseName, cm.UploadedDate
                FROM CourseMaterials cm
                JOIN Courses c ON cm.CourseId = c.CourseID
                JOIN UserCourses uc ON uc.CourseID = c.CourseID
                WHERE uc.UserID = @UserID
                ORDER BY cm.UploadedDate DESC";
                using (var cmd = new SqlCommand(sqlMaterials, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            activities.Add(new Activity
                            {
                                type = "material",
                                title = "New material uploaded: " + reader["Title"] + " (" + reader["CourseName"] + ")",
                                date = ((DateTime)reader["UploadedDate"]).ToString("MMM dd, yyyy hh:mm tt"),
                                icon = "fa-book",
                                color = "bg-primary"
                            });
                        }
                    }
                }

                // Recent Assignments
                string sqlAssignments = @"
                SELECT TOP 3 a.Title, c.CourseName, a.DueDate
                FROM Assignments a
                JOIN Courses c ON a.CourseID = c.CourseID
                JOIN UserCourses uc ON uc.CourseID = c.CourseID
                WHERE uc.UserID = @UserID
                ORDER BY a.DueDate DESC";
                using (var cmd = new SqlCommand(sqlAssignments, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            activities.Add(new Activity
                            {
                                type = "assignment",
                                title = "Assignment due: " + reader["Title"] + " (" + reader["CourseName"] + ")",
                                date = ((DateTime)reader["DueDate"]).ToString("MMM dd, yyyy"),
                                icon = "fa-tasks",
                                color = "bg-warning"
                            });
                        }
                    }
                }

                // Recent Schedules
                string sqlSchedules = @"
                SELECT TOP 2 s.Title, c.CourseName, s.EventDate, s.StartTime
                FROM Schedules s
                JOIN Courses c ON s.CourseID = c.CourseID
                JOIN UserCourses uc ON uc.CourseID = c.CourseID
                WHERE uc.UserID = @UserID
                ORDER BY s.EventDate DESC, s.StartTime DESC";
                using (var cmd = new SqlCommand(sqlSchedules, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            activities.Add(new Activity
                            {
                                type = "schedule",
                                title = "Upcoming class: " + reader["Title"] + " (" + reader["CourseName"] + ")",
                                date = ((DateTime)reader["EventDate"]).ToString("MMM dd, yyyy") + " " + reader["StartTime"],
                                icon = "fa-calendar-alt",
                                color = "bg-info"
                            });
                        }
                    }
                }

                // Recent Quizzes
                string sqlQuizzes = @"
                SELECT TOP 2 q.Title, c.CourseName, q.StartDate
                FROM Quizzes q
                JOIN Courses c ON q.CourseId = c.CourseID
                JOIN UserCourses uc ON uc.CourseID = c.CourseID
                WHERE uc.UserID = @UserID AND q.Status = 'active' AND q.IsActivated = 1
                ORDER BY q.StartDate DESC";
                using (var cmd = new SqlCommand(sqlQuizzes, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            activities.Add(new Activity
                            {
                                type = "quiz",
                                title = "Upcoming quiz: " + reader["Title"] + " (" + reader["CourseName"] + ")",
                                date = ((DateTime)reader["StartDate"]).ToString("MMM dd, yyyy"),
                                icon = "fa-question-circle",
                                color = "bg-success"
                            });
                        }
                    }
                }
            }
            // Sort by date ascending
            //activities = activities.OrderBy(a => a.date).ToList();
            activities = activities.OrderByDescending(a => a.date).ToList();
            return new JavaScriptSerializer().Serialize(activities);
        }

        public class Activity
        {
            public string type { get; set; }
            public string title { get; set; }
            public string date { get; set; }
            public string icon { get; set; }
            public string color { get; set; }
        }

        private void LoadStudentName()
        {
            int userId = 0;
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT FullName FROM Users WHERE UserID = @UserID";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    var result = cmd.ExecuteScalar();
                    lblStudentName.Text = result != null ? result.ToString() : "Unknown";
                }
            }
        }

//         // Example: Home.aspx.cs or StudentProfileService.aspx.cs
// [System.Web.Services.WebMethod]
// public static string LoadStudent()
// {
//     int userId = 0;
//     if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
//     {
//         int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
//     }

//     string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
//     using (var conn = new SqlConnection(connStr))
//     {
//         conn.Open();
//         string sql = "SELECT FullName, ProfilePicture FROM Users WHERE UserID = @UserID";
//         using (var cmd = new SqlCommand(sql, conn))
//         {
//             cmd.Parameters.AddWithValue("@UserID", userId);

//             using (SqlDataReader dr = cmd.ExecuteReader())
//             {
//                 if (dr.Read())
//                 {
//                     return Newtonsoft.Json.JsonConvert.SerializeObject(new
//                     {
//                         FullName = dr["FullName"]?.ToString() ?? "Unknown",
//                         ProfilePicture = dr["ProfilePicture"]?.ToString() ?? "~/Assets/Images/default-profile.png"
//                     });
//                 }
//             }
//         }
//     }
//     return Newtonsoft.Json.JsonConvert.SerializeObject(new
//     {
//         FullName = "Unknown",
//         ProfilePicture = "~/Assets/Images/default-profile.png"
//     });
// }
    }
}