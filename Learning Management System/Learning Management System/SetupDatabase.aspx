<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html>
<html>
<head>
    <title>Database Setup - Learning Management System</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            padding: 20px; 
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .success { 
            color: #28a745; 
            background: #d4edda;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .error { 
            color: #dc3545; 
            background: #f8d7da;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .info { 
            color: #17a2b8; 
            background: #d1ecf1;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .warning {
            color: #856404;
            background: #fff3cd;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .btn {
            background: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 5px;
            text-decoration: none;
            display: inline-block;
        }
        .btn:hover {
            background: #0056b3;
        }
        .btn-success {
            background: #28a745;
        }
        .btn-success:hover {
            background: #1e7e34;
        }
        .sql-output {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            font-family: 'Courier New', monospace;
            white-space: pre-line;
            max-height: 400px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Learning Management System - Database Setup</h1>
        
        <%
            string action = Request.QueryString["action"];
            bool setupComplete = false;
            
            if (action == "setup")
            {
                try
                {
                    // First, try to connect to master database to create LMS database
                    string masterConnectionString = "Data Source=N3THUNT3R-SOCIA;Initial Catalog=master;Integrated Security=True";
                    string lmsConnectionString = ConfigurationManager.ConnectionStrings["LMSConnection"]?.ConnectionString 
                        ?? "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";
                    
                    Response.Write("<div class='info'><strong>Starting Database Setup...</strong></div>");
                    
                    // Read the SQL script
                    string sqlScriptPath = Server.MapPath("~/CreateDatabase.sql");
                    if (!File.Exists(sqlScriptPath))
                    {
                        Response.Write("<div class='error'>❌ CreateDatabase.sql file not found!</div>");
                        return;
                    }
                    
                    string sqlScript = File.ReadAllText(sqlScriptPath);
                    
                    using (SqlConnection conn = new SqlConnection(masterConnectionString))
                    {
                        conn.Open();
                        Response.Write("<div class='success'>✅ Connected to SQL Server</div>");
                        
                        // Split script by GO statements and execute each batch
                        string[] batches = sqlScript.Split(new string[] { "\r\nGO\r\n", "\nGO\n", "\r\nGO", "\nGO" }, 
                            StringSplitOptions.RemoveEmptyEntries);
                        
                        Response.Write("<div class='info'>Executing " + batches.Length + " SQL batches...</div>");
                        Response.Write("<div class='sql-output'>");
                        
                        foreach (string batch in batches)
                        {
                            if (!string.IsNullOrWhiteSpace(batch))
                            {
                                try
                                {
                                    using (SqlCommand cmd = new SqlCommand(batch.Trim(), conn))
                                    {
                                        cmd.CommandTimeout = 60;
                                        var result = cmd.ExecuteScalar();
                                        if (result != null)
                                        {
                                            Response.Write("✅ Batch executed successfully\n");
                                        }
                                    }
                                }
                                catch (Exception batchEx)
                                {
                                    Response.Write("⚠️ Batch warning: " + batchEx.Message + "\n");
                                }
                            }
                        }
                        
                        Response.Write("</div>");
                        conn.Close();
                    }
                    
                    // Now test the LMS database connection
                    Response.Write("<div class='info'>Testing LMS database connection...</div>");
                    
                    using (SqlConnection lmsConn = new SqlConnection(lmsConnectionString))
                    {
                        lmsConn.Open();
                        Response.Write("<div class='success'>✅ LMS Database connection successful!</div>");
                        
                        // Check tables
                        string[] requiredTables = { "Users", "Admins", "Courses", "Enrollments", "Assignments", "LoginActivity" };
                        
                        foreach (string tableName in requiredTables)
                        {
                            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @tableName", lmsConn))
                            {
                                cmd.Parameters.AddWithValue("@tableName", tableName);
                                int tableExists = (int)cmd.ExecuteScalar();
                                
                                if (tableExists > 0)
                                {
                                    // Count records
                                    using (SqlCommand countCmd = new SqlCommand($"SELECT COUNT(*) FROM [{tableName}]", lmsConn))
                                    {
                                        int recordCount = (int)countCmd.ExecuteScalar();
                                        Response.Write($"<div class='success'>✅ {tableName} table: {recordCount} records</div>");
                                    }
                                }
                                else
                                {
                                    Response.Write($"<div class='error'>❌ {tableName} table not found</div>");
                                }
                            }
                        }
                        
                        lmsConn.Close();
                    }
                    
                    setupComplete = true;
                    Response.Write("<div class='success'><strong>🎉 Database setup completed successfully!</strong></div>");
                    
                }
                catch (Exception ex)
                {
                    Response.Write("<div class='error'>❌ Setup failed: " + ex.Message + "</div>");
                    Response.Write("<div class='info'>Stack Trace: " + ex.StackTrace + "</div>");
                }
            }
            else
            {
                // Just test the connection
                try
                {
                    string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"]?.ConnectionString 
                        ?? "Data Source=localhost;Initial Catalog=LearningManagementSystem;Integrated Security=True";
                    
                    Response.Write("<div class='info'><strong>Connection String:</strong> " + connectionString + "</div>");
                    
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        Response.Write("<div class='success'>✅ Database connection successful!</div>");
                        
                        // Check if database has tables
                        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES", conn))
                        {
                            int tableCount = (int)cmd.ExecuteScalar();
                            Response.Write("<div class='info'>Tables in database: " + tableCount + "</div>");
                            
                            if (tableCount == 0)
                            {
                                Response.Write("<div class='warning'>⚠️ Database exists but has no tables. Please run the setup.</div>");
                            }
                        }
                        
                        conn.Close();
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<div class='error'>❌ Database connection failed: " + ex.Message + "</div>");
                    
                    if (ex.Message.Contains("Cannot open database"))
                    {
                        Response.Write("<div class='info'>📝 The database 'LearningManagementSystem' may not exist. Please run the setup to create it.</div>");
                    }
                    else if (ex.Message.Contains("server was not found"))
                    {
                        Response.Write("<div class='info'>📝 SQL Server may not be running. Please start SQL Server service.</div>");
                    }
                }
            }
        %>
        
        <% if (!setupComplete) { %>
        <h3>Setup Options:</h3>
        <div>
            <a href="?action=setup" class="btn btn-success">🚀 Run Complete Database Setup</a>
            <a href="?" class="btn">🔄 Test Connection Again</a>
        </div>
        
        <div class="warning">
            <strong>⚠️ Important:</strong> Running the setup will create the database and tables. 
            If they already exist, it will add sample data only.
        </div>
        <% } else { %>
        <h3>✅ Setup Complete - Test Your Login:</h3>
        <div>
            <a href="Login.aspx" class="btn btn-success">🔑 Go to Login Page</a>
            <a href="TestDatabase.aspx" class="btn">🧪 Test Database Again</a>
        </div>
        
        <div class="info">
            <strong>Test Credentials:</strong><br/>
            • Admin: admin@lms.edu / admin123<br/>
            • Teacher: teacher@lms.edu / teacher123<br/>
            • Student: student@lms.edu / student123
        </div>
        <% } %>
        
        <h3>📋 Setup Instructions:</h3>
        <ol>
            <li><strong>SQL Server:</strong> Make sure SQL Server is installed and running</li>
            <li><strong>Connection:</strong> Verify the connection string in Web.config</li>
            <li><strong>Permissions:</strong> Ensure your Windows account has SQL Server permissions</li>
            <li><strong>Database:</strong> Click "Run Complete Database Setup" to create everything</li>
            <li><strong>Test:</strong> Use the provided test credentials to login</li>
        </ol>
        
        <div class="info">
            <strong>🔧 Troubleshooting:</strong><br/>
            • If connection fails, try running SQL Server Management Studio first<br/>
            • Make sure SQL Server service is running in Windows Services<br/>
            • Verify your Windows account has access to SQL Server<br/>
            • Check if Windows Authentication is enabled in SQL Server
        </div>
    </div>
</body>
</html>
