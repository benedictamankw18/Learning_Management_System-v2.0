<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Students" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<style>
@keyframes fadeIn {
	from { opacity: 0; transform: translateY(30px); }
	to { opacity: 1; transform: translateY(0); }
}
@keyframes spin {
	100% { transform: rotate(360deg); }
}

/* Student Info Modal Styles */
.student-modal-content {
	border-radius: 20px;
	overflow: hidden;
	border: none;
	box-shadow: 0 10px 40px rgba(44,43,124,0.15);
	background: #f8f9fa;
}
.student-modal-header {
	background: linear-gradient(135deg, #1976d2, #2c2b7c 80%);
	color: #fff;
	border-radius: 20px 20px 0 0;
	border-bottom: none;
	padding: 32px 32px 24px 32px;
	display: flex;
	align-items: center;
	gap: 2rem;
}
.student-modal-avatar {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	object-fit: cover;
	border: 4px solid #fff;
	box-shadow: 0 2px 12px rgba(44,43,124,0.13);
}
.student-modal-title {
	font-size: 1.7rem;
	font-weight: 700;
	color: #fff;
	margin-bottom: 0.2rem;
	letter-spacing: 0.5px;
}
.student-modal-meta {
	color: #e3f2fd;
	font-size: 1.1rem;
	font-weight: 500;
}
.student-info-card {
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 2px 16px rgba(44,43,124,0.07);
	padding: 2rem 2.2rem 1.5rem 2.2rem;
	margin-bottom: 0.5rem;
	position: relative;
}
.student-info-list {
	margin: 0;
	padding: 0;
	list-style: none;
}
.student-info-list li {
	padding: 0.85rem 0 0.85rem 0;
	border-bottom: 1px solid #f1f3f4;
	font-size: 1.13rem;
	display: flex;
	align-items: center;
	gap: 0.7rem;
}
.student-info-list li:last-child {
	border-bottom: none;
}
.student-info-label {
	min-width: 140px;
	color: #1976d2;
	font-weight: 600;
	letter-spacing: 0.2px;
}
.student-info-value {
	color: #333;
	font-weight: 500;
}
.student-status-active { color: #2e7d32; font-weight: 600; }
.student-status-inactive { color: #b71c1c; font-weight: 600; }
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

</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid px-0">
	<!-- Page Header -->
	<div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
		<div>
			<h2 class="fw-bold mb-1" style="color:#2c2b7c;">My Students</h2>
			<p class="text-muted mb-0">View and manage students enrolled in your courses.</p>
		</div>
		<div class="d-flex gap-2 align-items-center mt-3 mt-md-0">
			<input type="text" id="courseSearch" class="form-control rounded-pill shadow-sm" style="min-width:220px;" placeholder="Search students..."/>
			<select id="courseFilter" class="form-select rounded-pill shadow-sm" style="min-width:150px;">
				<option value="">All Courses</option>
			</select>
		</div>
	</div>

	<!-- Animated Loading Spinner -->
	<div id="studentsLoading" class="justify-content-center align-items-center my-5" style="height:120px; display:none;">
		<div class="spinner-border text-primary" style="width:3rem; height:3rem; animation: spin 1s linear infinite;"></div>
	</div>

	<!-- Students Table (fade-in animation) -->
	<div id="studentsTableWrapper" class="table-responsive" style="display:none; animation: fadeIn 0.7s ease;">
		<table class="table table-hover align-middle rounded-4 overflow-hidden shadow-sm bg-white">
			<thead class="table-light">
				<tr>
					<th scope="col">#</th>
					<th scope="col">Name</th>
					<th scope="col">Student ID</th>
					<th scope="col">Course</th>
					<th scope="col">Email</th>
					<th scope="col">Status</th>
					<th scope="col">Actions</th>
				</tr>
			</thead>
			<tbody>
				
			</tbody> 
		</table>
	</div>
</div>

<!-- Student Info Modal -->
<div class="modal fade" id="studentInfoModal" tabindex="-1">
	<div class="modal-dialog modal-lg">
		<div class="modal-content student-modal-content">
							<div class="modal-header student-modal-header">
								<img src="../../Assest/Images/ProfileUew.png" alt="Profile" class="student-modal-avatar" id="studentModalAvatar">
								<div>
									<div class="student-modal-title" id="studentModalName">Student Name</div>
									<div class="student-modal-meta" id="studentModalID">Student ID</div>
								</div>
								<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
							</div>
							<div class="modal-body p-0">
															<div class="student-info-card">
																<div class="mb-4">
																	<div class="bg-light rounded-4 p-3 border border-1 border-primary-subtle">
																		<h6 class="fw-bold text-primary mb-3"><i class="fa fa-user me-2"></i>Personal Info</h6>
																		<ul class="student-info-list mb-0">
																			<li><span class="student-info-label"><i class="fa fa-user me-2 text-primary"></i>Full Name:</span> <span class="student-info-value" id="studentModalFullName"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-id-card me-2 text-primary"></i>Student ID:</span> <span class="student-info-value" id="studentModalID2"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-envelope me-2 text-primary"></i>Email:</span> <span class="student-info-value" id="studentModalEmail"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-phone me-2 text-primary"></i>Phone:</span> <span class="student-info-value" id="studentModalPhone"></span></li>
																		</ul>
																	</div>
																</div>
																<div>
																	<div class="bg-light rounded-4 p-3 border border-1 border-primary-subtle">
																		<h6 class="fw-bold text-primary mb-3"><i class="fa fa-building-columns me-2"></i>Academic Info</h6>
																		<ul class="student-info-list mb-0">
																			<li><span class="student-info-label"><i class="fa fa-building-columns me-2 text-primary"></i>Department:</span> <span class="student-info-value" id="studentModalDepartment"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-layer-group me-2 text-primary"></i>Level:</span> <span class="student-info-value" id="studentModalLevel"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-graduation-cap me-2 text-primary"></i>Programme:</span> <span class="student-info-value" id="studentModalProgramme"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-book me-2 text-primary"></i>Course:</span> <span class="student-info-value" id="studentModalCourse"></span></li>
																			<li><span class="student-info-label"><i class="fa fa-circle me-2 text-primary"></i>Status:</span> <span class="student-info-value" id="studentModalStatus"></span></li>
																		</ul>
																	</div>
																</div>
															</div>
							</div>
			<div class="modal-footer bg-light border-0">
				<button type="button" class="btn btn-gradient-primary px-4" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<script>

function fetchStudents() {
    const search = document.querySelector('#courseSearch')?.value || "";
    const courseCode = document.querySelector('#courseFilter')?.value || "";

    document.getElementById("studentsLoading").style.display = "flex";
    document.getElementById("studentsTableWrapper").style.display = "none";

    fetch('Students.aspx/GetStudents', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ search: search, courseCode: courseCode })
    })
    .then(res => res.json())
    .then(data => {
        const students = JSON.parse(data.d);
        const tbody = document.querySelector("#studentsTableWrapper tbody");
        tbody.innerHTML = "";

        if (students.length === 0) {
            tbody.innerHTML = `<tr><td colspan="7" class="text-center text-muted">No students found.</td></tr>`;
        } else {
            students.forEach((s, i) => {
                tbody.innerHTML += `
                <tr>
                    <th>${i + 1}</th>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <img src="${s.Img}" alt="Profile" class="rounded-circle" style="width:36px; height:36px; object-fit:cover;">
                            <span>${s.Name}</span>
                        </div>
                    </td>
                    <td>${s.StudentID}</td>
                    <td>${s.CourseCode}</td>
                    <td>${s.Email}</td>
                    <td><span class="badge ${s.Status === 'Active' ? 'bg-success' : 'bg-secondary'} bg-opacity-75">${s.Status}</span></td>
                    <td>
                        <button class="btn btn-outline-primary btn-sm rounded-pill px-3 view-student-btn"
                            data-student='${JSON.stringify(s)}'>
                            <i class="fa fa-eye"></i> View
                        </button>
                    </td>
                </tr>
                `;
            });
        }

        document.getElementById("studentsLoading").style.display = "none";
        document.getElementById("studentsTableWrapper").style.display = "block";

        // Re-attach modal event
        document.querySelectorAll('.view-student-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const data = JSON.parse(this.getAttribute('data-student'));
                document.getElementById('studentModalAvatar').src = data.Img;
                document.getElementById('studentModalName').textContent = data.Name;
                document.getElementById('studentModalFullName').textContent = data.Name;
                document.getElementById('studentModalID').textContent = data.StudentID;
                document.getElementById('studentModalID2').textContent = data.StudentID;
                document.getElementById('studentModalCourse').textContent = data.CourseCode;
                document.getElementById('studentModalEmail').textContent = data.Email;
                document.getElementById('studentModalPhone').textContent = data.Phone;
                document.getElementById('studentModalDepartment').textContent = data.Department;
                document.getElementById('studentModalLevel').textContent = data.Level;
                document.getElementById('studentModalProgramme').textContent = data.Programme;
                const statusSpan = document.getElementById('studentModalStatus');
                statusSpan.textContent = data.Status;
                statusSpan.className = 'student-info-value ' + (data.Status.toLowerCase() === 'active' ? 'student-status-active' : 'student-status-inactive');
                var modal = new bootstrap.Modal(document.getElementById('studentInfoModal'));
                modal.show();
            });
        });
    })
    .catch(() => {
        document.getElementById("studentsLoading").style.display = "none";
        document.getElementById("studentsTableWrapper").style.display = "block";
        const tbody = document.querySelector("#studentsTableWrapper tbody");
        tbody.innerHTML = `<tr><td colspan="7" class="text-center text-danger">Failed to load students.</td></tr>`;
    });
}
function populateCourseFilter() {
    fetch('Students.aspx/GetTeacherCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        const courses = JSON.parse(data.d);
        const select = document.getElementById('courseFilter');
        select.innerHTML = `<option value="">All Courses</option>`;
        courses.forEach(c => {
            select.innerHTML += `<option value="${c.CourseCode}">${c.CourseCode} - ${c.CourseName}</option>`;
        });
    });
}
// Add event listeners for search and filter
document.addEventListener("DOMContentLoaded", function() {
    populateCourseFilter();
    fetchStudents();
});
document.querySelector('#courseSearch').addEventListener('input', fetchStudents);
document.querySelector('#courseFilter').addEventListener('change', fetchStudents);
</script>

</asp:Content>
