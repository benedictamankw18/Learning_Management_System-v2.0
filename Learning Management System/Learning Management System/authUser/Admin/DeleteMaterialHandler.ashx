<%@ WebHandler Language="C#" Class="DeleteMaterialHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;

public class DeleteMaterialHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        try
        {
            var materialIdStr = context.Request.Form["materialId"];
            if (string.IsNullOrEmpty(materialIdStr))
                throw new ArgumentException("materialId cannot be null or empty");
            var materialId = int.Parse(materialIdStr);

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "DELETE FROM CourseMaterials WHERE CourseMaterialId=@MaterialId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MaterialId", materialId);
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