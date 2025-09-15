<%@ WebHandler Language="C#" Class="LmsSimpleUserApi" %>

using System;
using System.Web;

public class LmsSimpleUserApi : IHttpHandler {
    
    public void ProcessRequest(HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("This is a simple test of an API handler. Current time: " + DateTime.Now.ToString());
    }
    
    public bool IsReusable {
        get { return false; }
    }
}
