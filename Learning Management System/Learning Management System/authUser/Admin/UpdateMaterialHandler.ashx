<%@ WebHandler Language="C#" Class="UpdateMaterialHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public class UpdateMaterialHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        try
        {
            var materialId = int.Parse(context.Request.Form["materialId"]);
            var title = context.Request.Form["title"];
            var materialType = context.Request.Form["materialType"];
            var description = context.Request.Form["description"];
            var status = context.Request.Form["status"];
            var tags = context.Request.Form["tags"];
            var file = context.Request.Files["file"]; // May be null

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string updateQuery;
            string fileName = null;
            string filePath = null;
            int fileSize = 0;

            // If a new file is uploaded, save it and update file fields
            if (file != null && file.ContentLength > 0)
            {
                string uploadDir = "/Uploads/Materials/";
                string uploadPath = context.Server.MapPath("~" + uploadDir);
                if (!Directory.Exists(uploadPath))
                    Directory.CreateDirectory(uploadPath);

                fileName = Guid.NewGuid().ToString() + "_" + Path.GetFileName(file.FileName);
                filePath = uploadDir + fileName;
                fileSize = file.ContentLength;
                file.SaveAs(Path.Combine(uploadPath, fileName));

                updateQuery = @"UPDATE CourseMaterials
                                SET Title=@Title, MaterialType=@MaterialType, Description=@Description, Status=@Status, 
                                    FileName=@FileName, FilePath=@FilePath, FileSize=@FileSize, 
                                    UploadedDate=GETDATE()
                                WHERE CourseMaterialId=@MaterialId";
            }
            else
            {
                updateQuery = @"UPDATE CourseMaterials
                                SET Title=@Title, MaterialType=@MaterialType, Description=@Description, Status=@Status
                                WHERE CourseMaterialId=@MaterialId";
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@MaterialType", materialType);
                    cmd.Parameters.AddWithValue("@Description", description ?? "");
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@MaterialId", materialId);

                    if (file != null && file.ContentLength > 0)
                    {
                        cmd.Parameters.AddWithValue("@FileName", fileName);
                        cmd.Parameters.AddWithValue("@FilePath", filePath);
                        cmd.Parameters.AddWithValue("@FileSize", fileSize);
                    }

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