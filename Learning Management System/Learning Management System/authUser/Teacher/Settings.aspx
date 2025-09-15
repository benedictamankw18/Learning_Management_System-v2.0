
<%@ Page Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Settings" %>

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
			padding: 24px;
			max-width: 900px;
			margin: 0 auto;
		}
		.page-header {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			padding: 30px;
			border-radius: 15px;
			margin-bottom: 30px;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
		}
		.settings-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			margin-bottom: 28px;
			padding: 28px 32px;
			transition: box-shadow 0.3s, transform 0.3s;
			position: relative;
		}
		.settings-card:hover {
			box-shadow: 0 10px 30px rgba(0,123,255,0.13);
			transform: translateY(-2px);
		}
		.settings-card .card-title {
			font-size: 1.3rem;
			font-weight: 600;
			color: #1976d2;
			margin-bottom: 18px;
		}
		.settings-row {
			display: flex;
			flex-wrap: wrap;
			gap: 32px;
		}
		.settings-avatar {
			width: 90px;
			height: 90px;
			border-radius: 50%;
			background: #e3f2fd;
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 2.8rem;
			color: #1976d2;
			margin-right: 32px;
			box-shadow: 0 2px 8px rgba(25, 118, 210, 0.08);
		}
		.user {
			width: 100%;
			height: 100%;
			object-fit: cover;
			border-radius: 50%;
		}
		.settings-info {
			flex: 1;
		}
		.settings-info h5 {
			font-weight: 600;
			color: #2c3e50;
			margin-bottom: 4px;
		}
		.settings-info .text-muted {
			font-size: 1rem;
		}
		.edit-btn {
			position: absolute;
			top: 24px;
			right: 32px;
			background: #e3f2fd;
			color: #1976d2;
			border: none;
			border-radius: 8px;
			padding: 7px 16px;
			font-weight: 500;
			transition: background 0.2s;
		}
		.edit-btn:hover {
			background: #bbdefb;
			color: #0d47a1;
		}
		.theme-toggle {
			display: flex;
			align-items: center;
			gap: 16px;
		}
		.form-switch .form-check-input {
			width: 2.5em;
			height: 1.3em;
		}
		.modal-content {
			border-radius: 15px;
			border: none;
		}
		.modal-header {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			border-radius: 15px 15px 0 0;
		}
		.btn-close-white {
			filter: brightness(0) invert(1);
		}
		@media (max-width: 600px) {
			.settings-card { padding: 18px 8px; }
			.settings-row { flex-direction: column; gap: 18px; }
			.settings-avatar { margin: 0 auto 18px auto; }
			.edit-btn { right: 12px; top: 12px; }
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="settings-container">
		<!-- Page Header -->
		<div class="page-header mb-4">
			<h1 class="mb-2"><i class="fas fa-cog me-3"></i>Settings</h1>
			<p class="mb-0 opacity-75">Manage your profile, preferences, and account security</p>
		</div>

		<!-- Profile Info Card -->
		<div class="settings-card animate__animated animate__fadeInDown">
			<div class="settings-row align-items-center">
				<div class="settings-avatar">
					<input type="hidden" id="hiddenProfilePic" value="<%= Session["ProfilePicture"] ?? "" %>" />
					<img src="" id="profilePictureSet" alt="User Avatar" class="user">
				</div>
				<div class="settings-info">
					<h5 id="profileNameSet">Mr. John Doe</h5>
					<div class="text-muted mb-1" id="profileEmail"><i class="fas fa-envelope me-2"></i>john.doe@school.edu.gh</div>
					<div class="text-muted" id="profileRole"><i class="fas fa-chalkboard-teacher me-2"></i>Teacher</div>
					<!-- Hidden fields for JS population -->
					<input type="hidden" id="hiddenProfileName" value="<%= Session["FullName"] ?? "Mr. John Doe" %>" />
					<input type="hidden" id="hiddenProfileEmail" value="<%= Session["Email"] ?? "john.doe@school.edu.gh" %>" />
					<input type="hidden" id="hiddenProfileRole" value="<%= Session["UserType"] ?? "Teacher" %>" />
				</div>
			</div>
			<button class="edit-btn" data-bs-toggle="modal" data-bs-target="#editProfileModal"><i class="fas fa-edit me-1"></i>Edit</button>
		</div>

		<!-- Password Change Card -->
		<div class="settings-card animate__animated animate__fadeInUp">
			<div class="card-title"><i class="fas fa-key me-2"></i>Change Password</div>
			<form id="changePasswordForm" class="row g-3">
				<div class="col-md-6 position-relative">
					<label for="currentPassword" class="form-label">Current Password</label>
					<input type="password" class="form-control pr-5" id="currentPassword" required>
					<span class="position-absolute end-0 translate-middle-y me-3" style="cursor:pointer;z-index:2; top: 50px;" onclick="togglePassword('currentPassword', this)">
						<i class="fa fa-eye-slash password-icon"></i>
					</span>
				</div>
				<div class="col-md-6 position-relative">
					<label for="newPassword" class="form-label">New Password</label>
					<input type="password" class="form-control pr-5" id="newPassword" required>
					<span class="position-absolute end-0 translate-middle-y me-3" style="cursor:pointer;z-index:2; top: 50px;" onclick="togglePassword('newPassword', this)">
						<i class="fa fa-eye-slash password-icon"></i>
					</span>
				</div>
				<div class="col-md-6 position-relative">
					<label for="confirmPassword" class="form-label">Confirm New Password</label>
					<input type="password" class="form-control pr-5" id="confirmPassword" required>
					<span class="position-absolute end-0 translate-middle-y me-3" style="cursor:pointer;z-index:2; top: 50px;" onclick="togglePassword('confirmPassword', this)">
						<i class="fa fa-eye-slash password-icon"></i>
					</span>
				</div>
				<div class="col-12 mt-2">
					<button type="button" class="btn btn-primary px-4" onclick="changePassword()">
						<i class="fas fa-save me-2"></i>Update Password
					</button>
				</div>
			</form>
		</div>

		<!-- Notification Preferences Card -->
		<div class="settings-card animate__animated animate__fadeInUp">
			<div class="card-title"><i class="fas fa-bell me-2"></i>Notification Preferences</div>
			<form id="notificationForm">
				<div class="form-check form-switch mb-3">
					<input class="form-check-input" type="checkbox" id="emailNotif" checked>
					<label class="form-check-label" for="emailNotif">Email Notifications</label>
				</div>
				<div class="form-check form-switch mb-3">
					<input class="form-check-input" type="checkbox" id="smsNotif">
					<label class="form-check-label" for="smsNotif">SMS Notifications</label>
				</div>
				<div class="form-check form-switch mb-3">
					<input class="form-check-input" type="checkbox" id="pushNotif" checked>
					<label class="form-check-label" for="pushNotif">Push Notifications</label>
				</div>
				<button type="button" class="btn btn-primary px-4" onclick="saveNotifications()">
					<i class="fas fa-save me-2"></i>Save Preferences
				</button>
			</form>
		</div>

		<!-- Theme Toggle Card -->
		<div class="settings-card animate__animated animate__fadeInUp">
			<div class="card-title"><i class="fas fa-moon me-2"></i>Theme</div>
			<div class="theme-toggle">
				<div class="form-check form-switch">
					<input class="form-check-input" type="checkbox" id="themeSwitch" onchange="toggleTheme()">
					<label class="form-check-label" for="themeSwitch">Dark Mode</label>
				</div>
				<span id="themeStatus" class="text-muted">Light Mode</span>
			</div>
		</div>
	</div>

	<!-- Edit Profile Modal -->
	<div class="modal fade" id="editProfileModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title"><i class="fas fa-user-edit me-2"></i>Edit Profile</h5>
					<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<form id="editProfileForm">
						<div class="mb-3">
							<label for="editName" class="form-label">Full Name</label>
							<input type="text" class="form-control" id="editName" value="" required>
						</div>
						<div class="mb-3">
							<label for="editEmail" class="form-label">Email</label>
							<input type="email" class="form-control" id="editEmail" value="" required>
						</div>
						<div class="mb-3">
							<label for="editRole" class="form-label">Role</label>
							<input type="text" class="form-control" id="editRole" value="Teacher" disabled>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" onclick="saveProfile()">
						<i class="fas fa-save me-2"></i>Save Changes
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		// Animate.css CDN for entry animations
		var animateCss = document.createElement('link');
		animateCss.rel = 'stylesheet';
		animateCss.href = 'https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css';
		document.head.appendChild(animateCss);

		document.addEventListener('DOMContentLoaded', function() {
    const profilePic = document.getElementById('hiddenProfilePic')?.value || '';
	const fullName = document.getElementById('hiddenProfileName')?.value || '';
let profilePicUrl = "";
if (profilePic && profilePic.trim() !== "") {
    // If not already a full URL or starting with '/', prepend your upload folder
    if (profilePic.startsWith('http') || profilePic.startsWith('/')) {
        profilePicUrl = profilePic;
    } else {
        profilePicUrl = '/Uploads/ProfilePictures/' + profilePic;
    }
} else {
    profilePicUrl = getDefaultProfilePic(fullName);
}
    document.getElementById('profilePictureSet').src = profilePicUrl;
});

		// Profile Save
		function saveProfile() {
			const name = document.getElementById('editName').value;
			const email = document.getElementById('editEmail').value;
			fetch('Settings.aspx/UpdateProfile', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ name: name, email: email })
			})
			.then(res => res.json())
			.then(data => {
				const result = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;
				if (result.success) {
					document.getElementById('profileNameSet').textContent = name;
					document.getElementById('profileEmail').innerHTML = '<i class="fas fa-envelope me-2"></i>' + email;
					bootstrap.Modal.getInstance(document.getElementById('editProfileModal')).hide();
					Swal.fire({
						icon: 'success',
						title: 'Success',
						text: 'Profile updated successfully!'
					});
				} else {
					Swal.fire({
						icon: 'error',
						title: 'Error',
						text: result.message || 'Update failed.'
					});
				}
			})
			.catch(() => {
				Swal.fire({
					icon: 'error',
					title: 'Error',
					text: 'An error occurred while updating your profile.'
				});
			});

			const fadeRemove = document.querySelector('.modal-backdrop');
			if (fadeRemove) fadeRemove.style.display = 'none';
		}

		// Password Change
		function changePassword() {
			const form = document.getElementById('changePasswordForm');
			if (form.checkValidity()) {
						const currentPassword = document.getElementById('currentPassword').value;
						const newPassword = document.getElementById('newPassword').value;
						const confirmPassword = document.getElementById('confirmPassword').value;

						if (newPassword !== confirmPassword) {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: 'New password and confirm password do not match.'
							});
							return;
						}

						fetch('Settings.aspx/ChangePassword', {
							method: 'POST',
							headers: { 'Content-Type': 'application/json' },
							body: JSON.stringify({ currentPassword: currentPassword, newPassword: newPassword })
						})
						.then(res => res.json())
						.then(data => {
							const result = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;
							if (result.success) {
								Swal.fire({
									icon: 'success',
									title: 'Success',
									text: 'Password updated successfully!'
								});
								form.reset();
							} else {
								Swal.fire({
									icon: 'error',
									title: 'Error',
									text: result.message || 'Password update failed.'
								});
							}
						})
						.catch(() => {
							Swal.fire({
								icon: 'error',
								title: 'Error',
								text: 'An error occurred while updating your password.'
							});
						});
			} else {
				form.reportValidity();
			}
		}

		// Notification Preferences
		function saveNotifications() {
			Swal.fire({
				icon: 'success',
				title: 'Saved',
				text: 'Notification preferences saved!'
			});
		}

		// Theme Toggle
		function toggleTheme() {
			const isDark = document.getElementById('themeSwitch').checked;
			document.body.classList.toggle('bg-dark', isDark);
			document.body.classList.toggle('text-light', isDark);
			document.getElementById('themeStatus').textContent = isDark ? 'Dark Mode' : 'Light Mode';
		}

		// Show/Hide Password Toggle
		function togglePassword(inputId, iconSpan) {
			const input = document.getElementById(inputId);
			const icon = iconSpan.querySelector('.password-icon');
			if (input.type === 'password') {
				input.type = 'text';
				icon.classList.remove('fa-eye-slash');
				icon.classList.add('fa-eye');
			} else {
				input.type = 'password';
				icon.classList.remove('fa-eye');
				icon.classList.add('fa-eye-slash');
			}
		}

		// JS version of GetDefaultProfilePic
function getDefaultProfilePic(fullName) {
    if (!fullName || typeof fullName !== 'string' || fullName.trim() === '') {
        return "../../../Assest/Images/user.png";
    }
    let initials = "";
    const names = fullName.trim().split(' ');
    if (names.length >= 2) {
        initials = names[0].charAt(0) + names[1].charAt(0);
    } else if (names.length === 1 && names[0].length >= 2) {
        initials = names[0].substring(0, 2);
    } else {
        initials = "U";
    }
    return `https://placehold.co/600x400/EEE/31343C?font=roboto&text=${initials.toUpperCase()}`;
}
	</script>

	

<script type="text/javascript">
// On page load, populate profile info from hidden fields
document.addEventListener('DOMContentLoaded', function() {
	var name = document.getElementById('hiddenProfileName')?.value || 'Mr. John Doe';
	var email = document.getElementById('hiddenProfileEmail')?.value || 'john.doe@school.edu.gh';
	var role = document.getElementById('hiddenProfileRole')?.value || 'Teacher';
	document.getElementById('profileNameSet').textContent = name;
	document.getElementById('profileEmail').innerHTML = '<i class="fas fa-envelope me-2"></i>' + email;
	document.getElementById('profileRole').innerHTML = '<i class="fas fa-chalkboard-teacher me-2"></i>' + role;
	// Also update modal fields
	document.getElementById('editName').value = name;
	document.getElementById('editEmail').value = email;
	document.getElementById('editRole').value = role;
});
</script>

</asp:Content>