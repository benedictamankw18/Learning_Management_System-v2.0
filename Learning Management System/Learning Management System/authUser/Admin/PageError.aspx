<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PageError.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.PageError" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Page Error - University of Education, Winneba</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="../../Assest/css/bootstrap-5.2.3-dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.min.css" />
    
    <style>
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            background-color: #f8f9fa;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }
        
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .error-icon {
            font-size: 70px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        h1 {
            color: #2c2b7c;
            font-size: 28px;
            margin-bottom: 20px;
        }
        
        p {
            font-size: 16px;
            line-height: 1.6;
            color: #555;
            margin-bottom: 25px;
        }
        
        .btn-primary {
            background-color: #2c2b7c;
            border-color: #2c2b7c;
            padding: 10px 20px;
            font-weight: 500;
        }
        
        .btn-primary:hover {
            background-color: #23226a;
            border-color: #23226a;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            padding: 10px 20px;
            font-weight: 500;
        }
        
        .error-details {
            margin-top: 30px;
            text-align: left;
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 14px;
            overflow-x: auto;
            display: none;
        }
        
        .actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }
        
        .logo {
            max-width: 200px;
            margin: 0 auto 30px;
        }
        
        .error-code {
            display: inline-block;
            background: #f8f9fa;
            padding: 5px 10px;
            border-radius: 4px;
            font-family: monospace;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .info-box {
            background-color: #edf6ff;
            border-left: 4px solid #2c2b7c;
            padding: 15px;
            margin: 20px 0;
            border-radius: 0 4px 4px 0;
            text-align: left;
        }
        
        .info-box h4 {
            margin-top: 0;
            color: #2c2b7c;
            font-size: 18px;
        }
        
        .troubleshooting-steps {
            text-align: left;
            margin: 20px 0;
        }
        
        .troubleshooting-steps ol {
            padding-left: 20px;
        }
        
        .troubleshooting-steps li {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="error-container">
            <img src="../../Assest/Images/uewDash.png" alt="University of Education, Winneba" class="logo" />
            
            <div class="error-icon">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            
            <h1>Page Load Error</h1>
            
            <p>We're sorry, but there was a problem loading the page. This could be due to a temporary issue or a connectivity problem.</p>
            
            <div class="error-code">
                Error Code: <span id="errorCode">ERR_PAGE_LOAD</span>
            </div>
            
            <div class="info-box">
                <h4><i class="fas fa-info-circle"></i> What happened?</h4>
                <p>The page was unable to load properly. This could be caused by:</p>
                <ul>
                    <li>Temporary server issues</li>
                    <li>Browser cache problems</li>
                    <li>Network connectivity issues</li>
                    <li>Script loading errors</li>
                </ul>
            </div>
            
            <div class="troubleshooting-steps">
                <h4>Try these steps:</h4>
                <ol>
                    <li>Refresh the page <strong>(recommended first step)</strong></li>
                    <li>Clear your browser cache</li>
                    <li>Check your internet connection</li>
                    <li>Try using a different browser</li>
                    <li>Contact support if the problem persists</li>
                </ol>
            </div>
            
            <div class="actions">
                <button id="refreshButton" type="button" class="btn btn-primary">
                    <i class="fas fa-sync-alt"></i> Refresh Page
                </button>
                
                <button id="clearCacheButton" type="button" class="btn btn-secondary">
                    <i class="fas fa-broom"></i> Clear Cache & Refresh
                </button>
            </div>
            
            <div class="mt-4">
                <a href="Dashboard.aspx" class="btn btn-link">
                    <i class="fas fa-arrow-left"></i> Return to Dashboard
                </a>
            </div>
            
            <div id="errorDetails" class="error-details">
                <p><strong>Technical Details:</strong></p>
                <p id="errorMessage">No specific error details available.</p>
            </div>
        </div>
    </form>
    
    <!-- Bootstrap Bundle with Popper -->
    <script src="../../Assest/css/bootstrap-5.2.3-dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            const errorType = urlParams.get('error') || 'unknown';
            const errorMsg = urlParams.get('message') || 'No specific error details available.';
            
            // Update error code and message
            document.getElementById('errorCode').textContent = 'ERR_' + errorType.toUpperCase();
            document.getElementById('errorMessage').textContent = decodeURIComponent(errorMsg);
            
            // Show error details if available
            if (errorMsg && errorMsg !== 'No specific error details available.') {
                document.getElementById('errorDetails').style.display = 'block';
            }
            
            // Refresh button
            document.getElementById('refreshButton').addEventListener('click', function() {
                window.location.reload();
            });
            
            // Clear cache and refresh button
            document.getElementById('clearCacheButton').addEventListener('click', function() {
                // Attempt to clear cache by forcing a reload from server
                try {
                    // Clear some common storage mechanisms
                    localStorage.clear();
                    sessionStorage.clear();
                    
                    // Clear browser cache and reload
                    window.location.reload(true);
                } catch (error) {
                    console.error('Error clearing cache:', error);
                    
                    // Fallback to normal reload
                    window.location.reload();
                }
            });
            
            // Log the error to server if possible
            try {
                fetch('Admin.Master.cs/LogClientError', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ 
                        message: 'Page load error: ' + errorType,
                        source: window.location.href,
                        stack: errorMsg
                    })
                }).catch(e => console.error('Failed to log error:', e));
            } catch (loggingError) {
                console.error('Error logging to server:', loggingError);
            }
        });
    </script>
</body>
</html>
