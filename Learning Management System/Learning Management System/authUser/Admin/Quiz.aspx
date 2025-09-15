<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <title>Quiz Management - Learning Management System</title>
    
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
        
        .quiz-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        
        .page-header {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.15);
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
            color: #28a745;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-nav .breadcrumb-item a:hover {
            text-decoration: underline;
        }
        
        /* Course List View */
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .course-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(40, 167, 69, 0.15);
            border-color: #28a745;
        }
        
        .course-card .course-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #28a745, #1e7e34);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }
        
        .course-card .course-icon i {
            font-size: 24px;
            color: white;
        }
        
        .course-card h5 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .course-card .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        
        .course-card .sections-count {
            color: #6c757d;
            font-size: 14px;
        }
        
        .course-card .quizzes-count {
            background: #e8f5e8;
            color: #155724;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        /* Course Sections View */
        .course-sections {
            display: none;
        }
        
        .course-info-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .sections-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .section-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            border-left: 4px solid #28a745;
        }
        
        .section-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.15);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .section-icon {
            width: 40px;
            height: 40px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }
        
        .section-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
        }
        
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            border: none;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-view {
            background: #e8f5e8;
            color: #155724;
        }
        
        .btn-add {
            background: #d4edda;
            color: #0a3622;
        }
        
        .btn-view:hover {
            background: #c3e6cb;
        }
        
        .btn-add:hover {
            background: #b8dabd;
        }
        
        /* Quiz Management View */
        .quiz-management {
            display: none;
        }
        
        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .quiz-table {
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
        
        .quiz-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            background: #e8f5e8;
            color: #155724;
        }
        
        .btn-sm-custom {
            padding: 6px 12px;
            font-size: 12px;
            border-radius: 6px;
            margin: 0 2px;
        }
        
/* Stylish loading spinner for course grid */
.course-loading-spinner {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 180px;
    color: #039a12cd;
    font-size: 1.1rem;
    font-weight: 500;
    opacity: 0.85;
}
.course-loading-spinner .spinner-border {
    width: 3rem;
    height: 3rem;
    margin-bottom: 1rem;
    color: #249d06c8;
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
        
        <%-- .modal-dialog{
            display: flex;
            background: rgba(0, 0, 0, 0.5);
            width: 100%;
            height: 100%;
        } --%>

        
        .modal-header {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        
        .btn-close-white {
            filter: brightness(0) invert(1);
        }
        
        /* Excel Format Guide */
        .excel-format {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .excel-format table {
            font-size: 12px;
        }
        
        .excel-format th {
            background: #e9ecef;
            font-weight: 600;
        }
        
        /* Hide/Show Views */
        .view-active {
            display: block !important;
        }
        
        .hidden {
            display: none !important;
        }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="quiz-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="mb-2">
                <i class="fas fa-question-circle me-3"></i>
                Quiz Management
            </h1>
            <p class="mb-0 opacity-75">Create and manage course quizzes and assessments</p>
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
                <h3 class="text-success">
                    <i class="fas fa-graduation-cap me-2"></i>
                    Select a Course
                </h3>
                <div class="text-muted">
                    <i class="fas fa-info-circle me-1"></i>
                    Click on a course to manage its quizzes
                </div>
            </div>
            
            <div class="course-grid" id="courseGrid">
                <!-- Courses will be loaded here -->
            </div>
        </div>

        <!-- VIEW 2: Course Sections -->
        <div id="courseSectionsView" class="course-sections">
            <button type="button" type="button" class="back-btn mb-4" onclick="showCourseList()">
                <i class="fas fa-arrow-left"></i>
                Back to Courses
            </button>

            <!-- Selected Course Info -->
            <div class="course-info-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="text-success mb-2" id="selectedCourseTitle">Course Title</h3>
                        <p class="text-muted mb-0" id="selectedCourseDesc">Course description and details</p>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="d-flex justify-content-end gap-3">
                            <div class="text-center">
                                <div class="h4 text-success mb-0" id="totalSections">0</div>
                                <small class="text-muted">Sections</small>
                            </div>
                            <div class="text-center">
                                <div class="h4 text-warning mb-0" id="totalQuizzes">0</div>
                                <small class="text-muted">Quizzes</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Course Sections -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="text-success">
                    <i class="fas fa-list me-2"></i>
                    Course Sections
                </h4>
                <div class="text-muted">
                    <small>Select a section to manage its quizzes</small>
                </div>
            </div>

            <div class="sections-grid" id="sectionsGrid">
                <!-- Sections will be loaded here -->
            </div>
        </div>

        <!-- VIEW 3: Quiz Management -->
        <div id="quizManagementView" class="quiz-management">
            <button type="button" type="button" class="back-btn mb-4" onclick="showCourseList()">
                <i class="fas fa-arrow-left"></i>
                Back to Courses
            </button>

            <!-- Quiz Header -->
            <div class="quiz-header">
                <div>
                    <h4 class="text-success mb-1" id="sectionTitle">Section Title</h4>
                    <p class="text-muted mb-0" id="sectionDescription">Section description</p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" type="button" class="btn btn-info" onclick="viewQuizSubmissions()">
                        <i class="fas fa-clipboard-list me-2"></i>
                        View Submissions
                    </button>
                    <button type="button" type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#addQuizModal">
                        <i class="fas fa-plus me-2"></i>
                        Add Quiz
                    </button>
                    <button type="button" type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#uploadExcelModal">
                        <i class="fas fa-file-excel me-2"></i>
                        Upload Excel
                    </button>
                </div>
            </div>

            <!-- Quiz Table -->
            <div class="quiz-table">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="quizTable">
                        <thead>
                            <tr>
                                <th>Quiz</th>
                                <th>Schedule</th>
                                <th>Duration</th>
                                <th>Attempts</th>
                                <th>Questions</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="quizTableBody">
                            <!-- Quizzes will be loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- VIEW 4: Questions Management -->
        <div id="questionsManagementView" class="quiz-management" style="display: none;">
            <button type="button" type="button" class="back-btn mb-4" onclick="backToQuizManagement()">
                <i class="fas fa-arrow-left"></i>
                Back to Quizzes
            </button>

            <!-- Questions Header -->
            <div class="quiz-header">
                <div>
                    <h4 class="text-primary mb-1" id="questionsQuizTitle">Quiz Title</h4>
                    <p class="text-muted mb-0" id="questionsQuizInfo">Quiz information</p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addQuestionModal">
                        <i class="fas fa-plus me-2"></i>
                        Add Question
                    </button>
                    <button type="button" type="button" class="btn btn-primary" onclick="previewQuiz()">
                        <i class="fas fa-play me-2"></i>
                        Preview Quiz
                    </button>
                </div>
            </div>

            <!-- Questions List -->
            <div class="quiz-table">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="questionsTable">
                        <thead>
                            <tr>
                                <th style="width: 50px;">#</th>
                                <th>Question</th>
                                <th style="width: 120px;">Type</th>
                                <th style="width: 100px;">Points</th>
                                <th style="width: 100px;">Difficulty</th>
                                <th style="width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="questionsTableBody">
                            <!-- Questions will be loaded here -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>


    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>

        let currentQuiz = null;
        let currentCourse = null;
        let currentSection = null;

        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {

            const body = document.getElementsByTagName('body')[0];
            body.innerHTML += `
               
               
    <!-- Add Quiz Modal -->
    <div class="modal fade" id="addQuizModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>
                        Create New Quiz
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addQuizForm">
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="quizTitle" class="form-label">Quiz Title</label>
                                <input type="text" class="form-control" id="quizTitle" placeholder="Enter quiz title" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="quizDuration" class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" id="quizDuration" min="5" max="180" placeholder="30" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="quizDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="quizDescription" rows="3" placeholder="Brief description of the quiz..."></textarea>
                        </div>
                        
                        <!-- Quiz Schedule -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="quizStartDate" class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="quizStartDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="quizStartTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="quizStartTime" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="quizEndDate" class="form-label">End Date</label>
                                <input type="date" class="form-control" id="quizEndDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="quizEndTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="quizEndTime" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="quizMaxAttempts" class="form-label">Max Attempts</label>
                                <input type="number" class="form-control" id="quizMaxAttempts" min="1" max="10" value="3" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="quizStatus" class="form-label">Status</label>
                                <select class="form-select" id="quizStatus" required>
                                    <option value="draft">Draft</option>
                                    <option value="active">Active</option>
                                    <option value="archived">Archived</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="quizType" class="form-label">Quiz Type</label>
                                <select class="form-select" id="quizType" required>
                                    <option value="practice">Practice Quiz</option>
                                    <option value="graded">Graded Quiz</option>
                                    <option value="exam">Exam</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="quizIsActivated" checked>
                                    <label class="form-check-label" for="quizIsActivated">
                                        <strong>Activate Quiz</strong> - Students can take this quiz when activated
                                    </label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-success" onclick="createQuiz()">
                        <i class="fas fa-save me-2"></i>Create Quiz
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Upload Excel Modal -->
    <div class="modal fade" id="uploadExcelModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-file-excel me-2"></i>
                        Upload Quiz from Excel
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="uploadExcelForm">
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="excelQuizTitle" class="form-label">Quiz Title</label>
                                <input type="text" class="form-control" id="excelQuizTitle" placeholder="Enter quiz title" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="excelQuizDuration" class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" id="excelQuizDuration" min="5" max="180" placeholder="30" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="excelFile" class="form-label">Excel File</label>
                            <input type="file" class="form-control" id="excelFile" accept=".xlsx,.xls" required>
                            <div class="form-text">Upload an Excel file with questions in the specified format below</div>
                        </div>
                        
                        <!-- Excel Format Guide -->
                        <div class="excel-format">
                            <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Excel Format Requirements</h6>
                            <p class="mb-2">Your Excel file must have the following columns in this exact order:</p>
                            <div class="table-responsive">
                                <table class="table table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th>Column A</th>
                                            <th>Column B</th>
                                            <th>Column C</th>
                                            <th>Column D</th>
                                            <th>Column E</th>
                                            <th>Column F</th>
                                        <tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><strong>Question</strong></td>
                                            <td><strong>A</strong></td>
                                            <td><strong>B</strong></td>
                                            <td><strong>C</strong></td>
                                            <td><strong>D</strong></td>
                                            <td><strong>Answer</strong></td>
                                        </tr>
                                        <tr class="table-light">
                                            <td>What is 2+2?</td>
                                            <td>3</td>
                                            <td>4</td>
                                            <td>5</td>
                                            <td>6</td>
                                            <td>B</td>
                                        </tr>
                                        <tr class="table-light">
                                            <td>What is the capital of France?</td>
                                            <td>London</td>
                                            <td>Berlin</td>
                                            <td>Paris</td>
                                            <td>Madrid</td>
                                            <td>C</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="alert alert-warning alert-sm mt-2">
                                <strong>Important:</strong> 
                                <ul class="mb-0 mt-1">
                                    <li>The Answer column should contain A, B, C, or D</li>
                                    <li>First row should contain headers</li>
                                    <li>Questions start from row 2</li>
                                    <li>All cells must be filled</li>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="excelQuizStatus" class="form-label">Status</label>
                                <select class="form-select" id="excelQuizStatus" required>
                                    <option value="draft">Draft</option>
                                    <option value="active">Active</option>
                                    <option value="archived">Archived</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="excelQuizType" class="form-label">Quiz Type</label>
                                <select class="form-select" id="excelQuizType" required>
                                    <option value="practice">Practice Quiz</option>
                                    <option value="graded">Graded Quiz</option>
                                    <option value="exam">Exam</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-success" onclick="uploadExcelQuiz()">
                        <i class="fas fa-upload me-2"></i>Upload Quiz
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>
                        Add New Question
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addQuestionForm">
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="questionText" class="form-label">Question Text</label>
                                <textarea class="form-control" id="questionText" rows="3" placeholder="Enter the question text..." required></textarea>
                            </div>
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <label for="questionType" class="form-label">Question Type</label>
                                        <select class="form-select" id="questionType" onchange="toggleAnswerFields()" required>
                                            <option value="multiple-choice">Multiple Choice</option>
                                            <option value="true-false">True/False</option>
                                            <option value="short-answer">Short Answer</option>
                                            <option value="essay">Essay</option>
                                        </select>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label for="questionPoints" class="form-label">Points</label>
                                        <input type="number" class="form-control" id="questionPoints" min="1" max="100" value="1" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label for="questionDifficulty" class="form-label">Difficulty</label>
                                        <select class="form-select" id="questionDifficulty" required>
                                            <option value="easy">Easy</option>
                                            <option value="medium">Medium</option>
                                            <option value="hard">Hard</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Multiple Choice Options -->
                        <div id="multipleChoiceOptions">
                            <h6 class="mb-3">Answer Options</h6>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option A</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="correctAnswer" value="A" required>
                                        </div>
                                        <input type="text" class="form-control" id="optionA" placeholder="Enter option A" required>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option B</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="correctAnswer" value="B" required>
                                        </div>
                                        <input type="text" class="form-control" id="optionB" placeholder="Enter option B" required>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option C</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="correctAnswer" value="C" required>
                                        </div>
                                        <input type="text" class="form-control" id="optionC" placeholder="Enter option C" required>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option D</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="correctAnswer" value="D" required>
                                        </div>
                                        <input type="text" class="form-control" id="optionD" placeholder="Enter option D" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- True/False Options -->
                        <div id="trueFalseOptions" style="display: none;">
                            <h6 class="mb-3">Correct Answer</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="tfAnswer" id="tfTrue" value="true">
                                        <label class="form-check-label" for="tfTrue">True</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="tfAnswer" id="tfFalse" value="false">
                                        <label class="form-check-label" for="tfFalse">False</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Short Answer/Essay -->
                        <div id="textAnswerOptions" style="display: none;">
                            <div class="mb-3">
                                <label for="correctAnswer" class="form-label">Sample Correct Answer (Optional)</label>
                                <textarea class="form-control" id="correctAnswer" rows="2" placeholder="Provide a sample answer or key points..."></textarea>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="questionExplanation" class="form-label">Explanation (Optional)</label>
                            <textarea class="form-control" id="questionExplanation" rows="2" placeholder="Provide an explanation for the correct answer..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-primary" onclick="addQuestion()">
                        <i class="fas fa-save me-2"></i>Add Question
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Question Modal -->
    <div class="modal fade" id="editQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>
                        Edit Question
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editQuestionForm">
                        <input type="hidden" id="editQuestionId">
                        <!-- Same structure as add question form -->
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="editQuestionText" class="form-label">Question Text</label>
                                <textarea class="form-control" id="editQuestionText" rows="3" required></textarea>
                            </div>
                            <div class="col-md-4">
                                <div class="row">
                                    <div class="col-12 mb-3">
                                        <label for="editQuestionType" class="form-label">Question Type</label>
                                        <select class="form-select" id="editQuestionType" onchange="toggleEditAnswerFields()" required>
                                            <option value="multiple-choice">Multiple Choice</option>
                                            <option value="true-false">True/False</option>
                                            <option value="short-answer">Short Answer</option>
                                            <option value="essay">Essay</option>
                                        </select>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label for="editQuestionPoints" class="form-label">Points</label>
                                        <input type="number" class="form-control" id="editQuestionPoints" min="1" max="100" required>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label for="editQuestionDifficulty" class="form-label">Difficulty</label>
                                        <select class="form-select" id="editQuestionDifficulty" required>
                                            <option value="easy">Easy</option>
                                            <option value="medium">Medium</option>
                                            <option value="hard">Hard</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Multiple Choice Options -->
                        <div id="editMultipleChoiceOptions">
                            <h6 class="mb-3">Answer Options</h6>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option A</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="editCorrectAnswer" value="A">
                                        </div>
                                        <input type="text" class="form-control" id="editOptionA">
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option B</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="editCorrectAnswer" value="B">
                                        </div>
                                        <input type="text" class="form-control" id="editOptionB">
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option C</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="editCorrectAnswer" value="C">
                                        </div>
                                        <input type="text" class="form-control" id="editOptionC">
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Option D</label>
                                    <div class="input-group">
                                        <div class="input-group-text">
                                            <input class="form-check-input" type="radio" name="editCorrectAnswer" value="D">
                                        </div>
                                        <input type="text" class="form-control" id="editOptionD">
                                    </div>
                                </div>
                            </div>
                        </div>
<!-- Edit True/False Options -->
<div id="editTrueFalseOptions" style="display: none;">
    <h6 class="mb-3">Correct Answer</h6>
    <div class="row">
        <div class="col-md-6">
            <div class="form-check">
                <input class="form-check-input" type="radio" name="editTfAnswer" id="editTfTrue" value="true">
                <label class="form-check-label" for="editTfTrue">True</label>
            </div>
        </div>
        <div class="col-md-6">
            <div class="form-check">
                <input class="form-check-input" type="radio" name="editTfAnswer" id="editTfFalse" value="false">
                <label class="form-check-label" for="editTfFalse">False</label>
            </div>
        </div>
    </div>
</div>
                        <div class="mb-3">
                            <label for="editQuestionExplanation" class="form-label">Explanation (Optional)</label>
                            <textarea class="form-control" id="editQuestionExplanation" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-success" onclick="updateQuestion()">
                        <i class="fas fa-save me-2"></i>Update Question
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Question Modal -->
    <div class="modal fade" id="viewQuestionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>
                        Question Details
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-8">
                            <h5 id="viewQuestionText" class="text-primary">Question Text</h5>
                        </div>
                        <div class="col-md-4 text-end">
                            <span id="viewQuestionType" class="badge bg-info">Multiple Choice</span>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h5 text-success mb-1" id="viewQuestionPoints">1</div>
                                <small class="text-muted">Points</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h6 text-warning mb-1" id="viewQuestionDifficulty">Medium</div>
                                <small class="text-muted">Difficulty</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h6 text-muted mb-1" id="viewQuestionNumber">1</div>
                                <small class="text-muted">Question #</small>
                            </div>
                        </div>
                    </div>
                    
                    <div id="viewQuestionOptions" class="mb-3">
                        <!-- Options will be displayed here -->
                    </div>
                    
                    <div id="viewQuestionExplanation" class="alert alert-info" style="display: none;">
                        <strong>Explanation:</strong> <span id="explanationText"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" type="button" class="btn btn-warning" onclick="editQuestionFromView()">
                        <i class="fas fa-edit me-2"></i>Edit Question
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Question Modal -->
    <div class="modal fade" id="deleteQuestionModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-trash me-2"></i>
                        Delete Question
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle text-warning fa-3x mb-3"></i>
                        <h5>Are you sure you want to delete this question?</h5>
                        <p class="text-muted mb-3">
                            <strong>Question #<span id="deleteQuestionNumber">1</span></strong><br>
                            This action cannot be undone. The question will be permanently removed from the quiz.
                        </p>
                        <input type="hidden" id="deleteQuestionId">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-danger" onclick="confirmDeleteQuestion()">
                        <i class="fas fa-trash me-2"></i>Yes, Delete Question
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Quiz Modal -->
    <div class="modal fade" id="viewQuizModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>
                        Quiz Details
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
                            <h4 id="viewQuizTitle" class="text-success mb-2">Quiz Title</h4>
                            <p id="viewQuizDescription" class="text-muted mb-3">Quiz description will appear here...</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <span id="viewQuizStatus" class="badge bg-success">Active</span>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-2">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h4 text-primary mb-1" id="viewQuizQuestions">0</div>
                                <small class="text-muted">Questions</small>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h4 text-warning mb-1" id="viewQuizDuration">0</div>
                                <small class="text-muted">Minutes</small>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h4 text-success mb-1" id="viewQuizMaxAttempts">0</div>
                                <small class="text-muted">Max Attempts</small>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h4 text-info mb-1" id="viewQuizType">Practice</div>
                                <small class="text-muted">Type</small>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h6 text-muted mb-1" id="viewQuizCreated">2025-01-01</div>
                                <small class="text-muted">Created</small>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="text-center p-3 bg-light rounded">
                                <div class="h6 mb-1" id="viewQuizActivation">Active</div>
                                <small class="text-muted">Status</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quiz Schedule Information -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <div class="alert alert-success">
                                <i class="fas fa-calendar-check me-2"></i>
                                <strong>Start:</strong> <span id="viewQuizStartDateTime">2025-08-10 09:00</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="alert alert-warning">
                                <i class="fas fa-calendar-times me-2"></i>
                                <strong>End:</strong> <span id="viewQuizEndDateTime">2025-08-20 23:59</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Section:</strong> <span id="viewQuizSection">Section Name</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" type="button" class="btn btn-warning" onclick="editQuizFromView()">
                        <i class="fas fa-edit me-2"></i>Edit Quiz
                    </button>
                    <button type="button" type="button" class="btn btn-primary" onclick="manageQuestions()">
                        <i class="fas fa-question me-2"></i>Manage Questions
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Quiz Modal -->
    <div class="modal fade" id="editQuizModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-edit me-2"></i>
                        Edit Quiz
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editQuizForm">
                        <input type="hidden" id="editQuizId">
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="editQuizTitle" class="form-label">Quiz Title</label>
                                <input type="text" class="form-control" id="editQuizTitle" placeholder="Enter quiz title" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="editQuizDuration" class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" id="editQuizDuration" min="5" max="180" placeholder="30" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editQuizDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editQuizDescription" rows="3" placeholder="Brief description of the quiz..."></textarea>
                        </div>
                        
                        <!-- Quiz Schedule -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editQuizStartDate" class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="editQuizStartDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editQuizStartTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="editQuizStartTime" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editQuizEndDate" class="form-label">End Date</label>
                                <input type="date" class="form-control" id="editQuizEndDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editQuizEndTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="editQuizEndTime" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label for="editQuizMaxAttempts" class="form-label">Max Attempts</label>
                                <input type="number" class="form-control" id="editQuizMaxAttempts" min="1" max="10" required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="editQuizQuestions" class="form-label">Number of Questions</label>
                                <input type="number" class="form-control" id="editQuizQuestions" readonly disabled>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="editQuizStatus" class="form-label">Status</label>
                                <select class="form-select" id="editQuizStatus" required>
                                    <option value="draft">Draft</option>
                                    <option value="active">Active</option>
                                    <option value="archived">Archived</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="editQuizType" class="form-label">Quiz Type</label>
                                <select class="form-select" id="editQuizType" required>
                                    <option value="practice">Practice Quiz</option>
                                    <option value="graded">Graded Quiz</option>
                                    <option value="exam">Exam</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="editQuizIsActivated">
                                    <label class="form-check-label" for="editQuizIsActivated">
                                        <strong>Activate Quiz</strong> - Students can take this quiz when activated
                                    </label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-success" onclick="updateQuiz()">
                        <i class="fas fa-save me-2"></i>Update Quiz
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Quiz Modal -->
    <div class="modal fade" id="deleteQuizModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-trash me-2"></i>
                        Delete Quiz
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-exclamation-triangle text-warning fa-3x mb-3"></i>
                        <h5>Are you sure you want to delete this quiz?</h5>
                        <p class="text-muted mb-3">
                            <strong id="deleteQuizTitle">Quiz Title</strong><br>
                            This action cannot be undone. All quiz questions and student attempts will be permanently deleted.
                        </p>
                        <input type="hidden" id="deleteQuizId">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-danger" onclick="confirmDeleteQuiz()">
                        <i class="fas fa-trash me-2"></i>Yes, Delete Quiz
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Notification Modal -->
    <div class="modal fade" id="successModal" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-check-circle me-2"></i>
                        Success
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-check-circle text-success fa-3x mb-3"></i>
                    <h5 id="successMessage">Operation completed successfully!</h5>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-success" onClick="showSuccessOk()" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Error Notification Modal -->
    <div class="modal fade" id="errorModal" tabindex="-1">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Error
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-exclamation-triangle text-danger fa-3x mb-3"></i>
                    <h5 id="errorMessage">An error occurred!</h5>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-danger" data-bs-dismiss="modal">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirm Action Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title">
                        <i class="fas fa-question-circle me-2"></i>
                        Confirm Action
                    </h5>
                    <button type="button" type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-question-circle text-warning fa-3x mb-3"></i>
                    <h5 id="confirmMessage">Are you sure you want to continue?</h5>
                    <p class="text-muted" id="confirmDetails"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-warning" id="confirmButton" onclick="executeConfirmAction()">
                        <i class="fas fa-check me-2"></i>Yes, Continue
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Toggle Quiz Activation Modal -->
    <div class="modal fade" id="toggleActivationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-toggle-on me-2"></i>
                        <span id="toggleActionTitle">Toggle Quiz Status</span>
                    </h5>
                    <button type="button" type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <i class="fas fa-toggle-on text-info fa-3x mb-3" id="toggleIcon"></i>
                    <h5 id="toggleMessage">Change quiz activation status?</h5>
                    <p class="text-muted" id="toggleDetails"></p>
                    <input type="hidden" id="toggleQuizId">
                </div>
                <div class="modal-footer">
                    <button type="button" type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" type="button" class="btn btn-info" id="toggleConfirmButton" onclick="executeToggleActivation()">
                        <i class="fas fa-toggle-on me-2"></i>
                        <span id="toggleButtonText">Confirm</span>
                    </button>
                </div>
            </div>
        </div>
    </div>

            `;




            loadCourses();
        });

        function loadCourses() {
    const courseGrid = document.getElementById('courseGrid');
    courseGrid.innerHTML = `
    <div class="course-loading-spinner">
        <div class="spinner-border" role="status"></div>
        <div>Loading courses, please wait...</div>
    </div>
`;
    $.ajax({
        type: "POST",
        url: "Quiz.aspx/GetCourses",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            courseGrid.innerHTML = '';
            if (response.d && response.d.success) {
                const courses = response.d.data;
                if (courses.length === 0) {
                    courseGrid.innerHTML = '<div class="text-center py-5 text-muted">No courses found.</div>';
                    return;
                }
                courses.forEach(course => {
                    const courseCard = document.createElement('div');
                    courseCard.className = 'course-card';
                    courseCard.onclick = () => showCourseQuizzes(course);
                    courseCard.innerHTML = `
                        <div class="course-icon">
                            <i class="fas fa-question-circle"></i>
                        </div>
                        <h5>${course.name}</h5>
                        <p class="text-muted mb-2">${course.code}</p>
                        <p class="small text-muted">${course.description || ''}</p>
                        <div class="course-meta">
                            <span class="sections-count">
                                <i class="fas fa-list me-1"></i>
                                <!-- You can fetch and show section count here -->
                            </span>
                            <span class="quizzes-count">
                                ${course.quizCount}
                            </span>
                        </div>
                    `;
                    courseGrid.appendChild(courseCard);
                });
            } else {
                courseGrid.innerHTML = '<div class="text-center py-5 text-danger">Failed to load courses.</div>';
            }
        },
        error: function() {
            courseGrid.innerHTML = '<div class="text-center py-5 text-danger">Error loading courses.</div>';
        }
    });
}

        // Show course sections
        function showCourseSections(course) {
            currentCourse = course;
            
            // Update breadcrumb
            document.getElementById('breadcrumb').innerHTML = `
                <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseList()">All Courses</a></li>
                <li class="breadcrumb-item active">${course.name}</li>
            `;
            
            // Update course info
            document.getElementById('selectedCourseTitle').textContent = course.name;
            document.getElementById('selectedCourseDesc').textContent = `${course.code} - ${course.description}`;
            document.getElementById('totalSections').textContent = course.sections;
            document.getElementById('totalQuizzes').textContent = course.quizzes;
            
            // Load sections
            loadCourseSections(course.id);
            
            // Switch views
            document.getElementById('courseListView').classList.remove('view-active');
            document.getElementById('courseSectionsView').classList.add('view-active');
            document.getElementById('quizManagementView').classList.remove('view-active');
        }

        // Show course quizzes directly
        function showCourseQuizzes(course) {
            currentCourse = course;
            
            // Update breadcrumb
            document.getElementById('breadcrumb').innerHTML = `
                <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseList()">All Courses</a></li>
                <li class="breadcrumb-item active">${course.name} - Quiz Management</li>
            `;
            
            // Update section info to show course info
            document.getElementById('sectionTitle').textContent = `${course.name} - All Quizzes`;
            document.getElementById('sectionDescription').textContent = `${course.code} - Manage all quizzes for this course`;
            
            // Load all quizzes for this course
            loadCourseQuizzes(course.id);
            
            // Switch views
            document.getElementById('courseListView').classList.remove('view-active');
            document.getElementById('courseSectionsView').classList.remove('view-active');
            document.getElementById('quizManagementView').classList.add('view-active');
        }

        // Show course quizzes directly
        <%-- function showCourseQuizzes(course) {
            currentCourse = course;
            
            // Update breadcrumb
            document.getElementById('breadcrumb').innerHTML = `
                <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseList()">All Courses</a></li>
                <li class="breadcrumb-item active">${course.name} - Quiz Management</li>
            `;
            
            // Update section info to show course info
            document.getElementById('sectionTitle').textContent = `${course.name} - All Quizzes`;
            document.getElementById('sectionDescription').textContent = `${course.code} - Manage all quizzes for this course`;
            
            // Load all quizzes for this course
            loadCourseQuizzes(course.id);
            
            // Switch views
            document.getElementById('courseListView').classList.remove('view-active');
            document.getElementById('courseSectionsView').classList.remove('view-active');
            document.getElementById('quizManagementView').classList.add('view-active');
            document.getElementById('questionsManagementView').classList.remove('view-active');
            
            // Reset display styles for other views
            document.getElementById('questionsManagementView').style.display = 'none';
            document.getElementById('quizManagementView').style.display = 'block';
        } --%>

        // Load course sections
        function loadCourseSections(courseId) {
            const sectionsGrid = document.getElementById('sectionsGrid');
            sectionsGrid.innerHTML = '';
            
            const sections = courseSections[courseId] || [];
            
            sections.forEach(section => {
                const sectionCard = document.createElement('div');
                sectionCard.className = 'section-card';
                
                sectionCard.innerHTML = `
                    <div class="section-header">
                        <div class="section-icon">
                            <i class="fas fa-folder"></i>
                        </div>
                        <div>
                            <h6 class="mb-1">${section.name}</h6>
                            <small class="text-muted">${section.quizzes} quizzes</small>
                        </div>
                    </div>
                    <p class="text-muted small mb-3">${section.description}</p>
                    <div class="section-actions">
                        <button type="button" type="button" class="btn-action btn-view" onclick="showQuizzes(${section.id}, '${section.name}', '${section.description}')">
                            <i class="fas fa-eye me-1"></i>View Quizzes
                        </button>
                        <button type="button" type="button" class="btn-action btn-add" onclick="showQuizzes(${section.id}, '${section.name}', '${section.description}')">
                            <i class="fas fa-plus me-1"></i>Add Quiz
                        </button>
                    </div>
                `;
                
                sectionsGrid.appendChild(sectionCard);
            });
        }

        // Show quizzes for a section
        function showQuizzes(sectionId, sectionName, sectionDesc) {
            currentSection = sectionId;
            
            // Update breadcrumb
            document.getElementById('breadcrumb').innerHTML = `
                <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseList()">All Courses</a></li>
                <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseSections(currentCourse)">${currentCourse.name}</a></li>
                <li class="breadcrumb-item active">${sectionName}</li>
            `;
            
            // Update section info
            document.getElementById('sectionTitle').textContent = sectionName;
            document.getElementById('sectionDescription').textContent = sectionDesc;
            
            // Load quizzes
            loadSectionQuizzes(sectionId);
            
            // Switch views
            document.getElementById('courseListView').classList.remove('view-active');
            document.getElementById('courseSectionsView').classList.remove('view-active');
            document.getElementById('quizManagementView').classList.add('view-active');
        }


        // Load quizzes for a section
        function loadSectionQuizzes(sectionId) {
    const tableBody = document.getElementById('quizTableBody');
    tableBody.innerHTML = `
         <tr>
            <td colspan="7" class="text-center py-4 text-muted">
                <div class="spinner-border text-success" role="status"></div>
                <div>Loading courses, please wait...</div>
            </td>
        </tr>
    `;

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/GetSectionQuizzes",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ sectionId: sectionId }),
        success: function(response) {
            tableBody.innerHTML = '';
            if (response.d && response.d.success) {
                const quizzes = response.d.data;
                if (quizzes.length === 0) {
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">
                                <i class="fas fa-question-circle fa-2x mb-2 d-block"></i>
                                No quizzes found. Click "Add Quiz" or "Upload Excel" to create some.
                            </td>
                        </tr>
                    `;
                    return;
                }
                quizzes.forEach(quiz => {
                    const statusClass = quiz.status === 'active' ? 'success' : quiz.status === 'draft' ? 'warning' : 'secondary';
                    const typeClass = quiz.type === 'exam' ? 'danger' : quiz.type === 'graded' ? 'primary' : 'info';
                    const activationClass = quiz.isActivated ? 'success' : 'danger';
                    const activationText = quiz.isActivated ? 'Active' : 'Inactive';
                    const startDateTime = `${quiz.startDate} ${quiz.startTime}`;
                    const endDateTime = `${quiz.endDate} ${quiz.endTime}`;
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="quiz-icon">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${quiz.title}</div>
                                    <small class="text-muted">
                                        <span class="badge bg-${typeClass}">${quiz.type}</span>
                                    </small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="small">
                                <div><strong>Start:</strong> ${startDateTime}</div>
                                <div><strong>End:</strong> ${endDateTime}</div>
                            </div>
                        </td>
                        <td>
                            <span class="badge bg-info">${quiz.duration} min</span>
                        </td>
                        <td>
                            <span class="badge bg-primary">${quiz.maxAttempts}</span>
                        </td>
                        <td>--</td>
                        <td>
                            <div class="d-flex flex-column gap-1">
                                <span class="badge bg-${statusClass}">${quiz.status}</span>
                                <span class="badge bg-${activationClass}">${activationText}</span>
                            </div>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <button type="button" type="button" class="btn btn-sm-custom btn-outline-primary" onclick='viewQuiz(${JSON.stringify(quiz)})' title="View">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" type="button" class="btn btn-sm-custom btn-outline-info" onclick='manageQuestionsForQuiz(${JSON.stringify(quiz)})' title="Questions">
                                    <i class="fas fa-question"></i>
                                </button>
                                <button type="button" type="button" class="btn btn-sm-custom btn-outline-warning" onclick='editQuiz(${JSON.stringify(quiz)})' title="Edit">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm-custom btn-outline-${quiz.isActivated ? 'success' : 'danger'}" 
        onclick='toggleQuizActivation(${JSON.stringify(quiz)})' 
        title="${quiz.isActivated ? 'Deactivate' : 'Activate'}">
    <i class="fas fa-${quiz.isActivated ? 'toggle-off' : 'toggle-on'}"></i>
</button>
                                <button type="button" type="button" class="btn btn-sm-custom btn-outline-danger" onclick='deleteQuiz(${JSON.stringify(quiz)})' title="Delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    `;
                    tableBody.appendChild(row);
                });
            } else {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="7" class="text-center py-4 text-danger">
                            Failed to load quizzes.
                        </td>
                    </tr>
                `;
            }
        },
        error: function() {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center py-4 text-danger">
                        Error loading quizzes.
                    </td>
                </tr>
            `;
        }
    });
}

 // Load all quizzes for a course
        function loadCourseQuizzes(courseId) {
    const tableBody = document.getElementById('quizTableBody');
    tableBody.innerHTML = `
        <tr>
            <td colspan="7" class="text-center py-4 text-muted">
                <div class="spinner-border text-success" role="status"></div>
                <div>Loading quizzes, please wait...</div>
            </td>
        </tr>
    `;

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/GetCourseQuizzes",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ courseId: courseId }),
        success: function(response) {
            tableBody.innerHTML = '';
            if (response.d && response.d.success) {
                const quizzes = response.d.data;
                if (quizzes.length === 0) {
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">
                                <i class="fas fa-question-circle fa-2x mb-2 d-block"></i>
                                No quizzes found for this course. Click "Add Quiz" or "Upload Excel" to create some.
                            </td>
                        </tr>
                    `;
                    return;
                }
                quizzes.forEach(quiz => {
                    const statusClass = quiz.status === 'active' ? 'success' : quiz.status === 'draft' ? 'warning' : 'secondary';
                    const typeClass = quiz.type === 'exam' ? 'danger' : quiz.type === 'graded' ? 'primary' : 'info';
                    const activationClass = quiz.isActivated ? 'success' : 'danger';
                    const activationText = quiz.isActivated ? 'Active' : 'Inactive';
                    const startDateTime = `${quiz.startDate} ${quiz.startTime}`;
                    const endDateTime = `${quiz.endDate} ${quiz.endTime}`;
                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="quiz-icon">
                                    <i class="fas fa-question-circle"></i>
                                </div>
                                <div>
                                    <div class="fw-bold">${quiz.title}</div>
                                    <small class="text-muted">
                                        <span class="badge bg-${typeClass}">${quiz.type}</span>
                                    </small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="small">
                                <div><strong>Start:</strong> ${startDateTime}</div>
                                <div><strong>End:</strong> ${endDateTime}</div>
                            </div>
                        </td>
                        <td>
                            <span class="badge bg-info">${quiz.duration} min</span>
                        </td>
                        <td>
                            <span class="badge bg-primary">${quiz.maxAttempts}</span>
                        </td>
                        <td>${quiz.questions} questions</td>
                        <td>
                            <div class="d-flex flex-column gap-1">
                                <span class="badge bg-${statusClass}">${quiz.status}</span>
                                <span class="badge bg-${activationClass}">${activationText}</span>
                            </div>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-sm-custom btn-outline-primary" onclick='viewQuiz(${JSON.stringify(quiz)})' title="View">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn btn-sm-custom btn-outline-info" onclick='manageQuestionsForQuiz(${JSON.stringify(quiz)})' title="Questions">
                                    <i class="fas fa-question"></i>
                                </button>
                                <button type="button" class="btn btn-sm-custom btn-outline-warning" onclick='editQuiz(${JSON.stringify(quiz)})' title="Edit">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm-custom btn-outline-${quiz.isActivated ? 'danger' : 'success'}" 
        onclick='toggleQuizActivation(${JSON.stringify(quiz)})' 
        title="${quiz.isActivated ? 'Deactivate' : 'Activate'}">
    <i class="fas fa-${quiz.isActivated ? 'toggle-off' : 'toggle-on'}"></i>
</button>
                                <button type="button" class="btn btn-sm-custom btn-outline-danger" onclick='deleteQuiz(${JSON.stringify(quiz)})' title="Delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    `;
                    tableBody.appendChild(row);
                });
            } else {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="7" class="text-center py-4 text-danger">
                            Failed to load quizzes.
                        </td>
                    </tr>
                `;
            }
        },
        error: function() {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center py-4 text-danger">
                        Error loading quizzes.
                    </td>
                </tr>
            `;
        }
    });
}


let courseQuizzes = {};

function createQuiz() {
    const form = document.getElementById('addQuizForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    // Gather form data
    const title = document.getElementById('quizTitle').value;
    const duration = parseInt(document.getElementById('quizDuration').value);
    const description = document.getElementById('quizDescription').value;
    const maxAttempts = parseInt(document.getElementById('quizMaxAttempts').value);
    const status = document.getElementById('quizStatus').value;
    const type = document.getElementById('quizType').value;
    const isActivated = document.getElementById('quizIsActivated').checked;
    const startDate = document.getElementById('quizStartDate').value;
    const startTime = document.getElementById('quizStartTime').value;
    const endDate = document.getElementById('quizEndDate').value;
    const endTime = document.getElementById('quizEndTime').value;

    // Combine date and time
const startDateTime = new Date(`${startDate}T${startTime}`);
const endDateTime = new Date(`${endDate}T${endTime}`);
const now = new Date();

// Validation: Start date/time must not be in the past
if (startDateTime < now) {
    showError('Start date/time must not be in the past.');
    return;
}

// Validation: Start date/time must be before end date/time
if (isNaN(startDateTime.getTime()) || isNaN(endDateTime.getTime())) {
    showError('Please enter valid start and end dates and times.');
    return;
}
if (startDateTime >= endDateTime) {
    showError('Start date/time must be before end date/time.');
    return;
}

// Validation: Duration must not exceed the difference between start and end
const diffMinutes = (endDateTime - startDateTime) / (1000 * 60);
if (duration > diffMinutes) {
    showError(`Quiz duration (${duration} min) cannot be longer than the time window (${Math.floor(diffMinutes)} min) between start and end.`);
    return;
}

    // Use currentCourse and currentSection from your JS context
    const courseId = currentCourse ? currentCourse.id : null;
    const sectionId = currentSection ? currentSection : null;

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/AddQuiz",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            courseId: courseId,
            sectionId: sectionId,
            title: title,
            description: description,
            duration: duration,
            maxAttempts: maxAttempts,
            status: status,
            type: type,
            isActivated: isActivated,
            startDate: startDate + 'T' + startTime,
            endDate: endDate + 'T' + endTime
        }),
        success: function(response) {
            if (response.d && response.d.success) {
                showSuccess('Quiz created successfully!');
                bootstrap.Modal.getInstance(document.getElementById('addQuizModal')).hide();
                document.getElementById('addQuizModal').style.display = 'none';
                form.reset();
                if (currentSection) {
                    loadSectionQuizzes(currentSection);
                } else if (currentCourse) {
                    loadCourseQuizzes(currentCourse.id);
                }
            } else {
                showError('Failed to create quiz: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            showError('Error creating quiz: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

        function uploadExcelQuiz() {
    const form = document.getElementById('uploadExcelForm');
    const fileInput = document.getElementById('excelFile');
    if (!form.checkValidity() || fileInput.files.length === 0) {
        form.reportValidity();
        return;
    }

    const file = fileInput.files[0];
    const reader = new FileReader();
    reader.onload = function(e) {
        const base64Excel = e.target.result.split(',')[1]; // Remove data:...base64, prefix

        // Gather other form data
        const title = document.getElementById('excelQuizTitle').value;
        const duration = parseInt(document.getElementById('excelQuizDuration').value);
        const status = document.getElementById('excelQuizStatus').value;
        const type = document.getElementById('excelQuizType').value;
        const courseId = currentCourse ? currentCourse.id : null;
        const sectionId = currentSection ? currentSection : null;

        $.ajax({
            type: "POST",
            url: "Quiz.aspx/UploadQuizExcel",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({
                base64Excel: base64Excel,
                title: title,
                duration: duration,
                status: status,
                type: type,
                courseId: courseId,
                sectionId: sectionId
            }),
            success: function(response) {
                if (response.d && response.d.success) {
                    showSuccess('Excel quiz uploaded and imported successfully!');
                    bootstrap.Modal.getInstance(document.getElementById('uploadExcelModal')).hide();
                    form.reset();
                    if (currentSection) {
                        loadSectionQuizzes(currentSection);
                    } else if (currentCourse) {
                        loadCourseQuizzes(currentCourse.id);
                    }
                } else {
                    showError('Failed to import quiz: ' + (response.d.message || 'Unknown error'));
                }
            },
            error: function(xhr) {
                showError('Error importing quiz: ' + (xhr.responseText || 'Unknown error'));
            }
        });
    };
    reader.readAsDataURL(file);
}
        // (Removed stray code block that was outside any function and causing errors)
        

        // Modal utility functions
        let confirmActionCallback = null;
        
        function showSuccess(message) {
            document.getElementById('successMessage').textContent = message;
            new bootstrap.Modal(document.getElementById('successModal')).show();
        }
        
       function showSuccessOk() {
    // Hide the success modal using Bootstrap's API
    const successModalEl = document.getElementById('successModal');
    const successModal = bootstrap.Modal.getInstance(successModalEl);
    if (successModal) successModal.hide();

    // Also hide the add quiz modal if it's still open
    const addQuizModalEl = document.getElementById('addQuizModal');
    const addQuizModal = bootstrap.Modal.getInstance(addQuizModalEl);
    if (addQuizModal) addQuizModal.hide();
    document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
}

        function showError(message) {
            document.getElementById('errorMessage').textContent = message;
            new bootstrap.Modal(document.getElementById('errorModal')).show();
        }
        
        function showConfirm(message, details, callback) {
            document.getElementById('confirmMessage').textContent = message;
            document.getElementById('confirmDetails').textContent = details || '';
            confirmActionCallback = callback;
            new bootstrap.Modal(document.getElementById('confirmModal')).show();
        }
        
        function executeConfirmAction() {
            if (confirmActionCallback) {
                confirmActionCallback();
                confirmActionCallback = null;
            }
            bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
        }

        // Toggle quiz activation status
        function toggleQuizActivation(quiz) {
    // If called with an ID (old code), show error
    if (typeof quiz === 'number') {
        showError('Quiz not found. Please refresh the page.');
        return;
    }

    const action = quiz.isActivated ? 'deactivate' : 'activate';

    // Update toggle modal content
    document.getElementById('toggleActionTitle').textContent = action.charAt(0).toUpperCase() + action.slice(1) + ' Quiz';
    document.getElementById('toggleMessage').textContent = `Are you sure you want to ${action} this quiz?`;
    document.getElementById('toggleDetails').textContent = `Quiz: "${quiz.title}"`;
    document.getElementById('toggleQuizId').value = quiz.id;
    document.getElementById('toggleButtonText').textContent = action.charAt(0).toUpperCase() + action.slice(1);

    // Store the quiz object for use in executeToggleActivation
    window.toggleQuizObj = quiz;

    // Show the toggle modal
    new bootstrap.Modal(document.getElementById('toggleActivationModal')).show();
}
        
        function executeToggleActivation() {
    const quiz = window.toggleQuizObj;
    if (!quiz) {
        showError('Quiz not found.');
        return;
    }

    // Send AJAX request to backend to toggle activation
    $.ajax({
        type: "POST",
        url: "Quiz.aspx/ToggleQuizActivation",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ quizId: quiz.id, activate: !quiz.isActivated }),
        success: function(response) {
            bootstrap.Modal.getInstance(document.getElementById('toggleActivationModal')).hide();
            if (response.d && response.d.success) {
                showSuccess(`Quiz has been ${quiz.isActivated ? 'deactivated' : 'activated'} successfully!`);
                // Reload the quiz list to reflect changes
                if (currentSection) {
                    loadSectionQuizzes(currentSection);
                } else if (currentCourse) {
                    loadCourseQuizzes(currentCourse.id);
                }
            } else {
                showError('Failed to update quiz activation: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            bootstrap.Modal.getInstance(document.getElementById('toggleActivationModal')).hide();
            showError('Error updating quiz activation: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

        // Navigation functions
        function showCourseList() {
            document.getElementById('breadcrumb').innerHTML = `
                <li class="breadcrumb-item active">All Courses</li>
            `;
            
            document.getElementById('courseListView').classList.add('view-active');
            document.getElementById('courseSectionsView').classList.remove('view-active');
            document.getElementById('quizManagementView').classList.remove('view-active');
            document.getElementById('questionsManagementView').classList.remove('view-active');
            
            // Reset display styles
            document.getElementById('quizManagementView').style.display = 'none';
            document.getElementById('questionsManagementView').style.display = 'none';
            
            currentCourse = null;
            currentSection = null;
            currentQuiz = null;
        }

        function showCourseSections() {
            if (currentCourse) {
                showCourseSections(currentCourse);
            }
        }

        // Quiz management functions
        function viewQuiz(quiz) {
    // If called with an ID (old code), find the quiz in loaded data
    if (typeof quiz === 'number') {
        // Try to find in sectionQuizzes or courseQuizzes
        quiz = null;
        // Search in sectionQuizzes
        for (const sectionId in sectionQuizzes) {
            const found = sectionQuizzes[sectionId].find(q => q.id === quiz);
            if (found) {
                quiz = found;
                break;
            }
        }
        // Optionally, search in courseQuizzes if needed
        if (!quiz && courseQuizzes && Array.isArray(courseQuizzes)) {
            quiz = courseQuizzes.find(q => q.id === quiz);
        }
        if (!quiz) {
            showError('Quiz not found.');
            return;
        }
    }

    // Populate the view modal
    document.getElementById('viewQuizTitle').textContent = quiz.title;
    document.getElementById('viewQuizDescription').textContent = quiz.description || 'No description provided.';
    document.getElementById('viewQuizQuestions').textContent = quiz.questions || '--';
    document.getElementById('viewQuizDuration').textContent = quiz.duration;
    document.getElementById('viewQuizMaxAttempts').textContent = quiz.maxAttempts || 'Unlimited';
    document.getElementById('viewQuizType').textContent = quiz.type.charAt(0).toUpperCase() + quiz.type.slice(1);
    document.getElementById('viewQuizCreated').textContent = quiz.created || '';
    document.getElementById('viewQuizSection').textContent = quiz.section || 'Unknown Section';

    // Set schedule information
    const startDateTime = `${quiz.startDate || ''} ${quiz.startTime || ''}`;
    const endDateTime = `${quiz.endDate || ''} ${quiz.endTime || ''}`;
    document.getElementById('viewQuizStartDateTime').textContent = startDateTime.trim();
    document.getElementById('viewQuizEndDateTime').textContent = endDateTime.trim();

    // Set activation status
    const activationElement = document.getElementById('viewQuizActivation');
    if (quiz.isActivated) {
        activationElement.textContent = 'Active';
        activationElement.className = 'h6 mb-1 text-success';
    } else {
        activationElement.textContent = 'Inactive';
        activationElement.className = 'h6 mb-1 text-danger';
    }

    // Set status badge
    const statusBadge = document.getElementById('viewQuizStatus');
    const statusClass = quiz.status === 'active' ? 'bg-success' : quiz.status === 'draft' ? 'bg-warning' : 'bg-secondary';
    statusBadge.className = `badge ${statusClass}`;
    statusBadge.textContent = quiz.status.charAt(0).toUpperCase() + quiz.status.slice(1);

    // Store quiz ID for potential edit action
    window.currentViewQuizId = quiz.id;

    // Show the modal
    new bootstrap.Modal(document.getElementById('viewQuizModal')).show();
}

        function editQuiz(quiz) {
    // If called with an ID (old code), show error
    if (typeof quiz === 'number') {
        showError('Quiz not found. Please refresh the page.');
        return;
    }

    // Populate the edit modal
    document.getElementById('editQuizId').value = quiz.id;
    document.getElementById('editQuizTitle').value = quiz.title;
    document.getElementById('editQuizDuration').value = quiz.duration;
    document.getElementById('editQuizDescription').value = quiz.description || '';
    document.getElementById('editQuizQuestions').value = quiz.questions || 0;
    document.getElementById('editQuizStatus').value = quiz.status;
    document.getElementById('editQuizType').value = quiz.type;

    // Populate new fields
    document.getElementById('editQuizStartDate').value = quiz.startDate || '';
    document.getElementById('editQuizStartTime').value = quiz.startTime || '';
    document.getElementById('editQuizEndDate').value = quiz.endDate || '';
    document.getElementById('editQuizEndTime').value = quiz.endTime || '';
    document.getElementById('editQuizMaxAttempts').value = quiz.maxAttempts || 3;
    document.getElementById('editQuizIsActivated').checked = quiz.isActivated !== false;

    // Show the modal
    new bootstrap.Modal(document.getElementById('editQuizModal')).show();
}

        function editQuizFromView() {
            // Close view modal and open edit modal
            bootstrap.Modal.getInstance(document.getElementById('viewQuizModal')).hide();
            setTimeout(() => {
                editQuiz(window.currentViewQuizId);
            }, 300);
        }

        function updateQuiz() {
    const form = document.getElementById('editQuizForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const quizId = parseInt(document.getElementById('editQuizId').value);
    const title = document.getElementById('editQuizTitle').value;
    const duration = parseInt(document.getElementById('editQuizDuration').value);
    const description = document.getElementById('editQuizDescription').value;
    const maxAttempts = parseInt(document.getElementById('editQuizMaxAttempts').value);
    const status = document.getElementById('editQuizStatus').value;
    const type = document.getElementById('editQuizType').value;
    const isActivated = document.getElementById('editQuizIsActivated').checked;
    const startDate = document.getElementById('editQuizStartDate').value;
    const startTime = document.getElementById('editQuizStartTime').value;
    const endDate = document.getElementById('editQuizEndDate').value;
    const endTime = document.getElementById('editQuizEndTime').value;

    // Validation (reuse your createQuiz validation if needed)
    const startDateTime = new Date(`${startDate}T${startTime}`);
    const endDateTime = new Date(`${endDate}T${endTime}`);
    const now = new Date();

    if (startDateTime < now) {
        showError('Start date/time must not be in the past.');
        return;
    }
    if (isNaN(startDateTime.getTime()) || isNaN(endDateTime.getTime())) {
        showError('Please enter valid start and end dates and times.');
        return;
    }
    if (startDateTime >= endDateTime) {
        showError('Start date/time must be before end date/time.');
        return;
    }
    const diffMinutes = (endDateTime - startDateTime) / (1000 * 60);
    if (duration > diffMinutes) {
        showError(`Quiz duration (${duration} min) cannot be longer than the time window (${Math.floor(diffMinutes)} min) between start and end.`);
        return;
    }

    // Use currentCourse and currentSection from your JS context
    const courseId = currentCourse ? currentCourse.id : null;
    const sectionId = currentSection ? currentSection : null;

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/UpdateQuiz",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            quizId: quizId,
            courseId: courseId,
            sectionId: sectionId,
            title: title,
            description: description,
            duration: duration,
            maxAttempts: maxAttempts,
            status: status,
            type: type,
            isActivated: isActivated,
            startDate: startDate + 'T' + startTime,
            endDate: endDate + 'T' + endTime
        }),
        success: function(response) {
            if (response.d && response.d.success) {
                showSuccess('Quiz updated successfully!');
                bootstrap.Modal.getInstance(document.getElementById('editQuizModal')).hide();
                if (currentSection) {
                    loadSectionQuizzes(currentSection);
                } else if (currentCourse) {
                    loadCourseQuizzes(currentCourse.id);
                }
            } else {
                showError('Failed to update quiz: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            showError('Error updating quiz: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

        function deleteQuiz(quiz) {
    // Accepts either a quiz object or an ID
    let quizObj = quiz;
    if (typeof quiz === 'number') {
        showError('Quiz not found. Please refresh the page.');
        return;
    }
    document.getElementById('deleteQuizId').value = quizObj.id;
    document.getElementById('deleteQuizTitle').textContent = quizObj.title;
    new bootstrap.Modal(document.getElementById('deleteQuizModal')).show();
}

function confirmDeleteQuiz() {
    const quizId = document.getElementById('deleteQuizId').value;
    $.ajax({
        type: "POST",
        url: "Quiz.aspx/DeleteQuiz",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ quizId: parseInt(quizId) }),
        success: function(response) {
            bootstrap.Modal.getInstance(document.getElementById('deleteQuizModal')).hide();
            if (response.d && response.d.success) {
                showSuccess('Quiz deleted successfully!');
                // Reload quizzes
                if (currentSection) {
                    loadSectionQuizzes(currentSection);
                } else if (currentCourse) {
                    loadCourseQuizzes(currentCourse.id);
                }
            } else {
                showError('Failed to delete quiz: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            bootstrap.Modal.getInstance(document.getElementById('deleteQuizModal')).hide();
            showError('Error deleting quiz: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}


        // Questions Management Functions
        function manageQuestions() {
            if (window.currentViewQuizId) {
                manageQuestionsForQuiz(window.currentViewQuizId);
                bootstrap.Modal.getInstance(document.getElementById('viewQuizModal')).hide();
            }
        }

        function manageQuestionsForQuiz(quiz) {
    // If called with a quiz ID (old code), find the quiz in loaded data
    if (typeof quiz === 'number') {
        // Optionally, fetch the quiz from your loaded quizzes array if needed
        showError('Quiz not found. Please refresh the page.');
        return;
    }

    currentQuiz = quiz;

    // Update header
    document.getElementById('questionsQuizTitle').textContent = quiz.title;
    document.getElementById('questionsQuizInfo').textContent =
        `${quiz.type.charAt(0).toUpperCase() + quiz.type.slice(1)} • ${quiz.duration} minutes`;

    // Update breadcrumb
    if (currentCourse) {
        document.getElementById('breadcrumb').innerHTML = `
            <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseList()">All Courses</a></li>
            <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="backToQuizManagement()">${currentCourse.name} - Quiz Management</a></li>
            <li class="breadcrumb-item active">${quiz.title} - Questions</li>
        `;
    }

    // Load questions for this quiz (implement this to fetch from DB if needed)
    loadQuestions(quiz.id);

    // Hide quiz management, show questions management
    document.getElementById('quizManagementView').classList.remove('view-active');
    document.getElementById('quizManagementView').style.display = 'none';
    document.getElementById('questionsManagementView').classList.add('view-active');
    document.getElementById('questionsManagementView').style.display = 'block';
}

        function backToQuizManagement() {
            // Hide questions management view
            document.getElementById('questionsManagementView').classList.remove('view-active');
            document.getElementById('questionsManagementView').style.display = 'none';
            
            // Show quiz management view
            document.getElementById('quizManagementView').classList.add('view-active');
            document.getElementById('quizManagementView').style.display = 'block';
            
            // Update breadcrumb
            if (currentCourse) {
                document.getElementById('breadcrumb').innerHTML = `
                    <li class="breadcrumb-item"><a href="javascript:void(0)" onclick="showCourseList()">All Courses</a></li>
                    <li class="breadcrumb-item active">${currentCourse.name} - Quiz Management</li>
                `;
            }
            
            // Clear current quiz
            currentQuiz = null;
        }

        function loadQuestions(quizId) {
    const tableBody = document.getElementById('questionsTableBody');
    tableBody.innerHTML = `
        <tr>
            <td colspan="6" class="text-center py-4 text-muted">
                <div class="spinner-border text-success" role="status"></div>
                <div>Loading questions, please wait...</div>
            </td>
        </tr>
    `;

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/GetQuizQuestions",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ quizId: quizId }),
        success: function(response) {
    tableBody.innerHTML = '';
    if (response.d && response.d.success) {
        const questions = response.d.data;
        window.currentQuestions = questions; // Store for viewQuestion function
                if (questions.length === 0) {
                    tableBody.innerHTML = `
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                <i class="fas fa-question-circle fa-2x mb-2 d-block"></i>
                                No questions found. Click "Add Question" to create some.
                            </td>
                        </tr>
                    `;
                    return;
                }
                questions.forEach((question, index) => {
                    const typeClass = question.type === 'multiple-choice' ? 'primary' :
                        question.type === 'true-false' ? 'success' :
                        question.type === 'short-answer' ? 'warning' : 'info';

                    const difficultyClass = question.difficulty === 'easy' ? 'success' :
                        question.difficulty === 'medium' ? 'warning' : 'danger';

                    const row = document.createElement('tr');
                    row.innerHTML = `
                        <td><strong>${index + 1}</strong></td>
                        <td>
                            <div class="fw-bold mb-1">${question.text.substring(0, 80)}${question.text.length > 80 ? '...' : ''}</div>
                            <small class="text-muted">${question.explanation ? 'Has explanation' : 'No explanation'}</small>
                        </td>
                        <td><span class="badge bg-${typeClass}">${question.type.replace('-', ' ')}</span></td>
                        <td><span class="badge bg-secondary">${question.points}</span></td>
                        <td><span class="badge bg-${difficultyClass}">${question.difficulty}</span></td>
                        <td>
                            <button type="button" class="btn btn-sm-custom btn-outline-primary" onclick="viewQuestion(${question.id})" title="View">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button type="button" class="btn btn-sm-custom btn-outline-warning" onclick="editQuestion(${question.id})" title="Edit">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm-custom btn-outline-danger" onclick="deleteQuestion(${question.id}, ${index + 1})" title="Delete">
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
                            Failed to load questions.
                        </td>
                    </tr>
                `;
            }
        },
        error: function() {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-4 text-danger">
                        Error loading questions.
                    </td>
                </tr>
            `;
        }
    });
}

function viewQuestion(questionId) {
    // Find the question in the loaded questions array
    const questions = window.currentQuestions || [];
    const question = questions.find(q => q.id === questionId);
    if (!question) {
        showError('Question not found.');
        return;
    }

    // Set question text and type
    document.getElementById('viewQuestionText').textContent = question.text;
    document.getElementById('viewQuestionType').textContent = question.type.replace('-', ' ').replace(/\b\w/g, l => l.toUpperCase());

    // Set points and difficulty
    document.getElementById('viewQuestionPoints').textContent = question.points;
    document.getElementById('viewQuestionDifficulty').textContent = question.difficulty.charAt(0).toUpperCase() + question.difficulty.slice(1);

    // Set question number (optional, you can pass index+1 if needed)
    const index = questions.findIndex(q => q.id === questionId);
    document.getElementById('viewQuestionNumber').textContent = index >= 0 ? (index + 1) : '';

    // Set options (for multiple-choice)
    const optionsDiv = document.getElementById('viewQuestionOptions');
    optionsDiv.innerHTML = '';
    if (question.options) {
        let optionsObj;
        try {
            optionsObj = typeof question.options === 'string' ? JSON.parse(question.options) : question.options;
        } catch {
            optionsObj = {};
        }
        if (Object.keys(optionsObj).length > 0) {
            for (const [key, value] of Object.entries(optionsObj)) {
                const opt = document.createElement('div');
                opt.innerHTML = `<strong>${key}:</strong> ${value}`;
                optionsDiv.appendChild(opt);
            }
        }
    }

    // Show explanation if present
    if (question.explanation) {
        document.getElementById('viewQuestionExplanation').style.display = 'block';
        document.getElementById('explanationText').textContent = question.explanation;
    } else {
        document.getElementById('viewQuestionExplanation').style.display = 'none';
        document.getElementById('explanationText').textContent = '';
    }

    // Show the modal
    new bootstrap.Modal(document.getElementById('viewQuestionModal')).show();
}

        function toggleAnswerFields() {
    const questionType = document.getElementById('questionType').value;
    const mcOptions = document.getElementById('multipleChoiceOptions');
    const tfOptions = document.getElementById('trueFalseOptions');
    const textOptions = document.getElementById('textAnswerOptions');

    // Hide all and remove required
    mcOptions.style.display = 'none';
    tfOptions.style.display = 'none';
    textOptions.style.display = 'none';

    document.querySelectorAll('input[name="correctAnswer"]').forEach(el => el.required = false);
    document.getElementById('optionA').required = false;
    document.getElementById('optionB').required = false;
    document.getElementById('optionC').required = false;
    document.getElementById('optionD').required = false;
    document.getElementById('correctAnswer').required = false;
    document.getElementById('tfTrue').required = false;
    document.getElementById('tfFalse').required = false;

    // Show relevant and set required
    if (questionType === 'multiple-choice') {
        mcOptions.style.display = 'block';
        document.querySelectorAll('input[name="correctAnswer"]').forEach(el => el.required = true);
        document.getElementById('optionA').required = true;
        document.getElementById('optionB').required = true;
        document.getElementById('optionC').required = true;
        document.getElementById('optionD').required = true;
    } else if (questionType === 'true-false') {
        tfOptions.style.display = 'block';
        document.getElementById('tfTrue').required = true;
        document.getElementById('tfFalse').required = true;
    } else {
        textOptions.style.display = 'block';
        document.getElementById('correctAnswer').required = false; // Optional for short/essay
    }
}

      function toggleEditAnswerFields() {
    const questionType = document.getElementById('editQuestionType').value;
    const mcOptions = document.getElementById('editMultipleChoiceOptions');
    const tfOptions = document.getElementById('editTrueFalseOptions');
    const textOptions = document.getElementById('editTextAnswerOptions');

    // Hide all and remove required
    mcOptions && (mcOptions.style.display = 'none');
    tfOptions && (tfOptions.style.display = 'none');
    textOptions && (textOptions.style.display = 'none');

    document.querySelectorAll('input[name="editCorrectAnswer"]').forEach(el => el.required = false);
    document.getElementById('editOptionA').required = false;
    document.getElementById('editOptionB').required = false;
    document.getElementById('editOptionC').required = false;
    document.getElementById('editOptionD').required = false;

    // If you have true/false or text answer fields, also set their required to false here:
    if (tfOptions) {
        tfOptions.querySelectorAll('input[type="radio"]').forEach(el => el.required = false);
    }
    if (textOptions) {
        const textField = textOptions.querySelector('textarea, input');
        if (textField) textField.required = false;
    }

    // Show relevant and set required
    if (questionType === 'multiple-choice') {
        mcOptions && (mcOptions.style.display = 'block');
        document.querySelectorAll('input[name="editCorrectAnswer"]').forEach(el => el.required = true);
        document.getElementById('editOptionA').required = true;
        document.getElementById('editOptionB').required = true;
        document.getElementById('editOptionC').required = true;
        document.getElementById('editOptionD').required = true;
    } else if (questionType === 'true-false') {
        if (tfOptions) {
            tfOptions.style.display = 'block';
            tfOptions.querySelectorAll('input[type="radio"]').forEach(el => el.required = true);
        }
    } else {
        if (textOptions) {
            textOptions.style.display = 'block';
            const textField = textOptions.querySelector('textarea, input');
            if (textField) textField.required = false; // Optional for short/essay
        }
    }
}

        function addQuestion() {
    const form = document.getElementById('addQuestionForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    // Collect form data
    const quizId = currentQuiz.id;
    const text = document.getElementById('questionText').value;
    const type = document.getElementById('questionType').value;
    const points = parseInt(document.getElementById('questionPoints').value);
    const difficulty = document.getElementById('questionDifficulty').value;
    const explanation = document.getElementById('questionExplanation').value;

    let options = {};
    let correctAnswer = "";

    if (type === 'multiple-choice') {
        options = {
            A: document.getElementById('optionA').value,
            B: document.getElementById('optionB').value,
            C: document.getElementById('optionC').value,
            D: document.getElementById('optionD').value
        };
        correctAnswer = document.querySelector('input[name="correctAnswer"]:checked').value;
    } else if (type === 'true-false') {
        correctAnswer = document.querySelector('input[name="tfAnswer"]:checked').value;
    } else {
        correctAnswer = document.getElementById('correctAnswer').value;
    }

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/AddQuizQuestion",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            quizId: quizId,
            text: text,
            type: type,
            points: points,
            difficulty: difficulty,
            explanation: explanation,
            optionsJson: JSON.stringify(options),
            correctAnswer: correctAnswer
        }),
        success: function(response) {
            if (response.d && response.d.success) {
                showSuccess('Question added successfully!');
                bootstrap.Modal.getInstance(document.getElementById('addQuestionModal')).hide();
                form.reset();
                loadQuestions(currentQuiz.id);
            } else {
                showError('Failed to add question: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            showError('Error adding question: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

        function editQuestion(questionId) {
    // Use the questions loaded from the database
    const questions = window.currentQuestions || [];
    const question = questions.find(q => q.id === questionId);

    if (question) {
        document.getElementById('editQuestionId').value = question.id;
        document.getElementById('editQuestionText').value = question.text;
        document.getElementById('editQuestionType').value = question.type;
        document.getElementById('editQuestionPoints').value = question.points;
        document.getElementById('editQuestionDifficulty').value = question.difficulty;
        document.getElementById('editQuestionExplanation').value = question.explanation || '';

        // Handle multiple choice options
        if (question.type === 'multiple-choice') {
            let optionsObj = {};
            try {
                optionsObj = typeof question.options === 'string' ? JSON.parse(question.options) : question.options;
            } catch {
                optionsObj = {};
            }
            document.getElementById('editOptionA').value = optionsObj.A || '';
            document.getElementById('editOptionB').value = optionsObj.B || '';
            document.getElementById('editOptionC').value = optionsObj.C || '';
            document.getElementById('editOptionD').value = optionsObj.D || '';
            if (question.correctAnswer) {
                const radio = document.querySelector(`input[name="editCorrectAnswer"][value="${question.correctAnswer}"]`);
                if (radio) radio.checked = true;
            }
        }
        toggleEditAnswerFields();
        new bootstrap.Modal(document.getElementById('editQuestionModal')).show();
    }
    if (question.type === 'true-false') {
    if (question.correctAnswer === "true") {
        document.getElementById('editTfTrue').checked = true;
    } else if (question.correctAnswer === "false") {
        document.getElementById('editTfFalse').checked = true;
    }
}
}

        function editQuestionFromView() {
            bootstrap.Modal.getInstance(document.getElementById('viewQuestionModal')).hide();
            setTimeout(() => {
                editQuestion(window.currentViewQuestionId);
            }, 300);
        }

       function updateQuestion() {
    const form = document.getElementById('editQuestionForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    const questionId = parseInt(document.getElementById('editQuestionId').value);
    const text = document.getElementById('editQuestionText').value;
    const type = document.getElementById('editQuestionType').value;
    const points = parseInt(document.getElementById('editQuestionPoints').value);
    const difficulty = document.getElementById('editQuestionDifficulty').value;
    const explanation = document.getElementById('editQuestionExplanation').value;

    let options = {};
    let correctAnswer = "";

    if (type === 'multiple-choice') {
        options = {
            A: document.getElementById('editOptionA').value,
            B: document.getElementById('editOptionB').value,
            C: document.getElementById('editOptionC').value,
            D: document.getElementById('editOptionD').value
        };
        const checked = document.querySelector('input[name="editCorrectAnswer"]:checked');
        correctAnswer = checked ? checked.value : '';
    } else if (type === 'true-false') {
        const checked = document.querySelector('input[name="editTfAnswer"]:checked');
        correctAnswer = checked ? checked.value : '';
    } else {
        correctAnswer = ''; // or get from a sample answer field if you have one
    }

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/UpdateQuizQuestion",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            questionId: questionId,
            text: text,
            type: type,
            points: points,
            difficulty: difficulty,
            explanation: explanation,
            optionsJson: JSON.stringify(options),
            correctAnswer: correctAnswer
        }),
        success: function(response) {
            if (response.d && response.d.success) {
                showSuccess('Question updated successfully!');
                bootstrap.Modal.getInstance(document.getElementById('editQuestionModal')).hide();
                loadQuestions(currentQuiz.id);
            } else {
                showError('Failed to update question: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            showError('Error updating question: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

        function deleteQuestion(questionId, questionNumber) {
            document.getElementById('deleteQuestionId').value = questionId;
            document.getElementById('deleteQuestionNumber').textContent = questionNumber;
            new bootstrap.Modal(document.getElementById('deleteQuestionModal')).show();
        }

        function confirmDeleteQuestion() {
    const questionId = parseInt(document.getElementById('deleteQuestionId').value);

    $.ajax({
        type: "POST",
        url: "Quiz.aspx/DeleteQuizQuestion",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ questionId: questionId }),
        success: function(response) {
            bootstrap.Modal.getInstance(document.getElementById('deleteQuestionModal')).hide();
            if (response.d && response.d.success) {
                showSuccess('Question deleted successfully!');
                loadQuestions(currentQuiz.id);
            } else {
                showError('Failed to delete question: ' + (response.d.message || 'Unknown error'));
            }
        },
        error: function(xhr) {
            bootstrap.Modal.getInstance(document.getElementById('deleteQuestionModal')).hide();
            showError('Error deleting question: ' + (xhr.responseText || 'Unknown error'));
        }
    });
}

       function previewQuiz() {
    // Use questions loaded from the DB
    const questions = window.currentQuestions || [];
    if (questions.length === 0) {
        showError('No questions found. Please add some questions first.');
        return;
    }

    const totalPoints = questions.reduce((sum, q) => sum + (q.points || 0), 0);
    const previewMessage = `Quiz Preview\n\n\rTitle: ${currentQuiz.title}\n\n\rQuestions: ${questions.length}\n\n\rTotal Points: ${totalPoints}\n\n\rDuration: ${currentQuiz.duration} minutes\n\n\rThis would open a preview of the quiz for students.`;

    showSuccess(previewMessage);
}

        function viewQuizSubmissions() {
            // Navigate to the Quiz Submissions page
            window.location.href = 'QuizSubmissions.aspx';
        }
    </script>

</asp:Content>
