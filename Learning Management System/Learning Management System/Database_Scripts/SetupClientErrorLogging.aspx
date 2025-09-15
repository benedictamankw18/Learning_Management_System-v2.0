<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SetupClientErrorLogging.aspx.cs" Inherits="Learning_Management_System.Database_Scripts.SetupClientErrorLogging" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Setup Client Error Logging</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .success {
            color: green;
            font-weight: bold;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        pre {
            background-color: #f5f5f5;
            padding: 10px;
            border: 1px solid #ddd;
            overflow-x: auto;
        }
        .header {
            background-color: #2c2b7c;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .container {
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>Setup Client Error Logging System</h1>
        </div>
        
        <div class="container">
            <h2>Database Setup Result</h2>
            <asp:Literal ID="litResult" runat="server"></asp:Literal>
            
            <hr />
            
            <h2>SQL Script Output</h2>
            <pre><asp:Literal ID="litSqlOutput" runat="server"></asp:Literal></pre>
            
            <p>
                <asp:Button ID="btnRunScript" runat="server" Text="Run SQL Script" OnClick="btnRunScript_Click" />
                <asp:Button ID="btnBackToAdmin" runat="server" Text="Back to Admin" OnClick="btnBackToAdmin_Click" />
            </p>
        </div>
    </form>
</body>
</html>
