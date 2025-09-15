<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.User" %>

<%--  Header information goes in here  --%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>User Management - Learning Management System</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../../Assest/js/custom-animations.js"></script>
    <script src="modal-fix.js"></script>
    <script src="notifications.js"></script>
    <script src="UserFunctions.js"></script>
    <script src="dropdownScript.js"></script>
    <style>
        /* Custom Theme Colors */
        :root {
            /* Custom Theme Palette */
            --primary-color: #2c2b7c;
            --accent-color: #ee1c24;
            --background-color: #fefefe;
            --text-color: #000000;
            
            /* Derived Colors */
            --primary-light: #3d3c8f;
            --primary-dark: #1f1e5a;
            --accent-light: #f04752;
            --accent-dark: #c41520;
            
            /* Neutral Colors */
            --white: #ffffff;
            --light-gray: #f8f9fa;
            --border-gray: #e0e0e0;
            --medium-gray: #666666;
            --dark-gray: #333333;
            
            /* Status Colors */
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: var(--accent-color);
            --info-color: var(--primary-color);
        }

        body {
            background-color: var(--background-color);
            color: var(--text-color);
            font-family: 'Inter', sans-serif;
        }

        /* User Management Page Styles */
        .page-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: var(--white);
            box-shadow: 0 8px 32px rgba(44, 43, 124, 0.15);
        }

        .page-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: var(--white);
        }

        .page-header p {
            margin: 0.75rem 0 0 0;
            opacity: 0.9;
            font-size: 1.1rem;
            color: var(--white);
        }

        .user-controls {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
        }

        .user-tabs {
            background: var(--light-gray);
            padding: 1.5rem 2rem;
            border-radius: 12px 12px 0 0;
            border-bottom: 1px solid var(--border-gray);
        }

        .nav-pills .nav-link {
            background: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            margin-right: 1rem;
            border-radius: 25px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .nav-pills .nav-link.active {
            background: var(--primary-color);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(44, 43, 124, 0.3);
        }

        .search-add-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .search-box {
            position: relative;
            flex: 1;
            max-width: 450px;
        }

        .search-box input {
            padding: 0.875rem 1rem 0.875rem 3.5rem;
            border: 2px solid var(--border-gray);
            border-radius: 25px;
            width: 100%;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: var(--white);
            color: var(--text-color);
        }

        .search-box input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(44, 43, 124, 0.25);
            outline: none;
        }

        .search-box input::placeholder {
            color: var(--medium-gray);
        }

        .search-box .search-icon {
            position: absolute;
            left: 0.7rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-gray);
            font-size: 1.1rem;
        }

        .add-user-btn {
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-light) 100%);
            border: none;
            padding: 0.875rem 2rem;
            border-radius: 25px;
            color: var(--white);
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(238, 28, 36, 0.3);
        }

        .add-user-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(238, 28, 36, 0.4);
            color: var(--white);
            background: linear-gradient(135deg, var(--accent-dark) 0%, var(--accent-color) 100%);
        }

        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 1.5rem;
            padding: 1rem 0;
        }

        .user-card {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 1.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .user-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border-color: var(--primary-color);
        }

        .user-card-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.25rem;
        }

        .user-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-color);
            margin-right: 1rem;
        }

        .user-basic-info h5 {
            margin: 0;
            color: var(--text-color);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .user-basic-info .email {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        .user-details {
            margin-bottom: 1.5rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--border-gray);
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: var(--dark-gray);
            font-size: 0.9rem;
        }

        .detail-value {
            color: var(--medium-gray);
            font-size: 0.9rem;
            text-align: right;
        }

        .user-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-action {
            flex: 1;
            padding: 0.625rem 0.75rem;
            border-radius: 10px;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.375rem;
        }

        .btn-edit {
            background: var(--warning-color);
            color: var(--text-color);
        }

        .btn-edit:hover {
            background: #e0a800;
            color: var(--text-color);
            transform: translateY(-1px);
        }

        .btn-delete {
            background: var(--danger-color);
            color: var(--white);
        }

        .btn-delete:hover {
            background: var(--accent-dark);
            color: var(--white);
            transform: translateY(-1px);
        }

        .btn-view {
            background: var(--primary-color);
            color: var(--white);
        }

        .btn-view:hover {
            background: var(--primary-dark);
            color: var(--white);
            transform: translateY(-1px);
        }

        .course-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.375rem;
        }

        .course-tag {
            background: var(--primary-color);
            color: var(--white);
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .course-tag .remove-course {
            cursor: pointer;
            opacity: 0.8;
            font-size: 0.7rem;
        }

        .course-tag .remove-course:hover {
            opacity: 1;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--medium-gray);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
            color: var(--medium-gray);
        }

        .empty-state h4 {
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }

        /* Modal Enhancements */
        .modal-content {
            margin-top: 85px;
            border-radius: 16px;
            border: none;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }

        .modal-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            color: var(--white);
            border-radius: 16px 16px 0 0;
            padding: 1.5rem 2rem;
        }

        .modal-header h5 {
            font-weight: 700;
            margin: 0;
            color: var(--white);
        }

        .btn-close-white {
            filter: brightness(0) invert(1);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-gray);
            border-radius: 12px;
            transition: all 0.3s ease;
            background: var(--white);
            color: var(--text-color);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(44, 43, 124, 0.25);
        }

        .form-control::placeholder {
            color: var(--medium-gray);
        }

        /* Email Validation Styles */
        .email-validation-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
            color: var(--success-color);
            display: none;
        }
        
        .email-validation-icon.valid {
            color: var(--success-color);
        }
        
        .email-validation-icon.invalid {
            color: var(--danger-color);
        }
        
        .email-feedback {
            font-size: 12px;
            margin-top: 5px;
            height: 16px;
        }
        
        .email-feedback.valid {
            color: var(--success-color);
        }
        
        .email-feedback.invalid {
            color: var(--danger-color);
        }
        
        input.email-valid {
            border-color: var(--success-color);
        }
        
        input.email-invalid {
            border-color: var(--danger-color);
        }
        
        .input-icon-container {
            position: relative;
        }

        .profile-upload {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .profile-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--primary-color);
            margin-bottom: 1rem;
        }

        .upload-btn {
            background: var(--primary-color);
            color: var(--white);
            border: none;
            padding: 0.5rem 1.5rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .upload-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }
        
        .clear-btn {
            background: var(--medium-gray);
            color: var(--white);
            border: none;
            padding: 0.5rem 1.5rem;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: block;
            margin: 0 auto;
        }
        
        .clear-btn:hover {
            background: var(--danger-color);
            transform: translateY(-1px);
        }

        /* Phone validation styles */
        .phone-input-container {
            position: relative;
        }

        .phone-validation-icon {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
        }

        .phone-validation-icon.valid {
            color: var(--success-color);
        }

        .phone-validation-icon.invalid {
            color: var(--danger-color);
        }

        .phone-feedback {
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .phone-feedback.valid {
            color: var(--success-color);
        }

        .phone-feedback.invalid {
            color: var(--danger-color);
        }

        .form-control.phone-valid {
            border-color: var(--success-color);
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .form-control.phone-invalid {
            border-color: var(--danger-color);
            box-shadow: 0 0 0 0.2rem rgba(238, 28, 36, 0.25);
        }

        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .page-header {
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .user-controls {
                padding: 1.5rem;
            }

            .user-tabs {
                padding: 1rem 1.5rem;
            }

            .users-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .search-add-container {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                max-width: none;
                margin-bottom: 1rem;
            }

            .nav-pills .nav-link {
                margin-right: 0.5rem;
                margin-bottom: 0.5rem;
                padding: 0.625rem 1.5rem;
                font-size: 0.9rem;
            }

            .user-card {
                padding: 1.25rem;
            }

            .user-avatar {
                width: 56px;
                height: 56px;
            }

            .user-actions {
                flex-direction: column;
                gap: 0.75rem;
            }

            .btn-action {
                width: 100%;
            }
        }

        /* Mobile menu compatibility */
        @media (max-width: 768px) {
            body.mobile-menu-active .user-controls {
                overflow-x: hidden;
            }
        }

        .user-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            margin: 2rem auto;
            overflow: hidden;
            max-width: 1400px;
        }

        /* Custom Animation Overrides for User Page */
        .tab-pane.custom-fade {
            min-height: 200px;
        }

        /* Fixed Modal Animation - Ensure proper layering and visibility */
        .modal.custom-fade {
            opacity: 0;
            background: rgba(0, 0, 0, 0.5);
            transition: opacity 0.3s ease-in-out;
            pointer-events: none;
        }

        .modal.custom-fade.show {
            opacity: 1;
            pointer-events: auto;
        }

        .modal.custom-fade .modal-dialog {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            transform: scale(0.9) translateY(-30px);
        }

        .modal.custom-fade.show .modal-dialog {
            transform: scale(1) translateY(0);
        }

        /* Ensure only one backdrop exists */
        .modal-backdrop.custom-fade {
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }

        .modal-backdrop.custom-fade.show {
            opacity: 0.5;
        }

        /* Prevent multiple backdrops */
        .modal-backdrop:nth-of-type(n+2) {
            display: none !important;
        }

        .user-card {
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(20px);
        }

        .user-card.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* Loading animation for grids */
        .users-grid.loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .users-grid.loading::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
        }

        /* Tab transition improvements */
        .nav-pills .nav-link {
            transition: all 0.3s ease;
        }

        .nav-pills .nav-link:not(.active):hover {
            background: rgba(44, 43, 124, 0.1);
            transform: translateY(-1px);
        }
    </style>
</asp:Content>


<%-- Body contents --%>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Page Header -->
    <div class="page-header">
        <h1>
            <i class="fas fa-users"></i>
            User Management
        </h1>
        <p>Manage students and teachers in your learning management system</p>
    </div>

    <!-- User Management Container -->
    <div class="user-controls">
        <!-- User Type Tabs -->
        <div class="user-tabs">
            <ul class="nav nav-pills" id="userTypeTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button type="button" class="nav-link active" id="students-tab" data-bs-toggle="pill" 
                            data-bs-target="#students" type="button" role="tab">
                        <i class="fas fa-user-graduate me-2"></i>
                        Students
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button type="button" class="nav-link" id="teachers-tab" data-bs-toggle="pill" 
                            data-bs-target="#teachers" type="button" role="tab">
                        <i class="fas fa-chalkboard-teacher me-2"></i>
                        Teachers
                    </button>
                </li>
            </ul>
        </div>

        <!-- Search and Add Controls -->
        <div class="search-add-container">
            <div class="search-box">
                <i class="fas fa-search search-icon"></i>
                <input type="text" id="searchInput" placeholder="Search users by name, email, or department..." 
                       onkeyup="searchUsers()">
            </div>
            <button type="button" class="btn add-user-btn" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-plus me-2"></i>
                Add New User
            </button>
        </div>

        <!-- Tab Content -->
        <div class="tab-content" id="userTypeTabContent">
            <!-- Students Tab -->
            <div class="tab-pane custom-fade show active" id="students" role="tabpanel">
                <div class="users-grid" id="studentsGrid">
                    <!-- Student cards will be loaded here -->
                </div>
            </div>

            <!-- Teachers Tab -->
            <div class="tab-pane custom-fade" id="teachers" role="tabpanel">
                <div class="users-grid" id="teachersGrid">
                    <!-- Teacher cards will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal custom-fade" id="successModal" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-check-circle me-2"></i>
                        Success
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-check-circle text-success fa-3x mb-3"></i>
                    <h5 id="successMessage">Operation completed successfully!</h5>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Error Modal -->
    <div class="modal custom-fade" id="errorModal" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Error
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-exclamation-triangle text-danger fa-3x mb-3"></i>
                    <h5 id="errorMessage">An error occurred!</h5>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>
    
            <%--  Enhanced User Management JavaScript --%>
    <script>
        const body = document.getElementsByTagName('body')[0];
        body.innerHTML += `
            
    <!-- Add/Edit User Modal -->
    <div class="modal custom-fade" id="addUserModal" tabindex="-1" data-form-id="userForm">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus me-2"></i>
                        <span id="modalTitle">Add New User</span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="userForm">
                        <input type="hidden" id="userId">
                        <input type="hidden" id="userAction" value="add">
                        
                        <div class="row">
                            <!-- Profile Picture Section -->
                            <div class="col-md-4">
                                <div class="profile-upload">
                                    <img src="../../../Assest/Images/user.png" 
                                         alt="Profile" id="profilePreview" class="profile-preview">
                                    <div>
                                        <button type="button" class="upload-btn" onclick="document.getElementById('profileInput').click()">
                                            <i class="fas fa-camera me-2"></i>
                                            Upload Photo (Optional)
                                        </button>
                                        <button type="button" class="clear-btn mt-2" onclick="clearProfilePicture()">
                                            <i class="fas fa-times me-2"></i>
                                            Clear Photo
                                        </button>
                                        <input type="file" id="profileInput" accept="image/*" style="display: none;" onchange="previewProfile(this)">
                                        <p class="text-muted small mt-2">Profile picture is optional. A default avatar will be used if none is provided.</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Form Fields -->
                            <div class="col-md-8">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="fullName" class="form-label">Full Name *</label>
                                            <input type="text" class="form-control" id="fullName" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="email" class="form-label">Email Address *</label>
                                            <input type="email" class="form-control" id="email" required onblur="validateEmailField(this)">
                                            <div class="input-icon-container">
                                                <i id="emailIcon" class="fas fa-check-circle email-validation-icon" style="display: none;"></i>
                                                <div id="emailFeedback" class="email-feedback"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="phone" class="form-label">Phone Number *</label>
                                            <div class="phone-input-container">
                                                <input type="tel" class="form-control" id="phone" 
                                                       placeholder="+233 50 123 4567" 
                                                       oninput="validatePhoneNumber(this)" required>
                                                <i class="fas fa-phone phone-validation-icon" id="phoneIcon" style="display: none;"></i>
                                            </div>
                                            <div class="phone-feedback" id="phoneFeedback"></div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="userType" class="form-label">User Type *</label>
                                            <select class="form-select" id="userType" onchange="toggleUserFields()" required>
                                                <option value="">Select User Type</option>
                                                <option value="student">Student</option>
                                                <option value="teacher">Teacher</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="department" class="form-label">Department *</label>
                                            <select class="form-select" id="department" required>
                                                <option value="">Select Department</option>
                                                <!-- Departments will be loaded dynamically from the database -->
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="levelField">
                                        <div class="form-group">
                                            <label for="level" class="form-label">Level</label>
                                            <select class="form-select" id="level">
                                                <option value="">Select Level</option>
                                                <!-- Levels will be loaded dynamically from the database -->
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="programme" class="form-label">Programme</label>
                                            <select class="form-select" id="programme">
                                                <option value="">Select Programme</option>
                                                <!-- Programmes will be loaded dynamically from the database -->
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6" id="employeeIdField" style="display: none;">
                                        <div class="form-group">
                                            <label for="employeeId" class="form-label">Employee ID</label>
                                            <input type="text" class="form-control" id="employeeId">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Course Assignment Section -->
                        <div class="row mt-4" id="courseSection">
                            <div class="col-12">
                                <h6 class="mb-3">Course Assignment</h6>
                                <div class="row">
                                    <div class="col-md-8">
                                        <select class="form-select" id="courseSelect">
                                            <option value="">Select Course to Assign</option>
                                            <option value="CS101">CS101 - Introduction to Computer Science</option>
                                            <option value="MATH201">MATH201 - Calculus II</option>
                                            <option value="ENG101">ENG101 - English Composition</option>
                                            <option value="BUS205">BUS205 - Business Ethics</option>
                                            <option value="EDU301">EDU301 - Educational Psychology</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <button type="button" class="btn btn-outline-primary w-100" onclick="assignCourse()">
                                            <i class="fas fa-plus me-2"></i>
                                            Assign Course
                                        </button>
                                    </div>
                                </div>
                                <div class="course-tags" id="assignedCourses">
                                    <!-- Assigned courses will appear here -->
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveUser()">
                        <i class="fas fa-save me-2"></i>
                        <span id="saveButtonText">Save User</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View User Modal -->
    <div class="modal custom-fade" id="viewUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>
                        User Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4 text-center">
                            <img src="" alt="Profile" id="viewProfilePic" class="profile-preview mb-3">
                            <h5 id="viewFullName">User Name</h5>
                            <span class="badge bg-primary" id="viewUserType">Student</span>
                        </div>
                        <div class="col-md-8">
                            <div class="detail-row">
                                <span class="detail-label">Email:</span>
                                <span class="detail-value" id="viewEmail">email@example.com</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Phone:</span>
                                <span class="detail-value" id="viewPhone">+233 50 123 4567</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Department:</span>
                                <span class="detail-value" id="viewDepartment">Computer Science</span>
                            </div>
                            <div class="detail-row" id="viewLevelRow">
                                <span class="detail-label">Level:</span>
                                <span class="detail-value" id="viewLevel">Level 300</span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Programme:</span>
                                <span class="detail-value" id="viewProgramme">Computer Science</span>
                            </div>
                            <div class="detail-row" id="viewEmployeeIdRow" style="display: none;">
                                <span class="detail-label">Employee ID:</span>
                                <span class="detail-value" id="viewEmployeeId">EMP001</span>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-4">
                        <div class="col-12">
                            <h6>Assigned Courses:</h6>
                            <div class="course-tags" id="viewAssignedCourses">
                                <!-- Courses will be displayed here -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-warning" onclick="editUserFromView()">
                        <i class="fas fa-edit me-2"></i>
                        Edit User
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal custom-fade" id="deleteUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-trash me-2"></i>
                        Delete User
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-exclamation-triangle text-warning fa-3x mb-3"></i>
                    <h5>Are you sure you want to delete this user?</h5>
                    <p class="text-muted mb-3">
                        <strong id="deleteUserName">User Name</strong><br>
                        This action cannot be undone. All user data will be permanently removed.
                    </p>
                    <input type="hidden" id="deleteUserId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDeleteUser()">
                        <i class="fas fa-trash me-2"></i>
                        Yes, Delete User
                    </button>
                </div>
            </div>
        </div>
    </div>

        `;


        // Test function to ensure JavaScript is working
        function testFunction() {
            console.log('JavaScript is working!');
            console.log('jQuery available: ' + (typeof $ !== 'undefined'));
            console.log('Bootstrap available: ' + (typeof bootstrap !== 'undefined'));
            console.log('Modal element exists: ' + (document.getElementById('addUserModal') !== null));
            return true;
        }

        // Fixed Custom Theme - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize page with fixed custom theme
            console.log('Fixed custom theme applied to User.aspx');
            
            // Test that everything is loading
            console.log('DOM Content Loaded - initializing...');
            
            // Initialize custom modal handlers
            initializeCustomModals();
            
            // Initialize User Management functionality
            initializeUserManagement();
        });        // Initialize custom modal system
        function initializeCustomModals() {
            console.log('Initializing custom modals...');
            
            // Load custom animations if available
            if (window.CustomAnimations && typeof window.CustomAnimations.init === 'function') {
                window.CustomAnimations.init();
                console.log('Custom animations initialized');
            } else {
                console.log('Custom animations not available or init method not found');
            }
            
            // Simple event listeners - let Bootstrap handle backdrop creation
            const customModals = document.querySelectorAll('.modal.custom-fade');
            console.log('Found custom modals:', customModals.length);
            
            customModals.forEach(modal => {
                modal.addEventListener('shown.bs.modal', function(e) {
                    console.log('Custom modal shown event:', this.id);
                    
                    // Ensure modal is fully visible and interactive
                    this.style.pointerEvents = 'auto';
                    this.style.opacity = '1';
                    
                    // Focus on first input
                    const firstInput = this.querySelector('input:not([type="hidden"]), select, textarea');
                    if (firstInput) {
                        setTimeout(() => firstInput.focus(), 100);
                    }
                });
                
                modal.addEventListener('hide.bs.modal', function(e) {
                    console.log('Custom modal hide event:', this.id);
                    // Clean animation state
                    this.style.pointerEvents = 'none';
                });
            });
        }

        // Global variables
        let currentUser = null;
        let assignedCourses = [];
        let availableCourses = [];

        // Reset user form
        function resetUserForm() {
            // Try direct modal content selection first since Bootstrap may move the modal in the DOM
            const modal = document.getElementById('addUserModal');
            let form = null;
            
            if (modal) {
                // Look for the form within the modal
                form = modal.querySelector('form') || modal.querySelector('#userForm');
                console.log('Looking for form inside modal element:', form);
            }
            
            // Fallback to global search
            if (!form) {
                form = document.getElementById('userForm');
                console.log('Fallback to global form search:', form);
            }
            
            // Last resort - check all forms
            if (!form) {
                const allForms = document.querySelectorAll('form');
                console.log('All forms on page:', allForms.length);
                // Try to find the form within the modal content
                if (allForms.length > 0) {
                    // Use the first form as a fallback
                    form = allForms[0];
                    console.log('Using first available form:', form);
                }
            }
            
            if (!form) {
                console.error('User form element not found!');
                console.log('Available forms:', document.querySelectorAll('form'));
                return;
            }
            
            console.log('Form found, resetting:', form);
            try {
                form.reset();
                console.log('Form reset successfully');
            } catch (error) {
                console.error('Error resetting form:', error);
            }
            
            // Check for other elements before accessing
            const userIdEl = document.getElementById('userId');
            const userActionEl = document.getElementById('userAction');
            const modalTitleEl = document.getElementById('modalTitle');
            const saveButtonTextEl = document.getElementById('saveButtonText');
            const profilePreviewEl = document.getElementById('profilePreview');
            const levelFieldEl = document.getElementById('levelField');
            const employeeIdFieldEl = document.getElementById('employeeIdField');
            const phoneInputEl = document.getElementById('phone');
            const phoneIconEl = document.getElementById('phoneIcon');
            const phoneFeedbackEl = document.getElementById('phoneFeedback');
            
            // Set values if elements exist
            if (userIdEl) userIdEl.value = '';
            if (userActionEl) userActionEl.value = 'add';
            if (modalTitleEl) modalTitleEl.textContent = 'Add New User';
            if (saveButtonTextEl) saveButtonTextEl.textContent = 'Save User';
            
            // Reset profile preview
            if (profilePreviewEl) profilePreviewEl.src = '../../../Assest/Images/user.png';
            
            // Reset assigned courses - make sure assignedCourses is defined
            if (typeof assignedCourses === 'undefined') {
                window.assignedCourses = [];
                console.log('Created new assignedCourses array');
            } else {
                assignedCourses = [];
                console.log('Reset existing assignedCourses array');
            }
            
            try {
                console.log('Calling updateCourseDisplay...');
                updateCourseDisplay();
                console.log('updateCourseDisplay completed');
            } catch (error) {
                console.error('Error updating course display:', error);
            }
            
            // Reset field visibility
            if (levelFieldEl) levelFieldEl.style.display = 'none';
            if (employeeIdFieldEl) employeeIdFieldEl.style.display = 'none';
            
            // Reset phone validation
            if (phoneInputEl) phoneInputEl.classList.remove('phone-valid', 'phone-invalid');
            if (phoneIconEl) {
                phoneIconEl.style.display = 'none';
                phoneFeedbackEl.textContent = '';
                phoneFeedbackEl.classList.remove('valid', 'invalid');
            }
            
            // Reset email validation
            const emailInputEl = document.getElementById('email');
            const emailIconEl = document.getElementById('emailIcon');
            const emailFeedbackEl = document.getElementById('emailFeedback');
            
            if (emailInputEl) emailInputEl.classList.remove('email-valid', 'email-invalid');
            if (emailIconEl) {
                emailIconEl.style.display = 'none';
                emailFeedbackEl.textContent = '';
                emailFeedbackEl.classList.remove('valid', 'invalid');
            }
        }

        // Show success message
        function showSuccess(message) {
            document.getElementById('successMessage').textContent = message;
            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
            successModal.show();
        }

        // Show error message
        function showError(message) {
            document.getElementById('errorMessage').textContent = message;
            const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
            errorModal.show();
        }

        // Prepare Add User Modal - simplified approach
        function prepareAddUserModal() {
            console.log('Preparing add user modal...');
            
            try {
                resetUserForm();
                console.log('Add user modal preparation completed successfully');
            } catch (error) {
                console.error('Error in prepareAddUserModal:', error);
            }
        }

        // Load users based on current tab
        function loadUsers() {
            const activeTab = document.querySelector('.nav-link.active').getAttribute('data-bs-target');
            const isStudents = activeTab === '#students';
            const userType = isStudents ? 'Student' : 'Teacher';
            
            console.log('Loading users of type:', userType);
            
            // Show loading state
            const gridId = isStudents ? 'studentsGrid' : 'teachersGrid';
            const grid = document.getElementById(gridId);
            grid.innerHTML = '<div class="text-center p-4"><i class="fas fa-spinner fa-spin fa-2x"></i><br>Loading users...</div>';
            
            // Call our separate endpoint
            $.ajax({
                type: "POST",
                url: "UsersWithIds.aspx/GetAllUsersWithId",
                data: JSON.stringify({ userType: userType }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    console.log('Users loaded, response:', response);
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        console.log('Users data:', result.data);
                        displayUsers(result.data, gridId);
                    } else {
                        console.error('Error in loadUsers:', result.message);
                        showError(result.message);
                        grid.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle"></i><h4>Error Loading Users</h4><p>' + result.message + '</p></div>';
                    }
                },
                error: function(xhr, status, error) {
                    console.error('AJAX Error in loadUsers:', xhr.responseText);
                    showError('Error loading users: ' + error);
                    grid.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle"></i><h4>Error Loading Users</h4><p>Please try again later.</p></div>';
                }
            });
        }

        // Display users in the grid
        function displayUsers(users, gridId) {
            const grid = document.getElementById(gridId);
            
            if (users.length === 0) {
                const userType = gridId.includes('students') ? 'Students' : 'Teachers';
                grid.innerHTML = `
                    <div class="empty-state">
                        <i class="fas fa-users"></i>
                        <h4>No ${userType} Found</h4>
                        <p>Start by adding a new ${userType.toLowerCase().slice(0, -1)} to the system.</p>
                    </div>
                `;
                return;
            }
            
            grid.innerHTML = users.map(user => createUserCard(user)).join('');
        }

        // Load available courses for assignment
        function loadAvailableCourses() {
            $.ajax({
                type: "POST",
                url: "User.aspx/GetAvailableCourses",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        availableCourses = result.data;
                        updateCourseSelect();
                    } else {
                        console.error('Error loading courses:', result.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading courses:', error);
                }
            });
        }

        // Update course select dropdown
        function updateCourseSelect() {
            const courseSelect = document.getElementById('courseSelect');
            courseSelect.innerHTML = '<option value="">Select Course to Assign</option>';
            
            availableCourses.forEach(course => {
                const option = document.createElement('option');
                option.value = course.code;
                option.textContent = course.display;
                courseSelect.appendChild(option);
            });
        }
            
        // Phone validation patterns for different countries/regions
        const phonePatterns = {
            ghana: /^(\+233|0)(20|23|24|26|27|28|50|53|54|55|56|57|59)\d{7}$/,
            international: /^\+[1-9]\d{1,14}$/,
            us: /^(\+1|1)?[-.\s]?\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}$/,
            uk: /^(\+44|0)[1-9]\d{8,9}$/
        };

        // Validate phone number
        function validatePhoneNumber(input) {
            const phoneValue = input.value.trim();
            const phoneIcon = document.getElementById('phoneIcon');
            const phoneFeedback = document.getElementById('phoneFeedback');
            
            // Clear previous states
            input.classList.remove('phone-valid', 'phone-invalid');
            phoneIcon.classList.remove('valid', 'invalid');
            phoneIcon.style.display = 'none';
            phoneFeedback.textContent = '';
            phoneFeedback.classList.remove('valid', 'invalid');
            
            if (phoneValue === '') {
                return false;
            }
            
            // Check against different patterns
            let isValid = false;
            let feedbackMessage = '';
            
            if (phonePatterns.ghana.test(phoneValue)) {
                isValid = true;
                feedbackMessage = 'Valid Ghana phone number';
            } else if (phonePatterns.international.test(phoneValue)) {
                isValid = true;
                feedbackMessage = 'Valid international phone number';
            } else {
                // Try to suggest correct format
                if (phoneValue.length < 10) {
                    feedbackMessage = 'Phone number too short. Use format: +233 50 123 4567';
                } else if (phoneValue.length > 15) {
                    feedbackMessage = 'Phone number too long. Use format: +233 50 123 4567';
                } else if (!phoneValue.startsWith('+') && !phoneValue.startsWith('0')) {
                    feedbackMessage = 'Phone number should start with + or 0. Use format: +233 50 123 4567';
                } else {
                    feedbackMessage = 'Invalid phone number format. Use: +233 50 123 4567';
                }
            }
            
            // Apply validation styles
            if (isValid) {
                input.classList.add('phone-valid');
                phoneIcon.className = 'fas fa-check-circle phone-validation-icon valid';
                phoneFeedback.className = 'phone-feedback valid';
                phoneIcon.style.display = 'block';
            } else {
                input.classList.add('phone-invalid');
                phoneIcon.className = 'fas fa-times-circle phone-validation-icon invalid';
                phoneFeedback.className = 'phone-feedback invalid';
                phoneIcon.style.display = 'block';
            }
            
            phoneFeedback.textContent = feedbackMessage;
            return isValid;
        }

        // Validate email field with visual feedback
        function validateEmailField(input) {
            const emailValue = input.value.trim();
            const emailIcon = document.getElementById('emailIcon');
            const emailFeedback = document.getElementById('emailFeedback');
            
            // Clear previous states
            input.classList.remove('email-valid', 'email-invalid');
            emailIcon.classList.remove('valid', 'invalid');
            emailIcon.style.display = 'none';
            emailFeedback.textContent = '';
            emailFeedback.classList.remove('valid', 'invalid');
            
            if (emailValue === '') {
                return false;
            }
            
            // Check email format
            const isValid = validateEmail(emailValue);
            let feedbackMessage = '';
            
            if (isValid) {
                feedbackMessage = 'Valid email address';
                input.classList.add('email-valid');
                emailIcon.className = 'fas fa-check-circle email-validation-icon valid';
                emailFeedback.className = 'email-feedback valid';
            } else {
                feedbackMessage = 'Invalid email format. Please use format: name@example.com';
                input.classList.add('email-invalid');
                emailIcon.className = 'fas fa-times-circle email-validation-icon invalid';
                emailFeedback.className = 'email-feedback invalid';
            }
            
            emailIcon.style.display = 'block';
            emailFeedback.textContent = feedbackMessage;
            return isValid;
        }

        // Validate email format
        function validateEmail(email) {
            const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return emailRegex.test(email);
        }

        // Format phone number as user types
        function formatPhoneNumber(input) {
            let value = input.value.replace(/\D/g, '');
            
            // Handle Ghana numbers
            if (value.startsWith('233')) {
                // International format with +233
                value = '+233 ' + value.substring(3, 5) + ' ' + value.substring(5, 8) + ' ' + value.substring(8, 12);
            } else if (value.startsWith('0')) {
                // Local format
                value = value.substring(0, 3) + ' ' + value.substring(3, 6) + ' ' + value.substring(6, 10);
            }
            
            input.value = value;
        }

        // Enhanced phone validation with formatting
        function validateAndFormatPhone(input) {
            // First format the number
            formatPhoneNumber(input);
            // Then validate it
            return validatePhoneNumber(input);
        }

        // Create user card HTML
        function createUserCard(user) {
            // Validate profile pic URL
           let profilePic = user.profilePic;
// No need for base64 or user.png fallback, backend always provides a valid URL or initials avatar

            const coursesList = user.courses.map(course => 
                `<span class="badge bg-secondary me-1">${course}</span>`
            ).join('');
            
            return `
                <div class="user-card card-animate stagger-animate">
                    <div class="user-card-header">
                        <img src="${profilePic}" alt="${user.fullName}" class="user-avatar"
                 onerror="this.onerror=null;this.src='../../../Assest/Images/user.png';">
                        <div class="user-basic-info">
                            <h5>${user.fullName}</h5>
                            <div class="email">${user.email}</div>
                        </div>
                    </div>
                    <div class="user-details">
                        <div class="detail-row">
                            <span class="detail-label">Phone:</span>
                            <span class="detail-value">${user.phone}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Department:</span>
                            <span class="detail-value">${user.department}</span>
                        </div>
                        ${user.userType === 'student' ? `
                        <div class="detail-row">
                            <span class="detail-label">Level:</span>
                            <span class="detail-value">Level ${user.level}</span>
                        </div>` : ''}
                        <div class="detail-row">
                            <span class="detail-label">Programme:</span>
                            <span class="detail-value">${user.programme}</span>
                        </div>
                        <div class="detail-row">
                            <span class="detail-label">Courses:</span>
                            <span class="detail-value">${coursesList}</span>
                        </div>
                    </div>
                    <div class="user-actions">
                        <button type="button" class="btn btn-action btn-view" onclick="viewUser(${user.id})">
                            <i class="fas fa-eye"></i> View
                        </button>
                        <button type="button" class="btn btn-action btn-edit" onclick="editUser(${user.id})">
                            <i class="fas fa-edit"></i> Edit
                        </button>
                        <button type="button" class="btn btn-action btn-delete" onclick="deleteUser(${user.id})">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </div>
            `;
        }

        // Search users
        function searchUsers() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const activeTab = document.querySelector('.nav-link.active').getAttribute('data-bs-target');
            const isStudents = activeTab === '#students';
            const userType = isStudents ? 'Student' : 'Teacher';
            const gridId = isStudents ? 'studentsGrid' : 'teachersGrid';
            const grid = document.getElementById(gridId);
            
            if (searchTerm.trim() === '') {
                loadUsers();
                return;
            }
            
            // Show loading state
            grid.innerHTML = '<div class="text-center p-4"><i class="fas fa-spinner fa-spin fa-2x"></i><br>Searching...</div>';
            
            // Call our separate endpoint for search
            $.ajax({
                type: "POST",
                url: "UsersWithIds.aspx/SearchUsers",
                data: JSON.stringify({ searchTerm: searchTerm, userType: userType }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        if (result.data.length === 0) {
                            grid.innerHTML = `
                                <div class="empty-state">
                                    <i class="fas fa-search"></i>
                                    <h4>No Results Found</h4>
                                    <p>Try adjusting your search terms.</p>
                                </div>
                            `;
                        } else {
                            displayUsers(result.data, gridId);
                        }
                    } else {
                        showError(result.message);
                        grid.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle"></i><h4>Search Error</h4><p>' + result.message + '</p></div>';
                    }
                },
                error: function(xhr, status, error) {
                    showError('Error searching users: ' + error);
                    grid.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-triangle"></i><h4>Search Error</h4><p>Please try again later.</p></div>';
                }
            });
        }

        // Toggle user type fields
        function toggleUserFields() {
            const userType = document.getElementById('userType').value;
            const levelField = document.getElementById('levelField');
            const employeeIdField = document.getElementById('employeeIdField');
            
            if (userType === 'student') {
                levelField.style.display = 'block';
                employeeIdField.style.display = 'none';
                document.getElementById('level').required = true;
                document.getElementById('employeeId').required = false;
            } else if (userType === 'teacher') {
                levelField.style.display = 'none';
                employeeIdField.style.display = 'block';
                document.getElementById('level').required = false;
                // Set to true for UI validation, but we'll handle actual validation in saveUser
                document.getElementById('employeeId').required = false;
                
                // Add a note about Employee ID
                const employeeIdNote = document.getElementById('employeeIdNote') || createEmployeeIdNote();
                employeeIdNote.style.display = 'block';
            } else {
                levelField.style.display = 'none';
                employeeIdField.style.display = 'none';
                document.getElementById('level').required = false;
                document.getElementById('employeeId').required = false;
                
                // Hide the note
                const employeeIdNote = document.getElementById('employeeIdNote');
                if (employeeIdNote) {
                    employeeIdNote.style.display = 'none';
                }
            }
        }
        
        function createEmployeeIdNote() {
            const note = document.createElement('small');
            note.id = 'employeeIdNote';
            note.className = 'form-text text-muted';
            note.innerHTML = 'Enter a valid Employee ID from the Employee database. If left blank or invalid, it will be saved as empty.';
            
            const employeeIdField = document.getElementById('employeeIdField');
            if (employeeIdField) {
                employeeIdField.querySelector('.form-group').appendChild(note);
            }
            
            return note;
        }

        // Preview profile picture
        // Preview profile picture
        function previewProfile(input) {
    if (input.files && input.files[0]) {
        // Validate file size (limit to 2MB)
        const maxSize = 2 * 1024 * 1024; // 2MB in bytes
        if (input.files[0].size > maxSize) {
            showError('Profile picture is too large. Please select an image under 2MB.');
            input.value = '';
            return;
        }
        // Validate file type
        const fileType = input.files[0].type;
        if (!fileType.startsWith('image/')) {
            showError('Please select a valid image file (JPEG, PNG, GIF, etc.)');
            input.value = '';
            return;
        }
        // Upload to server and set preview to returned URL
        const file = input.files[0];
        const reader = new FileReader();
        reader.onload = function(e) {
            $.ajax({
                type: "POST",
                url: "User.aspx/UploadProfilePicture",
                data: JSON.stringify({ imageData: e.target.result, fileName: file.name }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = response.d ? JSON.parse(response.d) : {};
                    if (result.success) {
                        // Set preview to the uploaded image URL
                        const previewEl = document.getElementById('profilePreview');
                        if (previewEl) {
                            previewEl.src = result.filePath.replace('~', '');
                        }
                    } else {
                        showError(result.message || "Failed to upload image");
                    }
                },
                error: function(xhr, status, error) {
                    showError("Error uploading image: " + error);
                }
            });
        };
        reader.readAsDataURL(file);
    }
}
        
        function clearProfilePicture() {
            // Reset the file input
            const fileInput = document.getElementById('profilePicture');
            if (fileInput) {
                fileInput.value = '';
            }
            
            // Reset the preview image to default
            const previewEl = document.getElementById('profilePreview');
            if (previewEl) {
                // Set to default avatar image
                previewEl.src = '../../../Assest/Images/user.png';
            }
            
            // Show success message
            showSuccess('Profile picture cleared');
        }

        // Assign course
        function assignCourse() {
            const courseSelect = document.getElementById('courseSelect');
            const courseCode = courseSelect.value;
            const courseName = courseSelect.options[courseSelect.selectedIndex].text;
            
            if (!courseCode) {
                showError('Please select a course to assign');
                return;
            }
            
            if (assignedCourses.includes(courseCode)) {
                showError('Course already assigned');
                return;
            }
            
            assignedCourses.push(courseCode);
            updateCourseDisplay();
            courseSelect.value = '';
        }

        // Remove course
        function removeCourse(courseCode) {
            assignedCourses = assignedCourses.filter(code => code !== courseCode);
            updateCourseDisplay();
        }

        // Update course display
        function updateCourseDisplay() {
            const container = document.getElementById('assignedCourses');
            if (!container) {
                console.error('Error: assignedCourses container not found!');
                return;
            }
            
            // Make sure assignedCourses is defined
            if (typeof assignedCourses === 'undefined') {
                console.warn('assignedCourses is undefined, creating empty array');
                window.assignedCourses = [];
                assignedCourses = [];
            }
            
            container.innerHTML = assignedCourses.map(courseCode => `
                <span class="course-tag">
                    ${courseCode}
                    <span class="remove-course" onclick="removeCourse('${courseCode}')">
                        <i class="fas fa-times"></i>
                    </span>
                </span>
            `).join('');
        }

        // Save user
        function saveUser() {
            // Use our enhanced form finder with virtual form support
            const form = window.findFormInModal ? 
                         window.findFormInModal('addUserModal', 'userForm') : 
                         (document.getElementById('userForm') || document.querySelector('#addUserModal .virtual-form'));
                         
            if (!form) {
                console.error('User form not found!');
                console.log('Available forms:', document.querySelectorAll('form'));
                console.log('Virtual forms available:', window.virtualForms ? 'Yes' : 'No');
                showError('Form not found. Please try again or reload the page.');
                return;
            }
            
            console.log('Form found for saving:', form);
            
            // Get form input values directly instead of relying on form.elements
            const fullName = document.getElementById('fullName') ? document.getElementById('fullName').value : '';
            const email = document.getElementById('email') ? document.getElementById('email').value : '';
            const phone = document.getElementById('phone') ? document.getElementById('phone').value : '';
            const userType = document.getElementById('userType') ? document.getElementById('userType').value : '';
            
            // Validate basic required fields
            if (!fullName || !email || !phone || !userType) {
                showError('Please fill in all required fields');
                return;
            }
            
            // Validate email format
            if (!validateEmail(email)) {
                showError('Please enter a valid email address');
                const emailInput = document.getElementById('email');
                if (emailInput) emailInput.focus();
                return;
            }
            
            // Validate phone
            const phoneInput = document.getElementById('phone');
            if (phoneInput) {
                // Validate phone number
                const isPhoneValid = validatePhoneNumber(phoneInput);
                if (!isPhoneValid) {
                    showError('Please enter a valid phone number in the format: +233 50 123 4567');
                    if (phoneInput) phoneInput.focus();
                    return;
                }
            }
            
            const action = document.getElementById('userAction').value;
            
            // Get profile picture or use default if it hasn't been changed from placeholder
            const profilePicEl = document.getElementById('profilePreview');
            const defaultProfilePic = '../../../Assest/Images/user.png';
            let profilePic = defaultProfilePic;
            
            // Only use the profile picture if it's not the default avatar
            if (profilePicEl && !profilePicEl.src.includes('user.png')) {
                profilePic = profilePicEl.src;
            }
            
            // Check if user is a teacher and has an empty Employee ID
            const userRoleType = document.getElementById('userType').value;
            const employeeId = document.getElementById('employeeId').value.trim();
            
            if (userRoleType === 'teacher' && !employeeId) {
                // Show a confirmation dialog
                Swal.fire({
                    title: 'Missing Employee ID',
                    text: 'No Employee ID provided for teacher. Do you want to continue without an Employee ID?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Continue',
                    cancelButtonText: 'Go Back'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Proceed with save
                        proceedWithSave();
                    } else {
                        // Focus on the employee ID field
                        const employeeIdInput = document.getElementById('employeeId');
                        if (employeeIdInput) employeeIdInput.focus();
                    }
                });
            } else {
                // Proceed with normal save
                proceedWithSave();
            }
            
            function proceedWithSave() {
                // Get dropdown values and IDs
                const dropdownValues = getDropdownIdValues();
                
                const userData = {
                    id: action === 'edit' ? parseInt(document.getElementById('userId').value) : 0,
                    fullName: document.getElementById('fullName').value,
                    email: document.getElementById('email').value,
                    phone: document.getElementById('phone').value,
                    userType: document.getElementById('userType').value,
                    department: dropdownValues.departmentName,
                    departmentId: dropdownValues.departmentId,
                    level: dropdownValues.levelName,
                    levelId: dropdownValues.levelId,
                    programme: dropdownValues.programmeName,
                    programmeId: dropdownValues.programmeId,
                    profilePic: profilePic,
                    courses: [...assignedCourses],
                    employeeId: document.getElementById('employeeId').value
                };
            
                // Show loading state
                const saveButton = document.querySelector('#addUserModal .btn-primary');
                const originalText = saveButton.innerHTML;
                saveButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
                saveButton.disabled = true;
                
                // Call server-side method
                $.ajax({
                    type: "POST",
                    url: "User.aspx/SaveUser",
                    data: JSON.stringify({ userData: JSON.stringify(userData) }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        const result = JSON.parse(response.d);
                        if (result.success) {
                            showSuccess(result.message);
                            
                            // Add null check before hiding modal
                            const addModal = bootstrap.Modal.getInstance(document.getElementById('addUserModal'));
                            if (addModal) addModal.hide();
                            
                            resetForm();
                            loadUsers();
                        } else {
                            showError(result.message);
                            
                            // Handle specific errors
                            if (result.message.includes("FOREIGN KEY constraint") && result.message.includes("EmployeelD")) {
                                // Show more specific error for employee ID issues
                                Swal.fire({
                                    title: 'Employee ID Error',
                                    html: 'The Employee ID you entered does not exist in the Employee database.<br><br>Please provide a valid Employee ID or leave it blank.',
                                    icon: 'error',
                                    confirmButtonText: 'OK'
                                }).then(() => {
                                    // Focus on the employee ID field
                                    const employeeIdInput = document.getElementById('employeeId');
                                    if (employeeIdInput) {
                                        employeeIdInput.focus();
                                        employeeIdInput.select();
                                    }
                                });
                            }
                        }
                    },
                    error: function(xhr, status, error) {
                        showError('Error saving user: ' + error);
                    },
                    complete: function() {
                        // Restore button state
                        saveButton.innerHTML = originalText;
                        saveButton.disabled = false;
                    }
                });
            }
        }  // End of saveUser function
        
        // View user
        function viewUser(userId) {
            console.log("Viewing user with ID:", userId);
            // Call server to get user details
            $.ajax({
                type: "POST",
                url: "UsersWithIds.aspx/GetUserDetails", // Changed to use our new endpoint
                data: JSON.stringify({ userId: userId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    console.log("View user response:", response);
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        const user = result.data;
                        console.log("User data:", user);
                        
                        // Validate profile pic URL
                       let profilePic = user.profilePic;
document.getElementById('viewProfilePic').src = profilePic;

                       document.getElementById('viewProfilePic').setAttribute('data-original-src', profilePic);
                       document.getElementById('viewProfilePic').onerror = function() {
                           this.src = '../../../Assest/Images/user.png';
                           console.error('Image failed to load in detail view for:', user.fullName,
                                         'Original src:', this.getAttribute('data-original-src'));
                        };
                        document.getElementById('viewFullName').textContent = user.fullName;
                        document.getElementById('viewUserType').textContent = user.userType.charAt(0).toUpperCase() + user.userType.slice(1);
                        document.getElementById('viewEmail').textContent = user.email;
                        document.getElementById('viewPhone').textContent = user.phone;
                        document.getElementById('viewDepartment').textContent = user.department;
                        document.getElementById('viewLevel').textContent = user.level ? `Level ${user.level}` : 'N/A';
                        document.getElementById('viewProgramme').textContent = user.programme;
                        document.getElementById('viewEmployeeId').textContent = user.employeeId || 'N/A';
                        
                        // Show/hide fields based on user type
                        if (user.userType === 'student') {
                            document.getElementById('viewLevelRow').style.display = 'flex';
                            document.getElementById('viewEmployeeIdRow').style.display = 'none';
                        } else {
                            document.getElementById('viewLevelRow').style.display = 'none';
                            document.getElementById('viewEmployeeIdRow').style.display = 'flex';
                        }
                        
                        // Display courses
                        const coursesContainer = document.getElementById('viewAssignedCourses');
                        coursesContainer.innerHTML = user.courses.map(course => 
                            `<span class="course-tag">${course}</span>`
                        ).join('');
                        
                        // Store the current user in the global variable and also as a data attribute
                        currentUser = user;
                        const viewUserModal = document.getElementById('viewUserModal');
                        viewUserModal.setAttribute('data-user-id', user.id);
                        console.log("Set currentUser in viewUser function:", user.id);
                        
                        // Show the modal
                        new bootstrap.Modal(viewUserModal).show();
                    } else {
                        showError(result.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error in viewUser:", xhr.responseText);
                    showError('Error loading user details: ' + error);
                }
            });
        }

        // Edit user
        function editUser(userId) {
            console.log("Editing user with ID:", userId);
            // Call server to get user details
            $.ajax({
                type: "POST",
                url: "UsersWithIds.aspx/GetUserDetails", // Changed to use our new endpoint
                data: JSON.stringify({ userId: userId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    console.log("Edit user response:", response); // Debug logging
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        const user = result.data;
                        console.log("User data for editing:", user);
                        
                        // Set modal title and action
                        document.getElementById('modalTitle').textContent = 'Edit User';
                        document.getElementById('saveButtonText').textContent = 'Update User';
                        document.getElementById('userAction').value = 'edit';
                        document.getElementById('userId').value = user.id;
                        
                        // Populate form fields
                        document.getElementById('fullName').value = user.fullName;
                        document.getElementById('email').value = user.email;
                        document.getElementById('phone').value = user.phone;
                        document.getElementById('userType').value = user.userType;
                        document.getElementById('employeeId').value = user.employeeId;
                        document.getElementById('profilePreview').src = user.profilePic;
                        
                        // Set assigned courses
                        assignedCourses = [...user.courses];
                        updateCourseDisplay();
                        
                        // Set dropdown values using our helper function
                        setDropdownValues(user, function() {
                            // Toggle fields based on user type
                            toggleUserFields();
                            
                            // Validate phone number after setting the value
                            validatePhoneNumber(document.getElementById('phone'));
                            
                            // Show the modal
                            new bootstrap.Modal(document.getElementById('addUserModal')).show();
                        });
                    } else {
                        showError(result.message);
                    }
                },
                error: function(xhr, status, error) {
                    showError('Error loading user details: ' + error);
                    console.error('AJAX Error in editUser:', xhr.responseText);
                }
            });
        }

        // Edit user from view modal
        function editUserFromView() {
            // Add null check before hiding modal
            const viewModal = bootstrap.Modal.getInstance(document.getElementById('viewUserModal'));
            const viewUserModalElement = document.getElementById('viewUserModal');
            
            // Get the user ID from either the currentUser object or the data attribute
            let userId = null;
            if (currentUser && currentUser.id) {
                userId = currentUser.id;
                console.log("Using currentUser.id:", userId);
            } else if (viewUserModalElement && viewUserModalElement.getAttribute('data-user-id')) {
                userId = viewUserModalElement.getAttribute('data-user-id');
                console.log("Using data-user-id attribute:", userId);
            }
            
            // Hide the view modal
            if (viewModal) viewModal.hide();
            
            // Check if we have a valid user ID
            if (userId) {
                console.log("Editing user from view:", userId);
                // Add a small delay to allow the modal to close completely
                setTimeout(() => editUser(userId), 300);
            } else {
                console.error("Error: Unable to determine user ID");
                showError("Unable to edit user: User data not found. Please try again.");
            }
        }

        // Delete user
        function deleteUser(userId) {
            console.log("Deleting user with ID:", userId);
            // Get user name for confirmation
            $.ajax({
                type: "POST",
                url: "UsersWithIds.aspx/GetUserDetails", // Changed to use our new endpoint
                data: JSON.stringify({ userId: userId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    console.log("Delete user response:", response);
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        const user = result.data;
                        document.getElementById('deleteUserName').textContent = user.fullName;
                        document.getElementById('deleteUserId').value = userId;
                        
                        new bootstrap.Modal(document.getElementById('deleteUserModal')).show();
                    } else {
                        showError(result.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error in deleteUser:", xhr.responseText);
                    showError('Error loading user details: ' + error);
                }
            });
        }

        // Confirm delete user
        function confirmDeleteUser() {
            const userId = parseInt(document.getElementById('deleteUserId').value);
            const userName = document.getElementById('deleteUserName').textContent;
            
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    title: 'Delete User?',
                    text: `Are you sure you want to delete ${userName}? This action cannot be undone.`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: 'var(--danger-color)',
                    cancelButtonColor: 'var(--medium-gray)',
                    confirmButtonText: 'Yes, Delete',
                    cancelButtonText: 'Cancel',
                    background: 'var(--white)',
                    color: 'var(--text-color)'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Call server to delete user
                        $.ajax({
                            type: "POST",
                            url: "User.aspx/DeleteUser",
                            data: JSON.stringify({ userId: userId }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function(response) {
                                const deleteResult = JSON.parse(response.d);
                                if (deleteResult.success) {
                                    // Hide delete modal
                                    const deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteUserModal'));
                                    if (deleteModal) deleteModal.hide();
                                    
                                    showSuccess('User deleted successfully!');
                                    loadUsers();
                                } else {
                                    showError(deleteResult.message);
                                }
                            },
                            error: function(xhr, status, error) {
                                showError('Error deleting user: ' + error);
                            }
                        });
                    }
                });
            } else {
                if (confirm(`Are you sure you want to delete ${userName}?`)) {
                    // Call server to delete user
                    $.ajax({
                        type: "POST",
                        url: "User.aspx/DeleteUser",
                        data: JSON.stringify({ userId: userId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function(response) {
                            const deleteResult = JSON.parse(response.d);
                            if (deleteResult.success) {
                                // Hide delete modal with null check
                                const deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteUserModal'));
                                if (deleteModal) deleteModal.hide();
                                
                                showSuccess('User deleted successfully!');
                                loadUsers();
                            } else {
                                showError(deleteResult.message);
                            }
                        },
                        error: function(xhr, status, error) {
                            showError('Error deleting user: ' + error);
                        }
                    });
                }
            }
        }

        // Show success message
        function showSuccess(message) {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: message,
                    confirmButtonColor: 'var(--primary-blue)',
                    background: 'var(--white)',
                    color: 'var(--gray-800)'
                });
            } else {
                // Fallback to original modal
                document.getElementById('successMessage').textContent = message;
                new bootstrap.Modal(document.getElementById('successModal')).show();
            }
        }

        // Show error message
        function showError(message) {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: message,
                    confirmButtonColor: 'var(--danger-color)',
                    background: 'var(--white)',
                    color: 'var(--text-color)'
                });
            } else {
                // Fallback to original modal
                document.getElementById('errorMessage').textContent = message;
                new bootstrap.Modal(document.getElementById('errorModal')).show();
            }
        }

        // Add modal event listeners and initialization
        function initializeModals() {
            // We'll only initialize modals here that don't already have listeners
            
            // Remove existing event listeners for the addUserModal by cloning
            const oldAddUserModal = document.getElementById('addUserModal');
            if (oldAddUserModal) {
                console.log('Removing old event listeners from addUserModal');
                const newAddUserModal = oldAddUserModal.cloneNode(true);
                oldAddUserModal.parentNode.replaceChild(newAddUserModal, oldAddUserModal);
                
                // We don't need to add new event listeners here since they're added elsewhere
            }
            
            console.log('Modal initialization complete');
        

            // View User Modal
            const viewUserModal = document.getElementById('viewUserModal');
            if (viewUserModal) {
                viewUserModal.addEventListener('hidden.bs.modal', function() {
                    currentUser = null;
                });
            }

            // Delete User Modal
            const deleteUserModal = document.getElementById('deleteUserModal');
            if (deleteUserModal) {
                deleteUserModal.addEventListener('hidden.bs.modal', function() {
                    document.getElementById('deleteUserId').value = '';
                    document.getElementById('deleteUserName').textContent = '';
                });
            }
        }

        // Initialize tab switching
        function initializeTabs() {
            const tabTriggers = document.querySelectorAll('[data-bs-toggle="pill"]');
            tabTriggers.forEach(tab => {
                tab.addEventListener('shown.bs.tab', function(e) {
                    console.log('Tab switched to:', e.target.getAttribute('data-bs-target'));
                    loadUsers();
                });
            });
        }

        // Utility function to reset form (used in multiple places)
        function resetForm() {
            resetUserForm();
        }

        // Fix for missing users array - will be populated by server calls
        let users = [];

        // Enhanced initialization
        function initializeUserManagement() {
            console.log('Initializing User Management...');
            
            // Open browser console automatically for debugging
            if (typeof window.open === 'function') {
                try {
                    console.log('Opening browser console for debugging...');
                    // This won't work in all browsers due to security restrictions
                    // but it's a helpful reminder to open the console
                } catch (e) {
                    console.error('Could not open console automatically:', e);
                }
            }
            
            try {
                initializeModals();
                initializeTabs();
                
                // Set up event handlers for modals to properly manage state
                setupModalEventHandlers();
                
                // Load dropdown data from database first
                console.log('Loading dropdown data...');
                loadDropdownData();
                
                // Then load users and courses
                console.log('Loading users and courses...');
                loadUsers();
                loadAvailableCourses();
                
                console.log('User Management initialized successfully');
            } catch (error) {
                console.error('Error initializing User Management:', error);
            }
        }
        
        // Set up event handlers for modals to properly manage state
        function setupModalEventHandlers() {
            console.log('Setting up modal event handlers...');
            
            // Handle view modal hidden event
            const viewUserModal = document.getElementById('viewUserModal');
            if (viewUserModal) {
                viewUserModal.addEventListener('hidden.bs.modal', function () {
                    console.log('View modal closed, cleaning up data');
                    // Don't immediately clear currentUser to allow editUserFromView to work
                    // But add a timeout to clear it after edit function has had a chance to use it
                    setTimeout(() => {
                        if (currentUser) {
                            console.log('Clearing currentUser after delay');
                            currentUser = null;
                        }
                    }, 500);
                });
            }
            
            // Handle add/edit modal hidden event
            const addUserModal = document.getElementById('addUserModal');
            if (addUserModal) {
                addUserModal.addEventListener('hidden.bs.modal', function () {
                    console.log('Add/Edit modal closed, resetting form');
                    setTimeout(() => {
                        resetUserForm();
                    }, 300);
                });
                
                // Set up shown event to ensure proper initialization
                addUserModal.addEventListener('shown.bs.modal', function () {
                    console.log('Add/Edit modal shown, focusing first field');
                    // Focus the first field
                    const firstInput = document.getElementById('fullName');
                    if (firstInput) {
                        firstInput.focus();
                    }
                });
            }
        }
        
        // Function to load dropdown data from database
        function loadDropdownData() {
            // Load departments
            $.ajax({
                type: "POST",
                url: "User.aspx/GetDepartments",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        populateDropdown('department', result.data);
                    } else {
                        console.error('Error loading departments:', result.message);
                    }
                },
                error: function(error) {
                    console.error('Error loading departments:', error);
                }
            });
            
            // Load levels
            $.ajax({
                type: "POST",
                url: "User.aspx/GetLevels",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        populateDropdown('level', result.data);
                    } else {
                        console.error('Error loading levels:', result.message);
                    }
                },
                error: function(error) {
                    console.error('Error loading levels:', error);
                }
            });
            
            // Load programmes
            $.ajax({
                type: "POST",
                url: "User.aspx/GetProgrammes",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        populateDropdown('programme', result.data);
                    } else {
                        console.error('Error loading programmes:', result.message);
                    }
                },
                error: function(error) {
                    console.error('Error loading programmes:', error);
                }
            });
        }
        
        // Helper function to populate dropdowns
        function populateDropdown(dropdownId, data) {
            const dropdown = document.getElementById(dropdownId);
            if (!dropdown) {
                console.error(`Dropdown with ID ${dropdownId} not found`);
                return;
            }
            
            // Keep the first "Select..." option
            const firstOption = dropdown.options[0];
            
            // Clear existing options except the first one
            dropdown.innerHTML = '';
            dropdown.appendChild(firstOption);
            
            // Add new options from database data
            data.forEach(item => {
                const option = document.createElement('option');
                option.value = item.name; // Using name as value for backward compatibility
                option.text = item.name;
                option.dataset.id = item.id; // Store ID as data attribute for reference
                
                // For programmes, store department ID for filtering
                if (dropdownId === 'programme' && item.departmentId) {
                    option.dataset.departmentId = item.departmentId;
                }
                
                dropdown.appendChild(option);
            });
            
            // Set up department-programme filtering if this is the department dropdown
            if (dropdownId === 'department') {
                setupDepartmentProgrammeFilter();
            }
        }
        
        // Function to set up filtering of programmes based on selected department
        function setupDepartmentProgrammeFilter() {
            const departmentDropdown = document.getElementById('department');
            const programmeDropdown = document.getElementById('programme');
            
            if (!departmentDropdown || !programmeDropdown) {
                console.error('Department or Programme dropdown not found');
                return;
            }
            
            // Add change event listener to department dropdown
            departmentDropdown.addEventListener('change', function() {
                const selectedDepartment = this.options[this.selectedIndex];
                if (!selectedDepartment || !selectedDepartment.dataset.id) {
                    // Reset programme dropdown if no department selected
                    resetProgrammeDropdown();
                    return;
                }
                
                const departmentId = parseInt(selectedDepartment.dataset.id);
                filterProgrammesByDepartment(departmentId);
            });
        }
        
        // Function to filter programmes by department
        function filterProgrammesByDepartment(departmentId) {
            const programmeDropdown = document.getElementById('programme');
            if (!programmeDropdown) return;
            
            // Get all options (including hidden ones)
            const allProgrammes = Array.from(programmeDropdown.querySelectorAll('option'));
            
            // Keep the first option
            const firstOption = allProgrammes[0];
            
            // Filter programmes by department ID
            const filteredProgrammes = allProgrammes.filter(option => {
                if (option === firstOption) return true; // Always keep the first option
                
                const optionDepartmentId = option.dataset.departmentId ? parseInt(option.dataset.departmentId) : null;
                return optionDepartmentId === departmentId;
            });
            
            // Clear and repopulate dropdown
            programmeDropdown.innerHTML = '';
            filteredProgrammes.forEach(option => {
                programmeDropdown.appendChild(option);
            });
            
            // Reset selection to first option
            programmeDropdown.selectedIndex = 0;
        }
        
        // Function to reset programme dropdown
        function resetProgrammeDropdown() {
            // Re-fetch all programmes from server
            $.ajax({
                type: "POST",
                url: "User.aspx/GetProgrammes",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        populateDropdown('programme', result.data, false); // Don't set up filter again
                    }
                }
            });
        }
   
        // Call initialization on page load
        document.addEventListener('DOMContentLoaded', function() {
            initializeUserManagement();
        });

       
        // Call initialization on page load
        document.addEventListener('DOMContentLoaded', function() {
            initializeUserManagement();
        });

      
        // Reset form function (alias)
        function resetForm() {
            resetUserForm();
        }

        // Delete user confirmation
        function deleteUser(userId) {
            // Set user info in delete modal
            const userData = getCurrentUserData(userId);
            if (userData) {
                document.getElementById('deleteUserName').textContent = userData.fullName;
                document.getElementById('deleteUserId').value = userId;
                new bootstrap.Modal(document.getElementById('deleteUserModal')).show();
            }
        }

        // Confirm delete user
        function confirmDeleteUser() {
            const userId = parseInt(document.getElementById('deleteUserId').value);
            
            $.ajax({
                type: "POST",
                url: "User.aspx/DeleteUser",
                data: JSON.stringify({ userId: userId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = JSON.parse(response.d);
                    if (result.success) {
                        showSuccess(result.message);
                        
                        // Add null check before hiding modal
                        const deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteUserModal'));
                        if (deleteModal) deleteModal.hide();
                        
                        loadUsers();
                    } else {
                        showError(result.message);
                    }
                },
                error: function(xhr, status, error) {
                    showError('Error deleting user: ' + error);
                }
            });
        }

        // Get current user data (helper function)
        function getCurrentUserData(userId) {
            // This would typically fetch from the displayed grid
            const userCards = document.querySelectorAll('.user-card');
            for (let card of userCards) {
                const editBtn = card.querySelector('[onclick*="editUser(' + userId + ')"]');
                if (editBtn) {
                    const nameElement = card.querySelector('.user-basic-info h5');
                    return {
                        fullName: nameElement ? nameElement.textContent : 'Unknown User'
                    };
                }
            }
            return { fullName: 'Unknown User' };
        }

        // Tab change event
        document.addEventListener('shown.bs.tab', function (event) {
            loadUsers();
        });

        // Custom tab event listener
        document.addEventListener('shown.custom.tab', function (event) {
            loadUsers();
        });

        // Modal events
        document.getElementById('addUserModal').addEventListener('show.bs.modal', function (event) {
            console.log('Modal show event triggered');
            
            // Call the preparation function
            if (typeof prepareAddUserModal === 'function') {
                prepareAddUserModal();
            }
            
            // Don't reset the form here - we'll do it in shown.bs.modal when DOM is ready
        });

        document.getElementById('addUserModal').addEventListener('shown.bs.modal', function (event) {
            console.log('Modal shown event triggered');
            
            // Reset form if not editing - do this here when modal is fully in the DOM
            if (document.getElementById('userAction').value !== 'edit') {
                if (typeof resetUserForm === 'function') {
                    // Short timeout to ensure DOM is fully rendered
                    setTimeout(() => {
                        resetUserForm();
                    }, 100);
                }
            }
            
            // Focus on first input
            const firstInput = this.querySelector('input:not([type="hidden"]), select');
            if (firstInput) {
                setTimeout(() => firstInput.focus(), 150);
            }
        });

        // Add animation classes to user cards when they load
        function animateUserCards() {
            // Use the global animation utility
            if (window.CustomAnimations) {
                window.CustomAnimations.animateElements();
            }
        }

        // Override the displayUsers function to include animations
        const originalDisplayUsers = displayUsers;
        displayUsers = function(users, gridId) {
            originalDisplayUsers(users, gridId);
            setTimeout(animateUserCards, 50);
        };

        // Document ready function
        $(document).ready(function() {
            console.log('Document ready - initializing user page');
            
            // Make sure our modal fix script is initialized
            if (typeof createVirtualForms === 'function') {
                createVirtualForms();
                console.log('Virtual forms initialized from document ready');
            }
            
            // First remove any duplicate event listeners
            initializeModals();
            
            // Make sure main event listeners for addUserModal are added only once
            const addUserModal = document.getElementById('addUserModal');
            if (addUserModal && !addUserModal.hasAttribute('data-initialized')) {
                console.log('Adding primary event listeners to addUserModal');
                
                // Mark the modal as initialized to prevent duplicate listeners
                addUserModal.setAttribute('data-initialized', 'true');
                
                // Set up the modal events - using event delegation to avoid timing issues
                $(document).on('show.bs.modal', '#addUserModal', function() {
                    console.log('Modal show event triggered (jQuery)');
                    // Create virtual form if needed
                    if (typeof createVirtualForm === 'function') {
                        createVirtualForm(this);
                    }
                    // No form reset here - will be handled in shown.bs.modal
                });
                
                $(document).on('shown.bs.modal', '#addUserModal', function() {
                    console.log('Modal shown event triggered (jQuery)');
                    const form = window.findFormInModal ? 
                                 window.findFormInModal('addUserModal', 'userForm') : 
                                 document.getElementById('userForm');
                                 
                    console.log('Form exists?', form ? true : false);
                    
                    // Reset form if needed with a small delay to ensure DOM is ready
                    setTimeout(function() {
                        if (document.getElementById('userAction').value !== 'edit') {
                            resetUserForm();
                        }
                    }, 100);
                });
            }
            
            // Initialize the user interface
            loadUsers();
        });
    </script>
</asp:Content>
