using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Linq;

public class ProfileImageHandler : IHttpHandler 
{
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            string userIdParam = context.Request.QueryString["UserID"];
            int userId;
            if (string.IsNullOrEmpty(userIdParam) || !int.TryParse(userIdParam, out userId))
            {
                context.Response.ContentType = "text/plain";
                context.Response.Write("Error: Invalid UserID parameter");
                context.Response.StatusCode = 400;
                return;
            }
            
            // Add debug info to response headers for tracking
            context.Response.AppendHeader("X-Debug-UserID", userId.ToString());

            string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"] != null ? 
                ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString : 
                "Data Source=N3THUNT3R-SOCIA;Initial Catalog=LearningManagementSystem;Integrated Security=True";

            // Try different queries to find the user's profile picture
            byte[] imgBytes = null;
            string debugSource = string.Empty;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                // First try the Users table
                string query1 = "SELECT ProfilePicture FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query1, conn))
                {
                    cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                    object result = cmd.ExecuteScalar();
                    
                    if (result != DBNull.Value && result != null)
                    {
                        imgBytes = (byte[])result;
                        debugSource = "Users.ProfilePicture";
                        
                        // Check if this is a valid image format
                        if (imgBytes.Length > 0)
                        {
                            bool isValidImage = false;
                            
                            // Check common image format headers
                            if ((imgBytes.Length > 2 && imgBytes[0] == 0xFF && imgBytes[1] == 0xD8) || // JPEG
                                (imgBytes.Length > 8 && imgBytes[0] == 0x89 && imgBytes[1] == 0x50 && imgBytes[2] == 0x4E) || // PNG
                                (imgBytes.Length > 3 && imgBytes[0] == 0x47 && imgBytes[1] == 0x49 && imgBytes[2] == 0x46) || // GIF
                                (imgBytes.Length > 2 && imgBytes[0] == 0x42 && imgBytes[1] == 0x4D)) // BMP
                            {
                                isValidImage = true;
                            }
                            
                            // If it doesn't look like a valid image, log a special header
                            if (!isValidImage)
                            {
                                context.Response.AppendHeader("X-Debug-InvalidFormat", "true");
                                context.Response.AppendHeader("X-Debug-FirstBytes", 
                                    string.Join("-", imgBytes.Take(Math.Min(10, imgBytes.Length)).Select(b => b.ToString("X2"))));
                            }
                        }
                    }
                }
                
                // The User_Profile table has been removed from the database
                // We now only use the Users table for profile pictures
                if (imgBytes == null || imgBytes.Length == 0)
                {
                    // Add debug info
                    debugSource = "No image found";
                }
            }

            context.Response.AppendHeader("X-Debug-ImageSource", debugSource);
            context.Response.AppendHeader("X-Debug-HasResult", (imgBytes != null && imgBytes.Length > 0).ToString());
            
            if (imgBytes != null && imgBytes.Length > 0)
            {
                context.Response.AppendHeader("X-Debug-ImageSize", imgBytes.Length.ToString());
                
                // Try to detect image format
                string contentType = "image/jpeg"; // Default
                string formatDetection = "unknown";
                
                if (imgBytes.Length > 2)
                {
                    // Check for JPEG header
                    if (imgBytes[0] == 0xFF && imgBytes[1] == 0xD8)
                    {
                        contentType = "image/jpeg";
                        formatDetection = "jpeg";
                    }
                    // Check for PNG header
                    else if (imgBytes.Length >= 8 && 
                        imgBytes[0] == 0x89 && imgBytes[1] == 0x50 && 
                        imgBytes[2] == 0x4E && imgBytes[3] == 0x47)
                    {
                        contentType = "image/png";
                        formatDetection = "png";
                    }
                    // Check for GIF header
                    else if (imgBytes.Length >= 3 && 
                        imgBytes[0] == 0x47 && imgBytes[1] == 0x49 && 
                        imgBytes[2] == 0x46)
                    {
                        contentType = "image/gif";
                        formatDetection = "gif";
                    }
                    // Check for BMP header
                    else if (imgBytes.Length >= 2 && 
                        imgBytes[0] == 0x42 && imgBytes[1] == 0x4D)
                    {
                        contentType = "image/bmp";
                        formatDetection = "bmp";
                    }
                    else 
                    {
                        // Check for base64 encoded image
                        string base64Check = System.Text.Encoding.ASCII.GetString(imgBytes.Take(30).ToArray()).ToLower();
                        if (base64Check.StartsWith("data:image/"))
                        {
                            formatDetection = "base64-encoded";
                            context.Response.AppendHeader("X-Debug-Base64Detected", "true");
                            
                            // Try to parse format from the data URI
                            int formatEnd = base64Check.IndexOf(';');
                            if (formatEnd > 0)
                            {
                                string format = base64Check.Substring(11, formatEnd - 11);
                                contentType = "image/" + format;
                                formatDetection = "base64-" + format;
                                
                                // Try to extract the actual binary data
                                int dataStart = base64Check.IndexOf("base64,");
                                if (dataStart > 0)
                                {
                                    string fullString = System.Text.Encoding.ASCII.GetString(imgBytes);
                                    dataStart += 7; // length of "base64,"
                                    try {
                                        string base64Data = fullString.Substring(dataStart);
                                        imgBytes = Convert.FromBase64String(base64Data);
                                        context.Response.AppendHeader("X-Debug-Base64Converted", "true");
                                    }
                                    catch (Exception ex) {
                                        context.Response.AppendHeader("X-Debug-Base64Error", ex.Message);
                                    }
                                }
                            }
                        }
                    }
                }
                
                context.Response.AppendHeader("X-Debug-FormatDetection", formatDetection);
                
                // Log the first few bytes to debug header
                string bytePreview = string.Empty;
                for (int i = 0; i < Math.Min(16, imgBytes.Length); i++)
                {
                    bytePreview += imgBytes[i].ToString("X2") + " ";
                }
                context.Response.AppendHeader("X-Debug-BytePreview", bytePreview.Trim());
                context.Response.AppendHeader("X-Debug-ContentType", contentType);
                
                // Set all needed HTTP headers
                context.Response.ContentType = contentType;
                context.Response.AppendHeader("Content-Length", imgBytes.Length.ToString());
                
                // Add cache control headers to prevent browser caching issues
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                context.Response.Cache.SetNoStore();
                context.Response.AppendHeader("Pragma", "no-cache");
                context.Response.AppendHeader("Expires", "0");
                
                // Write the binary data
                context.Response.BinaryWrite(imgBytes);
                context.Response.Flush();
                context.Response.End();
            }
            else
            {
                // Serve default image if no profile picture is found
                string defaultImagePath = context.Server.MapPath("~/Assest/Images/user.png");
                if (File.Exists(defaultImagePath))
                {
                    byte[] defaultImageBytes = File.ReadAllBytes(defaultImagePath);
                    context.Response.ContentType = "image/png";
                    context.Response.AppendHeader("Content-Length", defaultImageBytes.Length.ToString());
                    context.Response.AppendHeader("X-Debug-UsingDefaultImage", "true");
                    
                    // Add cache control headers for default image too
                    context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    context.Response.Cache.SetNoStore();
                    context.Response.AppendHeader("Pragma", "no-cache");
                    context.Response.AppendHeader("Expires", "0");
                    
                    context.Response.BinaryWrite(defaultImageBytes);
                    context.Response.Flush();
                    context.Response.End();
                }
                else
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("Error: No profile image found for user ID: " + userId);
                    context.Response.StatusCode = 404;
                }
            }
        }
        catch (Exception ex)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Error: " + ex.Message);
            context.Response.StatusCode = 500;
        }
    }
 
    public bool IsReusable 
    {
        get { return false; }
    }
}
