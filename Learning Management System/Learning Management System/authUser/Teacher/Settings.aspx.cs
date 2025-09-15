using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;

namespace Learning_Management_System.authUser.Teacher
{
    public partial class Settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        // ...existing code...
        [WebMethod(EnableSession = true)]
        public static string UpdateProfile(string name, string email)
        {
            string userId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Session expired. Please log in again." });

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE Users SET FullName = @Name, Email = @Email WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    HttpContext.Current.Session["FullName"] = name;
                    HttpContext.Current.Session["Email"] = email;
                    
                    if (rows > 0)
                        return new JavaScriptSerializer().Serialize(new { success = true });
                    else
                        return new JavaScriptSerializer().Serialize(new { success = false, message = "Update failed." });
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public static string ChangePassword(string currentPassword, string newPassword)
        {
            string userId = HttpContext.Current.Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
                return new JavaScriptSerializer().Serialize(new { success = false, message = "Session expired. Please log in again." });

            string connStr = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            string currentPasswordHash = HashPasswordStatic(currentPassword);
            string newPasswordHash = HashPasswordStatic(newPassword);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Check current password
                string sql = "SELECT COUNT(*) FROM Login WHERE UserID = @UserID AND PasswordHash = @CurrentPassword";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@CurrentPassword", currentPasswordHash);
                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();
                    if (count == 0)
                        return new JavaScriptSerializer().Serialize(new { success = false, message = "Current password is incorrect." });
                }
                // Update to new password
                string updateSql = "UPDATE Login SET PasswordHash = @NewPassword WHERE UserID = @UserID";
                using (SqlCommand updateCmd = new SqlCommand(updateSql, conn))
                {
                    updateCmd.Parameters.AddWithValue("@NewPassword", newPasswordHash);
                    updateCmd.Parameters.AddWithValue("@UserID", userId);
                    int rows = updateCmd.ExecuteNonQuery();
                    if (rows > 0)
                        return new JavaScriptSerializer().Serialize(new { success = true });
                    else
                        return new JavaScriptSerializer().Serialize(new { success = false, message = "Password update failed." });
                }
            }
        }

        // Static version for use in static WebMethod
        private static string HashPasswordStatic(string password)
        {
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


    }
}