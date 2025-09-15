<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Reports" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Reports - Learning Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../../Assest/css/bootstrap-5.2.3-dist/css/bootstrap.css">
    <script src="../../Assest/css/bootstrap-5.2.3-dist/js/bootstrap.js"></script>
    <link rel="stylesheet" href="../../Assest/fontawesome-free-6.7.2-web/css/all.css">
    <!-- jsPDF and jsPDF-AutoTable for PDF generation -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }

        .container {
            max-width: 1200px;
        }

        .page-header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .page-title {
            color: #2c3e50;
            font-weight: 700;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-subtitle {
            color: #7f8c8d;
            margin-bottom: 0;
        }

        .report-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 48px rgba(0, 0, 0, 0.15);
        }

        .report-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .report-description {
            color: #7f8c8d;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .export-options {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .export-btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 140px;
            justify-content: center;
        }

        .export-btn:hover {
            transform: translateY(-2px);
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, #2980b9, #3498db);
            color: white;
        }

        .btn-success {
            background: linear-gradient(45deg, #27ae60, #2ecc71);
            color: white;
            border: none;
        }

        .btn-success:hover {
            background: linear-gradient(45deg, #2ecc71, #27ae60);
            color: white;
        }

        .btn-info {
            background: linear-gradient(45deg, #17a2b8, #138496);
            color: white;
            border: none;
        }

        .btn-info:hover {
            background: linear-gradient(45deg, #138496, #17a2b8);
            color: white;
        }

        .btn-warning {
            background: linear-gradient(45deg, #f39c12, #e67e22);
            color: white;
            border: none;
        }

        .btn-warning:hover {
            background: linear-gradient(45deg, #e67e22, #f39c12);
            color: white;
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            text-decoration: none;
            transform: translateX(-5px);
        }

        .stats-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            flex: 1;
            min-width: 200px;
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #3498db;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #7f8c8d;
            font-weight: 500;
        }

        .filter-section {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .filter-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .form-select, .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 10px 15px;
        }

        .form-select:focus, .form-control:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .modal-content {
            border-radius: 15px;
            border: none;
        }

        .modal-header {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            border-radius: 15px 15px 0 0;
        }

        .btn-close {
            filter: brightness(0) invert(1);
        }

        @media (max-width: 768px) {
            .export-options {
                flex-direction: column;
            }
            
            .export-btn {
                width: 100%;
            }
            
            .stats-row {
                flex-direction: column;
            }
        }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container">
        <a href="AdminMaster.aspx" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Back to Dashboard
        </a>

        <div class="page-header">
            <h1 class="page-title">
                <i class="fas fa-chart-bar"></i>
                Reports & Export
            </h1>
            <p class="page-subtitle">Generate and export comprehensive PDF reports for users, courses, and quizzes</p>
        </div>

        <!-- Statistics Overview -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number" id="totalStudents">0</div>
                <div class="stat-label">Total Students</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="totalTeachers">0</div>
                <div class="stat-label">Total Teachers</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="totalCourses">0</div>
                <div class="stat-label">Active Courses</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" id="totalQuizzes">0</div>
                <div class="stat-label">Total Quizzes</div>
            </div>
        </div>

        <!-- User Reports -->
        <div class="report-card">
            <h3 class="report-title">
                <i class="fas fa-users"></i>
                User Reports
            </h3>
            <p class="report-description">
                Export comprehensive PDF lists of students and teachers with their profile information, registration dates, and activity status.
            </p>
            
            <div class="filter-section">
                <h6 class="filter-title">Filter Options</h6>
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">User Type</label>
                        <select class="form-select" id="userTypeFilter">
                            <option value="all">All Users</option>
                            <option value="students">Students Only</option>
                            <option value="teachers">Teachers Only</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Status</label>
                        <select class="form-select" id="userStatusFilter">
                            <option value="all">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">In active</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Registration Date</label>
                        <select class="form-select" id="userDateFilter">
                            <option value="all">All Time</option>
                            <option value="thisMonth">This Month</option>
                            <option value="lastMonth">Last Month</option>
                            <option value="thisYear">This Year</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="export-options">
                <button type="button" class="export-btn btn-primary" onclick="exportUsers('students')">
                    <i class="fas fa-file-pdf"></i>
                    Export Students PDF
                </button>
                <button type="button" class="export-btn btn-success" onclick="exportUsers('teachers')">
                    <i class="fas fa-file-pdf"></i>
                    Export Teachers PDF
                </button>
                <button type="button" class="export-btn btn-info" onclick="exportUsers('all')">
                    <i class="fas fa-file-pdf"></i>
                    Export All Users PDF
                </button>
            </div>
        </div>

        <!-- Quiz Reports -->
        <div class="report-card">
            <h3 class="report-title">
                <i class="fas fa-clipboard-list"></i>
                Quiz Reports
            </h3>
            <p class="report-description">
                Export detailed PDF quiz reports including questions, submissions, and performance analytics by course and level.
            </p>
            
            <div class="filter-section">
                <h6 class="filter-title">Filter Options</h6>
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Course</label>
                        <select class="form-select" id="quizCourseFilter">
    <option value="all">All Courses</option>
</select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Level</label>
                        <select class="form-select" id="quizLevelFilter">
                            <option value="all">All Levels</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Quiz Type</label>
                        <select class="form-select" id="quizTypeFilter">
                            <option value="all">All Types</option>
                            <option value="graded">Graded</option>
                            <option value="practice">Practice</option>
                            <option value="exam">Exam</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="export-options">
                <button type="button" class="export-btn btn-info" onclick="exportQuizzes('all')">
                    <i class="fas fa-file-pdf"></i>
                    All Quiz PDF
                </button>
                <button type="button" class="export-btn btn-primary" onclick="exportQuizzes('active')">
                    <i class="fas fa-file-pdf"></i>
                    Active Quiz PDF
                </button>
                <button type="button" class="export-btn btn-success" onclick="exportQuizzes('archived')">
                    <i class="fas fa-file-pdf"></i>
                    Archived Quiz PDF
                </button>
                <button type="button" class="export-btn btn-warning" onclick="exportQuizzes('draft')">
                    <i class="fas fa-file-pdf"></i>
                    Draft Quiz PDF
                </button>
            </div>
        </div>

        <!-- Course Reports -->
        <div class="report-card">
            <h3 class="report-title">
                <i class="fas fa-book"></i>
                Course Reports
            </h3>
            <p class="report-description">
                Export PDF course enrollment data, teacher assignments, and student registration lists with detailed information.
            </p>
            
            <div class="filter-section">
                <h6 class="filter-title">Filter Options</h6>
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label">Academic Year</label>
                        <select class="form-select" id="courseYearFilter">
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Status</label>
                        <select class="form-select" id="courseSemesterFilter">
                            <option value="all">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">In active</option>
                            <option value="draft">Draft</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Department</label>
                        <select class="form-select" id="courseDepartmentFilter">
                            <option value="all">All Departments</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="export-options">
            <button type="button" class="export-btn btn-info" onclick="exportCourses('course-details')">
                    <i class="fas fa-file-pdf"></i>
                    Course Details PDF
                </button>
                <button type="button" class="export-btn btn-primary" onclick="exportCourses('student-enrollment')">
                    <i class="fas fa-file-pdf"></i>
                    Student Enrollments PDF
                </button>
                <button type="button" class="export-btn btn-success" onclick="exportCourses('teacher-assignments')">
                    <i class="fas fa-file-pdf"></i>
                    Teacher Assignments PDF
                </button>
                <button type="button" class="export-btn btn-warning" onclick="exportCourses('enrollment-stats')">
                    <i class="fas fa-file-pdf"></i>
                    Enrollment Stats PDF
                </button>
            </div>
        </div>
    </div>

    <script>




        // Modal functions
        function showSuccess(message) {
            document.getElementById('successModalBody').textContent = message;
            new bootstrap.Modal(document.getElementById('successModal')).show();
        }

        function showError(message) {
            document.getElementById('errorModalBody').textContent = message;
            new bootstrap.Modal(document.getElementById('errorModal')).show();
        }

        function showLoading() {
            new bootstrap.Modal(document.getElementById('loadingModal')).show();
        }

        function hideLoading() {
            bootstrap.Modal.getInstance(document.getElementById('loadingModal')).hide();
        }

function populateQuizTypeFilter() {
    fetch('Reports.aspx/GetAllQuizTypes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            const types = result.d.data;
            const quizTypeFilter = document.getElementById('quizTypeFilter');
            quizTypeFilter.innerHTML = '<option value="all">All Types</option>';
            types.forEach(type => {
                const opt = document.createElement('option');
                opt.value = type.toLowerCase();
                opt.textContent = type.charAt(0).toUpperCase() + type.slice(1);
                quizTypeFilter.appendChild(opt);
            });
        }
    });
}

 // Export functions
function exportUsers(type) {
    showLoading();
    const userTypeEl = document.getElementById('userTypeFilter');
    const statusEl = document.getElementById('userStatusFilter');
    const dateEl = document.getElementById('userDateFilter');

    if (!userTypeEl || !statusEl || !dateEl) {
        hideLoading();
        showError('One or more filter inputs are missing.');
        return;
    }

    const userType = userTypeEl.value;
    const status = statusEl.value;
    const dateFilter = dateEl.value;

    try {
        fetchUsers(userType, status, dateFilter, function(err, data) {
            hideLoading();

            if (err) {
                showError('Failed to fetch users: ' + err.message);
                return;
            }

            if (!Array.isArray(data) || data.length === 0) {
                showError('No users found for the selected filters.');
                return;
            }
            generateUsersPDF(data, type, function(recordCount) {
                showSuccess(`${capitalize(type)} report exported successfully! ${recordCount} records exported.`);
            });
        });
    } catch (error) {
        hideLoading();
        showError('Unexpected error: ' + error.message);
    }
}

function capitalize(str) {
    return (typeof str === 'string' && str.length > 0)
        ? str.charAt(0).toUpperCase() + str.slice(1)
        : '';
}


function exportQuizzes(status) {
    showLoading();
    const course = document.getElementById('quizCourseFilter').value;
    const level = document.getElementById('quizLevelFilter').value;
    const type = document.getElementById('quizTypeFilter').value;
    try {
        fetchQuizzes(course, level, type, status, function(data) {
            hideLoading();
            if (!data || data.length === 0) {
                showError(`No quizzes found for ${capitalize(status)} status with the selected filters.`);
                return;
            }

            generateQuizzesPDF(data, status);

            showSuccess(`Quiz ${capitalize(status)} report exported successfully! ${data.length} quizzes exported.`);
        });
    } catch (err) {
        hideLoading();
        console.error("Export error:", err);
        showError("Failed to export quizzes. Please try again.");
    }
}

function populateQuizLevelFilter() {
    fetch('Reports.aspx/GetAllLevels', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            const levels = result.d.data;
            const quizLevelFilter = document.getElementById('quizLevelFilter');
            quizLevelFilter.innerHTML = '<option value="all">All Levels</option>';
            levels.forEach(level => {
                const opt = document.createElement('option');
                opt.value = 'level' + level.name;
                opt.textContent = level.name;
                quizLevelFilter.appendChild(opt);
            });
        }
    });
}



        function fetchCourses(year, semester, department, callback) {
    fetch('Reports.aspx/GetCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ year, semester, department })
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            callback(result.d.data);
        } else {
            showError('Failed to fetch courses.');
        }
    })
    .catch(() => showError('Failed to fetch courses.'));
}

function populateDepartmentFilter() {
    fetch('Reports.aspx/GetAllDepartments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            const departments = result.d.data;
            const departmentFilter = document.getElementById('courseDepartmentFilter');
            departmentFilter.innerHTML = '<option value="all">All Departments</option>';
            departments.forEach(dep => {
                const opt = document.createElement('option');
                opt.value = dep.id;
                opt.textContent = dep.name;
                departmentFilter.appendChild(opt);
            });
        }
    });
}

function exportCourses(reportType) {
    showLoading();

    // ✅ Grab filter values from the dropdowns or input fields
    const year = document.getElementById('courseYearFilter').value;
    const semester = document.getElementById('courseSemesterFilter').value;
    const department = document.getElementById('courseDepartmentFilter').value;

    // ✅ Call fetchCourses (your AJAX function)
    fetchCourses(year, semester, department, function(data) {

        // ✅ When data comes back, generate the PDF based on reportType
        generateCoursesPDF(data, reportType, function(recordCount) {

            // ✅ Hide loader after export is complete
            

            // ✅ Show success message
            showSuccess(
              `Course ${reportType.replace('-', ' ')} report exported successfully! ${recordCount} records exported.`
            );
        }); hideLoading();
    });
}


function buildStudentRows(data) {
    console.log("Student rows before filter:", data);

    if (!Array.isArray(data)) {
        console.error("Expected array but got:", data);
        return [];
    }

    // ✅ Filter only students
    let students = data.filter(item => 
        item.UserType && item.UserType.toLowerCase() === "student"
    );

    console.log("After UserType filter:", students);

    // ✅ Map correct property names
    let rows = students.map(student => [
        student.Name ?? "N/A",  
        student.Email ?? "N/A",  
        student.Programme ?? student.Program ?? "N/A",  
        student.Level ?? "N/A",  
        student.Status ?? "N/A",  
        student.RegistrationDate ?? "N/A"
    ]);

    console.log("Filtered student rows:", rows);
    return rows;
}


function generateUsersPDF(data, type, onSuccess) {
    try {
        if (!window.jspdf || !window.jspdf.jsPDF) {
            showError('PDF library not loaded. Please refresh the page and try again.');
            return;
        }

        if (!Array.isArray(data)) {
            showError('Invalid data format. Expected an array.');
            return;
        }

        if (!['students', 'teachers', 'all'].includes(type)) {
            showError('Invalid report type specified.');
            return;
        }

        const { jsPDF } = window.jspdf;
        const doc = new jsPDF('p', 'mm', 'a4');

        addPDFHeader(doc, `${type.charAt(0).toUpperCase() + type.slice(1)} Report`);

        let headers, rows = [];

        if (type === 'students' || (type === 'all' && data.some(item => item.Program || item.Programme))) {
            headers = ['Name', 'Email', 'Department', 'Program', 'Level', 'Status', 'Registration Date'];
            rows = data.filter(item => item.UserType?.toLowerCase() === "student")
                       .map(student => [
                           student.Name ?? 'N/A',
                           student.Email ?? 'N/A',
                           student.Department ?? 'N/A',
                           student.Programme ?? student.Program ?? 'N/A',
                           student.Level ?? 'N/A',
                           student.Status ?? 'N/A',
                           student.RegistrationDate ?? 'N/A'
                       ]);
        }

        if (type === 'teachers' || (type === 'all' && data.some(item => item.Department))) {
            headers = ['Name', 'Email', 'Department', 'Status', 'Registration Date'];
            const teacherRows = data.filter(item => item.UserType?.toLowerCase() === "teacher")
                                    .map(teacher => [
                                        teacher.Name ?? 'N/A',
                                        teacher.Email ?? 'N/A',
                                        teacher.Department ?? 'N/A',
                                        teacher.Status ?? 'N/A',
                                        teacher.RegistrationDate ?? 'N/A'
                                    ]);
            rows = rows.concat(teacherRows);
        }

        if (rows.length === 0) {
            showError('No data available for the selected filters.');
            return;
        }

        if (typeof doc.autoTable !== "function") {
            showError('Table plugin not available. Please include jspdf-autotable.');
            return;
        }

        doc.autoTable({
            head: [headers],
            body: rows,
            startY: 50,
            theme: 'striped',
            headStyles: { fillColor: [52, 152, 219], textColor: 255, fontStyle: 'bold' },
            styles: { fontSize: 9, cellPadding: 3 },
            alternateRowStyles: { fillColor: [245, 245, 245] }
        });

        addPDFFooter(doc);

        const today = new Date().toLocaleDateString().replace(/\//g, '-');
        const filename = `${type}_report_${today}.pdf`;
        doc.save(filename);

        if (typeof onSuccess === "function") {
            onSuccess(rows.length);
        }
    } catch (error) {
        console.error('PDF Generation Error:', error);
        showError('Failed to generate PDF. Error: ' + error.message);
    }
}


        function generateQuizzesPDF(data, reportType) {
    try {
        const { jsPDF } = window.jspdf;
        if (!jsPDF) {
            showError('PDF library not loaded. Please refresh the page and try again.');
            return;
        }

        const doc = new jsPDF('p', 'mm', 'a4');

        // Add header
        addPDFHeader(doc, `Quiz ${reportType.charAt(0).toUpperCase() + reportType.slice(1)} Report`);

        // Format date helper
        const formatDate = d => d ? new Date(d).toLocaleDateString() : 'N/A';

        // Choose header label for first column
        const typeHeader = {
            draft: "Draft ID",
            archived: "Archived ID",
            active: "Active ID",
            all: "Quiz ID"
        }[reportType] || "Quiz ID";

        // Table headers
        const headers = [typeHeader, 'Title', 'Type', 'Course', 'Number of Questions', 'Created Date'];

        // Table rows (use backend field names)
        const rows = data.map(quiz => [
            quiz.Id ?? 'N/A',
            quiz.Title ?? 'N/A',
            quiz.Type ?? 'N/A',
            quiz.Course ?? 'N/A',
            (quiz.TotalQuestions ?? 0).toString(),
            formatDate(quiz.CreatedDate)
        ]);

        if (rows.length === 0) {
            showError('No quiz data available for the selected filters.');
            return;
        }

        // Add table
        doc.autoTable({
            head: [headers],
            body: rows,
            startY: 50,
            theme: 'striped',
            headStyles: {
                fillColor: [52, 152, 219],
                textColor: 255,
                fontStyle: 'bold'
            },
            styles: {
                fontSize: 9,
                cellPadding: 3
            },
            alternateRowStyles: {
                fillColor: [245, 245, 245]
            }
        });

        // Add footer
        addPDFFooter(doc);

        // Save the PDF
        const filename = `quiz_${reportType}_report_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(filename);

    } catch (error) {
        console.error('PDF Generation Error:', error);
        showError('Failed to generate PDF. Error: ' + error.message);
    }
}

function populateCourseFilters() {
    fetch('Reports.aspx/GetAllCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            const courses = result.d.data;
            const quizCourseFilter = document.getElementById('quizCourseFilter');
            const courseYearFilter = document.getElementById('courseYearFilter');
            // Clear existing options except "All Courses"
            quizCourseFilter.innerHTML = '<option value="all">All Courses</option>';
            courses.forEach(course => {
                const opt = document.createElement('option');
                opt.value = course.id;
                opt.textContent = course.name;
                quizCourseFilter.appendChild(opt);
            });
            // Repeat for other course filter dropdowns if needed
        }
    });
}


function generateCoursesPDF(data, reportType, onSuccess) {
    try {
        const { jsPDF } = window.jspdf;
        if (!jsPDF) {
            showError('PDF library not loaded. Please refresh the page and try again.');
            return;
        }

        // Init PDF
        const doc = new jsPDF('p', 'mm', 'a4');
        const reportTitle = `Course ${reportType.replace('-', ' ')
            .charAt(0).toUpperCase() + reportType.replace('-', ' ').slice(1)} Report`;

        addPDFHeader(doc, reportTitle);

        if (!Array.isArray(data) || data.length === 0) {
            showError('No course data available for the selected filters.');
            return;
        }

        let headers = [];
        let rows = [];
        
        switch (reportType) {
        case 'student-enrollment':
    headers = ['Student Name', 'Email', 'Course', 'Code', 'Teacher', 'Year', 'Semester'];
    rows = data.map(enrollment => [
        enrollment.StudentName || 'N/A',
        enrollment.StudentEmail || 'N/A',
        enrollment.CourseName || enrollment.Name || 'N/A',
        enrollment.CourseCode || enrollment.Code || 'N/A',
        enrollment.Teacher || 'N/A',
        enrollment.AcademicYear || 'N/A',
        enrollment.Semester || 'N/A'
    ]);
    break;


          case 'teacher-assignments':
    headers = ['Teacher', 'Email', 'Department', 'Course', 'Enrolled', 'Year', 'Semester'];
    rows = data.map(assignment => [
        assignment.Teacher || 'N/A',
        assignment.TeacherEmail || 'N/A',
        assignment.Department || 'N/A',
        assignment.Name || assignment.Course || 'N/A',
        (assignment.Enrolled || 0).toString(),
        assignment.AcademicYear || 'N/A',
        assignment.Semester || 'N/A'
    ]);
    break;
           case 'course-details':
    headers = ['Course Name', 'Code', 'Level', 'Teacher', 'Enrolled', 'Capacity', 'Available', 'Department', 'Programme', 'Year', 'Semester'];
    rows = data.map(course => [
        course.Name || 'N/A',
        course.Code || 'N/A',
        course.Level || 'N/A',
        course.Teacher || 'N/A',
        (course.Enrolled || 0).toString(),
        (course.Capacity || 0).toString(),
        course.Available || 'N/A',
        course.Department || 'N/A',
        course.Programme || 'N/A',
        course.AcademicYear || 'N/A',
        course.Semester || 'N/A'
    ]);
    break;
          case 'enrollment-stats':
    headers = ['Course', 'Code', 'Enrolled', 'Available', 'Year', 'Semester'];
    rows = data.map(stats => [
        stats.Name || 'N/A',
        stats.Code || 'N/A',
        (stats.Enrolled || 0).toString(),
        (stats.Available && stats.Available !== "Available" ? stats.Available : (stats.Capacity || 0) - (stats.Enrolled || 0)).toString(),
        stats.AcademicYear || 'N/A',
        stats.Semester || 'N/A'
    ]);
    break;

        }

        if (rows.length === 0) {
            showError('No course data available for the selected filters.');
            return;
        }

        // Render table
        doc.autoTable({
            head: [headers],
            body: rows,
            startY: 50,
            theme: 'striped',
            headStyles: {
                fillColor: [52, 152, 219],
                textColor: 255,
                fontStyle: 'bold'
            },
            styles: {
                fontSize: 8,
                cellPadding: 2,
                overflow: 'linebreak' // wrap long text
            },
            alternateRowStyles: {
                fillColor: [245, 245, 245]
            }
        });

        // Footer + Save
        addPDFFooter(doc);
        const filename = `course_${reportType}_report_${new Date().toISOString().split('T')[0]}.pdf`;
        doc.save(filename);

        if (typeof onSuccess === "function") {
            onSuccess(rows.length);
        }
    } catch (error) {
        console.error('PDF Generation Error:', error);
        showError('Failed to generate PDF. Error: ' + error.message);
    }
}

        function addPDFHeader(doc, title) {
            try {
                // Add UEW logo area (placeholder)
                doc.setFillColor(52, 152, 219);
                doc.rect(15, 10, 180, 20, 'F');
                
                // Add title
                doc.setTextColor(255, 255, 255);
                doc.setFontSize(16);
                doc.setFont('helvetica', 'bold');
                doc.text('University of Education, Winneba', 20, 18);
                doc.setFontSize(12);
                doc.text('Learning Management System', 20, 25);
                
                // Add report title
                doc.setTextColor(0, 0, 0);
                doc.setFontSize(14);
                doc.setFont('helvetica', 'bold');
                doc.text(title || 'Report', 15, 38);
                
                // Add generation date
                doc.setFontSize(10);
                doc.setFont('helvetica', 'normal');
                const date = new Date().toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                });
                doc.text(`Generated on: ${date}`, 15, 45);
            } catch (error) {
                console.error('Error adding PDF header:', error);
            }
        }

        function addPDFFooter(doc) {
            try {
                const pageCount = doc.internal.getNumberOfPages();
                
                for (let i = 1; i <= pageCount; i++) {
                    doc.setPage(i);
                    
                    // Add footer line
                    doc.setDrawColor(52, 152, 219);
                    doc.line(15, 285, 195, 285);
                    
                    // Add footer text
                    doc.setTextColor(100, 100, 100);
                    doc.setFontSize(8);
                    doc.setFont('helvetica', 'normal');
                    doc.text('University of Education, Winneba - Learning Management System', 15, 290);
                    doc.text(`Page ${i} of ${pageCount}`, 170, 290);
                    doc.text(`Generated by Admin Portal - ${new Date().getFullYear()}`, 15, 294);
                }
            } catch (error) {
                console.error('Error adding PDF footer:', error);
            }
        }

    function fetchUsers(userType, status, dateFilter, callback) {
            fetch('Reports.aspx/GetUsers', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userType, status, dateFilter })
            })
            .then(res => {
                if (!res.ok) throw new Error('Network response was not ok: ' + res.statusText);
                return res.json();
            })
            .then(result => {
                let response = result.d;
                
                // Handle ASP.NET's weird "d" wrapping (sometimes a JSON string)
                if (typeof response === "string") {
                    try {
                        response = JSON.parse(response);
                    } catch (e) {
                        return callback(new Error("Invalid server response format"), null);
                    }
                }

                if (response && response.success) {
                    callback(null, response.data);
                } else {
                    callback(new Error("Failed to fetch users"), null);
                }
            })
            .catch(err => {
                callback(err, null);
            });
        }


function populateAcademicYearFilter() {
    const yearFilter = document.getElementById('courseYearFilter');
    yearFilter.innerHTML = '';
    const currentYear = new Date().getFullYear();
    for (let i = 0; i < 10; i++) {
        const yearRange = `${currentYear - i}-${currentYear - i + 1}`;
        const opt = document.createElement('option');
        opt.value = yearRange;
        opt.textContent = yearRange;
        yearFilter.appendChild(opt);
    }
}

function fetchQuizzes(course, level, type, status, callback) {
    fetch('Reports.aspx/GetQuizzes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ course, level, type, status })
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            callback(result.d.data);
        } else {
            showError('Failed to fetch quizzes.');
        }
    })
    .catch(() => showError('Failed to fetch quizzes.'));
}


        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {

            const body = document.getElementsByTagName('body')[0];
            body.innerHTML += `

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="successModalLabel">
                        <i class="fas fa-check-circle"></i> Export Successful
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="successModalBody">
                    Your export has been completed successfully!
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Error Modal -->
    <div class="modal fade" id="errorModal" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger">
                    <h5 class="modal-title text-white" id="errorModalLabel">
                        <i class="fas fa-exclamation-triangle"></i> Export Error
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="errorModalBody">
                    An error occurred during export.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Modal -->
    <div class="modal fade" id="loadingModal" tabindex="-1" aria-labelledby="loadingModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3 mb-0">Generating export...</p>
                </div>
            </div>
        </div>
    </div>


            `;

    populateQuizLevelFilter();
    populateAcademicYearFilter();
    populateCourseFilters();
    populateDepartmentFilter();
    populateQuizTypeFilter();

            // Update statistics
            fetch('Reports.aspx/GetStatistics', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' }
})
.then(res => res.json())
.then(result => {
    if (result.d && result.d.success) {
        document.getElementById('totalStudents').textContent = result.d.data.students;
        document.getElementById('totalTeachers').textContent = result.d.data.teachers;
        document.getElementById('totalCourses').textContent = result.d.data.courses;
        document.getElementById('totalQuizzes').textContent = result.d.data.quizzes;
    }
});
            // Check if PDF libraries are loaded
            console.log('jsPDF loaded:', typeof window.jspdf !== 'undefined');
            console.log('AutoTable loaded:', typeof window.jspdf?.jsPDF.API.autoTable !== 'undefined');
        });
    </script>

</asp:Content>
