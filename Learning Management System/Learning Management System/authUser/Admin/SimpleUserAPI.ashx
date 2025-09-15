<%@ WebHandler Language="C#" Class="SimpleUserAPI" %>

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Configuration;
using System.Text;

public class SimpleUserAPI : IHttpHandler {
    
    private static string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null ? 
        ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString : 
        "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";
        
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "application/json";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
        
        try {
            // Get action parameter (required)
            string action = context.Request.QueryString["action"];
            if (action == null) action = string.Empty;
            
            if (string.IsNullOrEmpty(action)) {
                SendErrorResponse(context, "Missing required parameter: action");
                return;
            }
            
            // Get optional parameters
            string userType = context.Request.QueryString["type"];
            if (userType == null) userType = string.Empty;
            
            string fields = context.Request.QueryString["fields"];
            if (fields == null) fields = string.Empty;
            
            string format = context.Request.QueryString["format"];
            if (format == null) format = "json";
            else format = format.ToLower();
            
            // Handle the action
            if (action == "all") {
                GetAllUsers(context, userType, fields, format);
            }
            else if (action == "byid") {
                string idParam = context.Request.QueryString["id"];
                int userId;
                if (string.IsNullOrEmpty(idParam) || !int.TryParse(idParam, out userId)) {
                    SendErrorResponse(context, "Missing or invalid parameter: id");
                    return;
                }
                GetUserById(context, userId, fields, format);
            }
            else if (action == "search") {
                string searchTerm = context.Request.QueryString["q"];
                if (string.IsNullOrEmpty(searchTerm)) {
                    SendErrorResponse(context, "Missing required parameter: q");
                    return;
                }
                SearchUsers(context, searchTerm, userType, fields, format);
            }
            else {
                SendErrorResponse(context, "Invalid action. Supported actions: all, byid, search");
            }
        }
        catch (Exception ex) {
            SendErrorResponse(context, "Error processing request: " + ex.Message);
        }
    }
    
    private void GetAllUsers(HttpContext context, string userType, string fields, string format) {
        List<Dictionary<string, object>> users = new List<Dictionary<string, object>>();
        
        using (SqlConnection conn = new SqlConnection(connectionString)) {
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
            
            using (SqlCommand cmd = new SqlCommand(query, conn)) {
                if (!string.IsNullOrEmpty(userType)) {
                    cmd.Parameters.AddWithValue("@UserType", userType);
                }
                
                using (SqlDataReader reader = cmd.ExecuteReader()) {
                    while (reader.Read()) {
                        users.Add(ExtractUserData(reader, fields));
                    }
                }
            }
        }
        
        SendResponse(context, users, format);
    }
    
    private void GetUserById(HttpContext context, int userId, string fields, string format) {
        using (SqlConnection conn = new SqlConnection(connectionString)) {
            conn.Open();
            
            string query = @"
                SELECT 
                    u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                    u.Department, u.Level, u.Programme, 
                    u.ProfilePicture, 
                    u.EmployeeID, u.CreatedDate, u.IsActive
                FROM Users u
                WHERE u.UserID = @UserID";
            
            using (SqlCommand cmd = new SqlCommand(query, conn)) {
                cmd.Parameters.AddWithValue("@UserID", userId);
                
                using (SqlDataReader reader = cmd.ExecuteReader()) {
                    if (reader.Read()) {
                        Dictionary<string, object> user = ExtractUserData(reader, fields);
                        SendResponse(context, user, format);
                    }
                    else {
                        SendErrorResponse(context, "User not found", 404);
                    }
                }
            }
        }
    }
    
    private void SearchUsers(HttpContext context, string searchTerm, string userType, string fields, string format) {
        List<Dictionary<string, object>> users = new List<Dictionary<string, object>>();
        
        using (SqlConnection conn = new SqlConnection(connectionString)) {
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
            
            using (SqlCommand cmd = new SqlCommand(query, conn)) {
                cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                
                if (!string.IsNullOrEmpty(userType)) {
                    cmd.Parameters.AddWithValue("@UserType", userType);
                }
                
                using (SqlDataReader reader = cmd.ExecuteReader()) {
                    while (reader.Read()) {
                        users.Add(ExtractUserData(reader, fields));
                    }
                }
            }
        }
        
        SendResponse(context, users, format);
    }
    
    private Dictionary<string, object> ExtractUserData(SqlDataReader reader, string fields) {
        Dictionary<string, object> user = new Dictionary<string, object>();
        
        // Define all available fields
        Dictionary<string, Func<SqlDataReader, object>> allFields = new Dictionary<string, Func<SqlDataReader, object>>();
        
        allFields.Add("id", delegate(SqlDataReader r) { return Convert.ToInt32(r["UserID"]); });
        allFields.Add("userId", delegate(SqlDataReader r) { return Convert.ToInt32(r["UserID"]); });
        allFields.Add("fullName", delegate(SqlDataReader r) { return r["FullName"].ToString(); });
        allFields.Add("email", delegate(SqlDataReader r) { return r["Email"].ToString(); });
        allFields.Add("phone", delegate(SqlDataReader r) { return r["Phone"].ToString(); });
        allFields.Add("userType", delegate(SqlDataReader r) { return r["UserType"].ToString(); });
        allFields.Add("department", delegate(SqlDataReader r) { 
            return r["Department"] == DBNull.Value ? "" : r["Department"].ToString(); 
        });
        allFields.Add("level", delegate(SqlDataReader r) { 
            return r["Level"] == DBNull.Value ? "" : r["Level"].ToString(); 
        });
        allFields.Add("programme", delegate(SqlDataReader r) { 
            return r["Programme"] == DBNull.Value ? "" : r["Programme"].ToString(); 
        });
        allFields.Add("profilePic", delegate(SqlDataReader r) { 
            return r["ProfilePicture"] != DBNull.Value 
                ? "/authUser/Admin/ProfileImageHandler.ashx?UserID=" + Convert.ToInt32(r["UserID"]) + "&t=" + DateTime.Now.Ticks
                : "../../Assest/Images/user.png"; 
        });
        allFields.Add("employeeId", delegate(SqlDataReader r) { 
            return r["EmployeeID"] == DBNull.Value ? "" : r["EmployeeID"].ToString(); 
        });
        allFields.Add("createdDate", delegate(SqlDataReader r) { 
            return Convert.ToDateTime(r["CreatedDate"]).ToString("yyyy-MM-dd"); 
        });
        allFields.Add("isActive", delegate(SqlDataReader r) { 
            return Convert.ToBoolean(r["IsActive"]); 
        });
        
        // Determine which fields to include
        HashSet<string> requestedFields = new HashSet<string>();
        if (string.IsNullOrEmpty(fields)) {
            foreach (string key in allFields.Keys) {
                requestedFields.Add(key);
            }
        }
        else {
            string[] fieldArray = fields.Split(',');
            foreach (string field in fieldArray) {
                requestedFields.Add(field.Trim().ToLower());
            }
        }
        
        // Add requested fields to the result
        foreach (string field in requestedFields) {
            if (allFields.ContainsKey(field)) {
                user[field] = allFields[field](reader);
            }
        }
        
        // Always include ID even if not requested
        if (!user.ContainsKey("id") && !user.ContainsKey("userId")) {
            user["id"] = Convert.ToInt32(reader["UserID"]);
        }
        
        return user;
    }
    
    private void SendResponse(HttpContext context, object data, string format) {
        if (format == "xml") {
            SendXmlResponse(context, data);
        }
        else {
            SendJsonResponse(context, data);
        }
    }
    
    private void SendJsonResponse(HttpContext context, object data) {
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.MaxJsonLength = 50000000; // Set to 50MB
        
        context.Response.ContentType = "application/json";
        context.Response.Write(serializer.Serialize(new { success = true, data = data }));
    }
    
    private void SendXmlResponse(HttpContext context, object data) {
        context.Response.ContentType = "application/xml";
        
        StringBuilder xml = new StringBuilder();
        xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        xml.AppendLine("<response>");
        xml.AppendLine("  <success>true</success>");
        xml.AppendLine("  <data>");
        
        if (data is Dictionary<string, object>) {
            AppendXmlForObject(xml, (Dictionary<string, object>)data, "user");
        }
        else if (data is List<Dictionary<string, object>>) {
            xml.AppendLine("    <users>");
            foreach (Dictionary<string, object> item in (List<Dictionary<string, object>>)data) {
                AppendXmlForObject(xml, item, "user");
            }
            xml.AppendLine("    </users>");
        }
        
        xml.AppendLine("  </data>");
        xml.AppendLine("</response>");
        
        context.Response.Write(xml.ToString());
    }
    
    private void AppendXmlForObject(StringBuilder xml, Dictionary<string, object> obj, string elementName) {
        xml.AppendLine("      <" + elementName + ">");
        
        foreach (KeyValuePair<string, object> kvp in obj) {
            string value = HttpUtility.HtmlEncode(Convert.ToString(kvp.Value));
            xml.AppendLine("        <" + kvp.Key + ">" + value + "</" + kvp.Key + ">");
        }
        
        xml.AppendLine("      </" + elementName + ">");
    }
    
    private void SendErrorResponse(HttpContext context, string message, int statusCode = 400) {
        context.Response.StatusCode = statusCode;
        
        if (context.Response.ContentType.Contains("json")) {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            context.Response.Write(serializer.Serialize(new { success = false, message = message }));
        }
        else {
            StringBuilder xml = new StringBuilder();
            xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            xml.AppendLine("<response>");
            xml.AppendLine("  <success>false</success>");
            xml.AppendLine("  <message>" + HttpUtility.HtmlEncode(message) + "</message>");
            xml.AppendLine("</response>");
            
            context.Response.Write(xml.ToString());
        }
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
    
    private void GetUserById(HttpContext context, int userId, string fields, string format) {
        using (SqlConnection conn = new SqlConnection(connectionString)) {
            conn.Open();
            
            string query = @"
                SELECT 
                    u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                    u.Department, u.Level, u.Programme, 
                    u.ProfilePicture, 
                    u.EmployeeID, u.CreatedDate, u.IsActive
                FROM Users u
                WHERE u.UserID = @UserID";
            
            using (SqlCommand cmd = new SqlCommand(query, conn)) {
                cmd.Parameters.AddWithValue("@UserID", userId);
                
                using (SqlDataReader reader = cmd.ExecuteReader()) {
                    if (reader.Read()) {
                        Dictionary<string, object> user = ExtractUserData(reader, fields);
                        SendResponse(context, user, format);
                    }
                    else {
                        SendErrorResponse(context, "User not found", 404);
                    }
                }
            }
        }
    }
    
    private void SearchUsers(HttpContext context, string searchTerm, string userType, string fields, string format) {
        List<Dictionary<string, object>> users = new List<Dictionary<string, object>>();
        
        using (SqlConnection conn = new SqlConnection(connectionString)) {
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
            
            using (SqlCommand cmd = new SqlCommand(query, conn)) {
                cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                
                if (!string.IsNullOrEmpty(userType)) {
                    cmd.Parameters.AddWithValue("@UserType", userType);
                }
                
                using (SqlDataReader reader = cmd.ExecuteReader()) {
                    while (reader.Read()) {
                        users.Add(ExtractUserData(reader, fields));
                    }
                }
            }
        }
        
        SendResponse(context, users, format);
    }
    
    private Dictionary<string, object> ExtractUserData(SqlDataReader reader, string fields) {
        Dictionary<string, object> user = new Dictionary<string, object>();
        
        // Define all available fields
        Dictionary<string, Func<SqlDataReader, object>> allFields = new Dictionary<string, Func<SqlDataReader, object>> {
            { "id", r => Convert.ToInt32(r["UserID"]) },
            { "userId", r => Convert.ToInt32(r["UserID"]) },
            { "fullName", r => r["FullName"].ToString() },
            { "email", r => r["Email"].ToString() },
            { "phone", r => r["Phone"].ToString() },
            { "userType", r => r["UserType"].ToString() },
            { "department", r => r["Department"]?.ToString() ?? "" },
            { "level", r => r["Level"]?.ToString() ?? "" },
            { "programme", r => r["Programme"]?.ToString() ?? "" },
            { "profilePic", r => r["ProfilePicture"] != DBNull.Value 
                ? "/authUser/Admin/ProfileImageHandler.ashx?UserID=" + Convert.ToInt32(r["UserID"]) + "&t=" + DateTime.Now.Ticks
                : "../../Assest/Images/user.png" },
            { "employeeId", r => r["EmployeeID"]?.ToString() ?? "" },
            { "createdDate", r => Convert.ToDateTime(r["CreatedDate"]).ToString("yyyy-MM-dd") },
            { "isActive", r => Convert.ToBoolean(r["IsActive"]) }
        };
        
        // Determine which fields to include
        HashSet<string> requestedFields;
        if (string.IsNullOrEmpty(fields)) {
            requestedFields = allFields.Keys.ToHashSet();
        }
        else {
            requestedFields = new HashSet<string>(fields.Split(',').Select(f => f.Trim().ToLower()));
        }
        
        // Add requested fields to the result
        foreach (var field in requestedFields) {
            if (allFields.ContainsKey(field)) {
                user[field] = allFields[field](reader);
            }
        }
        
        // Always include ID even if not requested
        if (!user.ContainsKey("id") && !user.ContainsKey("userId")) {
            user["id"] = Convert.ToInt32(reader["UserID"]);
        }
        
        return user;
    }
    
    private void SendResponse(HttpContext context, object data, string format) {
        if (format == "xml") {
            SendXmlResponse(context, data);
        }
        else {
            SendJsonResponse(context, data);
        }
    }
    
    private void SendJsonResponse(HttpContext context, object data) {
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        serializer.MaxJsonLength = 50000000; // Set to 50MB
        
        context.Response.ContentType = "application/json";
        context.Response.Write(serializer.Serialize(new { success = true, data = data }));
    }
    
    private void SendXmlResponse(HttpContext context, object data) {
        context.Response.ContentType = "application/xml";
        
        StringBuilder xml = new StringBuilder();
        xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        xml.AppendLine("<response>");
        xml.AppendLine("  <success>true</success>");
        xml.AppendLine("  <data>");
        
        if (data is Dictionary<string, object>) {
            AppendXmlForObject(xml, data as Dictionary<string, object>, "user");
        }
        else if (data is List<Dictionary<string, object>>) {
            xml.AppendLine("    <users>");
            foreach (var item in data as List<Dictionary<string, object>>) {
                AppendXmlForObject(xml, item, "user");
            }
            xml.AppendLine("    </users>");
        }
        
        xml.AppendLine("  </data>");
        xml.AppendLine("</response>");
        
        context.Response.Write(xml.ToString());
    }
    
    private void AppendXmlForObject(StringBuilder xml, Dictionary<string, object> obj, string elementName) {
        xml.AppendLine($"      <{elementName}>");
        
        foreach (var kvp in obj) {
            string value = HttpUtility.HtmlEncode(Convert.ToString(kvp.Value));
            xml.AppendLine($"        <{kvp.Key}>{value}</{kvp.Key}>");
        }
        
        xml.AppendLine($"      </{elementName}>");
    }
    
    private void SendErrorResponse(HttpContext context, string message, int statusCode = 400) {
        context.Response.StatusCode = statusCode;
        
        if (context.Response.ContentType.Contains("json")) {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            context.Response.Write(serializer.Serialize(new { success = false, message = message }));
        }
        else {
            StringBuilder xml = new StringBuilder();
            xml.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            xml.AppendLine("<response>");
            xml.AppendLine("  <success>false</success>");
            xml.AppendLine($"  <message>{HttpUtility.HtmlEncode(message)}</message>");
            xml.AppendLine("</response>");
            
            context.Response.Write(xml.ToString());
        }
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
