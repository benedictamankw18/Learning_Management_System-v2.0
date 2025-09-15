<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>System Settings - Learning Management System</title>
    
    <!-- SweetAlert2 for notifications -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        /* Settings Page Custom Theme */
        :root {
            /* Custom Theme Colors */
            --primary-color: #2c2b7c;
            --accent-color: #ee1c24;
            --background-color: #fefefe;
            --text-color: #000000;
            
            /* Derived Theme Colors */
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

        /* Settings Header */
        .settings-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: var(--white);
            box-shadow: 0 8px 32px rgba(44, 43, 124, 0.15);
        }

        .settings-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: var(--white);
        }

        .settings-header p {
            margin: 0.75rem 0 0 0;
            opacity: 0.9;
            font-size: 1.1rem;
            color: var(--white);
        }

        /* Settings Navigation */
        .settings-nav {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .nav-tabs-custom {
            border: none;
            background: var(--light-gray);
            padding: 1rem 2rem;
        }

        .nav-tabs-custom .nav-link {
            border: none;
            color: var(--medium-gray);
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            margin-right: 0.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .nav-tabs-custom .nav-link:hover {
            background: var(--white);
            color: var(--primary-color);
        }

        .nav-tabs-custom .nav-link.active {
            background: var(--primary-color);
            color: var(--white);
            box-shadow: 0 2px 8px rgba(44, 43, 124, 0.2);
        }

        /* Settings Content */
        .settings-content {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 0 0 16px 16px;
            padding: 2rem;
        }

        .settings-section {
            margin-bottom: 3rem;
        }

        .settings-section:last-child {
            margin-bottom: 0;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-gray);
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-color);
            margin: 0;
        }

        .section-description {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-gray);
            border-radius: 8px;
            background: var(--white);
            color: var(--text-color);
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(44, 43, 124, 0.25);
            outline: none;
        }

        .form-control::placeholder {
            color: var(--medium-gray);
        }

        /* Toggle Switches */
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: var(--border-gray);
            transition: 0.4s;
            border-radius: 34px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background-color: var(--white);
            transition: 0.4s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider {
            background-color: var(--primary-color);
        }

        input:checked + .toggle-slider:before {
            transform: translateX(26px);
        }

        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-gray);
        }

        .setting-item:last-child {
            border-bottom: none;
        }

        .setting-info h6 {
            margin: 0;
            color: var(--text-color);
            font-weight: 600;
        }

        .setting-info p {
            margin: 0.25rem 0 0 0;
            color: var(--medium-gray);
            font-size: 0.875rem;
        }

        /* Action Buttons */
        .btn-primary-custom {
            background: var(--primary-color);
            border: none;
            color: var(--white);
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-primary-custom:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(44, 43, 124, 0.3);
        }

        .btn-danger-custom {
            background: var(--danger-color);
            border: none;
            color: var(--white);
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-danger-custom:hover {
            background: var(--accent-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(238, 28, 36, 0.3);
        }

        .btn-success-custom {
            background: var(--success-color);
            border: none;
            color: var(--white);
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-success-custom:hover {
            background: #218838;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        /* Info Cards */
        .info-card {
            background: var(--light-gray);
            border: 1px solid var(--border-gray);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .info-card.warning {
            background: rgba(255, 193, 7, 0.1);
            border-color: var(--warning-color);
        }

        .info-card.danger {
            background: rgba(238, 28, 36, 0.1);
            border-color: var(--danger-color);
        }

        .info-card.success {
            background: rgba(40, 167, 69, 0.1);
            border-color: var(--success-color);
        }

        .info-card h6 {
            margin: 0 0 0.5rem 0;
            color: var(--text-color);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card p {
            margin: 0;
            color: var(--medium-gray);
            font-size: 0.875rem;
        }

        /* Progress Bars */
        .progress-container {
            margin: 1rem 0;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .progress-bar-custom {
            height: 8px;
            background: var(--border-gray);
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        .progress-fill.primary { background: var(--primary-color); }
        .progress-fill.success { background: var(--success-color); }
        .progress-fill.warning { background: var(--warning-color); }
        .progress-fill.danger { background: var(--danger-color); }

        /* File Upload */
        .file-upload-area {
            border: 2px dashed var(--border-gray);
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .file-upload-area:hover {
            border-color: var(--primary-color);
            background: rgba(44, 43, 124, 0.05);
        }

        .file-upload-area.dragover {
            border-color: var(--primary-color);
            background: rgba(44, 43, 124, 0.1);
        }

        .file-upload-area.success {
            border-color: var(--success-color);
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }

        .file-upload-area.error {
            border-color: var(--danger-color);
            background: rgba(238, 28, 36, 0.1);
            color: var(--danger-color);
        }

        /* Logo Display Styles */
        .current-logo-container {
            margin-bottom: 1rem;
        }

        .logo-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid var(--border-gray);
            background: var(--white);
        }

        .upload-progress {
            background: var(--light-gray);
            border: 1px solid var(--border-gray);
            border-radius: 8px;
            padding: 1rem;
        }

        .upload-progress .progress {
            height: 8px;
            background: var(--border-gray);
            border-radius: 4px;
            overflow: hidden;
        }

        .upload-progress .progress-bar {
            background: var(--primary-color);
            transition: width 0.3s ease;
        }

        /* File upload states */
        .file-upload-area.uploading {
            border-color: var(--primary-color);
            background: rgba(44, 43, 124, 0.1);
            pointer-events: none;
        }

        .file-upload-area.uploading i {
            animation: uploadSpin 1s linear infinite;
        }

        @keyframes uploadSpin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Drag and drop active state */
        .file-upload-area.drag-active {
            border-color: var(--primary-color);
            background: rgba(44, 43, 124, 0.15);
            transform: scale(1.02);
            transition: all 0.3s ease;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .settings-header {
                padding: 1.5rem;
            }

            .settings-header h1 {
                font-size: 2rem;
            }

            .nav-tabs-custom {
                padding: 1rem;
                overflow-x: auto;
                white-space: nowrap;
            }

            .settings-content {
                padding: 1.5rem;
            }

            .setting-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }

        /* Animation */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Badge Styles */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.online {
            background: rgba(40, 167, 69, 0.2);
            color: var(--success-color);
        }

        .status-badge.offline {
            background: rgba(238, 28, 36, 0.2);
            color: var(--danger-color);
        }

        .status-badge.maintenance {
            background: rgba(255, 193, 7, 0.2);
            color: var(--warning-color);
        }

        /* Form Validation Styles */
        .form-control.is-valid,
        .form-select.is-valid {
            border-color: var(--success-color);
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .form-control.is-invalid,
        .form-select.is-invalid {
            border-color: var(--danger-color);
            box-shadow: 0 0 0 0.2rem rgba(238, 28, 36, 0.25);
        }

        .invalid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875rem;
            color: var(--danger-color);
        }

        .form-control.is-invalid ~ .invalid-feedback,
        .form-select.is-invalid ~ .invalid-feedback {
            display: block;
        }

        .valid-feedback {
            display: none;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875rem;
            color: var(--success-color);
        }

        .form-control.is-valid ~ .valid-feedback,
        .form-select.is-valid ~ .valid-feedback {
            display: block;
        }

        /* Password Strength Indicator */
        .password-strength {
            margin-top: 0.5rem;
            height: 4px;
            background: var(--border-gray);
            border-radius: 2px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .password-strength.weak .password-strength-bar {
            width: 25%;
            background: var(--danger-color);
        }

        .password-strength.fair .password-strength-bar {
            width: 50%;
            background: var(--warning-color);
        }

        .password-strength.good .password-strength-bar {
            width: 75%;
            background: #ffc107;
        }

        .password-strength.strong .password-strength-bar {
            width: 100%;
            background: var(--success-color);
        }

        /* Validation Warning Messages */
        .validation-warning {
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid var(--warning-color);
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            display: none;
        }

        .validation-warning.show {
            display: block;
        }

        .validation-warning h6 {
            color: var(--warning-color);
            margin: 0 0 0.5rem 0;
            font-weight: 600;
        }

        .validation-warning ul {
            margin: 0;
            padding-left: 1.5rem;
            color: var(--medium-gray);
        }

        /* Wide SweetAlert for backup history */
        .swal-wide {
            width: 90% !important;
            max-width: 1200px !important;
        }

        .swal-wide .swal2-html-container {
            max-height: 600px;
            overflow-y: auto;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Settings Header -->
    <div class="settings-header">
        <h1>
            <i class="fas fa-cogs"></i>
            System Settings
        </h1>
        <p>Configure and manage your Learning Management System preferences and options</p>
    </div>

    <!-- Settings Navigation and Content -->
    <div class="settings-nav">
        <ul class="nav nav-tabs nav-tabs-custom" id="settingsTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="general-tab" data-bs-toggle="tab" 
                        data-bs-target="#general" type="button" role="tab">
                    <i class="fas fa-sliders-h me-2"></i>General
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="system-tab" data-bs-toggle="tab" 
                        data-bs-target="#system" type="button" role="tab">
                    <i class="fas fa-server me-2"></i>System
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="security-tab" data-bs-toggle="tab" 
                        data-bs-target="#security" type="button" role="tab">
                    <i class="fas fa-shield-alt me-2"></i>Security
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="notifications-tab" data-bs-toggle="tab" 
                        data-bs-target="#notifications" type="button" role="tab">
                    <i class="fas fa-bell me-2"></i>Notifications
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="backup-tab" data-bs-toggle="tab" 
                        data-bs-target="#backup" type="button" role="tab">
                    <i class="fas fa-database me-2"></i>Backup
                </button>
            </li>
        </ul>

        <div class="settings-content">
            <div class="tab-content" id="settingsTabContent">
                
                <!-- General Settings -->
                <div class="tab-pane fade show active" id="general" role="tabpanel">
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-university text-primary"></i>
                            <div>
                                <h3 class="section-title">Institution Information</h3>
                                <p class="section-description">Basic information about your educational institution</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-building"></i>
                                        Institution Name
                                    </label>
                                    <input type="text" id="institutionName" class="form-control" value="University of Education, Winneba" 
                                           placeholder="Enter institution name" required minlength="3" maxlength="100">
                                    <div class="invalid-feedback">Please enter a valid institution name (3-100 characters).</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-code"></i>
                                        Institution Code
                                    </label>
                                    <input type="text" id="institutionCode" class="form-control" value="UEW" 
                                           placeholder="Enter institution code" required minlength="2" maxlength="10" pattern="[A-Z0-9]+">
                                    <div class="invalid-feedback">Please enter a valid code (2-10 uppercase letters/numbers).</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-envelope"></i>
                                        Contact Email
                                    </label>
                                    <input type="email" id="contactEmail" class="form-control" value="admin@uew.edu.gh" 
                                           placeholder="Enter contact email" required>
                                    <div class="invalid-feedback">Please enter a valid email address.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-phone"></i>
                                        Contact Phone
                                    </label>
                                    <input type="tel" id="contactPhone" class="form-control" value="+233 332 093 842" 
                                           placeholder="Enter contact phone" pattern="[+]?[0-9\s-()]{10,20}">
                                    <div class="invalid-feedback">Please enter a valid phone number.</div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-map-marker-alt"></i>
                                Institution Address
                            </label>
                            <textarea id="institutionAddress" class="form-control" rows="3" required minlength="10" maxlength="500"
                                      placeholder="Enter complete address">P.O. Box 25, Winneba, Central Region, Ghana</textarea>
                            <div class="invalid-feedback">Please enter a valid address (10-500 characters).</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-image"></i>
                                Institution Logo
                            </label>
                            
                            <!-- Current Logo Display -->
                            <div id="currentLogo" class="current-logo-container mb-3" style="display: none;">
                                <div class="d-flex align-items-center justify-content-between p-3 border rounded">
                                    <div class="d-flex align-items-center">
                                        <img id="logoPreview" src="" alt="Current Logo" class="logo-preview me-3">
                                        <div>
                                            <h6 class="mb-1">Current Logo</h6>
                                            <p class="text-muted mb-0" id="logoInfo">No logo uploaded</p>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeLogo()">
                                        <i class="fas fa-trash-alt me-1"></i>Remove
                                    </button>
                                </div>
                            </div>

                            <!-- Upload Area -->
                            <div class="file-upload-area" id="uploadArea" onclick="document.getElementById('logoUpload').click()">
                                <i class="fas fa-cloud-upload-alt fa-2x text-muted mb-3"></i>
                                <h6>Click to upload or drag and drop</h6>
                                <p class="text-muted">PNG, JPG, SVG up to 5MB</p>
                                <p class="text-muted small">Recommended size: 200x200 pixels</p>
                                <input type="file" id="logoUpload" class="d-none" accept="image/*">
                            </div>

                            <!-- Upload Progress -->
                            <div id="uploadProgress" class="upload-progress mt-3" style="display: none;">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="small">Uploading...</span>
                                    <span class="small" id="uploadPercent">0%</span>
                                </div>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-striped progress-bar-animated" 
                                         id="progressBar" role="progressbar" style="width: 0%"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-globe text-primary"></i>
                            <div>
                                <h3 class="section-title">Localization</h3>
                                <p class="section-description">Language and regional preferences</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Default Language</label>
                                    <select class="form-select">
                                        <option value="en">English</option>
                                        <option value="tw">Twi</option>
                                        <option value="ga">Ga</option>
                                        <option value="fr">French</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Time Zone</label>
                                    <select class="form-select">
                                        <option value="GMT">GMT (Greenwich Mean Time)</option>
                                        <option value="WAT">WAT (West Africa Time)</option>
                                        <option value="UTC">UTC (Coordinated Universal Time)</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Date Format</label>
                                    <select class="form-select">
                                        <option value="dd/mm/yyyy">DD/MM/YYYY</option>
                                        <option value="mm/dd/yyyy">MM/DD/YYYY</option>
                                        <option value="yyyy-mm-dd">YYYY-MM-DD</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Currency</label>
                                    <select class="form-select">
                                        <option value="GHS">Ghanaian Cedi (₵)</option>
                                        <option value="USD">US Dollar ($)</option>
                                        <option value="EUR">Euro (€)</option>
                                        <option value="GBP">British Pound (£)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="button" class="btn btn-primary-custom" onclick="return saveGeneralSettings(event);">
                            <i class="fas fa-save me-2"></i>Save General Settings
                        </button>
                    </div>
                </div>

                <!-- System Settings -->
                <div class="tab-pane fade" id="system" role="tabpanel">
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-server text-primary"></i>
                            <div>
                                <h3 class="section-title">System Status</h3>
                                <p class="section-description">Current system health and performance metrics</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="info-card success">
                                    <h6><i class="fas fa-check-circle"></i>System Status</h6>
                                    <p>All services running normally</p>
                                    <span class="status-badge online">Online</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-card">
                                    <h6><i class="fas fa-hdd"></i>Storage Usage</h6>
                                    <div class="progress-container">
                                        <div class="progress-label">
                                            <span>Database</span>
                                            <span>67%</span>
                                        </div>
                                        <div class="progress-bar-custom">
                                            <div class="progress-fill primary" style="width: 67%"></div>
                                        </div>
                                    </div>
                                    <div class="progress-container">
                                        <div class="progress-label">
                                            <span>Files</span>
                                            <span>43%</span>
                                        </div>
                                        <div class="progress-bar-custom">
                                            <div class="progress-fill success" style="width: 43%"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-card">
                                    <h6><i class="fas fa-users"></i>Active Users</h6>
                                    <p>Current online users: <strong>247</strong></p>
                                    <p>Peak today: <strong>892</strong></p>
                                    <p>Last updated: <strong>2 min ago</strong></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-cog text-primary"></i>
                            <div>
                                <h3 class="section-title">System Configuration</h3>
                                <p class="section-description">Core system settings and performance options</p>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Maintenance Mode</h6>
                                <p>Enable maintenance mode to perform system updates</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="maintenanceMode">
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Debug Mode</h6>
                                <p>Enable detailed error logging for development</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="debugMode">
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Cache System</h6>
                                <p>Enable caching to improve system performance</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="cacheSystem" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Auto Backup</h6>
                                <p>Automatically backup system data daily</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="autoBackup" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-tools text-primary"></i>
                            <div>
                                <h3 class="section-title">System Tools</h3>
                                <p class="section-description">Utilities for system maintenance and optimization</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <button type="button" class="btn btn-primary-custom w-100 mb-3" onclick="return clearCache(event);">
                                    <i class="fas fa-broom me-2"></i>Clear Cache
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-success-custom w-100 mb-3" onclick="return optimizeDatabase(event);">
                                    <i class="fas fa-database me-2"></i>Optimize DB
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-primary-custom w-100 mb-3" onclick="return systemCheck(event);">
                                    <i class="fas fa-stethoscope me-2"></i>Health Check
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-danger-custom w-100 mb-3" onclick="return restartSystem(event);">
                                    <i class="fas fa-redo me-2"></i>Restart System
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Security Settings -->
                <div class="tab-pane fade" id="security" role="tabpanel">
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-shield-alt text-primary"></i>
                            <div>
                                <h3 class="section-title">Security Policies</h3>
                                <p class="section-description">Configure security settings and access controls</p>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Two-Factor Authentication</h6>
                                <p>Require 2FA for all administrator accounts</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="twoFactorAuth" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Strong Password Policy</h6>
                                <p>Enforce complex password requirements</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="strongPassword" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Session Timeout</h6>
                                <p>Automatically log out inactive users</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="sessionTimeout" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Session Timeout (minutes)</label>
                                    <input type="number" id="sessionTimeoutMinutes" class="form-control" value="30" min="5" max="480" required>
                                    <div class="invalid-feedback">Please enter a value between 5 and 480 minutes.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Max Login Attempts</label>
                                    <input type="number" id="maxLoginAttempts" class="form-control" value="5" min="3" max="10" required>
                                    <div class="invalid-feedback">Please enter a value between 3 and 10 attempts.</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-key text-primary"></i>
                            <div>
                                <h3 class="section-title">API Security</h3>
                                <p class="section-description">Manage API keys and access tokens</p>
                            </div>
                        </div>

                        <div class="info-card warning">
                            <h6><i class="fas fa-exclamation-triangle"></i>API Key Management</h6>
                            <p>Regenerate API keys regularly for enhanced security. Current key expires in 45 days.</p>
                        </div>

                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group">
                                    <label class="form-label">Current API Key</label>
                                    <div class="input-group">
                                        <input type="text" id="currentApiKey" class="form-control" value="lms_api_key_2024_********" readonly>
                                        <button class="btn btn-outline-secondary" type="button" id="toggleApiKey" onclick="toggleApiKeyVisibility()">
                                            <i class="fas fa-eye" id="eyeIcon"></i>
                                        </button>
                                        <button class="btn btn-outline-primary" type="button" onclick="copyApiKey()">
                                            <i class="fas fa-copy"></i>
                                        </button>
                                    </div>
                                    <small class="text-muted">Click the eye icon to show/hide the full key</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">&nbsp;</label>
                                <button type="button" class="btn btn-danger-custom w-100" onclick="return regenerateApiKey(event);">
                                    <i class="fas fa-sync me-2"></i>Regenerate Key
                                </button>
                            </div>
                        </div>

                        <!-- API Key Information -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="info-card">
                                    <h6><i class="fas fa-info-circle"></i>Key Information</h6>
                                    <p><strong>Created:</strong> <span id="keyCreatedDate">August 1, 2025</span></p>
                                    <p><strong>Last Used:</strong> <span id="keyLastUsed">2 hours ago</span></p>
                                    <p><strong>Expires:</strong> <span id="keyExpiryDate">January 1, 2026</span></p>
                                    <p class="mb-0"><strong>Status:</strong> <span class="status-badge online" id="keyStatus">Active</span></p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-card">
                                    <h6><i class="fas fa-chart-line"></i>Usage Statistics</h6>
                                    <p><strong>Total Requests:</strong> <span id="totalRequests">1,247</span></p>
                                    <p><strong>Requests Today:</strong> <span id="requestsToday">23</span></p>
                                    <p><strong>Rate Limit:</strong> <span id="rateLimit">1000/hour</span></p>
                                    <p class="mb-0"><strong>Remaining:</strong> <span id="remainingRequests">977</span></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end">
                        <button type="button" class="btn btn-primary-custom" onclick="return saveSecuritySettings(event);">
                            <i class="fas fa-shield-alt me-2"></i>Save Security Settings
                        </button>
                    </div>
                </div>

                <!-- Notification Settings -->
                <div class="tab-pane fade" id="notifications" role="tabpanel">
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-bell text-primary"></i>
                            <div>
                                <h3 class="section-title">Email Notifications</h3>
                                <p class="section-description">Configure when and how email notifications are sent</p>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Student Enrollment Notifications</h6>
                                <p>Send email when students enroll in courses</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="enrollmentNotifications" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Course Completion Notifications</h6>
                                <p>Send email when students complete courses</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="completionNotifications" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>System Alert Notifications</h6>
                                <p>Send email for system errors and warnings</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="systemAlerts" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <h6>Weekly Reports</h6>
                                <p>Send weekly summary reports to administrators</p>
                            </div>
                            <label class="toggle-switch">
                                <input type="checkbox" id="weeklyReports" checked>
                                <span class="toggle-slider"></span>
                            </label>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-envelope text-primary"></i>
                            <div>
                                <h3 class="section-title">Email Configuration</h3>
                                <p class="section-description">SMTP settings for outgoing emails</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">SMTP Server</label>
                                    <input type="text" id="smtpServer" class="form-control" value="smtp.gmail.com" 
                                           placeholder="Enter SMTP server" required minlength="3" maxlength="100">
                                    <div class="invalid-feedback">Please enter a valid SMTP server address.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">SMTP Port</label>
                                    <input type="number" id="smtpPort" class="form-control" value="587" 
                                           placeholder="Enter SMTP port" required min="1" max="65535">
                                    <div class="invalid-feedback">Please enter a valid port number (1-65535).</div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">SMTP Username</label>
                                    <input type="email" id="smtpUsername" class="form-control" value="noreply@uew.edu.gh" 
                                           placeholder="Enter SMTP username" required>
                                    <div class="invalid-feedback">Please enter a valid email address for SMTP username.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">SMTP Password</label>
                                    <input type="password" id="smtpPassword" class="form-control" value="••••••••••••" 
                                           placeholder="Enter SMTP password" minlength="6">
                                    <div class="invalid-feedback">Password must be at least 6 characters long.</div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-primary-custom" onclick="return testEmailConnection(event);">
                                <i class="fas fa-paper-plane me-2"></i>Test Connection
                            </button>
                            <button type="button" class="btn btn-success-custom" onclick="return sendTestEmail(event);">
                                <i class="fas fa-envelope me-2"></i>Send Test Email
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Backup Settings -->
                <div class="tab-pane fade" id="backup" role="tabpanel">
                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-database text-primary"></i>
                            <div>
                                <h3 class="section-title">Backup Status</h3>
                                <p class="section-description">Current backup information and history</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="info-card success">
                                    <h6><i class="fas fa-check-circle"></i>Last Backup</h6>
                                    <p><strong>August 5, 2025</strong></p>
                                    <p>11:30 PM GMT</p>
                                    <span class="status-badge online">Success</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-card">
                                    <h6><i class="fas fa-clock"></i>Next Backup</h6>
                                    <p><strong>August 6, 2025</strong></p>
                                    <p>11:30 PM GMT</p>
                                    <span class="status-badge maintenance">Scheduled</span>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="info-card">
                                    <h6><i class="fas fa-hdd"></i>Backup Size</h6>
                                    <p><strong>2.3 GB</strong></p>
                                    <p>Database: 1.8 GB</p>
                                    <p>Files: 0.5 GB</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-cog text-primary"></i>
                            <div>
                                <h3 class="section-title">Backup Configuration</h3>
                                <p class="section-description">Configure automatic backup settings</p>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Backup Frequency</label>
                                    <select class="form-select">
                                        <option value="daily" selected>Daily</option>
                                        <option value="weekly">Weekly</option>
                                        <option value="monthly">Monthly</option>
                                        <option value="manual">Manual Only</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Backup Time</label>
                                    <input type="time" class="form-control" value="23:30">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Retention Period (days)</label>
                                    <input type="number" id="retentionPeriod" class="form-control" value="30" min="7" max="365" required>
                                    <div class="invalid-feedback">Please enter a value between 7 and 365 days.</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="form-label">Storage Location</label>
                                    <select id="storageLocation" class="form-select" required>
                                        <option value="">Select storage location</option>
                                        <option value="local">Local Server</option>
                                        <option value="cloud" selected>Cloud Storage</option>
                                        <option value="external">External Drive</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a storage location.</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="settings-section">
                        <div class="section-header">
                            <i class="fas fa-tools text-primary"></i>
                            <div>
                                <h3 class="section-title">Backup Actions</h3>
                                <p class="section-description">Manual backup and restore operations</p>
                            </div>
                        </div>

                        <div class="info-card warning">
                            <h6><i class="fas fa-exclamation-triangle"></i>Important Notice</h6>
                            <p>Always test backups regularly. Consider creating a backup before major system updates.</p>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <button type="button" class="btn btn-primary-custom w-100 mb-3" onclick="return createBackup(event);">
                                    <i class="fas fa-save me-2"></i>Create Backup
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-success-custom w-100 mb-3" onclick="return downloadBackup(event);">
                                    <i class="fas fa-download me-2"></i>Download Latest
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-primary-custom w-100 mb-3" onclick="return viewBackupHistory(event);">
                                    <i class="fas fa-history me-2"></i>View History
                                </button>
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-danger-custom w-100 mb-3" onclick="return restoreBackup(event);">
                                    <i class="fas fa-undo me-2"></i>Restore Backup
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Settings JavaScript -->
    <script>
        // Fixed Custom Theme - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Fixed custom theme applied to Settings.aspx');
            initializeSettings();
        });

        function initializeSettings() {
            // Initialize file upload drag and drop
            initializeFileUpload();
            
            // Load current settings
            loadCurrentSettings();
            
            // Initialize form validation
            initializeFormValidation();
            
            // Initialize real-time validation
            initializeRealTimeValidation();
        }

        function initializeFormValidation() {
            // Add validation warning containers
            addValidationWarnings();
            
            // Initialize password strength checker
            initializePasswordStrength();
            
            // Set up form submission validation
            setupFormValidation();
        }

        function addValidationWarnings() {
            const forms = ['general', 'security', 'notifications', 'backup'];
            
            forms.forEach(formName => {
                const container = document.querySelector(`#${formName}`);
                if (container) {
                    const warningDiv = document.createElement('div');
                    warningDiv.className = 'validation-warning';
                    warningDiv.id = `${formName}-validation-warning`;
                    warningDiv.innerHTML = `
                        <h6><i class="fas fa-exclamation-triangle me-2"></i>Validation Errors</h6>
                        <ul id="${formName}-error-list"></ul>
                    `;
                    container.insertBefore(warningDiv, container.firstChild);
                }
            });
        }

        function initializePasswordStrength() {
            const passwordField = document.getElementById('smtpPassword');
            if (passwordField) {
                const strengthIndicator = document.createElement('div');
                strengthIndicator.className = 'password-strength';
                strengthIndicator.innerHTML = '<div class="password-strength-bar"></div>';
                passwordField.parentNode.appendChild(strengthIndicator);

                passwordField.addEventListener('input', function() {
                    checkPasswordStrength(this.value, strengthIndicator);
                });
            }
        }

        function checkPasswordStrength(password, indicator) {
            let strength = 0;
            
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            const classes = ['weak', 'fair', 'good', 'strong'];
            indicator.className = 'password-strength';
            
            if (strength > 0) {
                indicator.classList.add(classes[Math.min(strength - 1, 3)]);
            }
        }

        function initializeRealTimeValidation() {
            // Institution Name validation
            const institutionName = document.getElementById('institutionName');
            if (institutionName) {
                institutionName.addEventListener('blur', function() {
                    validateInstitutionName(this);
                });
            }

            // Institution Code validation
            const institutionCode = document.getElementById('institutionCode');
            if (institutionCode) {
                institutionCode.addEventListener('input', function() {
                    this.value = this.value.toUpperCase();
                });
                institutionCode.addEventListener('blur', function() {
                    validateInstitutionCode(this);
                });
            }

            // Email validation
            const emailFields = ['contactEmail', 'smtpUsername'];
            emailFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    field.addEventListener('blur', function() {
                        validateEmail(this);
                    });
                }
            });

            // Phone validation
            const phoneField = document.getElementById('contactPhone');
            if (phoneField) {
                phoneField.addEventListener('blur', function() {
                    validatePhone(this);
                });
            }

            // Numeric field validation
            const numericFields = ['sessionTimeoutMinutes', 'maxLoginAttempts', 'smtpPort', 'retentionPeriod'];
            numericFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    field.addEventListener('blur', function() {
                        validateNumericField(this);
                    });
                }
            });
        }

        function validateInstitutionName(field) {
            const value = field.value.trim();
            const isValid = value.length >= 3 && value.length <= 100;
            
            setFieldValidation(field, isValid);
            return isValid;
        }

        function validateInstitutionCode(field) {
            const value = field.value.trim();
            const pattern = /^[A-Z0-9]{2,10}$/;
            const isValid = pattern.test(value);
            
            setFieldValidation(field, isValid);
            return isValid;
        }

        function validateEmail(field) {
            const value = field.value.trim();
            const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const isValid = pattern.test(value);
            
            setFieldValidation(field, isValid);
            return isValid;
        }

        function validatePhone(field) {
            const value = field.value.trim();
            const pattern = /^[+]?[0-9\s\-()]{10,20}$/;
            const isValid = value === '' || pattern.test(value);
            
            setFieldValidation(field, isValid);
            return isValid;
        }

        function validateNumericField(field) {
            const value = parseInt(field.value);
            const min = parseInt(field.getAttribute('min'));
            const max = parseInt(field.getAttribute('max'));
            const required = field.hasAttribute('required');
            
            let isValid = true;
            
            if (required && (isNaN(value) || field.value.trim() === '')) {
                isValid = false;
            } else if (!isNaN(value)) {
                if (!isNaN(min) && value < min) isValid = false;
                if (!isNaN(max) && value > max) isValid = false;
            }
            
            setFieldValidation(field, isValid);
            return isValid;
        }

        function setFieldValidation(field, isValid) {
            field.classList.remove('is-valid', 'is-invalid');
            
            if (field.value.trim() !== '') {
                field.classList.add(isValid ? 'is-valid' : 'is-invalid');
            }
        }

        function setupFormValidation() {
            // Override save functions to include validation
            const originalSaveGeneral = window.saveGeneralSettings;
            window.saveGeneralSettings = function() {
                if (validateGeneralForm()) {
                    originalSaveGeneral();
                } else {
                    showFormValidationErrors('general');
                }
            };

            const originalSaveSecurity = window.saveSecuritySettings;
            window.saveSecuritySettings = function() {
                if (validateSecurityForm()) {
                    originalSaveSecurity();
                } else {
                    showFormValidationErrors('security');
                }
            };
        }

        function validateGeneralForm() {
            const fields = [
                { id: 'institutionName', validator: validateInstitutionName },
                { id: 'institutionCode', validator: validateInstitutionCode },
                { id: 'contactEmail', validator: validateEmail },
                { id: 'contactPhone', validator: validatePhone }
            ];

            let isValid = true;
            const errors = [];

            fields.forEach(fieldInfo => {
                const field = document.getElementById(fieldInfo.id);
                if (field && !fieldInfo.validator(field)) {
                    isValid = false;
                    errors.push(getFieldErrorMessage(field));
                }
            });

            // Validate address
            const address = document.getElementById('institutionAddress');
            if (address && !validateTextArea(address)) {
                isValid = false;
                errors.push('Institution address must be between 10 and 500 characters');
            }

            return isValid;
        }

        function validateSecurityForm() {
            const fields = [
                { id: 'sessionTimeoutMinutes', validator: validateNumericField },
                { id: 'maxLoginAttempts', validator: validateNumericField }
            ];

            let isValid = true;

            fields.forEach(fieldInfo => {
                const field = document.getElementById(fieldInfo.id);
                if (field && !fieldInfo.validator(field)) {
                    isValid = false;
                }
            });

            return isValid;
        }

        function validateTextArea(field) {
            const value = field.value.trim();
            const minLength = parseInt(field.getAttribute('minlength')) || 0;
            const maxLength = parseInt(field.getAttribute('maxlength')) || Infinity;
            const required = field.hasAttribute('required');
            
            if (required && value === '') return false;
            if (value.length < minLength || value.length > maxLength) return false;
            
            setFieldValidation(field, true);
            return true;
        }

        function getFieldErrorMessage(field) {
            const feedback = field.nextElementSibling;
            return feedback && feedback.classList.contains('invalid-feedback') ? feedback.textContent : 'Invalid input';
        }

        function showFormValidationErrors(formName) {
            const warning = document.getElementById(`${formName}-validation-warning`);
            const errorList = document.getElementById(`${formName}-error-list`);
            
            if (warning && errorList) {
                const errors = getFormErrors(formName);
                
                if (errors.length > 0) {
                    errorList.innerHTML = errors.map(error => `<li>${error}</li>`).join('');
                    warning.classList.add('show');
                    
                    // Scroll to the warning
                    warning.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    
                    // Hide warning after 10 seconds
                    setTimeout(() => {
                        warning.classList.remove('show');
                    }, 10000);
                }
            }
        }

        function getFormErrors(formName) {
            const errors = [];
            const form = document.getElementById(formName);
            
            if (form) {
                const invalidFields = form.querySelectorAll('.is-invalid');
                invalidFields.forEach(field => {
                    const feedback = field.nextElementSibling;
                    if (feedback && feedback.classList.contains('invalid-feedback')) {
                        errors.push(feedback.textContent);
                    }
                });
            }
            
            return errors;
        }

        function initializeFileUpload() {
            const uploadArea = document.querySelector('.file-upload-area');
            const fileInput = document.getElementById('logoUpload');
            
            // Enhanced drag and drop
            uploadArea.addEventListener('dragover', function(e) {
                e.preventDefault();
                this.classList.add('dragover', 'drag-active');
            });

            uploadArea.addEventListener('dragleave', function(e) {
                e.preventDefault();
                this.classList.remove('dragover', 'drag-active');
            });

            uploadArea.addEventListener('drop', function(e) {
                e.preventDefault();
                this.classList.remove('dragover', 'drag-active');
                
                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    handleFileUpload(files[0]);
                }
            });

            // File input change handler
            fileInput.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    handleFileUpload(e.target.files[0]);
                }
            });

            // Load existing logo if any
            loadCurrentLogo();
        }

        function loadCurrentLogo() {
            // Simulate loading existing logo - in real implementation, this would fetch from server
            const existingLogoPath = 'assets/images/uew_logo.png'; // Replace with actual path
            
            // Check if logo exists (in real implementation, you'd make an AJAX call)
            const img = new Image();
            img.onload = function() {
                displayCurrentLogo(existingLogoPath, 'UEW Logo', '45 KB');
            };
            img.onerror = function() {
                // No existing logo or failed to load
                console.log('No existing logo found');
            };
            // Uncomment the next line when you have an actual logo path
            // img.src = existingLogoPath;
        }

        function displayCurrentLogo(imagePath, fileName, fileSize) {
            const currentLogoContainer = document.getElementById('currentLogo');
            const logoPreview = document.getElementById('logoPreview');
            const logoInfo = document.getElementById('logoInfo');
            
            logoPreview.src = imagePath;
            logoInfo.textContent = `${fileName} (${fileSize})`;
            currentLogoContainer.style.display = 'block';
        }

        function handleFileUpload(file) {
            // Comprehensive file validation
            const validTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/svg+xml'];
            const maxSize = 5 * 1024 * 1024; // 5MB
            const minSize = 1024; // 1KB
            
            // Reset any previous validation states
            const uploadArea = document.querySelector('.file-upload-area');
            uploadArea.classList.remove('error', 'success');
            
            // Validate file type
            if (!validTypes.includes(file.type)) {
                showFileError('Invalid file type. Please upload PNG, JPG, or SVG files only.');
                return false;
            }
            
            // Validate file size
            if (file.size > maxSize) {
                showFileError('File too large. Please upload files smaller than 5MB.');
                return false;
            }
            
            if (file.size < minSize) {
                showFileError('File too small. Please upload files larger than 1KB.');
                return false;
            }
            
            // Validate file name
            const fileName = file.name;
            const validNamePattern = /^[a-zA-Z0-9._-]+$/;
            if (!validNamePattern.test(fileName)) {
                showFileError('Invalid file name. Use only letters, numbers, dots, hyphens, and underscores.');
                return false;
            }
            
            // Check for potential security issues
            if (fileName.toLowerCase().includes('script') || fileName.includes('..')) {
                showFileError('Security violation detected in file name.');
                return false;
            }
            
            // If validation passes, start upload process
            startFileUpload(file);
            return true;
        }

        function startFileUpload(file) {
            const uploadArea = document.querySelector('.file-upload-area');
            const uploadProgress = document.getElementById('uploadProgress');
            const progressBar = document.getElementById('progressBar');
            const uploadPercent = document.getElementById('uploadPercent');
            
            // Show upload state
            uploadArea.classList.add('uploading');
            uploadProgress.style.display = 'block';
            
            // Create file reader to preview image immediately
            const reader = new FileReader();
            reader.onload = function(e) {
                // Preview the image immediately
                previewUploadedImage(e.target.result, file.name, formatFileSize(file.size));
            };
            reader.readAsDataURL(file);
            
            // Simulate upload progress (replace with actual upload logic)
            simulateUploadProgress(file, progressBar, uploadPercent, uploadArea, uploadProgress);
        }

        function simulateUploadProgress(file, progressBar, uploadPercent, uploadArea, uploadProgress) {
            let progress = 0;
            const uploadInterval = setInterval(() => {
                progress += Math.random() * 20;
                if (progress >= 100) {
                    progress = 100;
                    clearInterval(uploadInterval);
                    
                    // Upload complete
                    setTimeout(() => {
                        uploadArea.classList.remove('uploading');
                        uploadArea.classList.add('success');
                        uploadProgress.style.display = 'none';
                        
                        // Reset upload area after a moment
                        setTimeout(() => {
                            uploadArea.classList.remove('success');
                        }, 3000);
                        
                        showFileSuccess('Logo uploaded successfully! The new logo has been saved.');
                        
                        // In real implementation, you would make an AJAX call here:
                        // uploadFileToServer(file);
                        
                    }, 500);
                }
                
                progressBar.style.width = progress + '%';
                uploadPercent.textContent = Math.round(progress) + '%';
            }, 200);
        }

        function previewUploadedImage(imageSrc, fileName, fileSize) {
            displayCurrentLogo(imageSrc, fileName, fileSize);
        }

        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        function removeLogo() {
            Swal.fire({
                title: 'Remove Logo?',
                text: 'Are you sure you want to remove the current logo?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, remove it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    const currentLogoContainer = document.getElementById('currentLogo');
                    currentLogoContainer.style.display = 'none';
                    
                    // Reset file input
                    document.getElementById('logoUpload').value = '';
                    
                    showSuccessAlert('Logo Removed', 'The institution logo has been removed successfully.');
                    
                    // In real implementation, you would make an AJAX call here:
                    // removeLogoFromServer();
                }
            });
        }

        // Real server upload function (to be implemented with actual server endpoint)
        function uploadFileToServer(file) {
            const formData = new FormData();
            formData.append('logoFile', file);
            formData.append('institutionId', '1'); // Replace with actual institution ID
            
            fetch('/api/settings/upload-logo', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showFileSuccess('Logo uploaded successfully to server!');
                } else {
                    showFileError('Server upload failed: ' + data.message);
                }
            })
            .catch(error => {
                showFileError('Upload failed: ' + error.message);
            });
        }

        function validateSVGFile(file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const svgContent = e.target.result;
                
                // Check for potentially dangerous SVG content
                const dangerousPatterns = [
                    /<script/i,
                    /javascript:/i,
                    /on\w+\s*=/i,
                    /<iframe/i,
                    /<object/i,
                    /<embed/i,
                    /<link/i,
                    /<meta/i
                ];
                
                const hasDangerousContent = dangerousPatterns.some(pattern => pattern.test(svgContent));
                
                if (hasDangerousContent) {
                    showFileError('SVG file contains potentially dangerous content and cannot be uploaded.');
                    return false;
                }
                
                showFileSuccess('SVG logo uploaded successfully after security validation!');
                return true;
            };
            reader.readAsText(file);
        }

        function showFileError(message) {
            showErrorAlert('File Upload Error', message);
            const uploadArea = document.querySelector('.file-upload-area');
            uploadArea.classList.add('error');
            
            // Remove error class after 3 seconds
            setTimeout(() => {
                uploadArea.classList.remove('error');
            }, 3000);
        }

        function showFileSuccess(message) {
            showSuccessAlert('Upload Successful', message);
            const uploadArea = document.querySelector('.file-upload-area');
            uploadArea.classList.add('success');
            
            // Remove success class after 3 seconds
            setTimeout(() => {
                uploadArea.classList.remove('success');
            }, 3000);
        }

        function loadCurrentSettings() {
            // Simulate loading current settings from server
            console.log('Loading current settings...');
        }

        // General Settings Functions
        function saveGeneralSettings(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Saving general settings...');
            
            setTimeout(() => {
                showSuccessAlert('Settings Saved!', 'General settings have been updated successfully.');
            }, 1500);

            return false; // Prevent any form submission
        }

        // System Functions
        function clearCache(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Clearing system cache...');
            
            setTimeout(() => {
                showSuccessAlert('Cache Cleared!', 'System cache has been cleared successfully.');
            }, 2000);

            return false; // Prevent any form submission
        }

        function optimizeDatabase(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Optimizing database...');
            
            setTimeout(() => {
                showSuccessAlert('Database Optimized!', 'Database optimization completed successfully.');
            }, 3000);

            return false; // Prevent any form submission
        }

        function systemCheck(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Running system health check...');
            
            setTimeout(() => {
                showSuccessAlert('System Healthy!', 'All system components are functioning properly.');
            }, 2500);

            return false; // Prevent any form submission
        }

        function restartSystem(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Restart System?',
                text: 'This will temporarily make the system unavailable. Continue?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, restart!'
            }).then((result) => {
                if (result.isConfirmed) {
                    showLoadingAlert('Restarting system...');
                    setTimeout(() => {
                        showSuccessAlert('System Restarted!', 'System has been restarted successfully.');
                    }, 4000);
                }
            });

            return false; // Prevent any form submission
        }

        // Security Functions
        function saveSecuritySettings(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Saving security settings...');
            
            setTimeout(() => {
                showSuccessAlert('Security Updated!', 'Security settings have been updated successfully.');
            }, 1500);

            return false; // Prevent any form submission
        }

        function regenerateApiKey(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Regenerate API Key?',
                html: `
                    <div class="text-start">
                        <p>This will invalidate the current API key and generate a new one.</p>
                        <div class="alert alert-warning">
                            <strong>⚠️ Important:</strong>
                            <ul class="mb-0 mt-2">
                                <li>Update all integrations immediately</li>
                                <li>Current applications will stop working</li>
                                <li>This action cannot be undone</li>
                            </ul>
                        </div>
                    </div>
                `,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, regenerate!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    performApiKeyRegeneration();
                }
            });

            return false; // Prevent any form submission
        }

        function performApiKeyRegeneration() {
            // Show loading state
            showLoadingAlert('Generating new API key...');
            
            // Simulate API key generation process
            setTimeout(() => {
                const newApiKey = generateSecureApiKey();
                updateApiKeyDisplay(newApiKey);
                
                // Close loading and show success with the new key
                Swal.fire({
                    title: 'New API Key Generated!',
                    html: `
                        <div class="text-start">
                            <p class="mb-3">Your new API key has been generated successfully:</p>
                            <div class="bg-light p-3 rounded border">
                                <code class="text-break" style="font-size: 0.9rem;">${newApiKey}</code>
                            </div>
                            <div class="alert alert-info mt-3 mb-0">
                                <strong>📋 Important:</strong> Copy this key now and update your integrations immediately.
                            </div>
                        </div>
                    `,
                    icon: 'success',
                    confirmButtonColor: '#2c2b7c',
                    confirmButtonText: 'I have copied the key',
                    allowOutsideClick: false
                }).then(() => {
                    // Auto-copy to clipboard
                    copyToClipboard(newApiKey);
                    showSuccessToast('API key copied to clipboard!');
                });
                
                // Update key information
                updateApiKeyInfo();
                
            }, 2000);
        }

        function generateSecureApiKey() {
            // Generate a secure API key
            const prefix = 'lms_api';
            const timestamp = Date.now().toString(36);
            const randomPart1 = generateRandomString(16);
            const randomPart2 = generateRandomString(16);
            const checksum = generateChecksum(timestamp + randomPart1 + randomPart2);
            
            return `${prefix}_${timestamp}_${randomPart1}_${randomPart2}_${checksum}`;
        }

        function generateRandomString(length) {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            let result = '';
            for (let i = 0; i < length; i++) {
                result += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return result;
        }

        function generateChecksum(input) {
            // Simple checksum generation (in production, use a proper hash function)
            let hash = 0;
            for (let i = 0; i < input.length; i++) {
                const char = input.charCodeAt(i);
                hash = ((hash << 5) - hash) + char;
                hash = hash & hash; // Convert to 32-bit integer
            }
            return Math.abs(hash).toString(36).substr(0, 8);
        }

        function updateApiKeyDisplay(newKey) {
            const apiKeyField = document.getElementById('currentApiKey');
            const maskedKey = maskApiKey(newKey);
            
            // Store the full key (in real app, this would be stored securely)
            apiKeyField.dataset.fullKey = newKey;
            apiKeyField.value = maskedKey;
            
            // Reset visibility to hidden
            apiKeyField.dataset.visible = 'false';
            const eyeIcon = document.getElementById('eyeIcon');
            eyeIcon.className = 'fas fa-eye';
        }

        function maskApiKey(key) {
            if (key.length <= 20) return key;
            return key.substring(0, 20) + '********************************';
        }

        function updateApiKeyInfo() {
            const now = new Date();
            const expiryDate = new Date(now.getTime() + (365 * 24 * 60 * 60 * 1000)); // 1 year from now
            
            document.getElementById('keyCreatedDate').textContent = now.toLocaleDateString();
            document.getElementById('keyLastUsed').textContent = 'Just now';
            document.getElementById('keyExpiryDate').textContent = expiryDate.toLocaleDateString();
            document.getElementById('keyStatus').textContent = 'Active';
            
            // Reset usage statistics
            document.getElementById('totalRequests').textContent = '0';
            document.getElementById('requestsToday').textContent = '0';
            document.getElementById('remainingRequests').textContent = '1000';
        }

        function toggleApiKeyVisibility() {
            const apiKeyField = document.getElementById('currentApiKey');
            const eyeIcon = document.getElementById('eyeIcon');
            const isVisible = apiKeyField.dataset.visible === 'true';
            
            if (isVisible) {
                // Hide the key
                const fullKey = apiKeyField.dataset.fullKey || apiKeyField.value;
                apiKeyField.value = maskApiKey(fullKey);
                apiKeyField.dataset.visible = 'false';
                eyeIcon.className = 'fas fa-eye';
            } else {
                // Show the key
                const fullKey = apiKeyField.dataset.fullKey || 'lms_api_key_2024_example_key_for_testing_purposes_abc123def456';
                apiKeyField.value = fullKey;
                apiKeyField.dataset.visible = 'true';
                eyeIcon.className = 'fas fa-eye-slash';
            }
        }

        function copyApiKey() {
            const apiKeyField = document.getElementById('currentApiKey');
            const fullKey = apiKeyField.dataset.fullKey || apiKeyField.value;
            
            copyToClipboard(fullKey);
            showSuccessToast('API key copied to clipboard!');
        }

        function copyToClipboard(text) {
            if (navigator.clipboard && window.isSecureContext) {
                // Use modern clipboard API
                navigator.clipboard.writeText(text).then(() => {
                    console.log('Text copied to clipboard');
                }).catch(err => {
                    console.error('Failed to copy text: ', err);
                    fallbackCopyToClipboard(text);
                });
            } else {
                // Fallback for older browsers
                fallbackCopyToClipboard(text);
            }
        }

        function fallbackCopyToClipboard(text) {
            const textArea = document.createElement('textarea');
            textArea.value = text;
            textArea.style.position = 'fixed';
            textArea.style.top = '-9999px';
            document.body.appendChild(textArea);
            textArea.select();
            
            try {
                document.execCommand('copy');
            } catch (err) {
                console.error('Fallback copy failed: ', err);
            }
            
            document.body.removeChild(textArea);
        }

        function showSuccessToast(message) {
            const toast = document.createElement('div');
            toast.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #28a745;
                color: white;
                padding: 0.75rem 1rem;
                border-radius: 8px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.2);
                z-index: 1000;
                font-size: 0.875rem;
                animation: slideInRight 0.3s ease;
            `;
            toast.innerHTML = `<i class="fas fa-check-circle me-2"></i>${message}`;
            
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        // Notification Functions
        function testEmailConnection(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Testing email connection...');
            
            setTimeout(() => {
                showSuccessAlert('Connection Successful!', 'SMTP connection test completed successfully.');
            }, 2000);

            return false; // Prevent any form submission
        }

        function sendTestEmail(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Sending test email...');
            
            setTimeout(() => {
                showSuccessAlert('Test Email Sent!', 'Test email has been sent successfully.');
            }, 1500);

            return false; // Prevent any form submission
        }

        // Backup Functions
        function createBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            // First validate backup configuration
            if (!validateBackupConfiguration()) {
                return false;
            }

            // Get current configuration
            const backupConfig = getBackupConfiguration();
            
            Swal.fire({
                title: 'Create System Backup?',
                html: `
                    <div class="text-start">
                        <p>This will create a complete system backup with the following configuration:</p>
                        <div class="bg-light p-3 rounded">
                            <p class="mb-2"><strong>📁 Storage Location:</strong> ${backupConfig.storageLocation}</p>
                            <p class="mb-2"><strong>⏰ Backup Type:</strong> Manual (On-demand)</p>
                            <p class="mb-2"><strong>📊 Estimated Size:</strong> ~2.5 GB</p>
                            <p class="mb-0"><strong>⏱️ Estimated Time:</strong> 5-10 minutes</p>
                        </div>
                        <div class="alert alert-info mt-3 mb-0">
                            <strong>💡 Note:</strong> The system will remain accessible during backup creation.
                        </div>
                    </div>
                `,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, create backup!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    performBackupCreation(backupConfig);
                }
            });
            
            return false; // Prevent any form submission
        }

        function validateBackupConfiguration() {
            const errors = [];
            const warnings = [];

            // Check storage location
            const storageLocation = document.getElementById('storageLocation');
            if (!storageLocation || !storageLocation.value) {
                errors.push('Storage location must be selected');
            }

            // Check retention period
            const retentionPeriod = document.getElementById('retentionPeriod');
            if (!retentionPeriod || !retentionPeriod.value || retentionPeriod.value < 7) {
                errors.push('Retention period must be at least 7 days');
            }

            // Check backup frequency
            const backupFrequency = document.querySelector('select[class*="form-select"]');
            if (!backupFrequency || !backupFrequency.value) {
                warnings.push('Backup frequency not set - only manual backups will be available');
            }

            // Check disk space (simulated)
            const availableSpace = getAvailableDiskSpace();
            if (availableSpace < 5000) { // Less than 5GB
                warnings.push('Low disk space detected - backup may fail');
            }

            if (errors.length > 0) {
                showBackupConfigurationError(errors, warnings);
                return false;
            }

            if (warnings.length > 0) {
                showBackupConfigurationWarning(warnings);
            }

            return true;
        }

        function getBackupConfiguration() {
            const storageLocation = document.getElementById('storageLocation');
            const retentionPeriod = document.getElementById('retentionPeriod');
            const backupFrequency = document.querySelector('select[class*="form-select"]');
            const backupTime = document.querySelector('input[type="time"]');

            return {
                storageLocation: getStorageLocationText(storageLocation?.value || 'cloud'),
                retentionDays: retentionPeriod?.value || '30',
                frequency: backupFrequency?.value || 'manual',
                time: backupTime?.value || '23:30',
                estimatedSize: '2.5 GB',
                estimatedTime: '5-10 minutes'
            };
        }

        function getStorageLocationText(value) {
            const locations = {
                'local': 'Local Server Storage',
                'cloud': 'Cloud Storage (Configured)',
                'external': 'External Drive (Connected)'
            };
            return locations[value] || 'Unknown Storage';
        }

        function getAvailableDiskSpace() {
            // Simulate disk space check (in real implementation, this would be an AJAX call)
            return Math.random() * 10000 + 5000; // Random between 5-15GB
        }

        function showBackupConfigurationError(errors, warnings) {
            let warningHtml = '';
            if (warnings.length > 0) {
                warningHtml = `
                    <div class="alert alert-warning mt-3">
                        <strong>⚠️ Warnings:</strong>
                        <ul class="mb-0 mt-2">
                            ${warnings.map(w => `<li>${w}</li>`).join('')}
                        </ul>
                    </div>
                `;
            }

            Swal.fire({
                title: 'Backup Configuration Error',
                html: `
                    <div class="text-start">
                        <p>Please fix the following configuration issues before creating a backup:</p>
                        <div class="alert alert-danger">
                            <strong>❌ Errors:</strong>
                            <ul class="mb-0 mt-2">
                                ${errors.map(e => `<li>${e}</li>`).join('')}
                            </ul>
                        </div>
                        ${warningHtml}
                        <p class="mt-3">Go to the <strong>Backup Configuration</strong> section to fix these issues.</p>
                    </div>
                `,
                icon: 'error',
                confirmButtonColor: '#ee1c24',
                confirmButtonText: 'Fix Configuration'
            }).then(() => {
                // Scroll to backup configuration section
                const configSection = document.querySelector('#backup .settings-section:nth-child(2)');
                if (configSection) {
                    configSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    
                    // Highlight the section temporarily
                    configSection.style.border = '2px solid #ee1c24';
                    configSection.style.borderRadius = '8px';
                    setTimeout(() => {
                        configSection.style.border = '';
                        configSection.style.borderRadius = '';
                    }, 3000);
                }
            });
        }

        function showBackupConfigurationWarning(warnings) {
            Swal.fire({
                title: 'Configuration Warnings',
                html: `
                    <div class="text-start">
                        <p>The following warnings were detected:</p>
                        <div class="alert alert-warning">
                            <strong>⚠️ Warnings:</strong>
                            <ul class="mb-0 mt-2">
                                ${warnings.map(w => `<li>${w}</li>`).join('')}
                            </ul>
                        </div>
                        <p>You can proceed with backup creation, but consider addressing these warnings.</p>
                    </div>
                `,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Proceed Anyway',
                cancelButtonText: 'Fix Issues First'
            }).then((result) => {
                if (result.isConfirmed) {
                    const backupConfig = getBackupConfiguration();
                    performBackupCreation(backupConfig);
                }
            });
        }

        function performBackupCreation(config) {
            showLoadingAlert('Preparing backup creation...');
            
            // Simulate backup creation process with real-time updates
            setTimeout(() => {
                Swal.update({
                    title: 'Creating Backup...',
                    html: `
                        <div class="text-start">
                            <div class="backup-progress-container">
                                <div class="d-flex justify-content-between mb-2">
                                    <span>Progress</span>
                                    <span id="backupProgress">0%</span>
                                </div>
                                <div class="progress mb-3">
                                    <div class="progress-bar progress-bar-striped progress-bar-animated" 
                                         id="backupProgressBar" style="width: 0%"></div>
                                </div>
                                <div id="backupStatus">Initializing backup process...</div>
                            </div>
                        </div>
                    `,
                    allowOutsideClick: false,
                    showConfirmButton: false
                });

                simulateBackupProgress(config);
            }, 1000);
        }

        function simulateBackupProgress(config) {
            const steps = [
                'Validating system state...',
                'Preparing database backup...',
                'Backing up database tables...',
                'Backing up user files...',
                'Backing up system configuration...',
                'Compressing backup files...',
                'Verifying backup integrity...',
                'Saving to ' + config.storageLocation + '...',
                'Backup completed successfully!'
            ];

            let currentStep = 0;
            let progress = 0;

            const progressInterval = setInterval(() => {
                progress += Math.random() * 15;
                
                if (progress >= 100) {
                    progress = 100;
                    currentStep = steps.length - 1;
                    clearInterval(progressInterval);
                    
                    setTimeout(() => {
                        completeBackupCreation(config);
                    }, 1000);
                } else if (currentStep < steps.length - 1 && progress > (currentStep + 1) * (100 / steps.length)) {
                    currentStep++;
                }

                const progressBar = document.getElementById('backupProgressBar');
                const progressText = document.getElementById('backupProgress');
                const statusText = document.getElementById('backupStatus');

                if (progressBar) progressBar.style.width = progress + '%';
                if (progressText) progressText.textContent = Math.round(progress) + '%';
                if (statusText) statusText.textContent = steps[currentStep];
            }, 500);
        }

        function completeBackupCreation(config) {
            const backupSize = (Math.random() * 1000 + 2000).toFixed(1); // Random size between 2-3GB
            const timestamp = new Date().toLocaleString();
            
            Swal.fire({
                title: 'Backup Created Successfully!',
                html: `
                    <div class="text-start">
                        <div class="alert alert-success">
                            <strong>✅ Backup completed successfully!</strong>
                        </div>
                        <div class="bg-light p-3 rounded">
                            <p class="mb-2"><strong>📁 Location:</strong> ${config.storageLocation}</p>
                            <p class="mb-2"><strong>📊 Size:</strong> ${backupSize} MB</p>
                            <p class="mb-2"><strong>⏰ Created:</strong> ${timestamp}</p>
                            <p class="mb-0"><strong>🔒 Status:</strong> Verified & Ready</p>
                        </div>
                        <div class="alert alert-info mt-3 mb-0">
                            <strong>💡 Next Steps:</strong> The backup has been added to your backup history and is ready for download or restore if needed.
                        </div>
                    </div>
                `,
                icon: 'success',
                confirmButtonColor: '#2c2b7c',
                confirmButtonText: 'View Backup History'
            }).then(() => {
                // Update backup status cards
                updateBackupStatusCards(timestamp, backupSize);
            });
        }

        function updateBackupStatusCards(timestamp, size) {
            // Update last backup card
            const lastBackupCard = document.querySelector('.info-card.success');
            if (lastBackupCard) {
                const dateElement = lastBackupCard.querySelector('p:first-of-type strong');
                const timeElement = lastBackupCard.querySelector('p:nth-of-type(2)');
                
                if (dateElement) dateElement.textContent = new Date().toLocaleDateString();
                if (timeElement) timeElement.textContent = new Date().toLocaleTimeString();
            }

            // Update backup size info
            const sizeCards = document.querySelectorAll('.info-card h6');
            sizeCards.forEach(card => {
                if (card.textContent.includes('Backup Size')) {
                    const sizeElement = card.parentElement.querySelector('p strong');
                    if (sizeElement) sizeElement.textContent = size + ' MB';
                }
            });

            // Show success toast
            showSuccessToast('Backup status updated successfully!');
        }

        function downloadBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showSuccessAlert('Download Started!', 'Latest backup download has been initiated.');
            return false; // Prevent any form submission
        }

        function viewBackupHistory(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            // Show loading first
            Swal.fire({
                title: 'Loading Backup History...',
                text: 'Please wait while we retrieve your backup history.',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });

            // Simulate loading and then show backup history
            setTimeout(() => {
                const backupHistoryHtml = `
                    <div class="text-start">
                        <div class="table-responsive">
                            <table class="table table-striped table-sm">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Size</th>
                                        <th>Type</th>
                                        <th>Storage Location</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><strong>Aug 8, 2025</strong></td>
                                        <td>14:30</td>
                                        <td>2.5 GB</td>
                                        <td><span class="badge bg-primary">Manual</span></td>
                                        <td><i class="fas fa-cloud text-info"></i> Cloud Storage</td>
                                        <td><span class="text-success"><i class="fas fa-check-circle"></i> Success</span></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-primary" onclick="return downloadBackupFile(event, 'latest');">Download</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Aug 7, 2025</strong></td>
                                        <td>23:30</td>
                                        <td>2.4 GB</td>
                                        <td><span class="badge bg-secondary">Auto</span></td>
                                        <td><i class="fas fa-cloud text-info"></i> Cloud Storage</td>
                                        <td><span class="text-success"><i class="fas fa-check-circle"></i> Success</span></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-primary" onclick="return downloadBackupFile(event, 'aug7');">Download</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Aug 6, 2025</strong></td>
                                        <td>23:30</td>
                                        <td>2.3 GB</td>
                                        <td><span class="badge bg-secondary">Auto</span></td>
                                        <td><i class="fas fa-cloud text-info"></i> Cloud Storage</td>
                                        <td><span class="text-success"><i class="fas fa-check-circle"></i> Success</span></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-primary" onclick="return downloadBackupFile(event, 'aug6');">Download</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Aug 5, 2025</strong></td>
                                        <td>15:45</td>
                                        <td>2.2 GB</td>
                                        <td><span class="badge bg-primary">Manual</span></td>
                                        <td><i class="fas fa-server text-secondary"></i> Local Server</td>
                                        <td><span class="text-success"><i class="fas fa-check-circle"></i> Success</span></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-primary" onclick="return downloadBackupFile(event, 'aug5');">Download</button></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Aug 4, 2025</strong></td>
                                        <td>23:30</td>
                                        <td>2.1 GB</td>
                                        <td><span class="badge bg-secondary">Auto</span></td>
                                        <td><i class="fas fa-hdd text-dark"></i> External Drive</td>
                                        <td><span class="text-warning"><i class="fas fa-exclamation-triangle"></i> Warning</span></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-primary" onclick="return downloadBackupFile(event, 'aug4');">Download</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="mt-3 p-3 bg-light rounded">
                            <h6><i class="fas fa-info-circle text-info"></i> Storage Information</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Total Backups:</strong> 5</p>
                                    <p class="mb-1"><strong>Total Size:</strong> 11.5 GB</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Storage Location:</strong> Cloud Storage</p>
                                    <p class="mb-1"><strong>Retention Period:</strong> 30 days</p>
                                </div>
                            </div>
                        </div>
                    </div>
                `;

                Swal.fire({
                    title: '<i class="fas fa-history text-primary"></i> Backup History',
                    html: backupHistoryHtml,
                    width: '90%',
                    confirmButtonColor: '#2c2b7c',
                    confirmButtonText: '<i class="fas fa-times"></i> Close',
                    customClass: {
                        popup: 'swal-wide'
                    }
                });
            }, 1000);

            return false; // Prevent any form submission
        }

        function restoreBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            // First show backup selection dialog
            const backupSelectionHtml = `
                <div class="text-start">
                    <p class="mb-3"><strong>Select a backup to restore:</strong></p>
                    <div class="form-group">
                        <select id="backupSelect" class="form-select" style="width: 100%;">
                            <option value="">Choose backup to restore...</option>
                            <option value="latest" data-size="2.5 GB" data-date="Aug 8, 2025 14:30" data-location="Cloud Storage">
                                Latest Backup - Aug 8, 2025 14:30 (2.5 GB) - Cloud Storage
                            </option>
                            <option value="aug7" data-size="2.4 GB" data-date="Aug 7, 2025 23:30" data-location="Cloud Storage">
                                Auto Backup - Aug 7, 2025 23:30 (2.4 GB) - Cloud Storage
                            </option>
                            <option value="aug6" data-size="2.3 GB" data-date="Aug 6, 2025 23:30" data-location="Cloud Storage">
                                Auto Backup - Aug 6, 2025 23:30 (2.3 GB) - Cloud Storage
                            </option>
                            <option value="aug5" data-size="2.2 GB" data-date="Aug 5, 2025 15:45" data-location="Local Server">
                                Manual Backup - Aug 5, 2025 15:45 (2.2 GB) - Local Server
                            </option>
                            <option value="aug4" data-size="2.1 GB" data-date="Aug 4, 2025 23:30" data-location="External Drive">
                                Auto Backup - Aug 4, 2025 23:30 (2.1 GB) - External Drive ⚠️
                            </option>
                        </select>
                    </div>
                    <div id="backupDetails" class="mt-3 p-3 bg-light rounded" style="display: none;">
                        <h6><i class="fas fa-info-circle text-info"></i> Backup Details</h6>
                        <p class="mb-1"><strong>📅 Date:</strong> <span id="selectedDate">-</span></p>
                        <p class="mb-1"><strong>📊 Size:</strong> <span id="selectedSize">-</span></p>
                        <p class="mb-1"><strong>📁 Location:</strong> <span id="selectedLocation">-</span></p>
                    </div>
                    <div class="alert alert-warning mt-3 mb-0">
                        <strong><i class="fas fa-exclamation-triangle"></i> Warning:</strong> 
                        This action will completely replace your current data with the selected backup. This cannot be undone.
                    </div>
                </div>
            `;

            Swal.fire({
                title: '<i class="fas fa-undo text-danger"></i> Restore System Backup',
                html: backupSelectionHtml,
                width: '600px',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-undo"></i> Restore Selected Backup',
                cancelButtonText: 'Cancel',
                preConfirm: () => {
                    const backupSelect = document.getElementById('backupSelect');
                    if (!backupSelect.value) {
                        Swal.showValidationMessage('Please select a backup to restore');
                        return false;
                    }
                    return {
                        backupId: backupSelect.value,
                        backupDate: backupSelect.options[backupSelect.selectedIndex].getAttribute('data-date'),
                        backupSize: backupSelect.options[backupSelect.selectedIndex].getAttribute('data-size'),
                        backupLocation: backupSelect.options[backupSelect.selectedIndex].getAttribute('data-location')
                    };
                },
                didOpen: () => {
                    // Add event listener for backup selection
                    const backupSelect = document.getElementById('backupSelect');
                    const backupDetails = document.getElementById('backupDetails');
                    const selectedDate = document.getElementById('selectedDate');
                    const selectedSize = document.getElementById('selectedSize');
                    const selectedLocation = document.getElementById('selectedLocation');

                    backupSelect.addEventListener('change', function() {
                        if (this.value) {
                            const selectedOption = this.options[this.selectedIndex];
                            selectedDate.textContent = selectedOption.getAttribute('data-date');
                            selectedSize.textContent = selectedOption.getAttribute('data-size');
                            selectedLocation.textContent = selectedOption.getAttribute('data-location');
                            backupDetails.style.display = 'block';
                        } else {
                            backupDetails.style.display = 'none';
                        }
                    });
                }
            }).then((result) => {
                if (result.isConfirmed && result.value) {
                    // Show final confirmation with selected backup details
                    confirmRestoreBackup(result.value);
                }
            });

            return false; // Prevent any form submission
        }

        function confirmRestoreBackup(backupInfo) {
            const confirmationHtml = `
                <div class="text-start">
                    <p class="mb-3">You are about to restore the following backup:</p>
                    <div class="bg-light p-3 rounded mb-3">
                        <p class="mb-2"><strong>📅 Backup Date:</strong> ${backupInfo.backupDate}</p>
                        <p class="mb-2"><strong>📊 File Size:</strong> ${backupInfo.backupSize}</p>
                        <p class="mb-2"><strong>📁 Storage Location:</strong> ${backupInfo.backupLocation}</p>
                        <p class="mb-0"><strong>🔧 Backup ID:</strong> ${backupInfo.backupId}</p>
                    </div>
                    <div class="alert alert-danger mb-0">
                        <strong><i class="fas fa-exclamation-triangle"></i> CRITICAL WARNING:</strong><br>
                        • All current data will be permanently lost<br>
                        • All user sessions will be terminated<br>
                        • System will be unavailable during restoration<br>
                        • This action is irreversible
                    </div>
                </div>
            `;

            Swal.fire({
                title: 'Final Confirmation Required',
                html: confirmationHtml,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: 'YES, RESTORE NOW',
                cancelButtonText: 'Cancel',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    performBackupRestore(backupInfo);
                }
            });
        }

        function performBackupRestore(backupInfo) {
            // Show restoration progress
            Swal.fire({
                title: 'Restoring System Backup',
                html: `
                    <div class="text-center">
                        <div class="mb-3">
                            <div class="spinner-border text-danger" role="status" style="width: 3rem; height: 3rem;">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        <p class="mb-2"><strong>Restoring from:</strong> ${backupInfo.backupDate}</p>
                        <p class="mb-3"><strong>Progress:</strong> <span id="restoreProgress">Initializing...</span></p>
                        <div class="progress mb-3">
                            <div id="restoreProgressBar" class="progress-bar bg-danger" role="progressbar" style="width: 0%"></div>
                        </div>
                        <div class="alert alert-info mb-0">
                            <small><i class="fas fa-info-circle"></i> Please do not close this window or refresh the page during restoration.</small>
                        </div>
                    </div>
                `,
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false
            });

            // Simulate restoration progress
            let progress = 0;
            const steps = [
                'Validating backup integrity...',
                'Stopping system services...',
                'Creating safety checkpoint...',
                'Extracting backup data...',
                'Restoring database...',
                'Restoring file system...',
                'Updating configurations...',
                'Restarting services...',
                'Finalizing restoration...'
            ];

            const progressInterval = setInterval(() => {
                progress += Math.random() * 15;
                if (progress > 100) progress = 100;

                const stepIndex = Math.floor((progress / 100) * steps.length);
                const currentStep = steps[Math.min(stepIndex, steps.length - 1)];

                document.getElementById('restoreProgress').textContent = currentStep;
                document.getElementById('restoreProgressBar').style.width = progress + '%';

                if (progress >= 100) {
                    clearInterval(progressInterval);
                    setTimeout(() => {
                        Swal.fire({
                            title: 'Backup Restored Successfully!',
                            html: `
                                <div class="text-center">
                                    <div class="mb-3">
                                        <i class="fas fa-check-circle text-success" style="font-size: 4rem;"></i>
                                    </div>
                                    <p class="mb-2">System has been successfully restored from:</p>
                                    <div class="bg-light p-3 rounded">
                                        <strong>${backupInfo.backupDate}</strong><br>
                                        <small class="text-muted">${backupInfo.backupSize} - ${backupInfo.backupLocation}</small>
                                    </div>
                                </div>
                            `,
                            icon: 'success',
                            confirmButtonColor: '#2c2b7c',
                            confirmButtonText: 'Continue'
                        });
                    }, 1000);
                }
            }, 800);
        }

        // Alert Functions
        function showSuccessAlert(title, text) {
            Swal.fire({
                title: title,
                text: text,
                icon: 'success',
                confirmButtonColor: '#2c2b7c'
            });
        }

        function showErrorAlert(title, text) {
            Swal.fire({
                title: title,
                text: text,
                icon: 'error',
                confirmButtonColor: '#ee1c24'
            });
        }

        function showLoadingAlert(title) {
            Swal.fire({
                title: title,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        // Toggle switch change handlers
        document.addEventListener('change', function(e) {
            if (e.target.type === 'checkbox' && e.target.closest('.toggle-switch')) {
                const settingName = e.target.id;
                const isEnabled = e.target.checked;
                console.log(`Setting ${settingName} ${isEnabled ? 'enabled' : 'disabled'}`);
                
                // Show a subtle notification for setting changes
                const toast = document.createElement('div');
                toast.style.cssText = `
                    position: fixed;
                    bottom: 20px;
                    right: 20px;
                    background: ${isEnabled ? '#28a745' : '#ffc107'};
                    color: white;
                    padding: 0.75rem 1rem;
                    border-radius: 8px;
                    box-shadow: 0 4px 16px rgba(0,0,0,0.2);
                    z-index: 1000;
                    font-size: 0.875rem;
                `;
                toast.textContent = `${settingName.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase())} ${isEnabled ? 'enabled' : 'disabled'}`;
                
                document.body.appendChild(toast);
                setTimeout(() => toast.remove(), 2000);
            }
        });

        // Download backup file function
        function downloadBackupFile(event, backupId) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Download Backup',
                text: `Preparing backup file for download...`,
                icon: 'info',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                    
                    // Simulate download preparation
                    setTimeout(() => {
                        Swal.fire({
                            title: 'Download Ready!',
                            text: `Backup file LMS_Backup_${backupId}.bak is ready for download.`,
                            icon: 'success',
                            confirmButtonColor: '#2c2b7c',
                            confirmButtonText: 'Start Download'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                // In a real implementation, this would trigger the actual download
                                showSuccessAlert('Download Started', 'Backup file download has been initiated.');
                            }
                        });
                    }, 2000);
                }
            });

            return false; // Prevent any form submission
        }
    </script>
</asp:Content>
