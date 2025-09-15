<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Courses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<style>
.course-modal-content {
	border-radius: 18px;
	overflow: hidden;
	border: none;
	box-shadow: 0 8px 32px rgba(44,43,124,0.13);
}
.course-modal-header {
	background: linear-gradient(135deg, #007bff, #2c2b7c);
	color: #fff;
	border-radius: 18px 18px 0 0;
	border-bottom: none;
	padding-top: 24px;
	padding-bottom: 24px;
}
.course-modal-icon {
	width: 48px;
	height: 48px;
	background: rgba(255,255,255,0.15);
	border-radius: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2rem;
	color: #fff;
	box-shadow: 0 2px 8px rgba(44,43,124,0.10);
}
.course-info-card {
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 4px 24px rgba(44,43,124,0.10);
	padding: 2.2rem 2rem 1.5rem 2rem;
	margin-bottom: 0.5rem;
	position: relative;
}
.course-info-header {
	display: flex;
	align-items: center;
	gap: 1.5rem;
	margin-bottom: 1.2rem;
}
.course-info-icon {
	width: 60px;
	height: 60px;
	background: linear-gradient(135deg, #007bff, #2c2b7c);
	color: #fff;
	border-radius: 14px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2.2rem;
	box-shadow: 0 2px 8px rgba(44,43,124,0.10);
}
.course-info-title {
	font-size: 1.45rem;
	font-weight: 700;
	color: #2c2b7c;
	margin-bottom: 0.2rem;
}
.course-info-meta {
	color: #1976d2;
	font-size: 1.05rem;
	font-weight: 500;
}
.course-info-list {
	margin: 0;
	padding: 0;
	list-style: none;
}
.course-info-list li {
	padding: 0.7rem 0 0.7rem 0;
	border-bottom: 1px solid #f1f3f4;
	font-size: 1.08rem;
	display: flex;
	align-items: center;
	gap: 0.7rem;
}
.course-info-list li:last-child {
	border-bottom: none;
}
.course-info-label {
	min-width: 140px;
	color: #1976d2;
	font-weight: 600;
}
.course-info-value {
	color: #333;
	font-weight: 500;
}
.btn-gradient-primary {
	background: linear-gradient(135deg, #007bff, #2c2b7c);
	color: #fff;
	border: none;
	border-radius: 8px;
	font-weight: 500;
	transition: background 0.2s;
}
.btn-gradient-primary:hover {
	background: linear-gradient(135deg, #0056b3, #2c2b7c);
	color: #fff;
}
@keyframes fadeIn { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
.fade-in { animation: fadeIn 0.7s ease; }
@keyframes spin { 100% { transform: rotate(360deg); } }
.course-card-anim { transition: box-shadow 0.3s, transform 0.3s; }
.course-card-anim:hover { box-shadow: 0 8px 32px rgba(44,43,124,0.15); transform: translateY(-6px) scale(1.03); }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid px-0">
	<!-- Page Header -->
	<div class="d-flex flex-wrap align-items-center justify-content-between mb-4 fade-in">
		<div>
			<h2 class="fw-bold mb-1" style="color:#2c2b7c;">My Courses</h2>
			<p class="text-muted mb-0">View and manage your assigned courses.</p>
		</div>
		<div class="d-flex gap-2 align-items-center mt-3 mt-md-0">
			<input type="text" id="courseSearch" class="form-control rounded-pill shadow-sm" style="min-width:220px;" placeholder="Search courses..."/>
			<select id="semesterFilter" class="form-select rounded-pill shadow-sm" style="min-width:150px;">
				<option value="">All Semesters</option>
				<option value="1">Semester 1</option>
				<option value="2">Semester 2</option>
				<option value="Others">Others</option>
			</select>
			<%-- <button class="btn btn-primary rounded-pill px-4 shadow-sm"><i class="fa fa-plus me-2"></i>Add Course</button> --%>
		</div>
	</div>

	<!-- Animated Loading Spinner (hidden by default, show when loading) -->
	<div id="coursesLoading" class="justify-content-center align-items-center my-5" style="height:120px; display:none;">
		<div class="spinner-border text-primary" style="width:3rem; height:3rem; animation: spin 1s linear infinite;"></div>
	</div>

	<!-- Courses Grid -->
	<div class="row g-4" id="coursesGrid">
		<!-- Add more cards as needed -->
	</div>
</div>


<!-- Course Info Modal -->
<div class="modal fade" id="courseInfoModal" tabindex="-1">
	<div class="modal-dialog modal-lg">
		<div class="modal-content course-modal-content">
			<div class="modal-header course-modal-header">
				<div class="d-flex align-items-center">
					<div class="course-modal-icon me-3"><i class="fa fa-book"></i></div>
					<h5 class="modal-title mb-0">Course Information</h5>
				</div>
				<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body p-4" id="courseInfoBody">
				<!-- Course info will be loaded here -->
			</div>
			<div class="modal-footer bg-light border-0">
				<button type="button" class="btn btn-gradient-primary px-4" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<script>
// Show loading spinner while courses are loading, then hide spinner and show courses
document.addEventListener("DOMContentLoaded", function() {
   fetchCourses();
});

document.getElementById('courseSearch').addEventListener('input', function() {
    fetchCourses();
});
document.getElementById('semesterFilter').addEventListener('change', function() {
    fetchCourses();
});

function fetchCourses() {
    const search = document.getElementById('courseSearch').value.trim();
    const semester = document.getElementById('semesterFilter').value;

    document.getElementById("coursesLoading").style.display = "flex";
    document.getElementById("coursesGrid").style.display = "none";

    fetch('Courses.aspx/GetAssignedCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ search: search, semester: semester })
    })
    .then(res => res.json())
    .then(data => {
        const courses = JSON.parse(data.d);
        const grid = document.getElementById("coursesGrid");
        grid.innerHTML = "";

        if (courses.length === 0) {
            grid.innerHTML = `<div class="col-12"><div class="alert alert-warning text-center">No courses found.</div></div>`;
        } else {
            courses.forEach(course => {
                grid.innerHTML += `
                <div class="col-12 col-md-6 col-lg-4 col-xl-3 fade-in">
                    <div class="card h-100 shadow-sm border-0 rounded-4 course-card-anim">
                        <div class="card-body d-flex flex-column">
                            <div class="d-flex align-items-center mb-3">
                                <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center me-3" style="width:48px; height:48px;">
                                    <i class="fa fa-book fa-lg text-primary"></i>
                                </div>
                                <div>
                                    <h5 class="card-title mb-0 fw-semibold">${course.Name}</h5>
                                    <small class="text-muted">${course.Code} &bull; Semester ${course.Semester || '-'}</small>
                                </div>
                            </div>
                            <p class="card-text text-muted flex-grow-1">${course.Desc}</p>
                            <div class="d-flex justify-content-between align-items-center mt-2">
                                <span class="badge ${course.Status === 'Active' ? 'bg-success' : 'bg-secondary'} bg-opacity-75">${course.Status}</span>
                                <a href="#" class="btn btn-outline-primary btn-sm rounded-pill px-3 view-course-btn"
                                    data-course='${JSON.stringify(course)}'>View</a>
                            </div>
                        </div>
                    </div>
                </div>
                `;
            });
        }

        document.getElementById("coursesLoading").style.display = "none";
        document.getElementById("coursesGrid").style.display = "flex";

        document.querySelectorAll('.view-course-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                const data = JSON.parse(this.getAttribute('data-course'));
                document.getElementById('courseInfoBody').innerHTML = `
                    <div class='course-info-card'>
                        <div class='course-info-header'>
                            <div class='course-info-icon'><i class='fa fa-book'></i></div>
                            <div>
                                <div class='course-info-title'>${data.Name}</div>
                                <div class='course-info-meta'>${data.Code} &bull; ${data.Credit} Credit Hour${data.Credit > 1 ? 's' : ''}</div>
                            </div>
                        </div>
                        <ul class='course-info-list mb-2'>
                            <li><span class='course-info-label'>Description:</span> <span class='course-info-value'>${data.Desc}</span></li>
                            <li><span class='course-info-label'>Start Date:</span> <span class='course-info-value'>${data.Start}</span></li>
                            <li><span class='course-info-label'>End Date:</span> <span class='course-info-value'>${data.End}</span></li>
                            <li><span class='course-info-label'>Enrolled:</span> <span class='course-info-value'><i class='fa fa-users me-1'></i> ${data.Students} Student${data.Students == 1 ? '' : 's'}</span></li>
                        </ul>
                    </div>
                `;
                var modal = new bootstrap.Modal(document.getElementById('courseInfoModal'));
                modal.show();
            });
        });
    })
    .catch(() => {
        document.getElementById("coursesLoading").style.display = "none";
        document.getElementById("coursesGrid").style.display = "flex";
        document.getElementById("coursesGrid").innerHTML = `<div class="col-12"><div class="alert alert-danger text-center">Failed to load courses.</div></div>`;
    });
}
</script>
</asp:Content>
