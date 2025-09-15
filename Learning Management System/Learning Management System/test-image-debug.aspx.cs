using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace Learning_Management_System
{
    public partial class test_image_debug : System.Web.UI.Page
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"]?.ConnectionString
            ?? "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize default values
                UserIdInput.Text = "1008"; // Default user ID to check
            }
        }

        protected void FetchButton_Click(object sender, EventArgs e)
        {
            int userId;
            if (int.TryParse(UserIdInput.Text, out userId))
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT 
                            u.UserID, u.FullName, u.Email, u.Phone, u.UserType, 
                            u.ProfilePicture
                        FROM Users u
                        WHERE u.UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Set basic user info
                                UserName.Text = reader["FullName"].ToString();
                                UserRole.Text = reader["UserType"].ToString();
                                UserEmail.Text = reader["Email"].ToString();

                                // Set handler URL
                                string timestamp = DateTime.Now.Ticks.ToString();
                                string handlerUrl = $"/authUser/Admin/ProfileImageHandler.ashx?UserID={userId}&t={timestamp}";
                                handlerLink.HRef = handlerUrl;
                                handlerLink.InnerText = handlerUrl;
                                
                                // Set the user avatar
                                UserAvatar.ImageUrl = handlerUrl;
                                
                                ResultsPanel.Visible = true;
                            }
                            else
                            {
                                Response.Write("<script>alert('User not found.');</script>");
                            }
                        }
                    }
                }
            }
            else
            {
                Response.Write("<script>alert('Please enter a valid User ID.');</script>");
            }
        }

        protected void InspectImagesButton_Click(object sender, EventArgs e)
        {
            int userId;
            if (int.TryParse(UserIdInput.Text, out userId))
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    
                    // Check Users.ProfilePicture
                    byte[] usersProfilePic = null;
                    string query1 = "SELECT ProfilePicture FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query1, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        object result = cmd.ExecuteScalar();
                        
                        if (result != DBNull.Value && result != null)
                        {
                            usersProfilePic = (byte[])result;
                            HasUsersProfilePic.Text = "Yes";
                            UsersProfilePicSize.Text = usersProfilePic.Length + " bytes";
                            
                            // Detect format
                            string format = "Unknown";
                            if (usersProfilePic.Length > 2)
                            {
                                if (usersProfilePic[0] == 0xFF && usersProfilePic[1] == 0xD8)
                                {
                                    format = "JPEG";
                                }
                                else if (usersProfilePic.Length > 8 && usersProfilePic[0] == 0x89 && usersProfilePic[1] == 0x50 && usersProfilePic[2] == 0x4E)
                                {
                                    format = "PNG";
                                }
                                else if (usersProfilePic.Length > 3 && usersProfilePic[0] == 0x47 && usersProfilePic[1] == 0x49 && usersProfilePic[2] == 0x46)
                                {
                                    format = "GIF";
                                }
                                else if (usersProfilePic.Length > 2 && usersProfilePic[0] == 0x42 && usersProfilePic[1] == 0x4D)
                                {
                                    format = "BMP";
                                }
                                else
                                {
                                    // Check for base64 encoded image
                                    string base64Check = Encoding.ASCII.GetString(usersProfilePic.Take(30).ToArray()).ToLower();
                                    if (base64Check.StartsWith("data:image/"))
                                    {
                                        format = "Base64 encoded string (Needs decoding)";
                                    }
                                }
                            }
                            UsersProfilePicFormat.Text = format;
                            
                            // Display first bytes
                            List<byte> firstBytes = usersProfilePic.Take(Math.Min(32, usersProfilePic.Length)).ToList();
                            UsersProfilePicBytes.DataSource = firstBytes;
                            UsersProfilePicBytes.DataBind();
                            
                            // Display ASCII representation
                            StringBuilder sb = new StringBuilder();
                            for (int i = 0; i < Math.Min(100, usersProfilePic.Length); i++)
                            {
                                byte b = usersProfilePic[i];
                                if (b >= 32 && b <= 126) // Printable ASCII
                                {
                                    sb.Append((char)b);
                                }
                                else
                                {
                                    sb.Append('.');
                                }
                            }
                            UsersProfilePicString.Text = sb.ToString();
                            
                            // Setup direct preview
                            string contentType = "image/jpeg"; // Default
                            if (format == "PNG") contentType = "image/png";
                            else if (format == "GIF") contentType = "image/gif";
                            else if (format == "BMP") contentType = "image/bmp";
                            
                            string base64String = Convert.ToBase64String(usersProfilePic);
                            UsersProfilePicPreview.ImageUrl = $"data:{contentType};base64,{base64String}";
                            
                            // Setup handler preview
                            string timestamp = DateTime.Now.Ticks.ToString();
                            usersHandlerPreview.Src = $"/authUser/Admin/ProfileImageHandler.ashx?UserID={userId}&t={timestamp}";
                        }
                        else
                        {
                            HasUsersProfilePic.Text = "No";
                            UsersProfilePicSize.Text = "0 bytes";
                            UsersProfilePicFormat.Text = "N/A";
                        }
                    }
                    
                    // Note about User_Profile table
                    HasUserProfilePic.Text = "N/A - Table does not exist";
                    UserProfilePicSize.Text = "N/A";
                    UserProfilePicFormat.Text = "N/A";
                    UserProfilePicString.Text = "The User_Profile table does not exist in the database.";
                    
                    // Empty the byte display
                    UserProfilePicBytes.DataSource = new List<byte>();
                    UserProfilePicBytes.DataBind();
                    
                    // Set placeholder images
                    UserProfilePicPreview.ImageUrl = "data:image/svg+xml;base64," + Convert.ToBase64String(Encoding.UTF8.GetBytes("<svg xmlns='http://www.w3.org/2000/svg' width='150' height='150'><rect width='150' height='150' fill='#eeeeee'/><text x='75' y='75' font-family='Arial' font-size='12' text-anchor='middle' dominant-baseline='middle' fill='#999999'>Not Available</text></svg>"));
                    profileHandlerPreview.Src = "data:image/svg+xml;base64," + Convert.ToBase64String(Encoding.UTF8.GetBytes("<svg xmlns='http://www.w3.org/2000/svg' width='150' height='150'><rect width='150' height='150' fill='#eeeeee'/><text x='75' y='75' font-family='Arial' font-size='12' text-anchor='middle' dominant-baseline='middle' fill='#999999'>Not Available</text></svg>"));
                    
                    DebugPanel.Visible = true;
                }
            }
            else
            {
                Response.Write("<script>alert('Please enter a valid User ID.');</script>");
            }
        }
    }
}
