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
using System.IO;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel; // For .xlsx
using OfficeOpenXml;
using Newtonsoft.Json;


namespace Learning_Management_System.authUser.Teacher
{
    public partial class Quizzes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public class QuizInfo
        {
            public int QuizID { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
            public string Type { get; set; }
            public int Duration { get; set; }
            public int MaxAttempts { get; set; }
            public string Status { get; set; }
            public bool IsActivated { get; set; }
            public string StartDate { get; set; }
            public string EndDate { get; set; }
            public int Questions { get; set; }
        }

        [WebMethod(EnableSession = true)]
        public static string GetTeacherQuizzes()
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var quizzes = new List<QuizInfo>();
            if (string.IsNullOrEmpty(teacherId)) return "[]";
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT q.QuizID, q.Title, q.Description, q.Type, q.Duration, q.MaxAttempts, q.Status, q.IsActivated,
                   q.StartDate, q.EndDate,
                   (SELECT COUNT(*) FROM QuizQuestions qq WHERE qq.QuizID = q.QuizID) AS Questions
            FROM Quizzes q
            INNER JOIN Courses c ON c.CourseID = q.CourseID
            WHERE c.UserID = @TeacherId
            ORDER BY q.StartDate DESC
        ";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            quizzes.Add(new QuizInfo
                            {
                                QuizID = Convert.ToInt32(reader["QuizID"]),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                Type = reader["Type"].ToString(),
                                Duration = reader["Duration"] != DBNull.Value ? Convert.ToInt32(reader["Duration"]) : 0,
                                MaxAttempts = reader["MaxAttempts"] != DBNull.Value ? Convert.ToInt32(reader["MaxAttempts"]) : 1,
                                Status = reader["Status"].ToString(),
                                IsActivated = reader["IsActivated"] != DBNull.Value && (bool)reader["IsActivated"],
                                StartDate = reader["StartDate"]?.ToString(),
                                EndDate = reader["EndDate"]?.ToString(),
                                Questions = reader["Questions"] != DBNull.Value ? Convert.ToInt32(reader["Questions"]) : 0
                            });
                        }
                    }
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(quizzes);
        }

        [WebMethod(EnableSession = true)]
        public static string DeleteQuiz(int quizId)
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(teacherId))
                return "{\"success\":false,\"message\":\"Not authorized.\"}";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Only allow delete if the quiz belongs to this teacher
                string sql = @"
            DELETE FROM Quizzes
            WHERE QuizID = @QuizID
            AND CourseID IN (SELECT CourseID FROM Courses WHERE UserID = @TeacherId)
        ";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                        return "{\"success\":true}";
                    else
                        return "{\"success\":false,\"message\":\"Quiz not found or not authorized.\"}";
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public static string ToggleQuizActivation(int quizId, bool activate)
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(teacherId))
                return "{\"success\":false,\"message\":\"Not authorized.\"}";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Only allow toggle if the quiz belongs to this teacher
                string sql = @"
            UPDATE Quizzes
            SET IsActivated = @IsActivated
            WHERE QuizID = @QuizID
            AND CourseID IN (SELECT CourseID FROM Courses WHERE UserID = @TeacherId)
        ";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    cmd.Parameters.AddWithValue("@IsActivated", activate);
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                        return "{\"success\":true}";
                    else
                        return "{\"success\":false,\"message\":\"Quiz not found or not authorized.\"}";
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public static string AddQuiz(string title, string description, string type, int duration, int maxAttempts, string status, bool isActivated, string startDate, string endDate)
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(teacherId))
                return "{\"success\":false,\"message\":\"Not authorized.\"}";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Get the first course for this teacher (or let the user select course in your form)
                string getCourseSql = "SELECT TOP 1 CourseID FROM Courses WHERE UserID = @TeacherId";
                int courseId = 0;
                using (SqlCommand cmd = new SqlCommand(getCourseSql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    var result = cmd.ExecuteScalar();
                    if (result == null)
                        return "{\"success\":false,\"message\":\"No course found for this teacher.\"}";
                    courseId = Convert.ToInt32(result);
                    conn.Close();
                }

                string sql = @"INSERT INTO Quizzes (CourseID, Title, Description, Type, Duration, MaxAttempts, Status, IsActivated, StartDate, EndDate, CreatedDate)
                       VALUES (@CourseID, @Title, @Description, @Type, @Duration, @MaxAttempts, @Status, @IsActivated, @StartDate, @EndDate, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description ?? "");
                    cmd.Parameters.AddWithValue("@Type", type);
                    cmd.Parameters.AddWithValue("@Duration", duration);
                    cmd.Parameters.AddWithValue("@MaxAttempts", maxAttempts);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@IsActivated", isActivated);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            return "{\"success\":true}";
        }

        [WebMethod(EnableSession = true)]
        public static string EditQuiz(int quizId, string title, string description, string type, int duration, int maxAttempts, string status, bool isActivated, string startDate, string endDate)
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(teacherId))
                return "{\"success\":false,\"message\":\"Not authorized.\"}";

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Only allow update if the quiz belongs to this teacher
                string sql = @"
            UPDATE Quizzes
            SET Title = @Title,
                Description = @Description,
                Type = @Type,
                Duration = @Duration,
                MaxAttempts = @MaxAttempts,
                Status = @Status,
                IsActivated = @IsActivated,
                StartDate = @StartDate,
                EndDate = @EndDate
            WHERE QuizID = @QuizID
            AND CourseID IN (SELECT CourseID FROM Courses WHERE UserID = @TeacherId)
        ";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description ?? "");
                    cmd.Parameters.AddWithValue("@Type", type);
                    cmd.Parameters.AddWithValue("@Duration", duration);
                    cmd.Parameters.AddWithValue("@MaxAttempts", maxAttempts);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@IsActivated", isActivated);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows > 0)
                        return "{\"success\":true}";
                    else
                        return "{\"success\":false,\"message\":\"Quiz not found or not authorized.\"}";
                }
            }
        }


        // Quiz.aspx.cs
        [System.Web.Services.WebMethod]
        public static object UploadQuizExcel(string base64Excel, string title, int duration, string status, string type, int courseId, int? sectionId)
        {
            int errorRow = 0; // Track the row for error reporting
            try
            {
                // Convert base64 to byte array
                byte[] fileBytes = Convert.FromBase64String(base64Excel);
                using (var stream = new MemoryStream(fileBytes))
                {
                    IWorkbook workbook = new XSSFWorkbook(stream);
                    ISheet sheet = workbook.GetSheetAt(0);

                    // Insert quiz first
                    int quizId = 0;
                    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString))
                    {
                        conn.Open();
                        var quizCmd = new SqlCommand(@"
                    INSERT INTO Quizzes (CourseId, SectionId, Title, Duration, Status, Type, IsActivated, StartDate, EndDate)
                    OUTPUT INSERTED.QuizId 
                    VALUES (@CourseId, @SectionId, @Title, @Duration, @Status, @Type, 1, GETDATE(), GETDATE())", conn);
                        quizCmd.Parameters.AddWithValue("@CourseId", courseId);
                        quizCmd.Parameters.AddWithValue("@SectionId", (object)sectionId ?? DBNull.Value);
                        quizCmd.Parameters.AddWithValue("@Title", title);
                        quizCmd.Parameters.AddWithValue("@Duration", duration);
                        quizCmd.Parameters.AddWithValue("@Status", status);
                        quizCmd.Parameters.AddWithValue("@Type", type);
                        quizId = (int)quizCmd.ExecuteScalar();

                        // Insert questions
                        for (int row = 1; row <= sheet.LastRowNum; row++) // row 0 is header
                        {
                            errorRow = row + 1;
                            IRow excelRow = sheet.GetRow(row);
                            if (excelRow == null) continue;

                            string qText = excelRow.GetCell(0)?.ToString().Trim();
                            string optA = excelRow.GetCell(1)?.ToString().Trim();
                            string optB = excelRow.GetCell(2)?.ToString().Trim();
                            string optC = excelRow.GetCell(3)?.ToString().Trim();
                            string optD = excelRow.GetCell(4)?.ToString().Trim();
                            string answer = excelRow.GetCell(5)?.ToString().Trim().ToUpper();

                            // Validation
                            if (string.IsNullOrWhiteSpace(qText) ||
                                string.IsNullOrWhiteSpace(optA) ||
                                string.IsNullOrWhiteSpace(optB) ||
                                string.IsNullOrWhiteSpace(optC) ||
                                string.IsNullOrWhiteSpace(optD) ||
                                string.IsNullOrWhiteSpace(answer))
                            {
                                return new { success = false, message = $"Row {errorRow}: Missing required data." };
                            }
                            if (!new[] { "A", "B", "C", "D" }.Contains(answer))
                            {
                                return new { success = false, message = $"Row {errorRow}: Answer must be A, B, C, or D." };
                            }

                            var options = new { A = optA, B = optB, C = optC, D = optD };

                            var qCmd = new SqlCommand(@"
                        INSERT INTO QuizQuestions
                        (QuizId, QuestionText, QuestionType, Points, Difficulty, Explanation, Options, CorrectAnswer)
                        VALUES (@QuizId, @QuestionText, @QuestionType, @Points, @Difficulty, @Explanation, @Options, @CorrectAnswer)", conn);

                            qCmd.Parameters.AddWithValue("@QuizId", quizId);
                            qCmd.Parameters.AddWithValue("@QuestionText", qText);
                            qCmd.Parameters.AddWithValue("@QuestionType", "multiple-choice");
                            qCmd.Parameters.AddWithValue("@Points", 1); // Or get from Excel if you want
                            qCmd.Parameters.AddWithValue("@Difficulty", "medium"); // Or get from Excel if you want
                            qCmd.Parameters.AddWithValue("@Explanation", ""); // Or get from Excel if you want
                            qCmd.Parameters.AddWithValue("@Options", Newtonsoft.Json.JsonConvert.SerializeObject(options));
                            qCmd.Parameters.AddWithValue("@CorrectAnswer", answer);

                            qCmd.ExecuteNonQuery();
                        }
                    }
                }
                return new { success = true };
            }
            catch (Exception exRow)
            {
                return new { success = false, message = $"Row {errorRow}: {exRow.Message}" };
            }
        }
        
        [System.Web.Services.WebMethod]
        public static object GetCourseQuizzes(int courseId)
        {
            var quizzes = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
            SELECT 
                QuizId, Title, Description, Duration, MaxAttempts, Status, Type, IsActivated, 
                StartDate, EndDate, CreatedDate,
                (SELECT COUNT(*) FROM QuizQuestions WHERE QuizId = q.QuizId) AS Questions
            FROM Quizzes q
            WHERE CourseId = @CourseId
            ORDER BY CreatedDate DESC";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            quizzes.Add(new
                            {
                                id = Convert.ToInt32(reader["QuizId"]),
                                title = reader["Title"].ToString(),
                                description = reader["Description"].ToString(),
                                duration = Convert.ToInt32(reader["Duration"]),
                                maxAttempts = Convert.ToInt32(reader["MaxAttempts"]),
                                status = reader["Status"].ToString(),
                                type = reader["Type"].ToString(),
                                isActivated = Convert.ToBoolean(reader["IsActivated"]),
                                startDate = reader["StartDate"] != DBNull.Value ? ((DateTime)reader["StartDate"]).ToString("yyyy-MM-dd") : "",
                                startTime = reader["StartDate"] != DBNull.Value ? ((DateTime)reader["StartDate"]).ToString("HH:mm") : "",
                                endDate = reader["EndDate"] != DBNull.Value ? ((DateTime)reader["EndDate"]).ToString("yyyy-MM-dd") : "",
                                endTime = reader["EndDate"] != DBNull.Value ? ((DateTime)reader["EndDate"]).ToString("HH:mm") : "",
                                questions = Convert.ToInt32(reader["Questions"]),
                                created = reader["CreatedDate"] != DBNull.Value ? ((DateTime)reader["CreatedDate"]).ToString("yyyy-MM-dd") : ""
                            });
                        }
                    }
                }
            }
            return new { success = true, data = quizzes };
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetTeacherCourses()
        {
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();
            var courses = new List<object>();
            if (string.IsNullOrEmpty(teacherId)) return "[]";
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseID, CourseName FROM Courses WHERE UserID = @TeacherId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new
                            {
                                CourseID = reader["CourseID"],
                                Title = reader["CourseName"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(courses);
        }


        [System.Web.Services.WebMethod]
        public static string GetSectionsByCourse(int courseId)
        {
            var sections = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseSectionsId, SectionName FROM CourseSections WHERE CourseID = @CourseID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            sections.Add(new
                            {
                                SectionID = reader["CourseSectionsId"],
                                Name = reader["SectionName"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(sections);
        }
    }
}