<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="QuizQuestion.aspx.cs" Inherits="Learning_Management_System.authUser.Student.QuizQuestion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<style>
		.quiz-info-card {
			background: #fff;
			border-radius: 14px;
			box-shadow: 0 2px 12px rgba(25, 118, 210, 0.10);
			padding: 2rem 2.2rem 1.5rem 2.2rem;
			margin: 2.5rem auto 2rem auto;
			max-width: 700px;
			border-left: 7px solid #1976d2;
		}
		.quiz-info-title {
			font-size: 1.5rem;
			font-weight: 700;
			color: #1976d2;
			margin-bottom: 0.5rem;
		}
		.quiz-info-meta {
			display: flex;
			flex-wrap: wrap;
			gap: 1.1rem 2.2rem;
			margin-bottom: 0.7rem;
		}
		.quiz-info-badge {
			background: #e3f2fd;
			color: #1976d2;
			border-radius: 1em;
			padding: 0.3em 1em;
			font-size: 1.01rem;
			font-weight: 500;
			margin-right: 0.5em;
		}
		.quiz-info-badge.type { background: #f0ecf9; color: #6f42c1; }
		.quiz-info-badge.attempts { background: #fff3cd; color: #856404; }
		.quiz-info-badge.done { background: #d4edda; color: #155724; }
		.quiz-info-badge.date { background: #f1f3f4; color: #495057; }
		.quiz-info-desc {
			color: #495057;
			font-size: 1.08rem;
			margin-bottom: 1.2rem;
		}
		.quiz-question-text {
			font-size: 1.25rem;
			font-weight: 600;
			color: #222e3c;
			margin-bottom: 0.7rem;
		}
		.quiz-info-actions {
			display: flex;
			gap: 1.2rem;
			margin-top: 0.7rem;
		}
		.btn-quiz {
			padding: 0.6em 1.5em;
			font-size: 1.08rem;
			border-radius: 0.5em;
			border: none;
			font-weight: 600;
			transition: background 0.2s, color 0.2s, box-shadow 0.2s;
			cursor: pointer;
			box-shadow: 0 2px 8px rgba(25, 118, 210, 0.07);
		}
		.btn-prevq {
			background: #e3f2fd;
			color: #1976d2;
		}
		.btn-prevq:disabled {
			background: #f1f3f4;
			color: #b0b0b0;
			cursor: not-allowed;
		}
		.btn-prevq:hover:not(:disabled) {
			background: #bbdefb;
			color: #0d47a1;
		}
		.btn-nextq {
			background: #1976d2;
			color: #fff;
		}
		.btn-nextq:hover {
			background: #125ea2;
			color: #fff;
		}
		.btn-submitq {
			background: #43a047;
			color: #fff;
		}
		.btn-submitq:hover {
			background: #2e7031;
			color: #fff;
		}
		.btn-review {
			background: #f8d7da;
			color: #721c24;
		}
		.btn-review:hover {
			background: #f5c6cb;
			color: #721c24;
		}
		.btn-start {
			background: #1976d2;
			color: #fff;
		}
		.btn-start:hover {
			background: #125ea2;
			color: #fff;
		}
	</style>

	<div class="quiz-info-card" id="quizInfoBlock">
		<div class="quiz-info-title" id="quizTitle"><!-- Quiz Title here --></div>
		<div class="quiz-info-meta">
			<span class="quiz-info-badge"><i class="fas fa-question-circle me-1"></i> <span id="numQuestions">--</span> Questions</span>
			<span class="quiz-info-badge date"><i class="fas fa-calendar me-1"></i> Start: <span id="startDate">--</span></span>
			<span class="quiz-info-badge date"><i class="fas fa-calendar me-1"></i> End: <span id="endDate">--</span></span>
			<span class="quiz-info-badge type"><i class="fas fa-tag me-1"></i> <span id="quizType">--</span></span>
			<span class="quiz-info-badge"><i class="fas fa-clock me-1"></i> <span id="duration">--</span> min</span>
			<span class="quiz-info-badge attempts"><i class="fas fa-redo me-1"></i> Max Attempts: <span id="maxAttempts">--</span></span>
			<span class="quiz-info-badge done"><i class="fas fa-check-double me-1"></i> Attempts Done: <span id="attemptsDone">--</span></span>
		</div>
		<div class="quiz-info-desc" id="quizDescription"><!-- Quiz Description here --></div>
		<div class="quiz-info-actions">
			<button class="btn-quiz btn-review" id="btnReviewAnswer" style="display:none;" onclick="window.location.href='QuizAnswer.aspx?quizId='+getQuizId()">Review Answer</button>
			<button class="btn-quiz btn-start" id="btnStartQuiz">Start Quiz</button>
		</div>
	</div>

	<div id="quizQuestionsBlock" style="display:none; max-width: 700px; margin: 0 auto;">
		<div class="quiz-info-card" id="quizActiveBlock" style="margin-bottom:2rem;">
			<div class="quiz-info-title" id="activeQuizTitle"></div>
			<div class="quiz-info-meta">
				<span class="quiz-info-badge type"><i class="fas fa-tag me-1"></i> <span id="activeQuizType"></span></span>
				<span class="quiz-info-badge"><i class="fas fa-clock me-1"></i> <span id="activeQuizDuration"></span> min</span>
				<span class="quiz-info-badge"><i class="fas fa-question-circle me-1"></i> <span id="activeNumQuestions"></span> Questions</span>
			</div>
			<div class="quiz-info-desc" id="activeQuizDescription"></div>
			<div class="quiz-timer-block" style="display:flex;align-items:center;gap:1rem;margin-top:1.2rem;">
				<span style="font-size:1.2rem;color:#1976d2;font-weight:600;"><i class='fas fa-stopwatch'></i> Time Left:</span>
				<span id="quizTimer" style="font-size:1.3rem;font-weight:700;color:#d32f2f;">--:--</span>
			</div>
		</div>
		<div id="quizQuestionsArea">
			<div class="alert alert-info">[Quiz questions will appear here]</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
		var currentQuestionIndex = 0;
		var totalQuestions = 0;
		var quizDuration = 0;
		var quizTimerInterval = null;
		var userAnswers = {}; // { questionId: answer }

		function getQuizId() {
			const urlParams = new URLSearchParams(window.location.search);
			return urlParams.get('quizId');
		}

		function loadQuizInfoAjax() {
			var quizId = getQuizId();
			$.ajax({
				type: 'POST',
				url: 'QuizQuestion.aspx/GetQuizInfo',
				data: JSON.stringify({ quizId: quizId }),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function (res) {
					var info = res.d ? (typeof res.d === 'string' ? JSON.parse(res.d) : res.d) : {};
					$('#quizTitle').text(info.Title);
					$('#numQuestions').text(info.NumQuestions);
					$('#startDate').text(info.StartDate);
					$('#endDate').text(info.EndDate);
					$('#maxAttempts').text(info.MaxAttempts);
					$('#attemptsDone').text(info.AttemptsDone);
					$('#quizType').text(info.Type);
					$('#duration').text(info.Duration);
					$('#quizDescription').text(info.Description);
					if (parseInt(info.AttemptsDone) > 0) {
						$('#btnReviewAnswer').show();
					} else {
						$('#btnReviewAnswer').hide();
					}
					// Hide Start Quiz button if max attempts reached
					if (parseInt(info.AttemptsDone) >= parseInt(info.MaxAttempts)) {
						$('#btnStartQuiz').hide();
					} else {
						$('#btnStartQuiz').show();
						// Disable Start Quiz if not within date range
						var now = new Date();
						var startDate = new Date(info.StartDate);
						var endDate = new Date(info.EndDate);
						// Set time to end of day for endDate
						endDate.setHours(23,59,59,999);
						if (now < startDate || now > endDate) {
							$('#btnStartQuiz').prop('disabled', true);
							if (now < startDate) {
								if ($('#quizDateMsg').length === 0) {
									$('<div id="quizDateMsg" class="alert alert-warning mt-2">Quiz is not yet available. Please check back after the start date.</div>').insertAfter('#btnStartQuiz');
								}
							} else if (now > endDate) {
								if ($('#quizDateMsg').length === 0) {
									$('<div id="quizDateMsg" class="alert alert-danger mt-2">Quiz is no longer available. The end date has passed.</div>').insertAfter('#btnStartQuiz');
								}
							}
						} else {
							$('#btnStartQuiz').prop('disabled', false);
							$('#quizDateMsg').remove();
						}
					}
					totalQuestions = parseInt(info.NumQuestions) || 0;
					quizDuration = parseInt(info.Duration) || 30;
				},
				error: function () {
					alert('Failed to load quiz info.');
				}
			});
		}

		function showQuizBlock() {
			// Copy info to active block
			$('#activeQuizTitle').text($('#quizTitle').text());
			$('#activeQuizType').text($('#quizType').text());
			$('#activeQuizDuration').text($('#duration').text());
			$('#activeNumQuestions').text($('#numQuestions').text());
			$('#activeQuizDescription').text($('#quizDescription').text());
		}

		// Save the current answer to userAnswers
		function saveCurrentAnswer() {
			var qid = $('#currentQuestionId').val();
			if (!qid) return;
			var selected = $("input[name='questionOption']:checked").val();
			var text = $("textarea[name='shortAnswer']").val();
			if (selected !== undefined) {
				userAnswers[qid] = selected;
			} else if (text !== undefined) {
				userAnswers[qid] = text;
			}
		}

		function submitQuizAnswers() {
			// You can add validation here if needed
			var quizId = getQuizId();
			$.ajax({
				type: 'POST',
				url: 'QuizQuestion.aspx/SubmitQuiz',
				data: JSON.stringify({ quizId: quizId, answers: userAnswers }),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function (res) {
					Swal.fire({
						title: 'Quiz Submitted!',
						text: 'Your answers have been submitted successfully.',
						icon: 'success',
						confirmButtonText: 'OK'
					}).then(function() {
						var quizId = getQuizId();
						var urlParams = new URLSearchParams(window.location.search);
						var status = urlParams.get('status') || 'submitted';
						window.location.href = 'QuizSubmited.aspx?quizId=' + quizId + '&status=' + status;
					});
				},
				error: function () {
					Swal.fire({
						title: 'Submission Failed',
						text: 'Failed to submit quiz. Please try again.',
						icon: 'error',
						confirmButtonText: 'OK'
					});
				}
			});
		}

		function loadQuestion(index) {
			// Save current answer before loading next
			saveCurrentAnswer();
			var quizId = getQuizId();
			$.ajax({
				type: 'POST',
				url: 'QuizQuestion.aspx/GetQuizQuestion',
				data: JSON.stringify({ quizId: quizId, questionIndex: index }),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function (res) {
					var q = res.d ? (typeof res.d === 'string' ? JSON.parse(res.d) : res.d) : null;
					if (!q) {
						$('#quizQuestionsArea').html('<div class="alert alert-warning">No more questions.</div>');
						return;
					}
					var html = '';
					html += '<div class="card mb-3">';
					html += '<div class="card-body">';
					html += '<div class="mb-2 quiz-question-text"><b>Question ' + (index + 1) + ':</b> ' + q.QuestionText + '</div>';
					if (q.QuestionType === 'multiple-choice' && q.Options && q.Options.length > 0) {
						html += '<div class="mb-2">';
						q.Options.forEach(function(opt) {
							html += '<div class="form-check mb-1">';
							html += '<input class="form-check-input" type="radio" name="questionOption" id="opt_' + opt.OptionId + '" value="' + opt.OptionId + '">';
							html += '<label class="form-check-label" for="opt_' + opt.OptionId + '"><b>' + (opt.OptionLabel ? opt.OptionLabel + '.' : '') + '</b> ' + opt.OptionText + '</label>';
							html += '</div>';
						});
						html += '</div>';
					} else if (q.QuestionType === 'true-false') {
						html += '<div class="mb-2">';
						html += '<div class="form-check mb-1">';
						html += '<input class="form-check-input" type="radio" name="questionOption" id="opt_true" value="True">';
						html += '<label class="form-check-label" for="opt_true"><b>True</b></label>';
						html += '</div>';
						html += '<div class="form-check mb-1">';
						html += '<input class="form-check-input" type="radio" name="questionOption" id="opt_false" value="False">';
						html += '<label class="form-check-label" for="opt_false"><b>False</b></label>';
						html += '</div>';
						html += '</div>';
					} else if (q.QuestionType === 'short-answer' || q.QuestionType === 'essay') {
						html += '<textarea class="form-control" rows="4" name="shortAnswer" placeholder="Type your answer here..."></textarea>';
					}
					// Store questionId for answer tracking
					html += '<input type="hidden" id="currentQuestionId" value="' + q.QuestionId + '" />';
					   html += '<div class="d-flex justify-content-between mt-3">';
					   html += '<button class="btn btn-quiz btn-prevq" id="btnPrevQ" ' + (index === 0 ? 'disabled' : '') + '>⟵ Previous</button>';
					   if (index === totalQuestions - 1) {
						   html += '<button class="btn btn-quiz btn-submitq" id="btnSubmitQ">Submit</button>';
					   } else {
						   html += '<button class="btn btn-quiz btn-nextq" id="btnNextQ">Next ⟶</button>';
					   }
					   html += '</div>';
					html += '</div></div>';
					$('#quizQuestionsArea').html(html);
					// Navigation handlers
					   $('#btnPrevQ').off('click').on('click', function() {
						   if (currentQuestionIndex > 0) {
							   currentQuestionIndex--;
							   loadQuestion(currentQuestionIndex);
						   }
					   });
					   $('#btnNextQ').off('click').on('click', function() {
						   if (currentQuestionIndex < totalQuestions - 1) {
							   currentQuestionIndex++;
							   loadQuestion(currentQuestionIndex);
						   }
					   });
					   // Submit button handler
					   $('#btnSubmitQ').off('click').on('click', function() {
						   alert('Quiz submitted! (Implement submission logic)');
					   });
				   // Restore previous answer if any
				   var qid = q.QuestionId;
				   if (userAnswers[qid]) {
					   if (q.QuestionType === 'multiple-choice') {
						   $("input[name='questionOption'][value='" + userAnswers[qid] + "']").prop('checked', true);
					   } else if (q.QuestionType === 'true-false') {
						   $("input[name='questionOption'][value='" + userAnswers[qid] + "']").prop('checked', true);
					   } else if (q.QuestionType === 'short-answer' || q.QuestionType === 'essay') {
						   $("textarea[name='shortAnswer']").val(userAnswers[qid]);
					   }
				   }
				   $('#btnPrevQ').off('click').on('click', function() {
					   saveCurrentAnswer();
					   if (currentQuestionIndex > 0) {
						   currentQuestionIndex--;
						   loadQuestion(currentQuestionIndex);
					   }
				   });
				   $('#btnNextQ').off('click').on('click', function() {
					   saveCurrentAnswer();
					   if (currentQuestionIndex < totalQuestions - 1) {
						   currentQuestionIndex++;
						   loadQuestion(currentQuestionIndex);
					   }
				   });
				   // Submit button handler
				   $('#btnSubmitQ').off('click').on('click', function() {
					   saveCurrentAnswer();
					   submitQuizAnswers();
				   });
		// Save the current answer to userAnswers
		function saveCurrentAnswer() {
			var qid = $('#currentQuestionId').val();
			if (!qid) return;
			var selected = $("input[name='questionOption']:checked").val();
			var text = $("textarea[name='shortAnswer']").val();
			if (selected !== undefined) {
				userAnswers[qid] = selected;
			} else if (text !== undefined) {
				userAnswers[qid] = text;
			}
		}

				},
				error: function () {
					$('#quizQuestionsArea').html('<div class="alert alert-danger">Failed to load question.</div>');
				}
			});
		}

		function startQuizTimer(minutes) {
			var totalSeconds = minutes * 60;
			var timerDisplay = document.getElementById('quizTimer');
			if (quizTimerInterval) clearInterval(quizTimerInterval);
			timerDisplay.textContent = `${minutes}:00`;
			quizTimerInterval = setInterval(function() {
				var min = Math.floor(totalSeconds / 60);
				var sec = totalSeconds % 60;
				timerDisplay.textContent = `${min}:${sec.toString().padStart(2, '0')}`;
				if (totalSeconds <= 0) {
					clearInterval(quizTimerInterval);
					timerDisplay.textContent = 'Time Up!';
					// Auto-submit and disable all inputs
					setTimeout(function() {
						saveCurrentAnswer();
						submitQuizAnswers();
						disableQuizInputs();
					}, 500);
				}
				totalSeconds--;
			}, 1000);
		}

		function disableQuizInputs() {
			// Disable all answer inputs and navigation buttons
			$('#quizQuestionsBlock input, #quizQuestionsBlock textarea, #quizQuestionsBlock button').prop('disabled', true);
			// Optionally show a message
			$('#quizQuestionsArea').prepend('<div class="alert alert-warning">Time is up! Your answers have been submitted.</div>');
		}

		$(document).ready(function() {
			loadQuizInfoAjax();
			$('#btnStartQuiz').on('click', function() {
				$('#quizInfoBlock').hide();
				$('#quizQuestionsBlock').show();
				showQuizBlock();
				currentQuestionIndex = 0;
				loadQuestion(currentQuestionIndex);
				startQuizTimer(quizDuration);
			});
		});
	</script>
</asp:Content>
