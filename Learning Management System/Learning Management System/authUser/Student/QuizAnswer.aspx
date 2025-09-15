<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="QuizAnswer.aspx.cs" Inherits="Learning_Management_System.authUser.Student.QuizAnswer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<style>
		.quiz-header {
			background: linear-gradient(90deg, #1976d2 60%, #43a047 100%);
			color: #fff;
			border-radius: 14px 14px 0 0;
			padding: 2rem 2.5rem 1.5rem 2.5rem;
			margin: 2.5rem auto 0 auto;
			max-width: 800px;
			box-shadow: 0 2px 12px rgba(25, 118, 210, 0.10);
		}
		.quiz-title {
			font-size: 2rem;
			font-weight: 700;
			margin-bottom: 0.5rem;
		}
		.quiz-meta {
			display: flex;
			flex-wrap: wrap;
			gap: 1.1rem 2.2rem;
			margin-bottom: 0.7rem;
		}
		.quiz-badge {
			background: #fff;
			color: #1976d2;
			border-radius: 1em;
			padding: 0.3em 1em;
			font-size: 1.08rem;
			font-weight: 500;
		}
		.quiz-badge.type { color: #6f42c1; }
		.quiz-badge.score { color: #d32f2f; font-weight: 700; }
		.quiz-badge.attempt { color: #388e3c; }
		.quiz-desc {
			color: #f1f1f1;
			font-size: 1.15rem;
			margin-bottom: 1.2rem;
		}
		.question-block {
			background: #fff;
			border-radius: 0 0 14px 14px;
			box-shadow: 0 2px 12px rgba(25, 118, 210, 0.10);
			margin: 0 auto 2rem auto;
			max-width: 800px;
			padding: 2rem 2.5rem 2rem 2.5rem;
		}
		.question-title {
			font-size: 1.18rem;
			font-weight: 600;
			color: #1976d2;
			margin-bottom: 0.5rem;
		}
		.answer-label {
			font-weight: 700;
			color: #222e3c;
		}
		.user-answer {
			color: #1565c0;
			font-size: 1.08rem;
			margin-bottom: 0.3rem;
		}
		.correct-answer {
			color: #388e3c;
			font-size: 1.08rem;
			margin-bottom: 0.7rem;
		}
		.wrong-answer {
			color: #d32f2f;
			font-size: 1.08rem;
			margin-bottom: 0.7rem;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="quiz-header">
		<div class="quiz-title" id="quizTitle"></div>
		<div class="quiz-meta">
			<span class="quiz-badge type" id="quizType"></span>
			<span class="quiz-badge score" id="quizScore"></span>
			<span class="quiz-badge attempt" id="quizAttempt"></span>
		</div>
		<div class="quiz-desc" id="quizDescription"></div>
	</div>
	<div id="questionsContainer"></div>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(document).ready(function() {
			var urlParams = new URLSearchParams(window.location.search);
			var quizId = urlParams.get('quizId');
			// Fetch quiz info and submission
			$.ajax({
				type: 'POST',
				url: 'QuizQuestion.aspx/GetQuizInfo',
				data: JSON.stringify({ quizId: quizId }),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function(res) {
					var info = res.d ? (typeof res.d === 'string' ? JSON.parse(res.d) : res.d) : {};
					$('#quizTitle').text(info.Title);
					$('#quizType').text(info.Type);
					$('#quizDescription').text(info.Description);
					// Fetch latest submission for score and attempt
					$.ajax({
						type: 'POST',
						url: 'QuizAnswer.aspx/GetSubmissionDetail',
						data: JSON.stringify({ quizId: quizId }),
						contentType: 'application/json; charset=utf-8',
						dataType: 'json',
						success: function(res2) {
							var sub = res2.d ? (typeof res2.d === 'string' ? JSON.parse(res2.d) : res2.d) : {};
							$('#quizScore').text('Score: ' + (sub.Score !== undefined ? sub.Score : '--'));
							$('#quizAttempt').text('Attempt: ' + (sub.Attempt !== undefined ? sub.Attempt : '--'));
							// Render questions and answers
							var html = '';
							if (sub.Questions && sub.Questions.length > 0) {
								sub.Questions.forEach(function(q, idx) {
									html += '<div class="question-block">';
									html += '<div class="question-title">Q' + (idx+1) + ': ' + q.QuestionText + ' <span style="font-size:1rem;font-weight:400;color:#888;">(' + (q.Points || '1') + ' pt)</span></div>';
									html += '<div class="answer-label">Your Answer:</div>';
									if (q.UserAnswer === q.CorrectAnswer) {
										html += '<div class="user-answer">' + (q.UserAnswer || '<i>No answer</i>') + '</div>';
									} else {
										html += '<div class="wrong-answer">' + (q.UserAnswer || '<i>No answer</i>') + '</div>';
									}
									html += '<div class="answer-label">Correct Answer:</div>';
									html += '<div class="correct-answer">' + (q.CorrectAnswer || '<i>No correct answer set</i>') + '</div>';
									if (q.Explanation) {
										html += '<div class="answer-label" style="margin-top:0.7rem;">Explanation:</div>';
										html += '<div class="correct-answer">' + q.Explanation + '</div>';
									}
									html += '</div>';
								});
							} else {
								html = '<div class="question-block">No questions found for this quiz/submission.</div>';
							}
							$('#questionsContainer').html(html);
						}
					});
				}
			});
		});
	</script>
</asp:Content>
