<%@ WebHandler Language="C#" Class="SimpleHandler" %>

using System;
using System.Web;

public class SimpleHandler : IHttpHandler {
    
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Simple Handler is working! Current time: " + DateTime.Now.ToString());
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
