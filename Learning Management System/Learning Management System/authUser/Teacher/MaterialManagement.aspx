<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="MaterialManagement.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.MaterialManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<title>Material Management - Teacher</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
<style>
	body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
	.material-container { padding: 20px; max-width: 1400px; margin: 0 auto; }
	.page-header { background: linear-gradient(135deg, #2c2b7c, #0056b3); color: white; padding: 30px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 8px 25px rgba(44, 43, 124, 0.15); }
	.breadcrumb-nav { background: white; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
	.breadcrumb-nav .breadcrumb { margin: 0; }
	.breadcrumb-nav .breadcrumb-item a { color: #2c2b7c; text-decoration: none; font-weight: 500; }
	.breadcrumb-nav .breadcrumb-item a:hover { text-decoration: underline; }
	.course-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px; }
	.course-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: all 0.3s ease; cursor: pointer; border: 2px solid transparent; }
	.course-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(44, 43, 124, 0.15); border-color: #2c2b7c; }
	.course-card .course-icon { width: 60px; height: 60px; background: linear-gradient(135deg, #2c2b7c, #0056b3); border-radius: 15px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; }
	.course-card .course-icon i { font-size: 24px; color: white; }
	.course-card h5 { color: #2c3e50; margin-bottom: 10px; font-weight: 600; }
	.course-card .course-meta { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; }
	.course-card .sections-count { color: #6c757d; font-size: 14px; }
	.course-card .materials-count { background: #e3f2fd; color: #2c2b7c; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
	.fade-in { animation: fadeIn 0.7s ease; }
	@keyframes fadeIn { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
	.course-loading-spinner { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 180px; color: #2c2b7c; font-size: 1.1rem; font-weight: 500; opacity: 0.85; }
	.course-loading-spinner .spinner-border { width: 3rem; height: 3rem; margin-bottom: 1rem; color: #2c2b7c; }
	.course-details { display: none; }
	.course-info-card { background: white; border-radius: 15px; padding: 25px; margin-bottom: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
	.sections-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
	.section-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); transition: all 0.3s ease; cursor: pointer; border-left: 4px solid #2c2b7c; }
	.section-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(44, 43, 124, 0.15); }
	.section-header { display: flex; align-items: center; margin-bottom: 15px; }
	.section-icon { width: 40px; height: 40px; background: #f8f9fa; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 12px; }
	.section-actions { display: flex; gap: 8px; margin-top: 15px; }
	.btn-action { padding: 6px 12px; border-radius: 6px; border: none; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.2s ease; }
	.btn-view { background: #e3f2fd; color: #2c2b7c; }
	.btn-add { background: #e8f5e8; color: #2e7d32; }
	.btn-view:hover { background: #bbdefb; }
	.btn-add:hover { background: #c8e6c9; }
	.material-management { display: none; }
	.materials-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
	.materials-table { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
	.table-responsive { border-radius: 12px; }
	.table thead th { background: #f8f9fa; border: none; font-weight: 600; color: #2c3e50; padding: 15px; }
	.table tbody td { padding: 15px; vertical-align: middle; border-top: 1px solid #f1f3f4; }
	.file-icon { width: 35px; height: 35px; border-radius: 8px; display: flex; align-items: center; justify-content: center; margin-right: 12px; }
	.file-pdf { background: #ffebee; color: #d32f2f; }
	.file-doc { background: #e3f2fd; color: #2c2b7c; }
	.file-video { background: #f3e5f5; color: #7b1fa2; }
	.file-image { background: #e8f5e8; color: #388e3c; }
	.file-default { background: #f5f5f5; color: #616161; }
	.btn-sm-custom { padding: 6px 12px; font-size: 12px; border-radius: 6px; margin: 0 2px; }
	.modal-content { border-radius: 15px; border: none; }
	.modal-header { background: linear-gradient(135deg, #2c2b7c, #0056b3); color: white; border-radius: 15px 15px 0 0; }
	.btn-close-white { filter: brightness(0) invert(1); }
	.back-btn { background: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 8px; display: inline-flex; align-items: center; gap: 8px; font-weight: 500; transition: all 0.2s ease; }
	.back-btn:hover { background: #5a6268; color: white; transform: translateX(-2px); }
	.view-active { display: block !important; }
	.hidden { display: none !important; }
     .fade{
            background: rgba(0, 0, 0, 0.5);
        }
	.btn-gradient-upload {
	background: linear-gradient(135deg, #0b08e1ff, #07157dff);
	color: #fff;
	box-shadow: 0 4px 16px rgba(44,43,124,0.15);
	border: none;
	border-radius: 12px;
	font-weight: 600;
	font-size: 1.08rem;
	padding: 0.6rem 2.2rem;
	transition: all 1s;
	box-shadow: 0 2px 8px rgba(44,43,124,0.10);
}
.btn-gradient-upload:hover {
	background: linear-gradient(135deg, #101070ff, #1310e1ff);
	color: #fff;
	box-shadow: 0 4px 16px rgba(44,43,124,0.15);
}

a{
	text-decoration: none;
	color: inherit;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="material-container">
	<!-- Page Header -->
	<div class="page-header">
		<h1 class="mb-2">
			<i class="fas fa-folder-open me-3"></i>
			Materials and Resources Management
		</h1>
		<p class="mb-0 opacity-75">Manage and share course materials and resources</p>
	</div>
	<!-- Breadcrumb Navigation -->
	<div class="breadcrumb-nav">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb" id="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="Materials.aspx"><i class="fas fa-home me-1"></i>All Courses</a>
                </li>
                <li class="breadcrumb-item">
                    <a href="javascript:history.back()">Course Details</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    Materials
                </li>
            </ol>
        </nav>
    </div>

    <a class="back-btn mb-4" href="Materials.aspx">
        <i class="fas fa-arrow-left"></i>
        Back to Sections
    </a>
    <div class="materials-header d-flex flex-wrap justify-content-between align-items-center shadow-sm rounded-4 mb-4 animate__animated animate__fadeInDown" style="background: linear-gradient(90deg, #2c2b7c 60%, #0056b3 100%); color: #fff;">
    <div>
        <h4 class="mb-1 fw-bold" id="sectionTitle"><i class="fas fa-folder me-2"></i>Section Title</h4>
        <p class="mb-0 opacity-75" id="sectionDescription">Section description</p>
    </div>
    <button class="btn btn-gradient-upload d-flex align-items-center gap-2 px-4 py-2 shadow-sm animate__animated animate__pulse animate__infinite"
        data-bs-toggle="modal" data-bs-target="#addMaterialModal">
        <i class="fas fa-cloud-upload-alt fa-lg"></i>
        <span class="fw-semibold">Upload Material</span>
    </button>
    </div>
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

    <!-- Add this overlay spinner just before the closing </div> of .material-container -->
<div id="uploadSpinner" class="position-fixed top-0 start-0 w-100 h-100 align-items-center justify-content-center"
     style="background: rgba(44,43,124,0.18); z-index: 2000; display: none;">
    <div class="text-center">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;"></div>
        <div class="mt-3 fw-semibold text-primary">Uploading, please wait...</div>
    </div>
</div>
    </div>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>


       // Sample materials data for demo (remove if using backend)

let currentCourseId = null;
let currentSectionId = null;

// Global variables for section/course context and materials
let sectionMaterials = {};
let currentSection = {};
let currentCourse = {};

// Helpers
function getStatusBadge(status) {
    if (status === "active") return `<span class="badge bg-success">Active</span>`;
    if (status === "draft") return `<span class="badge bg-warning text-dark">Draft</span>`;
    if (status === "archived") return `<span class="badge bg-secondary">Archived</span>`;
    return `<span class="badge bg-light text-dark">${status}</span>`;
}
function getTypeLabel(type) {
    switch (type) {
        case "pdf": return "PDF";
        case "video": return "Video";
        case "document": return "Document";
        case "presentation": return "Presentation";
        case "image": return "Image";
        default: return "Other";
    }
}
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
function formatFileSize(bytes) {
    if (bytes >= 1024 * 1024 * 1024) return (bytes / (1024 * 1024 * 1024)).toFixed(2) + ' GB';
    if (bytes >= 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
    if (bytes >= 1024) return (bytes / 1024).toFixed(2) + ' KB';
    return bytes + ' bytes';
}

       function editMaterial(id) {
    const material = loadedMaterials.find(m => m.id == id);
    if (material) {
        document.getElementById('editMaterialId').value = material.id;
        document.getElementById('editMaterialTitle').value = material.title;
        document.getElementById('editMaterialType').value = material.type;
        document.getElementById('editMaterialDescription').value = material.desc;
        document.getElementById('editMaterialStatus').value = material.status;
        document.getElementById('editMaterialTags').value = material.tags || '';
        bootstrap.Modal.getOrCreateInstance(document.getElementById('editMaterialModal')).show();
    }
}
let loadedMaterials = [];

function deleteMaterial(id) {
    const material = loadedMaterials.find(m => m.id == id);
    if (material) {
        document.getElementById('deleteMaterialId').value = material.id;
        document.getElementById('deleteMaterialTitle').textContent = material.title;
        document.getElementById('deleteMaterialDesc').textContent = material.desc;
        const fileIcon = getFileIcon(material.type);
        const iconElement = document.getElementById('deleteFileIcon');
        iconElement.className = `file-icon file-${material.type}`;
        iconElement.innerHTML = `<i class="${fileIcon}"></i>`;
        bootstrap.Modal.getOrCreateInstance(document.getElementById('deleteMaterialModal')).show();
    }
}


function loadMaterials(courseId, sectionId) {
    currentCourseId = courseId;
    currentSectionId = sectionId;
    $.ajax({
        type: "POST",
        url: "MaterialManagement.aspx/GetSectionInfo",
        data: JSON.stringify({ sectionId: sectionId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            const section = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
            document.getElementById('sectionTitle').textContent = section.name || "Section Title";
            document.getElementById('sectionDescription').textContent = section.desc || "Section description";
        }
    });

    // Fetch materials
    $.ajax({
        type: "POST",
        url: "MaterialManagement.aspx/GetSectionMaterials",
        data: JSON.stringify({ courseId: courseId, sectionId: sectionId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            loadedMaterials = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
            renderMaterialsTable(loadedMaterials);
        }
    });
}

function updateMaterial() {
    // Validate form first
    const materialId = document.getElementById('editMaterialId').value;
    const title = document.getElementById('editMaterialTitle').value.trim();
    const type = document.getElementById('editMaterialType').value;
    const description = document.getElementById('editMaterialDescription').value.trim();
    const status = document.getElementById('editMaterialStatus').value;
    const tags = document.getElementById('editMaterialTags').value.trim();
    const fileInput = document.getElementById('editMaterialFile');
    
    if (!title || !type) {
        showSuccessMessage("Please fill all required fields.");
        return;
    }

    // Show spinner after validation
    showUploadSpinner();
    
    // Check if a new file was selected
    const file = fileInput.files.length > 0 ? fileInput.files[0] : null;

    // If a new file is selected, upload it first
    if (file) {
        // Upload new file and then update material info
        const formData = new FormData();
        formData.append('file', file);
        formData.append('sectionId', currentSectionId);
        formData.append('courseId', currentCourseId);
        formData.append('title', title);
        formData.append('materialType', type);
        formData.append('description', description);
        formData.append('status', status);

        // Upload new file and then update material info
$.ajax({
    url: 'FileUpdateHandler.ashx',
    type: 'POST',
    data: formData,
    processData: false,
    contentType: false,
    success: function(response) {
        if (typeof response === "string") {
            try {
                response = JSON.parse(response);
            } catch (e) {
                console.error("Error parsing response:", e);
            }
        }
        
        if (response.success) {
            // File uploaded successfully, NOW update the material metadata
            saveMaterialUpdate(materialId, title, type, description, status, tags, 
                               response.fileName, response.filePath, response.fileSize);
        } else {
            hideUploadSpinner();
            showSuccessMessage("File upload failed: " + (response.error || "Unknown error"));
        }
    },
    error: function(xhr) {
        hideUploadSpinner();
        console.error("File upload error:", xhr);
        showSuccessMessage("File upload failed. Please try again.");
    }
});
    } else {
        // No new file, just update the material info with empty file values
        saveMaterialUpdate(materialId, title, type, description, status, tags, "", "", 0);
    }
}

function startDownload() {
    const materialId = document.getElementById('downloadMaterialId').value;
    if (!materialId) {
        alert("Material not found.");
        return;
    }
    // Start file download by navigating to the handler
    window.location.href = 'FileDownloadHandler.ashx?id=' + encodeURIComponent(materialId);
}

function saveMaterialUpdate(materialId, title, type, description, status, tags, fileName, filePath, fileSize) {
    $.ajax({
        type: "POST",
        url: "MaterialManagement.aspx/UpdateMaterial",
        data: JSON.stringify({
            materialId: parseInt(materialId),
            title: title,
            type: type,
            description: description || "",
            status: status,
            tags: tags || "",
            fileName: fileName || "",
            filePath: filePath || "",
            fileSize: fileSize || 0
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            let result = res.d;
            
            // Parse the result if it's a string
            if (typeof result === "string") {
                try {
                    result = JSON.parse(result);
                } catch (e) {
                    console.error("Error parsing result:", e);
                }
            }
            
            if (result && result.success) {
                // First close the modal, then hide spinner and show message to avoid flickering
                const modalElement = document.getElementById('editMaterialModal');
                const modalInstance = bootstrap.Modal.getInstance(modalElement);
                if (modalInstance) {
                    modalInstance.hide();
                } else {
                    // jQuery fallback
                    $(modalElement).modal('hide');
                }
                
                // Reset form and refresh data
                document.getElementById('editMaterialForm').reset();
                loadMaterials(currentCourseId, currentSectionId);
                
                // Now hide spinner and show message
                hideUploadSpinner();
                showSuccessMessage("Material updated successfully!");
            } else {
                hideUploadSpinner();
                showSuccessMessage("Failed to update material: " + (result?.error || "Unknown error"));
            }
        },
        error: function(xhr) {
            hideUploadSpinner();
            console.error("AJAX error:", xhr);
            showSuccessMessage("Failed to update material. Please try again.");
        }
    });
}



function renderMaterialsTable(materials) {
    const tbody = document.getElementById('materialsTableBody');
    tbody.innerHTML = "";
    materials.forEach((mat, idx) => {
        const fileIcon = getFileIcon(mat.type);
        const fileClass = "file-" + (mat.type || "default");
        tbody.innerHTML += `
            <tr>
                <td>
                    <div class="d-flex align-items-center">
                        <div class="file-icon ${fileClass} me-2">
                            <i class="${fileIcon}"></i>
                        </div>
                        <div>
                            <div class="fw-semibold">${mat.title}</div>
                            <div class="small text-muted">${mat.desc}</div>
                            <div class="small text-muted"><i class="fa fa-tags me-1"></i>${mat.tags}</div>
                        </div>
                    </div>
                </td>
                <td>${getTypeLabel(mat.type)}</td>
                <td>${mat.size}</td>
                <td>${mat.uploaded}</td>
                <td>${getStatusBadge(mat.status)}</td>
                <td>
                    <button type="button" class="btn btn-sm-custom btn-outline-primary" onclick="downloadMaterial(${mat.id})" title="Download">
                        <i class="fas fa-download"></i>
                    </button>
                    <button type="button" class="btn btn-sm-custom btn-outline-warning" onclick="editMaterial(${mat.id})" title="Edit">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button type="button" class="btn btn-sm-custom btn-outline-danger" onclick="deleteMaterial(${mat.id})" title="Delete">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    });
}

function confirmDeleteMaterial() {
    const materialId = document.getElementById('deleteMaterialId').value;
    if (!materialId) {
        showSuccessMessage("Material not found.");
        return;
    }

    // AJAX call to backend to delete the material
    $.ajax({
        type: "POST",
        url: "MaterialManagement.aspx/DeleteMaterial",
        data: JSON.stringify({ materialId: materialId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            let result = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
            if (result.success) {
                showSuccessMessage("Material deleted successfully!");
                bootstrap.Modal.getInstance(document.getElementById('deleteMaterialModal')).hide();
                loadMaterials(currentCourseId, currentSectionId);
            } else {
                showSuccessMessage("Failed to delete material: " + (result.error || "Unknown error"));
            }
        },
        error: function() {
            showSuccessMessage("Failed to delete material (AJAX error).");
        }
    });
}


     function downloadMaterial(id) {
    const material = loadedMaterials.find(m => m.id == id);
    if (material) {
        document.getElementById('downloadMaterialId').value = material.id;
        document.getElementById('downloadMaterialTitle').textContent = material.title;
        document.getElementById('downloadMaterialType').textContent = material.type.toUpperCase();
        document.getElementById('downloadMaterialSize').textContent = material.size;
        const iconElement = document.getElementById('downloadFileIcon');
        iconElement.className = `file-icon file-${material.type}`;
        iconElement.innerHTML = `<i class="${getFileIcon(material.type)}"></i>`;
        bootstrap.Modal.getOrCreateInstance(document.getElementById('downloadMaterialModal')).show();
    }
}

// Real-time file validation for Add Material
function validateFileInRealTime() {
    const fileInput = document.getElementById('materialFile');
    const materialType = document.getElementById('materialType').value;
    const file = fileInput.files[0];
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
function showValidationMessage(message, type) {
    const fileInput = document.getElementById('materialFile');
    const existingMessage = fileInput.parentNode.querySelector('.validation-message');
    if (existingMessage) existingMessage.remove();
    const messageDiv = document.createElement('div');
    messageDiv.className = `validation-message alert ${type === 'error' ? 'alert-danger' : 'alert-success'} mt-2`;
    messageDiv.style.fontSize = '12px';
    messageDiv.style.padding = '8px 12px';
    messageDiv.innerHTML = `<i class="fas ${type === 'error' ? 'fa-exclamation-triangle' : 'fa-check-circle'} me-2"></i>${message}`;
    fileInput.parentNode.appendChild(messageDiv);
}
function clearValidationMessage() {
    const existingMessage = document.querySelector('.validation-message');
    if (existingMessage) existingMessage.remove();
}

// Real-time file validation for Edit Material
function validateEditFileInRealTime() {
    const fileInput = document.getElementById('editMaterialFile');
    const materialType = document.getElementById('editMaterialType').value;
    const file = fileInput.files[0];
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
    if (existingMessage) existingMessage.remove();
    const messageDiv = document.createElement('div');
    messageDiv.className = `edit-validation-message alert ${type === 'error' ? 'alert-danger' : 'alert-success'} mt-2`;
    messageDiv.style.fontSize = '12px';
    messageDiv.style.padding = '8px 12px';
    messageDiv.innerHTML = `<i class="fas ${type === 'error' ? 'fa-exclamation-triangle' : 'fa-check-circle'} me-2"></i>${message}`;
    fileInput.parentNode.appendChild(messageDiv);
}
function clearEditValidationMessage() {
    const existingMessage = document.querySelector('.edit-validation-message');
    if (existingMessage) existingMessage.remove();
}

// File type validation function
function validateFileType(file, selectedType) {
            if (typeof selectedType !== 'string') selectedType = '';
    const fileName = file.name.toLowerCase();
    const fileExtension = fileName.split('.').pop();
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
    if (selectedType === 'other') {
        return { isValid: true, message: '' };
    }
    const allowedExts = allowed[selectedType]?.extensions || [];
    const allowedMimes = allowed[selectedType]?.mimeTypes || [];
    if (!allowedExts.includes(fileExtension) || (allowedMimes.length && !allowedMimes.includes(file.type))) {
        const expectedFormats = allowedExts.join(', ').toUpperCase();
        return {
            isValid: false,
            message: `File type mismatch! You selected "${selectedType.toUpperCase()}" but uploaded a "${fileExtension.toUpperCase()}" file.\n\nFor ${selectedType.toUpperCase()} type, please upload: ${expectedFormats}\n\nOr change the Material Type to match your file.`
        };
    }
    return { isValid: true, message: '' };
}

// Show success toast
function showSuccessMessage(message) {
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

// --- Event Listeners and Initialization ---
document.addEventListener('DOMContentLoaded', function() {
renderMaterialsTable(loadedMaterials);
const urlParams = new URLSearchParams(window.location.search);
    const courseId = urlParams.get('course');
    const sectionId = urlParams.get('section');
    if (courseId && sectionId) {
        loadMaterials(courseId, sectionId);
    }
    // Add Material Modal validation
    const fileInput = document.getElementById('materialFile');
    const materialTypeSelect = document.getElementById('materialType');
    fileInput.addEventListener('change', validateFileInRealTime);
    materialTypeSelect.addEventListener('change', validateFileInRealTime);

    // Clear validation when modal is closed
    const addMaterialModal = document.getElementById('addMaterialModal');
    addMaterialModal.addEventListener('hidden.bs.modal', function() {
        clearValidationMessage();
        document.getElementById('addMaterialForm').reset();
    });

    // Edit Material Modal validation
    const editFileInput = document.getElementById('editMaterialFile');
    const editMaterialTypeSelect = document.getElementById('editMaterialType');
    editFileInput.addEventListener('change', validateEditFileInRealTime);
    editMaterialTypeSelect.addEventListener('change', validateEditFileInRealTime);
});

<%-- function uploadMaterial() {
    showUploadSpinner();

    const title = document.getElementById('materialTitle').value.trim();
    const type = document.getElementById('materialType').value;
    const description = document.getElementById('materialDescription').value.trim();
    const status = document.getElementById('materialStatus').value;
    const tags = document.getElementById('materialTags').value.trim();
    const fileInput = document.getElementById('materialFile');
    const file = fileInput.files[0];

    if (!title || !type || !file) {
        hideUploadSpinner();
        showSuccessMessage("Please fill all required fields and select a file.");
        return;
    }

    // 1. Upload file to server (send all required fields)
    const formData = new FormData();
    formData.append('file', file);
    formData.append('sectionId', currentSectionId);
    formData.append('courseId', currentCourseId);
    formData.append('title', title);
    formData.append('materialType', type);
    formData.append('description', description);
    formData.append('status', status);

    fetch('FileUploadHandler.ashx', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(fileResult => {
        if (!fileResult.success) {
            hideUploadSpinner();
            showSuccessMessage("File upload failed: " + (fileResult.error || fileResult.message));
            return;
        }
        // 2. Save material metadata to DB (optional, since handler already does it)
        showSuccessMessage("Material uploaded successfully!");
        bootstrap.Modal.getInstance(document.getElementById('addMaterialModal')).hide();
        document.getElementById('addMaterialForm').reset();
        loadMaterials(currentCourseId, currentSectionId);
        hideUploadSpinner();
    })
    .catch(async (err) => {
    hideUploadSpinner();
    let errorMsg = "File upload failed.";
    if (err && err.response && err.response.text) {
        errorMsg += " " + await err.response.text();
    }
    console.error(errorMsg);
    showSuccessMessage(errorMsg);
});
} --%>



function saveMaterialToDb(data) {
    $.ajax({
        url: 'MaterialManagement.aspx/SaveMaterial',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(data),
        dataType: 'json',
        success: function(response) {
            let result = response.d;
            
            // Parse the result if it's a string
            if (typeof result === "string") {
                try {
                    result = JSON.parse(result);
                } catch (e) {
                    console.error("Error parsing result:", e);
                }
            }
            
            if (result && result.success) {
                // Successfully saved
                hideUploadSpinner();
                showSuccessMessage('Material uploaded successfully!');
                bootstrap.Modal.getInstance(document.getElementById('addMaterialModal')).hide();
                document.getElementById('addMaterialForm').reset();
                loadMaterials(currentCourseId, currentSectionId);
            } else {
                // Failed to save
                hideUploadSpinner();
                showSuccessMessage("Failed to save material: " + (result?.error || "Unknown error"));
            }
        },
        error: function(xhr) {
            hideUploadSpinner();
            console.error("AJAX error:", xhr);
            showSuccessMessage("Failed to save material. Please try again.");
        }
    });
}


  // Material management functions
   function uploadMaterial() {
    // Validate form first
    const form = document.getElementById('addMaterialForm');
    const title = document.getElementById('materialTitle').value.trim();
    const materialType = document.getElementById('materialType').value;
    const description = document.getElementById('materialDescription').value.trim();
    const status = document.getElementById('materialStatus').value;
    const tags = document.getElementById('materialTags').value.trim();
    const fileInput = document.getElementById('materialFile');
    const file = fileInput.files[0];

    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    if (!file) {
        showSuccessMessage('Please select a file to upload.');
        return;
    }
    
    const validation = validateFileType(file, materialType);
    if (!validation.isValid) {
        showSuccessMessage(validation.message);
        return;
    }
    
    const maxSize = 50 * 1024 * 1024;
    if (file.size > maxSize) {
        showSuccessMessage('File size exceeds 50MB limit. Please choose a smaller file.');
        return;
    }

    // Show spinner after validation passes
    showUploadSpinner();

    // Prepare form data for AJAX upload
    const formData = new FormData();
    formData.append('file', file);
    formData.append('sectionId', currentSectionId);
    formData.append('courseId', currentCourseId);
    formData.append('title', title);
    formData.append('materialType', materialType);
    formData.append('description', description);
    formData.append('status', status);

    $.ajax({
        url: 'FileUploadHandler.ashx',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            try {
                if (typeof response === "string") {
                    response = JSON.parse(response);
                }
                
                if (response.success) {
    hideUploadSpinner();
    showSuccessMessage('Material uploaded successfully!');
    
    // Safe modal handling
    const modalElement = document.getElementById('addMaterialModal');
    const modalInstance = bootstrap.Modal.getInstance(modalElement);
    if (modalInstance) {
        modalInstance.hide();
    } else {
        // jQuery fallback if needed
        $(modalElement).modal('hide');
    }
    
    document.getElementById('addMaterialForm').reset();
    loadMaterials(currentCourseId, currentSectionId);
} else {
    hideUploadSpinner();
    showSuccessMessage("File upload failed: " + (response.error || "Unknown error"));
}
            } catch (err) {
                hideUploadSpinner();
                console.error("Error parsing response:", err);
                showSuccessMessage("Error processing server response");
            }
        },
        error: function(xhr) {
            hideUploadSpinner();
            showSuccessMessage("File upload failed: " + (xhr.responseText || 'Unknown error'));
        }
    });
}




function showUploadSpinner() {
    document.getElementById('uploadSpinner').style.display = 'flex';
}

function hideUploadSpinner() {
    document.getElementById('uploadSpinner').style.display = 'none';
}
</script>
</asp:Content>
