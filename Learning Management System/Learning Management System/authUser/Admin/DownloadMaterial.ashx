<%@ WebHandler Language="C#" Class="DownloadMaterial" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using Ionic.Zip;

public class DownloadMaterial : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        int materialId;
        if (!int.TryParse(context.Request.QueryString["materialId"], out materialId))
        {
            context.Response.StatusCode = 400;
            context.Response.Write("Invalid material ID.");
            return;
        }

        bool compressed = context.Request.QueryString["compressed"] == "true";

        string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
        string filePath = null;
        string fileName = null;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            string query = "SELECT FilePath, FileName FROM CourseMaterials WHERE CourseMaterialId = @MaterialId";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@MaterialId", materialId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        filePath = reader["FilePath"] != DBNull.Value ? reader["FilePath"].ToString() : null;
                        fileName = reader["FileName"] != DBNull.Value ? reader["FileName"].ToString() : null;
                    }
                }
            }
        }

        if (string.IsNullOrEmpty(filePath))
        {
            context.Response.StatusCode = 404;
            context.Response.Write("File not found.");
            return;
        }

        string physicalPath = context.Server.MapPath("~" + filePath);
        if (!File.Exists(physicalPath))
        {
            context.Response.StatusCode = 404;
            context.Response.Write("File not found on server.");
            return;
        }

        context.Response.Clear();

       if (compressed)
{
    string zipFileName = (Path.GetFileNameWithoutExtension(fileName ?? physicalPath) ?? "material") + ".zip";
    context.Response.ContentType = "application/zip";
    context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + zipFileName + "\"");

    using (var zip = new ZipFile())
    {
        zip.AddFile(physicalPath, "");
        zip.Save(context.Response.OutputStream);
    }
    context.Response.End();
}
        else
        {
            // Serve original file
            context.Response.ContentType = MimeMapping.GetMimeMapping(fileName ?? physicalPath);
            context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + (fileName ?? Path.GetFileName(physicalPath)) + "\"");
            context.Response.TransmitFile(physicalPath);
            context.Response.End();
        }
    }

    public bool IsReusable { get { return false; } }
}