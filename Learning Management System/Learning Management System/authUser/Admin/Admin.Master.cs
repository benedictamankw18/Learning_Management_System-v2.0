using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using Learning_Management_System.Helpers;
using System.Web.Services;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        string adminId = HttpContext.Current.Session["UserID"]?.ToString();
        //string adminId = "";
        string adminName = HttpContext.Current.Session["FullName"]?.ToString() ?? "Administrator";
        string adminEmail = HttpContext.Current.Session["Email"]?.ToString();
        string AdminProfile = HttpContext.Current.Session["ProfilePicture"]?.ToString();
        string adminRole = HttpContext.Current.Session["UserType"]?.ToString() ?? "Admin";

        protected void Page_Load(object sender, EventArgs e)
        {
            try 
            {
                // Check if user is authenticated as admin
                if (Session["Admin"] == null)
                {
                    Response.Redirect("~/Accounts/Login.aspx");
                    return;
                }

                if (!IsPostBack)
                {
                    //if (Session["UserType"] != null)
                    //{
                    //    if (!Session["UserType"].ToString().ToLower().Equals("admin"))
                    //    {
                    //        Response.Redirect("~/Accounts/Login.aspx");
                    //        return;
                    //    }
                    //}
                    LoadAdminProfile();
                    SetActiveMenuItem();
                    RegisterStartupScripts();
                    RegisterErrorHandlingScripts();
                }
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Critical error in Admin.Master Page_Load", ex);
                RegisterErrorRecoveryScript();
            }
        }
        
        private void RegisterErrorRecoveryScript()
        {
            // This script will detect if the page has loaded correctly and refresh if needed
            string script = @"
                document.addEventListener('DOMContentLoaded', function() {
                    try {
                        // Add a flag to session storage to prevent infinite refresh loops
                        const refreshAttempts = sessionStorage.getItem('refreshAttempts') || 0;
                        
                        if (parseInt(refreshAttempts) < 3) {
                            sessionStorage.setItem('refreshAttempts', parseInt(refreshAttempts) + 1);
                            
                            // Check if critical DOM elements exist
                            const sidebar = document.getElementById('sidebar');
                            const header = document.getElementById('header');
                            const loadingOverlay = document.getElementById('loadingOverlay');
                            
                            if (!sidebar || !header || !loadingOverlay) {
                                // Critical elements missing, show error and refresh
                                if (typeof Swal !== 'undefined') {
                                    Swal.fire({
                                        title: 'Page Load Error',
                                        text: 'An error occurred while loading some functionality. The page will refresh automatically.',
                                        icon: 'error',
                                        allowOutsideClick: false,
                                        allowEscapeKey: false,
                                        showConfirmButton: false,
                                        timer: 3000,
                                        timerProgressBar: true
                                    }).then(() => {
                                        window.location.reload();
                                    });
                                } else {
                                    alert('An error occurred while loading some functionality. The page will refresh automatically.');
                                    window.location.reload();
                                }
                            } else {
                                // Page loaded successfully, reset refresh attempts
                                sessionStorage.setItem('refreshAttempts', 0);
                            }
                        } else {
                            // Too many refresh attempts, show manual refresh option
                            if (typeof Swal !== 'undefined') {
                                Swal.fire({
                                    title: 'Persistent Page Load Error',
                                    text: 'There seems to be a problem loading the page. Would you like to try clearing your browser cache and refreshing?',
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonText: 'Yes, refresh page',
                                    cancelButtonText: 'No, continue anyway',
                                    allowOutsideClick: false,
                                    allowEscapeKey: false
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        sessionStorage.clear();
                                        window.location.reload(true);
                                    } else {
                                        // Reset counter but don't refresh
                                        sessionStorage.setItem('refreshAttempts', 0);
                                    }
                                });
                            } else {
                                if (confirm('There seems to be a problem loading the page. Would you like to try clearing your browser cache and refreshing?')) {
                                    sessionStorage.clear();
                                    window.location.reload(true);
                                } else {
                                    sessionStorage.setItem('refreshAttempts', 0);
                                }
                            }
                        }
                    } catch (error) {
                        console.error('Error in recovery script:', error);
                        // Last resort - basic reload
                        setTimeout(() => window.location.reload(), 5000);
                    }
                });
            ";
            
            Page.ClientScript.RegisterStartupScript(this.GetType(), "ErrorRecoveryScript", script, true);
        }

        private void LoadAdminProfile()
        {
            try
            {
              
                // Update profile information in the UI
                Page.ClientScript.RegisterStartupScript(this.GetType(), "UpdateProfile", 
                    $@"
                    document.addEventListener('DOMContentLoaded', function() {{
                        const usernameElement = document.querySelector('.profile-username');
                        if (usernameElement) {{
                            usernameElement.textContent = '{adminName}';
                        }}
                        
                        // Update profile dropdown info
                        updateProfileDropdown('{adminName}', '{adminEmail}', '{adminRole}');
                    }});
                    ", true);

                // Get notification count
                int notificationCount = GetUnreadNotificationCount(adminId);
                LoadMasterContent();

                if (notificationCount > 0)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "UpdateNotifications",
                        $@"
                        document.addEventListener('DOMContentLoaded', function() {{
                            updateNotificationBadge({notificationCount});
                        }});
                        ", true);
                }
            }
            catch (Exception ex)
            {
                // Log error
               ActivityLogger.LogError("Error loading admin profile", ex);
            }
        }

        private void LoadMasterContent()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    string query = @"select ProfilePicture from Users where UserID = @UserId;";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserId", adminId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                if(reader["ProfilePicture"] != DBNull.Value)
                                {
                                    // Convert the binary data to a base64 string for display in an img tag
                                    byte[] imageData = (byte[])reader["ProfilePicture"];
                                    string base64String = Convert.ToBase64String(imageData);
                                    string imgSrc = "data:image/jpeg;base64," + base64String;
                                    
                                    // Update the profile picture using JavaScript since we can't directly access the img control
                                    Page.ClientScript.RegisterStartupScript(this.GetType(), "UpdateProfilePic", 
                                        $@"
                                        document.addEventListener('DOMContentLoaded', function() {{
                                            const profileImg = document.querySelector('.User-Profile');
                                            if (profileImg) {{
                                                profileImg.src = '{imgSrc}';
                                            }}
                                        }});
                                        ", true);
                                }
                            }
                        }
                        }
                }
            }
            catch (Exception)
            {
                // Log error if needed
            }
        }

        private void SetActiveMenuItem()
        {
            try
            {
                string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath).ToLower();
                
                Page.ClientScript.RegisterStartupScript(this.GetType(), "SetActiveMenu",
                    $@"
                    document.addEventListener('DOMContentLoaded', function() {{
                        setActiveMenuByPage('{currentPage}');
                    }});
                    ", true);
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Error setting active menu item", ex);
            }
        }

        private void RegisterStartupScripts()
        {
            // Register global JavaScript functions
            string script = @"
                // Global functions for master page
                function updateProfileDropdown(name, email, role) {
                    const dropdown = document.querySelector('.drop-profile');
                    if (dropdown) {
                        // Update profile link with actual data
                        const profileLink = dropdown.querySelector('a[href*=""Profile""]');
                        if (profileLink) {
                            profileLink.href = 'Profile.aspx';
                        }
                        
                        // Update dashboard link
                        const dashboardLink = dropdown.querySelector('a[href*=""Dashboard""]');
                        if (dashboardLink) {
                            dashboardLink.href = 'Dashboard.aspx';
                        }
                        
                        // Update settings link
                        const settingsLink = dropdown.querySelector('a[href*=""Settings""]');
                        if (settingsLink) {
                            settingsLink.href = 'Settings.aspx';
                        }
                        
                        // Update notifications link
                        const notificationsLink = dropdown.querySelector('a[href*=""Notifications""]');
                        if (notificationsLink) {
                            notificationsLink.href = 'Notifications.aspx';
                        }
                    }
                }
                
                function updateNotificationBadge(count) {
                    const badge = document.querySelector('.notification-badge');
                    if (badge) {
                        badge.textContent = count;
                        badge.style.display = count > 0 ? 'flex' : 'none';
                    }
                }
                
                function setActiveMenuByPage(currentPage) {
                    const menuItems = document.querySelectorAll('.menu-item');
                    menuItems.forEach(item => {
                        item.classList.remove('active');
                        const href = item.getAttribute('href');
                        if (href && href.toLowerCase().includes(currentPage.replace('.aspx', ''))) {
                            item.classList.add('active');
                        }
                    });
                }
                
                function performGlobalSearch() {
                    const searchInput = document.getElementById('globalSearch');
                    if (!searchInput) return;
                    
                    const query = searchInput.value.trim();
                    if (!query) {
                        showToast('Please enter a search term', 'warning');
                        return;
                    }
                    
                    showLoading();
                    
                    // Perform AJAX search
                    fetch('AdminMaster.aspx/PerformGlobalSearch', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ query: query })
                    })
                    .then(response => response.json())
                    .then(data => {
                        hideLoading();
                        if (data.d && data.d.success) {
                            displaySearchResults(data.d.results);
                        } else {
                            showToast('Search failed. Please try again.', 'error');
                        }
                    })
                    .catch(error => {
                        hideLoading();
                        console.error('Search error:', error);
                        showToast('Search failed. Please try again.', 'error');
                    });
                }
                
                function displaySearchResults(results) {
                    if (results && results.length > 0) {
                        let resultsHtml = '<div class=""search-results"">';
                        results.forEach(result => {
                            resultsHtml += `
                                <div class=""search-result-item"">
                                    <h6>${result.Title}</h6>
                                    <p>${result.Description}</p>
                                    <a href=""${result.Url}"" class=""btn btn-sm btn-primary"">View</a>
                                </div>
                            `;
                        });
                        resultsHtml += '</div>';
                        
                        Swal.fire({
                            title: 'Search Results',
                            html: resultsHtml,
                            width: '600px',
                            confirmButtonColor: '#2c2b7c'
                        });
                    } else {
                        showToast('No results found', 'info');
                    }
                }
                
                function confirmLogout() {
                    Swal.fire({
                        title: 'Confirm Logout',
                        text: 'Are you sure you want to logout from the admin dashboard?',
                        icon: 'question',
                        showCancelButton: true,
                        confirmButtonColor: '#2c2b7c',
                        cancelButtonColor: '#666666',
                        confirmButtonText: '<i class=""fas fa-sign-out-alt""></i> Yes, Logout',
                        cancelButtonText: '<i class=""fas fa-times""></i> Cancel'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            performLogout();
                        }
                    });
                }
                
                function performLogout() {
                    showLoading();
                    
                    fetch('AdminMaster.aspx/PerformLogout', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.d && data.d.success) {
                            showToast('Logout successful', 'success');
                            setTimeout(() => {
                               // window.location.href = '../../Accounts/Login.aspx';
                            }, 1000);
                        } else {
                            hideLoading();
                            showToast('Logout failed. Please try again.', 'error');
                        }
                    })
                    .catch(error => {
                        hideLoading();
                        console.error('Logout error:', error);
                        showToast('Logout failed. Please try again.', 'error');
                    });
                }
                
                function showLoading() {
                    const overlay = document.getElementById('loadingOverlay');
                    if (overlay) {
                        overlay.classList.add('active');
                    }
                }
                
                function hideLoading() {
                    const overlay = document.getElementById('loadingOverlay');
                    if (overlay) {
                        overlay.classList.remove('active');
                    }
                }
                
                function showToast(message, type = 'info') {
                    if (typeof Swal !== 'undefined') {
                        const Toast = Swal.mixin({
                            toast: true,
                            position: 'top-end',
                            showConfirmButton: false,
                            timer: 3000,
                            timerProgressBar: true,
                            didOpen: (toast) => {
                                toast.addEventListener('mouseenter', Swal.stopTimer);
                                toast.addEventListener('mouseleave', Swal.resumeTimer);
                            }
                        });

                        Toast.fire({
                            icon: type,
                            title: message
                        });
                    }
                }
            ";

            Page.ClientScript.RegisterStartupScript(this.GetType(), "MasterPageFunctions", script, true);
        }
        
        private void RegisterErrorHandlingScripts()
        {
            // Register error handling scripts
            string errorHandlingScript = @"
                document.addEventListener('DOMContentLoaded', function() {
                    try {
                        // Set up global error handler
                        window.addEventListener('error', function(event) {
                            console.error('Global error caught:', event.error || event.message);
                            
                            // Log the error to server if available
                            try {
                                fetch('AdminMaster.aspx/LogClientError', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({ 
                                        message: event.message || 'Unknown error',
                                        source: event.filename || event.srcElement?.src || 'Unknown source',
                                        lineNumber: event.lineno || 0,
                                        columnNumber: event.colno || 0,
                                        stack: event.error?.stack || 'No stack trace'
                                    })
                                }).catch(e => console.error('Failed to log error:', e));
                            } catch (loggingError) {
                                console.error('Error in error logging:', loggingError);
                            }
                            
                            // Don't show error dialog for every error - we'll handle critical ones separately
                            return false;
                        });
                        
                        // Set up unhandled promise rejection handler
                        window.addEventListener('unhandledrejection', function(event) {
                            console.error('Unhandled promise rejection:', event.reason);
                            
                            // Log the error to server if available
                            try {
                                fetch('AdminMaster.aspx/LogClientError', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({ 
                                        message: 'Unhandled promise rejection: ' + (event.reason?.message || String(event.reason)),
                                        source: 'Promise rejection',
                                        stack: event.reason?.stack || 'No stack trace'
                                    })
                                }).catch(e => console.error('Failed to log promise rejection:', e));
                            } catch (loggingError) {
                                console.error('Error logging promise rejection:', loggingError);
                            }
                        });
                        
                        // Add a manual refresh button to the error overlay
                        const addRefreshButton = function() {
                            // If there's already an error message visible on the page
                            const errorDiv = document.createElement('div');
                            errorDiv.id = 'page-error-overlay';
                            errorDiv.style.cssText = 'position: fixed; bottom: 20px; right: 20px; background: #ff5555; color: white; padding: 15px; border-radius: 5px; z-index: 9999; box-shadow: 0 2px 10px rgba(0,0,0,0.2);';
                            errorDiv.innerHTML = `
                                <p><strong>Page Error Detected</strong></p>
                                <p>An error occurred while loading the page.</p>
                                <button id='refreshPageBtn' style='background: white; color: #333; border: none; padding: 8px 15px; border-radius: 3px; cursor: pointer;'>Refresh Page</button>
                            `;
                            document.body.appendChild(errorDiv);
                            
                            document.getElementById('refreshPageBtn').addEventListener('click', function() {
                                window.location.reload();
                            });
                        };
                        
                        // Check if page loaded completely within 10 seconds
                        const pageLoadTimeout = setTimeout(function() {
                            // If this executes, the DOM loaded but something might be wrong
                            if (document.readyState !== 'complete') {
                                console.error('Page did not completely load within timeout period');
                                addRefreshButton();
                            }
                        }, 10000);
                        
                        window.addEventListener('load', function() {
                            clearTimeout(pageLoadTimeout);
                        });
                        
                        // Add manual refresh option in case of error
                        if (document.getElementById('loadingOverlay')) {
                            const refreshButton = document.createElement('button');
                            refreshButton.textContent = 'Refresh Page';
                            refreshButton.style.cssText = 'position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); background: white; color: #333; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; display: none;';
                            refreshButton.addEventListener('click', function() {
                                window.location.reload();
                            });
                            document.getElementById('loadingOverlay').appendChild(refreshButton);
                            
                            // Show the refresh button if loading is visible for too long
                            setTimeout(function() {
                                const overlay = document.getElementById('loadingOverlay');
                                if (overlay && overlay.classList.contains('active')) {
                                    refreshButton.style.display = 'block';
                                }
                            }, 15000);
                        }
                    } catch (error) {
                        console.error('Error setting up error handlers:', error);
                    }
                });
            ";
            
            Page.ClientScript.RegisterStartupScript(this.GetType(), "ErrorHandlingScripts", errorHandlingScript, true);
        }

        private int GetUnreadNotificationCount(string adminId)
        {
            try
            {
                if (string.IsNullOrEmpty(adminId)) return 0;

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    string query = @"
                        SELECT COUNT(*) 
                        FROM Notifications 
                        WHERE (TargetUserId = @UserId OR TargetUserId IS NULL) AND IsRead = 0";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserId", adminId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return reader.GetInt32(0);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Error getting notification count", ex);
                return 0;
            }
            return 0;
        }


    [WebMethod]
    public static object PerformGlobalSearch(string query)
    {
        try
        {
            var results = new List<object>();
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
            {
                con.Open();
                string searchQuery = @"
                    SELECT 'User' as Type, UserId as Id, UserName as Title, Email as Description, 'User.aspx?id=' + CAST(UserId as VARCHAR) as Url
                    FROM Users 
                    WHERE UserName LIKE @Query OR Email LIKE @Query
                    UNION ALL
                    SELECT 'Course' as Type, CourseId as Id, CourseName as Title, CourseDescription as Description, 'Course.aspx?id=' + CAST(CourseId as VARCHAR) as Url
                    FROM Courses 
                    WHERE CourseName LIKE @Query OR CourseDescription LIKE @Query
                    UNION ALL
                    SELECT 'Material' as Type, MaterialId as Id, MaterialName as Title, Description as Description, 'Material.aspx?id=' + CAST(MaterialId as VARCHAR) as Url
                    FROM Materials 
                    WHERE MaterialName LIKE @Query OR Description LIKE @Query";
                using (var cmd = new SqlCommand(searchQuery, con))
                {
                    cmd.Parameters.AddWithValue("@Query", "%" + query + "%");
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            results.Add(new
                            {
                                Type = reader["Type"].ToString(),
                                Id = reader["Id"].ToString(),
                                Title = reader["Title"].ToString(),
                                Description = reader["Description"].ToString(),
                                Url = reader["Url"].ToString()
                            });
                        }
                    }
                }
            }
            return new { success = true, results = results };
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }

         [System.Web.Services.WebMethod]
        public static object PerformLogout()
        {
            try
            {
                // Log logout activity

                string email = HttpContext.Current.Session["Email"].ToString();
                string name = HttpContext.Current.Session["FullName"].ToString();
                string userid = HttpContext.Current.Session["UserID"].ToString();

                // Clear session
                HttpContext.Current.Session["Teacher"] = null;
                HttpContext.Current.Session["UserID"] = null;
                HttpContext.Current.Session["FullName"] = null;
                HttpContext.Current.Session["Email"] = null;
                HttpContext.Current.Session["UserType"] = null;
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();

                ActivityLogger.LogLoginActivity(email +" ("+userid+") ", "SuccessS");
                ActivityLogger.Log("UserLogout", name + " ("+userid+") " + " Logout on "+ DateTime.Now.ToShortDateString());
                return new { success = true };
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Error during logout", ex);
                return new { success = false, message = ex.Message };
            }
        }
        
        [System.Web.Services.WebMethod]
        public static object GetNotifications()
        {
            try
            {
                string adminId = HttpContext.Current.Session["UserID"]?.ToString();

                if (string.IsNullOrEmpty(adminId)) 
                    return new { success = false, message = "Not authenticated" };

                List<object> notifications = new List<object>();

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    string query = @"
                        SELECT TOP 10 
                            NotificationId,
                            Title,
                            Message,
                            NotificationType,
                            CreatedDate,
                            IsRead
                        FROM AdminNotifications 
                        WHERE AdminId = @AdminId AND IsActive = 1
                        ORDER BY CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@AdminId", adminId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                notifications.Add(new
                                {
                                    Id = reader["NotificationId"].ToString(),
                                    Title = reader["Title"].ToString(),
                                    Message = reader["Message"].ToString(),
                                    Type = reader["NotificationType"].ToString(),
                                    Date = Convert.ToDateTime(reader["CreatedDate"]).ToString("MMM dd, yyyy HH:mm"),
                                    IsRead = Convert.ToBoolean(reader["IsRead"])
                                });
                            }
                        }
                    }
                }

                return new { success = true, notifications = notifications };
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Error getting notifications", ex);
                return new { success = false, message = ex.Message };
            }
        }
        
        [System.Web.Services.WebMethod]
        public static object LogClientError(string message, string source = "", int lineNumber = 0, int columnNumber = 0, string stack = "")
        {
            try
            {
                // Sanitize input to prevent SQL injection or XSS
                message = HttpUtility.HtmlEncode(message ?? "No message");
                source = HttpUtility.HtmlEncode(source ?? "Unknown source");
                stack = HttpUtility.HtmlEncode(stack ?? "No stack trace");
                
                // Add browser info
                string userAgent = HttpContext.Current.Request.UserAgent ?? "Unknown user agent";
                string url = HttpContext.Current.Request.Url?.ToString() ?? "Unknown URL";
                string adminId = HttpContext.Current.Session["UserID"]?.ToString() ?? "Unknown user";
                
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString))
                {
                    con.Open();
                    string query = @"
                        INSERT INTO ClientErrorLogs 
                        (ErrorMessage, ErrorSource, LineNumber, ColumnNumber, StackTrace, 
                         UserAgent, PageUrl, AdminId, Timestamp) 
                        VALUES 
                        (@Message, @Source, @LineNumber, @ColumnNumber, @Stack, 
                         @UserAgent, @Url, @AdminId, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Message", message);
                        cmd.Parameters.AddWithValue("@Source", source);
                        cmd.Parameters.AddWithValue("@LineNumber", lineNumber);
                        cmd.Parameters.AddWithValue("@ColumnNumber", columnNumber);
                        cmd.Parameters.AddWithValue("@Stack", stack);
                        cmd.Parameters.AddWithValue("@UserAgent", userAgent);
                        cmd.Parameters.AddWithValue("@Url", url);
                        cmd.Parameters.AddWithValue("@AdminId", adminId);
                        cmd.ExecuteNonQuery();
                    }
                }
                
                return new { success = true };
            }
            catch (Exception ex)
            {
                // Just log to server logs if database logging fails
                System.Diagnostics.Debug.WriteLine($"Error logging client error: {ex.Message}");
                return new { success = false, message = ex.Message };
            }
        }

    }
}