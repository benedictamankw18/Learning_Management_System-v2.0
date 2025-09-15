using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Text;

namespace Learning_Management_System.Database_Scripts
{
    public partial class SetupClientErrorLogging : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if the user is authenticated as admin
                if (Session["Admin"] == null)
                {
                    Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }
                
                // Display the SQL script content
                string scriptPath = Server.MapPath("~/Database_Scripts/CreateClientErrorLogsTable.sql");
                if (File.Exists(scriptPath))
                {
                    litSqlOutput.Text = File.ReadAllText(scriptPath);
                }
                else
                {
                    litSqlOutput.Text = "SQL script file not found at: " + scriptPath;
                }
            }
        }

        protected void btnRunScript_Click(object sender, EventArgs e)
        {
            try
            {
                string scriptPath = Server.MapPath("~/Database_Scripts/CreateClientErrorLogsTable.sql");
                if (!File.Exists(scriptPath))
                {
                    litResult.Text = "<p class='error'>SQL script file not found at: " + scriptPath + "</p>";
                    return;
                }
                
                string sqlScript = File.ReadAllText(scriptPath);
                StringBuilder output = new StringBuilder();
                
                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    connection.Open();
                    
                    // Split the script by GO statements if they exist
                    string[] batches = sqlScript.Split(new[] { "GO", "go" }, StringSplitOptions.RemoveEmptyEntries);
                    
                    foreach (string batch in batches)
                    {
                        if (!string.IsNullOrWhiteSpace(batch))
                        {
                            using (SqlCommand command = new SqlCommand(batch, connection))
                            {
                                try
                                {
                                    command.ExecuteNonQuery();
                                    output.AppendLine("Batch executed successfully.");
                                }
                                catch (Exception ex)
                                {
                                    output.AppendLine("Error executing batch: " + ex.Message);
                                }
                            }
                        }
                    }
                    
                    // Now verify if the table exists
                    using (SqlCommand checkCommand = new SqlCommand(
                        "SELECT CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'ClientErrorLogs') THEN 1 ELSE 0 END", 
                        connection))
                    {
                        int exists = (int)checkCommand.ExecuteScalar();
                        if (exists == 1)
                        {
                            litResult.Text = "<p class='success'>Client error logging system has been successfully set up!</p>";
                        }
                        else
                        {
                            litResult.Text = "<p class='error'>Failed to set up client error logging system.</p>";
                        }
                    }
                }
                
                litSqlOutput.Text = output.ToString();
            }
            catch (Exception ex)
            {
                litResult.Text = "<p class='error'>Error: " + ex.Message + "</p>";
            }
        }

        protected void btnBackToAdmin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/authUser/Admin/Dashboard.aspx");
        }
    }
}
