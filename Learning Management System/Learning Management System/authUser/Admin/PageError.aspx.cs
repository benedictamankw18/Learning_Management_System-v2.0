using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace Learning_Management_System.authUser.Admin
{
    public partial class PageError : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Log the error visit
                LogErrorPageVisit();
            }
        }

        private void LogErrorPageVisit()
        {
            try
            {
                string errorType = Request.QueryString["error"] ?? "unknown";
                string errorMessage = Request.QueryString["message"] ?? "No specific error details";
                string adminId = Session["UserID"]?.ToString() ?? "Unknown";
                string userAgent = Request.UserAgent ?? "Unknown";
                string referrer = Request.UrlReferrer?.ToString() ?? "Direct";

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    string query = @"
                        INSERT INTO ClientErrorLogs 
                        (ErrorMessage, ErrorSource, UserAgent, PageUrl, AdminId, Timestamp) 
                        VALUES 
                        (@Message, @Source, @UserAgent, @Url, @AdminId, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Message", $"Error page visit: {errorType}");
                        cmd.Parameters.AddWithValue("@Source", referrer);
                        cmd.Parameters.AddWithValue("@UserAgent", userAgent);
                        cmd.Parameters.AddWithValue("@Url", "PageError.aspx");
                        cmd.Parameters.AddWithValue("@AdminId", adminId);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log to server log since we can't use the database logging at this point
                System.Diagnostics.Debug.WriteLine($"Error logging error page visit: {ex.Message}");
            }
        }
    }
}
