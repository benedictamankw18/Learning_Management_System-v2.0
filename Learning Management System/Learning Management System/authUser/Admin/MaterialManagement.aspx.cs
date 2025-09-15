using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.IO.Compression;


namespace Learning_Management_System.authUser.Admin
{
    public partial class MaterialManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object UploadMaterial(int sectionId, int courseId, string title, string materialType, string description, string status, string fileName, string filePath, int fileSize)
{
    try
    {
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = @"INSERT INTO CourseMaterials
    (CourseId, SectionId, MaterialType, Title, Description, FileName, FilePath, FileSize, Status, UploadedDate, IsActive)
    VALUES
    (@CourseId, @SectionId, @MaterialType, @Title, @Description, @FileName, @FilePath, @FileSize, @Status, GETDATE(), 1)";
using (SqlCommand cmd = new SqlCommand(query, conn))
{
    cmd.Parameters.AddWithValue("@CourseId", courseId);
    cmd.Parameters.AddWithValue("@SectionId", sectionId);
    cmd.Parameters.AddWithValue("@MaterialType", materialType);
    cmd.Parameters.AddWithValue("@Title", title);
    cmd.Parameters.AddWithValue("@Description", description ?? "");
    cmd.Parameters.AddWithValue("@FileName", fileName);
    cmd.Parameters.AddWithValue("@FilePath", filePath);
    cmd.Parameters.AddWithValue("@FileSize", fileSize);
    cmd.Parameters.AddWithValue("@Status",  status);

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

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetSectionMaterials(int sectionId)
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
                var materials = new List<object>();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"SELECT [CourseMaterialId], [Title], [MaterialType], [FileSize], [UploadedDate], [IsActive], [Status], [Description]
                 FROM [CourseMaterials]
                 WHERE [SectionId] = @SectionId
                 ORDER BY [OrderIndex], [UploadedDate] DESC";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SectionId", sectionId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                materials.Add(new
{
    id = (int)reader["CourseMaterialId"],
    title = reader["Title"]?.ToString(),
    type = reader["MaterialType"]?.ToString(),
    size = reader["FileSize"]?.ToString(),
    uploaded = reader["UploadedDate"] != DBNull.Value ? ((DateTime)reader["UploadedDate"]).ToString("yyyy-MM-dd") : "",
    status = reader["Status"]?.ToString(),
    isActive = reader["IsActive"] != DBNull.Value && (bool)reader["IsActive"],
    description = reader["Description"]?.ToString()
});
                            }
                        }
                    }
                }

                return new { success = true, data = materials };
            }
            catch (Exception ex)
            {
                return new { success = false, message = ex.Message };
            }
        }
    }
}