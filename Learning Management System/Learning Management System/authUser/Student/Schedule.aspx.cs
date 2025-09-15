using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace Learning_Management_System.authUser.Student
{
    public partial class Schedule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [System.Web.Services.WebMethod]
        public static string GetStudentEvents()
        {
            // Replace with actual student ID from session/auth
            int studentId = 1; // fallback
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out studentId);
            }
            var events = new List<object>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                // Schedules (classes)
                string sql = @"
            SELECT s.[ScheduleID], s.[CourseID], s.[Title], s.[Description], s.[EventDate], s.[StartTime], s.[EndTime], s.[Location], c.CourseName
            FROM [LearningManagementSystem].[dbo].[Schedules] s
            INNER JOIN [LearningManagementSystem].[dbo].[UserCourses] sc ON s.CourseID = sc.CourseID
            INNER JOIN [LearningManagementSystem].[dbo].[Courses] c ON s.CourseID = c.CourseID
            WHERE sc.UserID = @StudentID
            ORDER BY s.EventDate, s.StartTime
        ";
                using (var cmd = new System.Data.SqlClient.SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string start = reader["StartTime"].ToString();
                            string end = reader["EndTime"].ToString();
                            string time = !string.IsNullOrEmpty(end) ? ($"{start} - {end}") : start;
                            events.Add(new
                            {
                                id = reader["ScheduleID"],
                                title = reader["Title"].ToString(),
                                type = "class",
                                date = ((DateTime)reader["EventDate"]).ToString("yyyy-MM-dd"),
                                time = time,
                                location = reader["Location"].ToString(),
                                icon = "fa-chalkboard-teacher",
                                course = reader["CourseName"].ToString(),
                                description = reader["Description"].ToString()
                            });
                        }
                    }
                }

                // Assignments (due dates)
                string sqlAssignments = @"
            SELECT a.[AssignmentID], a.[Title], a.[CourseID], a.[DueDate], a.[Status], a.[Description], c.CourseName
            FROM [LearningManagementSystem].[dbo].[Assignments] a
            INNER JOIN [LearningManagementSystem].[dbo].[UserCourses] sc ON a.CourseID = sc.CourseID
            INNER JOIN [LearningManagementSystem].[dbo].[Courses] c ON a.CourseID = c.CourseID
            WHERE sc.UserID = @StudentID
            ORDER BY a.DueDate
        ";
                using (var cmd = new System.Data.SqlClient.SqlCommand(sqlAssignments, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            events.Add(new
                            {
                                id = reader["AssignmentID"],
                                title = reader["Title"].ToString(),
                                type = "assignment",
                                date = ((DateTime)reader["DueDate"]).ToString("yyyy-MM-dd"),
                                time = "Due",
                                location = "",
                                icon = "fa-tasks",
                                course = reader["CourseName"].ToString(),
                                description = reader["Description"].ToString()
                            });
                        }
                    }
                }
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(events);
        }

    }
}