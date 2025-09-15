<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Debug Handler Types</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Debug Handler Types</h1>
            <pre>
<%= "ProfileImageHandler Type: " + typeof(Learning_Management_System.authUser.Admin.ProfileImageHandler).FullName %>
<%= "UserAPI Type: " + typeof(Learning_Management_System.authUser.Admin.UserAPI).FullName %>
<%= "APIDocumentation Type: " + typeof(Learning_Management_System.authUser.Admin.APIDocumentation).FullName %>
            </pre>
        </div>
    </form>
</body>
</html>
