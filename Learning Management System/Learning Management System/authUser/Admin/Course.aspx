<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Course.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Course" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Course Management - Learning Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="../../Assest/css/bootstrap-5.2.3-dist/css/bootstrap.css">
    <script src="../../Assest/css/bootstrap-5.2.3-dist/js/bootstrap.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css">
    <link rel="stylesheet" href="../../Assest/css/style.css">
    <link rel="stylesheet" href="../../Assest/css/AdminMaster.css">
    <link rel="stylesheet" href="../../Assest/css/course.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js"></script>
    
    <!-- Additional Frontend Enhancements -->
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="../../Assest/js/ClientErrorHandler.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="../../Assest/css/bootstrap-5.2.3-dist/js/bootstrap.js"></script>
    <script src="notifications.js"></script>
    <script src="row-checkbox-management.js"></script>
    <script src="bulk-actions.js"></script>
    
    <script>
        // Global variables
        let searchTimeoutCourse; // Declared once at the top to avoid duplicate declarations

        // Ensure the loading spinner exists
        document.addEventListener('DOMContentLoaded', function() {
             let searchTimeout;
        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(filterCourses, 300);
        }
            // Check if loadingSpinner exists, if not create it
            if (!document.getElementById('loadingSpinner')) {
                const loadingSpinner = document.createElement('div');
                loadingSpinner.id = 'loadingSpinner';
                loadingSpinner.className = 'loading-spinner';
                loadingSpinner.innerHTML = `
                    <div class="spinner-wrapper">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <div class="spinner-text mt-2">Loading...</div>
                    </div>
                `;
                document.body.appendChild(loadingSpinner);
            }
        });
    </script>
    
    <style>
        /* Enhanced Course Management Styles with Dark Theme Support */
        /* Note: Most styles are now in course.css for better theme integration */
        
        /* Additional enhanced styles that complement course.css */
        .course-container {
            max-width: 1400px;
        }

        /* Enhanced stat card hover effects */
        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transition: all 0.5s ease;
            transform: scale(0);
        }
        
        .stat-card:hover::before {
            transform: scale(1.5);
        }
        
        .stat-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(102, 126, 234, 0.4);
        }

        .loading-spinner {
     position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
}

.spinner-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(5px);
}

.spinner-content {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 2rem;
}

        .spinner-wrapper {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
}

        
        .spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

.loading-progress {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 1rem;
    width: 200px;
}

.progress {
    width: 100%;
    height: 4px;
    background-color: #e9ecef;
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 0.5rem;
}

.progress-bar {
    background: linear-gradient(45deg, #007bff, #0056b3);
    transition: width 0.05s linear;
    height: 100%;
    border-radius: 10px;
}

.progress-text {
    font-size: 0.875rem;
    color: #6c757d;
    margin-top: 0.5rem;
    text-align: center;
}

.spinner-title {
    font-size: 1.25rem;
    font-weight: 600;
    color: #2c3e50;
    margin: 1rem 0 0.5rem;
}

.spinner-message {
    font-size: 0.9rem;
    color: #6c757d;
    text-align: center;
}

/* Animation for fade in/out */
.loading-spinner.show {
    display: flex;
    animation: fadeIn 0.3s ease forwards;
}

.loading-spinner.hide {
    animation: fadeOut 0.3s ease forwards;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes fadeOut {
    from { opacity: 1; }
    to { opacity: 0; }
}

        /* Enhanced Modal Styles */
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 0.375rem 0.375rem 0 0;
        }

        .modal-header .btn-close {
            filter: invert(1);
        }

        .modal-body {
            padding: 2rem;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .form-control.is-valid {
            border-color: #198754;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 8 8'%3e%3cpath fill='%23198754' d='m2.3 6.73.94-.94 4.94-4.94L6.77 0 2.8 3.97 1.06 2.23 0 3.29z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }

        .form-control.is-invalid {
            border-color: #dc3545;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 12' width='12' height='12' fill='none' stroke='%23dc3545'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath d='m5.8 4.6 2.4 2.4M8.2 4.6l-2.4 2.4'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(0.375em + 0.1875rem) center;
            background-size: calc(0.75em + 0.375rem) calc(0.75em + 0.375rem);
        }

        .invalid-feedback {
            display: block;
            font-size: 0.875rem;
            color: #dc3545;
            margin-top: 0.25rem;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        /* Completely disable all modal effects */
        .modal {
            transition: none !important;
            animation: none !important;
            opacity: 1 !important;
        }

        .modal .modal-dialog {
            transition: none !important;
            transform: none !important;
            animation: none !important;
        }

        .modal.show {
            opacity: 1 !important;
            display: block !important;
        }

        .modal:not(.show) {
            opacity: 0 !important;
            display: none !important;
        }

        /* COMPLETELY DISABLE BOOTSTRAP MODAL BACKDROP AND FADE EFFECTS */
        .modal-backdrop {
            display: none !important;
        }

        .modal-backdrop.show {
            display: none !important;
        }

        .modal-backdrop.fade {
            display: none !important;
        }

        /* Remove all fade and transition effects from modals */
        .modal {
            transition: none !important;
            animation: none !important;
            opacity: 1 !important;
            background: rgba(0, 0, 0, 0.5) !important;
        }

        .modal.fade {
            transition: none !important;
            animation: none !important;
            opacity: 1 !important;
        }

        .modal.show {
            display: block !important;
            opacity: 1 !important;
        }

        .modal .modal-dialog {
            transition: none !important;
            transform: none !important;
            animation: none !important;
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        /* Enhanced Statistics Cards */
        .course-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(135deg, #fff 0%, #f8f9fc 100%);
            border: none;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 1rem;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #007bff, #0056b3);
            border-radius: 12px 12px 0 0;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }

        .stat-icon.bg-success {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .stat-icon.bg-info {
            background: linear-gradient(135deg, #17a2b8, #117a8b);
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
        }

        .stat-icon.bg-warning {
            background: linear-gradient(135deg, #ffc107, #d39e00);
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }

        .stat-content {
            flex: 1;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.25rem;
            line-height: 1;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .stat-trend {
            font-size: 0.75rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .stat-trend.positive {
            color: #28a745;
        }

        .stat-trend.negative {
            color: #dc3545;
        }

        .stat-trend.neutral {
            color: #6c757d;
        }

        .loading-dots {
            color: #6c757d;
            font-size: 1rem;
            font-weight: normal;
        }

        /* Enhanced Search and Filter Section */
        .search-filter-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border: 1px solid #e9ecef;
        }

        /* Enhanced Table Styling */
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border: 1px solid #e9ecef;
        }

        .table thead th {
            background: linear-gradient(135deg, #f8f9fc, #e9ecef);
            border: none;
            font-weight: 600;
            color: #495057;
            padding: 1rem;
            position: relative;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .table thead th:hover {
            background: linear-gradient(135deg, #e9ecef, #dee2e6);
        }

        .table tbody tr {
            transition: all 0.2s ease;
            border: none;
        }

        .table tbody tr:hover {
            background-color: #f8f9fc;
            transform: translateX(2px);
        }

        .table tbody td {
            padding: 1rem;
            border: none;
            border-bottom: 1px solid #f1f3f4;
            vertical-align: middle;
        }

        /* Enhanced Course Table Elements */
        .course-code-badge strong {
            color: #667eea;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .course-name-cell .fw-semibold {
            color: #2d3748;
            font-size: 1rem;
            margin-bottom: 0.25rem;
        }

        .course-name-cell small {
            color: #718096;
            font-size: 0.8rem;
            line-height: 1.3;
        }

        .department-badge {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .instructor-cell {
            color: #4a5568;
            font-size: 0.9rem;
        }

        .enrollment-cell {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
        }

        .enrollment-count {
            font-weight: 600;
            color: #2d3748;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-badge.bg-success {
            background: linear-gradient(135deg, #48bb78, #38a169) !important;
            color: white;
        }

        .status-badge.bg-secondary {
            background: linear-gradient(135deg, #a0aec0, #718096) !important;
            color: white;
        }

        .status-badge.bg-warning {
            background: linear-gradient(135deg, #ed8936, #dd6b20) !important;
            color: white;
        }

        /* No Data State */
        .no-data-row td {
            padding: 3rem 1rem;
        }

        .no-data-row .fas {
            color: #cbd5e0;
        }

        .no-data-row h5 {
            color: #4a5568;
            margin-bottom: 0.5rem;
        }

        .no-data-row p {
            color: #718096;
            margin-bottom: 1.5rem;
        }

        /* Enhanced Action Buttons */
        .btn-group .btn {
            border-radius: 6px;
            margin: 0 2px;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }

        .btn-group .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #007bff;
            border-radius: 50%;
        }

        /* Enhanced Modal Styling */
        .modal-content {
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            Z-index: 1050 !important; /* Ensure modal is above other elements */
        }

        .modal-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 12px 12px 0 0;
            border-bottom: none;
            padding: 1.5rem;
        }



/* Add or update these styles in your CSS */
.loading-spinner-save {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.9);
    display: none;
    z-index: 9999;
    backdrop-filter: blur(5px);
}

.spinner-overlay-save {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}

.spinner-content-save {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    text-align: center;
}

.spinner-wrapper-save {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1rem;
}

.loading-progress-save {
    width: 300px;
    background-color: #f3f3f3;
    border-radius: 4px;
    padding: 3px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.progress-save {
    height: 6px !important;
    background-color: #f3f3f3;
    border-radius: 4px;
    overflow: hidden;
}

.progress-bar-save {
    width: 0%;
    height: 100%;
    background: linear-gradient(90deg, #007bff, #00bfff);
    border-radius: 4px;
    transition: width 0.3s ease;
    animation: none !important;
}

.progress-text-save {
    font-size: 14px;
    color: #666;
    margin-top: 8px;
}

.spinner-title-save {
    color: #333;
    font-size: 18px;
    margin-bottom: 5px;
}

.spinner-message-save {
    color: #666;
    font-size: 14px;
}

/* Remove the spinning animation */
.spinner-save {
    display: none; /* Hide the spinner since we're using a progress bar */
}

/* Add animation for the progress bar gradient */
@keyframes gradientMove {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.progress-bar-save {
    background-size: 200% 200%;
    background-image: linear-gradient(45deg, #007bff, #00bfff, #007bff);
    animation: gradientMove 2s ease infinite;
}




        .modal-title {
            font-weight: 600;
            font-size: 1.25rem;
        }

        .modal-body {
            padding: 2rem;
        }

        .modal-footer {
            border-top: 1px solid #e9ecef;
            padding: 1.5rem;
        }

        /* Form Enhancements */
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 0.75rem;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.1);
            transform: translateY(-1px);
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        /* Enhanced SweetAlert Styling */
        .swal-popup-enhanced {
            border-radius: 15px !important;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2) !important;
        }

        .swal-title-enhanced {
            font-weight: 700 !important;
            color: #2c3e50 !important;
        }

        /* Form Validation Styles */
        .form-control.is-invalid,
        .form-select.is-invalid {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.1);
        }

        .form-control.is-valid,
        .form-select.is-valid {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.1);
        }

        /* Enhanced Table Row Styling */
        .course-row {
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .course-row:hover {
            border-left-color: #007bff;
            background: linear-gradient(90deg, rgba(0, 123, 255, 0.05), transparent);
        }

        .course-code-badge {
            font-family: 'Monaco', 'Menlo', monospace;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 0.25rem 0.5rem;
            border-radius: 6px;
            display: inline-block;
            border: 1px solid #2196f3;
        }

        .department-badge {
            background: #f8f9fa;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            color: #495057;
            border: 1px solid #dee2e6;
        }

        .instructor-cell {
            display: flex;
            align-items: center;
            font-weight: 500;
        }

        .enrollment-cell {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
        }

        .enrollment-count {
            font-weight: 600;
            color: #007bff;
        }

        .action-buttons .btn {
            margin: 0 1px;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .action-buttons .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .status-badge {
            font-weight: 600;
            padding: 0.5rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Loading States */
        .loading-row td {
            background: linear-gradient(90deg, #f8f9fa, #ffffff, #f8f9fa);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { background-position: -200px 0; }
            100% { background-position: 200px 0; }
        }

        /* Global Loading Overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            backdrop-filter: blur(5px);
        }

        .loading-overlay .spinner-border {
            width: 3rem;
            height: 3rem;
            border-width: 0.25em;
        }

        .no-data-row {
            background: #f8f9fc;
        }

        /* Responsive Enhancements */
        @media (max-width: 768px) {
            .course-stats {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .stat-card {
                padding: 1rem;
            }
            
            .table-responsive {
                font-size: 0.875rem;
            }
            
            .action-buttons .btn {
                padding: 0.25rem 0.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="course-container container">
                    <div class="course-header">
                        <h1 class="course-title">
                            <i class="fa fa-graduation-cap me-3"></i>
                            Course Management
                        </h1>
                        <button type="button" class="btn btn-primary btn-primary-custom" onclick="openModal('addCourseModal')">
                            <i class="fa fa-plus me-2"></i>Add New Course
                        </button>
                    </div>

                    <!-- Course Statistics -->
                    <div class="course-stats">
                        <div class="stat-card" id="totalCoursesCard">
                            <div class="stat-icon">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalCoursesCount">
                                    <span class="loading-dots">Loading...</span>
                                </div>
                                <div class="stat-label">Total Courses</div>
                                <div class="stat-trend positive">
                                    <i class="fas fa-arrow-up"></i> +12% from last month
                                </div>
                            </div>
                        </div>
                        <div class="stat-card" id="activeCoursesCard">
                            <div class="stat-icon bg-success">
                                <i class="fas fa-play-circle"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="activeCoursesCount">
                                    <span class="loading-dots">Loading...</span>
                                </div>
                                <div class="stat-label">Active Courses</div>
                                <div class="stat-trend positive">
                                    <i class="fas fa-arrow-up"></i> +8% from last month
                                </div>
                            </div>
                        </div>
                        <div class="stat-card" id="enrollmentsCard">
                            <div class="stat-icon bg-info">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="totalEnrollmentsCount">
                                    <span class="loading-dots">Loading...</span>
                                </div>
                                <div class="stat-label">Total Enrollments</div>
                                <div class="stat-trend positive">
                                    <i class="fas fa-arrow-up"></i> +15% from last month
                                </div>
                            </div>
                        </div>
                        <div class="stat-card" id="draftCoursesCard">
                            <div class="stat-icon bg-warning">
                                <i class="fas fa-edit"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-number" id="draftCoursesCount">
                                    <span class="loading-dots">Loading...</span>
                                </div>
                                <div class="stat-label">Draft Courses</div>
                                <div class="stat-trend neutral">
                                    <i class="fas fa-minus"></i> No change
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter Section -->
                    <div class="search-filter-section">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="courseSearch" class="form-label">Search Courses</label>
                                <input type="text" id="courseSearch" class="form-control" placeholder="Enter course name or code...">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="statusFilter" class="form-label">Status</label>
                                <select id="statusFilter" class="form-select">
                                    <option value="">All Status</option>
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                    <option value="draft">Draft</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="departmentFilter" class="form-label">Department</label>
                                <select id="departmentFilter" class="form-select">
                                    <option value="">All Departments</option>
                                    <!-- Department options will be loaded dynamically -->
                                </select>
                            </div>
                            <div class="col-md-2 mb-3 d-flex align-items-end">
                                <button type="button" class="btn btn-outline-primary w-100" onclick="filterCoursesEnhanced()">
                                    <i class="fa fa-filter me-2"></i>Filter
                                </button>
                            </div>
                        </div>
                        
                        <!-- Bulk Actions and Export -->
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-outline-success" onclick="exportToExcel()">
                                        <i class="fa fa-file-excel me-2"></i>Export to Excel
                                    </button>
                                    <button type="button" class="btn btn-outline-info" onclick="exportToPDF()">
                                        <i class="fa fa-file-pdf me-2"></i>Export to PDF
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <div class="d-flex gap-2 justify-content-end">
                                    <button type="button" class="btn btn-outline-warning" onclick="bulkStatusUpdate()" id="bulkActionBtn" disabled>
                                        <i class="fa fa-edit me-2"></i>Bulk Status Update
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" onclick="bulkDelete()" id="bulkDeleteBtn" disabled>
    <i class="fa fa-trash me-2"></i>Bulk Delete
</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Course Table -->
                    <div class="table-container">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0" id="courseTable">
                                <thead>
                                    <tr>
                                        <th width="50">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                                <label class="form-check-label" for="selectAll"></label>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(1)" style="cursor: pointer;" class="sortable">
                                            <div class="d-flex align-items-center">
                                                Course Code <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(2)" style="cursor: pointer;" class="sortable">
                                            <div class="d-flex align-items-center">
                                                Course Name <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(3)" style="cursor: pointer;" class="sortable">
                                            <div class="d-flex align-items-center">
                                                Department <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(4)" style="cursor: pointer;" class="sortable text-center">
                                            <div class="d-flex align-items-center justify-content-center">
                                                Credits <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(5)" style="cursor: pointer;" class="sortable">
                                            <div class="d-flex align-items-center">
                                                Instructor <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(6)" style="cursor: pointer;" class="sortable text-center">
                                            <div class="d-flex align-items-center justify-content-center">
                                                Enrolled <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th onclick="sortTable(7)" style="cursor: pointer;" class="sortable text-center">
                                            <div class="d-flex align-items-center justify-content-center">
                                                Status <i class="fa fa-sort ms-1 text-muted"></i>
                                            </div>
                                        </th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="courseTableBody">
                                    <!-- Table data will be populated by JavaScript -->
                                    <tr class="loading-row">
                                        <td colspan="9" class="text-center py-4">
                                            <div class="d-flex justify-content-center align-items-center">
                                                <div class="spinner-border text-primary me-2" role="status">
                                                    <span class="visually-hidden">Loading...</span>
                                                </div>
                                                Loading courses...
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                                    
                        </div>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination-container">
                        <nav aria-label="Course pagination">
                            <ul class="pagination">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active">
                                    <a class="page-link" href="#">1</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="#">2</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="#">3</a>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                

        


    <script>
// Add this function to properly structure the modal form
    function initModalForm() {
            console.log('Initializing modal form...');


  // Wait for DOM to be fully loaded
    if (document.readyState !== 'complete') {
        document.addEventListener('DOMContentLoaded', initModalForm);
        return;
    }
try {
        const modal = document.getElementById('addCourseModal');
        if (!modal) {
            console.warn('Add Course modal not found, will retry later');
            return;
        }

        const modalBody = modal.querySelector('.modal-body');
        const modalFooter = modal.querySelector('.modal-footer');

        if (!modalBody || !modalFooter) {
            console.warn('Modal structure incomplete, retrying...');
            setTimeout(initModalForm, 100);
            return;
        }

        // Initialize form if needed
        let form = modal.querySelector('#addCourseForm');
        if (!form) {
            console.log('Creating form element...');
            form = document.createElement('form');
            form.id = 'addCourseForm';
            form.className = 'needs-validation';
            form.setAttribute('novalidate', '');
            
            // Wrap modal content in form
            const bodyContent = modalBody.innerHTML;
            const footerContent = modalFooter.innerHTML;
            
            modalBody.innerHTML = '';
            form.innerHTML = `
                <div class="modal-body">${bodyContent}</div>
                <div class="modal-footer">${footerContent}</div>
            `;
            
            modalBody.appendChild(form);
        }

        // Add form event listeners
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            if (form.checkValidity()) {
                saveCourse();
            } else {
                e.stopPropagation();
                form.classList.add('was-validated');
            }
        });

        console.log('Modal form initialized successfully');
    } catch (error) {
        console.error('Error initializing modal form:', error);
    }
}

// Call initialization when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, initializing form...');
    setTimeout(initModalForm, 500); // Add small delay to ensure modal is ready
});

// Add a mutation observer to handle dynamic modal creation
const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (mutation.addedNodes.length) {
            mutation.addedNodes.forEach(function(node) {
                if (node.id === 'addCourseModal') {
                    console.log('Modal dynamically added, initializing form...');
                    initModalForm();
                }
            });
        }
    });
});

observer.observe(document.body, {
    childList: true,
    subtree: true
});


function recoverFromInitializationError() {
    console.log('Attempting to recover from initialization errors...');
    
    // Clear any stuck modals or backdrops
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
    document.body.classList.remove('modal-open');
    
    // Re-initialize forms
    initFormReferences();
    
    // Reload course data
    loadCourses();
    loadCourseStatistics();
}

// Add to window error handler
window.onerror = function(msg, url, line, col, error) {
    console.error('Global error caught:', msg);
    // Log error to server if needed
    
    // Try to recover if it's an initialization error
    if (msg.includes('Cannot set properties of null') || 
        msg.includes('Cannot read properties of null')) {
        setTimeout(recoverFromInitializationError, 500);
    }
    
    return false;
};


         // Fixed Theme Application - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            
 let searchTimeout;
        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(filterCourses, 300);
        }

            //Display the Save Add Course form
            body = document.getElementsByTagName('body')[0];
            body.innerHTML += `
                



    <!-- Global Loading Spinner -->
<div class="loading-spinner-save" id="globalLoadingSpinner-save">
    <div class="spinner-overlay-save"></div>
    <div class="spinner-content-save">
        <div class="spinner-wrapper-save mb-3">
            <div class="spinner-save"></div>
            <div class="loading-progress-save">
                <div class="progress-save" style="height: 4px; width: 200px;">
                    <div class="progress-bar-save progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%"></div>
                </div>
                <div class="progress-text-save mt-2"></div>
            </div>
        </div>
        <h5 class="spinner-title-save">Processing...</h5>
        <p class="spinner-message-save text-muted">Please wait while we process your request</p>
    </div>
</div>


       <%-- // Replace the existing Add Course Modal content with this --%>
<div class="modal" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true" data-bs-backdrop="false" data-bs-keyboard="false">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCourseModalLabel">
                    <i class="fa fa-plus me-2"></i>Add New Course
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="addCourseForm" class="needs-validation" novalidate>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="courseCode" class="form-label">Course Code</label>
                            <input type="text" class="form-control" id="courseCode" name="courseCode" 
                                   placeholder="e.g., CS101" required>
                            <div class="invalid-feedback">Please enter a valid course code.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="courseName" class="form-label">Course Name</label>
                            <input type="text" class="form-control" id="courseName" name="courseName" 
                                   placeholder="Course title" required>
                            <div class="invalid-feedback">Please enter a course name.</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="department" class="form-label">Department</label>
                            <select class="form-select" id="department" name="department" required>
                                <option value="">Select Department</option>
                            </select>
                            <div class="invalid-feedback">Please select a department.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="credits" class="form-label">Credits</label>
                            <input type="number" class="form-control" id="credits" name="credits" 
                                   min="1" max="6" required>
                            <div class="invalid-feedback">Please enter credits (1-6).</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="instructor" class="form-label">Instructor</label>
                            <select class="form-select" id="instructor" name="instructor" required>
                                <option value="">Select Instructor</option>
                            </select>
                            <div class="invalid-feedback">Please select an instructor.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="courseStatus" class="form-label">Status</label>
                            <select class="form-select" id="courseStatus" name="courseStatus" required>
                                <option value="draft">Draft</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="courseDescription" class="form-label">Course Description</label>
                        <textarea class="form-control" id="courseDescription" name="courseDescription" 
                                rows="4"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="startDate" class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" required>
                            <div class="invalid-feedback">Please select a start date.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="endDate" class="form-label">End Date</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" required>
                            <div class="invalid-feedback">Please select an end date.</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary btn-primary-custom" onclick="saveCourse(event)">
                        <i class="fa fa-save me-2"></i>Save Course
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
           


    <!-- Edit Course Modal -->
    <div class="modal" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true" data-bs-backdrop="false" data-bs-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editCourseModalLabel">
                        <i class="fa fa-edit me-2"></i>Edit Course
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editCourseForm" class="course-form">
    <div class="row">
        <div class="col-md-6 mb-3">
            <label for="editCourseCode" class="form-label">Course Code</label>
            <input type="text" class="form-control" id="editCourseCode" name="editCourseCode" readonly>
        </div>
        <div class="col-md-6 mb-3">
            <label for="editCourseName" class="form-label">Course Name</label>
            <input type="text" class="form-control" id="editCourseName" name="editCourseName" required>
        </div>
    </div>
    <div class="row">
<div class="col-md-6 mb-3">
            <label for="editDepartment" class="form-label">Department</label>
            <select class="form-select" id="editDepartment" name="editDepartment" required>
                <option value="">Select Department</option>
            </select>
        </div>

<div class="col-md-6 mb-3">
    <label for="editCredits" class="form-label">Credits</label>
    <input type="number" class="form-control" id="editCredits" name="editCredits">
</div>
    </div>

    <div class="row">
        
        <div class="col-md-6 mb-3">
            <label for="editInstructor" class="form-label">Instructor</label>
            <select class="form-select" id="editInstructor" name="editInstructor" required>
                <option value="">Select Instructor</option>
            </select>
        </div>
        <div class="col-md-6 mb-3">
    <label for="editCourseStatus" class="form-label">Status</label>
    <select class="form-select" id="editCourseStatus" name="editCourseStatus">
        <option value="draft">Draft</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
    </select>
</div>
    </div>
    <!-- ... similar updates for other edit form controls ... -->
    
  <div class="row">
        
<div class="mb-3">
    <label for="editCourseDescription" class="form-label">Description</label>
    <textarea class="form-control" id="editCourseDescription" name="editCourseDescription"></textarea>
</div>
   </div>     



  <div class="row">
        
<div class="col-md-6 mb-3">
    <label for="editStartDate" class="form-label">Start Date</label>
    <input type="date" class="form-control" id="editStartDate" name="editStartDate">
</div>

<div class="col-md-6 mb-3">
    <label for="editEndDate" class="form-label">End Date</label>
    <input type="date" class="form-control" id="editEndDate" name="editEndDate">
</div>

   </div>     
    
</form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary btn-primary-custom" onclick="updateCourse()">
                        <i class="fa fa-save me-2"></i>Update Course
                    </button>
                </div>
            </div>
        </div>
    </div>

 

    <!-- View Course Modal -->
    <div class="modal" id="viewCourseModal" tabindex="-1" aria-labelledby="viewCourseModalLabel" aria-hidden="true" data-bs-backdrop="false" data-bs-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewCourseModalLabel">
                        <i class="fa fa-eye me-2"></i>Course Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="course-info-container">
                        <!-- Course Header Info -->
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h3 class="text-primary mb-1" id="viewCourseName">Course Name</h3>
                                <p class="text-muted mb-2">
                                    <strong>Course Code:</strong> <span id="viewCourseCode">CODE</span> |
                                    <strong>Credits:</strong> <span id="viewCredits">0</span>
                                </p>
                                <span id="viewStatusBadge" class="status-badge">Status</span>
                            </div>
                            <div class="col-md-4 text-end">
                                <div class="enrollment-info">
                                    <h4 class="text-primary text-white mb-0" id="viewEnrolled">0</h4>
                                    <small class="text-white">Students Enrolled</small>
                                </div>
                            </div>
                        </div>

                        <!-- Course Details -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="info-group">
                                    <label class="form-label"><i class="fa fa-building me-2"></i>Department</label>
                                    <p class="info-value" id="viewDepartment">-</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-group">
                                    <label class="form-label"><i class="fa fa-user me-2"></i>Instructor</label>
                                    <p class="info-value" id="viewInstructor">-</p>
                                </div>
                            </div>
                        </div>

                        <!-- Course Description -->
                        <div class="mb-4">
                            <label class="form-label"><i class="fa fa-file-text me-2"></i>Course Description</label>
                            <div class="description-box p-3 bg-light border rounded" id="viewCourseDescription">
                                Course description will appear here...
                            </div>
                        </div>

                        <!-- Course Timeline -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="info-group">
                                    <label class="form-label"><i class="fa fa-calendar-plus me-2"></i>Start Date</label>
                                    <p class="info-value" id="viewStartDate">-</p>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-group">
                                    <label class="form-label"><i class="fa fa-calendar-minus me-2"></i>End Date</label>
                                    <p class="info-value" id="viewEndDate">-</p>
                                </div>
                            </div>
                        </div>

                        <!-- Course Statistics (Additional Info) -->
                        <div class="course-stats-view">
                            <h6 class="text-primary mb-3"><i class="fa fa-chart-bar me-2"></i>Course Statistics</h6>
                            <div class="row">
                                <div class="col-md-3 col-6">
                                    <div class="stat-item text-center p-3 bg-light rounded">
                                        <div class="stat-number text-primary" id="viewEnrolledCount">0</div>
                                        <div class="stat-label small">Enrolled</div>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="stat-item text-center p-3 bg-light rounded">
                                        <div class="stat-number text-success">0</div>
                                        <div class="stat-label small">Completed</div>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="stat-item text-center p-3 bg-light rounded">
                                        <div class="stat-number text-warning">0</div>
                                        <div class="stat-label small">In Progress</div>
                                    </div>
                                </div>
                                <div class="col-md-3 col-6">
                                    <div class="stat-item text-center p-3 bg-light rounded">
                                        <div class="stat-number text-info" id="viewCreditsValue">0</div>
                                        <div class="stat-label small">Credits</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-warning btn-primary-custom" onclick="editCourseFromView()">
                        <i class="fa fa-edit me-2"></i>Edit Course
                    </button>
                </div>
            </div>
        </div>
    </div>


    <!-- Delete Course Modal -->
    <div class="modal" id="deleteCourseModal" tabindex="-1" aria-labelledby="deleteCourseModalLabel" aria-hidden="true" data-bs-backdrop="false" data-bs-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-danger">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteCourseModalLabel">
                        <i class="fa fa-exclamation-triangle me-2"></i>Confirm Course Deletion
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger" role="alert">
                        <i class="fa fa-warning me-2"></i>
                        <strong>Warning!</strong> This action cannot be undone.
                    </div>
                    
                    <div class="delete-course-info">
                        <h6 class="text-danger mb-3">You are about to delete the following course:</h6>
                        
                        <div class="course-delete-details bg-light p-3 rounded border">
                            <div class="row mb-2">
                                <div class="col-sm-4"><strong>Course Code:</strong></div>
                                <div class="col-sm-8" id="deleteCourseCode">-</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4"><strong>Course Name:</strong></div>
                                <div class="col-sm-8" id="deleteCourseName">-</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4"><strong>Department:</strong></div>
                                <div class="col-sm-8" id="deleteDepartment">-</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4"><strong>Instructor:</strong></div>
                                <div class="col-sm-8" id="deleteInstructor">-</div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-sm-4"><strong>Enrolled Students:</strong></div>
                                <div class="col-sm-8">
                                    <span id="deleteEnrolled" class="fw-bold">0</span>
                                    <span id="enrolledWarning" class="text-danger ms-2" style="display: none;">
                                        <i class="fa fa-exclamation-circle"></i> Students will be affected!
                                    </span>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-4"><strong>Status:</strong></div>
                                <div class="col-sm-8">
                                    <span id="deleteStatusBadge" class="status-badge">Status</span>
                                </div>
                            </div>
                        </div>

                        <div id="studentWarningSection" class="alert alert-warning mt-3" style="display: none;">
                            <i class="fa fa-users me-2"></i>
                            <strong>Impact Warning:</strong> This course has <span id="studentWarningCount">0</span> enrolled student(s). 
                            Deleting this course will affect their academic records and progress.
                        </div>

                        <div class="mt-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="confirmDeletion">
                                <label class="form-check-label text-danger fw-bold" for="confirmDeletion">
                                    I understand that this action cannot be undone
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa fa-times me-2"></i>Cancel
                    </button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn" onclick="confirmDeletion()" disabled>
                        <i class="fa fa-trash me-2"></i>Delete Course
                    </button>
                </div>
            </div>
        </div>
    </div>


            `;









            // Initialize form references for safer modal handling
            initFormReferences();

            // GLOBAL BACKDROP CLEANUP FUNCTION
            function removeAllBackdrops() {
                const backdrops = document.querySelectorAll('.modal-backdrop');
                backdrops.forEach(backdrop => {
                    backdrop.remove();
                });
                // Also remove any backdrop classes from body
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';
            }

            // Force remove all fade classes from modals
            const modalElements = document.querySelectorAll('.modal');
            modalElements.forEach(modal => {
                modal.classList.remove('fade');
                modal.style.transition = 'none';
                modal.style.animation = 'none';
            });

            // Run backdrop cleanup on page load
            removeAllBackdrops();
            
            // Set up interval to continuously clean up backdrops
            setInterval(removeAllBackdrops, 100);

            // Completely override Bootstrap modal behavior to disable fade
            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                const originalModal = bootstrap.Modal;
                bootstrap.Modal = function(element, options) {
                    options = options || {};
                    options.backdrop = true;
                    options.keyboard = true;
                    options.focus = true;
                    // Force no animation/fade
                    const modal = new originalModal(element, options);
                    
                    // Override show/hide methods to remove transitions
                    const originalShow = modal.show;
                    const originalHide = modal.hide;
                    
                    modal.show = function() {
                        const modalElement = this._element;
                        modalElement.style.transition = 'none';
                        modalElement.style.animation = 'none';
                        modalElement.classList.remove('fade');
                        return originalShow.call(this);
                    };
                    
                    modal.hide = function() {
                        const modalElement = this._element;
                        modalElement.style.transition = 'none';
                        modalElement.style.animation = 'none';
                        return originalHide.call(this);
                    };
                    
                    return modal;
                };
                
                // Override default options
                bootstrap.Modal.Default = bootstrap.Modal.Default || {};
                bootstrap.Modal.Default.backdrop = true;
                bootstrap.Modal.Default.keyboard = true;
                bootstrap.Modal.Default.focus = true;
            }
            
            // Alternative: Direct DOM manipulation approach
            const DOMstyle = document.createElement('style');
            DOMstyle.textContent = `
                .modal.fade { transition: none !important; opacity: 1 !important; }
                .modal.fade .modal-dialog { transform: none !important; transition: none !important; }
                .modal-backdrop.fade { transition: none !important; opacity: 0.5 !important; }
                .modal { display: none !important; }
                .modal.show { display: block !important; opacity: 1 !important; }
            `;
            document.head.appendChild(DOMstyle);

            // Load courses on page load
            loadCourses();
            loadCourseStatistics();
            loadDepartments();
            loadInstructors();
        });
            // Function to load departments from the database
            function loadDepartments() {
                console.log('Loading departments from database...');
                
                $.ajax({
                    type: "POST",
                    url: "Course.aspx/GetDepartments",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.success) {
                            const departments = response.d.data || [];
                            console.log(`Successfully loaded ${departments.length} departments from database:`, departments);
                            
                            // Get all department dropdowns
                            const departmentDropdowns = [
                                document.getElementById('departmentFilter'),
                                document.getElementById('department'),
                                document.getElementById('editDepartment')
                            ];
                            
                            // Populate each dropdown
                            departmentDropdowns.forEach(dropdown => {
                                if (dropdown) {
                                    try {
                                        // Keep the first option (All Departments or Select Department)
                                        const firstOption = dropdown.options[0];
                                        dropdown.innerHTML = '';
                                        dropdown.appendChild(firstOption);
                                        
                                        // Add department options
                                        departments.forEach(dept => {
                                            const option = document.createElement('option');
                                            option.value = dept.id;  // Use the ID instead of code
                                            option.textContent = dept.name;
                                            dropdown.appendChild(option);
                                        });
                                        
                                        console.log(`Populated dropdown ${dropdown.id} with ${departments.length} departments`);
                                    } catch (err) {
                                        console.error(`Error populating ${dropdown.id} dropdown:`, err);
                                    }
                                }
                            });
                        } else {
                            console.error('Failed to load departments:', response.d ? response.d.message : 'Unknown error');
                            showToast('Failed to load departments. Using default values.', 'warning');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Error loading departments:', error);
                        console.error('Status:', status);
                        console.error('Response:', xhr.responseText);
                        showToast('Error loading departments. Using default values.', 'error');
                    }
                });
            }
            
            function loadInstructors() {
                console.log('Loading instructors from database...');
                
                $.ajax({
                    type: "POST",
                    url: "Course.aspx/GetInstructors",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.success) {
                            const instructors = response.d.data || [];
                            console.log(`Successfully loaded ${instructors.length} instructors from database:`, instructors);
                            
                            // Get all instructor dropdowns
                            const instructorDropdowns = [
                                document.getElementById('instructor'),
                                document.getElementById('editInstructor')
                            ];
                            
                            // Populate each dropdown
                            instructorDropdowns.forEach(dropdown => {
                                if (dropdown) {
                                    try {
                                        // Keep the first option (Select Instructor)
                                        const firstOption = dropdown.options[0];
                                        dropdown.innerHTML = '';
                                        dropdown.appendChild(firstOption);
                                        
                                        // Add instructor options
                                        instructors.forEach(instructor => {
                                            const option = document.createElement('option');
                                            option.value = instructor.id;
                                            option.textContent = instructor.name;
                                            dropdown.appendChild(option);
                                        });
                                        
                                        console.log(`Populated dropdown ${dropdown.id} with ${instructors.length} instructors`);
                                        
                                        // Show warning if no instructors found
                                        if (instructors.length === 0) {
                                            const warningText = dropdown.nextElementSibling;
                                            if (warningText && warningText.classList.contains('form-text')) {
                                                warningText.textContent = 'No instructors with valid employee records found. Please add instructors with employee records first.';
                                                warningText.classList.add('text-danger');
                                            }
                                        }
                                    } catch (err) {
                                        console.error(`Error populating ${dropdown.id} dropdown:`, err);
                                    }
                                }
                            });
                        } else {
                            console.error('Failed to load instructors:', response.d ? response.d.message : 'Unknown error');
                            showToast('Failed to load instructors. Using default values.', 'warning');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('Error loading instructors:', error);
                        console.error('Status:', status);
                        console.error('Response:', xhr.responseText);
                        showToast('Failed to load instructors. Using default values.', 'warning');
                    }
                });
            }
            // Function to show toast notifications
function showToast(message, type = 'info') {
            const Toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true,
                didOpen: (toast) => {
                    toast.addEventListener('mouseenter', Swal.stopTimer);
                    toast.addEventListener('mouseleave', Swal.resumeTimer);
                }
            });

            const iconMap = {
                'success': 'success',
                'error': 'error',
                'warning': 'warning',
                'info': 'info'
            };

            Toast.fire({
                icon: iconMap[type] || 'info',
                title: message
            });
        }

function showLoadingSpinner() {
            document.getElementById('loadingSpinner').style.display = 'flex';
        }
        function hideLoadingSpinner() {
            document.getElementById('loadingSpinner').style.display = 'none';
        }

function exportToPDF() {
    const table = document.getElementById('courseTable');
    if (!table) {
        showToast('Course table not found.', 'error');
        return;
    }

    showLoadingSpinner();

    html2canvas(table).then(canvas => {
        const imgData = canvas.toDataURL('image/png');
        const pdf = new window.jspdf.jsPDF('l', 'pt', 'a4');
        const pageWidth = pdf.internal.pageSize.getWidth();
        const pageHeight = pdf.internal.pageSize.getHeight();
        const imgWidth = pageWidth - 40;
        const imgHeight = canvas.height * imgWidth / canvas.width;

        pdf.addImage(imgData, 'PNG', 20, 20, imgWidth, imgHeight);
        pdf.save('courses_export.pdf');
        hideLoadingSpinner();
        showToast('Courses exported to PDF successfully!', 'success');
    }).catch(err => {
        hideLoadingSpinner();
        showToast('Failed to export to PDF.', 'error');
        console.error(err);
    });
}


function exportToExcel() {
    const table = document.getElementById('courseTable');
    if (!table) {
        showToast('Course table not found.', 'error');
        return;
    }

    let tableHTML = table.outerHTML.replace(/ /g, '%20');
    const filename = 'courses_export.xls';

    // Create a download link and trigger it
    const downloadLink = document.createElement('a');
    document.body.appendChild(downloadLink);
    downloadLink.href = 'data:application/vnd.ms-excel,' + tableHTML;
    downloadLink.download = filename;
    downloadLink.click();
    document.body.removeChild(downloadLink);

    showToast('Courses exported to Excel successfully!', 'success');
}

        // Enhanced Table Sorting Functionality
        let sortDirection = {};
        
        function sortTable(columnIndex) {
            try {
                console.log(`🔍 Starting sort for column ${columnIndex}`);
                
                const table = document.getElementById('courseTable');
                if (!table) {
                    console.error('❌ Course table not found');
                    return;
                }
                
                const tbody = table.querySelector('tbody');
                if (!tbody) {
                    console.error('❌ Table body not found');
                    return;
                }
                
                // Get all data rows (exclude loading and no-data rows)
                const rows = Array.from(tbody.querySelectorAll('tr:not(.loading-row):not(.no-data-row)'));
                console.log(`📊 Found ${rows.length} rows to sort`);
                
                if (rows.length === 0) {
                    console.warn('⚠️ No rows to sort');
                    showToast('No data available to sort', 'warning');
                    return;
                }
                
                // Determine sort direction
                const currentDirection = sortDirection[columnIndex] || 'asc';
                const newDirection = currentDirection === 'asc' ? 'desc' : 'asc';
                sortDirection[columnIndex] = newDirection;
                
                console.log(`🔄 Sorting direction: ${currentDirection} → ${newDirection}`);
                
                // Update sort icons
                document.querySelectorAll('.sortable i').forEach(icon => {
                    icon.className = 'fa fa-sort ms-1 text-muted';
                });
                
                const headerIcon = document.querySelector(`[onclick*="sortTable(${columnIndex})"] i`);
                if (headerIcon) {
                    headerIcon.className = `fa fa-sort-${newDirection === 'asc' ? 'up' : 'down'} ms-1 text-primary`;
                    console.log(`🎯 Updated sort icon for column ${columnIndex}`);
                } else {
                    console.warn(`⚠️ Sort icon not found for column ${columnIndex}`);
                }
                
                // Validate column index
                if (columnIndex < 0 || columnIndex >= rows[0].cells.length) {
                    console.error(`❌ Invalid column index: ${columnIndex}`);
                    showToast(`Invalid column index: ${columnIndex}`, 'error');
                    return;
                }
                
                // Sort the rows
                rows.sort((a, b) => {
                    try {
                        let aVal = a.cells[columnIndex] ? a.cells[columnIndex].textContent.trim() : '';
                        let bVal = b.cells[columnIndex] ? b.cells[columnIndex].textContent.trim() : '';
                        
                        // Handle numeric columns (Credits=4 and Enrolled=6)
                        if (columnIndex === 4 || columnIndex === 6) {
                            aVal = parseInt(aVal) || 0;
                            bVal = parseInt(bVal) || 0;
                            console.log(`🔢 Numeric sort: ${aVal} vs ${bVal}`);
                        } else {
                            aVal = aVal.toLowerCase();
                            bVal = bVal.toLowerCase();
                            console.log(`🔤 Text sort: "${aVal}" vs "${bVal}"`);
                        }
                        
                        if (aVal < bVal) return newDirection === 'asc' ? -1 : 1;
                        if (aVal > bVal) return newDirection === 'asc' ? 1 : -1;
                        return 0;
                    } catch (sortError) {
                        console.error('❌ Error during row comparison:', sortError);
                        return 0;
                    }
                });
                
                // Re-append sorted rows with animation
                rows.forEach((row, index) => {
                    tbody.appendChild(row);
                    // Add subtle animation
                    row.style.transition = 'background-color 0.3s ease';
                    row.style.backgroundColor = '#f8f9fa';
                    setTimeout(() => {
                        row.style.backgroundColor = '';
                    }, 200 + (index * 20));
                });
                
                // Show feedback
                const columnNames = ['', 'Course Code', 'Course Name', 'Department', 'Credits', 'Instructor', 'Enrolled', 'Status'];
                const columnName = columnNames[columnIndex] || `Column ${columnIndex}`;
                const message = `✅ Table sorted by ${columnName} (${newDirection === 'asc' ? 'ascending' : 'descending'})`;
                
                console.log(`🎉 ${message}`);
                showToast(message, 'success');
                
            } catch (error) {
                console.error('❌ Error in sortTable:', error);
                showToast('An error occurred while sorting the table', 'error');
            }
        }


        // Add real-time form validation
        function addFormValidation() {
            const courseCodeInput = document.getElementById('courseCode');
            const courseNameInput = document.getElementById('courseName');
            const creditsInput = document.getElementById('credits');
            const descriptionInput = document.getElementById('courseDescription');
            const departmentInput = document.getElementById('department');
            const instructorInput = document.getElementById('instructor');
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');

            if (courseCodeInput) {
                courseCodeInput.addEventListener('blur', function() {
                    validateCourseCode(this);
                });
                courseCodeInput.addEventListener('input', function() {
                    this.value = this.value.toUpperCase();
                    // Clear validation when user starts typing
                    this.classList.remove('is-valid', 'is-invalid');
                    const feedback = this.parentNode.querySelector('.invalid-feedback');
                    if (feedback) feedback.remove();
                });
            }

            if (courseNameInput) {
                courseNameInput.addEventListener('blur', function() {
                    validateRequired(this, 'Course name is required');
                });
                courseNameInput.addEventListener('input', function() {
                    // Clear validation when user starts typing
                    this.classList.remove('is-valid', 'is-invalid');
                    const feedback = this.parentNode.querySelector('.invalid-feedback');
                    if (feedback) feedback.remove();
                });
            }

            if (creditsInput) {
                creditsInput.addEventListener('blur', function() {
                    validateCredits(this);
                });
                creditsInput.addEventListener('input', function() {
                    // Clear validation when user starts typing
                    this.classList.remove('is-valid', 'is-invalid');
                    const feedback = this.parentNode.querySelector('.invalid-feedback');
                    if (feedback) feedback.remove();
                });
            }
            
            if (descriptionInput) {
                // Description is optional according to database schema
                descriptionInput.addEventListener('blur', function() {
                    // No validation needed since it's optional
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                });
                descriptionInput.addEventListener('input', function() {
                    // Clear validation when user starts typing
                    this.classList.remove('is-valid', 'is-invalid');
                    const feedback = this.parentNode.querySelector('.invalid-feedback');
                    if (feedback) feedback.remove();
                });
            }

            if (departmentInput) {
                // Department is required according to database schema
                departmentInput.addEventListener('change', function() {
                    if (!this.value) {
                        showFieldError(this, 'Please select a department');
                    } else {
                        showFieldSuccess(this);
                    }
                });
            }
            
            if (instructorInput) {
                instructorInput.addEventListener('change', function() {
                    validateRequired(this, 'Instructor is required');
                });
            }

            if (startDateInput && endDateInput) {
                startDateInput.addEventListener('change', function() {
                    validateDateRange(startDateInput, endDateInput);
                });
                startDateInput.addEventListener('blur', function() {
                    // Check if empty on blur
                    if (!this.value && this.required) {
                        showFieldError(this, 'Start date is required');
                    }
                });
                
                endDateInput.addEventListener('change', function() {
                    validateDateRange(startDateInput, endDateInput);
                });
                endDateInput.addEventListener('blur', function() {
                    // Check if empty on blur
                    if (!this.value && this.required) {
                        showFieldError(this, 'End date is required');
                    }
                });
            }
        }

        // Validation functions
        function validateCourseCode(input) {
            // First check if empty
            if (input.value.trim() === '') {
                showFieldError(input, 'Course code is required');
                return false;
            }
            
            // Then check format
            const codeRegex = /^[A-Z]{2,4}\d{3}$/;
            const isValid = codeRegex.test(input.value);
            
            if (!isValid) {
                showFieldError(input, 'Course code must be in format like CS101, MATH201, etc.');
                return false;
            } else {
                showFieldSuccess(input);
                return true;
            }
        }

        function validateRequired(input, message) {
            const isValid = input.value.trim() !== '';
            
            if (!isValid) {
                showFieldError(input, message);
                return false;
            } else {
                showFieldSuccess(input);
                return true;
            }
        }

        function validateCredits(input) {
            // First check if empty
            if (input.value.trim() === '') {
                showFieldError(input, 'Credits are required');
                return false;
            }
            
            // Then check range
            const credits = parseInt(input.value);
            const isValid = credits >= 1 && credits <= 6;
            
            if (!isValid) {
                showFieldError(input, 'Credits must be between 1 and 6');
                return false;
            } else {
                showFieldSuccess(input);
                return true;
            }
        }

        function validateDateRange(startInput, endInput) {
            // Check if both dates are required - typically they should be
            const startRequired = startInput.required;
            const endRequired = endInput.required;
            
            // If either field is required but empty, show error
            if (startRequired && !startInput.value) {
                showFieldError(startInput, 'Start date is required');
                return false;
            }
            
            if (endRequired && !endInput.value) {
                showFieldError(endInput, 'End date is required');
                return false;
            }
            
            // If both have values, check the range
            if (startInput.value && endInput.value) {
                const startDate = new Date(startInput.value);
                const endDate = new Date(endInput.value);
                
                if (startDate >= endDate) {
                    showFieldError(endInput, 'End date must be after start date');
                    return false;
                } else {
                    showFieldSuccess(startInput);
                    showFieldSuccess(endInput);
                    return true;
                }
            }
            
            // If we got here and have values, mark as valid
            if (startInput.value) {
                showFieldSuccess(startInput);
            }
            if (endInput.value) {
                showFieldSuccess(endInput);
            }
            
            return true;
        }

        function showFieldError(input, message) {
            input.classList.remove('is-valid');
            input.classList.add('is-invalid');
            
            // Remove existing feedback
            const existingFeedback = input.parentNode.querySelector('.invalid-feedback');
            if (existingFeedback) {
                existingFeedback.remove();
            }
            
            // Add error message
            const feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            feedback.textContent = message;
            input.parentNode.appendChild(feedback);
        }

        function showFieldSuccess(input) {
            input.classList.remove('is-invalid');
            input.classList.add('is-valid');
            
            // Remove error message
            const existingFeedback = input.parentNode.querySelector('.invalid-feedback');
            if (existingFeedback) {
                existingFeedback.remove();
            }
        }

        // Store form references globally to avoid DOM timing issues
       
        let addCourseFormRef = null;
        let editCourseFormRef = null;
        
        // Initialize form references when DOM is ready
        function initFormReferences() {
            // Try to get form references with retry mechanism
            let attempts = 0;
            const maxAttempts = 5;
            
function tryInitialize() {
        attempts++;
        console.log(`Form references initialization attempt ${attempts}`);
        
        // Wait for DOM to be fully loaded
        if (document.readyState !== 'complete') {
            if (attempts < maxAttempts) {
                setTimeout(tryInitialize, 100);
            }
            return;
        }

        // Try to get the form elements
        const addCourseForm = document.getElementById('addCourseForm');
        const editCourseForm = document.getElementById('editCourseForm');

        if (!addCourseForm && attempts < maxAttempts) {
            setTimeout(tryInitialize, 100);
            return;
        }

        if (addCourseForm) {
            addCourseFormRef = addCourseForm;
            console.log('Add Course form found');
        } else {
            console.error('Add Course form not found after all attempts');
            // Try to recreate the form if not found
            wrapFormInModal();
        }

        if (editCourseForm) {
            editCourseFormRef = editCourseForm;
            console.log('Edit Course form found');
        }
    }
            
            tryInitialize();
        }
        
        // Robust form reset that uses stored references
        function resetFormSafely(formRef, formId) {
            try {
                let form = formRef;
                
                // Fallback strategies if reference is stale
                if (!form || !document.contains(form)) {
                    form = document.getElementById(formId);
                }
                
                if (!form) {
                    const modals = document.querySelectorAll('.modal');
                    for (const modal of modals) {
                        const modalForm = modal.querySelector(`#${formId}`);
                        if (modalForm) {
                            form = modalForm;
                            break;
                        }
                    }
                }
                
                if (form) {
                    form.reset();
                    
                    // Clear validation
                    const inputs = form.querySelectorAll('.form-control, .form-select, textarea');
                    inputs.forEach(input => {
                        input.classList.remove('is-valid', 'is-invalid');
                        const feedback = input.parentNode.querySelector('.invalid-feedback');
                        if (feedback) {
                            feedback.remove();
                        }
                    });
                    
                    console.log(`Form ${formId} reset and validation cleared successfully`);
                    return true;
                }
                
                console.warn(`Form ${formId} not found for reset`);
                return false;
            } catch (error) {
                console.error(`Error resetting form ${formId}:`, error);
                return false;
            }
        }


        // Alternative form clearing function that works regardless of DOM timing issues
        function clearAllFormsValidation() {
            try {
                // Clear validation from all forms on the page
                const allForms = document.querySelectorAll('form');
                let clearedCount = 0;
                
                allForms.forEach(form => {
                    const inputs = form.querySelectorAll('.form-control, .form-select, textarea');
                    inputs.forEach(input => {
                        input.classList.remove('is-valid', 'is-invalid');
                        
                        // Remove any feedback messages
                        const feedback = input.parentNode.querySelector('.invalid-feedback');
                        if (feedback) {
                            feedback.remove();
                        }
                    });
                    clearedCount++;
                });
                
                console.log(`Cleared validation for ${clearedCount} forms using global clear`);
                return clearedCount > 0;
            } catch (error) {
                console.error('Error in clearAllFormsValidation:', error);
                return false;
            }
        }

        function clearFormValidation(formId) {
            try {
                // Use setTimeout to ensure DOM is stable when called during modal events
                setTimeout(() => {
                    let form = document.getElementById(formId);
                    
                    // If form not found by ID, try to find it in all modals
                    if (!form) {
                        const modals = document.querySelectorAll('.modal');
                        for (const modal of modals) {
                            const modalForm = modal.querySelector(`#${formId}`);
                            if (modalForm) {
                                form = modalForm;
                                break;
                            }
                        }
                    }
                    
                    if (form) {
                        const inputs = form.querySelectorAll('.form-control, .form-select, textarea');
                        inputs.forEach(input => {
                            input.classList.remove('is-valid', 'is-invalid');
                            
                            // Remove any feedback messages
                            const feedback = input.parentNode.querySelector('.invalid-feedback');
                            if (feedback) {
                                feedback.remove();
                            }
                        });
                        console.log(`Validation cleared for form: ${formId}`);
                    } else {
                        console.warn('Form not found for validation clearing:', formId);
                        // Try clearing all forms as a fallback
                        const allForms = document.querySelectorAll('form');
                        let clearedCount = 0;
                        allForms.forEach(form => {
                            const inputs = form.querySelectorAll('.form-control, .form-select, textarea');
                            inputs.forEach(input => {
                                input.classList.remove('is-valid', 'is-invalid');
                                
                                // Remove any feedback messages
                                const feedback = input.parentNode.querySelector('.invalid-feedback');
                                if (feedback) {
                                    feedback.remove();
                                }
                            });
                            clearedCount++;
                        });
                        console.log(`Cleared validation for ${clearedCount} forms as fallback`);
                    }
                }, 10); // Small delay to ensure DOM stability
            } catch (ex) {
                console.error('Error in clearFormValidation:', ex);
                // Emergency fallback
                try {
                    clearAllValidation();
                } catch (fallbackError) {
                    console.error('Emergency fallback also failed:', fallbackError);
                }
            }
        }

        // Comprehensive form reset function for div-based form containers
        function resetCourseForm(formId) {
            try {
                console.log(`Resetting course form: ${formId}`);
                
                let formContainer = document.getElementById(formId);
                
                // If not found, try to find it in modals
                if (!formContainer) {
                    const modals = document.querySelectorAll('.modal');
                    for (const modal of modals) {
                        const modalContainer = modal.querySelector(`#${formId}`);
                        if (modalContainer) {
                            formContainer = modalContainer;
                            break;
                        }
                    }
                }
                
                if (formContainer) {
                    // Clear all input fields
                    const inputs = formContainer.querySelectorAll('input, select, textarea');
                    inputs.forEach(input => {
                        // Clear values based on input type
                        if (input.type === 'text' || input.type === 'number' || input.type === 'date' || input.tagName === 'TEXTAREA') {
                            input.value = '';
                        } else if (input.type === 'checkbox' || input.type === 'radio') {
                            input.checked = false;
                        } else if (input.tagName === 'SELECT') {
                            input.selectedIndex = 0;
                        } else if (input.tagName === 'TEXTAREA') {
                            input.value = '';
                        }
                        
                        // Remove validation classes
                        input.classList.remove('is-valid', 'is-invalid');
                        
                        // Remove feedback messages
                        const feedback = input.parentNode.querySelector('.invalid-feedback');
                        if (feedback) {
                            feedback.remove();
                        }
                    });
                    
                    // Remove validation from container
                    if (formContainer.classList) {
                        formContainer.classList.remove('was-validated');
                    }
                    
                    console.log(`Form ${formId} reset successfully`);
                    return true;
                } else {
                    console.warn(`Form container ${formId} not found for reset`);
                    return false;
                }
            } catch (error) {
                console.error(`Error resetting form ${formId}:`, error);
                return false;
            }
        }

function gotoPage(page) {
    const totalPages = Math.ceil(totalCourses / pageSize);
    // Clamp page between 1 and totalPages
    if (page < 1) page = 1;
    if (page > totalPages) page = totalPages;
    if (page === currentPage) return; // No need to reload same page
    currentPage = page;
    loadCourses();
}

function renderPagination() {
    const paginationContainer = document.querySelector('.pagination');
    if (!paginationContainer) return;

    const totalPages = Math.ceil(totalCourses / pageSize);
    let html = '';

    // Previous button
    html += `<li class="page-item${currentPage === 1 ? ' disabled' : ''}">
        <a class="page-link" href="#" onclick="gotoPage(${currentPage - 1}); return false;">Previous</a>
    </li>`;

    // Page numbers (show max 5 pages for simplicity)
    let startPage = Math.max(1, currentPage - 2);
    let endPage = Math.min(totalPages, startPage + 4);
    if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);

    for (let i = startPage; i <= endPage; i++) {
        html += `<li class="page-item${i === currentPage ? ' active' : ''}">
            <a class="page-link" href="#" onclick="gotoPage(${i}); return false;">${i}</a>
        </li>`;
    }

    // Next button
    html += `<li class="page-item${currentPage === totalPages ? ' disabled' : ''}">
        <a class="page-link" href="#" onclick="gotoPage(${currentPage + 1}); return false;">Next</a>
    </li>`;

    paginationContainer.innerHTML = html;
}


        // Load courses from server
        function loadCourses() {
    const tableBody = document.getElementById('courseTableBody');
    if (!tableBody) return;

    tableBody.innerHTML = `<tr class="loading-row"><td colspan="9" class="text-center py-4">Loading...</td></tr>`;

    $.ajax({
        type: "POST",
        url: "Course.aspx/GetCourses",
        data: JSON.stringify({
            pageNumber: currentPage,
            pageSize: pageSize,
            searchTerm: document.getElementById('courseSearch').value.trim(),
            department: document.getElementById('departmentFilter').value,
            status: document.getElementById('statusFilter').value
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            if (response.d && response.d.success) {
                totalCourses = response.d.totalCount || 0;
                populateCourseTable(response.d.data);
                renderPagination();
            } else {
                handleLoadError('Failed to load courses: ' + (response.d?.message || 'Unknown error'));
            }
        },
        error: function(xhr, status, error) {
            handleLoadError('Error loading courses: ' + error);
        }
    });
}


// Add error handler function
function handleLoadError(message) {
    console.error(message);
    const tableBody = document.getElementById('courseTableBody');
    if (tableBody) {
        tableBody.innerHTML = `
            <tr class="error-row">
                <td colspan="9" class="text-center py-4">
                    <div class="text-danger">
                        <i class="fas fa-exclamation-circle fa-2x mb-2"></i>
                        <p>Failed to load courses. Please try again.</p>
                        <button class="btn btn-outline-primary btn-sm mt-2" onclick="loadCourses()">
                            <i class="fas fa-sync-alt me-1"></i>Retry
                        </button>
                    </div>
                </td>
            </tr>
        `;
    }
}



        // Load sample courses for testing/demo
        function loadSampleCourses() {
            <%-- const sampleCourses = [
                {
                    courseCode: 'CS101',
                    courseName: 'Introduction to Computer Science',
                    department: 'Computer Science',
                    credits: 3,
                    instructor: 'Dr. Kwame Asante',
                    enrolledCount: 45,
                    status: 'active',
                    description: 'An introductory course covering fundamental concepts of computer science including programming, algorithms, and data structures.'
                },
                {
                    courseCode: 'MATH201',
                    courseName: 'Calculus II',
                    department: 'Mathematics',
                    credits: 4,
                    instructor: 'Prof. Ama Osei',
                    enrolledCount: 32,
                    status: 'active',
                    description: 'Advanced calculus covering integration techniques, series, and multivariable calculus.'
                },
                {
                    courseCode: 'EDU301',
                    courseName: 'Educational Psychology',
                    department: 'Education',
                    credits: 3,
                    instructor: 'Dr. Kofi Mensah',
                    enrolledCount: 28,
                    status: 'draft',
                    description: 'Study of learning processes and psychological principles in educational settings.'
                },
                {
                    courseCode: 'BUS205',
                    courseName: 'Business Ethics',
                    department: 'Business',
                    credits: 2,
                    instructor: 'Mrs. Akosua Darko',
                    enrolledCount: 0,
                    status: 'inactive',
                    description: 'Exploration of ethical principles and moral reasoning in business contexts.'
                },
                {
                    courseCode: 'ENG102',
                    courseName: 'English Composition',
                    department: 'English',
                    credits: 3,
                    instructor: 'Dr. Sarah Johnson',
                    enrolledCount: 38,
                    status: 'active',
                    description: 'Development of writing skills through analysis and composition of various text types.'
                }
            ]; --%>

            setTimeout(() => {
                populateCourseTable(sampleCourses);
            }, 1000);
        }

        // Populate course table with data
        function populateCourseTable(courses) {
            const tableBody = document.querySelector('#courseTableBody');
            
            if (courses.length === 0) {
                tableBody.innerHTML = `
                    <tr class="no-data-row">
                        <td colspan="9" class="text-center py-5">
                            <div class="text-muted">
                                <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                <h5>No courses found</h5>
                                <p>Try adjusting your search criteria or add a new course.</p>
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCourseModal" onclick="openAddCourseModal(event)">
                                    <i class="fas fa-plus me-2"></i>Add New Course
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
                return;
            }

            tableBody.innerHTML = '';
            
            courses.forEach((course, index) => {
                const row = document.createElement('tr');
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                row.className = 'course-row';
                
                row.innerHTML = `
                    <td>
                        <div class="form-check">
                            <input class="form-check-input course-checkbox" type="checkbox" 
       value="${course.courseCode}" onchange="toggleBulkActions(); updateSelectAllCheckbox();">
                        </div>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="course-code-badge">
                                <strong>${course.courseCode}</strong>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="course-name-cell">
                            <div class="fw-semibold">${course.courseName}</div>
                            ${course.description ? `<small class="text-muted">${course.description.substring(0, 50)}${course.description.length > 50 ? '...' : ''}</small>` : ''}
                        </div>
                    </td>
                    <td>
                        <span class="department-badge">${course.department}</span>
                    </td>
                    <td class="text-center">
                        <span class="badge bg-light text-dark">${course.credits} Credit${course.credits !== 1 ? 's' : ''}</span>
                    </td>
                    <td>
                        <div class="instructor-cell">
                            <i class="fas fa-user-tie me-2 text-muted"></i>
                            ${course.instructor}
                        </div>
                    </td>
                    <td class="text-center">
                        <div class="enrollment-cell">
                            <span class="enrollment-count">${course.enrolledCount}</span>
                            <i class="fas fa-users ms-1 text-muted"></i>
                        </div>
                    </td>
                    <td class="text-center">
                        <span class="badge bg-${getStatusColor(course.status)} status-badge">
                            <i class="fas fa-${getStatusIcon(course.status)} me-1"></i>
                            ${course.status}
                        </span>
                    </td>
                    <td>
                        <div class="btn-group action-buttons" role="group">
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="viewCourse('${course.courseCode}')" 
                                    title="View Course Details" data-bs-toggle="tooltip">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-success" onclick="editCourse('${course.courseCode}')" 
                                    title="Edit Course" data-bs-toggle="tooltip">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteCourse('${course.courseCode}')" 
                                    title="Delete Course" data-bs-toggle="tooltip">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                `;
                
                tableBody.appendChild(row);
                
                // Animate row appearance
                setTimeout(() => {
                    row.style.transition = 'all 0.3s ease';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 50);
            });
// After populating the table, add event listeners for all course-checkboxes
document.querySelectorAll('.course-checkbox').forEach(cb => {
    cb.addEventListener('change', updateSelectAllCheckbox);
});
            // Initialize tooltips
            setTimeout(() => {
                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }, 500);
        }

        // Get status color for badges
        function getStatusColor(status) {
            switch(status.toLowerCase()) {
                case 'active': return 'success';
                case 'inactive': return 'secondary';
                case 'draft': return 'warning';
                default: return 'secondary';
            }
        }

function deleteCourse(courseCode) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Delete Course?',
            text: `Are you sure you want to delete course ${courseCode}? This action cannot be undone!`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                showGlobalLoading();
                
                // Call server to delete course
                $.ajax({
                    type: "POST",
                    url: "Course.aspx/DeleteCourse",
                    data: JSON.stringify({ courseCode: courseCode }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        hideGlobalLoading();
                        if (response.d && response.d.success) {
                            showToast(`Course ${courseCode} deleted successfully!`, 'success');
                            loadCourses();
                            loadCourseStatistics();
                        } else {
                            showToast(response.d ? response.d.message : 'Failed to delete course', 'error');
                        }
                    },
                    error: function(xhr, status, error) {
                        hideGlobalLoading();
                        console.error('Error deleting course:', error);
                        showToast('An error occurred while deleting the course.', 'error');
                    }
                });
            }
        });
    } else {
        if (confirm(`Are you sure you want to delete course ${courseCode}?`)) {
            // Remove from sample data for demo
            const tableBody = document.querySelector('#courseTableBody');
            const rows = tableBody.querySelectorAll('tr');
            rows.forEach(row => {
                if (row.cells && row.cells[1] && row.cells[1].textContent.includes(courseCode)) {
                    row.remove();
                }
            });
            showToast(`Course ${courseCode} deleted successfully!`, 'success');
        }
    }
}
        


        // Get status icon for badges
        function getStatusIcon(status) {
            switch(status.toLowerCase()) {
                case 'active': return 'play-circle';
                case 'inactive': return 'pause-circle';
                case 'draft': return 'edit';
                default: return 'question-circle';
            }
        }

       function showGlobalLoading(timeout = 3000) {
    const spinner = document.getElementById('globalLoadingSpinner-save');
    if (!spinner) return;

    spinner.style.display = 'flex';
    const progressBar = spinner.querySelector('.progress-bar-save');
    const progressText = spinner.querySelector('.progress-text-save');

    let progress = 0;
    const interval = 30;
    const increment = (100 * interval) / timeout;

    const progressInterval = setInterval(() => {
        progress = Math.min(progress + increment, 100);
        if (progressBar) {
            progressBar.style.width = `${progress}%`;
            progressBar.style.transition = 'width 0.1s linear';
        }
        if (progressText) {
            progressText.textContent = `Loading... ${Math.round(progress)}%`;
        }

        if (progress >= 100) {
            clearInterval(progressInterval);
            setTimeout(hideGlobalLoading, 200);
        }
    }, interval);

    // Ensure cleanup
    setTimeout(() => {
        clearInterval(progressInterval);
        hideGlobalLoading();
    }, timeout + 500);
}

// Update hideGlobalLoading to clear interval if exists
function hideGlobalLoading() {
    const spinner = document.getElementById('globalLoadingSpinner-save');
    if (spinner) {
        // Clear any existing progress interval
        const intervalId = spinner.dataset.progressInterval;
        if (intervalId) {
            clearInterval(intervalId);
            delete spinner.dataset.progressInterval;
        }

        // Add fade out animation
        spinner.style.opacity = '0';
        setTimeout(() => {
            spinner.style.display = 'none';
            spinner.style.opacity = '1';
            
            // Reset progress bar
            const bar = spinner.querySelector('.progress-bar');
            const text = spinner.querySelector('.progress-text');
            if (bar) bar.style.width = '0%';
            if (text) text.textContent = '';
        }, 300);
    }
}

function openModal(modalId) {
    const modalElement = document.getElementById(modalId);
    if (!modalElement) return;

    try {
        // Try Bootstrap 5.x
        const modal = new bootstrap.Modal(modalElement);
        modal.show();
    } catch (error) {
        // Fallback to manual display
        modalElement.style.display = 'block';
        modalElement.classList.add('show');
        document.body.classList.add('modal-open');
    }
}

function closeModal(modalId) {
    const modalElement = document.getElementById(modalId);
    if (!modalElement) return;

    // Bootstrap 5 way
    if (window.bootstrap && bootstrap.Modal && typeof bootstrap.Modal.getInstance === 'function') {
        let modal = bootstrap.Modal.getInstance(modalElement);
        if (!modal) {
            modal = new bootstrap.Modal(modalElement);
        }
        modal.hide();
    }
    // Bootstrap 4 way
    else if (window.jQuery) {
        $('#' + modalId).modal('hide');
    }
    // Manual fallback
    else {
        modalElement.style.display = 'none';
        modalElement.classList.remove('show');
        document.body.classList.remove('modal-open');
        document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
    }
}


        // Function to load and update course statistics
        function loadCourseStatistics() {
            $.ajax({
                type: "POST",
                url: "Course.aspx/GetCourseStatistics",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.success) {
                        updateStatisticsCards(response.d.data);
                    } else {
                        console.error('Failed to load course statistics:', response.d ? response.d.message : 'Unknown error');
                        // Load sample stats for testing
                        updateStatisticsCards({
                            totalCourses: 5,
                            activeCourses: 3,
                            draftCourses: 1,
                            inactiveCourses: 1,
                            totalEnrollments: 143
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading course statistics:', error);
                    // Load sample stats for testing
                    updateStatisticsCards({
                        totalCourses: 5,
                        activeCourses: 3,
                        draftCourses: 1,
                        inactiveCourses: 1,
                        totalEnrollments: 143
                    });
                }
            });
        }

        // Function to update statistics cards with data
        function updateStatisticsCards(stats) {
            // Update total courses
            const totalCoursesElement = document.getElementById('totalCoursesCount');
            if (totalCoursesElement) {
                totalCoursesElement.textContent = stats.totalCourses;
            }

            // Update active courses
            const activeCoursesElement = document.getElementById('activeCoursesCount');
            if (activeCoursesElement) {
                activeCoursesElement.textContent = stats.activeCourses;
            }

            // Update draft courses
            const draftCoursesElement = document.getElementById('draftCoursesCount');
            if (draftCoursesElement) {
                draftCoursesElement.textContent = stats.draftCourses;
            }

            // Update inactive courses
            const inactiveCoursesElement = document.getElementById('inactiveCoursesCount');
            if (inactiveCoursesElement) {
                inactiveCoursesElement.textContent = stats.inactiveCourses;
            }

            // Update total enrollments
            const totalEnrollmentsElement = document.getElementById('totalEnrollmentsCount');
            if (totalEnrollmentsElement) {
                totalEnrollmentsElement.textContent = stats.totalEnrollments;
            }
        }

        // Debounce function to limit how often search is performed
        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }

        // Update the viewCourse function to properly populate the modal
function viewCourse(courseCode) {
    if (typeof courseCode !== 'string') {
        courseCode = courseCode.toString();
    }

    $.ajax({
        type: "POST",
        url: "Course.aspx/GetCourseDetails",
        data: JSON.stringify({ courseCode: courseCode }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            if (response.d.success) {
                const courseData = response.d.data;
                
                // Update course header info
                document.getElementById('viewCourseName').textContent = courseData.courseName;
                document.getElementById('viewCourseCode').textContent = courseData.courseCode;
                document.getElementById('viewCredits').textContent = courseData.credits;
                
                // Update status badge with proper color
                const statusBadge = document.getElementById('viewStatusBadge');
                if (statusBadge) {
                    statusBadge.className = `status-badge bg-${getStatusColor(courseData.status)}`;
                    statusBadge.innerHTML = `<i class="fas fa-${getStatusIcon(courseData.status)} me-1"></i>${courseData.status}`;
                }
                
                // Update enrollment info
                document.getElementById('viewEnrolled').textContent = courseData.enrolledCount;
                document.getElementById('viewEnrolledCount').textContent = courseData.enrolledCount;
                
                // Update department and instructor
                document.getElementById('viewDepartment').textContent = courseData.department;
                document.getElementById('viewInstructor').textContent = courseData.instructor;
                
                // Update description
                document.getElementById('viewCourseDescription').textContent = 
                    courseData.description || 'No description available';
                
                // Update dates
                document.getElementById('viewStartDate').textContent = 
                    formatDate(courseData.startDate) || 'Not set';
                document.getElementById('viewEndDate').textContent = 
                    formatDate(courseData.endDate) || 'Not set';
                
                // Update credits in statistics
                document.getElementById('viewCreditsValue').textContent = courseData.credits;
                
                // Show the modal
                const viewModal = document.getElementById('viewCourseModal');
                if (viewModal) {
                    const modal = new bootstrap.Modal(viewModal);
                    modal.show();
                }
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: response.d.message || 'Failed to load course details'
                });
            }
        },
        error: function(xhr, status, error) {
            console.error('Error loading course details:', error);
            Swal.fire({
                icon: 'error',
                title: 'Server Error!',
                text: 'An error occurred while loading course details.'
            });
        }
    });
}

// Helper function to format dates
function formatDate(dateString) {
    if (!dateString) return null;
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
}
        
        // Generic function to safely hide any modal
        function safeHideModal(modalId) {
            try {
                const modalElement = document.getElementById(modalId);
                if (!modalElement) {
                    console.error(`Modal element not found: ${modalId}`);
                    return false;
                }
                
                // Handle focus properly before hiding modal
                const focusedElement = document.activeElement;
                if (focusedElement && modalElement.contains(focusedElement)) {
                    // Remove focus from any focused element inside the modal
                    focusedElement.blur();
                    // Focus on body to prevent accessibility issues
                    document.body.focus();
                }
                
                // Method 1: Use stored instance if available
                const storedInstanceName = modalId + 'Instance';
                if (window[storedInstanceName]) {
                    try {
                        window[storedInstanceName].hide();
                        console.log(`Modal ${modalId} hidden using stored instance`);
                        return true;
                    } catch (error) {
                        console.warn(`Failed to hide modal ${modalId} with stored instance:`, error);
                    }
                }
                
                // Method 2: Try creating a new Bootstrap 5 modal instance
                if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                    try {
                        const modal = new bootstrap.Modal(modalElement);
                        modal.hide();
                        console.log(`Modal ${modalId} hidden using Bootstrap 5`);
                        return true;
                    } catch (error) {
                        console.warn(`Failed to hide modal ${modalId} with Bootstrap 5:`, error);
                    }
                }
                
                // Method 3: Try jQuery modal
                if (typeof $ !== 'undefined' && $.fn && $.fn.modal) {
                    try {
                        $(modalElement).modal('hide');
                        console.log(`Modal ${modalId} hidden using jQuery modal`);
                        return true;
                    } catch (error) {
                        console.warn(`Failed to hide modal ${modalId} with jQuery:`, error);
                    }
                }
                
                // Method 4: Manual DOM approach
                try {
                    console.log(`Using manual approach to hide modal ${modalId}`);
                    
                    // Hide modal
                    modalElement.style.display = 'none';
                    modalElement.classList.remove('show');
                    
                    // Remove backdrop if it exists
                    const backdrop = document.querySelector('.modal-backdrop');
                    if (backdrop) {
                        backdrop.remove();
                    }
                    
                    // Remove modal-open class from body
                    document.body.classList.remove('modal-open');
                    document.body.style.overflow = '';
                    document.body.style.paddingRight = '';
                    
                    return true;
                    
                } catch (error) {
                    console.error(`All approaches to hide modal ${modalId} failed:`, error);
                    return false;
                }
            } catch (ex) {
                console.error(`Exception in safeHideModal for ${modalId}:`, ex);
                return false;
            }
        }
        
        // Debug function to inspect modal state
        function debugModalState() {
            console.log('=== Modal Debug Information ===');
            
            const modal = document.getElementById('addCourseModal');
            console.log('Modal element:', modal);
            
            if (modal) {
                console.log('Modal properties:');
                console.log('- innerHTML length:', modal.innerHTML.length);
                console.log('- className:', modal.className);
                console.log('- style.display:', modal.style.display);
                console.log('- computed display:', window.getComputedStyle(modal).display);
                console.log('- offsetHeight:', modal.offsetHeight);
                console.log('- offsetWidth:', modal.offsetWidth);
                
                // Check if modal content is being dynamically modified
                console.log('- innerHTML preview (first 1000 chars):', modal.innerHTML.substring(0, 1000));
                
                const modalDialog = modal.querySelector('.modal-dialog');
                console.log('Modal dialog:', modalDialog);
                
                const modalContent = modal.querySelector('.modal-content');
                console.log('Modal content:', modalContent);
                
                const modalBody = modal.querySelector('.modal-body');
                console.log('Modal body:', modalBody);
                
                if (modalBody) {
                    console.log('Modal body properties:');
                    console.log('- innerHTML length:', modalBody.innerHTML.length);
                    console.log('- children count:', modalBody.children.length);
                    console.log('- innerHTML preview:', modalBody.innerHTML.substring(0, 500));
                    
                    Array.from(modalBody.children).forEach((child, i) => {
                        console.log(`Child ${i}:`, child.tagName, child.id, child.className);
                        if (child.tagName === 'FORM') {
                            console.log(`  Form details - ID: ${child.id}, Name: ${child.name}, Action: ${child.action}`);
                            console.log(`  Form children: ${child.children.length}`);
                        }
                    });
                }
                
                // Check if there are any forms anywhere in the modal
                const allFormsInModal = modal.querySelectorAll('form');
                console.log('All forms in modal:', allFormsInModal.length);
                allFormsInModal.forEach((form, i) => {
                    console.log(`Form ${i} in modal:`, form.id, form.tagName, form.parentElement.tagName);
                });
                
                // Check for specific form
                const specificForm = modal.querySelector('#addCourseForm');
                console.log('Specific addCourseForm lookup:', specificForm);
                
                // Check if form exists but is hidden
                const hiddenForms = modal.querySelectorAll('form[style*="display: none"], form[hidden]');
                console.log('Hidden forms in modal:', hiddenForms.length);
            }
            
            console.log('All forms on page:');
            const allForms = document.querySelectorAll('form');
            allForms.forEach((form, i) => {
                const parent = form.parentElement;
                const grandParent = parent ? parent.parentElement : null;
                console.log(`Form ${i}:`, form.id, form.className, 
                          `Parent: ${parent?.tagName}#${parent?.id}`, 
                          `GrandParent: ${grandParent?.tagName}#${grandParent?.id}`);
            });
            
            console.log('=== End Modal Debug ===');
        }

        

// Add this function before the openAddCourseModal function
function safeShowModal(modalId) {
    try {
        console.log(`Attempting to show modal: ${modalId}`);
        const modalElement = document.getElementById(modalId);
        
        if (!modalElement) {
            console.error(`Modal element not found: ${modalId}`);
            return false;
        }

        // Remove any existing backdrops
        document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
        
        // Remove fade classes and transitions
        modalElement.classList.remove('fade');
        modalElement.style.transition = 'none';
        modalElement.style.animation = 'none';
        
        // Try different methods to show the modal
        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
            try {
                // Method 1: Use Bootstrap Modal
                const modal = new bootstrap.Modal(modalElement, {
                    backdrop: false,
                    keyboard: false
                });
                modal.show();
                console.log('Modal shown using Bootstrap Modal');
                return true;
            } catch (bootstrapError) {
                console.warn('Bootstrap Modal show failed:', bootstrapError);
            }
        }
        
        // Method 2: Manual DOM manipulation
        try {
            modalElement.style.display = 'block';
            modalElement.classList.add('show');
            document.body.classList.add('modal-open');
            console.log('Modal shown using manual DOM manipulation');
            return true;
        } catch (domError) {
            console.error('Manual modal show failed:', domError);
            return false;
        }
    } catch (error) {
        console.error(`Error showing modal ${modalId}:`, error);
        return false;
    }
}


// Also add this wrapper function for the Add Course form
function wrapFormInModal() {
    const modalBody = document.querySelector('#addCourseModal .modal-body');
    const modalFooter = document.querySelector('#addCourseModal .modal-footer');
    
    if (modalBody && modalFooter) {
        // Create the form element
        const form = document.createElement('form');
        form.id = 'addCourseForm';
        form.className = 'needs-validation';
        form.setAttribute('novalidate', '');
        
        // Move modal body content into form
        while (modalBody.firstChild) {
            form.appendChild(modalBody.firstChild);
        }
        
        // Move modal footer content into form
        while (modalFooter.firstChild) {
            form.appendChild(modalFooter.firstChild);
        }
        
        // Add form to modal body
        modalBody.appendChild(form);
        
        console.log('Form wrapper added successfully');
        return true;
    }
    
    console.error('Could not find modal body or footer');
    return false;
}

// Call this when the document is ready
document.addEventListener('DOMContentLoaded', function() {

     let searchTimeout;
        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(filterCourses, 300);
        }
    wrapFormInModal();

    // Initialize form references
    initFormReferences();
    
    // Safe event listener addition
    const searchInput = document.getElementById('courseSearch');
    if (searchInput) {
        searchInput.addEventListener('input', debounceSearch);
    } else {
        console.warn('Search input not found');
    }
    
    // Load initial data
    setTimeout(() => {
        loadCourses();
        loadCourseStatistics();
    }, 100);

});

        // Enhanced modal opening function with debugging
        function openAddCourseModal(event) {
    if (event) {
        event.preventDefault();
    }
    
    // Ensure the modal content is properly structured
    const modalElement = document.getElementById('addCourseModal');
    if (!modalElement) {
        console.error('Add Course modal not found');
        return;
    }

    // Reset form and clear validation before showing
    const form = document.getElementById('addCourseForm');
    if (form) {
        form.reset();
        clearFormValidation('addCourseForm');
    }

    try {
        // Try Bootstrap modal
        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
            const modal = new bootstrap.Modal(modalElement);
            modal.show();
        } else {
            // Fallback to manual show
            modalElement.style.display = 'block';
            modalElement.classList.add('show');
            document.body.classList.add('modal-open');
        }
    } catch (error) {
        console.error('Error showing modal:', error);
    }
} 
        // Helper function to clear all validation state
        function clearAllValidation() {
            const formInputs = document.querySelectorAll('#addCourseModal input, #addCourseModal select, #addCourseModal textarea');
            formInputs.forEach(input => {
                input.classList.remove('is-valid', 'is-invalid');
                const feedback = input.parentNode.querySelector('.invalid-feedback');
                if (feedback) {
                    feedback.remove();
                }
            });
        }
        
document.addEventListener('DOMContentLoaded', function() {

     let searchTimeout;
        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(filterCourses, 300);
        }
    const addCourseModal = document.getElementById('addCourseModal');
    const closeBtn = addCourseModal ? addCourseModal.querySelector('.btn-close') : null;

    if (closeBtn && addCourseModal) {
    closeBtn.addEventListener('click', function (e) {
        e.preventDefault();

        // Reset the form
        resetCourseForm('addCourseForm');

        // Bootstrap 5 way (native JS API)
        if (window.bootstrap && bootstrap.Modal && typeof bootstrap.Modal.getInstance === 'function') {
            let modalInstance = bootstrap.Modal.getInstance(addCourseModal);
            if (!modalInstance) {
                modalInstance = new bootstrap.Modal(addCourseModal);
            }
            modalInstance.hide();
        }
        // Bootstrap 4 way (jQuery API)
        else if (window.jQuery) {
            $('#addCourseModal').modal('hide');
        }
        // Manual fallback
        else {
            addCourseModal.style.display = 'none';
            addCourseModal.classList.remove('show');
            document.body.classList.remove('modal-open');
            document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
        }

        // Handle accessibility
        addCourseModal.removeAttribute('aria-hidden');
        addCourseModal.setAttribute('inert', '');

        // Return focus to a visible element
        setTimeout(() => {
            const focusable = document.querySelector(
                'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
            );
            if (focusable) {
                focusable.focus();
            } else {
                document.body.focus();
            }
        }, 200);
    });
}
        });

        // Function to reset the course form
        function resetCourseForm(formId) {
            const form = document.getElementById(formId);
            if (form) {
                form.reset();
                clearAllValidation();
            }
        }

        // Function to initialize form references
        function initFormReferences() {
            const form = document.getElementById('addCourseForm');
            if (form) {
                console.log('Form initialized:', form);
            } else {
                console.error('Form not found: addCourseForm');
            }
        }

   // Fixed Theme Application - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            
 let searchTimeout;
        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(filterCourses, 300);
        }
            // Apply fixed custom theme
            console.log('Fixed custom theme applied to Course.aspx');

            // GLOBAL BACKDROP CLEANUP FUNCTION
            function removeAllBackdrops() {
                const backdrops = document.querySelectorAll('.modal-backdrop');
                backdrops.forEach(backdrop => {
                    backdrop.remove();
                });
                // Also remove any backdrop classes from body
                document.body.classList.remove('modal-open');
                document.body.style.overflow = '';
                document.body.style.paddingRight = '';
            }

            // Force remove all fade classes from modals to ensure instant display
            const allModals = document.querySelectorAll('.modal');
            allModals.forEach(modal => {
                modal.classList.remove('fade');
                modal.style.transition = 'none';
                modal.style.animation = 'none';
            });

            // Run backdrop cleanup on page load
            removeAllBackdrops();
            
            // Set up interval to continuously clean up backdrops
            setInterval(removeAllBackdrops, 100);

            // Completely override Bootstrap modal behavior to disable fade
            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                const originalModal = bootstrap.Modal;
                bootstrap.Modal = function(element, options) {
                    options = options || {};
                    options.backdrop = true;
                    options.keyboard = true;
                    options.focus = true;
                    // Force no animation/fade
                    const modal = new originalModal(element, options);
                    
                    // Override show/hide methods to remove transitions
                    const originalShow = modal.show;
                    const originalHide = modal.hide;
                    
                    modal.show = function() {
                        const modalElement = this._element;
                        modalElement.style.transition = 'none';
                        modalElement.style.animation = 'none';
                        modalElement.classList.remove('fade');
                        return originalShow.call(this);
                    };
                    
                    modal.hide = function() {
                        const modalElement = this._element;
                        modalElement.style.transition = 'none';
                        modalElement.style.animation = 'none';
                        return originalHide.call(this);
                    };
                    
                    return modal;
                };
                
                // Override default options
                bootstrap.Modal.Default = bootstrap.Modal.Default || {};
                bootstrap.Modal.Default.backdrop = true;
                bootstrap.Modal.Default.keyboard = true;
                bootstrap.Modal.Default.focus = true;
            }
            
            // Alternative: Direct DOM manipulation approach
            const manipulationstyle = document.createElement('style');
            manipulationstyle.textContent = `
                .modal.fade { transition: none !important; opacity: 1 !important; }
                .modal.fade .modal-dialog { transform: none !important; transition: none !important; }
                .modal-backdrop.fade { transition: none !important; opacity: 0.5 !important; }
                .modal { display: none !important; }
                .modal.show { display: block !important; opacity: 1 !important; }
            `;
            document.head.appendChild(manipulationstyle);
            
            // Load courses on page load
            loadCourses();
            loadCourseStatistics();
            
            // Add event listeners for search and filters
            const searchInput = document.getElementById('courseSearch');
            const statusFilter = document.getElementById('statusFilter');
            const departmentFilter = document.getElementById('departmentFilter');
            
            if (searchInput) {
                searchInput.addEventListener('input', debounceSearch);
            }
            
            if (statusFilter) {
                statusFilter.addEventListener('change', filterCourses);
            }
            
            if (departmentFilter) {
                departmentFilter.addEventListener('change', filterCourses);
            }

            // COMPLETELY DISABLE MODAL BACKDROP AND FADE EFFECTS
            // Add Course Modal Event Listeners
            const addCourseModal = document.getElementById('addCourseModal');
            if (addCourseModal) {
                // Remove fade class and disable transitions immediately
                addCourseModal.classList.remove('fade');
                addCourseModal.style.transition = 'none';
                addCourseModal.style.animation = 'none';
                
                // Override Bootstrap modal initialization to disable backdrop
                addCourseModal.addEventListener('show.bs.modal', function (e) {
                    // Remove any existing backdrops
                    const existingBackdrops = document.querySelectorAll('.modal-backdrop');
                    existingBackdrops.forEach(backdrop => backdrop.remove());
                    
                    // Disable all transitions and animations
                    this.classList.remove('fade');
                    this.style.transition = 'none';
                    this.style.animation = 'none';
                    this.style.opacity = '1';
                    this.style.display = 'block';
                    
                    const dialog = this.querySelector('.modal-dialog');
                    if (dialog) {
                        dialog.style.transition = 'none';
                        dialog.style.transform = 'none';
                        dialog.style.animation = 'none';
                    }
                });
                
                addCourseModal.addEventListener('shown.bs.modal', function () {
                    // Remove any backdrops that might have been created
                    const backdrops = document.querySelectorAll('.modal-backdrop');
                    backdrops.forEach(backdrop => backdrop.remove());
                    
                    // Ensure modal is fully visible
                    this.style.opacity = '1';
                    this.style.display = 'block';
                    
                    // Focus on first input when modal opens
                    document.getElementById('courseCode').focus();
                });
                
                addCourseModal.addEventListener('hidden.bs.modal', function () {
                    // Clear form when modal is closed
                    document.getElementById('addCourseForm').reset();
                    // Remove validation classes
                    clearFormValidation('addCourseForm');
                    
                    // Clean up any remaining backdrops
                    const backdrops = document.querySelectorAll('.modal-backdrop');
                    backdrops.forEach(backdrop => backdrop.remove());
                });
            }

            // Apply same backdrop-disabling treatment to all other modals
            const alModals = ['editCourseModal', 'viewCourseModal', 'deleteCourseModal'];
            alModals.forEach(modalId => {
                const modalElement = document.getElementById(modalId);
                if (modalElement) {
                    modalElement.classList.remove('fade');
                    modalElement.style.transition = 'none';
                    modalElement.style.animation = 'none';
                    
                    modalElement.addEventListener('show.bs.modal', function (e) {
                        // Remove any existing backdrops
                        const existingBackdrops = document.querySelectorAll('.modal-backdrop');
                        existingBackdrops.forEach(backdrop => backdrop.remove());
                        
                        // Disable all transitions and animations
                        this.classList.remove('fade');
                        this.style.transition = 'none';
                        this.style.animation = 'none';
                        this.style.opacity = '1';
                        this.style.display = 'block';
                        
                        const dialog = this.querySelector('.modal-dialog');
                        if (dialog) {
                            dialog.style.transition = 'none';
                            dialog.style.transform = 'none';
                            dialog.style.animation = 'none';
                        }
                    });
                    
                    modalElement.addEventListener('shown.bs.modal', function () {
                        // Remove any backdrops that might have been created
                        const backdrops = document.querySelectorAll('.modal-backdrop');
                        backdrops.forEach(backdrop => backdrop.remove());
                        
                        // Ensure modal is fully visible
                        this.style.opacity = '1';
                        this.style.display = 'block';
                    });
                    
                    modalElement.addEventListener('hidden.bs.modal', function () {
                        // Clean up any remaining backdrops
                        const backdrops = document.querySelectorAll('.modal-backdrop');
                        backdrops.forEach(backdrop => backdrop.remove());
                    });
                }
            });

            // Add real-time validation
            addFormValidation();
        });


        <%-- function filterCoursesEnhanced() {
            
        } --%>

document.addEventListener('DOMContentLoaded', function() {
    
 let searchTimeout;
        function debounceSearch() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(filterCourses, 300);
        }
            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Enhanced search listeners
            document.getElementById('courseSearch').addEventListener('input', debounceSearch);
            document.getElementById('statusFilter').addEventListener('change', filterCoursesEnhanced);
            document.getElementById('departmentFilter').addEventListener('change', filterCoursesEnhanced);
            
            // Add form validation feedback
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('input', function(e) {
                    if (e.target.checkValidity()) {
                        e.target.classList.remove('is-invalid');
                        e.target.classList.add('is-valid');
                    } else {
                        e.target.classList.remove('is-valid');
                        e.target.classList.add('is-invalid');
                    }
                });
            });

        // Real-time search with debouncing
       
        
        
        // Enhanced filter function with smooth animations
        function filterCoursesEnhanced() {
            filterCourses();
            const searchTerm = document.getElementById('courseSearch').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const departmentFilter = document.getElementById('departmentFilter').value;
            
            const table = document.getElementById('courseTable');
            if (!table) {
        console.error('Course table not found');
        return;
    }
    const tbody = table.getElementsByTagName('tbody')[0];
    if (!tbody) {
        console.error('Table body not found');
        return;
    }
            const rows = tbody.getElementsByTagName('tr');
    let visibleCount = 0;
    
<%--             
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const courseCode = row.cells[0].textContent.toLowerCase();
                const courseName = row.cells[1].textContent.toLowerCase();
                const department = row.cells[2].textContent.toLowerCase();
                const status = row.cells[6].textContent.toLowerCase().trim();
                
                const matchesSearch = courseCode.includes(searchTerm) || courseName.includes(searchTerm);
                const matchesStatus = !statusFilter || status === statusFilter.toLowerCase();
                const matchesDepartment = !departmentFilter || department.includes(departmentFilter.replace('-', ' '));
                
                if (matchesSearch && matchesStatus && matchesDepartment) {
                    row.style.transition = 'all 0.3s ease';
                    row.style.display = '';
                    row.style.opacity = '1';
                    row.style.transform = 'translateX(0)';
                    visibleCount++;
                } else {
                    row.style.transition = 'all 0.3s ease';
                    row.style.opacity = '0';
                    row.style.transform = 'translateX(-20px)';
                    setTimeout(() => {
                        if (row.style.opacity === '0') {
                            row.style.display = 'none';
                        }
                    }, 300);
                }
            }
            
            // Show/hide "no results" message
            showNoResultsMessage(visibleCount === 0);
        } --%>
        
// Loop through each row with proper null checks
    Array.from(rows).forEach(row => {
        if (row.classList.contains('loading-row') || row.classList.contains('no-data-row')) {
            return; // Skip loading and no-data rows
        }

        try {
            // Safely get cell content with null checks
            const courseCode = row.cells[1]?.querySelector('.course-code-badge')?.textContent?.toLowerCase() || '';
            const courseName = row.cells[2]?.querySelector('.fw-semibold')?.textContent?.toLowerCase() || '';
            const department = row.cells[3]?.querySelector('.department-badge')?.textContent?.toLowerCase() || '';
            const status = row.cells[7]?.querySelector('.status-badge')?.textContent?.toLowerCase()?.trim() || '';

            // Check if row matches all filters
            const matchesSearch = !searchTerm || 
                courseCode.includes(searchTerm) || 
                courseName.includes(searchTerm);
            const matchesStatus = !statusFilter || 
                status === statusFilter.toLowerCase();
            const matchesDepartment = !departmentFilter || 
                department.includes(departmentFilter.toLowerCase().replace('-', ' '));

            // Apply visibility with animation
            if (matchesSearch && matchesStatus && matchesDepartment) {
                row.style.transition = 'all 0.3s ease';
                row.style.display = '';
                row.style.opacity = '1';
                row.style.transform = 'translateX(0)';
                visibleCount++;
            } else {
                row.style.transition = 'all 0.3s ease';
                row.style.opacity = '0';
                row.style.transform = 'translateX(-20px)';
                setTimeout(() => {
                    if (row.style.opacity === '0') {
                        row.style.display = 'none';
                    }
                }, 300);
            }
        } catch (error) {
            console.error('Error processing row:', error);
            // Keep row visible if there's an error
            row.style.display = '';
            visibleCount++;
        }
    });
    
    // Show/hide "no results" message
    //showNoResultsMessage(visibleCount === 0);
}

        function showNoResultsMessage(show) {
            let noResultsRow = document.getElementById('noResultsRow');
            
            if (show && !noResultsRow) {
                const tableBody = document.querySelector('#courseTable tbody');
                noResultsRow = document.createElement('tr');
                noResultsRow.id = 'noResultsRow';
                noResultsRow.innerHTML = `
                    <td colspan="8" class="text-center py-4">
                        <div class="text-muted">
                            <i class="fa fa-search fa-2x mb-2"></i>
                            <h5>No courses found</h5>
                            <p>Try adjusting your search criteria</p>
                        </div>
                    </td>
                `;
                tableBody.appendChild(noResultsRow);
            } else if (!show && noResultsRow) {
                noResultsRow.remove();
            }
        }
        

    // Initialize all modals
    function initializeModals() {
        const modals = ['addCourseModal', 'editCourseModal', 'viewCourseModal', 'deleteCourseModal'];
        modals.forEach(modalId => {
            const modalElement = document.getElementById(modalId);
            if (modalElement) {
                // Remove fade effects
                modalElement.classList.remove('fade');
                modalElement.style.transition = 'none';
                modalElement.style.animation = 'none';
            
            // Initialize Bootstrap modal
            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                try {
                    window[modalId + 'Instance'] = new bootstrap.Modal(modalElement, {
                        backdrop: false,
                        keyboard: false
                    });
                } catch (err) {
                    console.error(`Failed to initialize ${modalId}:`, err);
                }
            }

            // Add event listeners
            modalElement.addEventListener('show.bs.modal', function(e) {
                this.classList.remove('fade');
                this.style.display = 'block';
                document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
            });

            modalElement.addEventListener('shown.bs.modal', function() {
                this.style.display = 'block';
                document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
            });

            modalElement.addEventListener('hidden.bs.modal', function() {
                document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
                if (modalId === 'addCourseModal') {
                    resetCourseForm('addCourseForm');
                }
            });
        }
    })

    // Add close button handler for Add Course modal
    const addCourseModal = document.getElementById('addCourseModal');
    const closeBtn = addCourseModal?.querySelector('.btn-close');
    if (closeBtn && addCourseModal) {
        closeBtn.addEventListener('click', function(e) {
            e.preventDefault();
            resetCourseForm('addCourseForm');
            safeHideModal('addCourseModal');
        });
    }

    // Add real-time validation
    addFormValidation();
}
});


function updateSelectAllCheckbox() {
    const courseCheckboxes = document.querySelectorAll('.course-checkbox');
    const selectAllCheckbox = document.getElementById('selectAll');
    if (!selectAllCheckbox) return;

    const checkedCount = Array.from(courseCheckboxes).filter(cb => cb.checked).length;
    selectAllCheckbox.checked = checkedCount === courseCheckboxes.length && checkedCount > 0;
    selectAllCheckbox.indeterminate = checkedCount > 0 && checkedCount < courseCheckboxes.length;
}

        // Function to handle individual row checkbox changes
        function handleRowCheckboxChange() {
            const checkboxes = document.querySelectorAll('.course-row-checkbox');
            const selectAllCheckbox = document.getElementById('selectAll');
            const bulkActionBtn = document.getElementById('bulkActionBtn');
            const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
            
            // Check if all checkboxes are checked
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            const anyChecked = Array.from(checkboxes).some(cb => cb.checked);
            
            // Update select all checkbox
            selectAllCheckbox.checked = allChecked;
            
            // Enable/disable bulk action buttons
            bulkActionBtn.disabled = !anyChecked;
            bulkDeleteBtn.disabled = !anyChecked;
        }

            // Function to toggle all checkboxes in the table
 // Bulk Actions Management
      function toggleSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAll');
    const courseCheckboxes = document.querySelectorAll('.course-checkbox');
    courseCheckboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
    toggleBulkActions();
    updateSelectAllCheckbox(); // <-- Add this line
}



        function bulkStatusUpdate() {
            const checkedBoxes = document.querySelectorAll('.course-checkbox:checked');
            const courseIds = Array.from(checkedBoxes).map(cb => cb.value);
            
            if (courseIds.length === 0) {
                showToast('Please select courses to update', 'warning');
                return;
            }

            Swal.fire({
                title: 'Update Course Status',
                text: `Update status for ${courseIds.length} selected course(s)?`,
                input: 'select',
                inputOptions: {
                    'active': 'Active',
                    'inactive': 'Inactive',
                    'draft': 'Draft'
                },
                inputPlaceholder: 'Select new status',
                showCancelButton: true,
                confirmButtonText: 'Update Status',
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#6c757d',
                showLoaderOnConfirm: true,
                preConfirm: (status) => {
                    if (!status) {
                        Swal.showValidationMessage('Please select a status');
                        return false;
                    }
                    return status;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    showGlobalLoading();
                    
                    // Prepare data for server
                    const updateData = {
                        courseIds: courseIds,
                        newStatus: result.value
                    };
                    
                    // Call server-side method for bulk status update
                    $.ajax({
                        type: "POST",
                        url: "Course.aspx/BulkUpdateCourseStatus",
                        data: JSON.stringify({
                                request: {
                                courseIds: courseIds,
                                newStatus: result.value
                                }
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function(response) {
                            hideGlobalLoading();
                            
                            if (response.d && response.d.success) {
                                // Show success message
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Status Updated!',
                                    text: `Successfully updated ${courseIds.length} course(s) to ${result.value}`,
                                    timer: 3000,
                                    timerProgressBar: true
                                });
                                
                                // Refresh the course table to show updated statuses
                                loadCourses();
                                loadCourseStatistics();
                                
                                // Clear selections
                                document.querySelectorAll('.course-checkbox:checked').forEach(cb => cb.checked = false);
                                document.getElementById('selectAll').checked = false;
                                toggleBulkActions();
                                
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Update Failed',
                                    text: response.d ? response.d.message : 'Failed to update course statuses'
                                });
                            }
                        },
                        error: function(xhr, status, error) {
                            hideGlobalLoading();
                            console.error('Error updating course statuses:', error);
                            
                            // Fallback: Update UI optimistically for demo
                            updateCoursesStatusInTable(courseIds, result.value);
                            showToast(`Updated ${courseIds.length} course(s) to ${result.value} (Demo mode)`, 'success');
                            
                            // Clear selections
                            document.querySelectorAll('.course-checkbox:checked').forEach(cb => cb.checked = false);
                            document.getElementById('selectAll').checked = false;
                            toggleBulkActions();
                        }
                    });
                }
            });
        }

function bulkDelete() {
    const checkedBoxes = document.querySelectorAll('.course-checkbox:checked');
    const courseIds = Array.from(checkedBoxes).map(cb => cb.value);

    if (courseIds.length === 0) {
        showToast('Please select courses to delete', 'warning');
        return;
    }

    Swal.fire({
        title: 'Delete Selected Courses?',
        text: `Are you sure you want to delete ${courseIds.length} selected course(s)? This action cannot be undone!`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Yes, delete them!',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            showGlobalLoading();

            // Prepare data for server
            const deleteData = {
                request: {
                    courseIds: courseIds
                }
            };

            // Call server-side method for bulk delete
            $.ajax({
                type: "POST",
                url: "Course.aspx/BulkDeleteCourses",
                data: JSON.stringify(deleteData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    hideGlobalLoading();

                    if (response.d && response.d.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Courses Deleted!',
                            text: `Successfully deleted ${courseIds.length} course(s).`,
                            timer: 3000,
                            timerProgressBar: true
                        });

                        // Refresh the course table and statistics
                        loadCourses();
                        loadCourseStatistics();

                        // Clear selections
                        document.querySelectorAll('.course-checkbox:checked').forEach(cb => cb.checked = false);
                        document.getElementById('selectAll').checked = false;
                        toggleBulkActions();
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Delete Failed',
                            text: response.d ? response.d.message : 'Failed to delete courses'
                        });
                    }
                },
                error: function(xhr, status, error) {
                    hideGlobalLoading();
                    console.error('Error deleting courses:', error);
                    showToast('An error occurred while deleting courses.', 'error');
                }
            });
        }
    });
}


function toggleBulkActions() {
    const checkedBoxes = document.querySelectorAll('.course-checkbox:checked');
    const bulkActionBtn = document.getElementById('bulkActionBtn');
    const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
    if (bulkActionBtn) bulkActionBtn.disabled = checkedBoxes.length === 0;
    if (bulkDeleteBtn) bulkDeleteBtn.disabled = checkedBoxes.length === 0;
}


function updateCoursesStatusInTable(courseIds, newStatus) {
    const tableBody = document.getElementById('courseTableBody');
    if (!tableBody) return;
    Array.from(tableBody.querySelectorAll('tr')).forEach(row => {
        const codeCell = row.querySelector('.course-code-badge strong');
        if (codeCell && courseIds.includes(codeCell.textContent.trim())) {
            // Update status badge
            const statusCell = row.querySelector('.status-badge');
            if (statusCell) {
                statusCell.textContent = newStatus;
                statusCell.className = `badge bg-${getStatusColor(newStatus)} status-badge`;
            }
        }
    });
}

        // Function to handle course filtering by status and department
        function filterCourses() {
            const searchTerm = document.getElementById('courseSearch').value.trim();
            const statusFilter = document.getElementById('statusFilter').value;
            const departmentFilter = document.getElementById('departmentFilter').value;
            
            // Show loading in table
            const tableBody = document.querySelector('#courseTableBody');
            tableBody.innerHTML = `
                <tr class="loading-row">
                    <td colspan="9" class="text-center py-4">
                        <div class="d-flex justify-content-center align-items-center">
                            <div class="spinner-border spinner-border-sm text-primary me-2" role="status">
                                <span class="visually-hidden">Searching...</span>
                            </div>
                            Searching courses...
                        </div>
                    </td>
                </tr>
            `;
            
            $.ajax({
                type: "POST",
                url: "Course.aspx/SearchCourses",
                data: JSON.stringify({
                    searchTerm: searchTerm,
                    department: departmentFilter,
                    status: statusFilter
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d.success) {
                        populateCourseTable(response.d.data);
                        
                        // Show search results feedback
                        if (searchTerm || statusFilter || departmentFilter) {
                            showToast(`Found ${response.d.data.length} course(s) matching your criteria`, 'info');
                        }
                    } else {
                        console.error('Failed to filter courses:', response.d.message);
                        showToast('Failed to filter courses. Please try again.', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error filtering courses:', error);
                    showToast('Search failed. Please check your connection and try again.', 'error');
                    // Show error state in table
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="9" class="text-center py-4 text-danger">
                                <i class="fas fa-exclamation-triangle fa-2x mb-2"></i>
                                <br>Failed to load courses. Please refresh the page.
                            </td>
                        </tr>
                    `;
                }
            });
        }
// Make sure all JavaScript is properly enclosed in script tags

   function editCourseFromView() {
    const viewModalElement = document.getElementById('viewCourseModal');

    // Bootstrap 5 way
    if (window.bootstrap && bootstrap.Modal && typeof bootstrap.Modal.getInstance === 'function') {
        const viewModal = bootstrap.Modal.getInstance(viewModalElement);
        if (viewModal) {
            viewModal.hide();
        }
    }
    // Bootstrap 4 way
    else if (window.jQuery) {
        $('#viewCourseModal').modal('hide');
    }
    // Manual fallback
    else {
        viewModalElement.style.display = 'none';
        viewModalElement.classList.remove('show');
        document.body.classList.remove('modal-open');
        document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
    }

    // Open edit modal with the same course
    if (window.currentViewingCourse) {
        setTimeout(() => {
            editCourse(window.currentViewingCourse);
        }, 300);
    }
}

        
        function editCourse(courseCode) {
            // Load course details from server
            $.ajax({
                type: "POST",
                url: "Course.aspx/GetCourseDetails",
                data: JSON.stringify({ courseCode: courseCode }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d.success) {
                        const courseData = response.d.data;
                        
                        // Populate edit form with course data
                        document.getElementById('editCourseCode').value = courseData.courseCode;
                        document.getElementById('editCourseName').value = courseData.courseName;
                        if(courseData.departmentId != 0){
                        document.getElementById('editDepartment').value = courseData.departmentId;
                        }else{
                            document.getElementById('editDepartment').selectedIndex = 0;
                        }
                        document.getElementById('editCredits').value = courseData.credits;
                        if(courseData.instructorId != 0){
                        document.getElementById('editInstructor').value = courseData.instructorId;
                        }else{
                            document.getElementById('editInstructor').selectedIndex = 0;
                        }
                        document.getElementById('editCourseStatus').value = courseData.status;
                        document.getElementById('editCourseDescription').value = courseData.description || '';
                        document.getElementById('editStartDate').value = courseData.startDate || '';
                        document.getElementById('editEndDate').value = courseData.endDate || '';
                        
                        // Store original course code for updates
                        window.editingCourseCode = courseData.courseCode;
                        
                        // Show edit modal
                        const editModal = new bootstrap.Modal(document.getElementById('editCourseModal'));
                        editModal.show();
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: response.d.message
                        });
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Server Error!',
                        text: 'An error occurred while loading course details.'
                    });
                }
            });
        }
                
        
        function updateCourse() {
            const form = document.getElementById('editCourseForm');
            if (form.checkValidity()) {
                const formData = {
                    courseCode: window.editingCourseCode, // Use the original course code
                    courseName: document.getElementById('editCourseName').value,
                    department: document.getElementById('editDepartment').value,
                    credits: parseInt(document.getElementById('editCredits').value),
                    instructor: document.getElementById('editInstructor').value,
                    status: document.getElementById('editCourseStatus').value,
                    description: document.getElementById('editCourseDescription').value,
                    startDate: document.getElementById('editStartDate').value,
                    endDate: document.getElementById('editEndDate').value
                };
                
                $.ajax({
                    type: "POST",
                    url: "Course.aspx/UpdateCourse",
                    data: JSON.stringify(formData),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response.d.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Course Updated!',
                                text: response.d.message,
                                timer: 3000,
                                timerProgressBar: true
                            });

                            //HMMM
                            // Close modal
const editCourseModalElement = document.getElementById('editCourseModal');

// Bootstrap 5 way (native API)
if (window.bootstrap && bootstrap.Modal && typeof bootstrap.Modal.getInstance === 'function') {
    const modalInstance = bootstrap.Modal.getInstance(editCourseModalElement) 
                       || new bootstrap.Modal(editCourseModalElement);
    modalInstance.hide();
}
// Bootstrap 4 way (jQuery API)
else if (window.jQuery) {
    $('#editCourseModal').modal('hide');
}
// Manual fallback
else {
    editCourseModalElement.style.display = 'none';
    editCourseModalElement.classList.remove('show');
    document.body.classList.remove('modal-open');
    document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
}

                            // Refresh the course table
                            loadCourses();
                            
                            // Update statistics
                            loadCourseStatistics();
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: response.d.message
                            });
                        }
                    },
                    error: function(xhr, status, error) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Server Error!',
                            text: 'An error occurred while updating the course.'
                        });
                    }
                });
            } else {
                form.reportValidity();
            }
        }

function validateCourseForm() {
    const form = document.getElementById('addCourseForm');
    if (!form) {
        console.error('Form not found');
        return false;
    }

    let isValid = true;
    const invalidFields = [];

    // Clear previous validation states
    form.querySelectorAll('.is-invalid').forEach(el => {
        el.classList.remove('is-invalid');
    });

    // Validate required fields
    form.querySelectorAll('[required]').forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            invalidFields.push(field.getAttribute('placeholder') || field.id);
            isValid = false;
        }
    });

    if (!isValid) {
        Swal.fire({
            icon: 'warning',
            title: 'Required Fields Missing',
            html: `
                <div class="text-left">
                    <p>Please fill in the following fields:</p>
                    <ul class="text-danger">
                        ${invalidFields.map(field => `<li>${field}</li>`).join('')}
                    </ul>
                </div>
            `
        });
    }

    return isValid;
}

        function saveCourse() {
             // Validate form first
    if (!validateCourseForm()) {
        return;
    }
         // Get form values
    const courseCode = document.getElementById('courseCode').value.trim();
    const courseName = document.getElementById('courseName').value.trim();
    const department = document.getElementById('department').value;
    const credits = document.getElementById('credits').value;
    const instructor = document.getElementById('instructor').value;
    const courseStatus = document.getElementById('courseStatus').value;
    const courseDescription = document.getElementById('courseDescription').value.trim();
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

            // Validate required fields
            if (!courseCode || !courseName || !department || !credits || !instructor || !courseStatus || !startDate || !endDate) {
                showToast('Please fill in all required fields.', 'warning');
                return;
            }

             // Validate course code format (letters and numbers)
    const codeRegex = /^[A-Z]{2,4}\d{3}$/;
    if (!codeRegex.test(courseCode)) {
        Swal.fire({
            icon: 'error',
            title: 'Invalid Course Code',
            text: 'Course code must be in format like CS101, MATH201, etc.',
            confirmButtonColor: '#d33'
        });
        return;
    }

    // Validate credits
    if (credits < 1 || credits > 6) {
        Swal.fire({
            icon: 'error',
            title: 'Invalid Credits',
            text: 'Credits must be between 1 and 6.',
            confirmButtonColor: '#d33'
        });
        return;
    }

    // Validate dates
    if (new Date(startDate) >= new Date(endDate)) {
        Swal.fire({
            icon: 'error',
            title: 'Invalid Dates',
            text: 'End date must be after start date.',
            confirmButtonColor: '#d33'
        });
        return;
    }

           // Show loading
    showGlobalLoading();

           
    // Prepare data for server
    const courseData = {
        courseCode: courseCode,
        courseName: courseName,
        department: department,
        credits: parseInt(credits),
        instructor: instructor,
        status: courseStatus,
        description: courseDescription,
        startDate: startDate,
        endDate: endDate
    };

 // Send to server
    $.ajax({
        type: "POST",
        url: "Course.aspx/AddCourse",
        data: JSON.stringify(courseData),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            hideGlobalLoading();
            if (response.d.success) {
                 // Clear all validation states
                const form = document.getElementById('addCourseForm');
                if (form) {
                    // Reset form
                    form.reset();
            resetCourseForm('addCourseForm');
                    
                    // Remove all validation classes and messages
                    const formElements = form.querySelectorAll('input, select, textarea');
                    formElements.forEach(element => {
                        element.classList.remove('is-valid', 'is-invalid');
                        
                        // Remove any feedback messages
                        const feedback = element.nextElementSibling;
                        if (feedback && feedback.classList.contains('invalid-feedback')) {
                            feedback.remove();
                        }
                    });
                } else{
            resetCourseForm('addCourseForm');

                    console.error('Failed to reset form validation');
                }

                 // Close modal safely
                try {
                    const modalElement = document.getElementById('addCourseModal');
if (modalElement) {
    // Bootstrap 5 way
    if (window.bootstrap && bootstrap.Modal && typeof bootstrap.Modal.getInstance === 'function') {
        let bsModal = bootstrap.Modal.getInstance(modalElement);
        if (!bsModal) {
            bsModal = new bootstrap.Modal(modalElement);
        }
        bsModal.hide();
    }
    // Bootstrap 4 way
    else if (window.jQuery) {
        $('#addCourseModal').modal('hide');
    }
    // Manual fallback
    else {
        modalElement.style.display = 'none';
        modalElement.classList.remove('show');
        document.body.classList.remove('modal-open');
        document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
    }
}

                } catch (error) {
                    console.warn('Modal close error:', error);
                }

                // Show success message
                Swal.fire({
                    icon: 'success',
                    title: 'Course Added!',
                    text: 'The course has been added successfully.',
                    timer: 2000,
                    showConfirmButton: false
                });

                // Reload courses and statistics
                loadCourses();
                loadCourseStatistics();
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: response.d.message || 'Failed to add course.'
                });
            }
        },
        error: function(xhr, status, error) {
            hideGlobalLoading();
            console.error('Error adding course:', error);
            Swal.fire({
                icon: 'error',
                title: 'Server Error',
                text: 'An error occurred while adding the course.'
            });
        }
    });
        }


// Add a helper function to completely clear form validation
function clearFormValidation(formId) {
    const form = document.getElementById(formId);
    if (form) {
        // Reset the form
        form.reset();
        
        // Remove all validation classes
        form.classList.remove('was-validated');
        
        // Clear all input validations
        const formElements = form.querySelectorAll('input, select, textarea');
        formElements.forEach(element => {
            // Remove validation classes
            element.classList.remove('is-valid', 'is-invalid');
            
            // Remove aria attributes
            element.removeAttribute('aria-invalid');
            element.removeAttribute('aria-describedby');
            
            // Remove any existing feedback elements
            const feedbackEl = element.nextElementSibling;
            if (feedbackEl && (feedbackEl.classList.contains('invalid-feedback') || 
                             feedbackEl.classList.contains('valid-feedback'))) {
                feedbackEl.remove();
            }
            
            // Clear any custom validity
            element.setCustomValidity('');
        });
        
        // Remove any remaining feedback messages
        const allFeedbacks = form.querySelectorAll('.invalid-feedback, .valid-feedback');
        allFeedbacks.forEach(feedback => feedback.remove());
    }
}


// Add some CSS for the validation popup
const validationstyle = document.createElement('style');
validationstyle.textContent = `
    .swal2-show-validation {
        font-family: 'Roboto', sans-serif;
    }
    .swal2-show-validation ul {
        margin: 1rem 0;
    }
    .swal2-show-validation li {
        padding: 0.5rem;
        margin-bottom: 0.5rem;
        background: #fff5f5;
        border-radius: 4px;
        font-size: 0.9rem;
    }
    .swal2-show-validation li i {
        color: #dc3545;
    }
    .text-left {
        text-align: left !important;
    }
`;
document.head.appendChild(validationstyle);

let currentPage = 1;
let pageSize = 10;
let totalCourses = 0;
</script>
</asp:Content>