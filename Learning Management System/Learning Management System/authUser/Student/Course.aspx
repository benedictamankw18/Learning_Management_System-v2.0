<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Course.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Course" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>My Courses - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.courses-container {
			padding: 2rem;
			background: #f8f9fa;
			min-height: 100vh;
		}
		.page-header {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			padding: 2.2rem 2rem 2rem 2rem;
			border-radius: 16px;
			margin-bottom: 2.5rem;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13);
			position: relative;
			overflow: hidden;
		}
		.page-header .fa {
			font-size: 2.2rem;
			margin-right: 1rem;
			opacity: 0.85;
		}
		.course-grid {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
			gap: 1.5rem;
		}
		.course-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 1.5rem 1.2rem;
			transition: box-shadow 0.25s, transform 0.25s;
			color: #2c3e50;
			text-decoration: none;
			position: relative;
			border: 2px solid transparent;
		}
		.course-card:hover {
			box-shadow: 0 10px 30px rgba(0,123,255,0.13);
			transform: translateY(-3px) scale(1.03);
			border-color: #007bff;
		}
		.course-icon {
			width: 54px;
			height: 54px;
			background: linear-gradient(135deg, #007bff, #0056b3);
			border-radius: 13px;
			display: flex;
			align-items: center;
			justify-content: center;
			margin-bottom: 1rem;
		}
		.course-icon i {
			font-size: 1.7rem;
			color: white;
		}
		.course-title {
			font-weight: 600;
			font-size: 1.15rem;
			margin-bottom: 0.3rem;
		}
		.course-meta {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-top: 1rem;
			padding-top: 0.7rem;
			border-top: 1px solid #eee;
			font-size: 0.97rem;
		}
		.sections-count {
			color: #6c757d;
		}
		.materials-count {
			background: #e3f2fd;
			color: #1976d2;
			padding: 4px 12px;
			border-radius: 20px;
			font-size: 0.95rem;
			font-weight: 600;
		}
		@media (max-width: 768px) {
			.courses-container { padding: 1rem; }
			.page-header { padding: 1.2rem 0.7rem; }
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="courses-container">
		<!-- Page Header -->
		<div class="page-header animate__animated animate__fadeInDown">
			<h1 class="mb-2">
				<i class="fas fa-book-open me-3"></i>
				My Courses
			</h1>
			<p class="mb-0 opacity-75">Browse and manage your enrolled courses</p>
		</div>

		<!-- Course Grid -->
		<asp:Repeater ID="rptCourses" runat="server">
			<HeaderTemplate>
				<div class="course-grid animate__animated animate__fadeInUp animate__delay-1s">
			</HeaderTemplate>
			<ItemTemplate>
				<a class="course-card" href='<%# Eval("CourseID", "Material.aspx?courseId={0}") %>'>
					<div class="course-icon">
						<i class="fas fa-book"></i>
					</div>
					<div class="course-title"><%# Eval("CourseName") %></div>
					<div class="text-muted mb-1"><%# Eval("CourseCode") %></div>
					<div class="small text-muted"><%# Eval("Description") %></div>
					<div class="course-meta">
						<span class="sections-count"><i class="fas fa-list me-1"></i><%# Eval("SectionCount") %> sections</span>
						<span class="materials-count"><%# Eval("MaterialCount") %> materials</span>
					</div>
				</a>
			</ItemTemplate>
			<FooterTemplate>
				</div>
			</FooterTemplate>
		</asp:Repeater>
	</div>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
</asp:Content>
