<%@ Page Title="Admin Profile" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-header {
            background: linear-gradient(135deg, #2c2b7c 0%, #3498db 100%);
            color: white;
            padding: 2rem 0;
            margin: -20px -20px 2rem -20px;
            border-radius: 0 0 15px 15px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            object-fit: cover;
            margin-bottom: 1rem;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .card-header-custom {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px 10px 0 0;
            padding: 1.5rem;
            margin: -2rem -2rem 2rem -2rem;
            border-bottom: 2px solid #dee2e6;
        }

        .card-title {
            color: #2c2b7c;
            font-weight: 600;
            margin-bottom: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #2c2b7c;
            box-shadow: 0 0 0 0.2rem rgba(44, 43, 124, 0.25);
        }

        .form-control.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }

        .form-control.is-valid {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .invalid-feedback {
            display: block;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875rem;
            color: #dc3545;
        }

        .valid-feedback {
            display: block;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875rem;
            color: #28a745;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #2c2b7c 0%, #3498db 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #1e1a5c 0%, #2980b9 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(44, 43, 124, 0.4);
            color: white;
        }

        .btn-success-custom {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-success-custom:hover {
            background: linear-gradient(135deg, #1e7e34 0%, #17a2b8 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
        }

        .btn-warning-custom {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            border: none;
            color: #212529;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-warning-custom:hover {
            background: linear-gradient(135deg, #e0a800 0%, #dc6200 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
            color: #212529;
        }

        .profile-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border-radius: 10px;
            padding: 1.5rem;
            text-align: center;
            border: 1px solid #dee2e6;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #2c2b7c;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #6c757d;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .avatar-upload {
            position: relative;
            display: inline-block;
        }

        .avatar-upload input[type="file"] {
            display: none;
        }

        .avatar-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #2c2b7c;
            color: white;
            border: none;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }

        .avatar-upload-btn:hover {
            background: #1e1a5c;
            transform: scale(1.1);
        }

        .profile-tabs {
            border-bottom: 2px solid #dee2e6;
            margin-bottom: 2rem;
        }

        .profile-tab {
            background: none;
            border: none;
            padding: 1rem 2rem;
            color: #6c757d;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
        }

        .profile-tab.active {
            color: #2c2b7c;
            border-bottom-color: #2c2b7c;
        }

        .profile-tab:hover {
            color: #2c2b7c;
            background: rgba(44, 43, 124, 0.05);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .security-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-left: 4px solid #2c2b7c;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #dee2e6;
            transition: background 0.3s ease;
        }

        .activity-item:hover {
            background: #f8f9fa;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2c2b7c 0%, #3498db 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.25rem;
        }

        .activity-time {
            color: #6c757d;
            font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .profile-header {
                padding: 1.5rem 0;
                margin: -20px -10px 2rem -10px;
            }

            .profile-card {
                padding: 1.5rem;
                margin-left: -10px;
                margin-right: -10px;
                border-radius: 10px;
            }

            .profile-stats {
                grid-template-columns: 1fr 1fr;
            }

            .profile-tab {
                padding: 0.75rem 1rem;
                font-size: 0.9rem;
            }
        }

        /* Toggle Switch Styles */
        .switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
            margin-right: 15px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #2c2b7c;
        }

        input:focus + .slider {
            box-shadow: 0 0 1px #2c2b7c;
        }

        input:checked + .slider:before {
            transform: translateX(26px);
        }

        .switch-container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .switch-container:last-child {
            border-bottom: none;
        }

        .switch-label {
            font-weight: 500;
            color: #333;
            margin: 0;
        }

        .switch-description {
            font-size: 0.9rem;
            color: #666;
            margin: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Profile Header -->
    <div class="profile-header text-center">
        <div class="container">
            <div class="avatar-upload">
                <img src="" alt="Profile Picture" class="profile-avatar" id="profileAvatar">
					<input type="hidden" id="hiddenProfilePicset" value="<%= Session["ProfilePicture"] ?? "" %>" />                
                <label for="avatarInput" class="avatar-upload-btn">
                    <i class="fas fa-camera"></i>
                </label>
                <input type="file" id="avatarInput" accept="image/*" onchange="previewAvatar(this)">
            </div>
            <h2 class="profile-name">John Smith</h2>
            <p class="profile-email mb-0">admin@university.edu</p>
            <small class="last-login">Last login: Never</small>

					<input type="hidden" id="hiddenAdminName" value="<%= Session["FullName"] ?? "" %>" />                
					<input type="hidden" id="hiddenAdminEmail" value="<%= Session["Email"] ?? "" %>" />                
					<input type="hidden" id="hiddenAdminLastLogin" value="<%= Session["LastLogin"] ?? "" %>" />                
					<input type="hidden" id="hiddenAdminPhone" value="<%= Session["Phone"] ?? "" %>" />                
                    <input type="hidden" id="hiddenAdminDepartment" value="IT" />
                    <input type="hidden" id="hiddenAdminAddress" value="IT Department" />
                    <input type="hidden" id="hiddenAdminPosition" value="System Administrator" />
        </div>
    </div>

    <!-- Profile Statistics -->
    <div class="profile-stats">
        <div class="stat-card">
            <div class="stat-value">156</div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">24</div>
            <div class="stat-label">Active Sessions</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">98.5%</div>
            <div class="stat-label">System Uptime</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">142</div>
            <div class="stat-label">Actions Today</div>
        </div>
    </div>

    <!-- Profile Tabs -->
    <div class="profile-tabs">
        <button class="profile-tab active" onclick="switchTab(event, 'personal')">
            <i class="fas fa-user me-2"></i>Personal Information
        </button>
        <button class="profile-tab" onclick="switchTab(event, 'security')">
            <i class="fas fa-shield-alt me-2"></i>Security
        </button>
        <button class="profile-tab" onclick="switchTab(event, 'preferences')">
            <i class="fas fa-cog me-2"></i>Preferences
        </button>
        <button class="profile-tab" onclick="switchTab(event, 'activity')">
            <i class="fas fa-history me-2"></i>Recent Activity
        </button>
    </div>

    <!-- Personal Information Tab -->
    <div id="personal" class="tab-content active">
        <div class="row">
            <div class="col-lg-8">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <h5 class="card-title">
                            <i class="fas fa-user"></i>
                            Personal Information
                        </h5>
                    </div>
                    
                    <form id="personalInfoForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">First Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="firstName" value="John" required>
                                    <div class="invalid-feedback" id="firstNameError"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Last Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="lastName" value="Smith" required>
                                    <div class="invalid-feedback" id="lastNameError"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Email Address <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" value="john.smith@university.edu" required>
                                    <div class="invalid-feedback" id="emailError"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone" value="+1 (555) 123-4567">
                                    <div class="invalid-feedback" id="phoneError"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Department</label>
                                    <select class="form-control" id="department">
                                        <option value="">Select Department</option>
                                        <option value="IT" selected>Information Technology</option>
                                        <option value="HR">Human Resources</option>
                                        <option value="Finance">Finance</option>
                                        <option value="Academic">Academic Affairs</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Job Title</label>
                                    <input type="text" class="form-control" id="jobTitle" value="System Administrator">
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Bio</label>
                            <textarea class="form-control" id="bio" rows="4" placeholder="Tell us about yourself...">Experienced system administrator with 8+ years in educational technology. Passionate about creating efficient learning environments through innovative technology solutions.</textarea>
                        </div>
                        
                        <div class="text-end">
                            <button type="button" class="btn-success-custom" onclick="savePersonalInfo(event)">
                                <i class="fas fa-save"></i>Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <h5 class="card-title">
                            <i class="fas fa-info-circle"></i>
                            Account Status
                        </h5>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Account Type:</strong><br>
                        <span class="badge bg-primary">Administrator</span>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Status:</strong><br>
                        <span class="badge bg-success">Active</span>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Last Login:</strong><br>
                        <small class="text-muted">Today at 9:15 AM</small>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Profile Completion:</strong><br>
                        <div class="progress mt-2">
                            <div class="progress-bar bg-success" style="width: 85%">85%</div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Permissions:</strong><br>
                        <small class="text-muted">Full System Access</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Security Tab -->
    <div id="security" class="tab-content">
        <div class="row">
            <div class="col-lg-8">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <h5 class="card-title">
                            <i class="fas fa-shield-alt"></i>
                            Security Settings
                        </h5>
                    </div>
                    
                    <!-- Change Password -->
                    <div class="security-item">
                        <h6><i class="fas fa-key me-2"></i>Change Password</h6>
                        <p class="text-muted mb-3">Update your password to keep your account secure.</p>
                        
                        <form id="passwordForm">
                            <div class="form-group">
                                <label class="form-label">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" required>
                                <div class="invalid-feedback" id="currentPasswordError"></div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">New Password</label>
                                        <input type="password" class="form-control" id="newPassword" required>
                                        <div class="invalid-feedback" id="newPasswordError"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">Confirm New Password</label>
                                        <input type="password" class="form-control" id="confirmPassword" required>
                                        <div class="invalid-feedback" id="confirmPasswordError"></div>
                                    </div>
                                </div>
                            </div>
                            
                            <button type="button" class="btn-warning-custom" onclick="changePassword(event)">
                                <i class="fas fa-key"></i>Update Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <h5 class="card-title">
                            <i class="fas fa-shield-check"></i>
                            Security Score
                        </h5>
                    </div>
                    
                    <div class="text-center mb-3">
                        <div class="h2 text-success">85%</div>
                        <p class="text-muted">Strong Security</p>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Password Strength</span>
                            <span class="text-success"><i class="fas fa-check"></i></span>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Recent Activity</span>
                            <span class="text-success"><i class="fas fa-check"></i></span>
                        </div>
                    </div>
                    
                    <button type="button" class="btn-primary-custom w-100" onclick="improveSecurity(event)">
                        <i class="fas fa-arrow-up"></i>Improve Security
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Preferences Tab -->
    <div id="preferences" class="tab-content">
        <div class="row">
            <div class="col-lg-8">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <h5 class="card-title">
                            <i class="fas fa-cog"></i>
                            System Preferences
                        </h5>
                    </div>
                    
                    <form id="preferencesForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Language</label>
                                    <select class="form-control" id="language">
                                        <option value="en" selected>English</option>
                                        <option value="es">Spanish</option>
                                        <option value="fr">French</option>
                                        <option value="de">German</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Timezone</label>
                                    <select class="form-control" id="timezone">
                                        <option value="EST" selected>Eastern Standard Time</option>
                                        <option value="CST">Central Standard Time</option>
                                        <option value="MST">Mountain Standard Time</option>
                                        <option value="PST">Pacific Standard Time</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Date Format</label>
                                    <select class="form-control" id="dateFormat">
                                        <option value="MM/DD/YYYY" selected>MM/DD/YYYY</option>
                                        <option value="DD/MM/YYYY">DD/MM/YYYY</option>
                                        <option value="YYYY-MM-DD">YYYY-MM-DD</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <h6 class="mt-4 mb-3">Notification Preferences</h6>
                        
                        <div class="switch-container">
                            <div>
                                <div class="switch-label">Email Notifications</div>
                                <div class="switch-description">Receive notifications via email</div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" id="emailNotifications" checked>
                                <span class="slider"></span>
                            </label>
                        </div>
                        
                        <div class="switch-container">
                            <div>
                                <div class="switch-label">Security Notifications</div>
                                <div class="switch-description">Get alerts about security events</div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" id="securityNotifications" checked>
                                <span class="slider"></span>
                            </label>
                        </div>
                        
                        <div class="switch-container">
                            <div>
                                <div class="switch-label">Maintenance Notifications</div>
                                <div class="switch-description">System maintenance and updates</div>
                            </div>
                            <label class="switch">
                                <input type="checkbox" id="maintenanceNotifications">
                                <span class="slider"></span>
                            </label>
                        </div>
                        
                        <div class="text-end">
                            <button type="button" class="btn-success-custom" onclick="savePreferences(event)">
                                <i class="fas fa-save"></i>Save Preferences
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="profile-card">
                    <div class="card-header-custom">
                        <h5 class="card-title">
                            <i class="fas fa-file-pdf"></i>
                            Export Data (PDF)
                        </h5>
                    </div>
                    
                    <p class="text-muted">Download your account data and activity history as PDF documents.</p>
                    
                    <div class="d-grid gap-2">
                        <button type="button" class="btn-primary-custom" onclick="exportProfile(event)">
                            <i class="fas fa-file-pdf"></i>Export Profile PDF
                        </button>
                        <button type="button" class="btn-primary-custom" onclick="exportActivity(event)">
                            <i class="fas fa-file-pdf"></i>Export Activity PDF
                        </button>
                        <button type="button" class="btn-primary-custom" onclick="exportAll(event)">
                            <i class="fas fa-file-pdf"></i>Export Complete PDF
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activity Tab -->
    <div id="activity" class="tab-content">
        <div class="profile-card">
            <div class="card-header-custom">
                <h5 class="card-title">
                    <i class="fas fa-history"></i>
                    Recent Activity
                </h5>
            </div>
            
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-sign-in-alt"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">Logged into system</div>
                    <div class="activity-time">Today at 9:15 AM</div>
                </div>
            </div>
            
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">Created new user account for Sarah Johnson</div>
                    <div class="activity-time">Yesterday at 3:42 PM</div>
                </div>
            </div>
            
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-cog"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">Updated system settings</div>
                    <div class="activity-time">Yesterday at 2:18 PM</div>
                </div>
            </div>
            
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-database"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">Performed system backup</div>
                    <div class="activity-time">2 days ago at 2:00 AM</div>
                </div>
            </div>
            
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">Security scan completed</div>
                    <div class="activity-time">3 days ago at 11:30 PM</div>
                </div>
            </div>
            
            <div class="activity-item">
                <div class="activity-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">Bulk imported 15 student accounts</div>
                    <div class="activity-time">1 week ago at 4:25 PM</div>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <button type="button" class="btn-primary-custom" onclick="loadMoreActivity(event)">
                    <i class="fas fa-plus"></i>Load More Activity
                </button>
            </div>
        </div>
    </div>

    <!-- Profile JavaScript -->
    <script>
        // Tab switching functionality
        function switchTab(event, tabName) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Hide all tab contents
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });

            // Remove active class from all tabs
            document.querySelectorAll('.profile-tab').forEach(tab => {
                tab.classList.remove('active');
            });

            // Show selected tab content
            document.getElementById(tabName).classList.add('active');

            // Add active class to clicked tab
            event.target.classList.add('active');

            return false;
        }

        // Avatar preview functionality
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    document.getElementById('profileAvatar').src = e.target.result;
                    showSuccessAlert('Avatar Updated', 'Profile picture has been updated successfully.');
                };
                
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Personal Information Functions
        function savePersonalInfo(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Clear previous validation
            clearFormValidation('personalInfoForm');

            // Get form values
            const firstName = document.getElementById('firstName').value.trim();
            const lastName = document.getElementById('lastName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const bio = document.getElementById('bio').value.trim();

            let isValid = true;

            // Validate first name
            if (!firstName) {
                showFieldError('firstName', 'First name is required.');
                isValid = false;
            }

            // Validate last name
            if (!lastName) {
                showFieldError('lastName', 'Last name is required.');
                isValid = false;
            }

            // Validate email
            if (!email) {
                showFieldError('email', 'Email address is required.');
                isValid = false;
            } else if (!isValidEmail(email)) {
                showFieldError('email', 'Please enter a valid email address.');
                isValid = false;
            }

            // Validate phone (optional but format check if provided)
            if (phone && !isValidPhone(phone)) {
                showFieldError('phone', 'Please enter a valid phone number.');
                isValid = false;
            }

            if (isValid) {
                showLoadingAlert('Saving personal information...');
                
                // Call WebMethod to update profile
                fetch('Profile.aspx/UpdateProfile', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        phone: phone,
                        address: bio
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.d === 'success') {
                        // Update profile name in header
                        document.querySelector('.profile-name').textContent = `${firstName} ${lastName}`;
                        document.querySelector('.profile-email').textContent = email;
                        
                        showSuccessAlert('Profile Updated!', 'Your personal information has been saved successfully.');
                    } else {
                        showErrorAlert('Error', data.d);
                    }
                })
                .catch(error => {
                    showErrorAlert('Error', 'An error occurred while updating your profile.');
                });
            }

            return false;
        }

        // Security Functions
        function changePassword(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Clear previous validation
            clearFormValidation('passwordForm');

            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            let isValid = true;

            // Validate current password
            if (!currentPassword) {
                showFieldError('currentPassword', 'Current password is required.');
                isValid = false;
            }

            // Validate new password
            if (!newPassword) {
                showFieldError('newPassword', 'New password is required.');
                isValid = false;
            } else if (newPassword.length < 8) {
                showFieldError('newPassword', 'Password must be at least 8 characters long.');
                isValid = false;
            }

            // Validate confirm password
            if (!confirmPassword) {
                showFieldError('confirmPassword', 'Please confirm your new password.');
                isValid = false;
            } else if (newPassword !== confirmPassword) {
                showFieldError('confirmPassword', 'Passwords do not match.');
                isValid = false;
            }

            if (isValid) {
                showLoadingAlert('Updating password...');
                
                // Call WebMethod to change password
                fetch('Profile.aspx/ChangePassword', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({
                        currentPassword: currentPassword,
                        newPassword: newPassword
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.d === 'success') {
                        // Clear form
                        document.getElementById('passwordForm').reset();
                        showSuccessAlert('Password Updated!', 'Your password has been changed successfully.');
                    } else {
                        showErrorAlert('Error', data.d);
                    }
                })
                .catch(error => {
                    showErrorAlert('Error', 'An error occurred while updating the password.');
                });
            }

            return false;
        }

        function improveSecurity(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Improve Security',
                html: `
                    <div class="text-start">
                        <p>To improve your security score, consider:</p>
                        <ul>
                            <li>Review recent login activity</li>
                            <li>Update your password regularly</li>
                            <li>Enable security notifications</li>
                            <li>Monitor account access patterns</li>
                        </ul>
                    </div>
                `,
                icon: 'info',
                confirmButtonColor: '#2c2b7c',
                confirmButtonText: 'Got it!'
            });

            return false;
        }

        // Preferences Functions
        function savePreferences(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Saving preferences...');
            
            setTimeout(() => {
                showSuccessAlert('Preferences Saved!', 'Your system preferences have been updated successfully.');
            }, 1500);

            return false;
        }

        function exportProfile(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Generating Profile PDF...');
            
            setTimeout(() => {
                generateProfilePDF();
                showSuccessAlert('PDF Generated!', 'Your profile data has been exported as a PDF document.');
            }, 2000);

            return false;
        }

        function exportActivity(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Generating Activity Log PDF...');
            
            setTimeout(() => {
                generateActivityPDF();
                showSuccessAlert('PDF Generated!', 'Your activity log has been exported as a PDF document.');
            }, 2000);

            return false;
        }

        function exportAll(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Generating Complete Data PDF...');
            
            setTimeout(() => {
                generateCompletePDF();
                showSuccessAlert('PDF Generated!', 'All your data has been exported as a comprehensive PDF document.');
            }, 3000);

            return false;
        }

        // PDF Generation Functions
        function generateProfilePDF() {
            // Create a simple text-based PDF content
            const profileContent = `
ADMIN PROFILE EXPORT
====================

Personal Information:
- Name: John Administrator
- Email: admin@university.edu
- Phone: +1 (555) 123-4567
- Department: Information Technology
- Position: System Administrator

Account Details:
- User ID: ADMIN001
- Registration Date: January 15, 2024
- Last Login: ${new Date().toLocaleString()}
- Account Status: Active

Preferences:
- Language: English
- Timezone: Eastern Standard Time
- Date Format: MM/DD/YYYY
- Email Notifications: Enabled
- Security Notifications: Enabled
- Maintenance Notifications: Disabled

Security Information:
- Password Last Changed: ${new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toLocaleDateString()}
- Security Score: 85% (Strong Security)
- Password Strength: Strong
- Recent Activity: Normal

Generated on: ${new Date().toLocaleString()}
            `;
            
            downloadTextAsPDF(profileContent, 'Admin_Profile_Export.pdf');
        }

        function generateActivityPDF() {
            const activityContent = `
ACTIVITY LOG EXPORT
===================

Recent Activity Summary:
- Total Sessions: 156
- Average Session Duration: 2.5 hours
- Last 30 Days: 42 sessions

Recent Login History:
1. ${new Date(Date.now() - 1 * 60 * 60 * 1000).toLocaleString()} - Login from 192.168.1.100
2. ${new Date(Date.now() - 25 * 60 * 60 * 1000).toLocaleString()} - Login from 192.168.1.100
3. ${new Date(Date.now() - 49 * 60 * 60 * 1000).toLocaleString()} - Login from 10.0.0.15
4. ${new Date(Date.now() - 72 * 60 * 60 * 1000).toLocaleString()} - Login from 192.168.1.100
5. ${new Date(Date.now() - 96 * 60 * 60 * 1000).toLocaleString()} - Login from 192.168.1.100

System Actions:
- Profile updates: 12
- Password changes: 2
- Settings modifications: 8
- Data exports: 5

Security Events:
- Failed login attempts: 0
- Suspicious activities: 0
- Security alerts: 3 (all resolved)

Generated on: ${new Date().toLocaleString()}
            `;
            
            downloadTextAsPDF(activityContent, 'Admin_Activity_Export.pdf');
        }

        function generateCompletePDF() {
            const completeContent = `
COMPLETE ADMIN DATA EXPORT
==========================

PERSONAL INFORMATION
====================
- Name: John Administrator
- Email: admin@university.edu
- Phone: +1 (555) 123-4567
- Department: Information Technology
- Position: System Administrator

ACCOUNT DETAILS
===============
- User ID: ADMIN001
- Registration Date: January 15, 2024
- Last Login: ${new Date().toLocaleString()}
- Account Status: Active
- Security Score: 85% (Strong Security)

SYSTEM PREFERENCES
==================
- Language: English
- Timezone: Eastern Standard Time
- Date Format: MM/DD/YYYY

NOTIFICATION SETTINGS
====================
- Email Notifications: Enabled
- Security Notifications: Enabled
- Maintenance Notifications: Disabled

ACTIVITY SUMMARY
================
- Total Sessions: 156
- Average Session Duration: 2.5 hours
- Last 30 Days: 42 sessions
- Profile updates: 12
- Password changes: 2

RECENT ACTIVITY
===============
1. ${new Date(Date.now() - 1 * 60 * 60 * 1000).toLocaleString()} - Login from 192.168.1.100
2. ${new Date(Date.now() - 25 * 60 * 60 * 1000).toLocaleString()} - Login from 192.168.1.100
3. ${new Date(Date.now() - 49 * 60 * 60 * 1000).toLocaleString()} - Login from 10.0.0.15

SECURITY INFORMATION
====================
- Password Last Changed: ${new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toLocaleDateString()}
- Failed login attempts: 0
- Security alerts: 3 (all resolved)

Generated on: ${new Date().toLocaleString()}
Document ID: EXPORT_${Date.now()}
            `;
            
            downloadTextAsPDF(completeContent, 'Admin_Complete_Export.pdf');
        }

        // Helper function to create and download PDF
        function downloadTextAsPDF(content, filename) {
            // Create a simple PDF using HTML5 and browser capabilities
            const element = document.createElement('div');
            element.style.cssText = `
                font-family: 'Courier New', monospace;
                font-size: 12px;
                line-height: 1.4;
                white-space: pre-wrap;
                padding: 40px;
                background: white;
                color: black;
                width: 8.5in;
                min-height: 11in;
                margin: 0 auto;
                border: 1px solid #ccc;
            `;
            element.textContent = content;
            
            // Temporarily add to document for printing
            document.body.appendChild(element);
            
            // Create a new window for printing
            const printWindow = window.open('', '_blank');
            printWindow.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>${filename}</title>
                    <style>
                        @media print {
                            body { margin: 0; }
                            @page { size: A4; margin: 1in; }
                        }
                        body {
                            font-family: 'Courier New', monospace;
                            font-size: 12px;
                            line-height: 1.4;
                            white-space: pre-wrap;
                            color: black;
                        }
                    </style>
                </head>
                <body>${content}</body>
                </html>
            `);
            
            printWindow.document.close();
            
            // Trigger print dialog (user can save as PDF)
            setTimeout(() => {
                printWindow.print();
                printWindow.close();
                document.body.removeChild(element);
            }, 500);
        }

        // Activity Functions
        function loadMoreActivity(event) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Loading more activity...');
            
            setTimeout(() => {
                showSuccessAlert('Activity Loaded!', 'Additional activity records have been loaded.');
            }, 1500);

            return false;
        }

        // Validation Helper Functions
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function isValidPhone(phone) {
            const phoneRegex = /^[\+]?[\d\s\-\(\)]{10,}$/;
            return phoneRegex.test(phone);
        }

        function showFieldError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + 'Error');
            
            if (field) {
                field.classList.add('is-invalid');
                field.classList.remove('is-valid');
            }
            
            if (errorElement) {
                errorElement.textContent = message;
            }
        }

        function clearFormValidation(formId) {
            const form = document.getElementById(formId);
            if (form) {
                form.querySelectorAll('.is-invalid').forEach(el => {
                    el.classList.remove('is-invalid');
                });
                form.querySelectorAll('.is-valid').forEach(el => {
                    el.classList.remove('is-valid');
                });
                form.querySelectorAll('.invalid-feedback').forEach(el => {
                    el.textContent = '';
                });
            }
        }

        // Alert Helper Functions
        function showSuccessAlert(title, message) {
            Swal.fire({
                icon: 'success',
                title: title,
                text: message,
                confirmButtonColor: '#2c2b7c'
            });
        }

        function showErrorAlert(title, message) {
            Swal.fire({
                icon: 'error',
                title: title,
                text: message,
                confirmButtonColor: '#dc3545'
            });
        }

        function showLoadingAlert(message) {
            Swal.fire({
                title: 'Please wait...',
                text: message,
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        // Initialize profile page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Profile page initialized');

            // Hide Details if any
            var AdminProfile = document.getElementById('hiddenProfilePicset').value || "../../Assest/Images/ProfileUew.png";
            if (AdminProfile) {
                var profileImg = document.getElementById('profileAvatar');
                if (profileImg) {
                    profileImg.src = AdminProfile;
                }
            }
            
            const lastLoginRaw = document.getElementById('hiddenAdminLastLogin').value;
            const lastLoginDate = lastLoginRaw ? new Date(lastLoginRaw) : new Date();
            const AdminLastLogin = lastLoginDate.toLocaleDateString(undefined, { month: 'long', year: 'numeric' });
            const AdminName = document.getElementById('hiddenAdminName').value || "John Administrator";
            const AdminEmail = document.getElementById('hiddenAdminEmail').value || "admin";
            const AdminPhone = document.getElementById('hiddenAdminPhone').value || "+1 (555) 123-4567";
            const AdminAddress = document.getElementById('hiddenAdminAddress').value || "Information Technology Department";
            const AdminPosition = document.getElementById('hiddenAdminPosition').value || "System Administrator";
            const AdminDepartment = document.getElementById('hiddenAdminDepartment').value || "IT";
            document.querySelector('.profile-name').textContent = AdminName;
            document.querySelector('.profile-email').textContent = AdminEmail;
            document.querySelector('.last-login').textContent = "Last login: " + AdminLastLogin;


            //
            document.getElementById('firstName').value = AdminName.split(' ')[0] || '';
            document.getElementById('lastName').value = AdminName.split(' ').slice(1).join(' ') || '';
            document.getElementById('email').value = AdminEmail || '';
            document.getElementById('phone').value = AdminPhone || '';
            //document.getElementById('bio').value = AdminAddress || '';
            document.getElementById('jobTitle').value = AdminPosition || '';
            document.getElementById('department').value = AdminDepartment || '';
        



            // Add real-time validation listeners
            addValidationListeners();
        });

        function addValidationListeners() {
            // Personal info form validation
            const personalFields = ['firstName', 'lastName', 'email', 'phone'];
            personalFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    field.addEventListener('blur', function() {
                        validateField(fieldId);
                    });
                    field.addEventListener('input', function() {
                        clearFieldValidation(fieldId);
                    });
                }
            });

            // Password form validation
            const passwordFields = ['currentPassword', 'newPassword', 'confirmPassword'];
            passwordFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    field.addEventListener('input', function() {
                        clearFieldValidation(fieldId);
                    });
                }
            });
        }

        function validateField(fieldId) {
            const field = document.getElementById(fieldId);
            const value = field.value.trim();
            
            switch(fieldId) {
                case 'firstName':
                case 'lastName':
                    if (!value) {
                        showFieldError(fieldId, 'This field is required.');
                    } else {
                        showFieldSuccess(fieldId);
                    }
                    break;
                case 'email':
                    if (!value) {
                        showFieldError(fieldId, 'Email address is required.');
                    } else if (!isValidEmail(value)) {
                        showFieldError(fieldId, 'Please enter a valid email address.');
                    } else {
                        showFieldSuccess(fieldId);
                    }
                    break;
                case 'phone':
                    if (value && !isValidPhone(value)) {
                        showFieldError(fieldId, 'Please enter a valid phone number.');
                    } else if (value) {
                        showFieldSuccess(fieldId);
                    }
                    break;
            }
        }

        function showFieldSuccess(fieldId) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + 'Error');
            
            if (field) {
                field.classList.remove('is-invalid');
                field.classList.add('is-valid');
            }
            
            if (errorElement) {
                errorElement.textContent = '';
            }
        }

        function clearFieldValidation(fieldId) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + 'Error');
            
            if (field) {
                field.classList.remove('is-invalid');
                field.classList.remove('is-valid');
            }
            
            if (errorElement) {
                errorElement.textContent = '';
            }
        }
    </script>
</asp:Content>
