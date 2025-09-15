<%@ WebHandler Language="C#" Class="FileDownloadHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public class FileDownloadHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string materialIdStr = context.Request.QueryString["id"];
        int materialId;
        if (!int.TryParse(materialIdStr, out materialId))
        {
            context.Response.StatusCode = 400;
            context.Response.Write("Invalid material ID.");
            return;
        }

        string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
        string filePath = null;
        string fileName = null;

        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string sql = "SELECT FilePath, FileName FROM CourseMaterials WHERE CourseMaterialId = @MaterialId";
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@MaterialId", materialId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        filePath = reader["FilePath"].ToString();
                        fileName = reader["FileName"].ToString();
                    }
                }
            }
        }

        if (string.IsNullOrEmpty(filePath) || !File.Exists(context.Server.MapPath(filePath)))
        {
            context.Response.StatusCode = 404;
            context.Response.Write("File not found.");
            return;
        }

        context.Response.ContentType = MimeMapping.GetMimeMapping(fileName);
        context.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        context.Response.TransmitFile(context.Server.MapPath(filePath));
        context.Response.End();
    }

    public bool IsReusable { get { return false; } }
}