<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Materials.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Materials" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Material Management - Teacher</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
	<style>
		body { font-family: 'Roboto'SS, sans-serif; background-color: #f8f9fa; }
		.material-container { padding: 20px; max-width: 1400px; margin: 0 auto; }
		.page-header { background: linear-gradient(135deg, #2c2b7c, #0056b3); color: white; padding: 30px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 8px 25px rgba(44, 43, 124, 0.15); }
		.breadcrumb-nav { background: white; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }
		.breadcrumb-nav .breadcrumb { margin: 0; }
		.breadcrumb-nav .breadcrumb-item a { color: #2c2b7c; text-decoration: none; font-weight: 500; }
		.breadcrumb-nav .breadcrumb-item a:hover { text-decoration: underline; }
		.course-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px; }
		.course-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); transition: all 0.3s ease; cursor: pointer; border: 2px solid transparent; }
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

		/* Add this to your <style> section for a modern, clean stat block look */
#courseStatsRow .bg-white {
    border-radius: 18px;
    box-shadow: 0 4px 18px rgba(44,43,124,0.08);
    border: 1.5px solid #f1f3f4;
    transition: box-shadow 0.2s, border 0.2s;
    min-height: 110px;
}
#courseStatsRow .bg-white:hover {
    box-shadow: 0 8px 32px rgba(44,43,124,0.13);
    border-color: #2c2b7c22;
}
#courseStatsRow .h2 {
    font-weight: 700;
    letter-spacing: 1px;
}
#courseStatsRow .text-success {
    color: #1e7e34 !important;
}
#courseStatsRow .text-primary {
    color: #2c2b7c !important;
}
#courseStatsRow .text-info {
    color: #0dcaf0 !important;
}
#courseStatsRow .text-warning {
    color: #ffc107 !important;
}
#courseStatsRow .small {
    font-size: 1rem;
    font-weight: 500;
    letter-spacing: 0.5px;
    opacity: 0.85;
}
@media (max-width: 767px) {
    #courseStatsRow .col-md-3 {
        margin-bottom: 1rem;
    }
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
			Materials
		</h1>
		<p class="mb-0 opacity-75">Manage and share course materials and resources</p>
	</div>
	<!-- Breadcrumb Navigation -->
	<div class="breadcrumb-nav">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb" id="breadcrumb">
				<li class="breadcrumb-item active">All Courses</li>
			</ol>
		</nav>
	</div>
	<!-- VIEW 1: Course List -->
	<div id="courseListView" class="view-active">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h3 class="text-primary">
				<i class="fas fa-graduation-cap me-2"></i>
				Select a Course
			</h3>
			<div class="text-muted">
				<i class="fas fa-info-circle me-1"></i>
				Click on a course to manage its materials
			</div>
		</div>
		<div class="course-grid" id="courseGrid">
			<!-- Courses will be loaded here -->
		</div>
	</div>
	<!-- VIEW 2: Course Details & Sections -->
	<div id="courseDetailsView" class="course-details">
		<button class="back-btn mb-4" onclick="showCourseList()">
			<i class="fas fa-arrow-left"></i>
			Back to Courses
		</button>
		<div class="course-info-card">
			<div class="row align-items-center">
				<div class="col-md-8">
					<h3 class="text-primary mb-2" id="selectedCourseTitle">Course Title</h3>
					<p class="text-muted mb-0" id="selectedCourseDesc">Course description and details</p>
				</div>
				<div class="col-md-4 text-end">
					<div class="d-flex justify-content-end gap-3">
						<div class="text-center">
							<div class="h4 text-success mb-0" id="totalSections">0</div>
							<small class="text-muted">Sections</small>
						</div>
						<div class="text-center">
							<div class="h4 text-warning mb-0" id="totalMaterials">0</div>
							<small class="text-muted">Materials</small>
						</div>
					</div>
				</div>
			</div>
		</div>

		

<!-- Place this block just after the course-info-card and before the "Course Sections" header in #courseDetailsView -->
<div class="row g-3 mb-4" id="courseStatsRow">
    <div class="col-md-3">
        <div class="bg-white rounded-3 shadow-sm p-3 text-center">
            <div class="h2 text-success mb-1" id="statTotalSections">0</div>
            <div class="small text-muted">Total Sections</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="bg-white rounded-3 shadow-sm p-3 text-center">
            <div class="h2 text-primary mb-1" id="statTotalMaterials">0</div>
            <div class="small text-muted">Total Materials</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="bg-white rounded-3 shadow-sm p-3 text-center">
            <div class="h2 text-info mb-1" id="statEnrolledStudents">0</div>
            <div class="small text-muted">Enrolled Students</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="bg-white rounded-3 shadow-sm p-3 text-center">
            <div class="h2 text-warning mb-1" id="statCompletionRate">0%</div>
            <div class="small text-muted">Completion Rate</div>
        </div>
    </div>
</div>

		<div class="d-flex justify-content-between align-items-center mb-4">
			<h4 class="text-primary">
				<i class="fas fa-list me-2"></i>
				Course Sections
			</h4>
			<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSectionModal">
				<i class="fas fa-plus me-2"></i>
				Add New Section
			</button>
		</div>
		<div class="sections-grid" id="sectionsGrid">
			<!-- Sections will be loaded here -->
		</div>
	</div>
</div>
<!-- Add Section Modal -->
<div class="modal fade" id="addSectionModal" tabindex="-1">
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
				<button type="button" class="btn btn-primary" onclick="addSection()">
					<i class="fas fa-save me-2"></i>Add Section
				</button>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>


let selectedCourseId = null;
let loadedCourses = []; // Store loaded courses for stats and info

// Fetch and render courses from backend
function renderTeacherCourses() {
    $.ajax({
        type: "POST",
        url: "Materials.aspx/GetTeacherCourses",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            const courses = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
            loadedCourses = courses;
            const grid = document.getElementById('courseGrid');
            grid.innerHTML = '';
            courses.forEach(course => {
                grid.innerHTML += `
                    <div class="course-card fade-in" onclick="showCourseDetails(${course.id})">
                        <div class="course-icon mb-2"><i class="fas fa-book"></i></div>
                        <h5>${course.name}</h5>
                        <div class="text-muted mb-2" style="min-height:40px;">${course.description}</div>
                        <div class="course-meta">
                            <span class="sections-count"><i class="fas fa-list me-1"></i>${course.sections} Sections</span>
                            <span class="materials-count"><i class="fas fa-file-alt me-1"></i>${course.materials} Materials</span>
                        </div>
                    </div>
                `;
            });
        }
    });
}

// Call on page load
document.addEventListener('DOMContentLoaded', renderTeacherCourses);


function addSection() {
    const name = document.getElementById('sectionName').value.trim();
    const desc = document.getElementById('sectionDesc').value.trim();
    const order = parseInt(document.getElementById('sectionOrder').value, 10) || 1;

    if (!name) {
        alert("Section name is required.");
        return;
    }

    const btn = document.querySelector('#addSectionModal .btn-primary');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Saving...';

    $.ajax({
        type: "POST",
        url: "Materials.aspx/AddSection",
        data: JSON.stringify({
            courseId: selectedCourseId,
            name: name,
            desc: desc,
            order: order
        }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            let result = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-save me-2"></i>Add Section';
            if (result.success) {
                var modal = bootstrap.Modal.getInstance(document.getElementById('addSectionModal'));
                if (modal) modal.hide();
                document.getElementById('addSectionForm').reset();
                const fadeRemove = document.querySelector('.modal-backdrop');
                if (fadeRemove) fadeRemove.remove();
                showCourseDetails(selectedCourseId);
            } else {
                alert("Failed to add section: " + (result.error || "Unknown error"));
            }
        },
        error: function() {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-save me-2"></i>Add Section';
            alert("Failed to add section (AJAX error).");
        }
    });
}


// Redirect to material management page
function redirectToMaterialManagement(courseId, sectionId) {
    window.location.href = `MaterialManagement.aspx?course=${courseId}&section=${sectionId}`;
}

// Show course details and sections from backend
function showCourseDetails(courseId) {
    selectedCourseId = courseId;

    // Show/hide views
    document.getElementById('courseListView').classList.remove('view-active');
    document.getElementById('courseListView').classList.add('hidden');
    document.getElementById('courseDetailsView').classList.remove('hidden');
    document.getElementById('courseDetailsView').classList.add('view-active');

    // Update breadcrumb
    const course = loadedCourses.find(c => String(c.id) === String(courseId));
    document.getElementById('breadcrumb').innerHTML = `
        <li class="breadcrumb-item"><a href="#" onclick="showCourseList();return false;">All Courses</a></li>
        <li class="breadcrumb-item active">${course ? course.name : ''}</li>
    `;

    // Update course info and stats
    document.getElementById('selectedCourseTitle').textContent = course ? course.name : '';
    document.getElementById('selectedCourseDesc').textContent = course ? course.description : '';
    document.getElementById('totalSections').textContent = course ? course.sections : 0;
    document.getElementById('totalMaterials').textContent = course ? course.materials : 0;
    document.getElementById('statTotalSections').textContent = course ? course.sections : 0;
    document.getElementById('statTotalMaterials').textContent = course ? course.materials : 0;
    // Demo: random stats for enrolled students and completion rate
    document.getElementById('statEnrolledStudents').textContent = course && course.enrolledStudents ? course.enrolledStudents : 0;
    document.getElementById('statCompletionRate').textContent = course && course.completionRate ? course.completionRate + "%" : "0%";

    // Fetch sections for this course
    $.ajax({
        type: "POST",
        url: "Materials.aspx/GetCourseSections",
        data: JSON.stringify({ courseId: courseId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            const sections = typeof res.d === "string" ? JSON.parse(res.d) : res.d;
            const grid = document.getElementById('sectionsGrid');
            grid.innerHTML = '';
            sections.forEach(section => {
                grid.innerHTML += `
                    <div class="section-card">
                        <div class="section-header">
                            <div class="section-icon"><i class="fas fa-layer-group"></i></div>
                            <div>
                                <div class="fw-bold">${section.name}</div>
                                <div class="text-muted small">${section.desc}</div>
                            </div>
                        </div>
                        <div class="section-actions">
                            <button class="btn btn-view btn-sm-custom" onclick="redirectToMaterialManagement(${courseId}, ${section.id})">View/Edit Material</button>
                            <button class="btn btn-add btn-sm-custom" onclick="redirectToMaterialManagement(${courseId}, ${section.id})">Add Material</button>
                        </div>
                    </div>
                `;
            });
        }
    });
}

// Show course list view
function showCourseList() {
    document.getElementById('courseDetailsView').classList.remove('view-active');
    document.getElementById('courseDetailsView').classList.add('hidden');
    document.getElementById('courseListView').classList.remove('hidden');
    document.getElementById('courseListView').classList.add('view-active');
    // Reset breadcrumb
    document.getElementById('breadcrumb').innerHTML = `<li class="breadcrumb-item active">All Courses</li>`;
}

// Add this function after your existing JS



</script>
</asp:Content>
