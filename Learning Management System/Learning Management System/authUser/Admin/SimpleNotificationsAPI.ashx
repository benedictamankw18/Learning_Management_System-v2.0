<%@ WebHandler Language="C#" Class="Learning_Management_System.authUser.Admin.SimpleNotificationsAPI" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;

namespace Learning_Management_System.authUser.Admin
{
    public class SimpleNotificationsAPI : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            
            try
            {
                var notifications = new List<object>();
                
                notifications.Add(new { 
                    id = 1, 
                    title = "System Notification", 
                    message = "Welcome to the LMS", 
                    type = "info", 
                    createdDate = "2023-05-15 14:30:00", 
                    isRead = false 
                });
                
                var serializer = new JavaScriptSerializer();
                string json = serializer.Serialize(new { success = true, data = notifications });
                context.Response.Write(json);
            }
            catch (Exception ex)
            {
                var serializer = new JavaScriptSerializer();
                string json = serializer.Serialize(new { success = false, message = "Error: " + ex.Message });
                context.Response.Write(json);
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
