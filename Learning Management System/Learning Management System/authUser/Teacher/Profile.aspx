<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
    <style>
        .profile-card {
            max-width: 480px;
            margin: 40px auto 0 auto;
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(44,43,124,0.10);
            padding: 2.5rem 2rem 2rem 2rem;
            text-align: center;
            font-family: 'Roboto', sans-serif;
            position: relative;
        }
        .profile-avatar {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #2c2b7c;
            margin-top: -70px;
            background: #f8f9fa;
            box-shadow: 0 2px 12px rgba(44,43,124,0.10);
        }
        .user{
            width: 110px;
            height: 110px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #2c2b7c;
            margin-top: -70px;
            background: #f8f9fa;
            box-shadow: 0 2px 12px rgba(44,43,124,0.10);
        }
        .profile-name {
            font-size: 1.6rem;
            font-weight: 700;
            color: #2c2b7c;
            margin-top: 1rem;
        }
        .profile-role {
            font-size: 1.1rem;
            color: #0056b3;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        .profile-info {
            margin: 1.5rem 0 1rem 0;
            text-align: left;
        }
        .profile-info .info-label {
            color: #888;
            font-size: 0.98rem;
            font-weight: 500;
        }
        .profile-info .info-value {
            color: #222;
            font-size: 1.08rem;
            font-weight: 500;
        }
        .profile-actions {
            margin-top: 1.5rem;
        }
        .btn-edit-profile {
            background: linear-gradient(90deg, #2c2b7c 60%, #0056b3 100%);
            color: #fff;
            border: none;
            border-radius: 30px;
            padding: 0.7rem 2.2rem;
            font-weight: 600;
            font-size: 1.08rem;
            box-shadow: 0 2px 8px rgba(44,43,124,0.10);
            transition: background 0.2s, transform 0.2s;
        }
        .btn-edit-profile:hover {
            background: linear-gradient(90deg, #0056b3 60%, #2c2b7c 100%);
            transform: translateY(-2px) scale(1.03);
        }
        <%-- @media (max-width: 600px) {
            .profile-card { padding: 1.2rem 0.5rem; }
        } --%>
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-card animate__animated animate__fadeInDown">
        <input type="hidden" id="hiddenProfilePic" value="<%= Session["ProfilePicture"].ToString() ?? "" %>" />
					<img src="" id="profilPicture" alt="User Avatar" class="user">
        <input type="hidden" id="hiddenFullName" value="<%= Session["FullName"] ?? "Dr. Jane Doe" %>" />
                     <div class="profile-name" id="profilName">Dr. Jane Doe</div>
        <div class="profile-role"><i class="fas fa-chalkboard-teacher me-1"></i> Teacher</div>
        <div class="profile-info">
            <div class="row mb-2">
                <div class="col-5 info-label">Email:</div>
                <div class="col-7 info-value" id="email">jane.doe@school.edu</div>
				<input type="hidden" id="hiddenEmail" value="<%= Session["Email"] ?? "jane.doe@school.edu" %>" />
            </div>
            <div class="row mb-2">
                <div class="col-5 info-label">Department:</div>
                <div class="col-7 info-value" id="department">Computer Science</div>
				<input type="hidden" id="hiddenDepartment" value="<%= Session["Department"] ?? "Computer Science" %>" />
            </div>
            <div class="row mb-2">
                <div class="col-5 info-label">Phone:</div>
                <div class="col-7 info-value" id="phone">+1 555-123-4567</div>
				<input type="hidden" id="hiddenPhone" value="<%= Session["Phone"] ?? "+1 555-123-4567" %>" />
            </div>
            <div class="row mb-2">
                <div class="col-5 info-label">Joined:</div>
                <div class="col-7 info-value" id="joined">August 2021</div>
                <input type="hidden" id="hiddenJoined" value="<%= Session["Joined"] ?? "August 2021" %>" />
            </div>
        </div>
        <div class="profile-actions">
            <button class="btn btn-edit-profile"><i class="fas fa-user-edit me-2"></i>Edit Profile</button>
        </div>
    </div>

    <script>
        // JavaScript to handle profile editing
        document.addEventListener("DOMContentLoaded", function () {
            const editButton = document.querySelector(".btn-edit-profile");
            editButton.addEventListener("click", function () {
                // Redirect to the edit profile page
                window.location.href = "./Settings.aspx";
            });

            document.getElementById("profilName").innerText = document.getElementById("hiddenFullName").value;
            document.getElementById("email").innerText = document.getElementById("hiddenEmail").value;
            document.getElementById("department").innerText = document.getElementById("hiddenDepartment").value;
            document.getElementById("phone").innerText = document.getElementById("hiddenPhone").value;
            document.getElementById("joined").innerText = document.getElementById("hiddenJoined").value;

            // Populate profile information
            const profilePic = document.getElementById('hiddenProfilePic')?.value || '';
	const fullName = document.getElementById('hiddenFullName')?.value || '';
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
    document.getElementById('profilPicture').src = profilePicUrl;
            
        });

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
</asp:Content>
