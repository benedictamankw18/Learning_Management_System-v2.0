<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h2>Learning Management System - Database Connection Test</h2>
    
    <%
        try
        {
            string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"]?.ConnectionString 
                ?? "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";
            
            Response.Write("<p class='info'>Connection String: " + connectionString + "</p>");
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                Response.Write("<p class='success'>✓ Database connection successful!</p>");
                
                // Test if Users table exists
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users'", conn))
                {
                    int tableExists = (int)cmd.ExecuteScalar();
                    if (tableExists > 0)
                    {
                        Response.Write("<p class='success'>✓ Users table exists</p>");
                        
                        // Count users
                        using (SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                        {
                            int userCount = (int)countCmd.ExecuteScalar();
                            Response.Write("<p class='info'>Users in database: " + userCount + "</p>");
                        }
                    }
                    else
                    {
                        Response.Write("<p class='error'>✗ Users table does not exist. Please run the CreateTables.sql script.</p>");
                    }
                }
                
                // Test if Courses table exists
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses'", conn))
                {
                    int tableExists = (int)cmd.ExecuteScalar();
                    if (tableExists > 0)
                    {
                        Response.Write("<p class='success'>✓ Courses table exists</p>");
                        
                        // Count courses
                        using (SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) FROM Courses", conn))
                        {
                            int courseCount = (int)countCmd.ExecuteScalar();
                            Response.Write("<p class='info'>Courses in database: " + courseCount + "</p>");
                        }
                    }
                    else
                    {
                        Response.Write("<p class='error'>✗ Courses table does not exist. Please run the CreateTables.sql script.</p>");
                    }
                }
                
                conn.Close();
            }
        }
        catch (Exception ex)
        {
            Response.Write("<p class='error'>✗ Database connection failed: " + ex.Message + "</p>");
            Response.Write("<p class='info'>Make sure SQL Server is running and the database exists.</p>");
        }
    %>
    
    <h3>Setup Instructions:</h3>
    <ol>
        <li>Make sure SQL Server is installed and running</li>
        <li>Run the <strong>CreateTables.sql</strong> script in SQL Server Management Studio</li>
        <li>Update the connection string in Web.config if needed</li>
        <li>Refresh this page to test the connection</li>
    </ol>
    
    <p><a href="authUser/Admin/User.aspx">Go to User Management Page</a></p>
</body>
</html>
