<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Resent.aspx.cs" Inherits="Learning_Management_System.Resent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title> UNIVERSITY OF EDUCATION - RESENT </title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
      rel="stylesheet"
    />
    <link rel="icon" href="../../Assest/Images/uew_logo.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css"/>
     <link rel="stylesheet" href="../../Assest/css/style.css" />
    <link rel="stylesheet" href="../../Assest/css/reset.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="resent-container-main">
      <div class="resent-container">
        <div class="logo-container">
          <img id="ImgLogo" src="../../Assest/images/uew_logo.png" alt="UEW REGISTER" />
          <label id="lblLogo"> RESET SENT </label>
        </div>
        <div class="resent-form">
          <p class="resent-text">
            A reset link has been sent to your email address.
            <br />
            Please check your inbox and follow the instructions to reset your
            password.
            <br />
            If you do not receive the email, please check your spam folder or
            contact support.
            <br />
            <br />
            <a href="Login.aspx" id="lnkLogin">Click here to login</a>
            <br />

            <br />
          </p>
        </div>
      </div>
    </div>
    </form>
</body>
</html>
