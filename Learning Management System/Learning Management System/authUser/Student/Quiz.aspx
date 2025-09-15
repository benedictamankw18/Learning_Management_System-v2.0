<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Quiz.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Quiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Course Quizzes - Learning Management System</title>
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body { font-family: 'Roboto', sans-serif; background: #f8f9fa; }
		.quizzes-container { max-width: 900px; margin: 0 auto; padding: 2rem; }
		.page-header { background: linear-gradient(135deg, #007bff, #0056b3); color: white; padding: 2rem; border-radius: 16px; margin-bottom: 2.5rem; box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13); }
		.quiz-list { margin-top: 2rem; }
		.quiz-card { background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.07); margin-bottom: 1.2rem; padding: 1.2rem 1.5rem; display: flex; align-items: center; cursor: pointer; transition: box-shadow 0.2s, transform 0.2s; border-left: 6px solid #1976d2; text-decoration: none; color: #2c3e50; }
		.quiz-card:hover { box-shadow: 0 6px 18px rgba(25, 118, 210, 0.13); transform: translateY(-2px) scale(1.01); background: #f1f7ff; color: #1976d2; }
		.quiz-icon { color: #1976d2; font-size: 1.5rem; margin-right: 1.2rem; }
		.quiz-title { font-size: 1.13rem; font-weight: 600; flex: 1; }
		.quiz-meta-row { display: flex; flex-wrap: wrap; gap: 1.2rem; margin-top: 0.5rem; }
		.quiz-badge { display: inline-block; padding: 0.3em 0.9em; border-radius: 1em; font-size: 0.97rem; font-weight: 500; margin-right: 0.5em; }
		.badge-duration { background: #e3f2fd; color: #1976d2; }
		.badge-attempts { background: #fff3cd; color: #856404; }
		.badge-status { background: #d4edda; color: #155724; }
		.badge-status.inactive { background: #f8d7da; color: #721c24; }
		.badge-type { background: #f0ecf9; color: #6f42c1; }
		.badge-date { background: #f1f3f4; color: #495057; }
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="quizzes-container">
		<div class="page-header mb-4">
			<h1 class="mb-2"><i class="fas fa-question-circle me-3"></i>Course Quizzes</h1>
			<p class="mb-0 opacity-75">Select a quiz to begin</p>
		</div>
		<asp:Repeater ID="rptQuizzes" runat="server">
			<ItemTemplate>
				<a class="quiz-card" href='<%# Eval("QuizID", "QuizQuestion.aspx?quizId={0}&courseId=" + Request.QueryString["courseId"]) %>'>
					<span class="quiz-icon"><i class="fas fa-clipboard-list"></i></span>
					<div class="flex-fill">
						<span class="quiz-title"><%# Eval("Title") %></span>
						<div class="small text-muted mt-1"><%# Eval("Description") %></div>
						<div class="quiz-meta-row">
							<span class="quiz-badge badge-duration"><i class="fas fa-clock me-1"></i> <%# Eval("Duration") %> min</span>
							<span class="quiz-badge badge-attempts"><i class="fas fa-redo me-1"></i> Attempts: <%# Eval("MaxAttempts") %></span>
							<span class='quiz-badge badge-status <%# (Eval("IsActivated").ToString() == "True" ? "" : "inactive") %>'><i class="fas fa-toggle-on me-1"></i> <%# (Eval("IsActivated").ToString() == "True" ? "Active" : "Inactive") %></span>
							<span class="quiz-badge badge-type"><i class="fas fa-tag me-1"></i> <%# Eval("Type") %></span>
						</div>
						<div class="quiz-meta-row">
							<span class="quiz-badge badge-date"><i class="fas fa-calendar me-1"></i> Start: <%# Eval("StartDate", "{0:dd MMM yyyy}") %></span>
							<span class="quiz-badge badge-date"><i class="fas fa-calendar me-1"></i> End: <%# Eval("EndDate", "{0:dd MMM yyyy}") %></span>
							<span class="quiz-badge badge-date"><i class="fas fa-calendar-plus me-1"></i> Created: <%# Eval("CreatedDate", "{0:dd MMM yyyy}") %></span>
						</div>
					</div>
				</a>
			</ItemTemplate>
		</asp:Repeater>
	</div>
</asp:Content>
