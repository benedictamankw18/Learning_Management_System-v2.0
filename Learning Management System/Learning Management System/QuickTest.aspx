<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quick Database Test</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
        pre { background: #f5f5f5; padding: 10px; border-radius: 5px; }
    </style>
</head>
<body>
    <h2>Database Connection Test</h2>
    
    <%
        try
        {
            string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"]?.ConnectionString;
            Response.Write("<p class='info'>Connection String: " + connectionString + "</p>");
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                Response.Write("<p class='success'>✅ Database connection successful!</p>");
                
                // Test Users table
                using (SqlCommand cmd = new SqlCommand("SELECT Email, Password, Role FROM Users", conn))
                {
                    Response.Write("<h3>Users in Database:</h3>");
                    Response.Write("<pre>");
                    
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Response.Write($"Email: {reader["Email"]}, Password: {reader["Password"]}, Role: {reader["Role"]}\n");
                        }
                    }
                    
                    Response.Write("</pre>");
                }
                
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Response.Write("<p class='error'>❌ Error: " + ex.Message + "</p>");
            Response.Write("<p>Stack Trace: " + ex.StackTrace + "</p>");
        }
    %>
    
    <h3>Test Login:</h3>
    <p>Try logging in with these credentials:</p>
    <ul>
        <li><strong>Admin:</strong> admin@lms.edu / admin123</li>
        <li><strong>Teacher:</strong> teacher@lms.edu / teacher123</li>
        <li><strong>Student:</strong> student@lms.edu / student123</li>
    </ul>
    
    <p><a href="Login.aspx">Go to Login Page</a></p>
</body>
</html>
