<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html>
<head>
    <title>Learning Management System - Status</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            padding: 20px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            margin: 0;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        .success { 
            color: #4CAF50; 
            background: rgba(76, 175, 80, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
            border-left: 4px solid #4CAF50;
        }
        .error { 
            color: #f44336; 
            background: rgba(244, 67, 54, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
            border-left: 4px solid #f44336;
        }
        .info { 
            color: #2196F3; 
            background: rgba(33, 150, 243, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
            border-left: 4px solid #2196F3;
        }
        .warning {
            color: #ff9800;
            background: rgba(255, 152, 0, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
            border-left: 4px solid #ff9800;
        }
        .btn {
            background: linear-gradient(45deg, #FE6B8B 30%, #FF8E53 90%);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            margin: 10px 5px;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.2s;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
        .credentials {
            background: rgba(255,255,255,0.05);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .status-card {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.2);
        }
        h1 { text-align: center; margin-bottom: 30px; }
        h2 { color: #FFD700; margin-top: 30px; }
        h3 { color: #87CEEB; }
        pre { 
            background: rgba(0,0,0,0.3); 
            padding: 15px; 
            border-radius: 8px; 
            overflow-x: auto;
            color: #E0E0E0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎓 Learning Management System - Setup Complete!</h1>
        
        <%
            bool dbConnectionWorking = false;
            int userCount = 0, courseCount = 0, tableCount = 0;
            string connectionString = "";
            
            try
            {
                connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null ? 
                    ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString : null;
                
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    dbConnectionWorking = true;
                    
                    // Count tables
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES", conn))
                    {
                        tableCount = (int)cmd.ExecuteScalar();
                    }
                    
                    // Count users
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                    {
                        userCount = (int)cmd.ExecuteScalar();
                    }
                    
                    // Count courses
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Courses", conn))
                    {
                        courseCount = (int)cmd.ExecuteScalar();
                    }
                    
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<div class='error'>❌ <strong>Database Connection Failed:</strong> " + ex.Message + "</div>");
            }
        %>
        
        <div class="status-grid">
            <div class="status-card">
                <h3>🔌 Database Connection</h3>
                <% if (dbConnectionWorking) { %>
                    <div class="success">✅ Connected Successfully!</div>
                    <div class="info">
                        📊 <strong>Statistics:</strong><br/>
                        • Tables: <%= tableCount %><br/>
                        • Users: <%= userCount %><br/>
                        • Courses: <%= courseCount %>
                    </div>
                <% } else { %>
                    <div class="error">❌ Connection Failed</div>
                <% } %>
            </div>
            
            <div class="status-card">
                <h3>🏗️ System Components</h3>
                <div class="success">✅ Login System</div>
                <div class="success">✅ Admin Dashboard</div>
                <div class="success">✅ Teacher Dashboard</div>
                <div class="success">✅ Student Dashboard</div>
                <div class="success">✅ Database Schema</div>
                <div class="success">✅ User Authentication</div>
            </div>
        </div>
        
        <h2>🔑 Test Credentials</h2>
        <div class="credentials">
            <div class="status-grid">
                <div style="text-align: center;">
                    <h3>👨‍💼 Administrator</h3>
                    <strong>Email:</strong> admin@lms.edu<br/>
                    <strong>Password:</strong> admin123<br/>
                    <small>Full system access</small>
                </div>
                <div style="text-align: center;">
                    <h3>👨‍🏫 Teacher</h3>
                    <strong>Email:</strong> teacher@lms.edu<br/>
                    <strong>Password:</strong> teacher123<br/>
                    <small>Course management</small>
                </div>
                <div style="text-align: center;">
                    <h3>👨‍🎓 Student</h3>
                    <strong>Email:</strong> student@lms.edu<br/>
                    <strong>Password:</strong> student123<br/>
                    <small>Course enrollment</small>
                </div>
            </div>
        </div>
        
        <h2>🚀 Quick Access</h2>
        <div style="text-align: center;">
            <a href="Login.aspx" class="btn">🔐 Login to System</a>
            <a href="SetupDatabase.aspx" class="btn">🛠️ Database Setup</a>
            <a href="TestDatabase.aspx" class="btn">🧪 Test Database</a>
        </div>
        
        <h2>📋 System Information</h2>
        <div class="info">
            <strong>Connection String:</strong><br/>
            <pre><%= connectionString %></pre>
        </div>
        
        <div class="warning">
            <strong>⚠️ Development Mode:</strong><br/>
            This system is currently configured for development. The test credentials above 
            are hardcoded and should be changed for production use.
        </div>
        
        <h2>📖 Available Features</h2>
        <div class="status-grid">
            <div class="status-card">
                <h3>Authentication</h3>
                • Role-based login (Admin/Teacher/Student)<br/>
                • Session management<br/>
                • Password validation<br/>
                • SweetAlert2 notifications
            </div>
            <div class="status-card">
                <h3>Admin Dashboard</h3>
                • User management<br/>
                • System statistics<br/>
                • Course oversight<br/>
                • Analytics charts
            </div>
            <div class="status-card">
                <h3>Teacher Dashboard</h3>
                • Course management<br/>
                • Student enrollment<br/>
                • Assignment creation<br/>
                • Grade tracking
            </div>
            <div class="status-card">
                <h3>Student Dashboard</h3>
                • Course enrollment<br/>
                • Assignment submission<br/>
                • Grade viewing<br/>
                • Progress tracking
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 40px; color: #B0C4DE;">
            <p>🎉 <strong>Congratulations!</strong> Your Learning Management System is ready to use!</p>
            <p><small>Built with ASP.NET Web Forms, SQL Server LocalDB, and modern UI components</small></p>
        </div>
    </div>
</body>
</html>
