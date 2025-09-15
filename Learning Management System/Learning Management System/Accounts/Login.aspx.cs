using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using Learning_Management_System.Helpers;

namespace Learning_Management_System.Accounts
{
    public partial class Login : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null ?
            ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString : null;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                // Clear any existing sessions
                Session.Clear();

                // Set version info safely
                try
                {
                    if (lblVersion != null)
                    {
                        lblVersion.InnerHtml = "LMS v1.0 - " + DateTime.Now.Year;
                    }
                }
                catch { } // Fail silently if control not found

                // Check if user is already logged in
                if (Session["Admin"] != null || Session["UserID"] != null)
                {
                    RedirectUserBasedOnRole();
                }
            }
        }

        // Override to handle validation issues
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // Ensure controls are properly registered for event validation
            try
            {
                if (txtEmail != null)
                    ClientScript.RegisterForEventValidation(txtEmail.UniqueID);
                if (txtPassword != null)
                    ClientScript.RegisterForEventValidation(txtPassword.UniqueID);
                if (btnLogin != null)
                    ClientScript.RegisterForEventValidation(btnLogin.UniqueID);
            }
            catch { } // Fail silently if registration fails
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                // Debug: Log the start of login process
                ActivityLogger.LogError("Login Process Started", new Exception($"Login attempt for button click"));

                // Validate controls exist
                if (txtEmail == null || txtPassword == null)
                {
                    ShowMessage("Form controls not properly loaded. Please refresh the page.", "error");
                    return;
                }

                string email = txtEmail.Text != null ? txtEmail.Text.Trim() : "";
                string password = txtPassword.Text != null ? txtPassword.Text.Trim() : "";

                // Debug: Log input validation
                ActivityLogger.LogError("Login Input", new Exception($"Email: {email}, Password length: {password.Length}, Password: {password}"));

                // Validate input
                if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
                {
                    ShowMessage("Please enter both email and password.", "error");
                    return;
                }

                // Validate email format
                if (!IsValidEmail(email))
                {
                    ShowMessage("Please enter a valid email address.", "error");
                    return;
                }

                // Debug: Log authentication attempt
                ActivityLogger.LogError("Authentication Attempt", new Exception($"Attempting authentication for: {email}, Password: {password}"));

                // Authenticate user
                if (AuthenticateUser(email, password))
                {
                    // Debug: Log successful authentication
                    ActivityLogger.LogError("Authentication Success", new Exception($"User authenticated: {email}, Session admin: {Session["admin"]}, Session UserID: {Session["UserID"]}"));

                    ActivityLogger.LogLoginActivity(email, "Success");

                    // Try direct redirect first
                    RedirectUserBasedOnRole();
                }
                else
                {
                    // Debug: Log failed authentication
                    ActivityLogger.LogError("Authentication Failed", new Exception($"Authentication failed for: {email}"));

                    ActivityLogger.LogLoginActivity(email, "Failed");
                    ShowMessage("Invalid email or password. Please try again.", "error");
                }
            }
            catch (Exception ex)
            {
                // LogError("Login Error", ex);
                ShowMessage("An error occurred during login. Please try again later.", "error");
            }
        }

        private bool AuthenticateUser(string email, string password)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {

                    conn.Open();

                    // Check for admin user first
                    string query = @"  SELECT u.*, l.PasswordHash, d.DepartmentName, l.LastLogin FROM dbo.Users AS u full JOIN dbo.Login AS l 
                                        ON u.UserID = l.UserID full join Department d on d.DepartmentID = u.DepartmentID 
                                        WHERE u.Email=@Email and u.IsActive=1;";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedPassword = reader["PasswordHash"].ToString().Trim();

                                // Verify password (assuming you're using hashing)
                                if (VerifyPassword(password, storedPassword))
                                {
                                    // Set admin session
                                    if (reader["UserType"].ToString().ToLower().Equals("admin"))
                                    {
                                        Session["Admin"] = true;
                                    }
                                    else if (reader["UserType"].ToString().ToLower().Equals("student"))
                                    {
                                        Session["Student"] = true;
                                    }
                                    else if (reader["UserType"].ToString().ToLower().Equals("teacher"))
                                    {
                                        Session["Teacher"] = true;
                                    }
                                    else
                                    {
                                        Session["Guest"] = true;
                                    }
                                    Session["UserID"] = reader["UserID"].ToString();
                                    Session["FullName"] = reader["FullName"].ToString();
                                    Session["Email"] = reader["Email"].ToString();
                                    Session["UserType"] = reader["UserType"].ToString();
                                    Session["Department"] = reader["DepartmentName"].ToString();
                                    Session["Phone"] = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "";
                                    Session["Joined"] = reader["CreatedDate"] != DBNull.Value ? Convert.ToDateTime(reader["CreatedDate"]).ToString("dd MMMM yyyy") : "";
                                    object dbProfilePic = reader["ProfilePicture"];
                                    Session["ProfilePicture"] = dbProfilePic != null ? dbProfilePic.ToString() : "";
                                    Session["LastLogin"] = reader["LastLogin"] != DBNull.Value ? Convert.ToDateTime(reader["LastLogin"]).ToString("dd MMMM yyyy HH:mm") : "Never";
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Authentication Error", ex);
            }

            return false;
        }


        private string HashPassword(string password)
        {
            // Use a secure hashing algorithm (SHA-256 in this example)
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();

                for (int i = 0; i < hashedBytes.Length; i++)
                {
                    builder.Append(hashedBytes[i].ToString("x2"));
                }

                return builder.ToString();
            }
        }

        private bool VerifyPassword(string inputPassword, string storedPassword)
        {

            // Hash the input password
            string hashedInputPassword = HashPassword(inputPassword);
            // Compare the hashed input password with the stored hash
            return hashedInputPassword.Equals(storedPassword);
        }

        private void RedirectUserBasedOnRole()
        {
            try
            {
                // Log the session state for debugging
                ActivityLogger.LogError("Redirect Debug", new Exception($"Session admin: {Session["Admin"]}, Session UserID: {Session["UserID"]}, Session UserType: {Session["UserType"]}"));

                ActivityLogger.Log("Login", $"User logged in: {Session["FullName"]} ({Session["UserID"]})");

                if (Session["Admin"] != null && (bool)Session["Admin"] == true)
                {
                    // Redirect to admin dashboard
                    string redirectUrl = "~/authUser/Admin/Dashboard.aspx";
                    ActivityLogger.LogError("Redirect Attempt", new Exception($"Redirecting admin to: {redirectUrl}"));
                    Response.Redirect(redirectUrl, false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }
                else if (Session["UserID"] != null)
                {
                    string userType = Session["UserType"] != null ? Session["UserType"].ToString() : null;
                    string redirectUrl = "";

                    switch (userType != null ? userType.ToLower() : null)
                    {
                        case "student":
                            redirectUrl = "~/authUser/Student/Dashboard.aspx";
                            break;
                        case "lecturer":
                        case "instructor":
                        case "teacher":
                            redirectUrl = "~/authUser/Teacher/Dashboard.aspx";
                            break;
                        case "admin":
                            redirectUrl = "~/authUser/Admin/Dashboard.aspx";
                            break;
                        default:
                            redirectUrl = "~/Default.aspx"; // Default to home page if role is unclear
                            break;
                    }

                    if (!string.IsNullOrEmpty(redirectUrl))
                    {
                        ActivityLogger.LogError("Redirect Attempt", new Exception($"Redirecting user ({userType}) to: {redirectUrl}"));
                        Response.Redirect(redirectUrl, false);
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }
                }

                // If we get here, no valid session or role was found
                Response.Redirect("~/Accounts/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Redirect Error", ex);

                // Force redirect using JavaScript as last resort
                string script = @"
                    setTimeout(function() {
                        window.location.href = '../Accounts/Login.aspx';
                    }, 100);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "ForceRedirect", script, true);
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private void ShowMessage(string message, string type = "info")
        {
            // Log the error message
            if (type == "error")
            {
                ActivityLogger.LogError("Login Error", new Exception(message));
            }

            // Only show error messages to avoid interfering with success redirects
            if (type == "error")
            {
                string script = $@"
                    document.addEventListener('DOMContentLoaded', function() {{
                        if (typeof Swal !== 'undefined') {{
                            Swal.fire({{
                                icon: '{type}',
                                title: 'Login Failed',
                                text: '{message}',
                                confirmButtonColor: '#2c2b7c'
                            }});
                        }} else {{
                            alert('{message}');
                        }}
                    }});
                ";

                ClientScript.RegisterStartupScript(this.GetType(), "ShowMessage", script, true);
            }
        }


    }
}