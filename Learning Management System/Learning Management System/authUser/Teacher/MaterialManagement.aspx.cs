using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.Services;


namespace Learning_Management_System.authUser.Teacher
{
    public partial class MaterialManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in and is a teacher
                if (Session["UserID"] == null && Session["admin"] == null)
                {
                    Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }
            }
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetSectionMaterials(int courseId, int sectionId)
        {
            var materials = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT CourseMaterialId, MaterialType, Title, Description, FileName, FilePath, FileSize, UploadedDate, Status, Tags
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
                                size = reader["FileSize"] != DBNull.Value ? FormatFileSize(Convert.ToInt64(reader["FileSize"])) : "",
                                uploaded = reader["UploadedDate"] != DBNull.Value ? Convert.ToDateTime(reader["UploadedDate"]).ToString("yyyy-MM-dd") : "",
                                status = reader["Status"].ToString(),
                                tags = reader["Tags"].ToString()
                            });
                        }
                    }
                }
            }
            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(materials);
        }

        // Helper for file size formatting (optional)
        private static string FormatFileSize(long bytes)
        {
            if (bytes >= 1024 * 1024 * 1024) return (bytes / (1024 * 1024 * 1024.0)).ToString("0.##") + " GB";
            if (bytes >= 1024 * 1024) return (bytes / (1024 * 1024.0)).ToString("0.##") + " MB";
            if (bytes >= 1024) return (bytes / 1024.0).ToString("0.##") + " KB";
            return bytes + " bytes";
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string GetSectionInfo(int sectionId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT SectionName, Description FROM CourseSections WHERE CourseSectionsId = @SectionId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@SectionId", sectionId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(new
                            {
                                name = reader["SectionName"].ToString(),
                                desc = reader["Description"].ToString()
                            });
                        }
                    }
                }
            }
            return "{}";
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string DeleteMaterial(int materialId)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "DELETE FROM CourseMaterials WHERE CourseMaterialId = @MaterialId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaterialId", materialId);
                        conn.Open();
                        int rows = cmd.ExecuteNonQuery();
                        return "{\"success\":" + (rows > 0 ? "true" : "false") + "}";
                    }
                }
            }
            catch (Exception ex)
            {
                return "{\"success\":false, \"error\":\"" + ex.Message.Replace("\"", "'") + "\"}";
            }
        }



        [WebMethod]
        public static object UpdateMaterial(int materialId, string title, string type, string description,
    string status, string tags, string fileName, string filePath, long fileSize)
        {
            try
            {
                // Get the current user ID from session
                string userId = HttpContext.Current.Session["UserID"]?.ToString();
                if (string.IsNullOrEmpty(userId))
                {
                    return new { success = false, error = "User not authenticated" };
                }

                // Create SQL connection and update material
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"UPDATE CourseMaterials 
                SET Title = @Title, 
                    MaterialType = @MaterialType, 
                    Description = @Description, 
                    Status = @Status, 
                    Tags = @Tags";

                    // Only update file info if a new file was uploaded
                    if (!string.IsNullOrEmpty(fileName) && !string.IsNullOrEmpty(filePath))
                    {
                        query += @", FileName = @FileName, 
                         FilePath = @FilePath, 
                         FileSize = @FileSize";
                    }

                    query += " WHERE CourseMaterialId = @MaterialId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaterialId", materialId);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@MaterialType", type);
                        cmd.Parameters.AddWithValue("@Description", description ?? "");
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@Tags", tags ?? "");

                        if (!string.IsNullOrEmpty(fileName) && !string.IsNullOrEmpty(filePath))
                        {
                            cmd.Parameters.AddWithValue("@FileName", fileName);
                            cmd.Parameters.AddWithValue("@FilePath", filePath);
                            cmd.Parameters.AddWithValue("@FileSize", fileSize);
                        }

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return new { success = true };
                        }
                        else
                        {
                            return new { success = false, error = "Material not found or no changes made" };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception details
                System.Diagnostics.Debug.WriteLine("UpdateMaterial error: " + ex.ToString());
                return new { success = false, error = "An error occurred: " + ex.Message };
            }
        }

        [System.Web.Services.WebMethod(EnableSession = true)]
        public static string SaveMaterial(int courseId, int sectionId, string title, string type, string description, string status, string tags, string fileName, string filePath, long fileSize)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"INSERT INTO CourseMaterials (CourseId, SectionId, MaterialType, Title, Description, FileName, FilePath, FileSize, Status, Tags, UploadedDate, UploadedBy, IsActive)
                           VALUES (@CourseId, @SectionId, @MaterialType, @Title, @Description, @FileName, @FilePath, @FileSize, @Status, @Tags, GETDATE(), @UploadedBy, 1)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseId);
                        cmd.Parameters.AddWithValue("@SectionId", sectionId);
                        cmd.Parameters.AddWithValue("@MaterialType", type);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Description", description ?? "");
                        cmd.Parameters.AddWithValue("@FileName", fileName);
                        cmd.Parameters.AddWithValue("@FilePath", filePath);
                        cmd.Parameters.AddWithValue("@FileSize", fileSize);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@Tags", tags ?? "");
                        cmd.Parameters.AddWithValue("@UploadedBy", HttpContext.Current.Session["UserID"] ?? "system");
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        return "{\"success\":true}";
                    }
                }
            }
            catch (Exception ex)
            {
                return "{\"success\":false, \"error\":\"" + ex.Message.Replace("\"", "'") + "\"}";
            }
        }

    }
}