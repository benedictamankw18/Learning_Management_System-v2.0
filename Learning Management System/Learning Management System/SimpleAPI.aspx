<%@ Page Language="C#" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        // Set content type to JSON
        Response.ContentType = "application/json";
        
        // Create a simple response object
        var data = new { 
            success = true, 
            message = "API is working!",
            users = new[] {
                new { id = 1, name = "John Doe", email = "john@example.com" },
                new { id = 2, name = "Jane Smith", email = "jane@example.com" }
            }
        };
        
        // Serialize to JSON
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        Response.Write(serializer.Serialize(data));
        Response.End();
    }
</script>
