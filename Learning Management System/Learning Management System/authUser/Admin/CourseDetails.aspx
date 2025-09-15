<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.CourseDetails" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Course Details - Learning Management System</title>
    
   <!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<!-- Bootstrap Bundle JS (includes Popper and Modal) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        
        .course-container {
            padding: 20px;
            max-width: 1400px;
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
        
        .breadcrumb-nav {
            background: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .breadcrumb-nav .breadcrumb {
            margin: 0;
        }
        
        .breadcrumb-nav .breadcrumb-item a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-nav .breadcrumb-item a:hover {
            text-decoration: underline;
        }
        
        .course-info-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .course-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-left: 4px solid #007bff;
        }
        
        .stat-card .stat-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        
        .stat-card .stat-icon i {
            color: white;
            font-size: 20px;
        }
        
        .stat-card .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #007bff;
            margin-bottom: 5px;
        }
        
        .stat-card .stat-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .sections-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .section-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border-left: 4px solid #007bff;
        }
        
        .section-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .section-icon {
            width: 40px;
            height: 40px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }
        
        .section-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
        }
        
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            border: none;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-view {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .btn-add {
            background: #e8f5e8;
            color: #2e7d32;
        }
        
        .btn-view:hover {
            background: #bbdefb;
        }
        
        .btn-add:hover {
            background: #c8e6c9;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        
        .back-btn:hover {
            background: #5a6268;
            color: white;
            transform: translateX(-2px);
        }
        
        /* Modal Styles */
        .modal-content {
            border-radius: 15px;
            border: none;
        }

        .fade{
            background: rgba(0, 0, 0, 0.5);
        }
        
        .modal-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        
        .btn-close-white {
            filter: brightness(0) invert(1);
        }
        
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="course-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="mb-2">
                <i class="fas fa-graduation-cap me-3"></i>
                <span id="pageTitle">Course Details</span>
            </h1>
            <p class="mb-0 opacity-75" id="pageSubtitle">Manage course sections and materials</p>
        </div>

        <!-- Breadcrumb Navigation -->
        <div class="breadcrumb-nav">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb" id="breadcrumb">
                    <li class="breadcrumb-item"><a href="Material.aspx">All Courses</a></li>
                    <li class="breadcrumb-item active">Course Details</li>
                </ol>
            </nav>
        </div>

        <!-- Back Button -->
        <a href="Material.aspx" class="back-btn mb-4">
            <i class="fas fa-arrow-left"></i>
            Back to All Courses
        </a>

        <!-- Course Information Card -->
        <div class="course-info-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="text-primary mb-2" id="courseTitle">Course Title</h2>
                    <p class="text-muted mb-3" id="courseDescription">Course description and details</p>
                    <div class="row">
                        <div class="col-md-6">
                            <strong>Course Code:</strong> <span id="courseCode">-</span>
                        </div>
                        <div class="col-md-6">
                            <strong>Instructor:</strong> <span id="courseInstructor">-</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <button type="button" class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#editCourseModal">
                        <i class="fas fa-edit me-2"></i>
                        Edit Course
                    </button>
                </div>
            </div>
        </div>

        <!-- Course Statistics -->
        <div class="course-stats">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-list"></i>
                </div>
                <div class="stat-number" id="totalSections">0</div>
                <div class="stat-label">Total Sections</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-number" id="totalMaterials">0</div>
                <div class="stat-label">Total Materials</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-number" id="enrolledStudents">0</div>
                <div class="stat-label">Enrolled Students</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-number" id="completionRate">0%</div>
                <div class="stat-label">Completion Rate</div>
            </div>
        </div>

        <!-- Course Sections -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="text-primary">
                <i class="fas fa-folder-open me-2"></i>
                Course Sections
            </h3>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSectionModal">
                <i class="fas fa-plus me-2"></i>
                Add New Section
            </button>
        </div>

        <div class="sections-grid" id="sectionsGrid">
            <!-- Sections will be loaded here -->
        </div>
    </div>




    <!-- Bootstrap JS -->
    
    <script>

        let currentCourse = null;

        function updateNotificationBadge(count) {
    // Example: update a badge element with the notification count
    const badge = document.getElementById('notificationBadge');
    if (badge) {
        badge.textContent = count > 0 ? count : '';
        badge.style.display = count > 0 ? 'inline-block' : 'none';
    }
}

   // Initialize the page
document.addEventListener('DOMContentLoaded', function() {

     const body1 = document.getElementsByTagName('body')[0];

 body1.innerHTML += `

<!-- Add Section Modal -->
    <div class="modal fade" id="addSectionModal" tabindex="-1" data-bs-backdrop="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>
                        Add New Section
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addSectionForm">
                        <div class="mb-3">
                            <label for="sectionName" class="form-label">Section Name</label>
                            <input type="text" class="form-control" id="sectionName" placeholder="e.g., Introduction, Chapter 1" required>
                        </div>
                        <div class="mb-3">
                            <label for="sectionDesc" class="form-label">Description</label>
                            <textarea class="form-control" id="sectionDesc" rows="3" placeholder="Brief description of this section..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="sectionOrder" class="form-label">Order</label>
                            <input type="number" class="form-control" id="sectionOrder" min="1" value="1">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                   <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
<button type="button" class="btn btn-primary" onclick="addSection()" data-bs-dismiss="modal">
    <i class="fas fa-save me-2"></i>Add Section
</button>
                </div>
            </div>
        </div>
    </div>



    <!-- Edit Course Modal -->
<div class="modal fade" id="editCourseModal" tabindex="-1" data-bs-backdrop="false">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-edit me-2"></i>
                    Edit Course Details
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editCourseForm">
                    <input type="hidden" id="editCourseId">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="editCourseName" class="form-label">Course Name</label>
                            <input type="text" class="form-control" id="editCourseName" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="editCourseCode" class="form-label">Course Code</label>
                            <input type="text" class="form-control" id="editCourseCode" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editCourseDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editCourseDescription" rows="3"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="editCourseCredits" class="form-label">Credits</label>
                            <input type="number" class="form-control" id="editCourseCredits" min="0">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="editCourseStatus" class="form-label">Status</label>
                            <select class="form-select" id="editCourseStatus">
                                <option value="active">Active</option>
                                <option value="draft">Draft</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                        <label for="editIsActive" class="form-label">Is Active</label>
                        <select class="form-select" id="editIsActive">
                            <option value="true">Yes</option>
                            <option value="false">No</option>
                        </select>
                    </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="editStartDate" class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="editStartDate">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="editEndDate" class="form-label">End Date</label>
                            <input type="date" class="form-control" id="editEndDate">
                        </div>
                    </div>
                    
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="updateCourse()" data-bs-dismiss="modal">
                    <i class="fas fa-save me-2"></i>Update Course
                </button>
            </div>
        </div>
    </div>
</div>

           `; 




    loadCourseDetails();

    // Attach the event listener for the edit course modal
    const editCourseModal = document.getElementById('editCourseModal');
    if (editCourseModal) {
        editCourseModal.addEventListener('show.bs.modal', function() {
            populateEditCourseForm();
        });
    }
});


// Load course details from URL parameters
function loadCourseDetails() {
    const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('courseId');

    if (courseId) {
        $.ajax({
            type: "POST",
    url: "CourseDetails.aspx/GetCourseDetails",
    data: JSON.stringify({ courseId: parseInt(courseId) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(response) {
                if (response.d && response.d.success) {
                    const course = response.d.data;
                    displayCourseDetails(course);
                } else {
                    window.location.href = 'Material.aspx';
                }
            },
            error: function() {
                window.location.href = 'Material.aspx';
            }
        });
    } else {
        window.location.href = 'Material.aspx';
    }
}

function addSection() {
    const form = document.getElementById('addSectionForm');
    const sectionName = document.getElementById('sectionName').value.trim();
    const sectionOrder = parseInt(document.getElementById('sectionOrder').value);

    // Custom validation
    if (sectionName.length === 0) {
        showSuccessMessage('Section Name is required.');
        document.getElementById('sectionName').focus();
        return;
    }
    if (isNaN(sectionOrder) || sectionOrder < 1) {
        showSuccessMessage('Order must be a positive number.');
        document.getElementById('sectionOrder').focus();
        return;
    }

    if (form.checkValidity()) {
        const urlParams = new URLSearchParams(window.location.search);
        const courseId = urlParams.get('courseId');
        const description = document.getElementById('sectionDesc').value;

        $.ajax({
            type: "POST",
            url: "CourseDetails.aspx/AddSection",
            data: JSON.stringify({
                courseId: parseInt(courseId),
                sectionName: sectionName,
                description: description,
                orderIndex: sectionOrder
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(response) {
                if (response.d && response.d.success) {
                    showSuccessMessage('Section added successfully!');
                    form.reset();
                    loadCourseSections(courseId);
                    loadCourseStats(courseId);
                } else {
                    showSuccessMessage('Failed to add section.');
                }
            },
            error: function() {
                showSuccessMessage('Error adding section.');
            }
        });
    } else {
        form.reportValidity();
    }
}

// Display course details
function displayCourseDetails(course) {
    currentCourse = course;

    // Update page title and header
    document.title = `${course.name} - Course Details`;
    document.getElementById('pageTitle').textContent = course.name;
    document.getElementById('pageSubtitle').textContent = `${course.code} - Manage sections and materials`;

    // Update breadcrumb
    document.getElementById('breadcrumb').innerHTML = `
        <li class="breadcrumb-item"><a href="Material.aspx">All Courses</a></li>
        <li class="breadcrumb-item active">${course.name}</li>
    `;

    // Update course information
    document.getElementById('courseTitle').textContent = course.name;
    document.getElementById('courseDescription').textContent = course.description;
    document.getElementById('courseCode').textContent = course.code;
    document.getElementById('courseInstructor').textContent = course.instructor;
    
    // Load sections
    loadCourseSections(course.id);

    // Load stats
    loadCourseStats(course.id); 
}

function loadCourseStats(courseId) {
    $.ajax({
        type: "POST",
        url: "CourseDetails.aspx/GetCourseStats",
        data: JSON.stringify({ courseId: courseId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            if (response.d && response.d.success) {
                const stats = response.d.data;
                document.getElementById('totalSections').textContent = stats.totalSections;
                document.getElementById('totalMaterials').textContent = stats.totalMaterials;
                document.getElementById('enrolledStudents').textContent = stats.enrolledStudents;
                document.getElementById('completionRate').textContent = stats.completionRate.toFixed(2) + "%";
            }
        }
    });
}


   // Load course sections
function loadCourseSections(courseId) {
    const sectionsGrid = document.getElementById('sectionsGrid');
    sectionsGrid.innerHTML = `
        <div class="col-12 text-center py-5">
            <div class="spinner-border text-primary" role="status"></div>
            <div>Loading sections...</div>
        </div>
    `;

    $.ajax({
        type: "POST",
        url: "CourseDetails.aspx/GetCourseSections",
        data: JSON.stringify({ courseId: parseInt(courseId) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            sectionsGrid.innerHTML = '';
            if (response.d && response.d.success) {
                const sections = response.d.data;
                if (sections.length === 0) {
                    sectionsGrid.innerHTML = `
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No sections found</h5>
                            <p class="text-muted">Click "Add New Section" to create the first section for this course.</p>
                        </div>
                    `;
                    return;
                }
                sections.forEach(section => {
                    const sectionCard = document.createElement('div');
                    sectionCard.className = 'section-card';

                    sectionCard.innerHTML = `
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-folder"></i>
                            </div>
                            <div>
                                <h6 class="mb-1">${section.name}</h6>
                                <small class="text-muted">${section.materials} materials</small>
                            </div>
                        </div>
                        <p class="text-muted small mb-3">${section.description || ''}</p>
                        <div class="section-actions">
                            <button type="button" class="btn-action btn-view" onclick="viewMaterials(${section.id}, '${section.name}')">
                                <i class="fas fa-eye me-1"></i>View Materials
                            </button>
                            <button type="button" class="btn-action btn-add" onclick="manageMaterials(${section.id}, '${section.name}')">
                                <i class="fas fa-plus me-1"></i>Manage Materials
                            </button>
                        </div>
                    `;

                    sectionsGrid.appendChild(sectionCard);
                });
            } else {
                sectionsGrid.innerHTML = '<div class="text-danger py-4">Failed to load sections.</div>';
            }
        },
        error: function() {
            sectionsGrid.innerHTML = '<div class="text-danger py-4">Error loading sections.</div>';
        }
    });
}

        // Navigate to material management for a section
        function viewMaterials(sectionId, sectionName) {
            window.location.href = `MaterialManagement.aspx?courseId=${currentCourse.id}&sectionId=${sectionId}&courseName=${encodeURIComponent(currentCourse.name)}&sectionName=${encodeURIComponent(sectionName)}`;
        }

        function manageMaterials(sectionId, sectionName) {
            // Store section data for the materials page
            sessionStorage.setItem('selectedSection', JSON.stringify({
                id: sectionId,
                name: sectionName,
                courseId: currentCourse.id,
                courseName: currentCourse.name
            }));
            
            window.location.href = `MaterialManagement.aspx?courseId=${currentCourse.id}&sectionId=${sectionId}&courseName=${encodeURIComponent(currentCourse.name)}&sectionName=${encodeURIComponent(sectionName)}`;
        }

function hideModal(modalId) {
    const modalElement = document.getElementById(modalId);
    if (modalElement) {
        let modalInstance = bootstrap.Modal.getInstance(modalElement);
        if (!modalInstance) {
            modalInstance = new bootstrap.Modal(modalElement);
        }
        modalInstance.hide();
    }
}

        // Populate edit course form with current course data
       function populateEditCourseForm() {
    if (currentCourse) {
        document.getElementById('editCourseId').value = currentCourse.id;
        document.getElementById('editCourseName').value = currentCourse.name;
        document.getElementById('editCourseCode').value = currentCourse.code;
        document.getElementById('editCourseDescription').value = currentCourse.description;
        document.getElementById('editCourseCredits').value = currentCourse.credits || '';
        document.getElementById('editCourseStatus').value = currentCourse.status || 'active';
        document.getElementById('editStartDate').value = currentCourse.startDate || '';
        document.getElementById('editEndDate').value = currentCourse.endDate || '';
        document.getElementById('editIsActive').value = currentCourse.isActive ? 'true' : 'false';
    }
}
        
        // Update course function
    function updateCourse() {
    const form = document.getElementById('editCourseForm');
    if (form.checkValidity()) {
        const updatedCourse = {
            id: parseInt(document.getElementById('editCourseId').value),
            name: document.getElementById('editCourseName').value,
            code: document.getElementById('editCourseCode').value,
            description: document.getElementById('editCourseDescription').value,
            credits: parseInt(document.getElementById('editCourseCredits').value) || null,
            status: document.getElementById('editCourseStatus').value,
            startDate: document.getElementById('editStartDate').value || null,
            endDate: document.getElementById('editEndDate').value || null,
            isActive: document.getElementById('editIsActive').value === "true",
        };

        $.ajax({
            type: "POST",
            url: "CourseDetails.aspx/UpdateCourse",
            data: JSON.stringify({ request: updatedCourse }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(response) {
                if (response.d && response.d.success) {
                    showSuccessMessage('Course updated successfully!');
                    loadCourseDetails();
                } else {
                    showSuccessMessage('Failed to update course.');
                }
            },
            error: function() {
                showSuccessMessage('Error updating course.');
            }
        });
    } else {
        form.reportValidity();
    }
}
        
        // Show success message function
        function showSuccessMessage(message) {
            // Create a toast-like notification
            const toast = document.createElement('div');
            toast.className = 'alert alert-success alert-dismissible fade show position-fixed';
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
            toast.innerHTML = `
                <i class="fas fa-check-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(toast);
            
            // Auto-remove after 3 seconds
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.remove();
                }
            }, 3000);
        }
    </script>

</asp:Content>
