using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Services;
using System.Configuration;

namespace Learning_Management_System
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

 [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetDashboardStats()
        {
            try
            {
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                int totalUsers = 0, totalStudents = 0, totalTeachers = 0, totalCourses = 0, totalQuizzes = 0;
                double avgPerformance = 0;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Total Users
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                        totalUsers = (int)cmd.ExecuteScalar();

                    // Active Students
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserType = 'Student' AND IsActive = 1", conn))
                        totalStudents = (int)cmd.ExecuteScalar();

                    // Teachers
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserType = 'Teacher'", conn))
                        totalTeachers = (int)cmd.ExecuteScalar();

                    // Active Courses
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Courses WHERE IsActive = 1", conn))
                        totalCourses = (int)cmd.ExecuteScalar();

                    // Total Quizzes
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Quizzes", conn))
                        totalQuizzes = (int)cmd.ExecuteScalar();

                    // Average Performance (e.g., average score from QuizSubmissions)
                    using (var cmd = new SqlCommand(@"WITH QuizMaxPoints AS (
                                            SELECT 
                                                qq.QuizId,
                                                SUM(qq.Points) AS MaxPoints
                                            FROM [LearningManagementSystem].[dbo].[QuizQuestions] qq
                                            GROUP BY qq.QuizId
                                        ),
                                        QuizPercentages AS (
                                            SELECT 
                                                s.SubmissionId,
                                                s.UserId,
                                                s.QuizId,
                                                (CAST(s.Score AS FLOAT) / qm.MaxPoints) * 100 AS PercentageScore
                                            FROM [LearningManagementSystem].[dbo].[QuizSubmissions] s
                                            INNER JOIN QuizMaxPoints qm
                                                ON s.QuizId = qm.QuizId
                                            WHERE s.Status = 'completed'
                                        )
                                        SELECT 
                                            AVG(PercentageScore) AS OverallAvgPercentage,
                                            COUNT(*) AS TotalAttempts
                                        FROM QuizPercentages;
                                        ", conn))
                    {
                        var result = cmd.ExecuteScalar();
                        avgPerformance = result != DBNull.Value ? Math.Round(Convert.ToDouble(result), 1) : 0;
                    }
                }

                return new
                {
                    success = true,
                    data = new
                    {
                        totalUsers,
                        totalStudents,
                        totalTeachers,
                        totalCourses,
                        totalQuizzes,
                        avgPerformance
                    }
                };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }


[WebMethod]
[System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
public static object GetDashboardChartData()
{
    try
    {
        var registrationLabels = new List<string>();
        var studentCounts = new List<int>();
        var teacherCounts = new List<int>();
        var courseLabels = new List<string>();
        var courseCounts = new List<int>();
        var performanceLabels = new List<string>();
        var performanceScores = new List<double>();

        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();

            // Registration Trends (last 8 months)
            using (var cmd = new SqlCommand(@"
                SELECT 
                    FORMAT([CreatedDate], 'MMM') AS MonthLabel,
                    SUM(CASE WHEN UserType = 'Student' THEN 1 ELSE 0 END) AS StudentCount,
                    SUM(CASE WHEN UserType = 'Teacher' THEN 1 ELSE 0 END) AS TeacherCount
                FROM Users
                WHERE CreatedDate >= DATEADD(MONTH, -7, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
                GROUP BY FORMAT([CreatedDate], 'MMM'), DATEPART(MONTH, [CreatedDate])
                ORDER BY DATEPART(MONTH, [CreatedDate])
            ", conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    registrationLabels.Add(reader["MonthLabel"].ToString());
                    studentCounts.Add(Convert.ToInt32(reader["StudentCount"]));
                    teacherCounts.Add(Convert.ToInt32(reader["TeacherCount"]));
                }
            }

            // Course Distribution (by department)
            using (var cmd = new SqlCommand(@"
                SELECT d.DepartmentName, COUNT(*) AS CourseCount
                FROM Courses c
                LEFT JOIN Department d ON c.DepartmentID = d.DepartmentID
                GROUP BY d.DepartmentName
            ", conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    courseLabels.Add(reader["DepartmentName"].ToString());
                    courseCounts.Add(Convert.ToInt32(reader["CourseCount"]));
                }
            }

            // Performance Overview (average score per course)
            using (var cmd = new SqlCommand(@"
                SELECT c.CourseCode, AVG(CAST(qs.Score AS FLOAT)) AS AvgScore
                FROM QuizSubmissions qs
                INNER JOIN Quizzes q ON qs.QuizID = q.QuizID
                INNER JOIN Courses c ON q.CourseID = c.CourseID
                GROUP BY c.CourseCode
            ", conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    performanceLabels.Add(reader["CourseCode"].ToString());
                    performanceScores.Add(reader["AvgScore"] != DBNull.Value ? Math.Round(Convert.ToDouble(reader["AvgScore"]), 1) : 0);
                }
            }
        }

        return new
        {
            success = true,
            data = new
            {
                registrationLabels,
                studentCounts,
                teacherCounts,
                courseLabels,
                courseCounts,
                performanceLabels,
                performanceScores
            }
        };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

[WebMethod]
[System.Web.Script.Services.ScriptMethod(ResponseFormat = System.Web.Script.Services.ResponseFormat.Json)]
public static object GetRecentActivity()
{
    try
    {
        var activities = new List<object>();
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();

            // Example: Fetch last 8 activities (customize as needed)
            string query = @"
                SELECT TOP 8 ActivityType, Description, CreatedDate
                FROM ActivityLog
                ORDER BY CreatedDate DESC";
            using (var cmd = new SqlCommand(query, conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Map ActivityType to icon and color (customize as needed)
                    string type = reader["ActivityType"].ToString();
                    string icon = "bell";
                    string iconBg = "#3498db";
                    switch (type)
                    {
                        case "UserRegistered": icon = "user-plus"; iconBg = "#3498db"; break;
                        case "QuizCompleted": icon = "clipboard-list"; iconBg = "#27ae60"; break;
                        case "CourseAdded": icon = "book"; iconBg = "#f39c12"; break;
                        case "TeacherAssigned": icon = "users"; iconBg = "#e74c3c"; break;
                        case "ReportGenerated": icon = "chart-line"; iconBg = "#9b59b6"; break;
                        case "MaterialUploaded": icon = "file-upload"; iconBg = "#17a2b8"; break;
                        case "QuizPassed": icon = "graduation-cap"; iconBg = "#27ae60"; break;
                        case "SystemNotice": icon = "bell"; iconBg = "#f39c12"; break;
                        default: icon = "bell"; iconBg = "#34db95ff"; break;
                    }

                    // Format time (e.g., "2 minutes ago")
                    DateTime created = Convert.ToDateTime(reader["CreatedDate"]);
                    string timeAgo = GetTimeAgo(created);

                    activities.Add(new
                    {
                        icon,
                        iconBg,
                        title = reader["Description"].ToString(),
                        time = timeAgo
                    });
                }
            }
        }
        return new { success = true, data = activities };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

// Helper to format "time ago"
private static string GetTimeAgo(DateTime dateTime)
{
    var span = DateTime.Now - dateTime;
    if (span.TotalMinutes < 1)
        return "just now";
    if (span.TotalMinutes < 60)
        return $"{(int)span.TotalMinutes} minutes ago";
    if (span.TotalHours < 24)
        return $"{(int)span.TotalHours} hours ago";
    if (span.TotalDays < 7)
        return $"{(int)span.TotalDays} days ago";
    return dateTime.ToString("MMM dd, yyyy");
}

[WebMethod]
    public static object PerformGlobalSearch(string query)
    {
        try
        {
            var results = new List<object>();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
            {
                con.Open();
                string searchQuery = @"
                    SELECT 'User' as Type, UserId as Id, UserName as Title, Email as Description, 'User.aspx?id=' + CAST(UserId as VARCHAR) as Url
                    FROM Users 
                    WHERE UserName LIKE @Query OR Email LIKE @Query
                    UNION ALL
                    SELECT 'Course' as Type, CourseId as Id, CourseName as Title, CourseDescription as Description, 'Course.aspx?id=' + CAST(CourseId as VARCHAR) as Url
                    FROM Courses 
                    WHERE CourseName LIKE @Query OR CourseDescription LIKE @Query
                    UNION ALL
                    SELECT 'Material' as Type, MaterialId as Id, MaterialName as Title, Description as Description, 'Material.aspx?id=' + CAST(MaterialId as VARCHAR) as Url
                    FROM Materials 
                    WHERE MaterialName LIKE @Query OR Description LIKE @Query";
                using (var cmd = new SqlCommand(searchQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Query", "%" + query + "%");
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            results.Add(new
                            {
                                Type = reader["Type"].ToString(),
                                Id = reader["Id"].ToString(),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                Url = reader["Url"].ToString()
                            });
                        }
                    }
                }
            }
            return new { success = true, results = results };
        }
        catch (Exception ex)
        {
            // Optionally log error
            return new { success = false, message = ex.Message };
        }
    }



    }
}