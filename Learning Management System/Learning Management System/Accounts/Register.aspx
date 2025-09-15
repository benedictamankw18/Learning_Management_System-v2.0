<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Learning_Management_System.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UNIVERSITY OF EDUCATION - REGISTER</title>
   <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
      rel="stylesheet"
    />
    <link rel="icon" href="../../Assest/Images/uew_logo.ico" type="image/x-icon" />
       <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css"/>
    <link rel="stylesheet" href="../../Assest/css/style.css" />
    <link rel="stylesheet" href="../../Assest/css/Register.css" />
</head>
<body>
    <form id="form1" runat="server">
       <div class="register-container-main">
      <div class="register-container">
        <div class="logo-container">
          <img id="ImgLogo" src="../../Assest/Images/uew_logo.png" alt="UEW REGISTER" />
          <label id="lblLogo">REGISTER</label>
        </div>
        <div class="register-form">
          <p class="register-text">
            Please visit the IT directortate to register for an account.
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
