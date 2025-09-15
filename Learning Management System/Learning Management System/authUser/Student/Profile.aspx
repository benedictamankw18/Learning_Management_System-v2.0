<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Profile - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.profile-container {
			padding: 2rem;
			background: #f8f9fa;
			min-height: 100vh;
			display: flex;
			justify-content: center;
			align-items: flex-start;
		}
		.profile-card {
			background: white;
			border-radius: 18px;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13);
			padding: 2.5rem 2rem 2rem 2rem;
			max-width: 500px;
			width: 100%;
			text-align: center;
			position: relative;
			overflow: hidden;
			margin-top: 2rem;
		}
		.profile-avatar {
			width: 100px;
			height: 100px;
			border-radius: 50%;
			object-fit: cover;
			border: 4px solid #fff;
			box-shadow: 0 2px 8px rgba(0,123,255,0.10);
			margin-bottom: 1.2rem;
		}
		.profile-name {
			font-size: 1.5rem;
			font-weight: 600;
			color: #2c3e50;
			margin-bottom: 0.3rem;
		}
		.profile-role {
			font-size: 1.1rem;
			color: #007bff;
			margin-bottom: 1.2rem;
		}
		.profile-info-grid {
			display: grid;
			grid-template-columns: 1fr 1fr;
			gap: 1.2rem 0.7rem;
			margin-bottom: 1.5rem;
		}
		.profile-info-label {
			font-weight: 500;
			color: #888;
			font-size: 0.98rem;
		}
		.profile-info-value {
			color: #2c3e50;
			font-size: 1.05rem;
			font-weight: 500;
		}
		.profile-actions {
			display: flex;
			gap: 1rem;
			justify-content: center;
			margin-top: 1.5rem;
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
		.btn-outline-primary {
			border-radius: 8px;
			font-weight: 500;
		}
		@media (max-width: 600px) {
			.profile-container { padding: 1rem; }
			.profile-card { padding: 1.2rem 0.5rem; }
			.profile-info-grid { grid-template-columns: 1fr; }
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="profile-container">
		<div class="profile-card animate__animated animate__fadeInDown">
			<img src="../../Assest/Images/ProfileUew.png" alt="Profile" class="profile-avatar mb-2">
			<div class="profile-name">Student Name</div>
			<div class="profile-role">Student</div>
			<div class="profile-info-grid">
				<div class="profile-info-label">Student ID</div>
				<div class="profile-info-value">202500123</div>
				<div class="profile-info-label">Email</div>
				<div class="profile-info-value">student@email.com</div>
				<div class="profile-info-label">Phone</div>
				<div class="profile-info-value">+233 123 456 789</div>
				<div class="profile-info-label">Member Since</div>
				<div class="profile-info-value">Aug 2023</div>
			</div>
			<div class="profile-actions">
				<div class="profile-actions">
					<button class="btn btn-primary px-4" onclick="window.location.href='Settings.aspx'; return false;">
						<i class="fas fa-user-edit me-2"></i>Edit Profile
					</button>
					<button class="btn btn-outline-primary px-4" onclick="window.location.href='Settings.aspx'; return false;">
						<i class="fas fa-key me-2"></i>Change Password
					</button>
				</div>
			</div>
		</div>
	</div>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
$(function() {
    $.ajax({
        type: "POST",
        url: "Profile.aspx/GetStudentProfile",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            if (res.d) {
                var data = JSON.parse(res.d);
                $('.profile-name').text(data.Name || "Student Name");
                $('.profile-info-value').eq(0).text(data.StudentID || "");
                $('.profile-info-value').eq(1).text(data.Email || "");
                $('.profile-info-value').eq(2).text(data.Phone || "");
                $('.profile-info-value').eq(3).text(data.CreatedDate || "");
                $('.profile-avatar').attr('src', data.ProfilePicture || "../../Assest/Images/ProfileUew.png");
            }
        }
    });
});
</script>
</asp:Content>
