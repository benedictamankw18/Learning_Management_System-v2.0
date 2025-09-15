<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Reports - Teacher</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
	<style>
	
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container py-4">
  <div class="row g-4">
    <!-- Students Block -->
    <div class="col-12 col-lg-6">
      <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
          <h4 class="card-title mb-3"><i class="fas fa-user-graduate me-2"></i>Student Reports</h4>
          <div class="d-flex flex-wrap gap-2 mb-3">
            <button class="btn btn-primary" onclick="printStudentReport('completed')"><i class="fas fa-print me-1"></i>Completed</button>
            <button class="btn btn-warning" onclick="printStudentReport('incomplete')"><i class="fas fa-print me-1"></i>In-Completed</button>
            <button class="btn btn-secondary" onclick="printStudentReport('all')"><i class="fas fa-print me-1"></i>All</button>
          </div>
          <div id="studentReportTable" class="table-responsive">
            <!-- Student report table will be rendered here -->
          </div>
        </div>
      </div>
    </div>
    <!-- Course Block -->
    <div class="col-12 col-lg-6">
      <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">
          <h4 class="card-title mb-3"><i class="fas fa-book-open me-2"></i>Course Reports</h4>
          <div class="row mb-3 g-2 align-items-end">
          <div class="col">
              <label for="courseFilter" class="form-label mb-1">Course</label>
              <select id="courseFilter" class="form-select">
                <option value="">All Courses</option>
                <!-- Course options will be populated dynamically -->
              </select>
            </div>
            <div class="col">
              <label for="courseStatusFilter" class="form-label mb-1">Status</label>
              <select id="courseStatusFilter" class="form-select">
                <option value="">All Status</option>
                <option value="active">Active</option>
                <option value="inactive">In Active</option>
                <option value="draft">Draft</option>
              </select>
            </div>
            <div class="col">
              <label for="courseQuizFilter" class="form-label mb-1">Quiz</label>
              <select id="courseQuizFilter" class="form-select">
                <option value="">All Quizzes</option>
                <!-- Quiz options will be populated dynamically -->
              </select>
            </div>
          </div>
          <div class="d-flex flex-wrap gap-2 mb-3">
            <button class="btn btn-info" onclick="printCourseReport('enrolled')"><i class="fas fa-print me-1"></i>Print</button>
          </div>
          <div id="courseReportTable" class="table-responsive">
            <!-- Course report table will be rendered here -->
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
// --- Dynamic Report JS ---
document.addEventListener('DOMContentLoaded', function() {
  populateCourseDropdown();
  // Initial load
  loadStudentReport('all');
  loadCourseReport();
  // Populate quizzes for the initial course (if any)
  populateQuizDropdown();
function populateCourseDropdown() {
  fetch('Reports.aspx/GetTeacherCourses', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  })
  .then(res => res.json())
  .then(data => {
    const courses = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;
    const select = document.getElementById('courseFilter');
    select.innerHTML = '<option value="">All Courses</option>';
    courses.forEach(c => {
      // Use CourseID for value
      select.innerHTML += `<option value="${c.CourseID}">${c.CourseName}</option>`;
    });
  });
}

  // Student print buttons
  document.querySelectorAll('[onclick^="printStudentReport"]').forEach(btn => {
    btn.addEventListener('click', function() {
      const type = this.getAttribute('onclick').match(/'(.*?)'/)[1];
      loadStudentReport(type, true);
    });
  });

  // Course print button
  document.querySelectorAll('[onclick^="printCourseReport"]').forEach(btn => {
    btn.addEventListener('click', function() {
      loadCourseReport(true);
    });
  });

  // Course filters
  document.getElementById('courseFilter').addEventListener('change', function() {
    loadCourseReport();
    populateQuizDropdown();
  });
// Populate quizzes for the selected course
function populateQuizDropdown() {
  const courseId = document.getElementById('courseFilter').value;
  const quizSelect = document.getElementById('courseQuizFilter');
  if (!courseId) {
    quizSelect.innerHTML = '<option value="">All Quizzes</option>';
    return;
  }
  fetch('Reports.aspx/GetQuizzesForCourse', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ courseId: courseId })
  })
  .then(res => res.json())
  .then(data => {
    const quizzes = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;
    quizSelect.innerHTML = '<option value="">All Quizzes</option>';
    quizzes.forEach(q => {
      quizSelect.innerHTML += `<option value="${q.QuizID}">${q.QuizTitle}</option>`;
    });
  })
  .catch(() => {
    quizSelect.innerHTML = '<option value="">All Quizzes</option>';
  });
}
  document.getElementById('courseStatusFilter').addEventListener('change', function() {
    loadCourseReport();
  });
  document.getElementById('courseQuizFilter').addEventListener('change', function() {
    loadCourseReport();
  });
});

function loadStudentReport(type = 'all', isPrint = false) {
  // Map type to status
  let status = '';
  if (type === 'completed') status = 'completed';
  else if (type === 'incomplete') status = 'incomplete';
  // else all

  const courseId = document.getElementById('courseFilter') ? document.getElementById('courseFilter').value : '';
  fetch('Reports.aspx/GetStudentReports', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ courseId: courseId, status: status, quiz: '' })
  })
  .then(res => res.json())
  .then(data => {
    const students = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;
    renderStudentTable(students);
    if (isPrint) printDiv('studentReportTable');
  })
  .catch(() => {
    document.getElementById('studentReportTable').innerHTML = '<div class="alert alert-danger">Failed to load student report.</div>';
  });
}

function renderStudentTable(students) {
  if (!students || students.length === 0) {
    document.getElementById('studentReportTable').innerHTML = '<div class="alert alert-warning">No student data found.</div>';
    return;
  }
  let html = `<table class="table table-bordered table-hover table-striped table-sm align-middle" style="background:#fff;">
    <thead class="table-primary text-center align-middle"><tr>
      <th>Name</th><th>ID</th><th>Course</th><th>Email</th><th>Phone</th><th>Department</th><th>Level</th><th>Programme</th><th>Status</th>
    </tr></thead><tbody>`;
  students.forEach((s, i) => {
    // Alternate row color
    const rowClass = i % 2 === 0 ? 'table-light' : 'table-white';
    // Status badge color
    let statusBadge = `<span class='badge ${s.Status === 'Active' ? 'bg-success' : 'bg-danger'}'>${s.Status}</span>`;
    html += `<tr class="${rowClass}">
      <td class="fw-semibold text-primary">${s.Name}</td>
      <td class="text-secondary">${s.StudentID}</td>
      <td class="text-info">${s.CourseCode}</td>
      <td><span class="text-dark">${s.Email}</span></td>
      <td><span class="text-muted">${s.Phone}</span></td>
      <td>${s.Department}</td>
      <td>${s.Level}</td>
      <td>${s.Programme}</td>
      <td class="text-center">${statusBadge}</td>
    </tr>`;
  });
  html += '</tbody></table>';
  document.getElementById('studentReportTable').innerHTML = html;
}

function loadCourseReport(isPrint = false) {
  const courseId = document.getElementById('courseFilter').value;
  const status = document.getElementById('courseStatusFilter').value;
  const quiz = document.getElementById('courseQuizFilter').value;
  fetch('Reports.aspx/GetCourseReports', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ courseId: courseId, status: status, quiz: quiz })
  })
  .then(res => res.json())
  .then(data => {
    const courses = typeof data.d === 'string' ? JSON.parse(data.d) : data.d;
    renderCourseTable(courses);
    if (isPrint) printDiv('courseReportTable');
  })
  .catch(() => {
    document.getElementById('courseReportTable').innerHTML = '<div class="alert alert-danger">Failed to load course report.</div>';
  });
}

function renderCourseTable(courses) {
  if (!courses || courses.length === 0) {
    document.getElementById('courseReportTable').innerHTML = '<div class="alert alert-warning">No course data found.</div>';
    return;
  }
  let html = `<table class="table table-bordered table-hover table-striped table-sm align-middle" style="background:#fff;">
    <thead class="table-info text-center align-middle"><tr>
      <th>Course Code</th><th>Course Name</th><th>Enrolled Students</th><th>Status</th>
    </tr></thead><tbody>`;
  courses.forEach((c, i) => {
    // Alternate row color
    const rowClass = i % 2 === 0 ? 'table-light' : 'table-white';
    // Status badge color
    let statusBadge = `<span class='badge ${c.Status === 'Active' ? 'bg-success' : c.Status === 'Draft' ? 'bg-warning text-dark' : 'bg-secondary'}'>${c.Status}</span>`;
    html += `<tr class="${rowClass}">
      <td class="fw-semibold text-primary">${c.Code}</td>
      <td class="text-info">${c.Name}</td>
      <td class="fw-bold text-success">${c.Students}</td>
      <td class="text-center">${statusBadge}</td>
    </tr>`;
  });
  html += '</tbody></table>';
  document.getElementById('courseReportTable').innerHTML = html;
}

function printDiv(divId) {
  const content = document.getElementById(divId).innerHTML;
  const today = new Date();
  const dateStr = today.toLocaleDateString() + ' ' + today.toLocaleTimeString();
  const logoUrl = '/Assest/Images/uew_logo.png'; // Change to your logo path if needed
  const reportTitle = divId === 'studentReportTable' ? 'Student Report' : 'Course Report';
  const win = window.open('', '', 'width=900,height=700');
  win.document.write('<html><head><title>Print Report</title>');
  win.document.write('<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">');
  win.document.write('<style> .print-header { display:flex; align-items:center; gap:1.5rem; border-bottom:2px solid #1976d2; margin-bottom:1.5rem; padding-bottom:1rem; } .print-logo { height:60px; } .print-title { font-size:2rem; font-weight:700; color:#1976d2; } .print-date { font-size:1rem; color:#555; margin-left:auto; } .print-table { border:1.5px solid #1976d2; border-radius:8px; overflow:hidden; } </style>');
  win.document.write('</head><body class="p-4">');
  win.document.write('<div class="print-header">');
  win.document.write(`<img src="${logoUrl}" class="print-logo" alt="Logo"/>`);
  win.document.write(`<span class="print-title">${reportTitle}</span>`);
  win.document.write(`<span class="print-date">${dateStr}</span>`);
  win.document.write('</div>');
  win.document.write(`<div class="print-table">${content}</div>`);
  win.document.write('</body></html>');
  win.document.close();
  win.print();
  win.close();
}
</script>
</asp:Content>
