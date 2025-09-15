<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Assignments" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<!-- Bootstrap JS (required for modals) -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>

@keyframes fadeIn {
	from { opacity: 0; transform: translateY(30px); }
	to { opacity: 1; transform: translateY(0); }
}
@keyframes spin {
	100% { transform: rotate(360deg); }
}

.btn-gradient-primary {
	background: linear-gradient(135deg, #1976d2, #2c2b7c);
	color: #fff;
	border: none;
	border-radius: 10px;
	font-weight: 500;
	font-size: 1.08rem;
	padding: 0.6rem 2.2rem;
	transition: background 0.2s;
	box-shadow: 0 2px 8px rgba(44,43,124,0.10);
}
.btn-gradient-primary:hover {
	background: linear-gradient(135deg, #0056b3, #2c2b7c);
	color: #fff;
}
/* Custom style for switch label spacing */
#assignmentStatusLabel {
	margin-left: 0.5rem;
	font-weight: 500;
	color: #1976d2;
}

</style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid px-0">
	<!-- Page Header -->
	<div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
		<div>
			<h2 class="fw-bold mb-1" style="color:#2c2b7c;">Assignments</h2>
			<p class="text-muted mb-0">Manage and review assignments for your courses.</p>
		</div>
		<div class="d-flex gap-2 align-items-center mt-3 mt-md-0">
			<input type="text" id="searchAssignments" class="form-control rounded-pill shadow-sm" style="min-width:220px;" placeholder="Search assignments..."/>
			<select class="form-select rounded-pill shadow-sm" style="min-width:150px;">
				<option value="">All Courses</option>
			</select>
			<button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addAssignmentModal"><i class="fa fa-plus me-2"></i>Add Assignment</button>
		</div>
	</div>

	<!-- Animated Loading Spinner -->
	<div id="assignmentsLoading" class="justify-content-center align-items-center my-5" style="height:120px; display: none;">
		<div class="spinner-border text-primary" style="width:3rem; height:3rem; animation: spin 1s linear infinite;"></div>
	</div>


	<!-- Assignments Table (fade-in animation) -->
	<div id="assignmentsTableWrapper" class="table-responsive" style="display:none; animation: fadeIn 0.7s ease;">
		<table class="table table-hover align-middle rounded-4 overflow-hidden shadow-sm bg-white">
			<thead class="table-light">
				<tr>
					<th scope="col">#</th>
					<th scope="col">Title</th>
					<th scope="col">Course</th>
					<th scope="col">Due Date</th>
					<th scope="col">Status</th>
					<th scope="col">PDF</th>
					<th scope="col">Actions</th>
				</tr>
			</thead>
			<tbody>
				
			</tbody>
		</table>
	</div>
<!-- Add Assignment Modal -->
<div class="modal fade" id="addAssignmentModal" tabindex="-1">
	<div class="modal-dialog modal-md">
		<div class="modal-content rounded-4">
			<div class="modal-header bg-primary text-white rounded-top-4">
				<h5 class="modal-title fw-bold"><i class="fa fa-plus me-2"></i>Add Assignment</h5>
				<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
			</div>
			<form id="addAssignmentForm" autocomplete="off">
				<div class="modal-body p-4">
					<div class="mb-3">
						<label for="assignmentTitle" class="form-label fw-semibold">Title</label>
						<input type="text" class="form-control rounded-pill" id="assignmentTitle" required>
					</div>
					<div class="mb-3">
						<label for="assignmentCourse" class="form-label fw-semibold">Course</label>
						<select class="form-select rounded-pill" id="assignmentCourse" required>
							<option value="">Select Course</option>
						</select>
					</div>
					<div class="mb-3">
						<label for="assignmentDueDate" class="form-label fw-semibold">Due Date</label>
						<input type="date" class="form-control rounded-pill" id="assignmentDueDate" required min="">
					</div>
								<div class="mb-3">
									<label for="assignmentDescription" class="form-label fw-semibold">Description</label>
									<textarea class="form-control rounded-3" id="assignmentDescription" rows="3"></textarea>
								</div>
											<div class="mb-3">
												<label for="assignmentPDF" class="form-label fw-semibold">Attach PDF (optional)</label>
												<input type="file" class="form-control" id="assignmentPDF" accept="application/pdf">
												<div class="form-text">Only PDF files are allowed. Max size: 10MB.</div>
											</div>
											<div class="mb-3 d-flex align-items-center justify-content-between">
												<label for="assignmentStatus" class="form-label fw-semibold mb-0">Status</label>
												<div class="form-check form-switch">
													<input class="form-check-input" type="checkbox" id="assignmentStatus" checked>
													<label class="form-check-label" for="assignmentStatus" id="assignmentStatusLabel">Active</label>
												</div>
											</div>
				</div>
				<div class="modal-footer bg-light border-0 rounded-bottom-4">
					<button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-gradient-primary rounded-pill px-4"><i class="fa fa-check me-2"></i>Add</button>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- View Assignment Modal -->
<div class="modal fade" id="viewAssignmentModal" tabindex="-1">
	<div class="modal-dialog modal-md">
		<div class="modal-content rounded-4">
			<div class="modal-header bg-primary text-white rounded-top-4">
				<h5 class="modal-title fw-bold"><i class="fa fa-eye me-2"></i>Assignment Details</h5>
				<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body p-4">
				<div class="mb-3">
					<span class="fw-semibold text-primary"><i class="fa fa-book me-2"></i>Title:</span>
					<span id="viewAssignmentTitle" class="ms-2"></span>
				</div>
				<div class="mb-3">
					<span class="fw-semibold text-primary"><i class="fa fa-graduation-cap me-2"></i>Course:</span>
					<span id="viewAssignmentCourse" class="ms-2"></span>
				</div>
				<div class="mb-3">
					<span class="fw-semibold text-primary"><i class="fa fa-calendar-alt me-2"></i>Due Date:</span>
					<span id="viewAssignmentDue" class="ms-2"></span>
				</div>
				<div class="mb-3">
					<span class="fw-semibold text-primary"><i class="fa fa-info-circle me-2"></i>Status:</span>
					<span id="viewAssignmentStatus" class="ms-2"></span>
				</div>
				<div>
					<span class="fw-semibold text-primary"><i class="fa fa-align-left me-2"></i>Description:</span>
					<div id="viewAssignmentDescription" class="ms-4 mt-1 text-secondary"></div>
				</div>
				<div id="viewAssignmentPDF" class="mb-2"></div>
			</div>
			<div class="modal-footer bg-light border-0 rounded-bottom-4">
				<button type="button" class="btn btn-gradient-primary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="editAssignmentModal" tabindex="-1">
    <div class="modal-dialog modal-md">
        <div class="modal-content rounded-4">
            <div class="modal-header bg-warning text-dark rounded-top-4">
                <h5 class="modal-title fw-bold"><i class="fa fa-edit me-2"></i>Edit Assignment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="editAssignmentForm" autocomplete="off">
                <div class="modal-body p-4">
                    <input type="hidden" id="editAssignmentId">
                    <div class="mb-3">
                        <label for="editAssignmentTitle" class="form-label fw-semibold">Title</label>
                        <input type="text" class="form-control rounded-pill" id="editAssignmentTitle" required>
                    </div>
                    <div class="mb-3">
                        <label for="editAssignmentDueDate" class="form-label fw-semibold">Due Date</label>
                        <input type="date" class="form-control rounded-pill" id="editAssignmentDueDate" required min="">
                    </div>
                    <div class="mb-3">
                        <label for="editAssignmentDescription" class="form-label fw-semibold">Description</label>
                        <textarea class="form-control rounded-3" id="editAssignmentDescription" rows="3"></textarea>
                    </div>
					<div class="mb-3">
						<label for="editAssignmentPDF" class="form-label fw-semibold">Attach PDF (optional)</label>
						<input type="file" class="form-control" id="editAssignmentPDF" accept="application/pdf">
						<div class="form-text">Only PDF files are allowed. Max size: 10MB.</div>
					</div>
					<div id="editAssignmentCurrentPDF" class="mb-2"></div>
                    <div class="mb-3 d-flex align-items-center justify-content-between">
                        <label for="editAssignmentStatus" class="form-label fw-semibold mb-0">Status</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="editAssignmentStatus">
                            <label class="form-check-label" for="editAssignmentStatus" id="editAssignmentStatusLabel">Active</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0 rounded-bottom-4">
                    <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-gradient-primary rounded-pill px-4"><i class="fa fa-check me-2"></i>Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

    <script src="../../Assest/css/bootstrap-5.2.3-dist/js/bootstrap.bundle.min.js"></script>
    <script src="../../Assest/fontawesome-free-6.7.2-web/js/all.min.js"></script>

<script>
// Update status label text on switch toggle
document.getElementById('assignmentStatus').addEventListener('change', function() {
	document.getElementById('assignmentStatusLabel').textContent = this.checked ? 'Active' : 'Inactive';
});

function populateAssignmentCourses() {
    fetch('Assignments.aspx/GetTeacherCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        const courses = JSON.parse(data.d);
        // For filter dropdown
        const filterSelect = document.querySelector('.form-select.rounded-pill.shadow-sm');
        filterSelect.innerHTML = `<option value="">All Courses</option>`;
        courses.forEach(c => {
            filterSelect.innerHTML += `<option value="${c.CourseCode}">${c.CourseCode} - ${c.CourseName}</option>`;
        });
        // For add-assignment modal
        const modalSelect = document.getElementById('assignmentCourse');
        modalSelect.innerHTML = `<option value="">Select Course</option>`;
        courses.forEach(c => {
            modalSelect.innerHTML += `<option value="${c.CourseCode}">${c.CourseCode} - ${c.CourseName}</option>`;
        });
    });
}

function fetchAssignments() {
    const courseCode = document.querySelector('.form-select.rounded-pill.shadow-sm').value;
    const search = document.querySelector('#searchAssignments').value.trim();

    document.getElementById("assignmentsLoading").style.display = "flex";
    document.getElementById("assignmentsTableWrapper").style.display = "none";

    fetch('Assignments.aspx/GetAssignments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ courseCode: courseCode, search: search })
    })
    .then(res => res.json())
    .then(data => {
        const assignments = JSON.parse(data.d);
        const tbody = document.querySelector("#assignmentsTableWrapper tbody");
        tbody.innerHTML = "";
        if (assignments.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" class="text-center text-muted">No assignments found.</td></tr>`;
        } else {
            assignments.forEach((a, i) => {
    tbody.innerHTML += `
    <tr>
        <th>${i + 1}</th>
        <td>${a.Title}</td>
        <td>${a.CourseCode}</td>
        <td>${a.DueDate}</td>
        <td><span class="badge ${a.Status === 'Open' ? 'bg-success' : 'bg-secondary'} bg-opacity-75">${a.Status}</span></td>
        <td>
            ${a.FilePath 
                ? `<a href="${a.FilePath.replace('~', '')}" target="_blank" class="btn btn-outline-info btn-sm rounded-pill px-3" title="Download PDF">
                    <i class="fa fa-file-pdf"></i> PDF
                   </a>`
                : `<span class="text-muted">No PDF</span>`
            }
        </td>
		<td>
            <button class="btn btn-outline-primary btn-sm rounded-pill px-3 view-assignment-btn"
                data-assignment='${JSON.stringify(a)}'>
                <i class="fa fa-eye"></i> View
            </button>
            <button class="btn btn-outline-warning btn-sm rounded-pill px-3 edit-assignment-btn"
                data-assignment='${JSON.stringify(a)}'>
                <i class="fa fa-edit"></i> Edit
            </button>
            <button class="btn btn-outline-danger btn-sm rounded-pill px-3 delete-assignment-btn"
                data-id="${a.AssignmentID}">
                <i class="fa fa-trash"></i> Delete
            </button>
        </td>
    </tr>
    `;
});
        }
        document.getElementById("assignmentsLoading").style.display = "none";
        document.getElementById("assignmentsTableWrapper").style.display = "block";

        // Attach view button events
        document.querySelectorAll('.view-assignment-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const data = JSON.parse(this.getAttribute('data-assignment'));
                document.getElementById('viewAssignmentTitle').textContent = data.Title;
                document.getElementById('viewAssignmentCourse').textContent = data.CourseCode;
                document.getElementById('viewAssignmentDue').textContent = data.DueDate;
                document.getElementById('viewAssignmentStatus').textContent = data.Status;
                document.getElementById('viewAssignmentDescription').textContent = data.Description;
				document.getElementById('viewAssignmentPDF').innerHTML = data.FilePath
				? `<a href="${data.FilePath.replace('~', '')}" target="_blank" class="btn btn-outline-info btn-sm"><i class="fa fa-file-pdf"></i> Download PDF</a>`
				: `<span class="text-muted">No PDF uploaded</span>`;
                const modal = new bootstrap.Modal(document.getElementById('viewAssignmentModal'));
                modal.show();
            });
        });
    })
    .catch(() => {
        document.getElementById("assignmentsLoading").style.display = "none";
        document.getElementById("assignmentsTableWrapper").style.display = "block";
        const tbody = document.querySelector("#assignmentsTableWrapper tbody");
        tbody.innerHTML = `<tr><td colspan="6" class="text-center text-danger">Failed to load assignments.</td></tr>`;
    });
}

document.getElementById('addAssignmentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const title = document.getElementById('assignmentTitle').value.trim();
    const courseCode = document.getElementById('assignmentCourse').value;
    const dueDate = document.getElementById('assignmentDueDate').value;
    const description = document.getElementById('assignmentDescription').value.trim();
    const isActive = document.getElementById('assignmentStatus').checked;
    const status = isActive ? "Open" : "Closed";
    const pdfInput = document.getElementById('assignmentPDF');

    const file = pdfInput.files[0];
	const today = new Date().toISOString().split('T')[0];
    if (dueDate < today) {
        showToast('Due date cannot be in the past.', 'warning');
        return;
    }
    // If file is selected, upload it first
    if (file) {
        if (file.type !== 'application/pdf') {
            showToast('Only PDF files are allowed.', 'warning');
            return;
        }
        if (file.size > 10 * 1024 * 1024) {
            showToast('PDF file must be less than 10MB.', 'warning');
            return;
        }
        var formData = new FormData();
        formData.append('file', file);

        fetch('AssignmentsUpload.ashx', {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                submitAssignment(title, courseCode, dueDate, description, status, data.filePath);
            } else {
                showToast(data.message || 'File upload failed.', 'error');
            }
        });
    } else {
        submitAssignment(title, courseCode, dueDate, description, status, "");
    }
});

function submitAssignment(title, courseCode, dueDate, description, status, filePath) {
    fetch('Assignments.aspx/AddAssignment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, courseCode, dueDate, description, status, filePath })
    })
    .then(res => res.json())
    .then(data => {
        const result = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
		if (result.success) {
			const modalEl = document.getElementById('addAssignmentModal');
			const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
			modalInstance.hide();
			// Do NOT add another event listener here!
			// Select all modal backdrops
			const backdrops = document.querySelectorAll('.modal-backdrop');
			backdrops.forEach(backdrop => backdrop.remove());
		
		} else {
			showToast(result.message || 'Failed to add assignment.', 'error');
		}
    });
}

// Edit button event
document.addEventListener('click', function(e) {
    if (e.target.closest('.edit-assignment-btn')) {
        const data = JSON.parse(e.target.closest('.edit-assignment-btn').getAttribute('data-assignment'));
        document.getElementById('editAssignmentId').value = data.AssignmentID;
        document.getElementById('editAssignmentTitle').value = data.Title;
        document.getElementById('editAssignmentDueDate').value = data.DueDate;
        document.getElementById('editAssignmentDescription').value = data.Description;
        document.getElementById('editAssignmentStatus').checked = data.Status === "Open";
        document.getElementById('editAssignmentStatusLabel').textContent = data.Status === "Open" ? "Active" : "Inactive";
        // Show current PDF link if exists
        document.getElementById('editAssignmentCurrentPDF').innerHTML = data.FilePath
            ? `<a href="${data.FilePath.replace('~', '')}" target="_blank" class="btn btn-outline-info btn-sm"><i class="fa fa-file-pdf"></i> Current PDF</a>`
            : `<span class="text-muted">No PDF uploaded</span>`;
        new bootstrap.Modal(document.getElementById('editAssignmentModal')).show();
    }
});

// Edit form submit
document.getElementById('editAssignmentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const assignmentId = document.getElementById('editAssignmentId').value;
    const title = document.getElementById('editAssignmentTitle').value.trim();
    const dueDate = document.getElementById('editAssignmentDueDate').value;
    const description = document.getElementById('editAssignmentDescription').value.trim();
    const status = document.getElementById('editAssignmentStatus').checked ? "Open" : "Closed";
    const pdfInput = document.getElementById('editAssignmentPDF');
    const file = pdfInput.files[0];

	const today = new Date().toISOString().split('T')[0];
    if (dueDate < today) {
        showToast('Due date cannot be in the past.', 'warning');
        return;
    }
    // If a new file is selected, upload it first
    if (file) {
        if (file.type !== 'application/pdf') {
            showToast('Only PDF files are allowed.', 'warning');
            return;
        }
        if (file.size > 10 * 1024 * 1024) {
            showToast('PDF file must be less than 10MB.', 'warning');
            return;
        }
        var formData = new FormData();
        formData.append('file', file);

        fetch('AssignmentsUpload.ashx', {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                submitEditAssignment(assignmentId, title, dueDate, description, status, data.filePath);
            } else {
                showToast(data.message || 'File upload failed.', 'error');
            }
        });
    } else {
        // No new file, keep existing
        submitEditAssignment(assignmentId, title, dueDate, description, status, "");
    }
});

function submitEditAssignment(assignmentId, title, dueDate, description, status, filePath) {
    fetch('Assignments.aspx/EditAssignment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ assignmentId, title, dueDate, description, status, filePath })
    })
    .then(res => res.json())
    .then(data => {
        const result = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
        if (result.success) {
            bootstrap.Modal.getInstance(document.getElementById('editAssignmentModal')).hide();
            fetchAssignments();
            setTimeout(() => showToast('Assignment updated successfully!', 'success'), 300);
        } else {
            showToast(result.message || 'Failed to update assignment.', 'error');
        }
    });
}

// Delete button event
document.addEventListener('click', async function(e) {
    if (e.target.closest('.delete-assignment-btn')) {
        const assignmentId = e.target.closest('.delete-assignment-btn').getAttribute('data-id');
        const confirmed = await confirmDialog('Are you sure you want to delete this assignment?');
        if (confirmed) {
            fetch('Assignments.aspx/DeleteAssignment', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ assignmentId })
            })
            .then(res => res.json())
            .then(data => {
                const result = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
                if (result.success) {
                    fetchAssignments();
                    setTimeout(() => showToast('Assignment deleted successfully!', 'success'), 300);
                } else {
                    showToast(result.message || 'Failed to delete assignment.', 'error');
                }
            });
        }
    }
});

// Update status label in edit modal
document.getElementById('editAssignmentStatus').addEventListener('change', function() {
    document.getElementById('editAssignmentStatusLabel').textContent = this.checked ? 'Active' : 'Inactive';
});

// Wire up search and filter
document.addEventListener("DOMContentLoaded", function() {
    populateAssignmentCourses();
    fetchAssignments();
    document.querySelector('#searchAssignments').addEventListener('input', fetchAssignments);
    document.querySelector('.form-select.rounded-pill.shadow-sm').addEventListener('change', fetchAssignments);
	const today = new Date().toISOString().split('T')[0];
    document.getElementById('assignmentDueDate').setAttribute('min', today);
    document.getElementById('editAssignmentDueDate').setAttribute('min', today);
});

// Place this ONCE, outside of any function, after your DOMContentLoaded
document.getElementById('addAssignmentModal').addEventListener('hidden.bs.modal', function () {
    document.getElementById('addAssignmentForm').reset();
    fetchAssignments();
    showToast('Assignment added successfully!', 'success');
});

function showToast(message, type = 'info') {
            try {
                if (typeof Swal !== 'undefined') {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        background: '#ffffff',
                        color: '#333333',
                        didOpen: (toast) => {
                            toast.addEventListener('mouseenter', Swal.stopTimer);
                            toast.addEventListener('mouseleave', Swal.resumeTimer);
                        }
                    });

                    Toast.fire({
                        icon: type,
                        title: message
                    });
                } else {
                    // Fallback when SweetAlert is not available
                    console.log(`${type.toUpperCase()}: ${message}`);
                    
                    // Simple browser alert for critical messages
                    if (type === 'error' || type === 'warning') {
                        showToast(`${type.toUpperCase()}: ${message}`, type);
                    }
                }
            } catch (error) {
                console.error("Error showing toast:", error);
                // Fallback to console log if the toast display fails
                console.log(`${type.toUpperCase()}: ${message}`);
            }
        }


		function confirmDialog(text) {
			return new Promise((resolve) => {
				try {
					if (typeof Swal !== 'undefined') {
						Swal.fire({
							title: 'Confirmation',
							text: text,
							icon: 'question',
							showCancelButton: true,
							confirmButtonColor: '#2c2b7c',
							cancelButtonColor: '#666666',
							confirmButtonText: '<i class="fas fa-thumbs-up"></i> Yes',
							cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
						}).then((result) => {
							resolve(result.isConfirmed);
						});
					} else {
						// Fallback for when SweetAlert is not available
						resolve(window.confirm(text));
					}
				} catch (error) {
					console.error("Error in confirmDialog:", error);
					resolve(false);
				}
			});
		}



</script>

</asp:Content>
