<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="QuizQuestions.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.QuizQuestions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

   
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    

<style>

        
        .modal-header {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
            <%-- border-radius: 15px 15px 0 0; --%>
        }
        
        .btn-close-white {
            filter: brightness(0) invert(1);
        }
        .quiz-questions-header {
            background: linear-gradient(90deg, #2c2b7c 0%, #1e7e34 100%);
            color: #fff;
            border-radius: 1rem 1rem 0 0;
            padding: 2rem 2rem 1rem 2rem;
            box-shadow: 0 4px 24px rgba(44,43,124,0.08);
            animation: fadeInDown 0.7s;
        }
        .quiz-questions-title {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .quiz-questions-meta {
            font-size: 1.1rem;
            margin-top: 0.5rem;
            color: #e0e0e0;
        }
        .questions-list {
            animation: fadeInUp 0.8s;
        }
        .question-card {
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 2px 12px rgba(44,43,124,0.07);
            margin-bottom: 1.5rem;
            padding: 1.5rem 2rem;
            transition: box-shadow 0.3s;
            border-left: 6px solid #2c2b7c;
            position: relative;
        }
        .question-card:hover {
            box-shadow: 0 6px 24px rgba(44,43,124,0.13);
        }
        .question-type-badge {
            position: absolute;
            top: 1.2rem;
            right: 2rem;
            font-size: 0.95rem;
        }
        .question-actions {
            margin-top: 1rem;
        }
        .question-actions .btn {
            margin-right: 0.5rem;
        }
        .add-question-btn {
            position: fixed;
            bottom: 2.5rem;
            right: 2.5rem;
            z-index: 100;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            font-size: 2rem;
            box-shadow: 0 4px 16px rgba(44,43,124,0.18);
            background: linear-gradient(135deg, #2c2b7c 60%, #1e7e34 100%);
            color: #fff;
            transition: background 0.3s, transform 0.2s;
            animation: bounceIn 0.8s;
        }
        .add-question-btn:hover {
            background: linear-gradient(135deg, #1e7e34 60%, #2c2b7c 100%);
            transform: scale(1.08);
            color: #fff;
        }
        .questions-loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 180px;
            animation: fadeIn 0.7s;
        }
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeIn {
            from { opacity: 0;}
            to { opacity: 1;}
        }
        @keyframes bounceIn {
            0% { transform: scale(0.5);}
            60% { transform: scale(1.1);}
            80% { transform: scale(0.95);}
            100% { transform: scale(1);}
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <div class="quiz-questions-header mb-4">
        <div class="quiz-questions-title"><i class="fas fa-question-circle me-2"></i>Quiz Questions</div>
        <div class="quiz-questions-meta" id="quizMeta">
            <!-- Quiz meta info will be loaded here (e.g., title, type, total questions) -->
        </div>
    
    </div>

 <button class="btn add-question-btn shadow" title="Add Question" id="addQuestionBtn" style="position: fixed; bottom: 2.5rem; right: 2.5rem; z-index: 100;">
    <i class="fas fa-plus"></i>
</button>

    <div id="questionsLoading" class="questions-loading">
        <div class="spinner-border text-primary mb-3" style="width:2.5rem; height:2.5rem;"></div>
        <div class="text-muted">Loading questions, please wait...</div>
    </div>
    <div class="questions-list" id="questionsList" style="display:none;">
        <!-- Question cards will be injected here by JS -->
    </div>
    <%-- <button class="btn add-question-btn shadow" title="Add Question" id="addQuestionBtn">
        <i class="fas fa-plus"></i>
    </button> --%>
    <!-- Add Question Modal Placeholder -->
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


<!-- Success Modal -->
<div class="modal fade" id="successModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title"><i class="fas fa-check-circle me-2"></i>Success</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div id="successMessage" class="text-success"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-bs-dismiss="modal">OK</button>
      </div>
    </div>
  </div>
</div>

<!-- Error Modal -->
<div class="modal fade" id="errorModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Error</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div id="errorMessage" class="text-danger"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">OK</button>
      </div>
    </div>
  </div>
</div>


<script>
let questions = [];

function fetchQuizQuestions() {
    if (!quizId) {
        document.getElementById('questionsLoading').innerHTML = '<div class="text-danger">Quiz ID not found in URL.</div>';
        return;
    }
    fetch('QuizQuestions.aspx/GetQuizQuestions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ quizId: parseInt(quizId, 10) })
    })
    .then(res => res.json())
    .then(data => {
        questions = JSON.parse(data.d || data);
        document.getElementById('questionsLoading').style.display = 'none';
        document.getElementById('questionsList').style.display = '';
        renderQuestions();
    })
    .catch(() => {
        document.getElementById('questionsLoading').innerHTML = '<div class="text-danger">Failed to load questions.</div>';
    });
}

document.addEventListener('DOMContentLoaded', fetchQuizQuestions);

function getTypeLabel(type) {
    switch (type) {
        case 'multiple-choice': return 'Multiple Choice';
        case 'true-false': return 'True/False';
        case 'short-answer': return 'Short Answer';
        case 'essay': return 'Essay';
        default: return type;
    }
}
// Render questions list
function renderQuestions() {
     const list = document.getElementById('questionsList');
    list.innerHTML = '';
    if (!Array.isArray(questions)) {
        list.innerHTML = '<div class="alert alert-warning">No questions found or failed to load questions.</div>';
        return;
    }
    questions.forEach((q, i) => {
        let optionsHtml = '';
       if (q.type === "multiple-choice" && q.options) {
            optionsHtml = `<div class="mb-2"> ${
                Object.entries(q.options).map(([key, opt]) =>
                    `<div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="question${i}" id="q${i}opt${key}" value="${key}" ${key === q.answer ? 'checked' : ''} disabled>
                        <label class="form-check-label${key === q.answer ? ' fw-bold text-success' : ''}" for="q${i}opt${key}">${key}: ${opt}</label>
                    </div>`
                ).join('')
            }
            </div>`;
        }
        list.innerHTML += `
            <div class="question-card position-relative animate__animated animate__fadeInUp">
                <span class="badge bg-primary question-type-badge">${getTypeLabel(q.type)}</span>
                <span class="badge bg-info ms-2">${q.points} Point${q.points > 1 ? 's' : ''}</span>
                <span class="badge bg-warning text-dark ms-2">${q.difficulty} Difficulty</span>
                <div class="fw-semibold mb-2"><i class="fa fa-question me-2 text-primary"></i>Q${i + 1}: ${q.text}</div>
                ${optionsHtml}
                ${q.type !== "multiple-choice" ? `<div class="mb-2"><span class="fw-bold text-success">Answer:</span> ${q.answer}</div>` : ''}
                <div class="question-actions">
                    <button class="btn btn-outline-info btn-sm me-2"><i class="fa fa-eye"></i> View</button>
                    <button class="btn btn-outline-warning btn-sm me-2"><i class="fa fa-edit"></i> Edit</button>
                    <button class="btn btn-outline-danger btn-sm"><i class="fa fa-trash"></i> Delete</button>
                </div>
            </div>
        `;
    });
    // Update meta
    document.getElementById('quizMeta').innerHTML = `
        <span><i class="fa fa-book-open me-1"></i>Quiz: <b>Intro to Programming</b></span>
        <span class="mx-3"><i class="fa fa-list-ul me-1"></i>Type: <b>${questions[0]?.quizType.toUpperCase() || 'TEST'}</b></span>
        <span class="mx-3"><i class="fa fa-hashtag me-1"></i>Total Questions: <b>${questions.length}</b></span>
    `;
}

// Show Add Question modal
document.getElementById('addQuestionBtn').addEventListener('click', function () {
    document.getElementById('addQuestionForm').reset();
    toggleAnswerFields();
    var modal = new bootstrap.Modal(document.getElementById('addQuestionModal'));
    modal.show();
});

// Toggle answer fields based on type
function toggleAnswerFields() {
    const type = document.getElementById('questionType').value;
    document.getElementById('multipleChoiceOptions').style.display = (type === 'multiple-choice') ? '' : 'none';
    document.getElementById('trueFalseOptions').style.display = (type === 'true-false') ? '' : 'none';
    document.getElementById('textAnswerOptions').style.display = (type === 'short-answer' || type === 'essay') ? '' : 'none';
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

// Add Question logic
function addQuestion() {
    const type = document.getElementById('questionType').value;
    const text = document.getElementById('questionText').value.trim();
    const points = parseInt(document.getElementById('questionPoints').value, 10);
    const difficulty = document.getElementById('questionDifficulty').value;
    let answer = '';
    let options = undefined;

    if (type === 'multiple-choice') {
        options = {
            A: document.getElementById('optionA').value.trim(),
            B: document.getElementById('optionB').value.trim(),
            C: document.getElementById('optionC').value.trim(),
            D: document.getElementById('optionD').value.trim()
        };
        const correct = document.querySelector('input[name="correctAnswer"]:checked');
        if (!correct) {
            showError('Please select the correct answer.');
            return;
        }
        answer = correct.value;
    } else if (type === 'true-false') {
        const tf = document.querySelector('input[name="tfAnswer"]:checked');
        if (!tf) {
            showError('Please select True or False.');
            return;
        }
        answer = tf.value === "true" ? "True" : "False";
    } else {
        answer = document.getElementById('correctAnswer').value.trim();
    }

    if (!text) {
        showError('Question text is required.');
        return;
    }

    fetch('QuizQuestions.aspx/AddQuizQuestion', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            quizId: parseInt(quizId, 10),
            text,
            type: type === 'multiple-choice' ? 'multiple-choice'
                : type === 'true-false' ? 'true-false'
                : type === 'short-answer' ? 'short-answer'
                : 'essay',
            points,
            difficulty,
            explanation: document.getElementById('questionExplanation').value.trim(),
            options: type === 'multiple-choice' ? JSON.stringify(options) : "",
            answer
        })
    })
    .then(res => res.json())
    .then(data => {
    let result;
    if (typeof data.d === "string") {
        result = JSON.parse(data.d);
    } else if (typeof data.d === "object") {
        result = data.d;
    } else {
        result = data;
    }
    if (result.success) {
        fetchQuizQuestions();
        var modal = bootstrap.Modal.getInstance(document.getElementById('addQuestionModal'));
        if (modal) modal.hide();
        showSuccess('Question added successfully!');
    } else {
        showError('Failed to add question.');
    }
})
    .catch(() => showError('Failed to add question.'));
}

// Initial load
document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
        document.getElementById('questionsLoading').style.display = 'none';
        document.getElementById('questionsList').style.display = '';
        renderQuestions();
    }, 1200);
});

// Event delegation for Edit button
document.getElementById('questionsList').addEventListener('click', function(e) {
    if (e.target.closest('.btn-outline-warning')) {
        const card = e.target.closest('.question-card');
        const idx = Array.from(document.querySelectorAll('.question-card')).indexOf(card);
        openEditQuestionModal(idx);
    }
});

// Open Edit Question Modal and populate fields
function openEditQuestionModal(idx) {
    const q = questions[idx];
    document.getElementById('editQuestionId').value = idx;
    document.getElementById('editQuestionText').value = q.text || '';
    document.getElementById('editQuestionType').value = 
        q.type === 'multiple-choice' ? 'multiple-choice' :
        q.type === 'true-false' ? 'true-false' :
        q.type === 'short-answer' ? 'short-answer' : 'essay';
    document.getElementById('editQuestionPoints').value = q.points || 1;
    document.getElementById('editQuestionDifficulty').value = q.difficulty || 'easy';

    toggleEditAnswerFields();

    // Fill answer fields
    if (q.type === 'multiple-choice' && q.options) {
        document.getElementById('editOptionA').value = q.options.A || '';
        document.getElementById('editOptionB').value = q.options.B || '';
        document.getElementById('editOptionC').value = q.options.C || '';
        document.getElementById('editOptionD').value = q.options.D || '';
        // Set correct answer radio
        if (q.answer) {
            document.querySelector(`input[name="editCorrectAnswer"][value="${q.answer}"]`).checked = true;
        }
    } else if (q.type === 'true-false') {
        document.getElementById('editTfTrue').checked = q.answer === "True";
        document.getElementById('editTfFalse').checked = q.answer === "False";
    } else {
        document.getElementById('editQuestionExplanation').value = q.explanation || '';
        document.getElementById('correctAnswer').value = q.answer || '';
    }

    var modal = new bootstrap.Modal(document.getElementById('editQuestionModal'));
    modal.show();
}

// Toggle answer fields for edit modal
function toggleEditAnswerFields() {
    const type = document.getElementById('editQuestionType').value;
    document.getElementById('editMultipleChoiceOptions').style.display = (type === 'multiple-choice') ? '' : 'none';
    document.getElementById('editTrueFalseOptions').style.display = (type === 'true-false') ? '' : 'none';
    // For short-answer/essay, show only explanation and correct answer
}

// Update question in array and re-render
function updateQuestion() {
    const idx = parseInt(document.getElementById('editQuestionId').value, 10);
    const q = questions[idx];
    const type = document.getElementById('editQuestionType').value;
    const text = document.getElementById('editQuestionText').value.trim();
    const points = parseInt(document.getElementById('editQuestionPoints').value, 10);
    const difficulty = document.getElementById('editQuestionDifficulty').value;
    let answer = '';
    let options = undefined;

    if (type === 'multiple-choice') {
        options = {
            A: document.getElementById('editOptionA').value.trim(),
            B: document.getElementById('editOptionB').value.trim(),
            C: document.getElementById('editOptionC').value.trim(),
            D: document.getElementById('editOptionD').value.trim()
        };
        const correct = document.querySelector('input[name="editCorrectAnswer"]:checked');
        if (!correct) {
            showSuccess('Please select the correct answer.');
            return;
        }
        answer = correct.value;
    } else if (type === 'true-false') {
        const tf = document.querySelector('input[name="editTfAnswer"]:checked');
        if (!tf) {
            showSuccess('Please select True or False.');
            return;
        }
        answer = tf.value === "true" ? "True" : "False";
    } else {
        answer = document.getElementById('correctAnswer').value.trim();
    }

    if (!text) {
        showSuccess('Question text is required.');
        return;
    }

    fetch('QuizQuestions.aspx/EditQuizQuestion', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            questionId: q.id,
            text,
            type: type === 'multiple-choice' ? 'multiple-choice'
                : type === 'true-false' ? 'true-false'
                : type === 'short-answer' ? 'short-answer'
                : 'essay',
            points,
            difficulty,
            explanation: document.getElementById('editQuestionExplanation').value.trim(),
            options: type === 'multiple-choice' ? JSON.stringify(options) : "",
            answer
        })
    })
    .then(res => res.json())
    .then(data => {
    let result;
    if (typeof data.d === "string") {
        result = JSON.parse(data.d);
    } else if (typeof data.d === "object") {
        result = data.d;
    } else {
        result = data;
    }
    if (result.success) {
        fetchQuizQuestions();
        var modal = bootstrap.Modal.getInstance(document.getElementById('editQuestionModal'));
        if (modal) modal.hide();
        showSuccess('Question updated successfully!');
    } else {
        showError('Failed to update question.');
    }
})
    .catch(() => showError('Failed to update question.'));
}

// Event delegation for View button
document.getElementById('questionsList').addEventListener('click', function(e) {
    if (e.target.closest('.btn-outline-info')) {
        const card = e.target.closest('.question-card');
        const idx = Array.from(document.querySelectorAll('.question-card')).indexOf(card);
        openViewQuestionModal(idx);
    }
});

// Open View Question Modal and populate fields
function openViewQuestionModal(idx) {
    const q = questions[idx];
    document.getElementById('viewQuestionText').innerHTML = q.text || '';
    document.getElementById('viewQuestionType').textContent = getTypeLabel(q.type) || '';
    document.getElementById('viewQuestionPoints').textContent = q.points || 1;
    document.getElementById('viewQuestionDifficulty').textContent = q.difficulty || '';
    document.getElementById('viewQuestionNumber').textContent = idx + 1;

    // Render options/answer
    let optionsHtml = '';
    if (q.type === "multiple-choice" && q.options) {
    optionsHtml = `<div class="mb-2"> ${
        Object.entries(q.options).map(([key, opt]) =>
            `<div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="viewQuestion${idx}" id="viewQ${idx}opt${key}" value="${key}" ${key === q.answer ? 'checked' : ''} disabled>
                <label class="form-check-label${key === q.answer ? ' fw-bold text-success' : ''}" for="viewQ${idx}opt${key}">${key}: ${opt}</label>
            </div>`
        ).join('')
    }
    </div>`;
} else if (q.type === "true-false") {
        optionsHtml = `<div class="mb-2">
            <span class="badge bg-secondary">Answer: </span>
            <span class="fw-bold text-success ms-2">${q.answer}</span>
        </div>`;
    } else {
        optionsHtml = `<div class="mb-2"><span class="fw-bold text-success">Answer:</span> ${q.answer}</div>`;
    }
    document.getElementById('viewQuestionOptions').innerHTML = optionsHtml;

    // Explanation
    if (q.explanation && q.explanation.trim() !== "") {
        document.getElementById('explanationText').textContent = q.explanation;
        document.getElementById('viewQuestionExplanation').style.display = '';
    } else {
        document.getElementById('viewQuestionExplanation').style.display = 'none';
    }

    var modal = new bootstrap.Modal(document.getElementById('viewQuestionModal'));
    modal.show();
}

// Optional: Edit from View modal
function editQuestionFromView() {
    const idx = parseInt(document.getElementById('viewQuestionNumber').textContent, 10) - 1;
    openEditQuestionModal(idx);
    var modal = bootstrap.Modal.getInstance(document.getElementById('viewQuestionModal'));
    if (modal) modal.hide();
}

// Event delegation for Delete button
document.getElementById('questionsList').addEventListener('click', function(e) {
    if (e.target.closest('.btn-outline-danger')) {
        const card = e.target.closest('.question-card');
        const idx = Array.from(document.querySelectorAll('.question-card')).indexOf(card);
        openDeleteQuestionModal(idx);
    }
});

// Open Delete Question Modal and set up for confirmation
function openDeleteQuestionModal(idx) {
    document.getElementById('deleteQuestionId').value = idx;
    document.getElementById('deleteQuestionNumber').textContent = idx + 1;
    var modal = new bootstrap.Modal(document.getElementById('deleteQuestionModal'));
    modal.show();
}

function confirmDeleteQuestion() {
    const idx = parseInt(document.getElementById('deleteQuestionId').value, 10);
    const q = questions[idx];
    if (!q) return;

    fetch('QuizQuestions.aspx/DeleteQuizQuestion', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ questionId: q.id })
    })
    .then(res => res.json())
    .then(data => {
    let result;
    if (typeof data.d === "string") {
        result = JSON.parse(data.d);
    } else if (typeof data.d === "object") {
        result = data.d;
    } else {
        result = data;
    }
    if (result.success) {
        fetchQuizQuestions();
        var modal = bootstrap.Modal.getInstance(document.getElementById('deleteQuestionModal'));
        if (modal) modal.hide();
        showSuccess('Question deleted successfully!');
    } else {
        showError('Failed to delete question.');
    }
})
    .catch(() => showError('Failed to delete question.'));
}

function getQuizIdFromUrl() {
    const params = new URLSearchParams(window.location.search);
    return params.get('quiz');
}
const quizId = getQuizIdFromUrl();


</script>

</asp:Content>
