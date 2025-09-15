<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="QuizSubmissions.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.QuizSubmissions" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

     <title>Quiz Submissions - Learning Management System</title>

     <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        
        .submissions-container {
            padding: 20px;
            max-width: 1600px;
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
        
        .page-header h1 {
            margin-bottom: 10px;
        }
        
        .page-header p {
            margin-bottom: 0;
            opacity: 0.9;
        }
        
        /* Filter Section */
        .filter-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .filter-section h5 {
            color: #007bff;
            margin-bottom: 20px;
        }
        
        /* Statistics Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-card .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-card.total-submissions .stat-number { color: #007bff; }
        .stat-card.completed-submissions .stat-number { color: #28a745; }
        .stat-card.average-score .stat-number { color: #ffc107; }
        .stat-card.highest-score .stat-number { color: #dc3545; }
        
        /* Submissions Table */
        .submissions-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .table-header {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .table-responsive {
            border-radius: 0 0 15px 15px;
        }
        
        .table thead th {
            background: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #2c3e50;
            padding: 15px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .table tbody td {
            padding: 15px;
            vertical-align: middle;
            border-top: 1px solid #f1f3f4;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        /* Score Display */
        .score-display {
            font-size: 1.1rem;
            font-weight: bold;
        }
        
        .score-excellent { color: #28a745; }
        .score-good { color: #17a2b8; }
        .score-average { color: #ffc107; }
        .score-poor { color: #dc3545; }
        
        /* Status Badges */
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        
        .status-in-progress {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-not-started {
            background: #f8d7da;
            color: #721c24;
        }
        
        /* Action Buttons */
        .btn-action {
            padding: 8px 12px;
            border-radius: 8px;
            border: none;
            font-size: 0.8rem;
            font-weight: 500;
            margin: 0 2px;
            transition: all 0.2s ease;
        }
        
        .btn-view {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .btn-view:hover {
            background: #bbdefb;
            color: #0d47a1;
        }
        
        .btn-details {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .btn-details:hover {
            background: #e1bee7;
            color: #4a148c;
        }
        
        /* Ensure the success modal is above the backdrop */
#successModal {
    z-index: 1060 !important;
}
.modal-backdrop {
    z-index: 1050 !important;
}
        .btn-export {
            background: #e8f5e8;
            color: #2e7d32;
        }
        
        .btn-export:hover {
            background: #c8e6c9;
            color: #1b5e20;
        }
        
        /* Modal Enhancements */
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        
        .modal-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px 30px;
        }
        
        .modal-header .modal-title {
            font-weight: 600;
        }
        
        .btn-close-white {
            filter: brightness(0) invert(1);
        }
        
        /* Submission Details */
        .submission-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .submission-info .row > div {
            margin-bottom: 10px;
        }
        
        .submission-info .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .submission-info .info-value {
            color: #212529;
        }
        
        /* Question Answer Display */
        .question-container {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .question-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .question-content {
            padding: 20px;
        }
        
        .question-text {
            font-weight: 600;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        
        .answer-options {
            margin-bottom: 15px;
        }
        
        .answer-option {
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 5px;
            border: 1px solid #e9ecef;
        }
        
        .answer-correct {
            background: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        
        .answer-selected {
            background: #cce5ff;
            border-color: #99d6ff;
            color: #004085;
        }
        
        .answer-incorrect {
            background: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }
        
        .answer-neutral {
            background: #ffffff;
        }
        
        /* Progress Bars */
        .progress-container {
            margin: 15px 0;
        }
        
        .progress {
            height: 8px;
            border-radius: 10px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .submissions-container {
                padding: 10px;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .table-responsive {
                font-size: 0.9rem;
            }
        }
        
        /* Loading Animation */
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 40px;
        }
        
        .spinner-border {
            width: 3rem;
            height: 3rem;
            animation: spinner-border 0.75s linear infinite;
        }
        
        @keyframes spinner-border {
        100% {
                transform: rotate(360deg);
            }
        }
        /* Export Options */
        .export-options {
            display: none;
            background: #e8f5e8;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        /* Print Styles */
        @media print {
            .no-print {
                display: none !important;
            }
            
            .submissions-container {
                padding: 0;
            }
            
            .submissions-table {
                box-shadow: none;
            }
        }
    </style>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="submissions-container">
        <!-- Navigation Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb bg-white p-3 rounded shadow-sm">
                <li class="breadcrumb-item"><a href="AdminMaster.aspx" class="text-decoration-none">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="Quiz.aspx" class="text-decoration-none">Quiz Management</a></li>
                <li class="breadcrumb-item active">Quiz Submissions</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="page-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1 class="mb-2">
                        <i class="fas fa-clipboard-list me-3"></i>
                        Quiz Submissions
                    </h1>
                    <p class="mb-0">View and analyze student quiz submissions and performance</p>
                </div>
                <div class="no-print">
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-outline-light" onclick="refreshData()">
                            <i class="fas fa-sync me-2"></i>Refresh
                        </button>
                        <button type="button" class="btn btn-light" onclick="exportSubmissions()">
                            <i class="fas fa-download me-2"></i>Export Data
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <div class="stats-container">
            <div class="stat-card total-submissions">
                <div class="stat-number" id="totalSubmissions">0</div>
                <div class="stat-label">Total Submissions</div>
            </div>
            <div class="stat-card completed-submissions">
                <div class="stat-number" id="completedSubmissions">0</div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-card average-score">
                <div class="stat-number" id="averageScore">0.0%</div>
                <div class="stat-label">Average Score</div>
            </div>
            <div class="stat-card highest-score">
                <div class="stat-number" id="highestScore">0%</div>
                <div class="stat-label">Highest Score</div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <h5><i class="fas fa-filter me-2"></i>Filter Submissions</h5>
            <form id="filterForm">
                <div class="row">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <label for="courseFilter" class="form-label">Course</label>
                        <select class="form-select" id="courseFilter">
    <option value="">All Courses</option>
</select>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <label for="quizFilter" class="form-label">Quiz</label>
                       <select class="form-select" id="quizFilter">
    <option value="">All Quizzes</option>
</select>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <label for="statusFilter" class="form-label">Status</label>
                        <select class="form-select" id="statusFilter">
                            <option value="">All Status</option>
                            <option value="completed">Completed</option>
                            <option value="in-progress">In Progress</option>
                            <option value="not-started">Not Started</option>
                        </select>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <label for="scoreFilter" class="form-label">Score Range</label>
                        <select class="form-select" id="scoreFilter">
                            <option value="">All Scores</option>
                            <option value="90-100">90-100% (Excellent)</option>
                            <option value="80-89">80-89% (Good)</option>
                            <option value="70-79">70-79% (Average)</option>
                            <option value="0-69">Below 70% (Needs Improvement)</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="studentSearch" class="form-label">Search Student</label>
                        <input type="text" class="form-control" id="studentSearch" placeholder="Enter student name or ID...">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="dateFrom" class="form-label">From Date</label>
                        <input type="date" class="form-control" id="dateFrom">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="dateTo" class="form-label">To Date</label>
                        <input type="date" class="form-control" id="dateTo">
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 text-end">
                        <button type="button" class="btn btn-outline-secondary me-2" onclick="clearFilters()">
                            <i class="fas fa-times me-2"></i>Clear Filters
                        </button>
                        <button type="button" class="btn btn-primary" onclick="applyFilters()">
                            <i class="fas fa-search me-2"></i>Apply Filters
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Submissions Table -->
        <div class="submissions-table">
            <div class="table-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">
                        <i class="fas fa-list me-2"></i>
                        Quiz Submissions
                    </h5>
                    <div class="d-flex align-items-center">
                        <span class="text-muted me-3">Showing <span id="showingCount">10</span> of <span id="totalCount">10</span> submissions</span>
                        <div class="dropdown">
                            <button type="button" class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-sort me-1"></i>Sort By
                            </button>
                           <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" id="sort-date" onclick="sortSubmissions('date')">Submission Date <span></span></a></li>
                                <li><a class="dropdown-item" href="#" id="sort-score" onclick="sortSubmissions('score')">Score <span></span></a></li>
                                <li><a class="dropdown-item" href="#" id="sort-student" onclick="sortSubmissions('student')">Student Name <span></span></a></li>
                                <li><a class="dropdown-item" href="#" id="sort-quiz" onclick="sortSubmissions('quiz')">Quiz Title <span></span></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div class="mt-3">Loading submissions...</div>
                </div>
            
            <div class="table-responsive" id="submissionsTableContainer" style="display:none;">
                <table class="table table-hover mb-0" id="submissionsTable">
                    <thead>
                        <tr>
                            <th>Student</th>
                            <th>Quiz</th>
                            <th>Course</th>
                            <th>Score</th>
                            <th>Status</th>
                            <th>Submitted</th>
                            <th>Duration</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="submissionsTableBody">
                        <!-- Submissions will be loaded here -->
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <div class="d-flex justify-content-between align-items-center p-3 border-top">
                <div class="text-muted">
                    Page <span id="currentPage">1</span> of <span id="totalPages">5</span>
                </div>
                <nav>
                    <ul class="pagination mb-0">
                        <li class="page-item disabled" id="prevPage">
                            <a class="page-link" href="#" onclick="changePage(-1)">Previous</a>
                        </li>
                        <li class="page-item active">
                            <a class="page-link" href="#">1</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">2</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">3</a>
                        </li>
                        <li class="page-item" id="nextPage">
                            <a class="page-link" href="#" onclick="changePage(1)">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    

    

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Sample submission data - expanded with more realistic data
        let submissions = [];
let currentSubmissions = [];
let currentPage = 1;
const itemsPerPage = 10;

    const body = document.getElementsByTagName('body')[0];
    body.innerHTML += `
            

            <!-- View Submission Modal -->
    <div class="modal fade" id="viewSubmissionModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>
                        Quiz Submission Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- Submission Info -->
                    <div class="submission-info">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-sm-4 info-label">Student:</div>
                                    <div class="col-sm-8 info-value" id="modalStudentName">John Doe</div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-4 info-label">Student ID:</div>
                                    <div class="col-sm-8 info-value" id="modalStudentId">STU001</div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-4 info-label">Quiz:</div>
                                    <div class="col-sm-8 info-value" id="modalQuizTitle">Programming Basics Quiz</div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-4 info-label">Course:</div>
                                    <div class="col-sm-8 info-value" id="modalCourse">CS101</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-sm-4 info-label">Score:</div>
                                    <div class="col-sm-8 info-value">
                                        <span id="modalScore" class="score-display score-excellent">85%</span>
                                        <small class="text-muted">(<span id="modalPoints">17/20</span> points)</small>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-4 info-label">Status:</div>
                                    <div class="col-sm-8 info-value">
                                        <span id="modalStatus" class="status-badge status-completed">Completed</span>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-4 info-label">Submitted:</div>
                                    <div class="col-sm-8 info-value" id="modalSubmitted">2025-08-06 14:30</div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-4 info-label">Duration:</div>
                                    <div class="col-sm-8 info-value" id="modalDuration">15 minutes</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Progress Summary -->
                    <div class="progress-container">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Quiz Progress</span>
                            <span id="progressText">17/20 questions correct</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-success" role="progressbar" id="progressBar" style="width: 85%"></div>
                        </div>
                    </div>

                    <!-- Questions and Answers -->
                    <div id="questionsContainer">
                        <!-- Questions will be loaded here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="exportSubmission()">
                        <i class="fas fa-download me-2"></i>Export PDF
                    </button>
                    <button type="button" class="btn btn-warning" id="manualGradeBtn">
    <i class="fas fa-star me-2"></i>Manual Grade
</button>
                </div>
            </div>
        </div>
    </div>

<!-- Export Options Modal -->
    <div class="modal fade" id="exportModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-download me-2"></i>
                        Export Submissions
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>Export Format</h6>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="exportFormat" id="exportExcel" value="excel" checked>
                            <label class="form-check-label" for="exportExcel">
                                <i class="fas fa-file-excel text-success me-2"></i>Excel (.xlsx)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="exportFormat" id="exportCSV" value="csv">
                            <label class="form-check-label" for="exportCSV">
                                <i class="fas fa-file-csv text-info me-2"></i>CSV (.csv)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="exportFormat" id="exportPDF" value="pdf">
                            <label class="form-check-label" for="exportPDF">
                                <i class="fas fa-file-pdf text-danger me-2"></i>PDF Report
                            </label>
                        </div>
                    </div>
                    
                    <h6>Export Options</h6>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="includeAnswers" checked>
                        <label class="form-check-label" for="includeAnswers">
                            Include detailed answers
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="includeStatistics" checked>
                        <label class="form-check-label" for="includeStatistics">
                            Include statistics summary
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="onlyFiltered">
                        <label class="form-check-label" for="onlyFiltered">
                            Export only filtered results
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-success" onclick="performExport()">
                        <i class="fas fa-download me-2"></i>Export
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Grade Submission Modal -->
    <div class="modal fade" id="gradeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-star me-2"></i>
                        Manual Grading
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Manual grading allows you to override the automatic score for subjective questions.
                    </div>
                    
                    <div class="mb-3">
                        <label for="manualScore" class="form-label">Override Score</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="manualScore" min="0" max="100" placeholder="85">
                            <span class="input-group-text">%</span>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="gradeComments" class="form-label">Grading Comments</label>
                        <textarea class="form-control" id="gradeComments" rows="4" placeholder="Add comments about the grading..."></textarea>
                    </div>
                    
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="notifyStudent" checked>
                        <label class="form-check-label" for="notifyStudent">
                            Notify student about grade change
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-warning" onclick="saveManualGrade()">
                        <i class="fas fa-save me-2"></i>Save Grade
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
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <i class="fas fa-check-circle text-success fa-3x mb-3"></i>
                <h5 id="successMessage">Operation completed successfully!</h5>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-bs-dismiss="modal">OK</button>
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
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <i class="fas fa-exclamation-triangle text-danger fa-3x mb-3"></i>
                <h5 id="errorMessage">An error occurred!</h5>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-bs-dismiss="modal">OK</button>
            </div>
        </div>
    </div>
</div>

<!-- Info Notification Modal -->
<div class="modal fade" id="infoModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">
                    <i class="fas fa-info-circle me-2"></i>
                    Analytics Information
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <i class="fas fa-chart-bar text-info fa-3x mb-3"></i>
                    <div id="infoMessage" style="white-space: pre-line;">Information will appear here...</div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-info" data-bs-dismiss="modal">OK</button>
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
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <i class="fas fa-question-circle text-warning fa-3x mb-3"></i>
                <h5 id="confirmMessage">Are you sure you want to continue?</h5>
                <p class="text-muted" id="confirmDetails"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-warning" onclick="executeConfirmAction()">
                    <i class="fas fa-check me-2"></i>Yes, Continue
                </button>
            </div>
        </div>
    </div>
</div>

`;



document.addEventListener('DOMContentLoaded', function() {
     document.getElementById('loadingSpinner').style.display = 'block';
    document.getElementById('submissionsTableContainer').style.display = 'none';
    clearFilters();
    fetchSubmissions();
        loadCourses();
    loadQuizzes();
    updateSortIndicators();
});


function fetchSubmissions() {
    // Show spinner, hide table
    document.getElementById('loadingSpinner').style.display = 'block';
    document.getElementById('submissionsTableContainer').style.display = 'none';

    fetch('QuizSubmissions.aspx/GetQuizSubmissions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: '{}'
    })
    .then(response => response.json())
    .then(result => {
        document.getElementById('loadingSpinner').style.display = 'none';
        document.getElementById('submissionsTableContainer').style.display = 'block';
        if (result.d && result.d.success) {
            submissions = result.d.data;
            currentSubmissions = [...submissions];
            loadSubmissions();
            updateStatistics();
        } else {
            showError(result.d && result.d.message ? result.d.message : 'Failed to load submissions.');
        }
    })
    .catch((err) => {
        document.getElementById('loadingSpinner').style.display = 'none';
        document.getElementById('submissionsTableContainer').style.display = 'block';
        showError('Failed to load submissions.\n' + err);
    });
}

        // Load submissions into the table
       function loadSubmissions() {
    const tableBody = document.getElementById('submissionsTableBody');
    tableBody.innerHTML = '';

    const start = (currentPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageSubmissions = currentSubmissions.slice(start, end);

    if (pageSubmissions.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center py-4 text-muted">
                    <i class="fas fa-clipboard-list fa-2x mb-2 d-block"></i>
                    No submissions found matching your criteria.
                </td>
            </tr>
        `;
        return;
    }

    pageSubmissions.forEach(submission => {
        const row = document.createElement('tr');
        
        const scoreClass = getScoreClass(submission.percentage);
        const statusClass = `status-${submission.status}`;
        
        row.innerHTML = `
            <td>
                <div>
                    <div class="fw-bold">${submission.student.name}</div>
                    <small class="text-muted">${submission.student.id}</small>
                </div>
            </td>
            <td>
                <div class="fw-bold">${submission.quiz.title}</div>
                <small class="text-muted">${submission.quiz.questions} questions</small>
            </td>
            <td>
                <span class="badge bg-primary">${submission.quiz.course}</span>
            </td>
            <td>
                <div class="score-display ${scoreClass}">
                    ${submission.percentage}%
                </div>
                <small class="text-muted">${submission.score}/${submission.quiz.maxScore} pts</small>
            </td>
            <td>
                <div class="d-flex flex-column gap-1">
                    <span class="status-badge ${statusClass}">
                        ${submission.status.replace('-', ' ')}
                    </span>
                    <small class="text-muted">
                        Attempt ${submission.attempt}/${submission.maxAttempts}
                    </small>
                </div>
            </td>
            <td>
                <div>${submission.submittedAt ? formatDate(submission.submittedAt) : 'Not submitted'}</div>
                <small class="text-muted">${submission.submittedAt ? formatTime(submission.submittedAt) : ''}</small>
            </td>
            <td>
                <span class="badge bg-info">${submission.duration}</span>
            </td>
            <td>
                <button type="button" class="btn btn-action btn-view" onclick="viewSubmission(${submission.id})" title="View Details">
                    <i class="fas fa-eye"></i>
                </button>
                <button type="button" class="btn btn-action btn-details" onclick="showAnalytics(${submission.id})" title="Analytics">
                    <i class="fas fa-chart-bar"></i>
                </button>
                <button type="button" class="btn btn-action btn-export" onclick="exportSingleSubmission(${submission.id})" title="Export">
                    <i class="fas fa-download"></i>
                </button>
            </td>
        `;
        
        tableBody.appendChild(row);
    });

    updatePagination();
}

        // Get score class for color coding
        function getScoreClass(percentage) {
            if (percentage >= 90) return 'score-excellent';
            if (percentage >= 80) return 'score-good';
            if (percentage >= 70) return 'score-average';
            return 'score-poor';
        }

        // Format date
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            });
        }

     function changePage(delta) {
    const totalPages = Math.max(1, Math.ceil(currentSubmissions.length / itemsPerPage));
    let newPage = currentPage + delta;
    if (newPage < 1) newPage = 1;
    if (newPage > totalPages) newPage = totalPages;
    if (newPage !== currentPage) {
        currentPage = newPage;
        loadSubmissions();
    }
}
        // Format time
        function formatTime(dateString) {
            const date = new Date(dateString);
            return date.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Update statistics
        function updateStatistics() {
    const total = currentSubmissions.length;
    const completed = currentSubmissions.filter(s => s.status === 'completed').length;
    const totalScore = currentSubmissions.reduce((sum, s) => sum + s.percentage, 0);
    const avgScore = total > 0 ? (totalScore / total).toFixed(1) : 0;
    const maxScore = total > 0 ? Math.max(...currentSubmissions.map(s => s.percentage)) : 0;

    document.getElementById('totalSubmissions').textContent = total;
    document.getElementById('completedSubmissions').textContent = completed;
    document.getElementById('averageScore').textContent = `${avgScore}%`;
    document.getElementById('highestScore').textContent = `${maxScore}%`;
}

        // View submission details
        function viewSubmission(submissionId) {
    const submission = submissions.find(s => s.id === submissionId);
    if (!submission) return;


    // Populate modal with submission data
    document.getElementById('modalStudentName').textContent = submission.student.name;
    document.getElementById('modalStudentId').textContent = submission.student.id;
    document.getElementById('modalQuizTitle').textContent = submission.quiz.title;
    document.getElementById('modalCourse').textContent = submission.quiz.course;
    document.getElementById('modalScore').textContent = `${submission.percentage}%`;
    document.getElementById('modalScore').className = `score-display ${getScoreClass(submission.percentage)}`;
    document.getElementById('modalPoints').textContent = `${submission.score}/${submission.quiz.maxScore}`;
    document.getElementById('modalStatus').textContent = submission.status.replace('-', ' ');
    document.getElementById('modalStatus').className = `status-badge status-${submission.status}`;
    document.getElementById('modalSubmitted').textContent = submission.submittedAt
        ? `${formatDate(submission.submittedAt)} ${formatTime(submission.submittedAt)}`
        : 'Not submitted';
    document.getElementById('modalDuration').textContent = submission.duration;

    // Update progress bar
    const progressPercent = submission.percentage;
    document.getElementById('progressBar').style.width = `${progressPercent}%`;
    document.getElementById('progressText').textContent = `${submission.score}/${submission.quiz.maxScore} points (${progressPercent}%)`;


 // Set the manual grade button's onclick
    document.getElementById('manualGradeBtn').onclick = function() {
        gradeSubmission(submissionId);
    };
    
    // Load questions and answers
    loadQuestionsAndAnswers(submission);

    // Show modal
    new bootstrap.Modal(document.getElementById('viewSubmissionModal')).show();
}

        // Load questions and answers
        function loadQuestionsAndAnswers(submission) {
    const container = document.getElementById('questionsContainer');
    container.innerHTML = '';

    // If no answers available
    if (!submission.answers || submission.answers.length === 0) {
        container.innerHTML = `
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Detailed answers are not available for this submission.
            </div>
        `;
        return;
    }

    submission.answers.forEach((answer, index) => {
        const questionDiv = document.createElement('div');
        questionDiv.className = 'question-container';

        let optionsHTML = '';
        if (answer.type === 'multiple-choice') {
            optionsHTML = answer.options.map(option => {
                let optionClass = 'answer-neutral';
                if (option === answer.correctAnswer && option === answer.selectedAnswer) {
                    optionClass = 'answer-correct'; // Correct and selected
                } else if (option === answer.correctAnswer) {
                    optionClass = 'answer-correct';
                } else if (option === answer.selectedAnswer) {
                    optionClass = answer.isCorrect ? 'answer-selected' : 'answer-incorrect';
                }
                return `
                    <div class="answer-option ${optionClass}">
                        ${option}
                        ${option === answer.correctAnswer ? '<i class="fas fa-check text-success ms-2"></i>' : ''}
                        ${option === answer.selectedAnswer && !answer.isCorrect ? '<i class="fas fa-times text-danger ms-2"></i>' : ''}
                    </div>
                `;
            }).join('');
        } else if (answer.type === 'true-false') {
            optionsHTML = `
                <div class="answer-option ${answer.selectedAnswer === answer.correctAnswer ? 'answer-correct' : 'answer-incorrect'}">
                    Selected: ${answer.selectedAnswer}
                    ${answer.isCorrect ? '<i class="fas fa-check text-success ms-2"></i>' : '<i class="fas fa-times text-danger ms-2"></i>'}
                </div>
                <div class="answer-option answer-correct">
                    Correct: ${answer.correctAnswer}
                </div>
            `;
        } else {
            // For other types, just show the answer
            optionsHTML = `
                <div class="answer-option answer-neutral">
                    Answer: ${answer.selectedAnswer || ''}
                </div>
                <div class="answer-option answer-correct">
                    Correct: ${answer.correctAnswer || ''}
                </div>
            `;
        }

        questionDiv.innerHTML = `
            <div class="question-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h6 class="mb-0">Question ${index + 1}</h6>
                    <div>
                        <span class="badge ${answer.isCorrect ? 'bg-success' : 'bg-danger'}">
                            ${answer.isCorrect ? 'Correct' : 'Incorrect'}
                        </span>
                        <span class="badge bg-secondary ms-2">${answer.points} points</span>
                    </div>
                </div>
            </div>
            <div class="question-content">
                <div class="question-text">${answer.question}</div>
                <div class="answer-options">
                    ${optionsHTML}
                </div>
            </div>
        `;

        container.appendChild(questionDiv);
    });
}

function loadQuizzes(courseCode = "") {
    fetch('QuizSubmissions.aspx/GetQuizzes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ courseCode: courseCode })
    })
    .then(response => response.json())
    .then(result => {
        if (result.d && result.d.success) {
            const select = document.getElementById('quizFilter');
            select.innerHTML = '<option value="">All Quizzes</option>';
            result.d.data.forEach(quiz => {
                const opt = document.createElement('option');
                opt.value = quiz.id;
                opt.textContent = quiz.title;
                select.appendChild(opt);
            });
        }
    });
}

// Call this on page load

function loadCourses() {
    fetch('QuizSubmissions.aspx/GetCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: '{}'
    })
    .then(response => response.json())
    .then(result => {
        if (result.d && result.d.success) {
            const select = document.getElementById('courseFilter');
            // Remove all except the first option
            select.innerHTML = '<option value="">All Courses</option>';
            result.d.data.forEach(course => {
                const opt = document.createElement('option');
                opt.value = course.code;
                opt.textContent = `${course.code} - ${course.name}`;
                select.appendChild(opt);
            });
        }
    });
}

        // Apply filters
        function applyFilters() {
    const courseFilter = document.getElementById('courseFilter').value;
    const quizFilter = document.getElementById('quizFilter').value;
    const statusFilter = document.getElementById('statusFilter').value;
    const scoreFilter = document.getElementById('scoreFilter').value;
    const studentSearch = document.getElementById('studentSearch').value.toLowerCase();
    const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;

    currentSubmissions = submissions.filter(submission => {
        // Course filter
        if (courseFilter && submission.quiz.course !== courseFilter) return false;
        
        // Quiz filter
        if (quizFilter && submission.quiz.id.toString() !== quizFilter) return false;
        
        // Status filter
        if (statusFilter && submission.status !== statusFilter) return false;
        
        // Score filter
        if (scoreFilter) {
            const [min, max] = scoreFilter.split('-').map(Number);
            if (submission.percentage < min || submission.percentage > max) return false;
        }
        
        // Student search
        if (studentSearch && 
            !submission.student.name.toLowerCase().includes(studentSearch) &&
            !submission.student.id.toLowerCase().includes(studentSearch)) return false;
        
        // Date filters
        if (dateFrom) {
            const submissionDate = submission.submittedAt ? new Date(submission.submittedAt).toISOString().split('T')[0] : '';
            if (submissionDate < dateFrom) return false;
        }
        if (dateTo) {
            const submissionDate = submission.submittedAt ? new Date(submission.submittedAt).toISOString().split('T')[0] : '';
            if (submissionDate > dateTo) return false;
        }
        
        return true;
    });

    currentPage = 1;
    loadSubmissions();
    updateStatistics();
}

        // Clear filters
function clearFilters() {
    // Manually clear each filter control
    document.getElementById('courseFilter').value = '';
    document.getElementById('quizFilter').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('scoreFilter').value = '';
    document.getElementById('studentSearch').value = '';
    document.getElementById('dateFrom').value = '';
    document.getElementById('dateTo').value = '';

    currentSubmissions = [...submissions];
    currentPage = 1;
    loadSubmissions();
    updateStatistics();
    // Optional: Scroll to top of the table after clearing filters
    document.getElementById('submissionsTable').scrollIntoView({ behavior: 'smooth' });
}

        // Sort submissions
// Add this variable at the top of your script
let currentSort = { criteria: null, asc: true };

function updateSortIndicators() {
    // Remove all indicators
    ['date', 'score', 'student', 'quiz'].forEach(criteria => {
        const el = document.getElementById('sort-' + criteria);
        if (el) el.querySelector('span').textContent = '';
    });
    // Add indicator to current
    if (currentSort.criteria) {
        const el = document.getElementById('sort-' + currentSort.criteria);
        if (el) el.querySelector('span').textContent = currentSort.asc ? ' ▲' : ' ▼';
    }
}

function sortSubmissions(criteria) {
    if (currentSort.criteria === criteria) {
        currentSort.asc = !currentSort.asc;
    } else {
        currentSort.criteria = criteria;
        currentSort.asc = true;
    }

    currentSubmissions.sort((a, b) => {
        let valA, valB;
        switch (criteria) {
            case 'date':
                valA = a.submittedAt ? new Date(a.submittedAt) : new Date(0);
                valB = b.submittedAt ? new Date(b.submittedAt) : new Date(0);
                break;
            case 'score':
                valA = a.percentage || 0;
                valB = b.percentage || 0;
                break;
            case 'student':
                valA = (a.student.name || '').toLowerCase();
                valB = (b.student.name || '').toLowerCase();
                break;
            case 'quiz':
                valA = (a.quiz.title || '').toLowerCase();
                valB = (b.quiz.title || '').toLowerCase();
                break;
            default:
                valA = '';
                valB = '';
        }
        if (valA < valB) return currentSort.asc ? -1 : 1;
        if (valA > valB) return currentSort.asc ? 1 : -1;
        return 0;
    });

    currentPage = 1;
    loadSubmissions();
    updateSortIndicators();
}

        // Update pagination
        function updatePagination() {
    const totalPages = Math.max(1, Math.ceil(currentSubmissions.length / itemsPerPage));
    const start = (currentPage - 1) * itemsPerPage;
    const end = Math.min(start + itemsPerPage, currentSubmissions.length);

    document.getElementById('currentPage').textContent = currentPage;
    document.getElementById('totalPages').textContent = totalPages;
    document.getElementById('showingCount').textContent = end - start;
    document.getElementById('totalCount').textContent = currentSubmissions.length;

    // Update previous/next button state
    document.getElementById('prevPage').classList.toggle('disabled', currentPage === 1);
    document.getElementById('nextPage').classList.toggle('disabled', currentPage === totalPages);

    // Dynamically generate page number links
    const paginationList = document.querySelector('.pagination');
    if (!paginationList) return;

    // Remove all page number items except prev/next
    while (paginationList.children.length > 2) {
        paginationList.removeChild(paginationList.children[1]);
    }

    // Insert page number items
    for (let i = 1; i <= totalPages; i++) {
        const li = document.createElement('li');
        li.className = 'page-item' + (i === currentPage ? ' active' : '');
        const a = document.createElement('a');
        a.className = 'page-link';
        a.href = '#';
        a.textContent = i;
        a.onclick = function(e) {
            e.preventDefault();
            if (currentPage !== i) {
                currentPage = i;
                loadSubmissions();
            }
        };
        li.appendChild(a);
        // Insert before the "next" button
        paginationList.insertBefore(li, paginationList.children[paginationList.children.length - 1]);
    }
}

        // Export submissions
       function exportSubmissions() {
    new bootstrap.Modal(document.getElementById('exportModal')).show();
}

        // Perform export
        function performExport() {
    const format = document.querySelector('input[name="exportFormat"]:checked').value;
    const includeAnswers = document.getElementById('includeAnswers').checked;
    const includeStatistics = document.getElementById('includeStatistics').checked;
    const onlyFiltered = document.getElementById('onlyFiltered').checked;

    // Choose which data to export
    const dataToExport = onlyFiltered ? currentSubmissions : submissions;

    if (format === 'excel' || format === 'csv') {
        // Build header
      let headers = [
    'Student Name', 'Student ID', 'Student Email', 'Quiz Title', 'Course', 'Score (%)', 'Points', 'Status', 'Submitted', 'Duration'
];
if (includeAnswers) headers.push('Answers');
if (includeStatistics) headers.push('Average Score', 'Highest Score');

let rows = dataToExport.map(sub => {
    let row = [
        sub.student.name,
        sub.student.id,
        sub.student.email, // <-- Add this if you want email
        sub.quiz.title,
        sub.quiz.course,
        sub.percentage,
        `${sub.score}/${sub.quiz.maxScore}`,
        sub.status,
        sub.submittedAt ? `${formatDate(sub.submittedAt)} ${formatTime(sub.submittedAt)}` : '',
        sub.duration
    ];
    if (includeAnswers) {
        if (sub.answers && sub.answers.length > 0) {
            row.push(sub.answers.map(a =>
                `Q: ${a.question}\nYour Answer: ${a.selectedAnswer}\nCorrect: ${a.correctAnswer}\nPoints: ${a.points}\n`
            ).join('\n---\n'));
        } else {
            row.push('N/A');
        }
    }
    if (includeStatistics) {
        row.push(
            `${(dataToExport.reduce((sum, s) => sum + s.percentage, 0) / dataToExport.length).toFixed(1)}%`,
            `${Math.max(...dataToExport.map(s => s.percentage))}%`
        );
    }
    return row;
});

        // Export as CSV
        if (format === 'csv') {
            let csvContent = '';
            csvContent += headers.join(',') + '\n';
            rows.forEach(row => {
                csvContent += row.map(val => `"${(val || '').toString().replace(/"/g, '""')}"`).join(',') + '\n';
            });
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'quiz_submissions.csv';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }
        // Export as Excel (simple XLSX via SheetJS if available)
        else if (format === 'excel' && window.XLSX) {
            const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, "Submissions");
            XLSX.writeFile(wb, "quiz_submissions.xlsx");
        } else if (format === 'excel') {
            showError('Excel export requires SheetJS (XLSX) library loaded.');
            return;
        }

        showSuccess(`Exported ${dataToExport.length} submissions as ${format.toUpperCase()}.`);
    }
    // Simulate PDF export
    else if (format === 'pdf') {
         // Use jsPDF to export the submissions table as PDF
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();

    // Title
    doc.setFontSize(16);
    doc.text("Quiz Submissions", 10, 15);

    // Table headers
    let headers = [
        "Student Name", "Student ID", "Quiz Title", "Course", "Score (%)", "Points", "Status", "Submitted", "Duration"
    ];
    let rows = dataToExport.map(sub => [
        sub.student.name,
        sub.student.id,
        sub.quiz.title,
        sub.quiz.course,
        sub.percentage,
        `${sub.score}/${sub.quiz.maxScore}`,
        sub.status,
        sub.submittedAt ? `${formatDate(sub.submittedAt)} ${formatTime(sub.submittedAt)}` : '',
        sub.duration
    ]);

    // Simple table rendering
    let startY = 25;
    doc.setFontSize(10);
    // Headers
    headers.forEach((header, i) => {
        doc.text(header, 10 + i * 25, startY);
    });
    // Rows
    rows.forEach((row, rowIndex) => {
        row.forEach((cell, colIndex) => {
            doc.text(String(cell), 10 + colIndex * 25, startY + 7 + rowIndex * 7);
        });
    });

    doc.save("quiz_submissions.pdf");
    showSuccess(`Exported ${dataToExport.length} submissions as PDF.`);

    }

    bootstrap.Modal.getInstance(document.getElementById('exportModal')).hide();
}

        // Export single submission
        function exportSingleSubmission(submissionId) {
    const submission = submissions.find(s => s.id === submissionId);
    if (!submission) {
        showError('Submission not found.');
        return;
    }

    // Choose export format (default to Excel, or prompt user if you want)
    const format = 'excel'; // or 'csv'

    // Build header and row
    let headers = [
        'Student Name', 'Student ID', 'Quiz Title', 'Course', 'Score (%)', 'Points', 'Status', 'Submitted', 'Duration', 'Answers'
    ];

    let row = [
        submission.student.name,
        submission.student.id,
        submission.quiz.title,
        submission.quiz.course,
        submission.percentage,
        `${submission.score}/${submission.quiz.maxScore}`,
        submission.status,
        submission.submittedAt ? `${formatDate(submission.submittedAt)} ${formatTime(submission.submittedAt)}` : '',
        submission.duration
    ];

    // Answers as a string
    if (submission.answers && submission.answers.length > 0) {
        row.push(submission.answers.map(a =>
            `Q: ${a.question}\nYour Answer: ${a.selectedAnswer}\nCorrect: ${a.correctAnswer}\nPoints: ${a.points}\n`
        ).join('\n---\n'));
    } else {
        row.push('N/A');
    }

    // Export as Excel (SheetJS)
    if (format === 'excel' && window.XLSX) {
        const ws = XLSX.utils.aoa_to_sheet([headers, row]);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Submission");
        XLSX.writeFile(wb, `submission_${submission.student.id}_${submission.quiz.title.replace(/\s+/g, '_')}.xlsx`);
        showSuccess(`Exported submission for ${submission.student.name} as Excel.`);
    }
    // Export as CSV
    else if (format === 'csv') {
        let csvContent = '';
        csvContent += headers.join(',') + '\n';
        csvContent += row.map(val => `"${(val || '').toString().replace(/"/g, '""')}"`).join(',') + '\n';
        const blob = new Blob([csvContent], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `submission_${submission.student.id}_${submission.quiz.title.replace(/\s+/g, '_')}.csv`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        showSuccess(`Exported submission for ${submission.student.name} as CSV.`);
    } else {
        showError('Excel export requires SheetJS (XLSX) library loaded.');
    }
}

        // Show analytics
       function showAnalytics(submissionId) {
    const submission = submissions.find(s => s.id === submissionId);
    if (!submission) {
        showError('Submission not found.');
        return;
    }

    let analytics = `Analytics for ${submission.student.name}'s submission:\n\n`;
    analytics += `Quiz: ${submission.quiz.title}\n`;
    analytics += `Course: ${submission.quiz.course}\n`;
    analytics += `Score: ${submission.percentage}% (${submission.score}/${submission.quiz.maxScore} pts)\n`;
    analytics += `Status: ${submission.status.replace('-', ' ')}\n`;
    analytics += `Submitted: ${submission.submittedAt ? formatDate(submission.submittedAt) + ' ' + formatTime(submission.submittedAt) : 'Not submitted'}\n`;
    analytics += `Duration: ${submission.duration}\n`;
    analytics += `Attempt: ${submission.attempt}/${submission.maxAttempts}\n`;

    // Per-question breakdown if answers are available
    if (submission.answers && submission.answers.length > 0) {
        analytics += `\nQuestion Breakdown:\n`;
        submission.answers.forEach((a, idx) => {
            analytics += `Q${idx + 1}: ${a.isCorrect ? '✔️' : '❌'} ${a.question}\n`;
            analytics += `   Your Answer: ${a.selectedAnswer}\n`;
            analytics += `   Correct: ${a.correctAnswer}\n`;
            analytics += `   Points: ${a.points}\n`;
        });
    }

    showInfo(analytics);
}

let currentGradingSubmissionId = null;
        // Grade submission
function gradeSubmission(submissionId) {
    currentGradingSubmissionId = submissionId;
    // Optionally pre-fill the score/comments if you want to edit an existing submission
    const submission = submissions.find(s => s.id === submissionId);
    if (submission) {
        document.getElementById('manualScore').value = submission.percentage || '';
        document.getElementById('gradeComments').value = submission.comments || '';
    } else {
        document.getElementById('manualScore').value = '';
        document.getElementById('gradeComments').value = '';
    }
    new bootstrap.Modal(document.getElementById('gradeModal')).show();
}

        // Save manual grade
      function saveManualGrade() {
    const score = document.getElementById('manualScore').value;
    const comments = document.getElementById('gradeComments').value;
    const notify = document.getElementById('notifyStudent').checked;

    // Validate score
    if (score === '' || isNaN(score) || score < 0 || score > 100) {
        showError('Please enter a valid score between 0 and 100.');
        return;
    }

    // Update the selected submission in your frontend
    let submission = submissions.find(s => s.id === currentGradingSubmissionId);
    if (submission) {
        submission.percentage = parseFloat(score);
        submission.status = 'completed';
        submission.comments = comments;
        // Update other fields as needed
        submission.score = Math.round((parseFloat(score) / 100) * submission.quiz.maxScore); // update raw score
        submission.gradedAt = new Date().toISOString(); // add graded timestamp
        submission.gradedBy = 'Manual'; // or current user if available
    }

    // Send the grade to the backend for persistence
    fetch('QuizSubmissions.aspx/SaveManualGrade', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            submissionId: currentGradingSubmissionId,
            score: parseFloat(score),
            comments: comments,
            notify: notify
        })
    })
    .then(response => response.json())
    .then(result => {
        if (result.d && result.d.success) {
            showSuccess(`Grade updated to ${score}%`);
            bootstrap.Modal.getInstance(document.getElementById('gradeModal')).hide();
            fetchSubmissions(); // Refresh data from backend
        } else {
            showError(result.d && result.d.message ? result.d.message : 'Failed to save grade.');
        }
    })
    .catch(() => showError('Failed to save grade.'));
}

function exportSubmission() {
    // Get the currently viewed submission
    const studentId = document.getElementById('modalStudentId').textContent;
    const submission = submissions.find(s => s.student.id === studentId);
    if (!submission) {
        showError('Submission not found.');
        return;
    }

    // Use jsPDF to export the submission as PDF
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();

    doc.setFontSize(16);
    doc.text("Quiz Submission Details", 10, 15);

    doc.setFontSize(12);
    doc.text(`Student: ${submission.student.name} (${submission.student.id})`, 10, 30);
    doc.text(`Quiz: ${submission.quiz.title}`, 10, 40);
    doc.text(`Course: ${submission.quiz.course}`, 10, 50);
    doc.text(`Score: ${submission.percentage}% (${submission.score}/${submission.quiz.maxScore})`, 10, 60);
    doc.text(`Status: ${submission.status.replace('-', ' ')}`, 10, 70);
    doc.text(`Submitted: ${submission.submittedAt ? formatDate(submission.submittedAt) + ' ' + formatTime(submission.submittedAt) : 'Not submitted'}`, 10, 80);
    doc.text(`Duration: ${submission.duration}`, 10, 90);

    // Optionally add answers
    let y = 100;
    if (submission.answers && submission.answers.length > 0) {
        doc.setFontSize(12);
        doc.text("Answers:", 10, y);
        y += 8;
        submission.answers.forEach((a, idx) => {
            doc.setFontSize(10);
            doc.text(`Q${idx + 1}: ${a.question}`, 12, y);
            y += 6;
            doc.text(`Your Answer: ${a.selectedAnswer}`, 14, y);
            y += 6;
            doc.text(`Correct: ${a.correctAnswer}`, 14, y);
            y += 6;
            doc.text(`Points: ${a.points}   ${a.isCorrect ? '✔️' : '❌'}`, 14, y);
            y += 8;
            if (y > 270) { doc.addPage(); y = 20; }
        });
    }

    doc.save(`submission_${submission.student.id}_${submission.quiz.title.replace(/\s+/g, '_')}.pdf`);
    showSuccess(`Exported submission for ${submission.student.name} as PDF.`);
}
        // Refresh data
        function refreshData() {
    document.getElementById('loadingSpinner').style.display = 'block';
    document.getElementById('submissionsTableContainer').style.display = 'none';

    // Actually fetch fresh data from the backend
    fetch('QuizSubmissions.aspx/GetQuizSubmissions', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: '{}'
    })
    .then(response => response.json())
    .then(result => {
        document.getElementById('loadingSpinner').style.display = 'none';
        document.getElementById('submissionsTableContainer').style.display = 'block';
        if (result.d && result.d.success) {
            submissions = result.d.data;
            currentSubmissions = [...submissions];
            currentPage = 1;
            loadSubmissions();
            updateStatistics();
            showSuccess('Data refreshed.');
        } else {
            showError(result.d && result.d.message ? result.d.message : 'Failed to refresh data.');
        }
    })
    .catch((err) => {
        document.getElementById('loadingSpinner').style.display = 'none';
        document.getElementById('submissionsTableContainer').style.display = 'block';
        showError('Failed to refresh data.\n' + err);
    });
}
let searchbarTimeout = null;

document.getElementById('studentSearch').addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    clearTimeout(searchbarTimeout);
    if (searchTerm.length >= 2 || searchTerm.length === 0) {
        searchbarTimeout = setTimeout(() => {
            applyFilters();
        }, 300);
    }
});
        // Auto-filter on dropdown changes
document.getElementById('courseFilter').addEventListener('change', function() {
    const selectedCourse = this.value;
    loadQuizzes(selectedCourse);
    applyFilters();
});
document.getElementById('quizFilter').addEventListener('change', applyFilters);
document.getElementById('statusFilter').addEventListener('change', applyFilters);
document.getElementById('scoreFilter').addEventListener('change', applyFilters);
document.getElementById('dateFrom').addEventListener('change', applyFilters);
document.getElementById('dateTo').addEventListener('change', applyFilters);

       let confirmActionCallback = null;

function showSuccess(message) {
    // Hide any open modals first
    document.querySelectorAll('.modal.show').forEach(modal => {
        bootstrap.Modal.getInstance(modal)?.hide();
    });

    document.getElementById('successMessage').textContent = message;
    new bootstrap.Modal(document.getElementById('successModal')).show();
}

function showError(message) {
    document.getElementById('errorMessage').textContent = message;
    new bootstrap.Modal(document.getElementById('errorModal')).show();
}

function showInfo(message) {
    document.getElementById('infoMessage').textContent = message;
    new bootstrap.Modal(document.getElementById('infoModal')).show();
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
    </script>

</asp:Content>
