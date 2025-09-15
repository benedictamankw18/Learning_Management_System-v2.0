<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Grades.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Grades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Grades - Learning Management System</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.grades-container {
			padding: 24px;
			max-width: 1300px;
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
		.row {
			display: flex;
			flex-wrap: wrap;
			margin: -12px;
			gap: 30px;
		}

		.grades-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			margin-bottom: 28px;
			padding: 28px 32px;
			transition: box-shadow 0.3s, transform 0.3s;
			position: relative;
		}
		.grades-card:hover {
			box-shadow: 0 10px 30px rgba(0,123,255,0.13);
			transform: translateY(-2px);
		}
		.grades-card .card-title {
			font-size: 1.3rem;
			font-weight: 600;
			color: #1976d2;
			margin-bottom: 18px;
		}
		.grades-summary {
			display: flex;
			gap: 32px;
			margin-bottom: 18px;
		}
		.summary-box {
			background: #e3f2fd;
			border-radius: 10px;
			padding: 18px 28px;
			color: #1976d2;
			font-weight: 600;
			font-size: 1.1rem;
			display: flex;
			align-items: center;
			gap: 12px;
			box-shadow: 0 2px 8px rgba(25, 118, 210, 0.08);
		}
		.grades-table {
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
		.edit-btn {
			background: #e3f2fd;
			color: #1976d2;
			border: none;
			border-radius: 8px;
			padding: 7px 16px;
			font-weight: 500;
			transition: background 0.2s;
		}
		.edit-btn:hover {
			background: #bbdefb;
			color: #0d47a1;
		}
		.view-btn {
			color: #e3f2fd;
			background: #46ce3cff;
			border: none;
			border-radius: 8px;
			padding: 7px 16px;
			font-weight: 500;
			transition: background 0.2s;
		}
		.view-btn:hover {
			color: #bbdefb;
			background: #32a10dff;
		}
		.download-btn {
			color: #e3f2fd;
			background: #c7ce3cff;
			border: none;
			border-radius: 8px;
			padding: 7px 16px;
			font-weight: 500;
			transition: background 0.2s;
		}
		.download-btn:hover {
			color: #bbdefb;
			background: #81a10dff;
		}
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
		@media (max-width: 700px) {
			.grades-card { padding: 18px 8px; }
			.grades-summary { flex-direction: column; gap: 12px; }
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="grades-container">
		<!-- Page Header -->
		<div class="page-header mb-4">
			<h1 class="mb-2"><i class="fas fa-clipboard-list me-3"></i>Assignment Grades</h1>
			<p class="mb-0 opacity-75">View, manage, and update student assignment grades for your courses</p>
		</div>

		<!-- Breadcrumb Navigation -->
		<div class="breadcrumb-nav">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb" id="breadcrumb">
					<li class="breadcrumb-item active">All Courses</li>
				</ol>
			</nav>
		</div>

		<!-- Course Selection Card -->
		<div class="grades-card animate__animated animate__fadeInDown row">
		<div class="card-body col-4">
			<div class="card-title"><i class="fas fa-graduation-cap me-2 "></i>Select Course</div>
			<select class="form-select mb-2" id="courseSelect" onchange="loadGrades()">
				<option value="">-- Select a Course --</option>
			</select>
		</div>
		<div class="card-body col-4">
			<div class="card-title"><i class="fas fa-clock me-2"></i>Select Assignment</div>
			<select class="form-select mb-2" id="assignmentSelect" onchange="loadGrades()">
				<option value="">-- Select an Assignment --</option>
			</select>
		</div>
		</div>

		<!-- Grades Summary -->
		<div class="grades-summary">
			<div class="summary-box"><i class="fas fa-users"></i> <span id="totalStudents">0</span> Students</div>
			<div class="summary-box"><i class="fas fa-check-circle"></i> <span id="passedCount">0</span> Passed</div>
			<div class="summary-box"><i class="fas fa-times-circle"></i> <span id="failedCount">0</span> Failed</div>
			<div class="summary-box"><i class="fas fa-percentage"></i> Avg: <span id="avgGrade">-</span></div>
		</div>

		<!-- Grades Table Card -->
		<div class="grades-card animate__animated animate__fadeInUp">
			<div class="card-title"><i class="fas fa-table me-2"></i>Student Grades</div>
			<div class="grades-table">
				<div class="table-responsive">
					<table class="table table-hover mb-0" id="gradesTable">
						<thead>
							<tr>
								<th>Student</th>
								<th>Index No.</th>
								<th>Course</th>
								<th>Assignment</th>
								<th>Grade</th>
								<th>Status</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody id="gradesTableBody">
							<!-- Grades will be loaded here -->
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- Edit Grade Modal -->
	<div class="modal fade" id="editGradeModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Grade</h5>
					<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<form id="editGradeForm">
						<div class="mb-3">
							<label for="editStudentName" class="form-label">Student</label>
							<input type="text" class="form-control" id="editStudentName" disabled>
						</div>
						<div class="mb-3">
							<label for="editGradeValue" class="form-label">Grade</label>
							<input type="number" class="form-control" id="editGradeValue" min="0" max="100" required>
						</div>
							<div class="mb-3">
								<label for="editStatus" class="form-label">Status</label>
								<select class="form-select" id="editStatus" disabled style="background-color: #f1f3f4; color: #495057; cursor: not-allowed;">
									<option value="Passed">Passed</option>
									<option value="Failed">Failed</option>
								</select>
								<div class="form-text text-muted">Status is automatically determined by the grade.</div>
							</div>
							<div class="mb-3">
								<label for="editFeedback" class="form-label">Feedback</label>
								<textarea class="form-control" id="editFeedback" rows="3"></textarea>
							</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" onclick="saveGrade()">
						<i class="fas fa-save me-2"></i>Save Changes
					</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		// Animate.css CDN for entry animations
		var animateCss = document.createElement('link');
		animateCss.rel = 'stylesheet';
		animateCss.href = 'https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css';
		document.head.appendChild(animateCss);
let gradesData = [];
let editingIndex = null;

// Populate courses on page load
$(document).ready(function() {
    $.ajax({
        type: "POST",
        url: "Grades.aspx/GetTeacherCourses",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            const courses = JSON.parse(res.d);
            const $courseSelect = $('#courseSelect');
            $courseSelect.empty().append('<option value="">-- Select a Course --</option>');
            courses.forEach(c => {
                $courseSelect.append(`<option value="${c.CourseID}">${c.CourseName} (${c.CourseCode})</option>`);
            });
        }
    });

    // When course changes, load assignments
    $('#courseSelect').on('change', function() {
        const courseId = $(this).val();
        const $assignmentSelect = $('#assignmentSelect');
        $assignmentSelect.empty().append('<option value="">-- Select an Assignment --</option>');
        if (!courseId) return;
        $.ajax({
            type: "POST",
            url: "Grades.aspx/GetAssignmentsForCourse",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ courseId }),
            dataType: "json",
            success: function(res) {
                const assignments = JSON.parse(res.d);
                assignments.forEach(a => {
                    $assignmentSelect.append(`<option value="${a.AssignmentID}">${a.AssignmentTitle}</option>`);
                });
            }
        });
    });
});

function loadGrades() {
    const courseId = document.getElementById('courseSelect').value;
    const assignmentId = document.getElementById('assignmentSelect').value;
    const tableBody = document.getElementById('gradesTableBody');
    tableBody.innerHTML = '';
    if (!courseId || !assignmentId) {
        document.getElementById('totalStudents').textContent = '0';
        document.getElementById('passedCount').textContent = '0';
        document.getElementById('failedCount').textContent = '0';
        document.getElementById('avgGrade').textContent = '-';
        gradesData = [];
        return;
    }
    $.ajax({
        type: "POST",
        url: "Grades.aspx/GetAssignmentGrades",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ courseId, assignmentId }),
        dataType: "json",
        success: function(res) {
			gradesData = JSON.parse(res.d);
			// Ensure each student object has a userId property for grade updates
			gradesData.forEach(function(student) {
				if (!student.userId && (student.UserID || student.userid || student.userID)) {
					student.userId = student.UserID || student.userid || student.userID;
				}
			});
            let passed = 0, failed = 0, total = gradesData.length, sum = 0;
            gradesData.forEach((student, idx) => {
                sum += student.grade;
                if (student.grade >= 60) passed++; else failed++;
                const status = student.grade >= 60 ? 'Passed' : 'Failed';
                const statusClass = student.grade >= 60 ? 'success' : 'danger';
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${student.name}</td>
                    <td>${student.index}</td>
                    <td>${student.course}</td>
                    <td>${student.assignment}</td>
                    <td>${student.grade}</td>
                    <td><span class="badge bg-${statusClass}">${status}</span></td>
					<td>
						${student.file && student.file !== '#' ?
							`<button type="button" class="view-btn" onclick="window.open('${student.file}', '_blank')"><i class="fas fa-eye"></i></button>
							<a class="download-btn" href="${student.file}" download><i class="fas fa-download"></i></a>`
							:
							`<button type="button" class="view-btn" disabled title="No file available"><i class="fas fa-eye"></i></button>
							<button type="button" class="download-btn" disabled title="No file available"><i class="fas fa-download"></i></button>`
						}
						<button type="button" class="edit-btn" onclick="openEditGrade(${idx})"><i class="fas fa-edit"></i></button>
					</td>
                `;
                tableBody.appendChild(row);
            });
            document.getElementById('totalStudents').textContent = total;
            document.getElementById('passedCount').textContent = passed;
            document.getElementById('failedCount').textContent = failed;
            document.getElementById('avgGrade').textContent = total ? (sum/total).toFixed(1) : '-';
        }
    });
}

function openEditGrade(idx) {
	editingIndex = idx;
	const student = gradesData[idx];
	document.getElementById('editStudentName').value = student.name;
	document.getElementById('editGradeValue').value = student.grade;
	// Set status in modal based on grade
	const computedStatus = student.grade >= 60 ? 'Passed' : 'Failed';
	document.getElementById('editStatus').value = computedStatus;
	document.getElementById('editFeedback').value = student.feedback || '';
	bootstrap.Modal.getOrCreateInstance(document.getElementById('editGradeModal')).show();
}

function saveGrade() {
	if (editingIndex === null) return;
	const newGrade = parseInt(document.getElementById('editGradeValue').value);
	const newFeedback = document.getElementById('editFeedback').value;
	if (isNaN(newGrade) || newGrade < 0 || newGrade > 100) {
		Swal.fire({
			icon: 'error',
			title: 'Invalid Grade',
			text: 'Please enter a valid grade between 0 and 100.'
		});
		return;
	}
	const computedStatus = newGrade >= 60 ? 'Passed' : 'Failed';
	const student = gradesData[editingIndex];
	const studentUserId = student.userId || student.UserID || student.userid || student.userID;
	if (!studentUserId) {
		alert("Student UserID is missing!");
		return;
	}
	$.ajax({
		type: "POST",
		url: "Grades.aspx/UpdateStudentGrade",
		contentType: "application/json; charset=utf-8",
		data: JSON.stringify({
			studentUserId: studentUserId,
			courseId: document.getElementById('courseSelect').value,
			assignmentId: document.getElementById('assignmentSelect').value,
			grade: newGrade,
			status: computedStatus,
			feedback: newFeedback
		}),
		dataType: "json",
		success: function(res) {
			if (res.d === true) {
				gradesData[editingIndex].grade = newGrade;
				gradesData[editingIndex].status = computedStatus;
				gradesData[editingIndex].feedback = newFeedback;
				bootstrap.Modal.getInstance(document.getElementById('editGradeModal')).hide();
				Swal.fire({
					icon: 'success',
					title: 'Grade Updated',
					text: 'The grade has been updated successfully.'
				});
				loadGrades();
			} else {
				Swal.fire({
					icon: 'error',
					title: 'Update Failed',
					text: 'Failed to update grade. Please try again.'
				});
			}
		},
		error: function() {
			Swal.fire({
				icon: 'error',
				title: 'Error',
				text: 'Error updating grade. Please try again.'
			});
		}
	});
}
	</script>

</asp:Content>
