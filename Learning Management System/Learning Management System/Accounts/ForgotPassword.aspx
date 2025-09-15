<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="Learning_Management_System.ForgotPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UNIVERSITY OF EDUCATION - FORGOT PASSWORD</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
      rel="stylesheet"
    />
    <link rel="icon" href="../../Assest/Images/uew_logo.ico" type="image/x-icon" />
       <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css"/>
     <link rel="stylesheet" href="../../Assest/css/style.css" />
    <link rel="stylesheet" href="../../Assest/css/forgotPassword.css" />
    <style>
      #lblMessage{
        color: red;
        font-weight: bold;
      }
    </style>
</head>
<body>
    <form id="FrmForgotPassword" runat="server">
      <div class="forgot-password-container">
        <div class="logo-container">
          <img
            id="ImgLogo"
            src="../../Assest/images/uew_logo.png"
            alt="UEW FORGOT PASSWORD"
          />
          <label id="lblLogo">FORGOT PASSWORD</label>
        </div>
        <div class="forgot-password-form">
          <p class="forgot-password-text">
            Please enter your email address to reset your password.
            <br />
            You will receive an email with instructions to reset your password.
            <br />
            Check your spam folder if you do not receive it within a few
            minutes.
          </p>
          <div class="form-Email">
            <asp:label for="txtEmail" runat="server" class="lblEmailClass">Email</asp:label>
            <div class="input-container">
              <i class="fa fa-envelope"></i>
              <asp:Textbox runat="server"
                type="text"
                id="txtEmail"
                name="txtEmail"
                title="Enter your email"
                placeholder="Enter your email"
              />
            </div>
          </div>
          <div class="form-Submit">
              <asp:Button runat="server" type="submit" id="btnSubmit" Text="Send" class="btnSubmit" OnClick="btnSubmit_Click" />
          </div>
          <div class="message-container">
              <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
          </div>
        </div>
      </div>
    </form>
</body>
</html>
