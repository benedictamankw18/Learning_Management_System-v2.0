<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test-image-debug.aspx.cs" Inherits="Learning_Management_System.test_image_debug" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profile Image Debug Tool</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f5f5f5;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        .debug-section {
            margin-bottom: 30px;
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 6px;
        }
        .header {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 10px;
            color: #2980b9;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        .row {
            display: flex;
            margin-bottom: 10px;
        }
        .label {
            min-width: 200px;
            font-weight: bold;
        }
        .value {
            flex: 1;
            word-break: break-word;
        }
        .monospace {
            font-family: monospace;
            background: #f8f8f8;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
            overflow-x: auto;
        }
        .byte-display {
            display: flex;
            flex-wrap: wrap;
            margin-top: 10px;
        }
        .byte {
            margin: 2px;
            padding: 4px 6px;
            background: #e9e9e9;
            border-radius: 3px;
            font-family: monospace;
            min-width: 24px;
            text-align: center;
        }
        .byte.header {
            background: #ffeaa7;
        }
        .image-preview {
            display: flex;
            margin-top: 20px;
            align-items: center;
        }
        .image-container {
            margin-right: 30px;
            text-align: center;
        }
        .image-container img {
            max-width: 150px;
            max-height: 150px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            background: white;
        }
        .user-info {
            display: flex;
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            align-items: center;
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-right: 20px;
            object-fit: cover;
            border: 3px solid #3498db;
        }
        .user-details {
            flex: 1;
        }
        .user-name {
            font-size: 20px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .user-role {
            color: #7f8c8d;
            margin-bottom: 10px;
        }
        .handler-url {
            color: #3498db;
            text-decoration: none;
        }
        .handler-url:hover {
            text-decoration: underline;
        }
        .button {
            padding: 8px 16px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .button:hover {
            background: #2980b9;
        }
        .button-group {
            margin-top: 15px;
        }
        .note {
            background: #ffeaa7;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Profile Image Debug Tool</h1>
        
        <form id="form1" runat="server">
            <div class="row">
                <div class="label">User ID:</div>
                <div class="value">
                    <asp:TextBox ID="UserIdInput" runat="server" Text="1008"></asp:TextBox>
                    <asp:Button ID="FetchButton" runat="server" Text="Fetch User Data" OnClick="FetchButton_Click" CssClass="button" />
                </div>
            </div>
            
            <asp:Panel ID="ResultsPanel" runat="server" Visible="false">
                <div class="user-info">
                    <asp:Image ID="UserAvatar" runat="server" CssClass="user-avatar" AlternateText="User Avatar" />
                    <div class="user-details">
                        <div class="user-name"><asp:Literal ID="UserName" runat="server"></asp:Literal></div>
                        <div class="user-role"><asp:Literal ID="UserRole" runat="server"></asp:Literal></div>
                        <div>Email: <asp:Literal ID="UserEmail" runat="server"></asp:Literal></div>
                        <div>Handler URL: <a href="#" id="handlerLink" runat="server" target="_blank" class="handler-url"></a></div>
                        <div class="button-group">
                            <asp:Button ID="InspectImagesButton" runat="server" Text="Analyze Images" OnClick="InspectImagesButton_Click" CssClass="button" />
                        </div>
                    </div>
                </div>
                
                <asp:Panel ID="DebugPanel" runat="server" Visible="false">
                    <div class="debug-section">
                        <div class="header">Users.ProfilePicture</div>
                        <div class="row">
                            <div class="label">Has Image Data:</div>
                            <div class="value"><asp:Literal ID="HasUsersProfilePic" runat="server"></asp:Literal></div>
                        </div>
                        <div class="row">
                            <div class="label">Size:</div>
                            <div class="value"><asp:Literal ID="UsersProfilePicSize" runat="server"></asp:Literal></div>
                        </div>
                        <div class="row">
                            <div class="label">Detected Format:</div>
                            <div class="value"><asp:Literal ID="UsersProfilePicFormat" runat="server"></asp:Literal></div>
                        </div>
                        <div class="row">
                            <div class="label">First 32 Bytes:</div>
                            <div class="value">
                                <div class="byte-display">
                                    <asp:Repeater ID="UsersProfilePicBytes" runat="server">
                                        <ItemTemplate>
                                            <div class='<%# ((int)Container.DataItem == 0 || (int)Container.DataItem == 1 || (int)Container.DataItem == 2) ? "byte header" : "byte" %>'>
                                                <%# DataBinder.Eval(Container, "DataItem", "{0:X2}") %>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div class="image-preview">
                            <div class="image-container">
                                <asp:Image ID="UsersProfilePicPreview" runat="server" AlternateText="Users.ProfilePicture Preview" />
                                <div>Direct Preview</div>
                            </div>
                            <div class="image-container">
                                <img id="usersHandlerPreview" runat="server" alt="Handler Preview (Users table)" />
                                <div>Handler Preview</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="debug-section">
                        <div class="header">User_Profile.Picture</div>
                        <div class="note" style="margin-bottom: 15px;">
                            <strong>Note:</strong> The User_Profile table does not exist in the database. This section is disabled.
                        </div>
                        <div class="row">
                            <div class="label">Has Image Data:</div>
                            <div class="value"><asp:Literal ID="HasUserProfilePic" runat="server"></asp:Literal></div>
                        </div>
                        <div class="row">
                            <div class="label">Size:</div>
                            <div class="value"><asp:Literal ID="UserProfilePicSize" runat="server"></asp:Literal></div>
                        </div>
                        <div class="row">
                            <div class="label">Detected Format:</div>
                            <div class="value"><asp:Literal ID="UserProfilePicFormat" runat="server"></asp:Literal></div>
                        </div>
                        <div class="row">
                            <div class="label">First 32 Bytes:</div>
                            <div class="value">
                                <div class="byte-display">
                                    <asp:Repeater ID="UserProfilePicBytes" runat="server">
                                        <ItemTemplate>
                                            <div class='<%# ((int)Container.DataItem == 0 || (int)Container.DataItem == 1 || (int)Container.DataItem == 2) ? "byte header" : "byte" %>'>
                                                <%# DataBinder.Eval(Container, "DataItem", "{0:X2}") %>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </div>
                        <div class="image-preview">
                            <div class="image-container">
                                <asp:Image ID="UserProfilePicPreview" runat="server" AlternateText="User_Profile.Picture Preview" />
                                <div>Direct Preview</div>
                            </div>
                            <div class="image-container">
                                <img id="profileHandlerPreview" runat="server" alt="Handler Preview (User_Profile table)" />
                                <div>Handler Preview</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="debug-section">
                        <div class="header">ASCII String Representation</div>
                        <div class="row">
                            <div class="label">Users.ProfilePicture:</div>
                            <div class="value">
                                <div class="monospace"><asp:Literal ID="UsersProfilePicString" runat="server"></asp:Literal></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="label">User_Profile.Picture:</div>
                            <div class="value">
                                <div class="monospace"><asp:Literal ID="UserProfilePicString" runat="server"></asp:Literal></div>
                                <div class="note" style="margin-top: 10px;">Table does not exist in database</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="note">
                        <strong>Note:</strong> If the first few bytes of the image data contain "data:image/" text,
                        this may indicate that a base64 encoded string was incorrectly stored in the database instead of
                        raw binary data. This can happen if the image was uploaded as a data URI and not properly decoded
                        before storage.
                    </div>
                </asp:Panel>
            </asp:Panel>
        </form>
    </div>
</body>
</html>
