<%@ Page Title="Admin Help & Support" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Help" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Zoom Web SDK -->
    <script src="https://source.zoom.us/2.18.0/lib/vendor/react.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/react-dom.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/redux.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/redux-thunk.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/lib/vendor/lodash.min.js"></script>
    <script src="https://source.zoom.us/2.18.0/zoom-meeting-embedded-2.18.0.min.js"></script>

    <style>
        .help-header {
            background: linear-gradient(135deg, #2c2b7c 0%, #3498db 100%);
            color: white;
            padding: 2rem 0;
            margin: -20px -20px 2rem -20px;
            border-radius: 0 0 15px 15px;
        }

        .help-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            border: none;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .help-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .help-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #3498db, #2c2b7c);
        }

        .help-category {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        


        .category-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 1.5rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .category-card:hover {
            transform: translateY(-3px);
            border-color: #3498db;
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.15);
        }

        .category-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            margin: 0 auto 1rem;
            background: linear-gradient(135deg, #3498db, #2c2b7c);
        }

        .category-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #2c2b7c;
            margin-bottom: 0.5rem;
        }

        .category-description {
            color: #666;
            line-height: 1.5;
        }

        .search-container-help {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 2rem;
            margin-bottom: 3rem;
            text-align: center;
        }

        .search-input-help {
            border: 2px solid #e9ecef;
            border-radius: 25px;
            padding: 1rem 1.5rem 1rem 3.5rem;
            font-size: 1.1rem;
            width: 100%;
            max-width: 600px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .search-input-help:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background: white;
        }

        .search-icon-help {
            position: absolute;
            left: 1.25rem;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 1.2rem;
        }

        .help-history-category{
             display: grid;
            margin-top: 3rem;
            gap: 0.2rem;
            margin-bottom: 3rem;
        }

        .faq-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .faq-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-bottom: 2px solid #dee2e6;
        }

        .faq-item {
            border-bottom: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            padding: 1.5rem;
            cursor: pointer;
            display: flex;
            justify-content: between;
            align-items: center;
            background: white;
            transition: all 0.3s ease;
            border: none;
            width: 100%;
            text-align: left;
            font-size: 1rem;
            font-weight: 500;
            color: #2c2b7c;
        }

        .faq-question:hover {
            background: #f8f9fa;
        }

        .faq-question.active {
            background: #e3f2fd;
            color: #1976d2;
        }

        .faq-answer {
            padding: 0 1.5rem 1.5rem;
            color: #666;
            line-height: 1.6;
            display: none;
        }

        .faq-answer.show {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .faq-icon {
            margin-left: auto;
            transition: transform 0.3s ease;
        }

        .faq-question.active .faq-icon {
            transform: rotate(180deg);
        }

        .contact-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 3rem;
        }

        .contact-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
        }

        .contact-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .contact-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin: 0 auto 1rem;
        }

        .contact-icon.email {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }

        .contact-icon.phone {
            background: linear-gradient(135deg, #27ae60, #229954);
        }

        .contact-icon.chat {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }

        .contact-icon.ticket {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #2c2b7c, #3498db);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 25px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(44, 43, 124, 0.3);
            color: white;
            text-decoration: none;
        }

        .video-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 2rem;
            margin-bottom: 3rem;
        }

        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .video-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .video-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .video-thumbnail {
            position: relative;
            background: linear-gradient(135deg, #3498db, #2c2b7c);
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .video-play-btn {
            position: absolute;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255,255,255,0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2c2b7c;
            font-size: 1.5rem;
            transition: all 0.3s ease;
        }

        .video-play-btn:hover {
            background: white;
            transform: scale(1.1);
        }

        .video-info {
            padding: 1.5rem;
        }

        .video-title {
            font-weight: 600;
            color: #2c2b7c;
            margin-bottom: 0.5rem;
        }

        .video-description {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        .quick-links {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 2rem;
        }

        .quick-links-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .quick-link {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-radius: 8px;
            background: #f8f9fa;
            color: #2c2b7c;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .quick-link:hover {
            background: #e3f2fd;
            border-color: #3498db;
            color: #1976d2;
            text-decoration: none;
            transform: translateX(5px);
        }

        .quick-link i {
            margin-right: 0.75rem;
            font-size: 1.2rem;
        }

        @media (max-width: 768px) {
            .help-category {
                grid-template-columns: 1fr;
            }
            
            .contact-section {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .video-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-links-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Meeting History Styles */
        .meeting-history-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .meeting-item {
            transition: all 0.3s ease;
            padding: 1rem;
            margin-bottom: 0.5rem;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .meeting-item:hover {
            background: #e3f2fd;
            border-color: #3498db !important;
            transform: translateX(5px);
        }

        .meeting-item:last-child {
            border-bottom: none !important;
        }

        /* Zoom Modal Styles */
        #zoomMeetingContainer {
            border: 2px solid #007bff;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .zoom-controls {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-top: 1rem;
        }

        .btn-zoom {
            background: #2d8cff;
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-zoom:hover {
            background: #1a73e8;
            transform: translateY(-2px);
        }

        @media (max-width: 480px) {
            .contact-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Help Header -->
    <div class="help-header text-center">
        <div class="container">
            <h1><i class="fas fa-life-ring me-2"></i>Help & Support Center</h1>
            <p class="mb-0">Find answers, tutorials, and get assistance with your Learning Management System</p>
        </div>
    </div>

    <!-- Search Section -->
    <div class="search-container-help">
        <h3 class="mb-3">How can we help you today?</h3>
        <div class="position-relative d-inline-block w-100" style="max-width: 600px;">
            <i class="fas fa-search search-icon-help"></i>
            <input type="text" class="search-input-help" id="helpSearch-help" placeholder="Search for help topics, features, or issues...">
        </div>
        <p class="text-muted mt-2">Try searching for "user management", "course creation", or "system settings"</p>
    </div>

    <!-- Help Categories -->
    <div class="help-category">
        <div class="category-card" onclick="showCategory('getting-started')">
            <div class="category-icon">
                <i class="fas fa-rocket"></i>
            </div>
            <div class="category-title">Getting Started</div>
            <div class="category-description">Learn the basics of administering your Learning Management System</div>
        </div>

        <div class="category-card" onclick="showCategory('user-management')">
            <div class="category-icon">
                <i class="fas fa-users"></i>
            </div>
            <div class="category-title">User Management</div>
            <div class="category-description">Add, edit, and manage students, instructors, and administrators</div>
        </div>

        <div class="category-card" onclick="showCategory('course-management')">
            <div class="category-icon">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <div class="category-title">Course Management</div>
            <div class="category-description">Create courses, manage enrollments, and track progress</div>
        </div>

        <div class="category-card" onclick="showCategory('system-settings')">
            <div class="category-icon">
                <i class="fas fa-cog"></i>
            </div>
            <div class="category-title">System Settings</div>
            <div class="category-description">Configure system preferences, security, and integrations</div>
        </div>

        <div class="category-card" onclick="showCategory('reports')">
            <div class="category-icon">
                <i class="fas fa-chart-line"></i>
            </div>
            <div class="category-title">Reports & Analytics</div>
            <div class="category-description">Generate reports and analyze system performance</div>
        </div>

        <div class="category-card" onclick="showCategory('troubleshooting')">
            <div class="category-icon">
                <i class="fas fa-tools"></i>
            </div>
            <div class="category-title">Troubleshooting</div>
            <div class="category-description">Solve common issues and technical problems</div>
        </div>
    </div>

    <!-- Video Tutorials -->
    <div class="video-section">
        <h3><i class="fas fa-play-circle me-2"></i>Video Tutorials</h3>
        <p class="text-muted">Watch step-by-step guides to learn key features</p>
        
        <div class="video-grid">
            <div class="video-card" onclick="playVideo('admin-overview')">
                <div class="video-thumbnail">
                    <i class="fas fa-play"></i>
                    <div class="video-play-btn">
                        <i class="fas fa-play"></i>
                    </div>
                </div>
                <div class="video-info">
                    <div class="video-title">Admin Dashboard Overview</div>
                    <div class="video-description">Get familiar with the admin dashboard layout and navigation</div>
                </div>
            </div>

            <div class="video-card" onclick="playVideo('user-creation')">
                <div class="video-thumbnail">
                    <i class="fas fa-user-plus"></i>
                    <div class="video-play-btn">
                        <i class="fas fa-play"></i>
                    </div>
                </div>
                <div class="video-info">
                    <div class="video-title">Creating and Managing Users</div>
                    <div class="video-description">Learn how to add new users and manage their permissions</div>
                </div>
            </div>

            <div class="video-card" onclick="playVideo('course-setup')">
                <div class="video-thumbnail">
                    <i class="fas fa-book"></i>
                    <div class="video-play-btn">
                        <i class="fas fa-play"></i>
                    </div>
                </div>
                <div class="video-info">
                    <div class="video-title">Course Setup and Configuration</div>
                    <div class="video-description">Step-by-step guide to creating and configuring courses</div>
                </div>
            </div>

            <div class="video-card" onclick="playVideo('system-backup')">
                <div class="video-thumbnail">
                    <i class="fas fa-database"></i>
                    <div class="video-play-btn">
                        <i class="fas fa-play"></i>
                    </div>
                </div>
                <div class="video-info">
                    <div class="video-title">System Backup and Maintenance</div>
                    <div class="video-description">Important procedures for system backup and maintenance</div>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="faq-section">
        <div class="faq-header">
            <h3><i class="fas fa-question-circle me-2"></i>Frequently Asked Questions</h3>
            <p class="mb-0 text-muted">Quick answers to common questions</p>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question" onclick="toggleFAQ(this)">
                How do I reset a user's password?
                <i class="fas fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
                To reset a user's password: <br>1) Go to User Management, <br>2) Find the user in the list, <br>3) Click the "Actions" dropdown, <br>4) Select "Reset Password", <br>5) The user will receive an email with a temporary password that they must change on first login.
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question" onclick="toggleFAQ(this)">
                How can I create a new course?
                <i class="fas fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
                To create a new course: <br>1) Navigate to Course Management, <br>2) Click "Add New Course", <br>3) Fill in the course details (name, description, credits), <br>4) Set the enrollment dates and capacity, <br>5) Assign instructors, <br>6) Configure course settings, <br>7) Save and publish the course.
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question" onclick="toggleFAQ(this)">
                How do I generate enrollment reports?
                <i class="fas fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
                To generate enrollment reports: <br>1) Go to Reports & Analytics, <br>2) Select "Enrollment Reports", <br>3) Choose the date range and courses, <br>4) Select report format (PDF, Excel, CSV), <br>5) Click "Generate Report". The report will be downloaded to your computer or emailed to you.
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question" onclick="toggleFAQ(this)">
                What should I do if the system is running slowly?
                <i class="fas fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
                If the system is slow: <br>1) Check the server status in System Monitoring, <br>2) Review recent user activity logs, <br>3) Clear browser cache and cookies, <br>4) Check for any scheduled maintenance, <br>5) If issues persist, contact technical support with specific details about the slowness.
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question" onclick="toggleFAQ(this)">
                How do I backup the system data?
                <i class="fas fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
                System backups are automated daily at 2:00 AM. To manually create a backup: <br>1) Go to System Settings > Backup, <br>2) Click "Create Manual Backup", <br>3) Select what to include (database, files, configurations), <br>4) Choose backup location, <br>5) Click "Start Backup". Monitor progress in the notifications panel.
            </div>
        </div>

        <div class="faq-item">
            <button type="button" class="faq-question" onclick="toggleFAQ(this)">
                How can I manage user permissions and roles?
                <i class="fas fa-chevron-down faq-icon"></i>
            </button>
            <div class="faq-answer">
                To manage permissions: <br>1) Navigate to User Management > Roles & Permissions, <br>2) Select the role to modify or create a new one, <br>3) Check/uncheck permissions for different modules, <br>4) Set access levels (View, Edit, Delete, Admin), <br>5) Save changes. Users with that role will automatically get updated permissions.
            </div>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="quick-links">
        <h3><i class="fas fa-link me-2"></i>Quick Links</h3>
        <div class="quick-links-grid">
            <a href="User.aspx" class="quick-link">
                <i class="fas fa-users"></i>
                User Management
            </a>
            <a href="Course.aspx" class="quick-link">
                <i class="fas fa-graduation-cap"></i>
                Course Management
            </a>
            <a href="Profile.aspx" class="quick-link">
                <i class="fas fa-user-cog"></i>
                Profile Settings
            </a>
            <a href="Notifications.aspx" class="quick-link">
                <i class="fas fa-bell"></i>
                Notifications
            </a>
            <a href="#" class="quick-link" onclick="showSystemStatus()">
                <i class="fas fa-server"></i>
                System Status
            </a>
            <a href="#" class="quick-link" onclick="showBackupSettings()">
                <i class="fas fa-database"></i>
                Backup Settings
            </a>
        </div>
    </div>

    <!-- Contact Support -->
    <div class="contact-section">
        <div class="contact-card">
            <div class="contact-icon email">
                <i class="fas fa-envelope"></i>
            </div>
            <h5>Email Support</h5>
            <p class="text-muted">Get help via email within 24 hours</p>
            <a href="mailto:support@university.edu" class="btn-primary-custom">Send Email</a>
        </div>

        <div class="contact-card">
            <div class="contact-icon phone">
                <i class="fas fa-phone"></i>
            </div>
            <h5>Phone Support</h5>
            <p class="text-muted">Call for immediate assistance</p>
            <a href="tel:+1-555-123-4567" class="btn-primary-custom">Call Now</a>
        </div>

        <div class="contact-card">
            <div class="contact-icon chat">
                <i class="fas fa-video"></i>
            </div>
            <h5>Live Video Support</h5>
            <p class="text-muted">Connect via Zoom for face-to-face help</p>
            <button type="button" class="btn-primary-custom" onclick="startLiveChat()">Start Video Call</button>
        </div>

        <div class="contact-card">
            <div class="contact-icon ticket">
                <i class="fas fa-ticket-alt"></i>
            </div>
            <h5>Submit Ticket</h5>
            <p class="text-muted">Create a detailed support request</p>
            <button type="button" class="btn-primary-custom" onclick="createSupportTicket()">Create Ticket</button>
        </div>
    </div>

    <!-- Meeting History Section -->
    <div class="help-history-category">
        <h3><i class="fas fa-history me-2"></i>Meeting History</h3>
        <div class="help-content">
            <div class="row">
                <div class="col-md-12">
                    <div id="meetingHistoryContainer">
                        <div class="text-center py-3">
                            <div class="spinner-border text-primary" role="status" id="historyLoader">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2 text-muted">Loading meeting history...</p>
                        </div>
                    </div>
                    
                    <div class="text-center mt-3">
                        <button type="button" class="btn btn-outline-primary" onclick="refreshMeetingHistory()">
                            <i class="fas fa-sync-alt me-2"></i>Refresh History
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Active Meeting Modal -->
    <div class="modal fade" id="activeMeetingModal" tabindex="-1" aria-labelledby="activeMeetingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="activeMeetingModalLabel">
                        <i class="fas fa-video me-2"></i>Support Session Active
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="meetingDetails">
                        <!-- Meeting details will be populated here -->
                    </div>
                    <div id="zoomMeetingContainer" style="height: 400px; display: none;">
                        <!-- Zoom Web SDK container -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-danger" onclick="endMeeting()">
                        <i class="fas fa-phone-slash me-2"></i>End Meeting
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Zoom App Download Modal -->
    <div class="modal fade" id="zoomAppModal" tabindex="-1" aria-labelledby="zoomAppModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="zoomAppModalLabel">
                        <i class="fab fa-zoom me-2"></i>Zoom App Required
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fab fa-zoom fa-4x text-info mb-3"></i>
                    <h5>Download Zoom App</h5>
                    <p class="text-muted">For the best experience, please download the Zoom desktop application.</p>
                    <div class="d-grid gap-2">
                        <a href="https://zoom.us/download" target="_blank" class="btn btn-primary">
                            <i class="fas fa-download me-2"></i>Download Zoom
                        </a>
                        <button type="button" class="btn btn-outline-secondary" onclick="joinInBrowser()">
                            <i class="fas fa-globe me-2"></i>Continue in Browser
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Global variables for Zoom integration
        let currentMeetingData = null;
        let zoomClient = null;

        // Load meeting history on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadMeetingHistory();
        });

        // Load meeting history
        function loadMeetingHistory() {
            $('#historyLoader').show();
            
            $.ajax({
                type: "POST",
                url: "Help.aspx/GetZoomMeetingHistory",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    try {
                        if (response.d) {
                            const meetings = JSON.parse(response.d);
                            displayMeetingHistory(meetings);
                        } else {
                            // If no data returned, show demo data
                            console.warn('No meeting history data returned, showing demo data');
                            displayDemoMeetingHistory();
                        }
                    } catch (error) {
                        console.error('Error parsing meeting history:', error);
                        displayDemoMeetingHistory();
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading meeting history:', status, error);
                    console.error('Response:', xhr.responseText);
                    
                    // Show demo data as fallback
                    displayDemoMeetingHistory();
                },
                complete: function() {
                    $('#historyLoader').hide();
                }
            });
        }

        // Display demo meeting history when server is unavailable
        function displayDemoMeetingHistory() {
            const demoMeetings = [
                {
                    MeetingId: '123456789012',
                    SupportType: 'technical',
                    CreatedDate: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(), // 2 hours ago
                    Status: 'Completed',
                    Duration: '45'
                },
                {
                    MeetingId: '234567890123',
                    SupportType: 'general',
                    CreatedDate: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(), // 1 day ago
                    Status: 'Completed',
                    Duration: '30'
                },
                {
                    MeetingId: '345678901234',
                    SupportType: 'training',
                    CreatedDate: new Date(Date.now() - 15 * 60 * 1000).toISOString(), // 15 minutes ago
                    Status: 'In Progress',
                    Duration: null
                },
                {
                    MeetingId: '456789012345',
                    SupportType: 'emergency',
                    CreatedDate: new Date(Date.now() + 60 * 60 * 1000).toISOString(), // 1 hour from now
                    Status: 'Scheduled',
                    Duration: null
                }
            ];

            const container = $('#meetingHistoryContainer');
            
            // Add demo mode indicator
            let html = '<div class="alert alert-info mb-3">';
            html += '<i class="fas fa-info-circle me-2"></i>';
            html += '<strong>Demo Mode:</strong> Showing sample meeting history. In production, this would display your actual Zoom meeting history.';
            html += '</div>';
            
            html += '<div class="meeting-history-list">';
            
            demoMeetings.forEach(meeting => {
                const statusColors = {
                    'Completed': 'success',
                    'In Progress': 'warning',
                    'Scheduled': 'info',
                    'Cancelled': 'danger',
                    'Created': 'secondary'
                };

                const statusColor = statusColors[meeting.Status] || 'secondary';
                const formattedDate = formatDate(meeting.CreatedDate);
                const duration = meeting.Duration ? `${meeting.Duration} min` : 'N/A';
                
                html += `
                    <div class="meeting-item border-bottom py-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${meeting.SupportType.charAt(0).toUpperCase() + meeting.SupportType.slice(1)} Support</h6>
                                <small class="text-muted">
                                    <i class="fas fa-calendar me-1"></i>${formattedDate}
                                    <span class="mx-2">•</span>
                                    <i class="fas fa-clock me-1"></i>${duration}
                                </small>
                                <div class="mt-1">
                                    <span class="badge bg-${statusColor} me-2">${meeting.Status}</span>
                                    <span class="badge bg-light text-dark">${meeting.SupportType}</span>
                                    <span class="badge bg-secondary ms-1">Demo</span>
                                </div>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">ID: ${meeting.MeetingId}</small>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            html += '</div>';
            
            // Add refresh button hint
            html += '<div class="text-center mt-3">';
            html += '<small class="text-muted">';
            html += '<i class="fas fa-lightbulb me-1"></i>';
            html += 'Tip: Once the database is set up, refresh to see actual meeting history';
            html += '</small>';
            html += '</div>';
            
            container.html(html);
        }

        // Display meeting history
        function displayMeetingHistory(meetings) {
            const container = $('#meetingHistoryContainer');
            
            if (!meetings || meetings.length === 0) {
                container.html(`
                    <div class="text-center text-muted py-4">
                        <i class="fas fa-calendar-times fa-2x mb-2"></i>
                        <p>No meeting history found</p>
                        <small>Your Zoom support sessions will appear here</small>
                    </div>
                `);
                return;
            }

            let html = '<div class="meeting-history-list">';
            
            meetings.forEach(meeting => {
                const statusColors = {
                    'Completed': 'success',
                    'In Progress': 'warning',
                    'Scheduled': 'info',
                    'Cancelled': 'danger',
                    'Created': 'secondary'
                };

                // Safely access meeting properties
                const supportType = meeting.SupportType || 'general';
                const status = meeting.Status || 'Unknown';
                const meetingId = meeting.MeetingId || 'N/A';
                const createdDate = meeting.CreatedDate || new Date().toISOString();
                const duration = meeting.Duration ? `${meeting.Duration} min` : 'N/A';

                const statusColor = statusColors[status] || 'secondary';
                const formattedDate = formatDate(createdDate);
                
                html += `
                    <div class="meeting-item border-bottom py-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1">${supportType.charAt(0).toUpperCase() + supportType.slice(1)} Support</h6>
                                <small class="text-muted">
                                    <i class="fas fa-calendar me-1"></i>${formattedDate}
                                    <span class="mx-2">•</span>
                                    <i class="fas fa-clock me-1"></i>${duration}
                                </small>
                                <div class="mt-1">
                                    <span class="badge bg-${statusColor} me-2">${status}</span>
                                    <span class="badge bg-light text-dark">${supportType}</span>
                                </div>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">ID: ${meetingId}</small>
                            </div>
                        </div>
                    </div>
                `;
            });
            
            html += '</div>';
            
            // Add success indicator for real data
            html += '<div class="text-center mt-3">';
            html += '<small class="text-success">';
            html += '<i class="fas fa-check-circle me-1"></i>';
            html += `Loaded ${meetings.length} meeting${meetings.length !== 1 ? 's' : ''} from database`;
            html += '</small>';
            html += '</div>';
            
            container.html(html);
        }

        // Refresh meeting history
        function refreshMeetingHistory() {
            // Show loading animation
            $('#meetingHistoryContainer').html(`
                <div class="text-center py-3">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2 text-muted">Refreshing meeting history...</p>
                </div>
            `);
            
            // Reload the meeting history
            loadMeetingHistory();
            
            // Show success message
            setTimeout(() => {
                showToast('Meeting history refreshed', 'success');
            }, 500);
        }

        // Format date helper
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        }

        // End meeting function
        function endMeeting() {
            if (zoomClient) {
                zoomClient.leave();
                zoomClient = null;
            }
            $('#activeMeetingModal').modal('hide');
            showToast('Meeting ended successfully', 'success');
            refreshMeetingHistory();
        }

        // Join in browser function
        function joinInBrowser() {
            $('#zoomAppModal').modal('hide');
            if (currentMeetingData) {
                initializeZoomWebSDK(currentMeetingData);
            }
        }
        // Search functionality
        document.getElementById('helpSearch-help').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            // In a real implementation, this would search through help articles
            if (searchTerm.length > 2) {
                console.log('Searching for:', searchTerm);
                // Show search results
            }
        });

        // Category navigation
        function showCategory(categoryId) {
            Swal.fire({
                title: 'Category: ' + categoryId.replace('-', ' ').toUpperCase(),
                html: `
                    <div class="text-start">
                        <h6>Available Topics:</h6>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-chevron-right text-primary me-2"></i>Getting started guide</li>
                            <li><i class="fas fa-chevron-right text-primary me-2"></i>Step-by-step tutorials</li>
                            <li><i class="fas fa-chevron-right text-primary me-2"></i>Best practices</li>
                            <li><i class="fas fa-chevron-right text-primary me-2"></i>Common issues</li>
                            <li><i class="fas fa-chevron-right text-primary me-2"></i>Advanced features</li>
                        </ul>
                        <p class="text-muted">Select a topic above to view detailed information and tutorials.</p>
                    </div>
                `,
                width: 600,
                confirmButtonColor: '#2c2b7c',
                confirmButtonText: 'Browse Topics'
            });
        }

        // Video player
        function playVideo(videoId) {
            Swal.fire({
                title: 'Video Tutorial',
                html: `
                    <div class="text-center">
                        <div style="background: linear-gradient(135deg, #3498db, #2c2b7c); height: 300px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem; margin-bottom: 1rem;">
                            <i class="fas fa-play"></i>
                        </div>
                        <p>Video: ${videoId.replace('-', ' ')}</p>
                        <p class="text-muted">This is a placeholder for the video player. In a real implementation, this would show the actual video content.</p>
                    </div>
                `,
                width: 700,
                confirmButtonColor: '#2c2b7c',
                confirmButtonText: 'Close'
            });
        }

        // FAQ toggle
        function toggleFAQ(element) {
            const answer = element.nextElementSibling;
            const icon = element.querySelector('.faq-icon');
            
            // Close all other FAQ items
            document.querySelectorAll('.faq-question').forEach(q => {
                if (q !== element) {
                    q.classList.remove('active');
                    q.nextElementSibling.classList.remove('show');
                }
            });
            
            // Toggle current FAQ item
            element.classList.toggle('active');
            answer.classList.toggle('show');
        }

        // Support functions
        function startLiveChat() {
            Swal.fire({
                title: 'Live Video Support',
                html: `
                    <div class="text-start">
                        <div class="mb-3 text-center">
                            <i class="fas fa-video fa-3x text-primary mb-3"></i>
                        </div>
                        <p><strong>Video Support Hours:</strong></p>
                        <ul>
                            <li>Monday - Friday: 8:00 AM - 6:00 PM EST</li>
                            <li>Saturday: 10:00 AM - 4:00 PM EST</li>
                            <li>Sunday: Closed</li>
                        </ul>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Video Support via Zoom</strong><br>
                            Connect with our support team for screen sharing and live assistance
                        </div>
                        <p>Current status: <span class="badge bg-success">Support Available</span></p>
                        <p>Average connection time: <strong>30 seconds</strong></p>
                        <div class="form-group mt-3">
                            <label>Select support type:</label>
                            <select class="form-control" id="supportType">
                                <option value="general">General Support</option>
                                <option value="technical">Technical Issue</option>
                                <option value="training">System Training</option>
                                <option value="emergency">Emergency Support</option>
                            </select>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#95a5a6',
                confirmButtonText: '<i class="fas fa-video me-2"></i>Start Video Call',
                cancelButtonText: 'Cancel',
                width: 500
            }).then((result) => {
                if (result.isConfirmed) {
                    const supportType = document.getElementById('supportType').value;
                    initiateZoomCall(supportType);
                }
            });
        }

        async function initiateZoomCall(supportType) {
            try {
                // Show loading dialog
                Swal.fire({
                    title: 'Connecting to Support...',
                    html: `
                        <div class="text-center">
                            <div class="spinner-border text-primary mb-3" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p>Setting up your Zoom meeting...</p>
                            <p class="text-muted">Support Type: <strong>${supportType}</strong></p>
                        </div>
                    `,
                    allowOutsideClick: false,
                    showConfirmButton: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Get Zoom meeting details from server using jQuery
                $.ajax({
                    type: "POST",
                    url: "Help.aspx/CreateZoomMeeting",
                    data: JSON.stringify({
                        supportType: supportType,
                        userInfo: {
                            name: 'Admin User',
                            email: 'admin@university.edu'
                        }
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        try {
                            if (response.d) {
                                const result = JSON.parse(response.d);
                                
                                if (result.success) {
                                    const meetingData = JSON.parse(result.meetingData);
                                    
                                    // Close loading dialog
                                    Swal.close();
                                    
                                    // Show meeting join dialog
                                    Swal.fire({
                                        title: 'Zoom Meeting Ready',
                                        html: `
                                            <div class="text-center">
                                                <i class="fas fa-video fa-3x text-success mb-3"></i>
                                                <h5>Meeting ID: ${meetingData.meetingId}</h5>
                                                <p><strong>Support Agent:</strong> ${meetingData.hostName}</p>
                                                <p><strong>Meeting Topic:</strong> ${meetingData.topic}</p>
                                                <div class="alert alert-warning">
                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                    You will be redirected to Zoom. Please ensure you have Zoom installed.
                                                </div>
                                                <div id="zoomMeetingContainer" style="width: 100%; height: 400px; display: none;"></div>
                                            </div>
                                        `,
                                        showCancelButton: true,
                                        confirmButtonColor: '#2c2b7c',
                                        cancelButtonColor: '#95a5a6',
                                        confirmButtonText: '<i class="fas fa-external-link-alt me-2"></i>Join in Zoom App',
                                        cancelButtonText: 'Join in Browser',
                                        width: 600
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            // Join via Zoom app
                                            const zoomAppUrl = `zoommtg://zoom.us/join?confno=${meetingData.meetingId}&pwd=${meetingData.password}`;
                                            window.location.href = zoomAppUrl;
                                            
                                            // Fallback to web join URL
                                            setTimeout(() => {
                                                window.open(meetingData.joinUrl, '_blank');
                                            }, 2000);
                                        } else if (result.dismiss === Swal.DismissReason.cancel) {
                                            // Join in browser using Zoom Web SDK
                                            joinZoomInBrowser(meetingData);
                                        }
                                    });
                                } else {
                                    throw new Error(result.error || 'Failed to create meeting');
                                }
                            } else {
                                throw new Error('Invalid response from server');
                            }
                        } catch (parseError) {
                            console.error('Error parsing response:', parseError);
                            throw new Error('Server returned invalid data');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX Error:', status, error);
                        console.error('Response:', xhr.responseText);
                        
                        let errorMessage = 'Connection failed';
                        let showDemo = false;
                        
                        if (xhr.status === 500) {
                            if (xhr.responseText.includes('CreateZoomMeeting')) {
                                errorMessage = 'Zoom WebMethod error - check server configuration';
                            } else if (xhr.responseText.includes('ZoomMeetings')) {
                                errorMessage = 'Database table missing - run ZoomMeetings_Table.sql script';
                            } else {
                                errorMessage = 'Server error - check compilation and WebMethod implementation';
                            }
                            showDemo = true;
                        } else if (xhr.status === 404) {
                            errorMessage = 'WebMethod not found - ensure Help.aspx.cs contains CreateZoomMeeting method';
                            showDemo = true;
                        } else if (xhr.responseText.includes('<!DOCTYPE')) {
                            errorMessage = 'Server compilation error - check for syntax errors in Help.aspx.cs';
                            showDemo = true;
                        } else if (xhr.status === 0) {
                            errorMessage = 'Network connection failed';
                            showDemo = true;
                        }
                        
                        // Close loading dialog first
                        Swal.close();
                        
                        // Show error with option to try demo mode
                        Swal.fire({
                            title: 'Connection Error',
                            html: `
                                <div class="text-center">
                                    <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                                    <p>Unable to start video call at this time.</p>
                                    <p class="text-muted"><strong>Error:</strong> ${errorMessage}</p>
                                    <div class="alert alert-info mt-3">
                                        <strong>Alternative Options:</strong><br>
                                        • Try again in a few moments<br>
                                        • Use phone support: +1-555-123-4567<br>
                                        • Submit a support ticket<br>
                                        • Send email: support@university.edu
                                        ${showDemo ? '<br>• View demo interface' : ''}
                                    </div>
                                    ${showDemo ? `
                                        <div class="alert alert-primary">
                                            <i class="fas fa-lightbulb me-2"></i>
                                            <strong>Demo Mode Available:</strong> See how the Zoom integration would work
                                        </div>
                                    ` : ''}
                                </div>
                            `,
                            icon: 'error',
                            confirmButtonColor: '#e74c3c',
                            confirmButtonText: 'Try Again',
                            showCancelButton: showDemo,
                            cancelButtonColor: '#3498db',
                            cancelButtonText: showDemo ? 'View Demo' : 'Close'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                startLiveChat();
                            } else if (result.dismiss === Swal.DismissReason.cancel && showDemo) {
                                showDemoZoomInterface(supportType);
                            }
                        });
                    }
                });

            } catch (error) {
                console.error('Zoom integration error:', error);
                Swal.fire({
                    title: 'Connection Error',
                    html: `
                        <div class="text-center">
                            <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                            <p>Unable to start video call at this time.</p>
                            <p class="text-muted">Error: ${error.message}</p>
                            <div class="alert alert-info mt-3">
                                <strong>Alternative Options:</strong><br>
                                • Try again in a few moments<br>
                                • Use phone support: +1-555-123-4567<br>
                                • Submit a support ticket<br>
                                • Send email: support@university.edu
                            </div>
                        </div>
                    `,
                    icon: 'error',
                    confirmButtonColor: '#e74c3c',
                    confirmButtonText: 'Try Again',
                    showCancelButton: true,
                    cancelButtonText: 'Use Alternative'
                }).then((result) => {
                    if (result.isConfirmed) {
                        startLiveChat();
                    } else {
                        // Show demo mode as fallback
                        showDemoZoomInterface(supportType);
                    }
                });
            }
        }

        // Demo mode for when server is unavailable
        function showDemoZoomInterface(supportType) {
            const demoMeetingData = {
                meetingId: '123-456-789-012',
                password: 'demo123',
                topic: `${supportType.charAt(0).toUpperCase() + supportType.slice(1)} Support Session - Demo Mode`,
                hostName: 'Demo Support Agent',
                joinUrl: 'https://zoom.us/j/123456789012?pwd=demo123',
                created: new Date().toISOString()
            };

            Swal.fire({
                title: 'Demo Mode - Zoom Meeting Ready',
                html: `
                    <div class="text-center">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Demo Mode Active</strong><br>
                            This is a demonstration of the Zoom integration interface.
                        </div>
                        <i class="fas fa-video fa-3x text-success mb-3"></i>
                        <h5>Meeting ID: ${demoMeetingData.meetingId}</h5>
                        <p><strong>Support Agent:</strong> ${demoMeetingData.hostName}</p>
                        <p><strong>Meeting Topic:</strong> ${demoMeetingData.topic}</p>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            In production, this would connect to a real Zoom meeting.
                        </div>
                        <div class="progress mt-3 mb-3">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 100%">
                                Demo Meeting Ready
                            </div>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#95a5a6',
                confirmButtonText: '<i class="fas fa-external-link-alt me-2"></i>Demo: Join in Zoom App',
                cancelButtonText: 'Demo: Join in Browser',
                width: 600
            }).then((result) => {
                if (result.isConfirmed) {
                    // Demo Zoom app join
                    Swal.fire({
                        title: 'Demo: Zoom App',
                        html: `
                            <div class="text-center">
                                <i class="fab fa-zoom fa-4x text-primary mb-3"></i>
                                <h5>Redirecting to Zoom App</h5>
                                <p>In production, this would open the Zoom desktop application.</p>
                                <div class="alert alert-success mt-3">
                                    <strong>Meeting Details:</strong><br>
                                    Meeting ID: ${demoMeetingData.meetingId}<br>
                                    Password: ${demoMeetingData.password}
                                </div>
                            </div>
                        `,
                        icon: 'success',
                        confirmButtonText: 'Close Demo'
                    });
                } else if (result.dismiss === Swal.DismissReason.cancel) {
                    // Demo browser join
                    showDemoBrowserZoom(demoMeetingData);
                }
            });
        }

        function showDemoBrowserZoom(meetingData) {
            Swal.fire({
                title: 'Demo: Browser Zoom Interface',
                html: `
                    <div class="text-center">
                        <div class="alert alert-info mb-3">
                            <strong>Demo Mode:</strong> Browser-based Zoom interface simulation
                        </div>
                        <div id="demoBrowserZoom" style="width: 100%; height: 400px; border: 2px solid #007bff; border-radius: 8px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white;">
                            <div class="text-center">
                                <i class="fas fa-video fa-4x mb-3"></i>
                                <h4>Zoom Meeting Simulation</h4>
                                <p>Meeting ID: ${meetingData.meetingId}</p>
                                <p>Host: ${meetingData.hostName}</p>
                                <div class="zoom-controls mt-3">
                                    <button class="btn btn-light me-2" onclick="toggleDemoMute()">
                                        <i class="fas fa-microphone" id="muteIcon"></i>
                                    </button>
                                    <button class="btn btn-light me-2" onclick="toggleDemoVideo()">
                                        <i class="fas fa-video" id="videoIcon"></i>
                                    </button>
                                    <button class="btn btn-danger" onclick="endDemoMeeting()">
                                        <i class="fas fa-phone-slash"></i>
                                    </button>
                                </div>
                                <div class="mt-3">
                                    <small class="text-light">Demo meeting - no actual connection</small>
                                </div>
                            </div>
                        </div>
                    </div>
                `,
                width: 600,
                showConfirmButton: false,
                showCancelButton: true,
                cancelButtonText: 'End Demo',
                allowOutsideClick: false
            });
        }

        // Demo control functions
        function toggleDemoMute() {
            const muteIcon = document.getElementById('muteIcon');
            if (muteIcon.classList.contains('fa-microphone')) {
                muteIcon.classList.remove('fa-microphone');
                muteIcon.classList.add('fa-microphone-slash');
                showToast('Microphone muted (Demo)', 'info');
            } else {
                muteIcon.classList.remove('fa-microphone-slash');
                muteIcon.classList.add('fa-microphone');
                showToast('Microphone unmuted (Demo)', 'info');
            }
        }

        function toggleDemoVideo() {
            const videoIcon = document.getElementById('videoIcon');
            if (videoIcon.classList.contains('fa-video')) {
                videoIcon.classList.remove('fa-video');
                videoIcon.classList.add('fa-video-slash');
                showToast('Video turned off (Demo)', 'info');
            } else {
                videoIcon.classList.remove('fa-video-slash');
                videoIcon.classList.add('fa-video');
                showToast('Video turned on (Demo)', 'info');
            }
        }

        function endDemoMeeting() {
            Swal.close();
            showToast('Demo meeting ended', 'success');
        }

        // Test meeting history function for debugging
        function testMeetingHistory() {
            console.log('Testing meeting history functionality...');
            
            // Test with sample data
            const testMeetings = [
                {
                    MeetingId: 'TEST123456',
                    SupportType: 'technical',
                    CreatedDate: new Date().toISOString(),
                    Status: 'Completed',
                    Duration: '25'
                }
            ];
            
            displayMeetingHistory(testMeetings);
            console.log('Test meeting history displayed successfully');
        }

        // Debug function to check server connectivity
        function debugServerConnection() {
            console.log('Testing server connection...');
            
            $.ajax({
                type: "POST",
                url: "Help.aspx/GetZoomMeetingHistory",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    console.log('Server response received:', response);
                    showToast('Server connection successful', 'success');
                },
                error: function(xhr, status, error) {
                    console.error('Server connection failed:', status, error);
                    console.error('Response text:', xhr.responseText);
                    showToast(`Server connection failed: ${status}`, 'error');
                }
            });
        }

        // Toast notification function
        function showToast(message, type = 'info') {
            const iconMap = {
                'success': 'fas fa-check-circle',
                'error': 'fas fa-exclamation-circle',
                'warning': 'fas fa-exclamation-triangle',
                'info': 'fas fa-info-circle'
            };

            const colorMap = {
                'success': '#28a745',
                'error': '#dc3545',
                'warning': '#ffc107',
                'info': '#17a2b8'
            };

            const toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                didOpen: (toast) => {
                    toast.addEventListener('mouseenter', Swal.stopTimer)
                    toast.addEventListener('mouseleave', Swal.resumeTimer)
                }
            });

            toast.fire({
                icon: type,
                title: message,
                background: colorMap[type] || '#17a2b8',
                color: 'white'
            });
        }

        function joinZoomInBrowser(meetingData) {
            Swal.fire({
                title: 'Loading Zoom Meeting...',
                html: `
                    <div id="zoomWebContainer" style="width: 100%; height: 500px; border: 1px solid #ddd; border-radius: 8px;">
                        <div class="text-center p-5">
                            <div class="spinner-border text-primary mb-3" role="status"></div>
                            <p>Initializing Zoom Web Client...</p>
                        </div>
                    </div>
                `,
                width: 800,
                showConfirmButton: false,
                allowOutsideClick: false,
                didOpen: () => {
                    initializeZoomWebSDK(meetingData);
                }
            });
        }

        function initializeZoomWebSDK(meetingData) {
            try {
                // Initialize Zoom Web SDK
                ZoomMtg.setZoomJSLib('https://source.zoom.us/2.18.0/lib', '/av');
                ZoomMtg.preLoadWasm();
                ZoomMtg.prepareWebSDK();

                ZoomMtg.init({
                    leaveUrl: window.location.origin + '/authUser/Admin/Help.aspx',
                    success: () => {
                        console.log('Zoom Web SDK initialized successfully');
                        
                        ZoomMtg.join({
                            signature: meetingData.signature,
                            meetingNumber: meetingData.meetingId,
                            userName: 'Admin User',
                            apiKey: meetingData.apiKey,
                            userEmail: 'admin@university.edu',
                            passWord: meetingData.password,
                            success: (success) => {
                                console.log('Joined Zoom meeting successfully', success);
                                document.getElementById('zoomWebContainer').innerHTML = '<p class="text-success">Connected to Zoom meeting!</p>';
                            },
                            error: (error) => {
                                console.error('Error joining Zoom meeting', error);
                                document.getElementById('zoomWebContainer').innerHTML = `
                                    <div class="text-center p-3">
                                        <i class="fas fa-exclamation-triangle text-warning fa-2x mb-2"></i>
                                        <p class="text-danger">Failed to join meeting in browser</p>
                                        <button class="btn btn-primary" onclick="window.open('${meetingData.joinUrl}', '_blank')">
                                            <i class="fas fa-external-link-alt me-2"></i>Open in Zoom App
                                        </button>
                                    </div>
                                `;
                            }
                        });
                    },
                    error: (error) => {
                        console.error('Zoom Web SDK initialization failed', error);
                        document.getElementById('zoomWebContainer').innerHTML = `
                            <div class="text-center p-3">
                                <i class="fas fa-times-circle text-danger fa-2x mb-2"></i>
                                <p>Web client initialization failed</p>
                                <button class="btn btn-primary" onclick="window.open('${meetingData.joinUrl}', '_blank')">
                                    <i class="fas fa-external-link-alt me-2"></i>Join via Zoom App
                                </button>
                            </div>
                        `;
                    }
                });
            } catch (error) {
                console.error('Zoom SDK Error:', error);
                document.getElementById('zoomWebContainer').innerHTML = `
                    <div class="text-center p-3">
                        <i class="fas fa-exclamation-triangle text-warning fa-2x mb-2"></i>
                        <p>Zoom Web SDK not available</p>
                        <button class="btn btn-primary" onclick="window.open('${meetingData.joinUrl}', '_blank')">
                            <i class="fas fa-external-link-alt me-2"></i>Join via Zoom App
                        </button>
                    </div>
                `;
            }
        }

        function createSupportTicket() {
            Swal.fire({
                title: 'Create Support Ticket',
                html: `
                    <div class="text-start">
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <select class="form-control" id="ticketCategory">
                                <option>Technical Issue</option>
                                <option>Feature Request</option>
                                <option>Bug Report</option>
                                <option>Account Issue</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Priority</label>
                            <select class="form-control" id="ticketPriority">
                                <option>Low</option>
                                <option>Medium</option>
                                <option>High</option>
                                <option>Critical</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Subject</label>
                            <input type="text" class="form-control" id="ticketSubject" placeholder="Brief description of the issue">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" id="ticketDescription" rows="4" placeholder="Detailed description of the issue or request"></textarea>
                        </div>
                    </div>
                `,
                width: 600,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#95a5a6',
                confirmButtonText: 'Submit Ticket',
                cancelButtonText: 'Cancel',
                preConfirm: () => {
                    const category = document.getElementById('ticketCategory').value;
                    const priority = document.getElementById('ticketPriority').value;
                    const subject = document.getElementById('ticketSubject').value;
                    const description = document.getElementById('ticketDescription').value;
                    
                    if (!subject || !description) {
                        Swal.showValidationMessage('Please fill in all required fields');
                        return false;
                    }
                    
                    return { category, priority, subject, description };
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Ticket Created!',
                        html: `
                            <p>Your support ticket has been created successfully.</p>
                            <p><strong>Ticket ID:</strong> #${Math.floor(Math.random() * 10000)}</p>
                            <p>You will receive an email confirmation shortly.</p>
                        `,
                        icon: 'success',
                        confirmButtonColor: '#27ae60'
                    });
                }
            });
        }

        function showSystemStatus() {
            Swal.fire({
                title: 'System Status',
                html: `
                    <div class="text-start">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span>Database Server</span>
                            <span class="badge bg-success">Online</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span>Application Server</span>
                            <span class="badge bg-success">Online</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span>File Storage</span>
                            <span class="badge bg-success">Online</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span>Email Service</span>
                            <span class="badge bg-warning">Delayed</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span>Backup Service</span>
                            <span class="badge bg-success">Online</span>
                        </div>
                        <hr>
                        <small class="text-muted">Last updated: ${new Date().toLocaleString()}</small>
                    </div>
                `,
                confirmButtonColor: '#2c2b7c'
            });
        }

        function showBackupSettings() {
            Swal.fire({
                title: 'Backup Information',
                html: `
                    <div class="text-start">
                        <p><strong>Last Backup:</strong> ${new Date(Date.now() - 24*60*60*1000).toLocaleDateString()}</p>
                        <p><strong>Next Scheduled:</strong> ${new Date(Date.now() + 60*60*1000).toLocaleString()}</p>
                        <p><strong>Backup Size:</strong> 2.4 GB</p>
                        <p><strong>Retention:</strong> 30 days</p>
                        <p><strong>Location:</strong> Cloud Storage (Encrypted)</p>
                        <hr>
                        <p class="text-muted">Backups are performed automatically every day at 2:00 AM EST.</p>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                confirmButtonText: 'Manual Backup',
                cancelButtonText: 'Close'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Manual Backup Started',
                        text: 'A manual backup has been initiated. You will be notified when it completes.',
                        icon: 'success',
                        timer: 3000,
                        showConfirmButton: false
                    });
                }
            });
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Add any initialization code here
            console.log('Help page loaded successfully');
        });
    </script>
</asp:Content>
