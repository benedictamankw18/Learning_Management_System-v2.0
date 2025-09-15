using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace Learning_Management_System.authUser.Teacher
{
    public partial class Materials : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetTeacherCourses()
        {
            var courses = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string teacherId = HttpContext.Current.Session["UserID"]?.ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
SELECT c.CourseID, c.CourseCode, c.CourseName, c.Description, c.IsActive,
    (SELECT COUNT(*) FROM CourseSections s WHERE s.CourseId = c.CourseID) AS Sections,
    (SELECT COUNT(*) FROM CourseMaterials m WHERE m.CourseId = c.CourseID) AS Materials,
    (SELECT COUNT(*) FROM UserCourses uc
        JOIN Users u ON u.UserId = uc.UserId
        WHERE uc.CourseID = c.CourseID AND u.UserType = 'Student') AS EnrolledStudents,
    (SELECT 
        CASE WHEN COUNT(*) = 0 THEN 0
             ELSE CAST(SUM(CASE WHEN uc.IsCompleted = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 END
     FROM UserCourses uc
     JOIN Users u ON u.UserId = uc.UserId
     WHERE uc.CourseID = c.CourseID AND u.UserType = 'Student') AS CompletionRate
FROM Courses c
WHERE c.UserID = @TeacherId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherId", teacherId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            courses.Add(new {
                                id = reader["CourseID"],
                                code = reader["CourseCode"].ToString(),
                                name = reader["CourseName"].ToString(),
                                description = reader["Description"].ToString(),
                                isActive = reader["IsActive"],
                                sections = reader["Sections"],
                                materials = reader["Materials"],
                                enrolledStudents = reader["EnrolledStudents"],
                                completionRate = reader["CompletionRate"]
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(courses);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetCourseSections(int courseId)
        {
            var sections = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT CourseSectionsId, SectionName, Description, OrderIndex, IsActive
            FROM CourseSections
            WHERE CourseId = @CourseId
            ORDER BY OrderIndex";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            sections.Add(new
                            {
                                id = reader["CourseSectionsId"],
                                name = reader["SectionName"].ToString(),
                                desc = reader["Description"].ToString(),
                                order = reader["OrderIndex"],
                                isActive = reader["IsActive"]
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(sections);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetCourseMaterials(int courseId, int sectionId)
        {
            var materials = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT CourseMaterialId, MaterialType, Title, Description, FileName, FilePath, FileSize, ExternalLink, OrderIndex, IsRequired, IsActive, UploadedDate, UploadedBy, Status, Tags
            FROM CourseMaterials
            WHERE CourseId = @CourseId AND SectionId = @SectionId
            ORDER BY OrderIndex";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@SectionId", sectionId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            materials.Add(new
                            {
                                id = reader["CourseMaterialId"],
                                type = reader["MaterialType"].ToString(),
                                title = reader["Title"].ToString(),
                                desc = reader["Description"].ToString(),
                                fileName = reader["FileName"].ToString(),
                                filePath = reader["FilePath"].ToString(),
                                fileSize = reader["FileSize"],
                                externalLink = reader["ExternalLink"].ToString(),
                                order = reader["OrderIndex"],
                                isRequired = reader["IsRequired"],
                                isActive = reader["IsActive"],
                                uploadedDate = reader["UploadedDate"],
                                uploadedBy = reader["UploadedBy"].ToString(),
                                status = reader["Status"].ToString(),
                                tags = reader["Tags"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(materials);
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string AddSection(int courseId, string name, string desc, int order)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"INSERT INTO CourseSections (CourseId, SectionName, Description, OrderIndex, IsActive, CreatedDate, CreatedBy)
                           VALUES (@CourseId, @SectionName, @Description, @OrderIndex, 1, GETDATE(), @CreatedBy);
                           SELECT SCOPE_IDENTITY();";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.Parameters.AddWithValue("@SectionName", name);
                        cmd.Parameters.AddWithValue("@Description", desc ?? "");
                        cmd.Parameters.AddWithValue("@OrderIndex", order);
                        cmd.Parameters.AddWithValue("@CreatedBy", HttpContext.Current.Session["UserID"] ?? "system");
                        conn.Open();
                        var newId = cmd.ExecuteScalar();
                        return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { success = true, id = newId });
                    }
                }
            }
            catch (Exception ex)
            {
                return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new { success = false, error = ex.Message });
            }
        }






    }
}