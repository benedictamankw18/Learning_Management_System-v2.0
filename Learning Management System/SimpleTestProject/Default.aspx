<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>Simple Test Project</title>
</head>
<body>
    <h1>Simple Test Project</h1>
    <p>This is a basic ASPX page to test if the server is working correctly.</p>
    <p>Current time: <%= DateTime.Now.ToString() %></p>
    <p><a href="SimpleHandler.ashx">Test the Simple Handler</a></p>
</body>
</html>
