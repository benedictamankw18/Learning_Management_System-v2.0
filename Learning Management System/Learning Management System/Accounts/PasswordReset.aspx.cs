using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;

namespace Learning_Management_System.Accounts
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        // Get connection string from web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
        private string token;
        private int userId = 0;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear any previous messages
                lblMessage.Text = string.Empty;
                
                // Get token from query string
                token = Request.QueryString["token"];
                
                if (string.IsNullOrEmpty(token))
                {
                    // No token provided, display error
                    DisplayMessage("Invalid password reset request. Please request a new password reset link.", "error");
                    DisableForm();
                    return;
                }
                
                // Validate token
                if (!ValidateToken(token, out userId))
                {
                    // Invalid or expired token
                    DisplayMessage("Your password reset link has expired or is invalid. Please request a new one.", "error");
                    DisableForm();
                    return;
                }
            }
            else
            {
                // Retrieve token from ViewState in postbacks
                token = ViewState["Token"] as string;
                userId = Convert.ToInt32(ViewState["UserId"] ?? "0");
            }
        }
        
        private bool ValidateToken(string token, out int userId)
        {
            userId = 0;
            
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    string query = @"
                        SELECT UserID 
                        FROM PasswordResetTokens 
                        WHERE Token = @Token 
                          AND IsActive = 1 
                          AND ExpiryDate > GETDATE()";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Token", token);
                        
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            userId = Convert.ToInt32(result);
                            
                            // Save to ViewState for postbacks
                            ViewState["Token"] = token;
                            ViewState["UserId"] = userId;
                            
                            ActivityLogger.Log("PasswordResetTokenValidation", "Success");
                            return true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                LogError("Error validating token", ex);
            }
            
            return false;
        }
        
        protected void btnReset_Click(object sender, EventArgs e)
        {
            // Validate inputs
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            
            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(confirmPassword))
            {
                DisplayMessage("Please enter and confirm your new password.", "error");
                return;
            }
            
            if (password != confirmPassword)
            {
                DisplayMessage("Passwords do not match.", "error");
                return;
            }
            
            // Validate password strength
            if (!IsPasswordStrong(password))
            {
                DisplayMessage("Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character.", "error");
                return;
            }
            
            // Reset the password
            if (ResetPassword(userId, password))
            {
                // Mark token as used
                InvalidateToken(token);
                
                // Success message
                DisplayMessage("Your password has been reset successfully. You can now login with your new password.", "success");
                ActivityLogger.Log("PasswordReset", $"Success for UserID: ({userId})");
                // Redirect to login page after 5 seconds
                string script = @"
                    setTimeout(function() {
                        window.location.href = 'Login.aspx';
                    }, 5000);";
                ClientScript.RegisterStartupScript(this.GetType(), "RedirectToLogin", script, true);
            }
            else
            {
                DisplayMessage("Failed to reset password. Please try again.", "error");
            }
        }
        
        private bool IsPasswordStrong(string password)
        {
            // Password must be at least 8 characters long and include uppercase, lowercase, number, and special character
            return password.Length >= 8 &&
                   password.Any(char.IsUpper) &&
                   password.Any(char.IsLower) &&
                   password.Any(char.IsDigit) &&
                   password.Any(c => !char.IsLetterOrDigit(c));
        }
        
        private bool ResetPassword(int userId, string password)
        {
            try
            {
                string passwordHash = HashPassword(password);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if the user exists
                    string checkQuery = "SELECT COUNT(*) FROM Login WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(checkQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        int count = (int)cmd.ExecuteScalar();

                        if (count > 0)
                        {
                            // Update password
                            string updateQuery = @"
                        UPDATE Login 
                        SET PasswordHash = @PasswordHash, 
                            LastLogin = GETDATE() 
                        WHERE UserID = @UserID";

                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                                updateCmd.Parameters.AddWithValue("@UserID", userId);
                                return updateCmd.ExecuteNonQuery() > 0;
                            }
                        }
                        else
                        {
                            // Insert new login record
                            string insertQuery = @"
                        INSERT INTO Login (UserID, PasswordHash) 
                        VALUES (@UserID, @PasswordHash)";

                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                                insertCmd.Parameters.AddWithValue("@UserID", userId);
                                return insertCmd.ExecuteNonQuery() > 0;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError("Error resetting password", ex);
                return false;
            }
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
        
        private void InvalidateToken(string token)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    string query = @"
                        UPDATE PasswordResetTokens 
                        SET IsActive = 0 
                        WHERE Token = @Token";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Token", token);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                LogError("Error invalidating token", ex);
            }
        }
        
        private void DisplayMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
        }
        
        private void DisableForm()
        {
            // Disable the form inputs
            txtPassword.Enabled = false;
            txtConfirmPassword.Enabled = false;
            btnReset.Enabled = false;
        }
        
        private void LogError(string message, Exception ex)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO ErrorLogs (ErrorMessage, StackTrace, Timestamp, PageName)
                        VALUES (@ErrorMessage, @StackTrace, GETDATE(), @PageName)";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ErrorMessage", message + ": " + ex.Message);
                        cmd.Parameters.AddWithValue("@StackTrace", ex.StackTrace ?? "");
                        cmd.Parameters.AddWithValue("@PageName", "PasswordReset.aspx");
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // Silent fail for error logging
            }
        }
    }
}