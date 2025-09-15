<%@ WebHandler Language="C#" Class="SimpleTest" %>

using System;
using System.Web;

public class SimpleTest : IHttpHandler {
    
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World! This is SimpleTest handler working.");
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
