<%@ WebHandler Language="C#" Class="SimpleUserAPI" %>

using System;
using System.Web;

public class SimpleUserAPI : IHttpHandler {
    
    public void ProcessRequest(HttpContext context) {
        try {
            context.Response.ContentType = "text/plain";
            context.Response.Write("SimpleUserAPI is working! Current time: " + DateTime.Now.ToString());
        }
        catch (Exception ex) {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Error: " + ex.Message + "\n\n" + ex.StackTrace);
        }
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
