<%@ WebHandler Language="C#" Class="TestHandler" %>

using System;
using System.Web;

public class TestHandler : IHttpHandler {
    
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World from Test Handler!");
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }
}
