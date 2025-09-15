<%@ WebHandler Language="C#" Class="UploadMaterialHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;

public class UploadMaterialHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        try
        {
            var file = context.Request.Files["file"];
            var sectionId = int.Parse(context.Request.Form["sectionId"]);
            var courseId = int.Parse(context.Request.Form["courseId"]);
            var title = context.Request.Form["title"];
            var materialType = context.Request.Form["materialType"];
            var description = context.Request.Form["description"];
            var status = context.Request.Form["status"];

            // Save file to disk
            string uploadDir = "/Uploads/Materials/";
            string uploadPath = context.Server.MapPath("~" + uploadDir);
            if (!System.IO.Directory.Exists(uploadPath))
                System.IO.Directory.CreateDirectory(uploadPath);

            string fileName = Guid.NewGuid().ToString() + "_" + System.IO.Path.GetFileName(file.FileName);
            string filePath = uploadPath + fileName;
            file.SaveAs(filePath);

            // Save info to DB
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
                    cmd.Parameters.AddWithValue("@FilePath", uploadDir + fileName);
                    cmd.Parameters.AddWithValue("@FileSize", file.ContentLength);
                    cmd.Parameters.AddWithValue("@Status", status);

                    int rows = cmd.ExecuteNonQuery();
                    context.Response.Write("{\"success\":" + (rows > 0 ? "true" : "false") + "}");
                }
            }
        }
        catch (Exception ex)
{
    context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message.Replace("\"", "'") + "\"}");
}
    }
    public bool IsReusable { get { return false; } }
}