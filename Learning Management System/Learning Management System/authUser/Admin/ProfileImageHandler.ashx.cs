using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;

namespace Learning_Management_System.authUser.Admin
{
    /// <summary>
    /// Handler for serving profile images from the database
    /// </summary>
    public class ProfileImageHandler : IHttpHandler
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"]?.ConnectionString
            ?? "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                // Get user ID parameter
                if (string.IsNullOrEmpty(context.Request.QueryString["UserID"]))
                {
                    // If no user ID is provided, return a default image
                    ReturnDefaultImage(context);
                    return;
                }

                int userId;
                if (!int.TryParse(context.Request.QueryString["UserID"], out userId))
                {
                    // If user ID is not a valid integer, return a default image
                    ReturnDefaultImage(context);
                    return;
                }

                // Retrieve profile image from database
                byte[] imageData = GetProfileImageFromDatabase(userId);

                if (imageData == null || imageData.Length == 0)
                {
                    // If no image data found, return a default image
                    ReturnDefaultImage(context);
                    return;
                }

                // Determine image format and set content type
                string contentType = DetermineContentType(imageData);
                context.Response.ContentType = contentType;
                
                // Set cache headers for better performance
                SetCacheHeaders(context);
                
                // Write image data to response
                context.Response.BinaryWrite(imageData);
            }
            catch (Exception ex)
            {
                // Log error and return default image
                System.Diagnostics.Debug.WriteLine("Error in ProfileImageHandler: " + ex.Message);
                ReturnDefaultImage(context);
            }
        }

        private string DetermineContentType(byte[] imageData)
        {
            // Check for JPEG signature
            if (imageData.Length >= 2 && imageData[0] == 0xFF && imageData[1] == 0xD8)
                return "image/jpeg";
            
            // Check for PNG signature
            if (imageData.Length >= 8 && 
                imageData[0] == 0x89 && imageData[1] == 0x50 && imageData[2] == 0x4E && imageData[3] == 0x47 &&
                imageData[4] == 0x0D && imageData[5] == 0x0A && imageData[6] == 0x1A && imageData[7] == 0x0A)
                return "image/png";
            
            // Check for GIF signature
            if (imageData.Length >= 6 && 
                imageData[0] == 0x47 && imageData[1] == 0x49 && imageData[2] == 0x46 &&
                imageData[3] == 0x38 && (imageData[4] == 0x37 || imageData[4] == 0x39) && imageData[5] == 0x61)
                return "image/gif";
            
            // Default to JPEG if we can't determine the type
            return "image/jpeg";
        }

        private void SetCacheHeaders(HttpContext context)
        {
            // Cache images for 1 day, but allow revalidation
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.Cache.SetExpires(DateTime.Now.AddDays(1));
            context.Response.Cache.SetMaxAge(new TimeSpan(1, 0, 0, 0));
            context.Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
        }

        private byte[] GetProfileImageFromDatabase(int userId)
        {
            byte[] imageData = null;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                string query = "SELECT ProfilePicture FROM Users WHERE UserID = @UserID";
                
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        imageData = (byte[])result;
                    }
                }
            }

            return imageData;
        }

        private void ReturnDefaultImage(HttpContext context)
        {
            // Set content type for default image
            context.Response.ContentType = "image/png";
            
            // Path to default image
            string defaultImagePath = context.Server.MapPath("~/Assest/Images/user.png");
            
            // Check if the default image exists
            if (File.Exists(defaultImagePath))
            {
                context.Response.WriteFile(defaultImagePath);
            }
            else
            {
                // If default image doesn't exist, create a simple placeholder image
                GeneratePlaceholderImage(context);
            }
        }

        private void GeneratePlaceholderImage(HttpContext context)
        {
            // Create a simple 100x100 placeholder image
            using (Bitmap bitmap = new Bitmap(100, 100))
            {
                using (Graphics graphics = Graphics.FromImage(bitmap))
                {
                    // Fill with light gray
                    graphics.FillRectangle(Brushes.LightGray, 0, 0, 100, 100);
                    
                    // Draw a simple user silhouette
                    graphics.FillEllipse(Brushes.DarkGray, 35, 20, 30, 30);
                    graphics.FillRectangle(Brushes.DarkGray, 25, 55, 50, 30);
                }
                
                // Save as PNG to response stream
                using (MemoryStream ms = new MemoryStream())
                {
                    bitmap.Save(ms, ImageFormat.Png);
                    ms.Position = 0;
                    byte[] imageBytes = ms.ToArray();
                    context.Response.BinaryWrite(imageBytes);
                }
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
