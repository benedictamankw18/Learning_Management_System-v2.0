<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Quizzes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Quiz Management - Teacher</title>
	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Font Awesome -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
	<style>
		body { font-family: 'Roboto', sans-serif; background-color: #f8f9fa; }
		.quiz-container { padding: 20px; max-width: 1400px; margin: 0 auto; }
		.page-header { background: linear-gradient(135deg, #2c2b7c, #1e7e34); color: white; padding: 30px; border-radius: 15px; margin-bottom: 30px; box-shadow: 0 8px 25px rgba(44, 43, 124, 0.15); }
		.breadcrumb-nav { background: white; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }
		.breadcrumb-nav .breadcrumb { margin: 0; }
		.breadcrumb-nav .breadcrumb-item a { color: #2c2b7c; text-decoration: none; font-weight: 500; }
		.breadcrumb-nav .breadcrumb-item a:hover { text-decoration: underline; }
		.quiz-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; margin-bottom: 30px; }
		.quiz-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); transition: all 0.3s ease; cursor: pointer; border: 2px solid transparent; position: relative; }
		.quiz-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(44, 43, 124, 0.15); border-color: #2c2b7c; }
		.quiz-card .quiz-icon { width: 60px; height: 60px; background: linear-gradient(135deg, #2c2b7c, #1e7e34); border-radius: 15px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; }
		.quiz-card .quiz-icon i { font-size: 24px; color: white; }
		.quiz-card h5 { color: #2c3e50; margin-bottom: 10px; font-weight: 600; }
		.quiz-card .quiz-meta { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; padding-top: 15px; border-top: 1px solid #eee; }
		.quiz-card .questions-count { color: #6c757d; font-size: 14px; }
		.quiz-card .status-badge { background: #e8f5e8; color: #155724; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
		.quiz-loading-spinner { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 180px; color: #2c2b7c; font-size: 1.1rem; font-weight: 500; opacity: 0.85; }
		.quiz-loading-spinner .spinner-border { width: 3rem; height: 3rem; margin-bottom: 1rem; color: #2c2b7c; }
		.fade-in { animation: fadeIn 0.7s ease; }
		@keyframes fadeIn { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
		.btn-action { padding: 6px 12px; border-radius: 6px; border: none; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.2s ease; }
		.btn-view { background: #e8f5e8; color: #155724; }
		.btn-add { background: #d4edda; color: #0a3622; }
		.btn-view:hover { background: #c3e6cb; }
		.btn-add:hover { background: #b8dabd; }
		.modal-content { border-radius: 15px; border: none; }
		.modal-header { background: linear-gradient(135deg, #2c2b7c, #1e7e34); color: white; border-radius: 15px 15px 0 0; }
		.btn-close-white { filter: brightness(0) invert(1); }
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
        
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="quiz-container">
	<!-- Page Header -->
	<div class="page-header mb-4">
		<h1 class="mb-2">Quiz Management</h1>
		<p class="mb-0 opacity-75">Create, update, delete, and manage quizzes and questions for your courses. Upload quizzes via Excel, and support all question types.</p>
	</div>
	<!-- Breadcrumb Navigation -->
	<div class="breadcrumb-nav mb-4">
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb mb-0" id="breadcrumb">
				<li class="breadcrumb-item active">All Quizzes</li>
			</ol>
		</nav>
	</div>
	<!-- Quiz List View -->
	<div id="quizListView" class="view-active fade-in">
		<div class="d-flex flex-wrap gap-2 justify-content-between align-items-center mb-4">
			<div class="d-flex gap-2">
				<button class="btn btn-primary rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#addQuizModal"><i class="fa fa-plus me-2"></i>Add Quiz</button>
				<button class="btn btn-success rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#uploadExcelModal"><i class="fa fa-file-excel me-2"></i>Upload Excel</button>
			</div>
			<a href="QuizSubmission.aspx" class="btn btn-outline-info rounded-pill px-4 shadow-sm"><i class="fa fa-list me-2"></i>View Submissions</a>
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


		<div class="quiz-grid" id="quizGrid">
			<!-- Loading spinner shown by default -->
			<div class="quiz-loading-spinner" id="quizLoadingSpinner">
				<div class="spinner-border" role="status"></div>
				<div>Loading quizzes, please wait...</div>
			</div>
		</div>

</div>














	<!-- Quiz Management Modal Templates (Add/Edit/View/Delete/Questions) -->
	<!-- Add Quiz Modal -->
	<div class="modal fade" id="addQuizModal" tabindex="-1">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Add New Quiz</h5>
					<button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="addQuizForm">
					<div class="row g-3">
						<div class="col-md-8">
							<label for="quizTitle" class="form-label">Quiz Title</label>
							<input type="text" class="form-control" id="quizTitle" placeholder="Enter quiz title" required />
						</div>
						<div class="col-md-4">
							<label for="quizDuration" class="form-label">Duration (minutes)</label>
							<input type="number" class="form-control" id="quizDuration" min="1" max="180" placeholder="30" required />
						</div>
					</div>
						
						<div class="mb-3">
							<label for="quizDescription" class="form-label">Description</label>
							<textarea class="form-control" id="quizDescription" rows="2" placeholder="Brief description of the quiz..."></textarea>
						</div>
						
						<div class="row g-3 mt-2">
							<div class="col-md-6">
								<label for="quizStartDate" class="form-label">Start Date</label>
								<input type="date" class="form-control" id="quizStartDate" required />
							</div>
							<div class="col-md-6">
								<label for="quizStartTime" class="form-label">Start Time</label>
								<input type="time" class="form-control" id="quizStartTime" required />
							</div>
						</div>
						<div class="row g-3 mt-2">
							<div class="col-md-6">
								<label for="quizEndDate" class="form-label">End Date</label>
								<input type="date" class="form-control" id="quizEndDate" required />
							</div>
							<div class="col-md-6">
								<label for="quizEndTime" class="form-label">End Time</label>
								<input type="time" class="form-control" id="quizEndTime" required />
							</div>
						</div>
						<div class="row g-3 mt-2">
							<div class="col-md-4">
								<label for="quizMaxAttempts" class="form-label">Max Attempts</label>
								<input type="number" class="form-control" id="quizMaxAttempts" min="1" value="1" required />
							</div>
							<div class="col-md-4">
								<label for="quizStatus" class="form-label">Status</label>
								<select class="form-select" id="quizStatus" required>
									<option value="draft">Draft</option>
									<option value="inactive">Inactive</option>
									<option value="active">Active</option>
								</select>
							</div>
								<div class="col-md-4">
								<label for="quizType" class="form-label">Quiz Type</label>
								<select class="form-select" id="quizType" required>
									<option value="practice">Practice Quiz</option>
                                    <option value="graded">Graded Quiz</option>
                                    <option value="exam">Exam</option>
								</select>
							</div>
						</div>
						<div class="form-check form-switch mt-3">
							<input class="form-check-input" type="checkbox" id="quizIsActivated" checked>
							<label class="form-check-label" for="quizIsActivated">
								<span id="quizIsActivatedLabel">Activate Quiz</span>
							</label>
						</div>
						<div class="mt-4 text-end">
							<button type="submit" class="btn btn-success px-4">Create Quiz</button>
						</div>
					</form>
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
                        <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="excelQuizCourse" class="form-label">Course</label>
                            <select class="form-select" id="excelQuizCourse" required>
                                <option value="">Select Course</option>
                                <!-- Populate with JS -->
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="excelQuizSection" class="form-label">Section (optional)</label>
                            <select class="form-select" id="excelQuizSection">
                                <option value="">None</option>
                                <!-- Populate with JS if needed -->
                            </select>
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
	<!-- More modals for Edit/View/Delete/Questions can be added here as needed -->

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
    <!-- Edit Quiz Modal -->
<div class="modal fade" id="editQuizModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header" style="background: linear-gradient(135deg, #2c2b7c, #1e7e34); color: white;">
                <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Quiz</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="editQuizForm">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label for="editQuizTitle" class="form-label">Quiz Title</label>
                            <input type="text" class="form-control" id="editQuizTitle" required />
                        </div>
                        <div class="col-md-4">
                            <label for="editQuizDuration" class="form-label">Duration (minutes)</label>
                            <input type="number" class="form-control" id="editQuizDuration" min="1" max="180" required />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editQuizDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="editQuizDescription" rows="2"></textarea>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label for="editQuizStartDate" class="form-label">Start Date</label>
                            <input type="date" class="form-control" id="editQuizStartDate" required />
                        </div>
                        <div class="col-md-6">
                            <label for="editQuizStartTime" class="form-label">Start Time</label>
                            <input type="time" class="form-control" id="editQuizStartTime" required />
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-6">
                            <label for="editQuizEndDate" class="form-label">End Date</label>
                            <input type="date" class="form-control" id="editQuizEndDate" required />
                        </div>
                        <div class="col-md-6">
                            <label for="editQuizEndTime" class="form-label">End Time</label>
                            <input type="time" class="form-control" id="editQuizEndTime" required />
                        </div>
                    </div>
                    <div class="row g-3 mt-2">
                        <div class="col-md-4">
                            <label for="editQuizMaxAttempts" class="form-label">Max Attempts</label>
                            <input type="number" class="form-control" id="editQuizMaxAttempts" min="1" required />
                        </div>
                        <div class="col-md-4">
                            <label for="editQuizStatus" class="form-label">Status</label>
                            <select class="form-select" id="editQuizStatus" required>
                                <option value="draft">Draft</option>
                                <option value="inactive">Inactive</option>
                                <option value="active">Active</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="editQuizType" class="form-label">Quiz Type</label>
                            <select class="form-select" id="editQuizType" required>
                                <option value="practice">Practice Quiz</option>
                                <option value="graded">Graded Quiz</option>
                                <option value="exam">Exam</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-check form-switch mt-3">
                        <input class="form-check-input" type="checkbox" id="editQuizIsActivated">
                        <label class="form-check-label" for="editQuizIsActivated">
                            <span id="editQuizIsActivatedLabel">Activate Quiz</span>
                        </label>
                    </div>
                    <div class="mt-4 text-end">
                        <button type="submit" class="btn btn-success px-4">Update Quiz</button>
                    </div>
                </form>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

// Example: Show quiz info in modal (replace with your dynamic logic)
function showQuizModal(quiz) {
  document.getElementById('viewQuizTitle').textContent = quiz.title;
  document.getElementById('viewQuizDescription').textContent = quiz.description;
  document.getElementById('viewQuizType').textContent = quiz.type;
  document.getElementById('viewQuizDuration').textContent = quiz.duration;
  document.getElementById('viewQuizMaxAttempts').textContent = quiz.maxAttempts;
  document.getElementById('viewQuizStart').textContent = quiz.start;
  document.getElementById('viewQuizEnd').textContent = quiz.end;
  document.getElementById('viewQuizStatus').textContent = quiz.status;
  document.getElementById('viewQuizActivated').textContent = quiz.activated ? "Yes" : "No";
  var modal = new bootstrap.Modal(document.getElementById('viewQuizModal'));
  modal.show();
}


    // Optional: Update label text dynamically
    document.getElementById('quizIsActivated').addEventListener('change', function() {
		document.getElementById('quizIsActivated').style.color = this.checked ? 'green' : 'red';
		document.getElementById('quizIsActivatedLabel').textContent = this.checked ? 'Activated' : 'Deactivated';
        <%-- document.getElementById('quizIsActivatedLabel').textContent = this.checked ? 'Quiz is Active' : 'Quiz is Inactive'; --%>
    });


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
        const title = document.getElementById('excelQuizTitle').value.trim();
        const duration = parseInt(document.getElementById('excelQuizDuration').value, 10);
        const status = document.getElementById('excelQuizStatus').value;
        const type = document.getElementById('excelQuizType').value;
        const courseId = document.getElementById('excelQuizCourse').value;
        const sectionId = document.getElementById('excelQuizSection').value || null;

        if (!title || isNaN(duration) || !status || !type || !courseId) {
            showError('Please fill in all required fields and select a course.');
            return;
        }

        fetch('Quizzes.aspx/UploadQuizExcel', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                base64Excel,
                title,
                duration,
                status,
                type,
                courseId,
                sectionId
            })
        })
        .then(res => res.json())
        .then(response => {
            const result = response.d || response;
            if (result.success) {
                showSuccess('Excel quiz uploaded and imported successfully!');
                bootstrap.Modal.getInstance(document.getElementById('uploadExcelModal')).hide();
                form.reset();
                if (typeof currentSection !== "undefined" && currentSection) {
                    loadSectionQuizzes(currentSection);
                } else if (typeof currentCourse !== "undefined" && currentCourse) {
                    loadCourseQuizzes(currentCourse.id);
                } else {
                    fetchQuizzes();
                }
            } else {
                showError('Failed to import quiz: ' + (result.message || 'Unknown error'));
            }
        })
        .catch((xhr) => {
            showError('Error importing quiz: ' + (xhr?.responseText || 'Unknown error'));
        });
    };
    reader.readAsDataURL(file);
}

function viewQuiz(quiz) {
    document.getElementById('viewQuizTitle').textContent = quiz.Title || '';
    document.getElementById('viewQuizDescription').textContent = quiz.Description || '';
    document.getElementById('viewQuizType').textContent = quiz.Type ? quiz.Type.charAt(0).toUpperCase() + quiz.Type.slice(1) : '';
    document.getElementById('viewQuizDuration').textContent = quiz.Duration || 0;
    document.getElementById('viewQuizMaxAttempts').textContent = quiz.MaxAttempts || 0;
    document.getElementById('viewQuizQuestions').textContent = quiz.Questions || 0;
    document.getElementById('viewQuizStatus').textContent = quiz.Status ? quiz.Status.charAt(0).toUpperCase() + quiz.Status.slice(1) : '';
    document.getElementById('viewQuizActivation').textContent = quiz.IsActivated ? 'Active' : 'Inactive';
    document.getElementById('viewQuizStartDateTime').textContent = quiz.StartDate || '';
    document.getElementById('viewQuizEndDateTime').textContent = quiz.EndDate || '';
    document.getElementById('viewQuizCreated').textContent = quiz.StartDate || '';
    document.getElementById('viewQuizSection').textContent = quiz.Section || 'N/A';
    var modal = new bootstrap.Modal(document.getElementById('viewQuizModal'));
    modal.show();
}

function editQuiz(quiz) {
    document.getElementById('editQuizTitle').value = quiz.Title || '';
    document.getElementById('editQuizDuration').value = quiz.Duration || '';
    document.getElementById('editQuizDescription').value = quiz.Description || '';
    
    
    // Split StartDate into date and time
    let startDate = '', startTime = '';
    if (quiz.StartDate) {
        const dt = new Date(quiz.StartDate);
        startDate = dt.toISOString().slice(0,10);
        startTime = dt.toTimeString().slice(0,5);
    }
    document.getElementById('editQuizStartDate').value = startDate;
    document.getElementById('editQuizStartTime').value = startTime;

    // Split EndDate into date and time
    let endDate = '', endTime = '';
    if (quiz.EndDate) {
        const dt = new Date(quiz.EndDate);
        endDate = dt.toISOString().slice(0,10);
        endTime = dt.toTimeString().slice(0,5);
    }
    document.getElementById('editQuizEndDate').value = endDate;
    document.getElementById('editQuizEndTime').value = endTime;


    document.getElementById('editQuizMaxAttempts').value = quiz.MaxAttempts || '';
    document.getElementById('editQuizStatus').value = quiz.Status || 'draft';
    document.getElementById('editQuizType').value = quiz.Type || 'practice';
    document.getElementById('editQuizIsActivated').checked = quiz.IsActivated ? true : false;
    document.getElementById('editQuizIsActivatedLabel').textContent = quiz.IsActivated ? 'Activated' : 'Deactivated';
    document.getElementById('editQuizIsActivated').onchange = function() {
        document.getElementById('editQuizIsActivatedLabel').textContent = this.checked ? 'Activated' : 'Deactivated';
    };
    var modal = new bootstrap.Modal(document.getElementById('editQuizModal'));
    modal.show();
}

document.getElementById('quizTableBody').addEventListener('click', function(e) {
    const btn = e.target.closest('button[data-quiz-index]');
    if (!btn) return;
    const idx = btn.getAttribute('data-quiz-index');
    const quiz = quizzes[idx];
    if (btn.classList.contains('btn-toggle-activate')) {
        // Show toggle activation modal
        document.getElementById('toggleQuizId').value = idx;
        document.getElementById('toggleActionTitle').textContent = quiz.IsActivated ? "Deactivate Quiz" : "Activate Quiz";
        document.getElementById('toggleMessage').textContent = quiz.IsActivated
            ? "Are you sure you want to deactivate this quiz?"
            : "Are you sure you want to activate this quiz?";
        document.getElementById('toggleDetails').textContent = quiz.Title;
        document.getElementById('toggleIcon').className = `fas fa-toggle-${quiz.IsActivated ? 'off' : 'on'} text-${quiz.IsActivated ? 'success' : 'danger'} fa-3x mb-3`;
        document.getElementById('toggleButtonText').textContent = quiz.IsActivated ? "Deactivate" : "Activate";
        var modal = new bootstrap.Modal(document.getElementById('toggleActivationModal'));
        modal.show();
    } else if (btn.classList.contains('btn-view-quiz')) {
        viewQuiz(quiz);
    } else if (btn.classList.contains('btn-edit-quiz')) {
        editQuiz(quiz);
    } else if (btn.classList.contains('btn-delete-quiz')) {
        document.getElementById('deleteQuizId').value = idx;
        document.getElementById('deleteQuizTitle').textContent = quiz.Title;
        var modal = new bootstrap.Modal(document.getElementById('deleteQuizModal'));
        modal.show();
    } else if (btn.classList.contains('btn-questions-quiz')) {
        window.location.href = `QuizQuestions.aspx?quiz=${quizzes[quizIndex].QuizID}`;
    }
});

function populateExcelQuizCourses() {
    fetch('Quizzes.aspx/GetTeacherCourses', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
.then(data => {
    const courses = JSON.parse(data.d || data); // Always parse the JSON string
    const courseSelect = document.getElementById('excelQuizCourse');
    courseSelect.innerHTML = '<option value="">Select Course</option>';
    courses.forEach(c => {
        courseSelect.innerHTML += `<option value="${c.CourseID}">${c.Title}</option>`;
    });
});
}

document.getElementById('uploadExcelModal').addEventListener('show.bs.modal', populateExcelQuizCourses);

document.getElementById('excelQuizCourse').addEventListener('change', function() {
    const courseId = document.getElementById('excelQuizCourse').value;
    const sectionSelect = document.getElementById('excelQuizSection'); // <-- ADD THIS LINE
    sectionSelect.innerHTML = '<option value="">None</option>';
    if (!courseId) {
        return;
    }
    fetch('Quizzes.aspx/GetSectionsByCourse', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ courseId })
    })
    .then(res => res.json())
    .then(data => {
        const sections = JSON.parse(data.d || data);
        sections.forEach(s => {
            sectionSelect.innerHTML += `<option value="${s.SectionID}">${s.Name}</option>`;
        });
    });
});

function executeToggleActivation() {
    const quizIndex = document.getElementById('toggleQuizId').value;
    if (quizIndex !== null && quizzes[quizIndex]) {
        // Call backend to toggle activation
        const quiz = quizzes[quizIndex];
        fetch('Quizzes.aspx/ToggleQuizActivation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ quizId: quiz.QuizID, activate: !quiz.IsActivated })
        })
        .then(res => res.json())
        .then(data => {
            // Optionally show a toast or modal here
            fetchQuizzes(); // Refresh the table
            var modal = bootstrap.Modal.getInstance(document.getElementById('toggleActivationModal'));
            if (modal) modal.hide();
        })
        .catch(() => {
            // Optionally show an error toast/modal
            var modal = bootstrap.Modal.getInstance(document.getElementById('toggleActivationModal'));
            if (modal) modal.hide();
        });
    }
}

document.getElementById('quizTableBody').addEventListener('click', function(e) {
    // ...existing handlers...

    // Delete Quiz
    if (e.target.closest('.btn-delete-quiz')) {
        const btn = e.target.closest('.btn-delete-quiz');
        const quizIndex = btn.getAttribute('data-quiz-index');
        if (quizIndex !== null && quizzes[quizIndex]) {
            document.getElementById('deleteQuizId').value = quizIndex;
            document.getElementById('deleteQuizTitle').textContent = quizzes[quizIndex].Title;
            var modal = new bootstrap.Modal(document.getElementById('deleteQuizModal'));
            modal.show();
        }
        return;
    }
    // ...rest of your handlers...
});

function confirmDeleteQuiz() {
    const quizIndex = document.getElementById('deleteQuizId').value;
    if (quizIndex !== null && quizzes[quizIndex]) {
        const quiz = quizzes[quizIndex];
        fetch('Quizzes.aspx/DeleteQuiz', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ quizId: quiz.QuizID })
        })
        .then(res => res.json())
        .then(data => {
            fetchQuizzes(); // Refresh table
            var modal = bootstrap.Modal.getInstance(document.getElementById('deleteQuizModal'));
            if (modal) modal.hide();
            document.getElementById('successMessage').textContent = "Quiz deleted successfully!";
            var successModal = new bootstrap.Modal(document.getElementById('successModal'));
            successModal.show();
        })
        .catch(() => {
            var modal = bootstrap.Modal.getInstance(document.getElementById('deleteQuizModal'));
            if (modal) modal.hide();
            document.getElementById('errorMessage').textContent = "Failed to delete quiz!";
            var errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
            errorModal.show();
        });
    }
}

document.getElementById('quizTableBody').addEventListener('click', function(e) {
    // ...existing handlers...

    // Questions (redirect)
    if (e.target.closest('.btn-questions-quiz')) {
        const btn = e.target.closest('.btn-questions-quiz');
        const quizIndex = btn.getAttribute('data-quiz-index');
        if (quizIndex !== null && quizzes[quizIndex]) {
            // Redirect to QuizQuestions.aspx with the actual QuizID
            window.location.href = `QuizQuestions.aspx?quiz=${quizzes[quizIndex].QuizID}`;
        }
        return;
    }

    // ...rest of your handlers...
});


let quizzes = [];

function fetchQuizzes() {
    document.getElementById('quizLoadingSpinner').style.display = 'flex';
    fetch('Quizzes.aspx/GetTeacherQuizzes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        quizzes = JSON.parse(data.d); // Store globally
        const tableBody = document.getElementById('quizTableBody');
        tableBody.innerHTML = '';
        if (quizzes.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="7" class="text-center py-4 text-muted">No quizzes found.</td></tr>`;
        } else {
            quizzes.forEach((quiz, idx) => {
                const statusClass = quiz.Status === 'active' ? 'success' : quiz.Status === 'draft' ? 'warning' : 'secondary';
                const typeClass = quiz.Type === 'exam' ? 'danger' : quiz.Type === 'graded' ? 'primary' : 'info';
                const activationClass = quiz.IsActivated ? 'success' : 'danger';
                const activationText = quiz.IsActivated ? 'Active' : 'Inactive';
                const startDateTime = quiz.StartDate ? quiz.StartDate : '';
                const endDateTime = quiz.EndDate ? quiz.EndDate : '';
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="quiz-icon">
                                <i class="fas fa-question-circle"></i>
                            </div>
                            <div>
                                <div class="fw-bold">${quiz.Title}</div>
                                <small class="text-muted">
                                    <span class="badge bg-${typeClass}">${quiz.Type}</span>
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
                        <span class="badge bg-info">${quiz.Duration} min</span>
                    </td>
                    <td>
                        <span class="badge bg-primary">${quiz.MaxAttempts}</span>
                    </td>
                    <td>${quiz.Questions} questions</td>
                    <td>
                        <div class="d-flex flex-column gap-1">
                            <span class="badge bg-${statusClass}">${quiz.Status}</span>
                            <span class="badge bg-${activationClass}">${activationText}</span>
                        </div>
                    </td>
                    <td>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-sm-custom btn-outline-primary btn-view-quiz" data-quiz-index="${idx}" title="View">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button type="button" class="btn btn-sm-custom btn-outline-info btn-questions-quiz"
                                data-quiz-index="${idx}" title="Questions">
                                <i class="fas fa-question"></i>
                            </button>
                            <button type="button" class="btn btn-sm-custom btn-outline-warning btn-edit-quiz" data-quiz-index="${idx}" title="Edit">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button"
                                class="btn btn-sm-custom btn-outline-${quiz.IsActivated ? 'success' : 'danger'} btn-toggle-activate"
                                data-quiz-index="${idx}" title="${quiz.IsActivated ? 'Deactivate' : 'Activate'}">
                                <i class="fas fa-${quiz.IsActivated ? 'toggle-off' : 'toggle-on'}"></i>
                            </button>
                            <button type="button"
                                class="btn btn-sm-custom btn-outline-danger btn-delete-quiz"
                                data-quiz-index="${idx}" title="Delete">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                `;
                tableBody.appendChild(row);
            });
        }
        document.getElementById('quizLoadingSpinner').style.display = 'none';
    });
}

document.addEventListener('DOMContentLoaded', function () {
    fetchQuizzes();
});


document.getElementById('addQuizForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const title = document.getElementById('quizTitle').value.trim();
    const description = document.getElementById('quizDescription').value.trim();
    const type = document.getElementById('quizType').value;
    const duration = parseInt(document.getElementById('quizDuration').value, 10);
    const maxAttempts = parseInt(document.getElementById('quizMaxAttempts').value, 10);
    const status = document.getElementById('quizStatus').value;
    const isActivated = document.getElementById('quizIsActivated').checked;
    const startDate = new Date(`${document.getElementById('quizStartDate').value}T${document.getElementById('quizStartTime').value}`);
    const endDate = new Date(`${document.getElementById('quizEndDate').value}T${document.getElementById('quizEndTime').value}`);
    const now = new Date();

// Validation: Start date/time must not be in the past
if (startDate < now) {
    showError('Start date/time must not be in the past.');
    return;
}

// Validation: Start date/time must be before end date/time
if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    showError('Please enter valid start and end dates and times.');
    return;
}
if (startDate >= endDate) {
    showError('Start date/time must be before end date/time.');
    return;
}

// Validation: Duration must not exceed the difference between start and end
const diffMinutes = (endDate - startDate) / (1000 * 60);
if (duration > diffMinutes) {
    showError(`Quiz duration (${duration} min) cannot be longer than the time window (${Math.floor(diffMinutes)} min) between start and end.`);
    return;
}

    fetch('Quizzes.aspx/AddQuiz', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, description, type, duration, maxAttempts, status, isActivated, startDate, endDate })
    })
    .then(res => res.json())
    .then(data => {
        const result = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
        if (result.success) {
            const modalEl = document.getElementById('addQuizModal');
            const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modalInstance.hide();
            fetchQuizzes();
            showSuccess('Quiz added successfully!');
            document.getElementById('addQuizForm').reset();
        } else {
            showError(result.message || 'Failed to add quiz.');
        }
    })
    .catch(() => {
        showError('Failed to add quiz.');
    });
});

function combineDateTime(date, time) {
    if (!date) return null;
    if (!time) return date;

    const dateTime = new Date(`${date}T${time}`);

    const pad = (n) => String(n).padStart(2, "0");

    const year = dateTime.getFullYear();
    const month = pad(dateTime.getMonth() + 1);
    const day = pad(dateTime.getDate());
    const hours = pad(dateTime.getHours());
    const minutes = pad(dateTime.getMinutes());
    const seconds = pad(dateTime.getSeconds());
    console.log(`Combined DateTime: ${year}-${month}-${day} ${hours}:${minutes}:${seconds}`);
    // return in SQL DATETIME format (local time)
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}


function showSuccess(msg) {
    document.getElementById('successMessage').textContent = msg;
    var modal = new bootstrap.Modal(document.getElementById('successModal'));
    modal.show();
}
function showError(msg) {
    document.getElementById('errorMessage').textContent = msg;
    var modal = new bootstrap.Modal(document.getElementById('errorModal'));
    modal.show();
}

document.getElementById('editQuizForm').addEventListener('submit', function(e) {
    e.preventDefault();
    // Get the quiz index from the modal (you can set this when opening the modal)
    const quizIndex = document.getElementById('deleteQuizId').value || 0; // Or use a hidden input for edit index
    const quiz = quizzes[quizIndex];

    const quizId = quiz.QuizID;
    const title = document.getElementById('editQuizTitle').value.trim();
    const description = document.getElementById('editQuizDescription').value.trim();
    const type = document.getElementById('editQuizType').value;
    const duration = parseInt(document.getElementById('editQuizDuration').value, 10);
    const maxAttempts = parseInt(document.getElementById('editQuizMaxAttempts').value, 10);
    const status = document.getElementById('editQuizStatus').value;
    const isActivated = document.getElementById('editQuizIsActivated').checked;
    const startDate = new Date(`${document.getElementById('editQuizStartDate').value}T${document.getElementById('editQuizStartTime').value}`);
    const endDate = new Date(`${document.getElementById('editQuizEndDate').value}T${document.getElementById('editQuizEndTime').value}`);
    const now = new Date();

// Validation: Start date/time must not be in the past
if (startDate < now) {
    showError('Start date/time must not be in the past.');
    return;
}

// Validation: Start date/time must be before end date/time
if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    showError('Please enter valid start and end dates and times.');
    return;
}
if (startDate >= endDate) {
    showError('Start date/time must be before end date/time.');
    return;
}

// Validation: Duration must not exceed the difference between start and end
const diffMinutes = (endDate - startDate) / (1000 * 60);
if (duration > diffMinutes) {
    showError(`Quiz duration (${duration} min) cannot be longer than the time window (${Math.floor(diffMinutes)} min) between start and end.`);
    return;
}


    fetch('Quizzes.aspx/EditQuiz', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ quizId, title, description, type, duration, maxAttempts, status, isActivated, startDate, endDate })
    })
    .then(res => res.json())
    .then(data => {
        const result = typeof data.d === "string" ? JSON.parse(data.d) : data.d;
        if (result.success) {
            const modalEl = document.getElementById('editQuizModal');
            const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modalInstance.hide();
            fetchQuizzes();
            showSuccess('Quiz updated successfully!');
        } else {
            showError(result.message || 'Failed to update quiz.');
        }
    })
    .catch(() => {
        showError('Failed to update quiz.');
    });
});

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
        
         function executeConfirmAction() {
            if (confirmActionCallback) {
                confirmActionCallback();
                confirmActionCallback = null;
            }
            bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
        }
</script>
</asp:Content>
