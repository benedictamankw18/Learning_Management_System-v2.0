using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace Learning_Management_System
{
    public class Global : System.Web.HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            // Simplified to basic functionality
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            // Code that runs at the beginning of each request
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            // Code that runs when a user is being authenticated
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
            Exception lastError = Server.GetLastError();
            if (lastError != null)
            {
                // Log error if needed
                // Server.ClearError();
            }
        }
    }
}