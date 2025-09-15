<%@ WebHandler Language="C#" Class="MiniTestHandler" %>

using System;
using System.Web;

public class MiniTestHandler : IHttpHandler {
    
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Test handler is working!");
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
