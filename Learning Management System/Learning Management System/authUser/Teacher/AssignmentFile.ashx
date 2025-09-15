<%@ WebHandler Language="C#" Class="AssignmentFile" %>

using System;
using System.Web;
using System.IO;

public class AssignmentFile : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string fileParam = context.Request.QueryString["file"];
        if (string.IsNullOrEmpty(fileParam))
        {
            context.Response.StatusCode = 400;
            context.Response.Write("Missing file parameter.");
            return;
        }

        // Prevent directory traversal
        fileParam = fileParam.Replace("..", "");
        string baseDir = context.Server.MapPath("~/Uploads/Assignments/");
        string filePath = Path.Combine(baseDir, Path.GetFileName(fileParam));

        if (!File.Exists(filePath))
        {
            context.Response.StatusCode = 404;
            context.Response.Write("File not found.");
            return;
        }

        context.Response.ContentType = "application/pdf";
        context.Response.AddHeader("Content-Disposition", $"inline; filename=\"{Path.GetFileName(filePath)}\"");
        context.Response.TransmitFile(filePath);
    }

    public bool IsReusable { get { return false; } }
}
