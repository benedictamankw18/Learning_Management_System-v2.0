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
    public partial class Grades : System.Web.UI.Page
    {
        [WebMethod]
        public static string GetTeacherCourses()
        {
            var userId = System.Web.HttpContext.Current.Session["UserID"];
            var courses = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand(@"SELECT c.CourseID, c.CourseName, c.CourseCode 
                    FROM Courses c 
                    WHERE c.UserID = @UserID", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        courses.Add(new
                        {
                            CourseID = dr["CourseID"].ToString(),
                            CourseName = dr["CourseName"].ToString(),
                            CourseCode = dr["CourseCode"].ToString()
                        });
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(courses);
        }

        [WebMethod]
        public static string GetAssignmentsForCourse(string courseId)
        {
            var assignments = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand(@"SELECT AssignmentID, Title FROM Assignments WHERE CourseID = @CourseID", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        assignments.Add(new
                        {
                            AssignmentID = dr["AssignmentID"].ToString(),
                            AssignmentTitle = dr["Title"].ToString()
                        });
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(assignments);
        }

        [WebMethod]
        public static string GetAssignmentGrades(string courseId, string assignmentId)
        {
            var grades = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand(@"
                    SELECT u.FullName, u.UserID, u.Email, u.EmployeeID, u.ProfilePicture, 
                           c.CourseName, c.CourseCode, a.Title AS AssignmentTitle, 
                           s.SubmissionFile, s.Score, s.Feedback, s.Status
                    FROM Users u
                    INNER JOIN UserCourses uc ON u.UserID = uc.UserID
                    INNER JOIN Courses c ON uc.CourseID = c.CourseID
                    LEFT JOIN AssignmentSubmissions s ON s.StudentID = u.UserID AND s.AssignmentID = @AssignmentID
                    INNER JOIN Assignments a ON a.AssignmentID = @AssignmentID
                    WHERE uc.CourseID = @CourseID AND s.SubmissionFile IS NOT NULL 
                ", conn);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        int grade = dr["Score"] != DBNull.Value ? Convert.ToInt32(dr["Score"]) : 0;
                        grades.Add(new
                        {
                            userId = dr["UserID"].ToString(), // <-- add this line
                            name = dr["FullName"].ToString(),
                            index = dr["EmployeeID"].ToString(),
                            course = dr["CourseName"].ToString(),
                            assignment = dr["AssignmentTitle"].ToString(),
                            grade = grade,
                            status = dr["Status"] != DBNull.Value ? dr["Status"].ToString() : (grade >= 60 ? "Passed" : "Failed"),
                            feedback = dr["Feedback"] != DBNull.Value ? dr["Feedback"].ToString() : "",
                            file = dr["SubmissionFile"] != DBNull.Value ? dr["SubmissionFile"].ToString() : "#"
                        });
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(grades);
        }

        [WebMethod]
        public static bool UpdateStudentGrade(string studentUserId, string courseId, string assignmentId, int grade, string status, string feedback)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            // Log method entry and parameters
            System.IO.File.AppendAllText(HttpContext.Current.Server.MapPath("~/App_Data/GradeUpdateErrors.log"),
                DateTime.Now + $" - UpdateStudentGrade called: studentUserId={studentUserId}, courseId={courseId}, assignmentId={assignmentId}, grade={grade}, status={status}, feedback={feedback}\n");
            try
            {
                using (var conn = new SqlConnection(connStr))
                {
                    int gradedBy = Convert.ToInt32(System.Web.HttpContext.Current.Session["UserID"]);
                    conn.Open();
                    // Try update first
                    var updateCmd = new SqlCommand(@"
                        UPDATE AssignmentSubmissions
                        SET Score = @Score, Status = @Status, Feedback = @Feedback, GradedAt = @GradedAt, GradedBy = @GradedBy
                        WHERE StudentID = @StudentUserID AND AssignmentID = @AssignmentID
                    ", conn);
                    updateCmd.Parameters.AddWithValue("@Score", grade);
                    updateCmd.Parameters.AddWithValue("@Status", status);
                    updateCmd.Parameters.AddWithValue("@Feedback", feedback ?? "");
                    updateCmd.Parameters.AddWithValue("@GradedAt", DateTime.Now);
                    updateCmd.Parameters.AddWithValue("@GradedBy", gradedBy);
                    updateCmd.Parameters.AddWithValue("@StudentUserID", Convert.ToInt32(studentUserId));
                    updateCmd.Parameters.AddWithValue("@AssignmentID", Convert.ToInt32(assignmentId));
                    int rows = updateCmd.ExecuteNonQuery();
                    if (rows > 0)
                        return true;

                    // If no row updated, insert new
                    var insertCmd = new SqlCommand(@"
                        INSERT INTO AssignmentSubmissions (StudentID, AssignmentID, Score, Status, Feedback, GradedAt, GradedBy)
                        VALUES (@StudentUserID, @AssignmentID, @Score, @Status, @Feedback, @GradedAt, @GradedBy)
                    ", conn);
                    insertCmd.Parameters.AddWithValue("@StudentUserID", studentUserId);
                    insertCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    insertCmd.Parameters.AddWithValue("@Score", grade);
                    insertCmd.Parameters.AddWithValue("@Status", status);
                    insertCmd.Parameters.AddWithValue("@Feedback", feedback ?? "");
                    insertCmd.Parameters.AddWithValue("@GradedAt", DateTime.Now);
                    insertCmd.Parameters.AddWithValue("@GradedBy", gradedBy);
                    int insertRows = insertCmd.ExecuteNonQuery();
                    return insertRows > 0;
                }
            }
            catch (Exception ex)
            {
                // Log error to file or event log as needed
                System.IO.File.AppendAllText(HttpContext.Current.Server.MapPath("~/App_Data/GradeUpdateErrors.log"),
                    DateTime.Now + " - Error: " + ex.ToString() + "\n");
                return false;
            }
        }
    }
}