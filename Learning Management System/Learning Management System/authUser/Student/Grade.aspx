<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Grade.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Grade" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Grades - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.grades-container {
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
		.summary-grid {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
			gap: 1.5rem;
			margin-bottom: 2.5rem;
		}
		.summary-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 1.5rem 1.2rem;
			text-align: center;
			color: #2c3e50;
			position: relative;
		}
		.summary-card .fa {
			font-size: 2rem;
			margin-bottom: 0.7rem;
			color: #007bff;
		}
		.summary-title {
			font-size: 1.1rem;
			font-weight: 500;
			color: #888;
		}
		.summary-value {
			font-size: 2rem;
			font-weight: 700;
			color: #2c3e50;
		}
		.grades-table-section {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 2rem 1.5rem;
		}
		.section-title {
			font-size: 1.25rem;
			font-weight: 600;
			margin-bottom: 1.2rem;
			color: #2c3e50;
			border-bottom: 2px solid #007bff;
			padding-bottom: 0.5rem;
		}
		.table {
			width: 100%;
			margin-bottom: 1rem;
			color: #212529;
			border-collapse: separate;
			border-spacing: 0;
		}
		.table th, .table td {
			padding: 1rem 0.7rem;
			vertical-align: middle;
			border-top: 1px solid #f1f3f4;
		}
		.table thead th {
			background: #f8f9fa;
			border: none;
			font-weight: 600;
			color: #2c3e50;
		}
		.badge-grade {
			font-size: 1rem;
			border-radius: 8px;
			padding: 0.4em 1em;
			font-weight: 600;
		}
		.badge-success { background: #e8f5e8; color: #2e7d32; }
		.badge-warning { background: #fff8e1; color: #ff9800; }
		.badge-danger { background: #ffebee; color: #d32f2f; }
		@media (max-width: 768px) {
			.grades-container { padding: 1rem; }
			.page-header { padding: 1.2rem 0.7rem; }
			.grades-table-section { padding: 1.2rem 0.7rem; }
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="grades-container">
		<!-- Page Header -->
		<div class="page-header animate__animated animate__fadeInDown">
			<h1 class="mb-2">
				<i class="fas fa-chart-bar me-3"></i>
				My Grades
			</h1>
			<p class="mb-0 opacity-75">View your academic performance and progress</p>
		</div>

		<!-- Summary Cards -->
		<div class="summary-grid animate__animated animate__fadeInUp animate__delay-1s">
			<div class="summary-card">
				<i class="fas fa-book-open"></i>
				<div class="summary-title">Courses</div>
				<div class="summary-value">4</div>
			</div>
			<div class="summary-card">
				<i class="fas fa-tasks"></i>
				<div class="summary-title">Assignments</div>
				<div class="summary-value">12</div>
			</div>
			<div class="summary-card">
				<i class="fas fa-chart-line"></i>
				<div class="summary-title">Average Grade</div>
				<div class="summary-value">85%</div>
			</div>
			<div class="summary-card">
				<i class="fas fa-trophy"></i>
				<div class="summary-title">Completion Rate</div>
				<div class="summary-value">92%</div>
			</div>
		</div>

		<!-- Grades Table -->
		<div class="grades-table-section animate__animated animate__fadeIn animate__delay-2s">
			<div class="section-title"><i class="fas fa-list me-2"></i>Grades by Course</div>
			<div class="table-responsive">
				<table class="table table-hover mb-0">
					<thead>
						<tr>
							<th>Course</th>
							<th>Instructor</th>
							<th>Assignments</th>
							<th>Grade</th>
							<th>Status</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function () {
    $.ajax({
        type: "POST",
        url: "Grade.aspx/GetStudentGrades",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (res) {
            var data = res.d ? JSON.parse(res.d) : res;
            // Update summary cards
            $('.summary-card').eq(0).find('.summary-value').text(data.summary.courses);
            $('.summary-card').eq(1).find('.summary-value').text(data.summary.assignments);
            $('.summary-card').eq(2).find('.summary-value').text(data.summary.avgGrade + "%");
            $('.summary-card').eq(3).find('.summary-value').text(data.summary.completion + "%");

            // Update grades table
            var tbody = $('.grades-table-section tbody');
            tbody.empty();
            data.grades.forEach(function (g) {
                var badgeClass = "badge-success", badgeText = "Passed";
                if (g.status === "At Risk") { badgeClass = "badge-danger"; badgeText = "At Risk"; }
                else if (g.status === "In Progress") { badgeClass = "badge-warning"; badgeText = "In Progress"; }
                tbody.append(`
                    <tr>
                        <td>${g.course}</td>
                        <td>${g.instructor}</td>
                        <td>${g.assignments}</td>
                        <td><span class="badge-grade ${badgeClass}">${g.grade}%</span></td>
                        <td><span class="badge ${badgeClass}">${badgeText}</span></td>
                    </tr>
                `);
            });
        },
        error: function (err) {
            alert("Failed to load grades.");
        }
    });
});
</script>
</asp:Content>
