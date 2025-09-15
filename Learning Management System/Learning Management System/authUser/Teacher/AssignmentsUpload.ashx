<%@ WebHandler Language="C#" Class="AssignmentsUpload" %>

using System;
using System.Web;

public class AssignmentsUpload : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        try
        {
            if (context.Request.Files.Count == 0)
            {
                context.Response.Write("{\"success\":false,\"message\":\"No file uploaded.\"}");
                return;
            }

            var file = context.Request.Files[0];
            if (file.ContentLength > 10 * 1024 * 1024)
            {
                context.Response.Write("{\"success\":false,\"message\":\"File too large.\"}");
                return;
            }
            if (!file.FileName.EndsWith(".pdf", StringComparison.OrdinalIgnoreCase))
            {
                context.Response.Write("{\"success\":false,\"message\":\"Only PDF files allowed.\"}");
                return;
            }

            string saveDir = "~/Uploads/Assignments/";
            string savePath = context.Server.MapPath(saveDir);
            if (!System.IO.Directory.Exists(savePath))
                System.IO.Directory.CreateDirectory(savePath);

            string fileName = Guid.NewGuid().ToString("N") + ".pdf";
            string fullPath = System.IO.Path.Combine(savePath, fileName);
            file.SaveAs(fullPath);

            // You can save the file path to DB here if needed

            context.Response.Write("{\"success\":true,\"filePath\":\"" + (saveDir + fileName) + "\"}");
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false,\"message\":\"" + ex.Message.Replace("\"", "'") + "\"}");
        }
    }

    public bool IsReusable { get { return false; } }
}