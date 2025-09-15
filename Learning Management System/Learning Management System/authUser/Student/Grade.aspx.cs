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

namespace Learning_Management_System.authUser.Student
{
    public partial class Grade : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod(EnableSession = true)]
        public static string GetStudentGrades()
        {
            var userId = System.Web.HttpContext.Current.Session["UserID"];
            var connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;

            var summary = new { courses = 0, assignments = 0, avgGrade = 0, completion = 0 };
            var grades = new List<object>();

            int totalCourses = 0, totalAssignments = 0, totalCompleted = 0, totalGrade = 0, gradeCount = 0;

            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Get all courses for the student
                var cmd = new SqlCommand(@"
                    SELECT c.CourseID, c.CourseName, u.FullName AS Instructor
                    FROM UserCourses uc
                    INNER JOIN Courses c ON uc.CourseID = c.CourseID
                    INNER JOIN Users u ON c.UserID = u.UserID
                    WHERE uc.UserID = @UserID", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                var courses = new List<dynamic>();
                using (var dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        courses.Add(new
                        {
                            CourseID = dr["CourseID"].ToString(),
                            CourseName = dr["CourseName"].ToString(),
                            Instructor = dr["Instructor"].ToString()
                        });
                    }
                }
                totalCourses = courses.Count;

                // For each course, get assignments and grades
                foreach (var course in courses)
                {
                    var cmd2 = new SqlCommand(@"
                        SELECT a.AssignmentID, a.Title, s.Score, s.Status
                        FROM Assignments a
                        LEFT JOIN AssignmentSubmissions s ON s.AssignmentID = a.AssignmentID AND s.StudentID = @UserID
                        WHERE a.CourseID = @CourseID", conn);
                    cmd2.Parameters.AddWithValue("@UserID", userId);
                    cmd2.Parameters.AddWithValue("@CourseID", course.CourseID);

                    int courseAssignments = 0, courseGradeSum = 0, courseGradeCount = 0, courseCompleted = 0;
                    string courseStatus = "In Progress";
                    int courseAvg = 0;

                    using (var dr2 = cmd2.ExecuteReader())
                    {
                        while (dr2.Read())
                        {
                            courseAssignments++;
                            totalAssignments++;
                            int score = dr2["Score"] != DBNull.Value ? Convert.ToInt32(dr2["Score"]) : 0;
                            string status = dr2["Status"] != DBNull.Value ? dr2["Status"].ToString() : "Not Submitted";
                            if (score > 0)
                            {
                                courseGradeSum += score;
                                courseGradeCount++;
                                totalGrade += score;
                                gradeCount++;
                            }
                            if (status == "Passed")
                                courseCompleted++;

                        }
                    }
                    if (courseGradeCount > 0)
                        courseAvg = courseGradeSum / courseGradeCount;
                    if (courseAssignments > 0 && courseCompleted == courseAssignments)
                        courseStatus = "Passed";
                    else if (courseAssignments > 0 && courseCompleted < courseAssignments && courseCompleted > 0)
                        courseStatus = "In Progress";
                    else if (courseAssignments > 0 && courseCompleted == 0)
                        courseStatus = "At Risk";

                    grades.Add(new
                    {
                        course = course.CourseName,
                        instructor = course.Instructor,
                        assignments = courseAssignments,
                        grade = courseAvg,
                        status = courseStatus
                    });

                    if (courseStatus == "Passed") totalCompleted++;
                }
            }

            int avgGrade = gradeCount > 0 ? totalGrade / gradeCount : 0;
            int completion = totalCourses > 0 ? (int)Math.Round((double)totalCompleted / totalCourses * 100) : 0;

            summary = new
            {
                courses = totalCourses,
                assignments = totalAssignments,
                avgGrade = avgGrade,
                completion = completion
            };

            return new JavaScriptSerializer().Serialize(new { summary, grades });
        }
    }
}