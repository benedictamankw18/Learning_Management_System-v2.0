<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Settings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Settings - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.settings-container {
			padding: 2rem;
			background: #f8f9fa;
			min-height: 100vh;
		}
		.page-header {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			padding: 2.2rem 2rem 2rem 2rem;
			border-radius: 16px;
			margin-bottom: 2.5rem;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13);
			position: relative;
			overflow: hidden;
		}
		.page-header .fa {
			font-size: 2.2rem;
			margin-right: 1rem;
			opacity: 0.85;
		}
		.settings-grid {
			display: grid;
			grid-template-columns: 2fr 1fr;
			gap: 2rem;
		}
		.settings-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 2rem 1.5rem;
			margin-bottom: 2rem;
		}
		.settings-title {
			font-size: 1.25rem;
			font-weight: 600;
			margin-bottom: 1.2rem;
			color: #2c3e50;
			border-bottom: 2px solid #007bff;
			padding-bottom: 0.5rem;
		}
		.form-label {
			font-weight: 500;
			color: #2c3e50;
		}
		.form-control, .form-select {
			border-radius: 8px;
			font-size: 1rem;
		}
		.btn-primary {
			background: linear-gradient(135deg, #007bff, #0056b3);
			border: none;
			border-radius: 8px;
			font-weight: 500;
			transition: background 0.18s;
		}
		.btn-primary:hover {
			background: #0056b3;
		}
		.account-card, .security-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 1.5rem 1.2rem;
			margin-bottom: 1.5rem;
		}
		.account-card .fa, .security-card .fa {
			font-size: 1.5rem;
			margin-right: 0.7rem;
			color: #007bff;
		}
		@media (max-width: 900px) {
			.settings-grid { grid-template-columns: 1fr; }
		}
		@media (max-width: 768px) {
			.settings-container { padding: 1rem; }
			.page-header { padding: 1.2rem 0.7rem; }
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="settings-container">
		<!-- Page Header -->
		<div class="page-header animate__animated animate__fadeInDown">
			<h1 class="mb-2">
				<i class="fas fa-cog me-3"></i>
				Settings
			</h1>
			<p class="mb-0 opacity-75">Manage your account, preferences, and security</p>
		</div>

		<div class="settings-grid">
			<!-- Settings Form -->
			<div>
				<div class="settings-card animate__animated animate__fadeInUp">
					<div class="settings-title"><i class="fas fa-user-edit me-2"></i>Profile Settings</div>
					<form>
						<div class="mb-3">
							<label class="form-label">Full Name</label>
							<input type="text" class="form-control" placeholder="Enter your name" value="Student Name" />
						</div>
						<div class="mb-3">
							<label class="form-label">Email Address</label>
							<input type="email" class="form-control" placeholder="Enter your email" value="student@email.com" />
						</div>
						<div class="mb-3">
							<label class="form-label">Phone Number</label>
							<input type="tel" class="form-control" placeholder="Enter your phone" value="+233 123 456 789" />
						</div>
						<div class="mb-3">
							<label class="form-label">Preferred Language</label>
							<select class="form-select">
								<option>English</option>
								<option>French</option>
								<option>Spanish</option>
							</select>
						</div>
						<button type="submit" class="btn btn-primary mt-2 px-4">
							<i class="fas fa-save me-2"></i>Save Changes
						</button>
					</form>
				</div>
			</div>
			<!-- Account & Security -->
			<div>
				<div class="account-card animate__animated animate__fadeInRight animate__delay-1s">
					<div class="settings-title"><i class="fas fa-user-circle me-2"></i>Account</div>
					<div class="mb-2"><i class="fas fa-id-badge"></i> Student ID: <span class="fw-bold">202500123</span></div>
					<div class="mb-2"><i class="fas fa-envelope"></i> Email: <span class="fw-bold">student@email.com</span></div>
					<div class="mb-2"><i class="fas fa-calendar-alt"></i> Member since: <span class="fw-bold">Aug 2023</span></div>
				</div>
				<div class="security-card animate__animated animate__fadeInRight animate__delay-2s">
					<div class="settings-title"><i class="fas fa-shield-alt me-2"></i>Security</div>
					<button class="btn btn-outline-primary w-100 mb-2" id="changePasswordBtn">
						<i class="fas fa-key me-2"></i>Change Password
					</button>
					<button class="btn btn-outline-danger w-100" onclick="window.location.href='../../Accounts/Login.aspx'; return false;"><i class="fas fa-sign-out-alt me-2"></i>Logout</button>
				</div>
			</div>
		</div>
	</div>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
$(function() {
    // Load profile data
    $.ajax({
        type: "POST",
        url: "Settings.aspx/GetStudentSettings",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            if (res.d) {
                var data = JSON.parse(res.d);
                $('input[placeholder="Enter your name"]').val(data.FullName || "");
                $('input[placeholder="Enter your email"]').val(data.Email || "");
                $('input[placeholder="Enter your phone"]').val(data.Phone || "");
                $('.account-card .fw-bold').eq(0).text(data.UserID || "");
                $('.account-card .fw-bold').eq(1).text(data.Email || "");
                $('.account-card .fw-bold').eq(2).text(data.CreatedDate || "");
            }
        }
    });

 // Change Password popup
    $('#changePasswordBtn').on('click', function(e) {
    e.preventDefault();
    Swal.fire({
        title: 'Change Password',
        html:
            `<div style="position:relative;">
                <input type="password" id="oldPassword" class="swal2-input" placeholder="Enter Your Old Password" style="padding-right:40px;">
                <span class="toggle-pass" data-target="oldPassword" style="position:absolute;top:20px;right:45px;cursor:pointer; background-color: #2c2b7c; color: white; border-radius: 0px 4px 4px 0px; padding: 16px 15px;">
                    <i class="fa fa-eye-slash"></i>
                </span>
            </div>
            <div style="position:relative;">
                <input type="password" id="newPassword" class="swal2-input" placeholder="Enter Your New Password" style="padding-right:40px;">
                <span class="toggle-pass" data-target="newPassword" style="position:absolute;top:20px;right:45px;cursor:pointer; background-color: #2c2b7c; color: white; border-radius: 0px 4px 4px 0px; padding: 16.5px 15px;">
                    <i class="fa fa-eye-slash"></i>
                </span>
            </div>
            <div style="position:relative;">
                <input type="password" id="confirmPassword" class="swal2-input" placeholder="Confirm Your New Password" style="padding-right:40px;">
                <span class="toggle-pass" data-target="confirmPassword" style="position:absolute;top:20px;right:45px;cursor:pointer; background-color: #2c2b7c; color: white; border-radius: 0px 4px 4px 0px; padding: 16.5px 15px;">
                    <i class="fa fa-eye-slash"></i>
                </span>
            </div>`,
        showCancelButton: true,
        confirmButtonText: 'Save',
        cancelButtonText: 'Close',
        didOpen: () => {
            // Toggle password visibility
            $('.toggle-pass').on('click', function() {
                var target = $(this).data('target');
                var input = $('#' + target);
                var icon = $(this).find('i');
                if (input.attr('type') === 'password') {
                    input.attr('type', 'text');
                    icon.removeClass('fa-eye-slash').addClass('fa-eye');
                } else {
                    input.attr('type', 'password');
                    icon.removeClass('fa-eye').addClass('fa-eye-slash');
                }
            });
        },
        preConfirm: () => {
            const oldPass = $('#oldPassword').val();
            const newPass = $('#newPassword').val();
            const confirmPass = $('#confirmPassword').val();
            const strongRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!oldPass || !newPass || !confirmPass) {
                Swal.showValidationMessage('All fields are required');
                return false;
            }
            if (!strongRegex.test(newPass)) {
                Swal.showValidationMessage('Password must be at least 8 characters and include uppercase, lowercase, number, and special character.');
                return false;
            }
            if (newPass !== confirmPass) {
                Swal.showValidationMessage('New passwords do not match');
                return false;
            }
            return { oldPass, newPass };
        }
    }).then((result) => {
        if (result.isConfirmed && result.value) {
            // AJAX call to backend to change password
            $.ajax({
                type: "POST",
                url: "Settings.aspx/ChangePassword",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    oldPassword: result.value.oldPass,
                    newPassword: result.value.newPass
                }),
                success: function(res) {
                    if (res.d && JSON.parse(res.d).success) {
                        Swal.fire('Success', 'Password changed successfully!', 'success');
                    } else {
                        Swal.fire('Error', (res.d && JSON.parse(res.d).message) || 'Failed to change password.', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to change password.', 'error');
                }
            });
        }
    });
});

    // Save changes
    $('.settings-card form').on('submit', function(e) {
    e.preventDefault();
    var name = $('input[placeholder="Enter your name"]').val().trim();
    var email = $('input[placeholder="Enter your email"]').val().trim();
    var phone = $('input[placeholder="Enter your phone"]').val().trim();

    // Simple validation
    if (!name) {
        Swal.fire('Validation Error', 'Full Name is required.', 'warning');
        return;
    }
	   if (!/^[A-Za-z\s]+$/.test(name)) {
        Swal.fire('Validation Error', 'Name must contain letters and spaces only.', 'warning');
        return;
    }
    if (!email || !/^[\w\.-]+@[\w\.-]+\.\w{2,}$/.test(email)) {
        Swal.fire('Validation Error', 'Please enter a valid email address.', 'warning');
        return;
    }
    if (!phone || phone.length < 7) {
        Swal.fire('Validation Error', 'Please enter a valid phone number.', 'warning');
        return;
    }

    $.ajax({
        type: "POST",
        url: "Settings.aspx/UpdateStudentSettings",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ name: name, email: email, phone: phone }),
        dataType: "json",
        success: function(res) {
			$('.account-card .fw-bold').eq(1).text(email);
            Swal.fire('Saved!', 'Your profile has been updated.', 'success');
        }
    });
});
});
</script>

</asp:Content>
