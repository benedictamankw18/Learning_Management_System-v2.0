<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Assignments" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Assignments - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.assignments-container {
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
		.assignment-grid {
			display: grid;
			grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
			gap: 24px;
			margin-bottom: 30px;
		}
		.assignment-card {
			background: white;
			border-radius: 15px;
			padding: 28px 24px 20px 24px;
			box-shadow: 0 5px 15px rgba(0, 0, 0, 0.09);
			transition: all 0.3s cubic-bezier(.25,.8,.25,1);
			cursor: pointer;
			border: 2px solid transparent;
			position: relative;
			overflow: hidden;
		}
		.assignment-card:hover {
			transform: translateY(-6px) scale(1.02);
			box-shadow: 0 12px 32px rgba(0, 123, 255, 0.18);
			border-color: #007bff;
		}
		.assignment-card .assignment-icon {
			width: 54px;
			height: 54px;
			background: linear-gradient(135deg, #007bff, #0056b3);
			border-radius: 12px;
			display: flex;
			align-items: center;
			justify-content: center;
			margin-bottom: 18px;
		}
		.assignment-card .assignment-icon i {
			font-size: 26px;
			color: white;
		}
		.assignment-card h5 {
			color: #2c3e50;
			margin-bottom: 10px;
			font-weight: 600;
		}
		.assignment-meta {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-top: 18px;
			padding-top: 14px;
			border-top: 1px solid #eee;
		}
		.assignment-meta .due-date {
			color: #d32f2f;
			font-size: 14px;
			font-weight: 500;
		}
		.assignment-meta .status {
			background: #e3f2fd;
			color: #1976d2;
			padding: 4px 14px;
			border-radius: 20px;
			font-size: 12px;
			font-weight: 600;
		}
		.assignment-actions {
			margin-top: 18px;
			display: flex;
			gap: 10px;
		}
		.btn-action {
			padding: 7px 16px;
			border-radius: 6px;
			border: none;
			font-size: 13px;
			font-weight: 500;
			cursor: pointer;
			transition: all 0.2s;
		}
		.btn-view {
			background: #e3f2fd;
			color: #1976d2;
		}
		.btn-submit {
			background: #e8f5e8;
			color: #2e7d32;
		}
		.btn-view:hover {
			background: #bbdefb;
		}
		.btn-submit:hover {
			background: #c8e6c9;
		}
		.no-assignments {
			text-align: center;
			color: #888;
			padding: 40px 0 20px 0;
			font-size: 1.1rem;
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
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="assignments-container animate__animated animate__fadeIn">
		<!-- Page Header -->
		<div class="page-header mb-4 animate__animated animate__fadeInDown">
			<h1 class="mb-2">
				<i class="fas fa-tasks me-3"></i>
				Assignments
			</h1>
			<p class="mb-0 opacity-75">View and manage your course assignments</p>
		</div>

		<!-- Breadcrumb Navigation -->
		<div class="breadcrumb-nav animate__animated animate__fadeInUp animate__delay-1s">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item active">All Assignments</li>
				</ol>
			</nav>
		</div>

		<!-- Assignment Grid -->
		<div class="assignment-grid animate__animated animate__fadeInUp animate__delay-2s" id="assignmentGrid">
			<!-- Assignments will be loaded here -->
		</div>
		<div class="no-assignments animate__animated animate__fadeIn animate__delay-3s" id="noAssignments" style="display:none;">
			<i class="fas fa-folder-open fa-2x mb-2 d-block"></i>
			No assignments found.
		</div>
	</div>

	<!-- Assignment Details Modal -->
	<div class="modal fade" id="assignmentDetailsModal" tabindex="-1">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-tasks me-2"></i>
						Assignment Details
					</h5>
					<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body" id="assignmentDetailsBody">
					<!-- Assignment details will be loaded here -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document.addEventListener('DOMContentLoaded', function() {
			loadAssignmentsAjax();
		});

		function loadAssignmentsAjax() {
			const grid = document.getElementById('assignmentGrid');
			const noAssignments = document.getElementById('noAssignments');
			grid.innerHTML = '';
			$.ajax({
				type: 'POST',
				url: 'Assignments.aspx/GetAllAssignments',
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function(res) {
					let assignments = res.d ? (typeof res.d === 'string' ? JSON.parse(res.d) : res.d) : [];
					if (!assignments || assignments.length === 0) {
						grid.style.display = 'none';
						noAssignments.style.display = 'block';
						return;
					}
					grid.style.display = 'grid';
					noAssignments.style.display = 'none';
					assignments.forEach(function(assignment, idx) {
						const card = document.createElement('div');
						card.className = 'assignment-card animate__animated animate__fadeInUp';
						card.onclick = function() { showAssignmentDetails(assignment); };
						card.innerHTML = `
							<div class="assignment-icon mb-2">
								<i class="fas fa-file-alt"></i>
							</div>
							<h5>${assignment.Title}</h5>
							<p class="text-muted mb-2">${assignment.CourseName}</p>
							<p class="small text-muted">${assignment.Description}</p>
							<div class="assignment-meta">
								<span class="due-date">
									<i class="fas fa-calendar-alt me-1"></i>
									Due: ${assignment.DueDate || '-'}
								</span>
								<span class="status">
									${assignment.Status}
								</span>
							</div>
							<div class="assignment-actions">
								<button class="btn-action btn-view" onclick="event.stopPropagation(); showAssignmentDetails(window._assignments[${idx}]);">
									<i class="fas fa-eye me-1"></i>View
								</button>
								${(() => {
									let dueDate = assignment.DueDate ? new Date(assignment.DueDate) : null;
									let now = new Date();
									let duePassed = dueDate && dueDate.setHours(23,59,59,999) < now;
									let isClosed = assignment.Status && assignment.Status.toLowerCase() === 'closed';
									if (assignment.HasSubmitted) {
										return `<button class='btn-action btn-submit' disabled><i class='fas fa-check me-1'></i>Submitted</button>`;
									} else if (isClosed || duePassed) {
										return `<button class='btn-action btn-submit' disabled><i class='fas fa-lock me-1'></i>Closed</button>`;
									} else {
										return `<button class='btn-action btn-submit' onclick='event.stopPropagation(); openUploadModal(${assignment.AssignmentID});'><i class='fas fa-upload me-1'></i>Submit</button>`;
									}
								})()}
							</div>
						`;
						grid.appendChild(card);
					});
					// Store assignments globally for modal/detail use
					window._assignments = assignments;
				},
				error: function(xhr) {
					grid.style.display = 'none';
					noAssignments.style.display = 'block';
				}
			});
		}

		// File upload modal HTML
		const uploadModalHtml = `
		<div class="modal fade" id="assignmentUploadModal" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"><i class="fas fa-upload me-2"></i>Submit Assignment</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<form id="assignmentUploadForm" enctype="multipart/form-data">
							<input type="hidden" id="uploadAssignmentId" name="assignmentId" />
							<input type="file" id="uploadAssignmentFile" name="file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png" required class="form-control mb-3" />
							<div id="uploadStatus" class="mb-2 text-danger"></div>
							<button type="submit" class="btn btn-success">Upload</button>
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
						</form>
					</div>
				</div>
			</div>
		</div>`;
		if (!document.getElementById('assignmentUploadModal')) {
			document.body.insertAdjacentHTML('beforeend', uploadModalHtml);
		}

		function showAssignmentDetails(assignment) {
			// Determine if submit should be disabled
			let disableSubmit = false;
			let dueDate = assignment.DueDate ? new Date(assignment.DueDate) : null;
			let now = new Date();
			if (assignment.Status && assignment.Status.toLowerCase() === 'closed') {
				disableSubmit = true;
			} else if (dueDate && dueDate.setHours(23,59,59,999) < now) {
				disableSubmit = true;
			}
			const body = document.getElementById('assignmentDetailsBody');
			body.innerHTML = `
				<div class='mb-3'>
					<h4 class='mb-1 text-primary'>${assignment.Title}</h4>
					<div class='mb-2'><span class='badge bg-info text-dark'>${assignment.CourseName}</span></div>
					<p class='mb-2'>${assignment.Description}</p>
					<div class='mb-2'><i class='fas fa-calendar-alt me-2'></i><b>Due Date:</b> ${assignment.DueDate || '-'}</div>
					<div class='mb-2'><i class='fas fa-info-circle me-2'></i><b>Status:</b> <span class='badge bg-${assignment.HasSubmitted ? 'success' : 'warning'}'>${assignment.Status}</span></div>
				</div>
				${assignment.HasSubmitted ?
					`<div class='alert alert-success'><i class='fas fa-check-circle me-2'></i>Your assignment has been submitted.</div>` :
					`<button class='btn btn-success' onclick='openUploadModal(${assignment.AssignmentID});' ${disableSubmit ? 'disabled' : ''}>
						<i class='fas fa-upload me-2'></i>Submit Assignment
					</button>`
				}
				${disableSubmit && !assignment.HasSubmitted ? `<div class='alert alert-warning mt-2'><i class='fas fa-lock me-2'></i>Submission is closed for this assignment.</div>` : ''}
			`;
			const modal = new bootstrap.Modal(document.getElementById('assignmentDetailsModal'));
			modal.show();
		}

		function openUploadModal(assignmentId) {
			$('#uploadAssignmentId').val(assignmentId);
			$('#uploadAssignmentFile').val('');
			$('#uploadStatus').text('');
			const modal = new bootstrap.Modal(document.getElementById('assignmentUploadModal'));
			modal.show();
		}

		// AJAX file upload logic
		$(document).off('submit', '#assignmentUploadForm').on('submit', '#assignmentUploadForm', function(e) {
			e.preventDefault();
			var formData = new FormData(this);
			$('#uploadStatus').text('Uploading...');
			$.ajax({
				url: 'AssignmentUploadHandler.ashx',
				type: 'POST',
				data: formData,
				contentType: false,
				processData: false,
				success: function(res) {
					if (typeof res === 'string') {
						try { res = JSON.parse(res); } catch (e) { res = {}; }
					}
					if (res && res.success) {
						$('#uploadStatus').removeClass('text-danger').addClass('text-success').text('Upload successful!');
						// Update UI: mark as submitted
						var assignmentId = $('#uploadAssignmentId').val();
						if (window._assignments) {
							var idx = window._assignments.findIndex(a => a.AssignmentID == assignmentId);
							if (idx !== -1) {
								window._assignments[idx].HasSubmitted = true;
								loadAssignmentsAjax();
								showAssignmentDetails(window._assignments[idx]);
							}
						}
						setTimeout(function() { $('#assignmentUploadModal').modal('hide'); }, 1200);
						document.querySelector('.modal-backdrop')?.remove();
					} else {
						$('#uploadStatus').removeClass('text-success').addClass('text-danger').text(res && res.error ? res.error : 'Upload failed.');
					}
				},
				error: function(xhr) {
					var msg = 'Upload failed.';
					if (xhr && xhr.responseText) {
						try {
							var resp = JSON.parse(xhr.responseText);
							if (resp && resp.error) msg += ' ' + resp.error;
						} catch (e) {
							msg += ' ' + xhr.responseText;
						}
					}
					$('#uploadStatus').removeClass('text-success').addClass('text-danger').text(msg);
				}
			});
		});
	</script>
</asp:Content>

