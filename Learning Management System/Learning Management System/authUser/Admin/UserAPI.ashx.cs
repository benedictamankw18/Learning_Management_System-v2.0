using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Text;

namespace Learning_Management_System.authUser.Admin
{
    /// <summary>
    /// API Handler for User data including entity IDs
    /// Supports GET requests with the following parameters:
    /// - action: Required. Possible values: "all", "byid", "search"
    /// - id: Required for "byid" action. The UserID to retrieve
    /// - type: Optional. Filter by user type (admin, student, teacher)
    /// - q: Required for "search" action. The search term
    /// - fields: Optional. Comma-separated list of fields to include (default is all fields)
    /// - format: Optional. Response format (json or xml). Default is json.
    /// 
    /// Examples:
    /// - Get all users: UserAPI.ashx?action=all
    /// - Get specific user: UserAPI.ashx?action=byid&id=1008
    /// - Search users: UserAPI.ashx?action=search&q=john
    /// - Filter by type: UserAPI.ashx?action=all&type=student
    /// - Select specific fields: UserAPI.ashx?action=all&fields=id,fullName,email
    /// - XML output: UserAPI.ashx?action=all&format=xml
    /// </summary>
    public class UserAPI : IHttpHandler
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null
            ? ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString
            : "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";
            
        // Helper method to get profile image URL using the handler
        private static string GetProfileImageUrl(int userId, byte[] imageData)
        {
            // If we have image data, use the handler to serve it directly
            if (imageData != null && imageData.Length > 0)
            {
                // Using the full URL to the handler with a cache-busting timestamp
                string timestamp = DateTime.Now.Ticks.ToString();
                return $"/authUser/Admin/ProfileImageHandler.ashx?UserID={userId}&t={timestamp}";
            }
            
            // Otherwise use the default image
            return "../../Assest/Images/user.png";
        }

        public void ProcessRequest(HttpContext context)
        {
            // Set default content type and enable CORS
            context.Response.ContentType = "application/json";
            context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
            context.Response.Headers.Add("Access-Control-Allow-Methods", "GET");
            context.Response.Headers.Add("Access-Control-Allow-Headers", "Content-Type");

            try
            {
                // Get action parameter (required)
                string action = context.Request.QueryString["action"];
                if (string.IsNullOrEmpty(action))
                {
                    SendErrorResponse(context, "Missing required parameter: action");
                    return;
                }

                // Get optional parameters
                string userType = context.Request.QueryString["type"] ?? string.Empty;
                string fields = context.Request.QueryString["fields"] ?? string.Empty;
                string format = context.Request.QueryString["format"] != null ? context.Request.QueryString["format"].ToLower() : "json";

                // Validate format parameter
                if (format != "json" && format != "xml")
                {
                    SendErrorResponse(context, "Invalid format. Supported formats: json, xml");
                    return;
                }

                // Set the response content type based on format
                if (format == "xml")
                {
                    context.Response.ContentType = "application/xml";
                }

                // Process based on action
                switch (action.ToLower())
                {
                    case "all":
                        GetAllUsers(context, userType, fields, format);
                        break;

                    case "byid":
                        string idParam = context.Request.QueryString["id"];
                        if (string.IsNullOrEmpty(idParam) || !int.TryParse(idParam, out int userId))
                        {
                            SendErrorResponse(context, "Missing or invalid parameter: id");
                            return;
                        }
                        GetUserById(context, userId, fields, format);
                        break;

                    case "search":
                        string searchTerm = context.Request.QueryString["q"];
                        if (string.IsNullOrEmpty(searchTerm))
                        {
                            SendErrorResponse(context, "Missing required parameter: q");
                            return;
                        }
                        SearchUsers(context, searchTerm, userType, fields, format);
                        break;

                    default:
                        SendErrorResponse(context, "Invalid action. Supported actions: all, byid, search");
                        break;
                }
            }
            catch (Exception ex)
            {
                SendErrorResponse(context, "Error processing request: " + ex.Message);
            }
        }

        private void GetAllUsers(HttpContext context, string userType, string fields, string format)
        {
            List<Dictionary<string, object>> users = new List<Dictionary<string, object>>();
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                string query = @"
                    SELECT 
                        u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                        u.Department, u.Level, u.Programme, 
                        u.ProfilePicture, 
                        u.EmployeeID, u.CreatedDate, u.IsActive
                    FROM Users u
                    WHERE 1=1 " + 
                    (string.IsNullOrEmpty(userType) ? "" : "AND u.UserType = @UserType") + @"
                    ORDER BY u.FullName";
                
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrEmpty(userType))
                    {
                        cmd.Parameters.AddWithValue("@UserType", userType);
                    }
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            users.Add(ExtractUserData(reader, fields));
                        }
                    }
                }
            }
            
            SendResponse(context, users, format);
        }

        private void GetUserById(HttpContext context, int userId, string fields, string format)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                string query = @"
                    SELECT 
                        u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                        u.Department, u.Level, u.Programme, 
                        u.ProfilePicture, 
                        u.EmployeeID, u.CreatedDate, u.IsActive
                    FROM Users u
                    WHERE u.UserID = @UserID";
                
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Dictionary<string, object> user = ExtractUserData(reader, fields);
                            SendResponse(context, user, format);
                        }
                        else
                        {
                            SendErrorResponse(context, "User not found", 404);
                        }
                    }
                }
            }
        }

        private void SearchUsers(HttpContext context, string searchTerm, string userType, string fields, string format)
        {
            List<Dictionary<string, object>> users = new List<Dictionary<string, object>>();
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                string query = @"
                    SELECT 
                        u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                        u.Department, u.Level, u.Programme, 
                        u.ProfilePicture, 
                        u.EmployeeID, u.CreatedDate, u.IsActive
                    FROM Users u
                    WHERE (u.FullName LIKE @SearchTerm 
                         OR u.Email LIKE @SearchTerm 
                         OR u.Phone LIKE @SearchTerm
                         OR u.Department LIKE @SearchTerm
                         OR u.Programme LIKE @SearchTerm
                         OR u.EmployeeID LIKE @SearchTerm) " +
                    (string.IsNullOrEmpty(userType) ? "" : "AND u.UserType = @UserType") + @"
                    ORDER BY u.FullName";
                
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    
                    if (!string.IsNullOrEmpty(userType))
                    {
                        cmd.Parameters.AddWithValue("@UserType", userType);
                    }
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            users.Add(ExtractUserData(reader, fields));
                        }
                    }
                }
            }
            
            SendResponse(context, users, format);
        }

        private Dictionary<string, object> ExtractUserData(SqlDataReader reader, string fields)
        {
            Dictionary<string, object> user = new Dictionary<string, object>();
            
            // Define all available fields
            Dictionary<string, Func<SqlDataReader, object>> allFields = new Dictionary<string, Func<SqlDataReader, object>>
            {
                { "id", r => Convert.ToInt32(r["UserID"]) },
                { "userId", r => Convert.ToInt32(r["UserID"]) },
                { "fullName", r => r["FullName"].ToString() },
                { "email", r => r["Email"].ToString() },
                { "phone", r => r["Phone"].ToString() },
                { "userType", r => r["UserType"].ToString() },
                { "department", r => r["Department"] != DBNull.Value ? r["Department"].ToString() : "" },
                { "level", r => r["Level"] != DBNull.Value ? r["Level"].ToString() : "" },
                { "programme", r => r["Programme"] != DBNull.Value ? r["Programme"].ToString() : "" },
                { "profilePic", r => r["ProfilePicture"] != DBNull.Value 
                    ? GetProfileImageUrl(Convert.ToInt32(r["UserID"]), (byte[])r["ProfilePicture"]) 
                    : "../../Assest/Images/user.png" },
                { "employeeId", r => r["EmployeeID"] != DBNull.Value ? r["EmployeeID"].ToString() : "" },
                { "createdDate", r => Convert.ToDateTime(r["CreatedDate"]).ToString("yyyy-MM-dd") },
                { "isActive", r => Convert.ToBoolean(r["IsActive"]) }
            };
            
            // Determine which fields to include
            HashSet<string> requestedFields = new HashSet<string>();
            if (string.IsNullOrEmpty(fields))
            {
                // Add all fields if none specified
                foreach (var key in allFields.Keys)
                {
                    requestedFields.Add(key);
                }
            }
            else
            {
                // Add only requested fields
                foreach (var field in fields.Split(',').Select(f => f.Trim().ToLower()))
                {
                    requestedFields.Add(field);
                }
            }
            
            // Add requested fields to the result
            foreach (var field in requestedFields)
            {
                if (allFields.ContainsKey(field))
                {
                    user[field] = allFields[field](reader);
                }
            }
            
            // Always include ID even if not requested
            if (!user.ContainsKey("id") && !user.ContainsKey("userId"))
            {
                user["id"] = Convert.ToInt32(reader["UserID"]);
            }
            
            return user;
        }

        private void SendResponse(HttpContext context, object data, string format)
        {
            if (format == "xml")
            {
                SendXmlResponse(context, data);
            }
            else
            {
                SendJsonResponse(context, data);
            }
        }

        private void SendJsonResponse(HttpContext context, object data)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = 50000000; // Set to 50MB
            
            context.Response.ContentType = "application/json";
            context.Response.Write(serializer.Serialize(new { success = true, data = data }));
        }

        private void SendXmlResponse(HttpContext context, object data)
        {
            context.Response.ContentType = "application/xml";
            
            StringBuilder xml = new StringBuilder();
            xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            xml.AppendLine("<response>");
            xml.AppendLine("  <success>true</success>");
            xml.AppendLine("  <data>");
            
            if (data is Dictionary<string, object>)
            {
                AppendXmlForObject(xml, data as Dictionary<string, object>, "user");
            }
            else if (data is List<Dictionary<string, object>>)
            {
                xml.AppendLine("    <users>");
                foreach (var item in data as List<Dictionary<string, object>>)
                {
                    AppendXmlForObject(xml, item, "user");
                }
                xml.AppendLine("    </users>");
            }
            
            xml.AppendLine("  </data>");
            xml.AppendLine("</response>");
            
            context.Response.Write(xml.ToString());
        }

        private void AppendXmlForObject(StringBuilder xml, Dictionary<string, object> obj, string elementName)
        {
            xml.AppendLine($"      <{elementName}>");
            
            foreach (var kvp in obj)
            {
                string value = HttpUtility.HtmlEncode(Convert.ToString(kvp.Value));
                xml.AppendLine($"        <{kvp.Key}>{value}</{kvp.Key}>");
            }
            
            xml.AppendLine($"      </{elementName}>");
        }

        private void SendErrorResponse(HttpContext context, string message, int statusCode = 400)
        {
            context.Response.StatusCode = statusCode;
            
            if (context.Response.ContentType.Contains("json"))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                context.Response.Write(serializer.Serialize(new { success = false, message = message }));
            }
            else
            {
                StringBuilder xml = new StringBuilder();
                xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
                xml.AppendLine("<response>");
                xml.AppendLine("  <success>false</success>");
                xml.AppendLine($"  <message>{HttpUtility.HtmlEncode(message)}</message>");
                xml.AppendLine("</response>");
                
                context.Response.Write(xml.ToString());
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
