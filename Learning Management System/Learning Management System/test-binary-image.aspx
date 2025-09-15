<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Display the handler URL for reference
            string userId = "1008"; // Example user ID
            handlerUrl.Text = "/authUser/Admin/ProfileImageHandler.ashx?UserID=" + userId;
            
            // Also load and display the binary data directly
            LoadImageDataDirectly(userId);
        }
    }
    
    private void LoadImageDataDirectly(string userId)
    {
        try
        {
            string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT Picture FROM User_Profile WHERE UserID = @UserID";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    byte[] imageData = (byte[])command.ExecuteScalar();
                    
                    if (imageData != null && imageData.Length > 0)
                    {
                        imgLength.Text = "Image data length: " + imageData.Length + " bytes";
                        
                        // Convert the first few bytes to hex for analysis
                        string hexString = BitConverter.ToString(imageData, 0, Math.Min(20, imageData.Length));
                        hexPreview.Text = "First 20 bytes (hex): " + hexString;
                        
                        // Detect content type based on file signatures
                        string contentType = "unknown";
                        if (imageData.Length >= 2)
                        {
                            if (imageData[0] == 0xFF && imageData[1] == 0xD8) // JPEG
                            {
                                contentType = "image/jpeg";
                            }
                            else if (imageData.Length >= 8 && 
                                imageData[0] == 0x89 && imageData[1] == 0x50 && 
                                imageData[2] == 0x4E && imageData[3] == 0x47) // PNG
                            {
                                contentType = "image/png";
                            }
                            else if (imageData.Length >= 3 && 
                                imageData[0] == 0x47 && imageData[1] == 0x49 && 
                                imageData[2] == 0x46) // GIF
                            {
                                contentType = "image/gif";
                            }
                            else if (imageData.Length >= 2 && 
                                imageData[0] == 0x42 && imageData[1] == 0x4D) // BMP
                            {
                                contentType = "image/bmp";
                            }
                        }
                        
                        detectedType.Text = "Detected content type: " + contentType;
                        
                        // Convert to base64 for direct display
                        string base64String = Convert.ToBase64String(imageData);
                        directImg.ImageUrl = "data:" + contentType + ";base64," + base64String;
                        
                        // Create a hidden field with the base64 data for testing in JavaScript
                        hiddenBase64.Value = base64String;
                        hiddenContentType.Value = contentType;
                    }
                    else
                    {
                        imgLength.Text = "No image data found for user ID: " + userId;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            imgLength.Text = "Error: " + ex.Message;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profile Image Test Page</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .section { margin-bottom: 20px; padding: 10px; border: 1px solid #ccc; }
        .image-container { margin-top: 10px; }
        .image-container img { max-width: 200px; border: 1px solid #ddd; }
        h3 { margin-top: 0; }
        .debug-info { font-family: monospace; margin: 10px 0; }
        #js-tests { margin-top: 20px; }
        .test-result { margin: 10px 0; padding: 5px; background-color: #f5f5f5; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Profile Image Debugging Page</h1>
        
        <div class="section">
            <h3>Handler URL Test</h3>
            <p>Handler URL: <asp:Label ID="handlerUrl" runat="server" CssClass="debug-info"></asp:Label></p>
            <div class="image-container">
                <p>Image loaded via handler:</p>
                <img src="" id="handlerImg" alt="User profile image from handler" onload="imageLoaded(this)" onerror="handleImageError(this)" />
                <div id="errorInfo"></div>
            </div>
        </div>
        
        <div class="section">
            <h3>Direct Database Load Test</h3>
            <asp:Label ID="imgLength" runat="server" CssClass="debug-info"></asp:Label><br />
            <asp:Label ID="hexPreview" runat="server" CssClass="debug-info"></asp:Label><br />
            <asp:Label ID="detectedType" runat="server" CssClass="debug-info"></asp:Label>
            <div class="image-container">
                <p>Image loaded directly from database (base64):</p>
                <asp:Image ID="directImg" runat="server" AlternateText="User profile image direct from DB" />
            </div>
        </div>
        
        <div id="js-tests" class="section">
            <h3>JavaScript Tests</h3>
            <div id="testResults"></div>
            <div class="image-container">
                <p>JS-generated image (using base64 data):</p>
                <img id="jsImg" alt="JavaScript generated image" />
            </div>
        </div>
        
        <asp:HiddenField ID="hiddenBase64" runat="server" />
        <asp:HiddenField ID="hiddenContentType" runat="server" />
    </form>
    
    <script>
        // Set the handler image source when the page loads
        window.onload = function() {
            // Get handler URL from the page
            var handlerUrl = document.getElementById('handlerUrl').innerText;
            addTestResult("Setting image source to: " + handlerUrl);
            document.getElementById('handlerImg').src = handlerUrl;
            
            // Create image from base64 data
            testBase64Image();
        };
        
        // Track if an image successfully loaded
        function imageLoaded(img) {
            addTestResult("✅ Image loaded successfully: " + img.src);
            
            // Display image dimensions
            addTestResult("Image dimensions: " + img.naturalWidth + "x" + img.naturalHeight);
            
            // Check if the image has valid dimensions
            if (img.naturalWidth === 0 || img.naturalHeight === 0) {
                addTestResult("⚠️ WARNING: Image loaded but has zero dimensions!");
            }
        }
        
        // Handle image load errors with retries
        var retryCount = 0;
        function handleImageError(img) {
            const errorDiv = document.getElementById('errorInfo');
            addTestResult("❌ Image error occurred. Current src: " + img.src);
            
            if (retryCount < 3) {
                retryCount++;
                errorDiv.innerHTML += "<p>Retry attempt " + retryCount + "...</p>";
                
                // Add retry parameter to avoid cache
                var srcParts = img.src.split('?');
                var baseUrl = srcParts[0];
                var params = srcParts.length > 1 ? srcParts[1] : '';
                
                // Parse parameters
                var urlParams = new URLSearchParams(params);
                var userId = urlParams.get('UserID');
                
                // Construct new URL
                var newSrc = baseUrl + "?UserID=" + userId + "&retry=" + retryCount;
                addTestResult("Retrying with: " + newSrc);
                img.src = newSrc;
            } else {
                errorDiv.innerHTML += "<p>Failed after " + retryCount + " retries. Original src: " + img.src + "</p>";
                addTestResult("Failed after " + retryCount + " retries");
                
                // Display a placeholder image
                img.src = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDAiIGhlaWdodD0iMTAwIiB2aWV3Qm94PSIwIDAgMTAwIDEwMCI+PHJlY3Qgd2lkdGg9IjEwMCIgaGVpZ2h0PSIxMDAiIGZpbGw9IiNlMWUxZTEiLz48dGV4dCB4PSI1MCIgeT0iNTAiIGZvbnQtc2l6ZT0iMTgiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGFsaWdubWVudC1iYXNlbGluZT0ibWlkZGxlIiBmb250LWZhbWlseT0ibW9ub3NwYWNlIiBmaWxsPSIjODg4ODg4Ij5ObyBJbWFnZTwvdGV4dD48L3N2Zz4=';
            }
        }
        
        // Test direct creation of image from base64
        function testBase64Image() {
            var base64 = document.getElementById('hiddenBase64').value;
            var contentType = document.getElementById('hiddenContentType').value;
            
            if (base64 && contentType) {
                addTestResult("Testing direct base64 image creation");
                var img = document.getElementById('jsImg');
                img.onload = function() {
                    addTestResult("✅ Base64 image loaded successfully");
                    addTestResult("Base64 image dimensions: " + img.naturalWidth + "x" + img.naturalHeight);
                };
                img.onerror = function() {
                    addTestResult("❌ Base64 image failed to load");
                };
                img.src = "data:" + contentType + ";base64," + base64;
            } else {
                addTestResult("❌ No base64 data available for testing");
            }
        }
        
        // Helper function to add test results
        function addTestResult(message) {
            var resultsDiv = document.getElementById('testResults');
            var timestamp = new Date().toLocaleTimeString();
            resultsDiv.innerHTML += '<div class="test-result">[' + timestamp + '] ' + message + '</div>';
        }
    </script>
</body>
</html>
