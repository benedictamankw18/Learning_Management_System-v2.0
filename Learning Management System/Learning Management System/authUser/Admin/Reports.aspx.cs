using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;


// This file is part of the Learning Management System project.
namespace Learning_Management_System.authUser.Admin
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetAllQuizTypes()
{
    try
    {
        var types = new HashSet<string>();
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT DISTINCT Type FROM Quizzes WHERE Type IS NOT NULL AND Type <> ''";
            using (var cmd = new SqlCommand(query, conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    types.Add(reader["Type"].ToString());
                }
            }
        }
        return new { success = true, data = types.ToList() };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetAcademicYears()
{
    try
    {
        var years = new List<string>();
        int currentYear = DateTime.Now.Year;
        // Generate the last 5 academic years (adjust as needed)
        for (int i = 0; i < 5; i++)
        {
            string yearRange = $"{currentYear - i}-{currentYear - i + 1}";
            years.Add(yearRange);
        }
        return new { success = true, data = years };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

        [WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetUsers(string userType, string status, string dateFilter)
{
     DateTime startDate = DateTime.MinValue, endDate = DateTime.MaxValue;
        var today = DateTime.Today;
    try
            {
                var users = new List<UserInfo>();
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string where = "WHERE 1=1";
                    if (userType == "students")
                        where += " AND u.UserType = 'student'";
                    else if (userType == "teachers")
                        where += " AND u.UserType = 'teacher'";
                    if (status != "all")
                        where += " AND u.IsActive = @IsActive";

                    if (!string.IsNullOrEmpty(dateFilter) && dateFilter != "all")
                    {

                        if (dateFilter == "thisMonth")
                        {
                            startDate = new DateTime(today.Year, today.Month, 1);
                            endDate = startDate.AddMonths(1).AddDays(-1);
                        }
                        else if (dateFilter == "lastMonth")
                        {
                            startDate = new DateTime(today.Year, today.Month, 1).AddMonths(-1);
                            endDate = new DateTime(today.Year, today.Month, 1).AddDays(-1);
                        }
                        else if (dateFilter == "thisYear")
                        {
                            startDate = new DateTime(today.Year, 1, 1);
                            endDate = new DateTime(today.Year, 12, 31);
                        }
                        else
                        {
                            startDate = DateTime.MinValue;
                            endDate = DateTime.MaxValue;
                        }
                        where += " AND u.CreatedDate BETWEEN @StartDate AND @EndDate";
                    }
                    string query = $@"
                SELECT u.UserID, u.FullName, u.Email, u.UserType, u.IsActive, u.CreatedDate,
                       d.DepartmentName, l.LevelName, p.ProgrammeName
                FROM Users u
                LEFT JOIN Department d ON u.DepartmentID = d.DepartmentID
                LEFT JOIN Level l ON u.LevelID = l.LevelID
                LEFT JOIN Programme p ON u.ProgrammeID = p.ProgrammeID
                {where}
                ORDER BY u.CreatedDate DESC";

                    using (var cmd = new SqlCommand(query, conn))
                    {
                        if (status != "all")
                            cmd.Parameters.AddWithValue("@IsActive", status == "active" ? 1 : 0);
                        if (!string.IsNullOrEmpty(dateFilter) && dateFilter != "all")
                        {
                            cmd.Parameters.AddWithValue("@StartDate", startDate);
                            cmd.Parameters.AddWithValue("@EndDate", endDate);
                        }
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                users.Add(new UserInfo
                                {
                                    Id = Convert.ToInt32(reader["UserID"]),
                                    Name = reader["FullName"].ToString(),
                                    Email = reader["Email"].ToString(),
                                    UserType = reader["UserType"].ToString(),
                                    Department = reader["DepartmentName"]?.ToString(),
                                    Level = reader["LevelName"]?.ToString(),
                                    Programme = reader["ProgrammeName"]?.ToString(),
                                    Program = reader["ProgrammeName"]?.ToString(),
                                    Status = (reader["IsActive"] != DBNull.Value && (bool)reader["IsActive"]) ? "Active" : "Inactive",
                                    RegistrationDate = reader["CreatedDate"] != DBNull.Value
                                        ? Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd")
                                        : ""
                                });
                            }
                        }
                    }
                }
                return new { success = true, data = users };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
}

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetAllCourses()
{
    try
    {
        var courses = new List<object>();
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT CourseID, CourseName FROM Courses WHERE IsActive = 1";
            using (var cmd = new SqlCommand(query, conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    courses.Add(new {
                        id = reader["CourseID"].ToString(),
                        name = reader["CourseName"].ToString()
                    });
                }
            }
        }
        return new { success = true, data = courses };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetAllDepartments()
{
    try
    {
        var departments = new List<object>();
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT DepartmentID, DepartmentName FROM Department WHERE IsActive = 1";
            using (var cmd = new SqlCommand(query, conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    departments.Add(new {
                        id = reader["DepartmentID"].ToString(),
                        name = reader["DepartmentName"].ToString()
                    });
                }
            }
        }
        return new { success = true, data = departments };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetQuizzes(string course, string level, string type, string status)
        {
            try
            {
                var quizzes = new List<QuizInfo>();
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string where = "WHERE 1=1";
                    if (course != "all")
                        where += " AND c.CourseID = @Course";
                    if (level != "all")
                        where += " AND l.LevelName = @Level";
                    if (type != "all")
                        where += " AND q.Type = @Type";
                    if (status != "all")
                        where += " AND q.Status = @Status"; // <-- Add this line

                    string query = $@"SELECT 
                        q.QuizID, 
                        q.Title, 
                        q.Type, 
                        q.Status, l.LevelName,
                        COUNT(qq.QuestionID) AS TotalQuestions,  
                        q.CreatedDate,
                        c.CourseName
                    FROM Quizzes q
                    LEFT JOIN QuizQuestions qq ON qq.QuizId = q.QuizId
                    LEFT JOIN Courses c ON q.CourseID = c.CourseID
                    LEFT JOIN Level l ON c.LevelID = l.LevelID
                    {where}
                    GROUP BY q.QuizID, q.Title, q.Type, q.Status, q.CreatedDate, c.CourseName, l.LevelName
                    ORDER BY q.CreatedDate DESC";


                    using (var cmd = new SqlCommand(query, conn))
                    {
                        if (course != "all")
                            cmd.Parameters.AddWithValue("@Course", course);
                        if (level != "all")
                            cmd.Parameters.AddWithValue("@Level", level.Replace("level", ""));
                        if (type != "all")
                            cmd.Parameters.AddWithValue("@Type", type);
                        if (status != "all")
                            cmd.Parameters.AddWithValue("@Status", CapitalizeFirst(status)); // e.g., "Active", "Archived", "Draft"

                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                quizzes.Add(new QuizInfo
                                {
                                    Id = Convert.ToInt32(reader["QuizID"]),
                                    Title = reader["Title"].ToString(),
                                    Type = reader["Type"].ToString(),
                                    Status = reader["Status"].ToString(),
                                    Questions = Convert.ToInt32(reader["TotalQuestions"]),
                                    CreatedDate = Convert.ToDateTime(reader["CreatedDate"]).ToString("yyyy-MM-dd"),
                                    Course = reader["CourseName"].ToString(),
                                    Level = reader["LevelName"].ToString()
                                });
                            }
                        }
                    }
                }
                return new { success = true, data = quizzes };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }


[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetAllLevels()
{
    try
    {
        var levels = new List<object>();
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT LevelID, LevelName FROM Level ORDER BY LevelName";
            using (var cmd = new SqlCommand(query, conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    levels.Add(new {
                        id = reader["LevelID"].ToString(),
                        name = reader["LevelName"].ToString()
                    });
                }
            }
        }
        return new { success = true, data = levels };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}
        // Helper to capitalize first letter
        private static string CapitalizeFirst(string input)
        {
            if (string.IsNullOrEmpty(input)) return input;
            return char.ToUpper(input[0]) + input.Substring(1).ToLower();
        }

 public class AssignmentInfo
        {
            public string TeacherName { get; set; }
            public string TeacherEmail { get; set; }
            public string AssignmentDate { get; set; }
        }
        public class EnrollmentInfo
        {
            public string StudentName { get; set; }
            public string StudentEmail { get; set; }
            public string EnrollmentDate { get; set; }
        }

        public class CourseInfo
        {
            public int Id { get; set; }
            public string Code { get; set; }
            public string Name { get; set; }
            public string Department { get; set; }
            public string Level { get; set; }
            public string Programme { get; set; }
            public string Teacher { get; set; }
            public string TeacherID { get; set; }
            public int Enrolled { get; set; }
            public int Capacity { get; set; }
            public List<EnrollmentInfo> Enrollments { get; set; } = new List<EnrollmentInfo>();
            public List<AssignmentInfo> Assignments { get; set; } = new List<AssignmentInfo>();
            public string AcademicYear { get; set; }
            public string Semester { get; set; }
            public string Available { get; set; }
        }

        public class UserInfo
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public string UserType { get; set; }
            public string Department { get; set; }
            public string Level { get; set; }
            public string Programme { get; set; }
            public string Program { get; set; }
            public string Status { get; set; }
            public string RegistrationDate { get; set; }
        }

        public class QuizInfo
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public string Course { get; set; }
            public string Section { get; set; }
            public string Level { get; set; }
            public string Status { get; set; }
            public string CreatedDate { get; set; }
            public string Type { get; set; }
            public int Questions { get; set; }
            public int Submissions { get; set; }
            public double AvgScore { get; set; }
        }

       [WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetCourses(string year, string semester, string department)
{
    try
    {
        var courses = new List<CourseInfo>();
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();

            string query = @"
                SELECT 
                    c.CourseID, 
                    c.CourseCode, 
                    c.CourseName, 
                    d.DepartmentName, 
                    l.LevelName, 
                    p.ProgrammeName,
                    c.UserID AS TeacherID, 
                    u.FullName AS TeacherName,
                    c.Status As Status,
                    CASE 
                        WHEN c.IsActive = 1 THEN 'Available'
                        WHEN c.IsActive = 0 THEN 'Not Available'
                    END As Available,
                    (SELECT COUNT(*) FROM UserCourses uc WHERE uc.CourseID = c.CourseID) AS Enrolled,

                    CAST(YEAR(c.StartDate) AS VARCHAR(4)) + '-' + CAST(YEAR(c.EndDate) AS VARCHAR(4)) AS AcademicYear,

                    CASE 
                        WHEN MONTH(c.StartDate) BETWEEN 9 AND 12 THEN 'First Semester'
                        WHEN MONTH(c.StartDate) BETWEEN 1 AND 6 THEN 'Second Semester'
                        ELSE 'Other'
                    END AS Semester
                FROM Courses c
                LEFT JOIN Department d ON c.DepartmentID = d.DepartmentID
                LEFT JOIN Level l ON c.LevelID = l.LevelID
                LEFT JOIN Programme p ON c.ProgrammeID = p.ProgrammeID
                LEFT JOIN Users u ON c.UserID = u.UserID
                WHERE 1=1";

            // ✅ Year filter (optional)
            if (year != "all")
                query += " AND CAST(YEAR(c.StartDate) AS VARCHAR(4)) + '-' + CAST(YEAR(c.EndDate) AS VARCHAR(4)) = @Year";

            // ✅ Department filter (optional)
            if (department != "all")
                query += " AND c.DepartmentID = @Department";

            using (var cmd = new SqlCommand(query, conn))
            {
                if (year != "all")
                    cmd.Parameters.AddWithValue("@Year", year);
                if (department != "all")
                    cmd.Parameters.AddWithValue("@Department", department);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        courses.Add(new CourseInfo
                        {
                            Id = Convert.ToInt32(reader["CourseID"]),
                            Name = reader["CourseName"].ToString(),
                            Code = reader["CourseCode"].ToString(),
                            Department = reader["DepartmentName"]?.ToString(),
                            Level = reader["LevelName"]?.ToString(),
                            Programme = reader["ProgrammeName"]?.ToString(),
                            Teacher = reader["TeacherName"]?.ToString(),
                            TeacherID = reader["TeacherID"]?.ToString(),
                            Enrolled = Convert.ToInt32(reader["Enrolled"]),
                            AcademicYear = reader["AcademicYear"]?.ToString(),
                            Semester = reader["Semester"]?.ToString(),
                            Available = reader["Available"]?.ToString()
                        });
                    }
                }
            }

            // ✅ Fetch Enrollments & Assignments per course
            foreach (var course in courses)
            {
                // Enrollments
                course.Enrollments = new List<EnrollmentInfo>();
                string enrollQuery = @"
                    SELECT u.FullName AS studentName, u.Email AS studentEmail, uc.EnrollmentDate
                    FROM UserCourses uc
                    JOIN Users u ON uc.UserID = u.UserID
                    WHERE uc.CourseID = @CourseID AND u.UserType = 'student'";

                using (var enrollCmd = new SqlCommand(enrollQuery, conn))
                {
                    enrollCmd.Parameters.AddWithValue("@CourseID", course.Id);
                    using (var enrollReader = enrollCmd.ExecuteReader())
                    {
                        while (enrollReader.Read())
                        {
                            course.Enrollments.Add(new EnrollmentInfo
                            {
                                StudentName = enrollReader["studentName"].ToString(),
                                StudentEmail = enrollReader["studentEmail"].ToString(),
                                EnrollmentDate = enrollReader["EnrollmentDate"] != DBNull.Value
                                    ? Convert.ToDateTime(enrollReader["EnrollmentDate"]).ToString("yyyy-MM-dd")
                                    : ""
                            });
                        }
                    }
                }

                // Assignments
                course.Assignments = new List<AssignmentInfo>();
                string assignQuery = @"
                    SELECT u.FullName AS teacherName, u.Email AS teacherEmail, uc.EnrollmentDate as AssignmentDate
                    FROM UserCourses uc
                    JOIN Users u ON uc.UserID = u.UserID
                    WHERE uc.CourseID = @CourseID AND u.UserType = 'teacher'";

                using (var assignCmd = new SqlCommand(assignQuery, conn))
                {
                    assignCmd.Parameters.AddWithValue("@CourseID", course.Id);
                    using (var assignReader = assignCmd.ExecuteReader())
                    {
                        while (assignReader.Read())
                        {
                            course.Assignments.Add(new AssignmentInfo
                            {
                                TeacherName = assignReader["teacherName"].ToString(),
                                TeacherEmail = assignReader["teacherEmail"].ToString(),
                                AssignmentDate = assignReader["AssignmentDate"] != DBNull.Value
                                    ? Convert.ToDateTime(assignReader["AssignmentDate"]).ToString("yyyy-MM-dd")
                                    : ""
                            });
                        }
                    }
                }
            }
        }

        return new { success = true, data = courses };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetStatistics()
{
    try
    {
        int students = 0, teachers = 0, courses = 0, quizzes = 0;
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserType = 'student'", conn))
                students = (int)cmd.ExecuteScalar();
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserType = 'teacher'", conn))
                teachers = (int)cmd.ExecuteScalar();
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Courses", conn))
                courses = (int)cmd.ExecuteScalar();
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Quizzes", conn))
                quizzes = (int)cmd.ExecuteScalar();
        }
        return new { success = true, data = new { students, teachers, courses, quizzes } };
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}
    }
}