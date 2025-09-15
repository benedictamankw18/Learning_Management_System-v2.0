<%@ WebHandler Language="C#" Class="Learning_Management_System.authUser.Teacher.FileUpdateHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.SessionState;
using System.IO;

namespace Learning_Management_System.authUser.Teacher
{
    /// <summary>
    /// Handler for updating files with new uploads in the Learning Management System
    /// </summary>
    public class FileUpdateHandler : IHttpHandler, IRequiresSessionState
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
                if (!Directory.Exists(uploadPath))
                    Directory.CreateDirectory(uploadPath);

                // Always create a new file with unique name for updates (to avoid caching issues)
                string fileName = Guid.NewGuid().ToString() + "_" + 
                    Path.GetFileName(file.FileName).Replace(" ", "_");
                string filePath = Path.Combine(uploadPath, fileName);
                file.SaveAs(filePath);

                // We don't insert to database here - we just return the file info
                // The client will handle the database update separately
                context.Response.Write("{\"success\":true," + 
                    "\"fileName\":\"" + HttpUtility.JavaScriptStringEncode(fileName) + "\"," + 
                    "\"filePath\":\"" + HttpUtility.JavaScriptStringEncode(uploadDir + fileName) + "\"," + 
                    "\"fileSize\":" + file.ContentLength + "}");
            }
            catch (Exception ex)
            {
                // Log the exception somewhere
                System.Diagnostics.Debug.WriteLine("File update error: " + ex.ToString());
                
                context.Response.StatusCode = 500;
                context.Response.Write("{\"success\":false,\"error\":\"An error occurred while processing your request\"}");
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}