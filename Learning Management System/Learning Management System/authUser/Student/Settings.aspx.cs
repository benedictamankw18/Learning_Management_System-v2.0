using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Security.Cryptography;
using System.Text;

namespace Learning_Management_System.authUser.Student
{
    public partial class Settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetStudentSettings()
        {
            var profile = new Dictionary<string, string>();
            int studentId = 1; // fallback
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out studentId);
            }
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"SELECT UserID, FullName, Email, Phone, UserType, DepartmentID, LevelID, ProgrammeID, EmployeeID, ProfilePicture, CreatedDate, ModifiedDate, IsActive 
                       FROM Users WHERE UserID = @UserID";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", studentId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            profile["UserID"] = reader["UserID"].ToString();
                            profile["FullName"] = reader["FullName"].ToString();
                            profile["Email"] = reader["Email"].ToString();
                            profile["Phone"] = reader["Phone"].ToString();
                            profile["UserType"] = reader["UserType"].ToString();
                            profile["DepartmentID"] = reader["DepartmentID"].ToString();
                            profile["LevelID"] = reader["LevelID"].ToString();
                            profile["ProgrammeID"] = reader["ProgrammeID"].ToString();
                            profile["EmployeeID"] = reader["EmployeeID"].ToString();
                            profile["ProfilePicture"] = reader["ProfilePicture"].ToString();
                            profile["CreatedDate"] = Convert.ToDateTime(reader["CreatedDate"]).ToString("MMM yyyy");
                            profile["ModifiedDate"] = reader["ModifiedDate"] != DBNull.Value ? Convert.ToDateTime(reader["ModifiedDate"]).ToString("MMM yyyy") : "";
                            profile["IsActive"] = reader["IsActive"].ToString();
                        }
                    }
                }
            }
            return new JavaScriptSerializer().Serialize(profile);
        }

        [WebMethod]
        public static string UpdateStudentSettings(string name, string email, string phone)
        {
            int studentId = 1; // fallback
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out studentId);
            }
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"UPDATE Users SET FullName=@Name, Email=@Email, Phone=@Phone, ModifiedDate=GETDATE() WHERE UserID=@UserID";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@UserID", studentId);
                    cmd.ExecuteNonQuery();
                }
            }
            return "{\"success\":true}";
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


        [WebMethod]
        public static string ChangePassword(string oldPassword, string newPassword)
        {
            oldPassword = new Settings().HashPassword(oldPassword);
            newPassword = new Settings().HashPassword(newPassword);
            int userId = 0;
            if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
            {
                int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out userId);
            }
            string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Check old password
                string sql = "SELECT PasswordHash FROM Login WHERE UserID=@UserID";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    var dbPass = cmd.ExecuteScalar() as string;
                    if (dbPass == null || dbPass != oldPassword)
                    {
                        return "{\"success\":false,\"message\":\"Old password is incorrect.\"}";
                    }
                }
                // Update new password
                string updateSql = "UPDATE Login SET PasswordHash=@Password WHERE UserID=@UserID";
                using (var cmd = new SqlCommand(updateSql, conn))
                {
                    cmd.Parameters.AddWithValue("@Password", newPassword);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.ExecuteNonQuery();
                }
            }
            return "{\"success\":true}";
        }

    }
}