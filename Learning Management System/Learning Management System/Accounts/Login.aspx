<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Learning_Management_System.Accounts.Login" EnableEventValidation="false" EnableViewState="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>UNIVERSITY OF EDUCATION - LOGIN</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap"
      rel="stylesheet"
    />
    <link rel="icon" href="../Assest/Images/uew_logo.ico" type="image/x-icon" />
        <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css"/>
    <link rel="stylesheet" href="../Assest/css/style.css" />
    <link rel="stylesheet" href="../Assest/css/login.css" />
    
    <!-- SweetAlert2 for better notifications -->
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    
        <script src="../Assest/js/script.js"></script>
</head>
    
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="logo-container">
                 <img id="ImgLogo" src="../Assest/Images/uew_logo.png" alt="UEW LOGIN" />
                <asp:Label ID="lblLogo" Text="LOGIN" runat="server"></asp:Label>
            </div>
            <div class="login-form">
          <div class="form-Email">
                <asp:Label ID="lblEmail" Text="Email" runat="server" class="lblEmailClass"></asp:Label>
           <div class="input-container">
                <i class="fa fa-user icon icon-input"></i>
                <asp:TextBox ID="txtEmail" runat="server" title="Enter your email" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
            </div>
            </div>

             <div class="form-Password">
                 <asp:Label ID="lblPassword" Text="Password" for="txtPassword" class="lblPasswordClass" runat="server" ></asp:Label>        
            <div class="input-container">
                <i class="fa fa-lock icon icon-input"></i>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" title="Enter your Password" placeholder="Enter your Password" CssClass="txtPassword"></asp:TextBox>
                  <i class="fa fa-eye togglePassword" id="togglePassword" onclick="togglePasswordVisibility()" title="Toggle Password Visibility"></i>
                </div>
          </div>
<div class="form-forgot-password">
      <a href="ForgotPassword.aspx" id="lnkForgotPassword"
              >Forgot Password?</a
            >
          </div>
                <div class="from-Submit">
                    <asp:Button ID="btnLogin" runat="server" Text="Login" title="Login" OnClick="btnLogin_Click" CssClass="btn-login" />
          </div>
                <div class="form-register">
            <span>Don't have an account? </span>
            <a href="Register.aspx" id="lnkRegister">Register</a>
          </div>
          <div class="form-test">
            <small style="color: #666; font-size: 12px;">
                Test Login: admin@test.com / admin123
            </small>
          </div>
          <div class="form-version">
            <span id="lblVersion" runat="server"></span>
          </div>
        </div>
        </div>
    </form>

    <script>
        // Password visibility toggle
        function togglePasswordVisibility() {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const toggleIcon = document.getElementById('togglePassword');
            
            if (passwordField && toggleIcon) {
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    passwordField.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }
        }

        // Form validation and submission
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('form1');
            const emailField = document.getElementById('<%= txtEmail.ClientID %>');
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const loginBtn = document.getElementById('<%= btnLogin.ClientID %>');

            // Real-time validation (visual feedback only, no popups)
            if (emailField) {
                emailField.addEventListener('blur', function() {
                    validateEmailFieldSilent(this);
                });
            }

            if (passwordField) {
                passwordField.addEventListener('blur', function() {
                    validatePasswordFieldSilent(this);
                });
            }
        });

        // Silent validation functions (only visual feedback, no popups)
        function validateEmailFieldSilent(field) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const isValid = emailRegex.test(field.value);
            
            if (field.value && !isValid) {
                field.style.borderColor = '#dc3545';
                showFieldError(field, 'Please enter a valid email address');
            } else {
                field.style.borderColor = '';
                removeFieldError(field);
            }
        }

        function validatePasswordFieldSilent(field) {
            if (field.value && field.value.length < 3) {
                field.style.borderColor = '#dc3545';
                showFieldError(field, 'Password must be at least 3 characters long');
            } else {
                field.style.borderColor = '';
                removeFieldError(field);
            }
        }

        // Popup validation functions (only called on form submit)
        function validateEmailField(field) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const isValid = emailRegex.test(field.value);
            
            if (field.value && !isValid) {
                field.style.borderColor = '#dc3545';
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Invalid Email',
                        text: 'Please enter a valid email address',
                        confirmButtonColor: '#2c2b7c',
                        confirmButtonText: 'OK'
                    });
                }
                return false;
            } else {
                field.style.borderColor = '';
                removeFieldError(field);
                return true;
            }
        }

        function validatePasswordField(field) {
            if (field.value && field.value.length < 3) {
                field.style.borderColor = '#dc3545';
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Password Too Short',
                        text: 'Password must be at least 3 characters long',
                        confirmButtonColor: '#2c2b7c',
                        confirmButtonText: 'OK'
                    });
                }
                return false;
            } else {
                field.style.borderColor = '';
                removeFieldError(field);
                return true;
            }
        }

        function showFieldError(field, message) {
            removeFieldError(field);
            const errorDiv = document.createElement('div');
            errorDiv.className = 'field-error';
            errorDiv.style.color = '#dc3545';
            errorDiv.style.fontSize = '12px';
            errorDiv.style.marginTop = '5px';
            errorDiv.textContent = message;
            
            // Insert after the input container
            const container = field.closest('.input-container');
            if (container && container.parentNode) {
                container.parentNode.insertBefore(errorDiv, container.nextSibling);
            }
        }

        function removeFieldError(field) {
            const container = field.closest('.input-container');
            if (container && container.parentNode) {
                const existingError = container.parentNode.querySelector('.field-error');
                if (existingError) {
                    existingError.remove();
                }
            }
        }

        // Handle Enter key press
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const loginBtn = document.getElementById('<%= btnLogin.ClientID %>');
                if (loginBtn && !loginBtn.disabled) {
                    loginBtn.click();
                }
            }
        });
    </script>
</body>
</html>