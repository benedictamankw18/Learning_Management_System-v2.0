using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Services;
using System.IO;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel; // For .xlsx
using OfficeOpenXml;
using Newtonsoft.Json;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Quiz : System.Web.UI.Page
    {
        private const LicenseContext nonCommercial = OfficeOpenXml.LicenseContext.NonCommercial;

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetCourses()
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

            var courses = new List<object>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = "SELECT c.CourseID, c.CourseCode, " +
                               "c.CourseName, c.Description, COUNT(q.QuizId) AS CounterQuizzes " +
                               "FROM Courses c " +
                               "LEFT JOIN Quizzes q ON c.CourseID = q.CourseId " +
                               "WHERE c.IsActive = 1 " +
                               "GROUP BY c.CourseID, c.CourseCode, c.CourseName, c.Description " +
                               "ORDER BY c.CourseName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new
                            {
                                id = reader["CourseID"],
                                code = reader["CourseCode"],
                                name = reader["CourseName"],
                                description = reader["Description"],
                                quizCount = reader["CounterQuizzes"]
                            });
                        }
                    }
                }
            }
            return new { success = true, data = courses };
        }

        [WebMethod]
        public static object AddQuiz(int courseId, int? sectionId, string title, string description, int duration, int maxAttempts, string status, string type, bool isActivated, DateTime startDate, DateTime endDate)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"INSERT INTO Quizzes
                (CourseId, SectionId, Title, Description, Duration, MaxAttempts, Status, Type, IsActivated, StartDate, EndDate, CreatedDate)
                VALUES
                (@CourseId, @SectionId, @Title, @Description, @Duration, @MaxAttempts, @Status, @Type, @IsActivated, @StartDate, @EndDate, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.Parameters.AddWithValue("@SectionId", (object)sectionId ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Description", description ?? "");
                        cmd.Parameters.AddWithValue("@Duration", duration);
                        cmd.Parameters.AddWithValue("@MaxAttempts", maxAttempts);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@Type", type);
                        cmd.Parameters.AddWithValue("@IsActivated", isActivated);
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);

                        int rows = cmd.ExecuteNonQuery();
                        return new { success = rows > 0 };
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }

        [System.Web.Services.WebMethod]
        public static object GetSectionQuizzes(int sectionId)
        {
            var quizzes = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
            SELECT 
                QuizId, Title, Description, Duration, MaxAttempts, Status, Type, IsActivated, 
                StartDate, EndDate, CreatedDate
            FROM Quizzes
            WHERE SectionId = @SectionId
            ORDER BY CreatedDate DESC";
                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SectionId", sectionId);
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
                                created = reader["CreatedDate"] != DBNull.Value ? ((DateTime)reader["CreatedDate"]).ToString("yyyy-MM-dd") : ""
                            });
                        }
                    }
                }
            }
            return new { success = true, data = quizzes };
        }


[System.Web.Services.WebMethod]
public static object GetQuizQuestions(int quizId)
{
    var questions = new List<object>();
    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    using (var conn = new SqlConnection(connStr))
    {
        conn.Open();
        string query = @"
    SELECT 
        QuestionId, QuestionText, QuestionType, Points, Difficulty, Explanation, Options, CorrectAnswer
    FROM QuizQuestions
    WHERE QuizId = @QuizId
    ORDER BY QuestionId";
        using (var cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.AddWithValue("@QuizId", quizId);
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // In GetQuizQuestions
questions.Add(new {
    id = Convert.ToInt32(reader["QuestionId"]),
    text = reader["QuestionText"].ToString(),
    type = reader["QuestionType"].ToString(),
    points = Convert.ToInt32(reader["Points"]),
    difficulty = reader["Difficulty"].ToString(),
    explanation = reader["Explanation"].ToString(),
    options = reader["Options"] != DBNull.Value ? reader["Options"].ToString() : "",
    correctAnswer = reader["CorrectAnswer"] != DBNull.Value ? reader["CorrectAnswer"].ToString() : ""
});
                }
            }
        }
    }
    return new { success = true, data = questions };
}


[System.Web.Services.WebMethod]
public static object UpdateQuizQuestion(int questionId, string text, string type, int points, string difficulty, string explanation, string optionsJson, string correctAnswer)
{
    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    try
    {
        using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
        {
            conn.Open();
            string query = @"UPDATE QuizQuestions SET
                QuestionText = @QuestionText,
                QuestionType = @QuestionType,
                Points = @Points,
                Difficulty = @Difficulty,
                Explanation = @Explanation,
                Options = @Options,
                CorrectAnswer = @CorrectAnswer
            WHERE QuestionId = @QuestionId";
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuestionId", questionId);
                cmd.Parameters.AddWithValue("@QuestionText", text);
                cmd.Parameters.AddWithValue("@QuestionType", type);
                cmd.Parameters.AddWithValue("@Points", points);
                cmd.Parameters.AddWithValue("@Difficulty", difficulty);
                cmd.Parameters.AddWithValue("@Explanation", explanation ?? "");
                cmd.Parameters.AddWithValue("@Options", optionsJson ?? "");
                cmd.Parameters.AddWithValue("@CorrectAnswer", correctAnswer ?? "");
                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
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
        // Add this at the top of your file:
        // using OfficeOpenXml;
        
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
                var quizCmd = new SqlCommand(@"INSERT INTO Quizzes (CourseId, SectionId, Title, Duration, Status, Type, IsActivated, StartDate, EndDate)
                    OUTPUT INSERTED.QuizId VALUES (@CourseId, @SectionId, @Title, @Duration, @Status, @Type, 1, GETDATE(), GETDATE())", conn);
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
        IRow excelRow = sheet.GetRow(row);
        if (excelRow == null) continue;

        string qText = excelRow.GetCell(0)?.ToString().Trim();
        if (string.IsNullOrWhiteSpace(qText)) continue;

        string optA = excelRow.GetCell(1)?.ToString().Trim();
        string optB = excelRow.GetCell(2)?.ToString().Trim();
        string optC = excelRow.GetCell(3)?.ToString().Trim();
        string optD = excelRow.GetCell(4)?.ToString().Trim();
        string answer = excelRow.GetCell(5)?.ToString().Trim().ToUpper();

        var options = new { A = optA, B = optB, C = optC, D = optD };

    var qCmd = new SqlCommand(@"INSERT INTO QuizQuestions
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
    return new { success = false, message = $"Row {errorRow}: {exRow.ToString()}" };
}
}


[System.Web.Services.WebMethod]
public static object DeleteQuizQuestion(int questionId)
{
    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    try
    {
        using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
        {
            conn.Open();
            string query = "DELETE FROM QuizQuestions WHERE QuestionId = @QuestionId";
            using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuestionId", questionId);
                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


        [System.Web.Services.WebMethod]
public static object UpdateQuiz(int quizId, int courseId, int? sectionId, string title, string description, int duration, int maxAttempts, string status, string type, bool isActivated, DateTime startDate, DateTime endDate)
{
    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    try
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = @"UPDATE Quizzes SET
                CourseId = @CourseId,
                SectionId = @SectionId,
                Title = @Title,
                Description = @Description,
                Duration = @Duration,
                MaxAttempts = @MaxAttempts,
                Status = @Status,
                Type = @Type,
                IsActivated = @IsActivated,
                StartDate = @StartDate,
                EndDate = @EndDate
            WHERE QuizId = @QuizId";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                cmd.Parameters.AddWithValue("@SectionId", (object)sectionId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", description ?? "");
                cmd.Parameters.AddWithValue("@Duration", duration);
                cmd.Parameters.AddWithValue("@MaxAttempts", maxAttempts);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@Type", type);
                cmd.Parameters.AddWithValue("@IsActivated", isActivated);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@EndDate", endDate);

                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}

[System.Web.Services.WebMethod]
public static object AddQuizQuestion(int quizId, string text, string type, int points, string difficulty, string explanation, string optionsJson, string correctAnswer)
{
    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    try
    {
        using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
        {
            conn.Open();
            string query = @"INSERT INTO QuizQuestions
                (QuizId, QuestionText, QuestionType, Points, Difficulty, Explanation, Options, CorrectAnswer)
                VALUES
                (@QuizId, @QuestionText, @QuestionType, @Points, @Difficulty, @Explanation, @Options, @CorrectAnswer)";
            using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.Parameters.AddWithValue("@QuestionText", text);
                cmd.Parameters.AddWithValue("@QuestionType", type);
                cmd.Parameters.AddWithValue("@Points", points);
                cmd.Parameters.AddWithValue("@Difficulty", difficulty);
                cmd.Parameters.AddWithValue("@Explanation", explanation ?? "");
                cmd.Parameters.AddWithValue("@Options", optionsJson ?? "");
                cmd.Parameters.AddWithValue("@CorrectAnswer", correctAnswer ?? "");
                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}



        [System.Web.Services.WebMethod]
public static object ToggleQuizActivation(int quizId, bool activate)
{
    string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    try
    {
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "UPDATE Quizzes SET IsActivated = @IsActivated WHERE QuizId = @QuizId";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@IsActivated", activate);
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
    }
}


[System.Web.Services.WebMethod]
public static object DeleteQuiz(int quizId)
{
    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
    try
    {
        using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
        {
            conn.Open();
            // Optionally, delete related questions first if you have ON DELETE CASCADE set up, you can skip this step
            string deleteQuestions = "DELETE FROM QuizQuestions WHERE QuizId = @QuizId";
            using (var cmd = new System.Data.SqlClient.SqlCommand(deleteQuestions, conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                cmd.ExecuteNonQuery();
            }
            // Delete the quiz
            string deleteQuiz = "DELETE FROM Quizzes WHERE QuizId = @QuizId";
            using (var cmd = new System.Data.SqlClient.SqlCommand(deleteQuiz, conn))
            {
                cmd.Parameters.AddWithValue("@QuizId", quizId);
                int rows = cmd.ExecuteNonQuery();
                return new { success = rows > 0 };
            }
        }
    }
    catch (Exception ex)
    {
        return new { success = false, message = ex.Message };
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


    }
}