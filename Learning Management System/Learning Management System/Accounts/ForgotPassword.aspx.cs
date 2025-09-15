using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;

namespace Learning_Management_System
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        // Get connection string from web.config
        private string connectionString = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ActivityLogger.Log("PageLoaded", "ForgotPassword page loaded successfully.");
                // Clear any previous messages
                lblMessage.Text = string.Empty;
            }
        }
        
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            
            // Validate email
            if (string.IsNullOrEmpty(email))
            {
                DisplayMessage("Please enter your email address.", "error");
                ActivityLogger.Log("PasswordResetRequest", "Email not provided.");
                return;
            }
            
            // Check if email exists in database
            int userId = GetUserIdByEmail(email);
            if (userId <= 0)
            {
                // Don't reveal that the email doesn't exist for security reasons
                DisplayMessage("If your email is registered, you will receive a password reset link shortly.", "success");
                ActivityLogger.Log("PasswordResetRequest", $"Email found: {email}");
                Response.Redirect("Resent.aspx");
                return;
            }
            
            // Generate reset token
            string token = GenerateResetToken();
            
            // Save token to database
            bool tokenSaved = SaveResetToken(userId, token);
            if (!tokenSaved)
            {
                DisplayMessage("An error occurred. Please try again later.", "error");
                return;
            }
            
            // Send email with reset link
            bool emailSent = SendResetEmail(email, token);
            if (!emailSent)
            {
                DisplayMessage("Failed to send email. Please try again later.", "error");
                return;
            }
            
            // Success message
            DisplayMessage("Password reset link has been sent to your email.", "success");
            Response.Redirect("Resent.aspx");
        }
        
        private int GetUserIdByEmail(string email)
        {
            int userId = 0;
            
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT UserID FROM Users WHERE Email = @Email AND IsActive = 1";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            userId = Convert.ToInt32(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                ActivityLogger.LogError("Error checking email", ex);
            }
            
            return userId;
        }
        
        private string GenerateResetToken()
        {
            // Generate a unique token
            byte[] tokenData = new byte[32];
            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(tokenData);
            }
            
            return Convert.ToBase64String(tokenData)
                .Replace("+", "-")
                .Replace("/", "_")
                .Replace("=", "")
                .Substring(0, 32); // Trim to 32 characters for cleaner URLs
        }
        
        private bool SaveResetToken(int userId, string token)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // First, invalidate any existing tokens for this user
                    string updateQuery = @"
                        UPDATE PasswordResetTokens 
                        SET IsActive = 0 
                        WHERE UserID = @UserID AND IsActive = 1";
                    
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                    
                    // Insert new token
                    string insertQuery = @"
                        INSERT INTO PasswordResetTokens (UserID, Token, ExpiryDate, IsActive)
                        VALUES (@UserID, @Token, @ExpiryDate, 1)";
                    
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Token", token);
                        cmd.Parameters.AddWithValue("@ExpiryDate", DateTime.Now.AddHours(24)); // Token valid for 24 hours
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
                ActivityLogger.LogError("Error saving reset token", ex);
                return false;
            }
        }


        private bool SendResetEmail(string email, string token)
{
    try
    {
        // Build reset URL
        string resetUrl = $"{Request.Url.GetLeftPart(UriPartial.Authority)}/Accounts/PasswordReset.aspx?token={token}";

        // Get Base64 logo
        string logoPath = Server.MapPath("../Assest/Images/uew_logo.png");
        string logoBase64 = Convert.ToBase64String(File.ReadAllBytes(logoPath));
        string logoUrl = $"data:image/png;base64,{logoBase64}";

        // Configure email settings from web.config
        string smtpServer = ConfigurationManager.AppSettings["SmtpServer"] ?? "smtp.gmail.com";
        int smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
        string smtpUsername = ConfigurationManager.AppSettings["SmtpUsername"] ?? "nethunterghana@gmail.com";
        string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"] ?? "uuub lqoq adis aiyp";
        bool enableSsl = bool.Parse(ConfigurationManager.AppSettings["SmtpEnableSsl"] ?? "true");
        string fromEmail = ConfigurationManager.AppSettings["FromEmail"] ?? "noreply@uew.edu.gh";
        string fromName = ConfigurationManager.AppSettings["FromName"] ?? "UEW Learning Management System";

        // Create email message
        MailMessage mail = new MailMessage();
        mail.From = new MailAddress(fromEmail, fromName);
        mail.To.Add(email);
        mail.Subject = "Password Reset Request";
        mail.Body = $@"
            <html>
            <head>
                <style>
                    body {{ font-family: 'Roboto', Arial, sans-serif; line-height: 1.6; color: #333; }}
                    .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                    h1 {{ color: #2c2b7c; }}
                    .button {{ display: inline-block; padding: 10px 20px; background-color: #2c2b7c; color: white; 
                              text-decoration: none; border-radius: 4px; margin: 20px 0; }}
                    .footer {{ margin-top: 30px; font-size: 12px; color: #666; }}
                </style>
            </head>
            <body>
                <div class='container'>
                    <h1>Password Reset Request</h1>
                    <img src='{logoUrl}' alt='UEW Logo' style='width: 150px; height: auto;'>
                    <p>We received a request to reset your password for the UEW Learning Management System.</p>
                    <p>To reset your password, please click the button below:</p>
                    <a href='{resetUrl}' class='button'>Reset Password</a>
                    <p>If you didn't request a password reset, you can ignore this email.</p>
                    <p>This link will expire in 24 hours for security reasons.</p>
                    <div class='footer'>
                        <p>This is an automated email, please do not reply.</p>
                        <p>&copy; {DateTime.Now.Year} University of Education, Winneba</p>
                    </div>
                </div>
            </body>
            </html>
        ";
        mail.IsBodyHtml = true;

        // Send email
        using (SmtpClient smtp = new SmtpClient(smtpServer, smtpPort))
        {
            smtp.EnableSsl = enableSsl;
            smtp.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
            smtp.Send(mail);
        }

        return true;
    }
    catch (Exception ex)
    {
        ActivityLogger.LogError("Error sending email", ex);
        return false;
    }
}

        
        private void DisplayMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
        }
        
    }
}