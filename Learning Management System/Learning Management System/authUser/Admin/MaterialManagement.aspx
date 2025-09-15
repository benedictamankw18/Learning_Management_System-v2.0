<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="MaterialManagement.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.MaterialManagement" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">



    <title>Material Management - Learning Management System</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        
        .material-container {
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
        
        .materials-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
          .fade{
            background: rgba(0, 0, 0, 0.5);
        }
        .materials-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .table-responsive {
            border-radius: 12px;
        }
        
        .table thead th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #2c3e50;
            padding: 15px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-top: 1px solid #f1f3f4;
        }
        
        .file-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }
        
        .file-pdf { background: #ffebee; color: #d32f2f; }
        .file-document { background: #e3f2fd; color: #1976d2; }
        .file-video { background: #f3e5f5; color: #7b1fa2; }
        .file-image { background: #e8f5e8; color: #388e3c; }
        .file-other { background: #f5f5f5; color: #616161; }
        
        .btn-sm-custom {
            padding: 6px 12px;
            font-size: 12px;
            border-radius: 6px;
            margin: 0 2px;
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
        
        .modal-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        
        .btn-close-white {
            filter: brightness(0) invert(1);
        }
        
        .modal-content {
            border-radius: 15px;
            border: none;
        }
        
        /* Modal file icons in dialogs */
        .modal-body .file-icon {
            width: 45px;
            height: 45px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }
        
        /* Modal header backgrounds */
        .modal-header.bg-danger {
            background: linear-gradient(135deg, #dc3545, #c82333) !important;
        }
        
        .modal-header.bg-success {
            background: linear-gradient(135deg, #28a745, #1e7e34) !important;
        }

        .upload-spinner-overlay {
   position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0,0,0,0.3);
    z-index: 20000; /* <-- Make this higher than Bootstrap modal (1050) */
    display: flex;
    align-items: center;
    justify-content: center;
}
.upload-spinner-content {
    background: white;
    border-radius: 16px;
    padding: 40px 60px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.15);
    display: flex;
    flex-direction: column;
    align-items: center;
}
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="material-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="mb-2">
                <i class="fas fa-folder-open me-3"></i>
                <span id="pageTitle">Material Management</span>
            </h1>
            <p class="mb-0 opacity-75" id="pageSubtitle">Upload and manage course materials</p>
        </div>

        <!-- Breadcrumb Navigation -->
        <div class="breadcrumb-nav">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb" id="breadcrumb">
                    <li class="breadcrumb-item"><a href="Material.aspx">All Courses</a></li>
                    <li class="breadcrumb-item"><a href="#" id="courseLink">Course</a></li>
                    <li class="breadcrumb-item active">Materials</li>
                </ol>
            </nav>
        </div>

        <!-- Back Button -->
        <a href="#" id="backButton" class="back-btn mb-4">
            <i class="fas fa-arrow-left"></i>
            Back to Course Details
        </a>

        <!-- Materials Header -->
        <div class="materials-header">
            <div>
                <h4 class="text-primary mb-1" id="sectionTitle">Section Title</h4>
                <p class="text-muted mb-0" id="sectionDescription">Section description</p>
            </div>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addMaterialModal">
                <i class="fas fa-cloud-upload-alt me-2"></i>
                Upload Material
            </button>
        </div>

        <!-- Materials Table -->
        <div class="materials-table">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="materialsTable">
                    <thead>
                        <tr>
                            <th>Material</th>
                            <th>Type</th>
                            <th>Size</th>
                            <th>Uploaded</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="materialsTableBody">
                        <!-- Materials will be loaded here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

 <!-- Upload Spinner Overlay -->
<div id="uploadSpinner" class="upload-spinner-overlay" style="display:none;">
    <div class="upload-spinner-content">
        <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
            <span class="visually-hidden">Uploading...</span>
        </div>
        <div class="mt-3 fw-bold text-primary">Uploading...</div>
    </div>
</div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
let sectionMaterials = {};
        <%-- // Sample materials data
        const sectionMaterials = {
            1: [
                { id: 1, title: 'Introduction to Programming - Lecture 1', type: 'pdf', size: '2.5 MB', uploaded: '2025-01-15', status: 'active', description: 'Basic programming concepts overview' },
                { id: 2, title: 'Hello World Tutorial', type: 'video', size: '15.2 MB', uploaded: '2025-01-15', status: 'active', description: 'Step-by-step first program creation' },
                { id: 3, title: 'Programming Exercises Set 1', type: 'document', size: '1.8 MB', uploaded: '2025-01-16', status: 'active', description: 'Practice problems and solutions' },
                { id: 4, title: 'Code Examples Collection', type: 'document', size: '3.2 MB', uploaded: '2025-01-17', status: 'active', description: 'Sample code snippets and examples' },
                { id: 5, title: 'Programming Fundamentals Quiz', type: 'pdf', size: '0.8 MB', uploaded: '2025-01-18', status: 'draft', description: 'Assessment material for basic concepts' }
            ],
            2: [
                { id: 6, title: 'Data Types Overview', type: 'pdf', size: '1.9 MB', uploaded: '2025-01-20', status: 'active', description: 'Comprehensive guide to data types' },
                { id: 7, title: 'Variable Declaration Tutorial', type: 'video', size: '12.5 MB', uploaded: '2025-01-21', status: 'active', description: 'How to declare and use variables' },
                { id: 8, title: 'Practice Exercises - Variables', type: 'document', size: '2.1 MB', uploaded: '2025-01-22', status: 'active', description: 'Hands-on variable exercises' }
            ]
        }; --%>

        let currentCourse = null;
        let currentSection = null;

        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {

     const body1 = document.getElementsByTagName('body')[0];

 body1.innerHTML += `



    <!-- Add Material Modal -->
    <div class="modal fade" id="addMaterialModal" tabindex="-1" data-bs-backdrop="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-cloud-upload-alt me-2"></i>
                        Upload Material
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addMaterialForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="materialTitle" class="form-label">Material Title</label>
                                <input type="text" class="form-control" id="materialTitle" placeholder="Enter title" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="materialType" class="form-label">Material Type</label>
                                <select class="form-select" id="materialType" required>
                                    <option value="">Select Type</option>
                                    <option value="pdf">PDF Document</option>
                                    <option value="video">Video</option>
                                    <option value="document">Word Document</option>
                                    <option value="presentation">Presentation</option>
                                    <option value="image">Image</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="materialFile" class="form-label">Choose File</label>
                            <input type="file" class="form-control" id="materialFile" required>
                            <div class="form-text">Supported formats: PDF, DOC, DOCX, PPT, PPTX, MP4, AVI, JPG, PNG (Max: 50MB)</div>
                        </div>
                        <div class="mb-3">
                            <label for="materialDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="materialDescription" rows="3" placeholder="Brief description of the material..."></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="materialStatus" class="form-label">Status</label>
                                <select class="form-select" id="materialStatus" required>
                                    <option value="active">Active</option>
                                    <option value="draft">Draft</option>
                                    <option value="archived">Archived</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="materialTags" class="form-label">Tags</label>
                                <input type="text" class="form-control" id="materialTags" placeholder="e.g., lecture, homework, reading">
                                <div class="form-text">Separate tags with commas</div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="uploadMaterial()">
                        <i class="fas fa-upload me-2"></i>Upload Material
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Material Modal -->
    <div class="modal fade" id="editMaterialModal" tabindex="-1" data-bs-backdrop="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>
                        Edit Material
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editMaterialForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editMaterialTitle" class="form-label">Material Title</label>
                                <input type="text" class="form-control" id="editMaterialTitle" placeholder="Enter title" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editMaterialType" class="form-label">Material Type</label>
                                <select class="form-select" id="editMaterialType" required>
                                    <option value="">Select Type</option>
                                    <option value="pdf">PDF Document</option>
                                    <option value="video">Video</option>
                                    <option value="document">Word Document</option>
                                    <option value="presentation">Presentation</option>
                                    <option value="image">Image</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editMaterialFile" class="form-label">Replace File (Optional)</label>
                            <input type="file" class="form-control" id="editMaterialFile">
                            <div class="form-text">Leave empty to keep current file. Supported formats: PDF, DOC, DOCX, PPT, PPTX, MP4, AVI, JPG, PNG (Max: 50MB)</div>
                        </div>
                        <div class="mb-3">
                            <label for="editMaterialDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editMaterialDescription" rows="3" placeholder="Brief description of the material..."></textarea>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editMaterialStatus" class="form-label">Status</label>
                                <select class="form-select" id="editMaterialStatus" required>
                                    <option value="active">Active</option>
                                    <option value="draft">Draft</option>
                                    <option value="archived">Archived</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editMaterialTags" class="form-label">Tags</label>
                                <input type="text" class="form-control" id="editMaterialTags" placeholder="e.g., lecture, homework, reading">
                                <div class="form-text">Separate tags with commas</div>
                            </div>
                        </div>
                        <input type="hidden" id="editMaterialId">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-warning" onclick="updateMaterial()">
                        <i class="fas fa-save me-2"></i>Update Material
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteMaterialModal" tabindex="-1" data-bs-backdrop="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-trash me-2"></i>
                        Delete Material
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle text-danger fa-3x mb-3"></i>
                        <h5 class="mb-3">Are you sure you want to delete this material?</h5>
                        <div class="alert alert-light border">
                            <div class="d-flex align-items-center">
                                <div class="file-icon me-3" id="deleteFileIcon">
                                    <i class="fas fa-file"></i>
                                </div>
                                <div class="text-start">
                                    <div class="fw-bold" id="deleteMaterialTitle">Material Title</div>
                                    <small class="text-muted" id="deleteMaterialDesc">Material description</small>
                                </div>
                            </div>
                        </div>
                        <p class="text-muted mb-0">
                            <strong>Warning:</strong> This action cannot be undone. The material will be permanently removed from the system.
                        </p>
                    </div>
                    <input type="hidden" id="deleteMaterialId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDeleteMaterial()">
                        <i class="fas fa-trash me-2"></i>Delete Permanently
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Download Material Modal -->
    <div class="modal fade" id="downloadMaterialModal" tabindex="-1" data-bs-backdrop="false">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-download me-2"></i>
                        Download Material
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-cloud-download-alt text-success fa-3x mb-3"></i>
                        <h5 class="mb-3">Download Material</h5>
                        <div class="alert alert-light border">
                            <div class="d-flex align-items-center">
                                <div class="file-icon me-3" id="downloadFileIcon">
                                    <i class="fas fa-file"></i>
                                </div>
                                <div class="text-start flex-grow-1">
                                    <div class="fw-bold" id="downloadMaterialTitle">Material Title</div>
                                    <div class="row">
                                        <div class="col-6">
                                            <small class="text-muted">Type: <span id="downloadMaterialType">PDF</span></small>
                                        </div>
                                        <div class="col-6">
                                            <small class="text-muted">Size: <span id="downloadMaterialSize">2.5 MB</span></small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Download Options:</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="downloadOption" id="downloadOriginal" value="original" checked>
                                <label class="form-check-label" for="downloadOriginal">
                                    Original File
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="downloadOption" id="downloadCompressed" value="compressed">
                                <label class="form-check-label" for="downloadCompressed">
                                    Compressed Version (Smaller size)
                                </label>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" id="downloadMaterialId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" onclick="startDownload()">
                        <i class="fas fa-download me-2"></i>Start Download
                    </button>
                </div>
            </div>
        </div>
    </div>



`;

            loadMaterialManagement();
            
            // Add real-time file validation
            const fileInput = document.getElementById('materialFile');
            const materialTypeSelect = document.getElementById('materialType');
            
            // Validate when file is selected
            fileInput.addEventListener('change', function() {
                validateFileInRealTime();
            });
            
            // Validate when material type is changed
            materialTypeSelect.addEventListener('change', function() {
                validateFileInRealTime();
            });
            
            // Clear validation when modal is closed
            const addMaterialModal = document.getElementById('addMaterialModal');
            addMaterialModal.addEventListener('hidden.bs.modal', function() {
                clearValidationMessage();
                document.getElementById('addMaterialForm').reset();
            });

const editFileInput = document.getElementById('editMaterialFile');
const editMaterialTypeSelect = document.getElementById('editMaterialType');

editFileInput.addEventListener('change', function() {
    validateEditFileInRealTime();
});
editMaterialTypeSelect.addEventListener('change', function() {
    validateEditFileInRealTime();
});

        });
        

// Real-time file validation for Edit Material
function validateEditFileInRealTime() {
    const fileInput = document.getElementById('editMaterialFile');
    const materialType = document.getElementById('editMaterialType').value;
    const file = fileInput.files[0];

    // Clear previous validation messages
    clearEditValidationMessage();

    if (file && materialType) {
        const validation = validateFileType(file, materialType);
        if (!validation.isValid) {
            showEditValidationMessage(validation.message, 'error');
        } else {
            showEditValidationMessage(`✓ File type matches selected material type (${materialType.toUpperCase()})`, 'success');
        }
    }
}

function showEditValidationMessage(message, type) {
    const fileInput = document.getElementById('editMaterialFile');
    const existingMessage = fileInput.parentNode.querySelector('.edit-validation-message');
    if (existingMessage) {
        existingMessage.remove();
    }
    const messageDiv = document.createElement('div');
    messageDiv.className = `edit-validation-message alert ${type === 'error' ? 'alert-danger' : 'alert-success'} mt-2`;
    messageDiv.style.fontSize = '12px';
    messageDiv.style.padding = '8px 12px';
    messageDiv.innerHTML = `<i class="fas ${type === 'error' ? 'fa-exclamation-triangle' : 'fa-check-circle'} me-2"></i>${message}`;
    fileInput.parentNode.appendChild(messageDiv);
}

function clearEditValidationMessage() {
    const existingMessage = document.querySelector('.edit-validation-message');
    if (existingMessage) {
        existingMessage.remove();
    }
}

        // Real-time file validation
        function validateFileInRealTime() {
            const fileInput = document.getElementById('materialFile');
            const materialType = document.getElementById('materialType').value;
            const file = fileInput.files[0];
            
            // Clear previous validation messages
            clearValidationMessage();
            
            if (file && materialType) {
                const validation = validateFileType(file, materialType);
                if (!validation.isValid) {
                    showValidationMessage(validation.message, 'error');
                } else {
                    showValidationMessage(`✓ File type matches selected material type (${materialType.toUpperCase()})`, 'success');
                }
            }
        }
        
        // Show validation message
        function showValidationMessage(message, type) {
            const fileInput = document.getElementById('materialFile');
            const existingMessage = fileInput.parentNode.querySelector('.validation-message');
            
            if (existingMessage) {
                existingMessage.remove();
            }
            
            const messageDiv = document.createElement('div');
            messageDiv.className = `validation-message alert ${type === 'error' ? 'alert-danger' : 'alert-success'} mt-2`;
            messageDiv.style.fontSize = '12px';
            messageDiv.style.padding = '8px 12px';
            messageDiv.innerHTML = `<i class="fas ${type === 'error' ? 'fa-exclamation-triangle' : 'fa-check-circle'} me-2"></i>${message}`;
            
            fileInput.parentNode.appendChild(messageDiv);
        }
        
        // Clear validation message
        function clearValidationMessage() {
            const existingMessage = document.querySelector('.validation-message');
            if (existingMessage) {
                existingMessage.remove();
            }
        }

        // Load material management from URL parameters
        function loadMaterialManagement() {
            const urlParams = new URLSearchParams(window.location.search);
            const courseId = urlParams.get('courseId');
            const sectionId = urlParams.get('sectionId');
            const courseName = urlParams.get('courseName');
            const sectionName = urlParams.get('sectionName');
            
            if (courseId && sectionId && courseName && sectionName) {
                currentCourse = {
                    id: parseInt(courseId),
                    name: decodeURIComponent(courseName)
                };
                currentSection = {
                    id: parseInt(sectionId),
                    name: decodeURIComponent(sectionName)
                };
                
                displayMaterialManagement();
            } else {
                // Missing parameters, redirect to main page
                window.location.href = 'Material.aspx';
            }
        }

        // Display material management interface
        function displayMaterialManagement() {
            // Update page title and header
            document.title = `${currentSection.name} - Material Management`;
            document.getElementById('pageTitle').textContent = `${currentSection.name} Materials`;
            document.getElementById('pageSubtitle').textContent = `${currentCourse.name} - Upload and manage materials`;
            
            // Update breadcrumb
            const courseLink = document.getElementById('courseLink');
            courseLink.textContent = currentCourse.name;
            courseLink.href = `CourseDetails.aspx?courseId=${currentCourse.id}&courseName=${encodeURIComponent(currentCourse.name)}`;
            
            document.getElementById('breadcrumb').innerHTML = `
                <li class="breadcrumb-item"><a href="Material.aspx">All Courses</a></li>
                <li class="breadcrumb-item"><a href="CourseDetails.aspx?courseId=${currentCourse.id}&courseName=${encodeURIComponent(currentCourse.name)}">${currentCourse.name}</a></li>
                <li class="breadcrumb-item active">${currentSection.name}</li>
            `;
            
            // Update back button
            document.getElementById('backButton').href = `CourseDetails.aspx?courseId=${currentCourse.id}&courseName=${encodeURIComponent(currentCourse.name)}`;
            
            // Update section info
            document.getElementById('sectionTitle').textContent = currentSection.name;
            document.getElementById('sectionDescription').textContent = `Materials for ${currentSection.name} section`;
            
            // Load materials
            loadSectionMaterials(currentSection.id);
        }


function formatFileSize(bytes) {
    if (bytes >= 1024 * 1024 * 1024) return (bytes / (1024 * 1024 * 1024)).toFixed(2) + ' GB';
    if (bytes >= 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
    if (bytes >= 1024) return (bytes / 1024).toFixed(2) + ' KB';
    return bytes + ' bytes';
}

        // Load materials for the current section
      function loadSectionMaterials(sectionId) {
    const tableBody = document.getElementById('materialsTableBody');
    tableBody.innerHTML = '';

    $.ajax({
        type: "POST",
        url: "MaterialManagement.aspx/GetSectionMaterials",
        data: JSON.stringify({ sectionId: sectionId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            if (response.d && response.d.success) {
                const materials = response.d.data;
                // Store materials for this section globally so edit/delete/download can access them
                sectionMaterials[sectionId] = materials;

                if (materials.length === 0) {
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <i class="fas fa-folder-open fa-2x mb-2 d-block"></i>
                                No materials found. Click "Upload Material" to add some.
                            </td>
                        </tr>
                    `;
                    return;
                }
                materials.forEach(material => {
                    const fileIcon = getFileIcon(material.type);
                    const statusClass = material.status === 'active' ? 'success' : material.status === 'draft' ? 'warning' : 'secondary';
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="file-icon file-${material.type}">
                                    <i class="${fileIcon}"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${material.title}</div>
                                    <small class="text-muted">${material.description || ''}</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark">${material.type ? material.type.toUpperCase() : ''}</span>
                        </td>
                        <td>${material.size ? formatFileSize(material.size) : ''}</td>
                        <td>${material.uploaded || ''}</td>
                        <td>
                            <span class="badge bg-${statusClass}">${material.status.toUpperCase()}</span>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm-custom btn-outline-primary" onclick="downloadMaterial(${material.id})" title="Download">
                                <i class="fas fa-download"></i>
                            </button>
                            <button type="button" class="btn btn-sm-custom btn-outline-warning" onclick="editMaterial(${material.id})" title="Edit">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm-custom btn-outline-danger" onclick="deleteMaterial(${material.id})" title="Delete">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    `;
                    tableBody.appendChild(row);
                });
            } else {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center py-4 text-danger">
                            Failed to load materials.
                        </td>
                    </tr>
                `;
            }
        },
        error: function() {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-4 text-danger">
                        Error loading materials.
                    </td>
                </tr>
            `;
        }
    });
}

        // Helper function to get file icon
        function getFileIcon(type) {
            const icons = {
                pdf: 'fas fa-file-pdf',
                video: 'fas fa-play-circle',
                document: 'fas fa-file-word',
                presentation: 'fas fa-file-powerpoint',
                image: 'fas fa-file-image',
                other: 'fas fa-file'
            };
            return icons[type] || icons.other;
        }

        // Material management functions
      function uploadMaterial() {
    const form = document.getElementById('addMaterialForm');
    const spinner = document.getElementById('uploadSpinner');
    const materialType = document.getElementById('materialType').value;
    const fileInput = document.getElementById('materialFile');
    const file = fileInput.files[0];
    const status = document.getElementById('materialStatus').value;

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    if (!file) {
        alert('Please select a file to upload.');
        return;
    }
    const validation = validateFileType(file, materialType);
    if (!validation.isValid) {
        alert(validation.message);
        return;
    }
    const maxSize = 50 * 1024 * 1024;
    if (file.size > maxSize) {
        alert('File size exceeds 50MB limit. Please choose a smaller file.');
        return;
    }

    // Prepare form data for AJAX upload
    const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('courseId');
    const sectionId = urlParams.get('sectionId');
    const title = document.getElementById('materialTitle').value;
    const description = document.getElementById('materialDescription').value;

    const formData = new FormData();
    formData.append('file', file);
    formData.append('sectionId', sectionId);
    formData.append('courseId', courseId);
    formData.append('title', title);
    formData.append('materialType', materialType);
    formData.append('description', description);
    formData.append('status', status);

    // Show spinner
    spinner.style.display = 'block';

    $.ajax({
        url: 'UploadMaterialHandler.ashx',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            spinner.style.display = 'none';
            if (response.success) {
                showSuccessMessage('Material uploaded successfully!');
                //bootstrap.Modal.getInstance(document.getElementById('addMaterialModal')).hide();
                form.reset(); // Clear all fields
                loadSectionMaterials(sectionId);
                document.getElementById('downloadMaterialModal').style.display = 'none'; // Reset the form
            } else {
                alert('Failed to upload material: ' + (response.message || 'Unknown error'));
            }
        },
        error: function(xhr, status, error) {
            spinner.style.display = 'none';
            alert('Error uploading material: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

       function showSuccessMessage(message) {
    // Simple Bootstrap 5 toast (if you have a toast container)
    let toast = document.createElement('div');
    toast.className = 'toast align-items-center text-bg-success border-0 show position-fixed bottom-0 end-0 m-4';
    toast.role = 'alert';
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">${message}</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    document.body.appendChild(toast);
    setTimeout(() => { toast.remove(); }, 3000);
}

        // File type validation function
       function validateFileType(file, selectedType) {
    const fileName = file.name.toLowerCase();
    const fileExtension = fileName.split('.').pop();

    // Define allowed extensions and MIME types for each material type
    const allowed = {
        presentation: {
            extensions: ['ppt', 'pptx', 'odp'],
            mimeTypes: [
                'application/vnd.ms-powerpoint',
                'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                'application/vnd.oasis.opendocument.presentation'
            ]
        },
        pdf: {
            extensions: ['pdf'],
            mimeTypes: ['application/pdf']
        },
        video: {
            extensions: ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mkv'],
            mimeTypes: ['video/mp4', 'video/x-msvideo', 'video/quicktime', 'video/x-ms-wmv', 'video/x-flv', 'video/webm', 'video/x-matroska']
        },
        document: {
            extensions: ['doc', 'docx', 'txt', 'rtf'],
            mimeTypes: [
                'application/msword',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                'text/plain',
                'application/rtf'
            ]
        },
        image: {
            extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp'],
            mimeTypes: [
                'image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/svg+xml', 'image/webp'
            ]
        },
        other: {
            extensions: [],
            mimeTypes: []
        }
    };

    // If "Other" is selected, allow any file type
    if (selectedType === 'other') {
        return { isValid: true, message: '' };
    }

    const allowedExts = allowed[selectedType]?.extensions || [];
    const allowedMimes = allowed[selectedType]?.mimeTypes || [];

    // Check extension and MIME type
    if (!allowedExts.includes(fileExtension) || (allowedMimes.length && !allowedMimes.includes(file.type))) {
        const expectedFormats = allowedExts.join(', ').toUpperCase();
        return {
            isValid: false,
            message: `File type mismatch! You selected "${selectedType.toUpperCase()}" but uploaded a "${fileExtension.toUpperCase()}" file.\n\nFor ${selectedType.toUpperCase()} type, please upload: ${expectedFormats}\n\nOr change the Material Type to match your file.`
        };
    }

    return { isValid: true, message: '' };
}

        function editMaterial(id) {
            // Find the material data
            const materials = sectionMaterials[currentSection.id] || [];
            const material = materials.find(m => m.id === id);
            
            if (material) {
                // Populate the edit form with current data
                document.getElementById('editMaterialId').value = material.id;
                document.getElementById('editMaterialTitle').value = material.title;
                document.getElementById('editMaterialType').value = material.type;
                document.getElementById('editMaterialDescription').value = material.description;
                document.getElementById('editMaterialStatus').value = material.status;
                document.getElementById('editMaterialTags').value = ''; // Add tags if you have them in data
                
                // Show the edit modal
                bootstrap.Modal.getOrCreateInstance(document.getElementById('editMaterialModal')).show();
            }
        }

        function deleteMaterial(id) {
            // Find the material data
            const materials = sectionMaterials[currentSection.id] || [];
            const material = materials.find(m => m.id === id);
            
            if (material) {
                // Populate the delete modal with material info
                document.getElementById('deleteMaterialId').value = material.id;
                document.getElementById('deleteMaterialTitle').textContent = material.title;
                document.getElementById('deleteMaterialDesc').textContent = material.description;
                
                // Set the file icon
                const fileIcon = getFileIcon(material.type);
                const iconElement = document.getElementById('deleteFileIcon');
                iconElement.className = `file-icon file-${material.type}`;
                iconElement.innerHTML = `<i class="${fileIcon}"></i>`;
                
                // Show the delete modal
                bootstrap.Modal.getOrCreateInstance(document.getElementById('deleteMaterialModal')).show();
            }
        }

        function downloadMaterial(id) {
            // Find the material data
            const materials = sectionMaterials[currentSection.id] || [];
            const material = materials.find(m => m.id === id);
            
            if (material) {
                // Populate the download modal with material info
                document.getElementById('downloadMaterialId').value = material.id;
                document.getElementById('downloadMaterialTitle').textContent = material.title;
                document.getElementById('downloadMaterialType').textContent = material.type.toUpperCase();
                document.getElementById('downloadMaterialSize').textContent = formatFileSize(material.size);
                
                // Set the file icon
                const fileIcon = getFileIcon(material.type);
                const iconElement = document.getElementById('downloadFileIcon');
                iconElement.className = `file-icon file-${material.type}`;
                iconElement.innerHTML = `<i class="${fileIcon}"></i>`;
                
                // Show the download modal
                bootstrap.Modal.getOrCreateInstance(document.getElementById('downloadMaterialModal')).show();
            }
        }
        
        // New functions for modal actions
       function updateMaterial() {
    const form = document.getElementById('editMaterialForm');
    const spinner = document.getElementById('uploadSpinner');
    const materialId = document.getElementById('editMaterialId').value;
    const title = document.getElementById('editMaterialTitle').value;
    const materialType = document.getElementById('editMaterialType').value;
    const description = document.getElementById('editMaterialDescription').value;
    const status = document.getElementById('editMaterialStatus').value;
    const tags = document.getElementById('editMaterialTags').value;
    const fileInput = document.getElementById('editMaterialFile');
    const file = fileInput.files[0];

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    // Optional: Validate file type if a new file is selected
    if (file) {
        const validation = validateFileType(file, materialType);
        if (!validation.isValid) {
            alert(validation.message);
            return;
        }
        const maxSize = 50 * 1024 * 1024;
        if (file.size > maxSize) {
            alert('File size exceeds 50MB limit. Please choose a smaller file.');
            return;
        }
    }

    const formData = new FormData();
    formData.append('materialId', materialId);
    formData.append('title', title);
    formData.append('materialType', materialType);
    formData.append('description', description);
    formData.append('status', status);
    formData.append('tags', tags);
    if (file) {
        formData.append('file', file);
    }

    spinner.style.display = 'block';

    $.ajax({
        url: 'UpdateMaterialHandler.ashx',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            spinner.style.display = 'none';
            if (response.success) {
                showSuccessMessage('Material updated successfully!');
                //bootstrap.Modal.getInstance(document.getElementById('editMaterialModal')).hide();
                form.reset();
                loadSectionMaterials(currentSection.id);
                document.getElementById('editMaterialModal').style.display = 'none'; // Reset the modal
            } else {
                alert('Failed to update material: ' + (response.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
    spinner.style.display = 'none';
    alert('Error updating material: ' + (xhr.responseText || 'Unknown error'));
}
    });
}
        
        function confirmDeleteMaterial() {
    const materialId = document.getElementById('deleteMaterialId').value;
    const spinner = document.getElementById('uploadSpinner');
    spinner.style.display = 'block';

    const formData = new FormData();
    formData.append('materialId', materialId);

    $.ajax({
        url: 'DeleteMaterialHandler.ashx',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            spinner.style.display = 'none';
            if (response.success) {
                showSuccessMessage('Material deleted successfully!');
                //bootstrap.Modal.getInstance(document.getElementById('deleteMaterialModal')).hide();
                loadSectionMaterials(currentSection.id);
                document.getElementById('deleteMaterialModal').style.display = 'none'; // Reset the modal
            } else {
                alert('Failed to delete material: ' + (response.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            spinner.style.display = 'none';
            alert('Error deleting material: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}
        
       function startDownload() {
    const materialId = document.getElementById('downloadMaterialId').value;
    // Check which download option is selected
    const downloadOption = document.querySelector('input[name="downloadOption"]:checked').value;

    let url = 'DownloadMaterial.ashx?materialId=' + encodeURIComponent(materialId);
    if (downloadOption === 'compressed') {
        url += '&compressed=true';
    }
    window.open(url, '_blank');
    bootstrap.Modal.getInstance(document.getElementById('downloadMaterialModal')).hide();
       }
    </script>

</asp:Content>
