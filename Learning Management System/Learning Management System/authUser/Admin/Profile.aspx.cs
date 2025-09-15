using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if admin is logged in
                if (Session["AdminId"] == null)
                {
                    //Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }

                LoadAdminProfile();
            }
        }

        private void LoadAdminProfile()
        {
            try
            {
                string adminId = Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT AdminId, FirstName, LastName, Email, PhoneNumber, 
                               Address, ProfilePicture, CreatedDate, LastLoginDate
                        FROM Admins 
                        WHERE AdminId = @AdminId";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@AdminId", adminId);
                        connection.Open();

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Register client script to populate form fields
                                string script = $@"
                                    document.addEventListener('DOMContentLoaded', function() {{
                                        document.getElementById('firstName').value = '{reader["FirstName"]}';
                                        document.getElementById('lastName').value = '{reader["LastName"]}';
                                        document.getElementById('email').value = '{reader["Email"]}';
                                        document.getElementById('phone').value = '{reader["PhoneNumber"] ?? ""}';
                                        document.getElementById('bio').value = '{reader["Address"] ?? ""}';
                                        
                                        // Update profile header
                                        document.querySelector('.profile-name').textContent = '{reader["FirstName"]} {reader["LastName"]}';
                                        document.querySelector('.profile-email').textContent = '{reader["Email"]}';
                                        
                                        // Update avatar if profile picture exists
                                        if ('{reader["ProfilePicture"]}' !== '') {{
                                            document.getElementById('profileAvatar').src = '../../../Assest/images/' + '{reader["ProfilePicture"]}';
                                        }}
                                        
                                        // Update last login
                                        document.querySelector('.last-login').textContent = 'Last login: {(reader["LastLoginDate"] != DBNull.Value ? Convert.ToDateTime(reader["LastLoginDate"]).ToString("MMM dd, yyyy hh:mm tt") : "Never")}';
                                    }});
                                ";

                                ClientScript.RegisterStartupScript(this.GetType(), "LoadProfile", script, true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error and show user-friendly message
                System.Diagnostics.Debug.WriteLine($"Profile Load Error: {ex.Message}");
                string errorScript = @"
                    Swal.fire({
                        title: 'Error!',
                        text: 'Unable to load profile data. Please try again.',
                        icon: 'error',
                        confirmButtonColor: '#3085d6'
                    });
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "LoadError", errorScript, true);
            }
        }

        [System.Web.Services.WebMethod]
        public static string UpdateProfile(string firstName, string lastName, string email, string phone, string address)
        {
            try
            {
                string adminId = HttpContext.Current.Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Admins 
                        SET FirstName = @FirstName, 
                            LastName = @LastName, 
                            Email = @Email, 
                            PhoneNumber = @Phone, 
                            Address = @Address,
                            ModifiedDate = GETDATE()
                        WHERE AdminId = @AdminId";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@FirstName", firstName);
                        command.Parameters.AddWithValue("@LastName", lastName);
                        command.Parameters.AddWithValue("@Email", email);
                        command.Parameters.AddWithValue("@Phone", phone ?? "");
                        command.Parameters.AddWithValue("@Address", address ?? "");
                        command.Parameters.AddWithValue("@AdminId", adminId);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "No changes were made.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error updating profile: " + ex.Message;
            }
        }

        [System.Web.Services.WebMethod]
        public static string ChangePassword(string currentPassword, string newPassword)
        {
            try
            {
                string adminId = HttpContext.Current.Session["AdminId"].ToString();
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // First verify current password
                    string verifyQuery = "SELECT Password FROM Admins WHERE AdminId = @AdminId";
                    using (SqlCommand verifyCommand = new SqlCommand(verifyQuery, connection))
                    {
                        verifyCommand.Parameters.AddWithValue("@AdminId", adminId);
                        connection.Open();
                        
                        string storedPassword = verifyCommand.ExecuteScalar()?.ToString();
                        
                        // In production, use proper password hashing
                        if (storedPassword != currentPassword)
                        {
                            return "Current password is incorrect.";
                        }
                    }

                    // Update password
                    string updateQuery = @"
                        UPDATE Admins 
                        SET Password = @NewPassword, 
                            ModifiedDate = GETDATE()
                        WHERE AdminId = @AdminId";

                    using (SqlCommand updateCommand = new SqlCommand(updateQuery, connection))
                    {
                        updateCommand.Parameters.AddWithValue("@NewPassword", newPassword);
                        updateCommand.Parameters.AddWithValue("@AdminId", adminId);

                        int rowsAffected = updateCommand.ExecuteNonQuery();
                        return rowsAffected > 0 ? "success" : "Failed to update password.";
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error changing password: " + ex.Message;
            }
        }
    }
}