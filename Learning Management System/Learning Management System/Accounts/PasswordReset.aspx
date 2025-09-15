<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PasswordReset.aspx.cs" Inherits="Learning_Management_System.Accounts.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
      rel="stylesheet"
    />
    <link rel="icon" href="../Assest/Images/uew_logo.ico" type="image/x-icon" />
        <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css"/>
    <link rel="stylesheet" href="../Assest/css/style.css" />
    <link rel="stylesheet" href="../Assest/css/PasswordReset.css" />
    <script src="../Assest/js/script.js"></script>
</head>
<body>
    <form id="FrmPasswordResent" runat="server">
      <div class="PasswordResent-container">
        <div class="logo-container">
          <img id="ImgLogo" src="../Assest/Images/uew_logo.png" alt="UEW LOGIN" />
          <label id="lblLogo" runat="server">RESET PASSWORD</label>
        </div>
        <div class="PasswordResent-form">
          <div class="form-Password">
            <label for="txtPassword" class="lblPasswordClass">Password</label>
            <div class="input-container">
              <i class="fa fa-lock icon icon-input"></i>
              <asp:TextBox 
                runat="server"
                TextMode="Password"
                ID="txtPassword"
                placeholder="Enter your Password"
                title="Enter your Password"
              />
              <i
                class="fa fa-eye togglePassword"
                id="togglePassword"
                onclick="togglePasswordVisibility()"
                title="Toggle Password Visibility"
              ></i>
            </div>
          </div>
          <div class="form-ConfirmPassword">
            <label for="txtConfirmPassword" class="lblConfirmPasswordClass"
              >Confirm Password</label
            >
            <div class="input-container">
              <i class="fa fa-lock icon icon-input"></i>
                <asp:TextBox
                runat="server"
                TextMode="Password"
                ID="txtConfirmPassword"
                placeholder="Enter your Confirm Password"
                title="Enter your Confirm Password"
              />
                   <i
                class="fa fa-eye togglePassword"
                id="toggleCPassword"
                onclick="toggleCPasswordVisibility()"
                title="Toggle Password Visibility"
              ></i>
            </div>
          </div>

          <div class="from-Submit">
            <asp:Button
              runat="server"
              ID="btnReset"
              class="btnReset"
              Text="RESET PASSWORD"
              OnClick="btnReset_Click"
            />
          </div>
          
          <div class="message-container">
              <asp:Label ID="lblMessage" class runat="server" CssClass="message"></asp:Label>
          </div>

          <div class="form-version">
            <span id="lblVersion" runat="server"></span>
            <span>Version 1.0</span>
          </div>
        </div>
      </div>
    </form>
    <script src="../Assest/js/script.js">
    </script>
</body>
</html>
