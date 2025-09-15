<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="QuizSubmission.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.QuizSubmission" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Quiz Submissions - Teacher</title>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Font Awesome -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">	
    <!-- Google Fonts -->
    <script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>

    <style>
		body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
		.submissions-container { padding: 20px; max-width: 1600px; margin: 0 auto; }
		.page-header { background: linear-gradient(135deg, #2c2b7c, #0056b3); color: white; padding: 30px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 8px 25px rgba(44, 43, 124, 0.15); }
		.page-header h1 { margin-bottom: 10px; }
		.page-header p { margin-bottom: 0; opacity: 0.9; }
		.filter-section { background: white; padding: 25px; border-radius: 15px; margin-bottom: 25px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); }
		.filter-section h5 { color: #2c2b7c; margin-bottom: 20px; }
		.stats-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
		.stat-card { background: white; padding: 25px; border-radius: 15px; text-align: center; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); transition: transform 0.3s ease; }
		.stat-card:hover { transform: translateY(-5px); }
		.stat-card .stat-number { font-size: 2.5rem; font-weight: bold; margin-bottom: 5px; }
		.stat-card .stat-label { color: #6c757d; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; }
		.stat-card.total-submissions .stat-number { color: #2c2b7c; }
		.stat-card.completed-submissions .stat-number { color: #28a745; }
		.stat-card.average-score .stat-number { color: #ffc107; }
		.stat-card.highest-score .stat-number { color: #dc3545; }
		.submissions-table { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); }
		.table-header { background: #f8f9fa; padding: 20px; border-bottom: 2px solid #e9ecef; }
		.table-responsive { border-radius: 0 0 15px 15px; }
		.table thead th { background: #f8f9fa; border: none; font-weight: 600; color: #2c3e50; padding: 15px; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; }
		.table tbody td { padding: 15px; vertical-align: middle; border-top: 1px solid #f1f3f4; }
		.table tbody tr:hover { background-color: #f8f9fa; }
		.score-display { font-size: 1.1rem; font-weight: bold; }
		.score-excellent { color: #28a745; }
		.score-good { color: #17a2b8; }
		.score-average { color: #ffc107; }
		.score-poor { color: #dc3545; }
		.status-badge { padding: 6px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
		.status-completed { background: #d4edda; color: #155724; }
		.status-in-progress { background: #fff3cd; color: #856404; }
		.status-not-started { background: #f8d7da; color: #721c24; }
		.btn-action { padding: 8px 12px; border-radius: 8px; border: none; font-size: 0.8rem; font-weight: 500; margin: 0 2px; transition: all 0.2s ease; }
		.btn-view { background: #e3f2fd; color: #1976d2; }
		.btn-view:hover { background: #bbdefb; color: #0d47a1; }
		.btn-details { background: #f3e5f5; color: #7b1fa2; }
		.btn-details:hover { background: #e1bee7; color: #4a148c; }
		.btn-export { background: #e8f5e8; color: #2e7d32; }
		.btn-export:hover { background: #c8e6c9; color: #1b5e20; }
		.modal-content { border-radius: 15px; border: none; box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3); }
		.modal-header { background: linear-gradient(135deg, #2c2b7c, #0056b3); color: white; border-radius: 15px 15px 0 0; padding: 20px 30px; }
		.modal-header .modal-title { font-weight: 600; }
		.btn-close-white { filter: brightness(0) invert(1); }
		.submission-info { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
		.submission-info .row > div { margin-bottom: 10px; }
		.submission-info .info-label { font-weight: 600; color: #495057; }
		.submission-info .info-value { color: #212529; }
		.question-container { border: 2px solid #e9ecef; border-radius: 10px; margin-bottom: 20px; overflow: hidden; }
		.question-header { background: #f8f9fa; padding: 15px 20px; border-bottom: 2px solid #e9ecef; }
		.question-content { padding: 20px; }
		.question-text { font-weight: 600; margin-bottom: 15px; color: #2c3e50; }
		.answer-options { margin-bottom: 15px; }
		.answer-option { padding: 8px 12px; margin: 5px 0; border-radius: 5px; border: 1px solid #e9ecef; }
		.answer-correct { background: #d4edda; border-color: #c3e6cb; color: #155724; }
		.answer-selected { background: #cce5ff; border-color: #99d6ff; color: #004085; }
		.answer-incorrect { background: #f8d7da; border-color: #f5c6cb; color: #721c24; }
		.answer-neutral { background: #ffffff; }
		.progress-container { margin: 15px 0; }
		.progress { height: 8px; border-radius: 10px; }
		@media (max-width: 768px) { .submissions-container { padding: 10px; } .stats-container { grid-template-columns: repeat(2, 1fr); } .table-responsive { font-size: 0.9rem; } }
		.loading-spinner { display: none; text-align: center; padding: 40px; }
		.spinner-border { width: 3rem; height: 3rem; animation: spinner-border 0.75s linear infinite; }
		@keyframes spinner-border { 100% { transform: rotate(360deg); } }
		.export-options { display: none; background: #e8f5e8; padding: 15px; border-radius: 8px; margin-top: 15px; }
		@media print { .no-print { display: none !important; } .submissions-container { padding: 0; } .submissions-table { box-shadow: none; } }
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="submissions-container">
	<!-- Page Header -->
	<div class="page-header mb-4">
		<h1 class="mb-2">Quiz Submissions</h1>
		<p class="mb-0 opacity-75">View, filter, and export quiz submissions for your courses. Analyze student performance and manage grading.</p>
	</div>
	<!-- Statistics -->
	<div class="stats-container mb-4">
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
	<div class="filter-section mb-4">
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
	<div class="submissions-table mb-4">
		<div class="table-header">
			<div class="d-flex justify-content-between align-items-center">
				<h5 class="mb-0">Submissions</h5>
				<div class="d-flex align-items-center">
					<button class="btn btn-export btn-sm me-2" onclick="exportSubmissions()"><i class="fa fa-file-export me-2"></i>Export</button>
					<button class="btn btn-outline-primary btn-sm" onclick="refreshData()"><i class="fa fa-sync me-2"></i>Refresh</button>
				</div>
			</div>
		</div>
		<div class="loading-spinner" id="loadingSpinner">
			<div class="spinner-border text-primary" role="status"></div>
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
					<!-- Dynamic rows -->
				</tbody>
			</table>
		</div>
        <div class="text-muted">
    Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> submissions
</div>
		<!-- Pagination -->
		<div class="d-flex justify-content-between align-items-center p-3 border-top">
        
			<div class="text-muted">
				Page <span id="currentPage">1</span> of <span id="totalPages">1</span>
			</div>
			<nav>
				<ul class="pagination mb-0">
					<li class="page-item" id="prevPage"><a class="page-link" href="#" onclick="changePage(-1)">&laquo;</a></li>
					<!-- Page numbers will be inserted here -->
					<li class="page-item" id="nextPage"><a class="page-link" href="#" onclick="changePage(1)">&raquo;</a></li>
				</ul>
			</nav>
		</div>
        
	</div>
</div>


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


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

let submissions = [];
let currentSubmissions = [];
let currentPage = 1;
const itemsPerPage = 10;

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('courseFilter').value = '';
document.getElementById('quizFilter').value = '';
document.getElementById('statusFilter').value = '';
document.getElementById('scoreFilter').value = '';
document.getElementById('studentSearch').value = '';
document.getElementById('dateFrom').value = '';
document.getElementById('dateTo').value = '';
    document.getElementById('loadingSpinner').style.display = 'block';
    document.getElementById('submissionsTableContainer').style.display = 'none';
    fetchSubmissions();
    updateSortIndicators();
    populateCourseFilter();
    populateQuizFilter();
});


function fetchSubmissions() {
    document.getElementById('loadingSpinner').style.display = 'block';
    document.getElementById('submissionsTableContainer').style.display = 'none';
    fetch('QuizSubmission.aspx/GetQuizSubmissions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            courseId: document.getElementById('courseFilter').value || null,
            quizId: document.getElementById('quizFilter').value || null
        })
    })
    .then(res => res.json())
    .then(data => {
        // Handle both string and object
        const result = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
       window.submissions = result; // Store globally for filtering/pagination
currentSubmissions = [...window.submissions]; // Initialize current submissions
applyFilters(); // This will call renderSubmissionsTable() and updateStatistics()
    })
    .catch(() => {
        showError('Failed to load submissions.');
        window.submissions = [];
        renderSubmissionsTable();
    });
}

function renderSubmissionsTable() {
    const tbody = document.getElementById('submissionsTableBody');
    tbody.innerHTML = "";

    const start = (currentPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageSubmissions = currentSubmissions.slice(start, end);

    if (!currentSubmissions || currentSubmissions.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center py-4 text-muted">
                    <i class="fas fa-clipboard-list fa-2x mb-2 d-block"></i>
                    No submissions found matching your criteria.
                </td>
            </tr>
        `;
        return;
    }

    pageSubmissions.forEach((sub, idx) => {
        const scoreClass = getScoreClass(sub.percentage || sub.score);
        const statusBadge = getStatusBadge(sub.status);
        tbody.innerHTML += `
            <tr>
                <td>
                    <div>
                        <div class="fw-bold">${sub.student.name}</div>
                        <small class="text-muted">${sub.student.id}</small>
                    </div>
                </td>
                <td>
                    <div class="fw-bold">${sub.quiz.title}</div>
                    <small class="text-muted">Quiz ID: ${sub.quiz.id}</small>
                </td>
                <td>
                    <span class="badge bg-primary">${sub.quiz.course}</span>
                </td>
                <td>
                    <div class="score-display ${scoreClass}">
                        ${sub.percentage || sub.score}%
                    </div>
                    <small class="text-muted">${sub.score}/${sub.quiz.maxScore} pts</small>
                </td>
                <td>
                    <div class="d-flex flex-column gap-1">
                        ${statusBadge}
                        <small class="text-muted">
                            Attempt ${sub.attempt || 1}/1
                        </small>
                    </div>
                </td>
                <td>
                    <div>${sub.submittedAt ? formatDate(sub.submittedAt) + ' ' + formatTime(sub.submittedAt) : 'Not submitted'}</div>
                </td>
                <td>
                    <span class="badge bg-info">${sub.duration || '-'}</span>
                </td>
                <td>
                    <button type="button" class="btn btn-action btn-view" onclick="viewSubmission(${start + idx})" title="View Details">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button type="button" class="btn btn-action btn-details" onclick="showAnalytics(${start + idx})" title="Analytics">
                        <i class="fas fa-chart-bar"></i>
                    </button>
                    <button type="button" class="btn btn-action btn-export" onclick="exportSingleSubmission(${start + idx})" title="Export">
                        <i class="fas fa-download"></i>
                    </button>
                </td>
            </tr>
        `;
    });
    document.getElementById('submissionsTableContainer').style.display = '';
    document.getElementById('loadingSpinner').style.display = 'none';
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
        renderSubmissionsTable();
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
       function viewSubmission(idx) {
    const sub = window.submissions && window.submissions[idx];
    currentSubmissionId = sub ? sub.id : null;

    // Populate modal with real data
    document.getElementById('modalStudentName').textContent = sub.student.name;
    document.getElementById('modalStudentId').textContent = sub.student.id;
    document.getElementById('modalQuizTitle').textContent = sub.quiz.title;
    document.getElementById('modalCourse').textContent = sub.quiz.course;
    document.getElementById('modalScore').textContent = `${sub.percentage || sub.score}%`;
    document.getElementById('modalScore').className = `score-display ${getScoreClass(sub.percentage || sub.score)}`;
    document.getElementById('modalPoints').textContent = `${sub.score}/${sub.quiz.maxScore}`;
    document.getElementById('modalStatus').textContent = (sub.status || '').replace('-', ' ');
    document.getElementById('modalStatus').className = `status-badge status-${sub.status}`;
    document.getElementById('modalSubmitted').textContent = sub.submittedAt ? `${formatDate(sub.submittedAt)} ${formatTime(sub.submittedAt)}` : 'Not submitted';
    document.getElementById('modalDuration').textContent = sub.duration || '-';

    // Progress bar
    document.getElementById('progressBar').style.width = `${sub.percentage || sub.score}%`;
    document.getElementById('progressText').textContent = `${sub.correctCount || '-'} / ${sub.totalQuestions || sub.quiz.maxScore} questions correct`;

    // Questions and answers
    if (sub.answers && sub.answers.length > 0) {
        loadQuestionsAndAnswers(sub);
    } else {
        document.getElementById('questionsContainer').innerHTML = `
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Detailed answers are not available for this submission.
            </div>
        `;
    }

    // Manual grade button
    document.getElementById('manualGradeBtn').onclick = function() {
        gradeSubmission(sub.id);
    };

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

        // Apply filters
      function applyFilters() {
    const courseFilter = document.getElementById('courseFilter').value;
    const quizFilter = document.getElementById('quizFilter').value;
    const statusFilter = document.getElementById('statusFilter').value;
    const scoreFilter = document.getElementById('scoreFilter').value;
    const studentSearch = document.getElementById('studentSearch').value.toLowerCase();
    const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
    console.log('Filters:', {
    courseFilter,
    quizFilter,
    statusFilter,
    scoreFilter,
    studentSearch,
    dateFrom,
    dateTo
});
console.log('Submissions before filter:', submissions);
    currentSubmissions = window.submissions.filter(submission => {
        // Course filter
        if (courseFilter && String(submission.quiz.courseId) !== String(courseFilter)) return false;
        
        // Quiz filter
        if (quizFilter) {
    console.log('Comparing:', submission.quiz.id, quizFilter);
    if (submission.quiz.id.toString() !== quizFilter) return false;
}
        
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
    !submission.student.id.toString().toLowerCase().includes(studentSearch)) return false;
        
       // Date filters
if (dateFrom) {
    if (!submission.submittedAt) return false;
    const submissionDate = new Date(submission.submittedAt).toISOString().split('T')[0];
    if (submissionDate < dateFrom) return false;
}
if (dateTo) {
    if (!submission.submittedAt) return false;
    const submissionDate = new Date(submission.submittedAt).toISOString().split('T')[0];
    if (submissionDate > dateTo) return false;
}
        console.log('Filtered submissions:', currentSubmissions);
        return true;
    });

    currentPage = 1;
    renderSubmissionsTable();
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
    applyFilters();
    renderSubmissionsTable();
    updateStatistics();
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
    renderSubmissionsTable();
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
                renderSubmissionsTable();
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
    const dataToExport = onlyFiltered ? currentSubmissions : window.submissions;

    // Build header
    let headers = [
        'Student Name', 'Student ID', 'Quiz Title', 'Course', 'Score (%)', 'Points', 'Status', 'Submitted', 'Duration'
    ];
    if (includeAnswers) headers.push('Answers');
    if (includeStatistics) headers.push('Average Score', 'Highest Score');

    let rows = dataToExport.map(sub => {
        let row = [
            sub.student.name,
            sub.student.id,
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
        showSuccess(`Exported ${dataToExport.length} submissions as CSV.`);
    }
    // Export as Excel (SheetJS)
    else if (format === 'excel' && window.XLSX) {
        const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Submissions");
        XLSX.writeFile(wb, "quiz_submissions.xlsx");
        showSuccess(`Exported ${dataToExport.length} submissions as Excel.`);
    } else if (format === 'excel') {
        showError('Excel export requires SheetJS (XLSX) library loaded.');
        return;
    }
    // Export as PDF (jsPDF)
    else if (format === 'pdf' && window.jspdf) {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        doc.setFontSize(16);
        doc.text("Quiz Submissions", 10, 15);
        doc.setFontSize(10);
        // Headers
        headers.forEach((header, i) => {
            doc.text(header, 10 + i * 25, 25);
        });
        // Rows
        rows.forEach((row, rowIndex) => {
            row.forEach((cell, colIndex) => {
                doc.text(String(cell), 10 + colIndex * 25, 32 + rowIndex * 7);
            });
        });
        doc.save("quiz_submissions.pdf");
        showSuccess(`Exported ${dataToExport.length} submissions as PDF.`);
    } else if (format === 'pdf') {
        showError('PDF export requires jsPDF library loaded.');
        return;
    }

    bootstrap.Modal.getInstance(document.getElementById('exportModal')).hide();
}

        // Export single submission
function exportSingleSubmission(idx) {
    const sub = window.submissions && window.submissions[idx];
    if (!sub) return;

    // Build CSV content
    const csvRows = [
        ["Student", "Quiz", "Course", "Score", "Status", "Submitted", "Duration"],
        [
            sub.student.name,
            sub.quiz.title,
            sub.quiz.course,
            (sub.percentage || sub.score) + "%",
            sub.status,
            sub.submittedAt ? `${formatDate(sub.submittedAt)} ${formatTime(sub.submittedAt)}` : '',
            sub.duration
        ]
    ];

    // Optionally add answers if available
    if (sub.answers && sub.answers.length > 0) {
        csvRows.push([]);
        csvRows.push(["Question", "Your Answer", "Correct Answer", "Points", "Result"]);
        sub.answers.forEach(a => {
            csvRows.push([
                a.question,
                a.selectedAnswer,
                a.correctAnswer,
                a.points,
                a.isCorrect ? "Correct" : "Incorrect"
            ]);
        });
    }

    // Convert to CSV string
    const csv = csvRows.map(row => row.map(val => `"${(val || '').toString().replace(/"/g, '""')}"`).join(",")).join("\n");

    // Download as CSV
    const blob = new Blob([csv], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `submission_${sub.student.name.replace(/\s+/g, '_')}_${sub.quiz.title.replace(/\s+/g, '_')}.csv`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);

    showSuccess(`Exported submission for ${sub.student.name} as CSV.`);
}

        // Show analytics
function showAnalytics(idx) {
    const sub = window.submissions && window.submissions[idx];
    if (!sub) return;

    let analytics = `Analytics for ${sub.student.name}:\n\n`;
    analytics += `Quiz: ${sub.quiz.title}\n`;
    analytics += `Course: ${sub.quiz.course}\n`;
    analytics += `Score: ${sub.percentage || sub.score}%\n`;
    analytics += `Status: ${(sub.status || '').replace('-', ' ')}\n`;
    analytics += `Submitted: ${sub.submittedAt ? formatDate(sub.submittedAt) + ' ' + formatTime(sub.submittedAt) : 'Not submitted'}\n`;
    analytics += `Duration: ${sub.duration || '-'}\n`;
    analytics += `Attempt: ${sub.attempt || 1}/1\n`;
    if (sub.comments) analytics += `\nComments: ${sub.comments}\n`;

    // Optionally, add more analytics (e.g., correct/incorrect count)
    if (sub.answers && sub.answers.length > 0) {
        const correct = sub.answers.filter(a => a.isCorrect).length;
        const total = sub.answers.length;
        analytics += `\nQuestions Correct: ${correct} / ${total}\n`;
        const incorrect = total - correct;
        analytics += `Questions Incorrect: ${incorrect}\n`;
    }

    document.getElementById('infoMessage').textContent = analytics;
    new bootstrap.Modal(document.getElementById('infoModal')).show();
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

    // Always use window.submissions and compare as string
    let submission = window.submissions.find(s => String(s.id) === String(currentGradingSubmissionId));
    if (submission) {
        submission.percentage = parseFloat(score);
        submission.status = 'completed';
        submission.comments = comments;
        submission.score = Math.round((parseFloat(score) / 100) * submission.quiz.maxScore);
        submission.gradedAt = new Date().toISOString();
        submission.gradedBy = 'Manual';

        // Optionally, persist to backend
        fetch('QuizSubmission.aspx/SaveManualGrade', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                submissionId: submission.id,
                score: submission.score,
                percentage: submission.percentage,
                comments: submission.comments,
                notify: notify
            })
        })
        .then(res => res.json())
        .then(data => {
            showSuccess('Manual grade saved successfully!');
            // Refresh UI
            renderSubmissionsTable();
            updateStatistics();
            bootstrap.Modal.getInstance(document.getElementById('gradeModal')).hide();
            // Re-open the details modal for the same submission
            const idx = window.submissions.findIndex(s => String(s.id) === String(currentGradingSubmissionId));
            if (idx !== -1) {
                viewSubmission(idx);
            }
        })
        .catch(() => {
            showError('Failed to save manual grade.');
        });
    } else {
        showError('Submission not found.');
    }
}


let currentSubmissionIdx = null;
function exportSubmission() {
    // Get the currently viewed submission
    const studentId = document.getElementById('modalStudentId').textContent;
    const quizTitle = document.getElementById('modalQuizTitle').textContent;
     const submission = window.submissions.find(s => s.id === currentSubmissionId);
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
   
let searchbarTimeout = null;

document.getElementById('courseFilter').addEventListener('change', function() {
    const selectedCourse = this.value;
    populateQuizFilter();
    fetchSubmissions();    
    applyFilters();
});
document.getElementById('quizFilter').addEventListener('change', applyFilters);
document.getElementById('statusFilter').addEventListener('change', applyFilters);
document.getElementById('scoreFilter').addEventListener('change', applyFilters);
document.getElementById('dateFrom').addEventListener('change', applyFilters);
document.getElementById('dateTo').addEventListener('change', applyFilters);

document.getElementById('studentSearch').addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    clearTimeout(searchbarTimeout);
    if (searchTerm.length >= 2 || searchTerm.length === 0) {
        searchbarTimeout = setTimeout(() => {
            applyFilters();
        }, 300);
    }
});

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


function refreshData() {
    // Optionally, show spinner or reload data from backend here
    clearFilters();
    fetchSubmissions();
}
function exportSubmissions() {
    new bootstrap.Modal(document.getElementById('exportModal')).show();
}


	// Sample data for courses and quizzes
const teacherCourses = [];

const quizzes = [];

// Populate courses in the filter
function populateCourseFilter() {
    fetch('QuizSubmission.aspx/GetTeacherCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        const courses = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
        const courseFilter = document.getElementById('courseFilter');
        courseFilter.innerHTML = `<option value="">All Courses</option>`;
        courses.forEach(course => {
    courseFilter.innerHTML += `<option value="${course.id}">${course.name}</option>`;
});
        populateQuizFilter(); // Populate quizzes for the first course
    });
}

function populateQuizFilter() {
    const courseId = document.getElementById('courseFilter').value;
    const quizFilter = document.getElementById('quizFilter');
    quizFilter.innerHTML = `<option value="">All Quizzes</option>`;
    if (!courseId) return;
    fetch('QuizSubmission.aspx/GetQuizzesByCourse', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ courseId: parseInt(courseId, 10) })
    })
    .then(res => res.json())
    .then(data => {
        const quizzes = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
        quizzes.forEach(quiz => {
            quizFilter.innerHTML += `<option value="${quiz.id}">${quiz.name}</option>`;
        });
    });
}

// Sample submissions data

// Helper functions
function getQuizName(quizId) {
    const quiz = quizzes.find(q => q.id === quizId);
    return quiz ? quiz.name : "Unknown Quiz";
}
function getCourseName(courseId) {
    const course = teacherCourses.find(c => c.id === courseId);
    return course ? course.name : "Unknown Course";
}
function getStatusBadge(status) {
    if (status === "completed") return `<span class="status-badge status-completed">Completed</span>`;
    if (status === "in-progress") return `<span class="status-badge status-in-progress">In Progress</span>`;
    if (status === "not-started") return `<span class="status-badge status-not-started">Not Started</span>`;
    return `<span class="status-badge">${status}</span>`;
}
function getScoreClass(score) {
    if (score >= 90) return "score-excellent";
    if (score >= 80) return "score-good";
    if (score >= 70) return "score-average";
    return "score-poor";
}

</script>
</asp:Content>
