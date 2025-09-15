<%@ WebHandler Language="C#" Class="FileUploadHandler" %>
using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.SessionState;

namespace Learning_Management_System.authUser.Teacher
{
    // Implement IRequiresSessionState to access session
    public class FileUploadHandler : IHttpHandler, IRequiresSessionState 
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            
            // Check authentication
            if (context.Session["UserID"] == null)
            {
                context.Response.StatusCode = 401;
                context.Response.Write("{\"success\":false,\"error\":\"User not authenticated\"}");
                return;
            }
            
            try
            {
                // Validate request method
                if (context.Request.HttpMethod != "POST")
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("{\"success\":false,\"error\":\"Invalid request method\"}");
                    return;
                }
                
                // Check for file
                if (context.Request.Files.Count == 0 || context.Request.Files["file"] == null)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("{\"success\":false,\"error\":\"No file uploaded\"}");
                    return;
                }

                var file = context.Request.Files["file"];
                var sectionId = int.Parse(context.Request.Form["sectionId"]);
                var courseId = int.Parse(context.Request.Form["courseId"]);
                var title = context.Request.Form["title"];
                var materialType = context.Request.Form["materialType"];
                var description = context.Request.Form["description"];
                var status = context.Request.Form["status"];
                
                // Validate file size (e.g., 50MB max)
                int maxSizeBytes = 52428800; // 50MB
                if (file.ContentLength > maxSizeBytes)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("{\"success\":false,\"error\":\"File exceeds maximum size of 50MB\"}");
                    return;
                }
                
                string uploadDir = "/Uploads/Materials/";
                string uploadPath = context.Server.MapPath("~" + uploadDir);
                if (!System.IO.Directory.Exists(uploadPath))
                    System.IO.Directory.CreateDirectory(uploadPath);

                string fileName = Guid.NewGuid().ToString() + "_" + 
                    System.IO.Path.GetFileName(file.FileName).Replace(" ", "_");
                string filePath = System.IO.Path.Combine(uploadPath, fileName);
                file.SaveAs(filePath);

                // Save info to DB
                string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = @"INSERT INTO CourseMaterials
    (CourseId, SectionId, MaterialType, Title, Description, FileName, FilePath, 
     FileSize, Status, UploadedDate, IsActive, UploadedBy, Tags, OrderIndex, IsRequired)
    VALUES
    (@CourseId, @SectionId, @MaterialType, @Title, @Description, @FileName, 
     @FilePath, @FileSize, @Status, GETDATE(), 1, @UploadedBy, @Tags, 
     (SELECT ISNULL(MAX(OrderIndex), 0) + 1 FROM CourseMaterials 
      WHERE CourseId = @CourseId AND SectionId = @SectionId), 0)";

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
                        cmd.Parameters.AddWithValue("@UploadedBy", context.Session["UserID"]);
                        cmd.Parameters.AddWithValue("@Tags", context.Request.Form["tags"] ?? "");
                        int rows = cmd.ExecuteNonQuery();
                        
                        // Return consistent JSON response
                        context.Response.Write("{\"success\":true," + 
                            "\"fileName\":\"" + HttpUtility.JavaScriptStringEncode(fileName) + "\"," + 
                            "\"filePath\":\"" + HttpUtility.JavaScriptStringEncode(uploadDir + fileName) + "\"," + 
                            "\"fileSize\":" + file.ContentLength + "}");
                    }
                }
            }
            catch (Exception ex) {
                // Log error details for debugging
                System.Diagnostics.Debug.WriteLine("Error in file upload: " + ex.ToString());
                context.Response.ContentType = "application/json";
                context.Response.StatusCode = 500;
                context.Response.Write("{\"success\":false,\"error\":\"" + 
                    HttpUtility.JavaScriptStringEncode(ex.Message) + "\"}");
            }
        }

        public bool IsReusable { get { return false; } }
    }
}