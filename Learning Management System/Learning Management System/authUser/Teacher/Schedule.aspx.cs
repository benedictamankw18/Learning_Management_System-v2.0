using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Configuration;

namespace Learning_Management_System.authUser.Teacher
{
    public partial class Schedule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
[WebMethod(EnableSession = true)]
public static string UpdateSchedule(int scheduleId, int courseId, string title, string description, string eventDate, string startTime, string endTime, string location)
{
    var connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
    using (var conn = new SqlConnection(connStr))
    {
        conn.Open();
        var cmd = new SqlCommand(@"
            UPDATE Schedules
            SET CourseID=@CourseID, Title=@Title, Description=@Description, EventDate=@EventDate, StartTime=@StartTime, EndTime=@EndTime, Location=@Location
            WHERE ScheduleID=@ScheduleID", conn);
        cmd.Parameters.AddWithValue("@ScheduleID", scheduleId);
        cmd.Parameters.AddWithValue("@CourseID", courseId);
        cmd.Parameters.AddWithValue("@Title", title);
        cmd.Parameters.AddWithValue("@Description", description ?? "");
        cmd.Parameters.AddWithValue("@EventDate", eventDate);
        cmd.Parameters.AddWithValue("@StartTime", startTime);
        cmd.Parameters.AddWithValue("@EndTime", endTime);
        cmd.Parameters.AddWithValue("@Location", location ?? "");
        cmd.ExecuteNonQuery();
    }
    return new JavaScriptSerializer().Serialize(new { success = true });
}

[WebMethod(EnableSession = true)]
public static string DeleteSchedule(int scheduleId)
{
    var connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
    using (var conn = new SqlConnection(connStr))
    {
        conn.Open();
        var cmd = new SqlCommand("DELETE FROM Schedules WHERE ScheduleID=@ScheduleID", conn);
        cmd.Parameters.AddWithValue("@ScheduleID", scheduleId);
        cmd.ExecuteNonQuery();
    }
    return new JavaScriptSerializer().Serialize(new { success = true });
}


        [WebMethod(EnableSession = true)]
        public static string GetTeacherSchedules()
        {
            var teacherId = System.Web.HttpContext.Current.Session["UserID"];
            var connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            var schedules = new List<object>();

            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand(@"
                    SELECT s.ScheduleID, s.Title, s.Description, s.EventDate, s.StartTime, s.EndTime, s.Location, c.CourseName
                    FROM Schedules s
                    INNER JOIN Courses c ON s.CourseID = c.CourseID
                    WHERE s.TeacherID = @TeacherID
                    ORDER BY s.EventDate, s.StartTime", conn);
                cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        schedules.Add(new
                        {
                            ScheduleID = dr["ScheduleID"],
                            Title = dr["Title"],
                            Description = dr["Description"],
                            EventDate = Convert.ToDateTime(dr["EventDate"]).ToString("yyyy-MM-dd"),
                            StartTime = dr["StartTime"].ToString(),
                            EndTime = dr["EndTime"].ToString(),
                            Location = dr["Location"].ToString(),
                            CourseName = dr["CourseName"].ToString()
                        });
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(schedules);
        }

        [WebMethod(EnableSession = true)]
        public static string CreateSchedule(int courseId, string title, string description, string eventDate, string startTime, string endTime, string location)
        {
            var teacherId = System.Web.HttpContext.Current.Session["UserID"];
            var connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand(@"
                    INSERT INTO Schedules (CourseID, TeacherID, Title, Description, EventDate, StartTime, EndTime, Location)
                    VALUES (@CourseID, @TeacherID, @Title, @Description, @EventDate, @StartTime, @EndTime, @Location)", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", description ?? "");
                cmd.Parameters.AddWithValue("@EventDate", eventDate);
                cmd.Parameters.AddWithValue("@StartTime", startTime);
                cmd.Parameters.AddWithValue("@EndTime", endTime);
                cmd.Parameters.AddWithValue("@Location", location ?? "");
                cmd.ExecuteNonQuery();
            }
            return new JavaScriptSerializer().Serialize(new { success = true });
        }
    }
}