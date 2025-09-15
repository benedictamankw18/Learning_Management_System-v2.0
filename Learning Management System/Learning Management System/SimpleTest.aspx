<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Diagnostics" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Simple Test Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Simple Test Page</h1>
            <p>If you can see this page, basic ASP.NET is working.</p>
            
            <asp:Label ID="lblInfo" runat="server" Text=""></asp:Label>
            
            <script runat="server">
                protected void Page_Load(object sender, EventArgs e)
                {
                    try
                    {
                        lblInfo.Text = "Page loaded successfully at " + DateTime.Now.ToString();
                        
                        // Output some basic information
                        Response.Write("<p>Server OS: " + Environment.OSVersion.ToString() + "</p>");
                        Response.Write("<p>.NET Version: " + Environment.Version.ToString() + "</p>");
                        Response.Write("<p>Request Path: " + Request.Path + "</p>");
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<p>Error: " + ex.Message + "</p>");
                        if (ex.InnerException != null)
                        {
                            Response.Write("<p>Inner Error: " + ex.InnerException.Message + "</p>");
                        }
                        Response.Write("<pre>" + ex.StackTrace + "</pre>");
                    }
                }
            </script>
        </div>
    </form>
</body>
</html>
