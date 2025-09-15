<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Student Home - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.home-container {
			padding: 2rem;
			background: #f8f9fa;
			min-height: 100vh;
		}
		.welcome-card {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			padding: 2.5rem 2rem 2rem 2rem;
			border-radius: 18px;
			margin-bottom: 2.5rem;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13);
			position: relative;
			overflow: hidden;
		}
		.welcome-card .fa {
			font-size: 2.5rem;
			margin-right: 1rem;
			opacity: 0.85;
		}
		.quick-links {
			display: grid;
			grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
			gap: 1.5rem;
			margin-bottom: 2.5rem;
		}
		.quick-link-card {
			background: white;
			border-radius: 14px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 1.5rem 1.2rem;
			text-align: center;
			transition: box-shadow 0.25s, transform 0.25s;
			color: #2c3e50;
			text-decoration: none;
			position: relative;
		}
		.quick-link-card:hover {
			box-shadow: 0 10px 30px rgba(0,123,255,0.13);
			transform: translateY(-3px) scale(1.03);
			color: #007bff;
		}
		.quick-link-card .fa {
			font-size: 2.2rem;
			margin-bottom: 0.7rem;
			color: #007bff;
			transition: color 0.2s;
		}
		.quick-link-card:hover .fa {
			color: #0056b3;
		}
		.recent-activity-section {
			background: white;
			border-radius: 14px;
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
		.activity-list {
			list-style: none;
			padding: 0;
			margin: 0;
		}
		.activity-item {
			display: flex;
			align-items: center;
			padding: 1rem 0;
			border-bottom: 1px solid #f1f3f4;
			transition: background 0.18s;
		}
		.activity-item:last-child {
			border-bottom: none;
		}
		.activity-icon {
			width: 44px;
			height: 44px;
			border-radius: 50%;
			background: #e3f2fd;
			color: #1976d2;
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 1.3rem;
			margin-right: 1rem;
		}
		.activity-content {
			flex: 1;
		}
		.activity-title {
			font-weight: 500;
			color: #2c3e50;
		}
		.activity-date {
			font-size: 0.93rem;
			color: #888;
		}
		@media (max-width: 768px) {
			.home-container { padding: 1rem; }
			.welcome-card { padding: 1.5rem 1rem; }
			.recent-activity-section { padding: 1.2rem 0.7rem; }
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="home-container">
		<!-- Welcome Card -->
		<div class="welcome-card animate__animated animate__fadeInDown">
			<h1><i class="fas fa-user-graduate"></i>Welcome, <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label>!</h1>
			<p class="mb-0">Your personalized learning hub. Access your courses, assignments, and more.</p>
		</div>

		<!-- Quick Links -->
		<div class="quick-links animate__animated animate__fadeInUp animate__delay-1s">
			<a href="Dashboard.aspx" class="quick-link-card">
				<i class="fas fa-tachometer-alt"></i>
				<div>Dashboard</div>
			</a>
			<a href="Course.aspx" class="quick-link-card">
				<i class="fas fa-book"></i>
				<div>My Courses</div>
			</a>
			<a href="Assignments.aspx" class="quick-link-card">
				<i class="fas fa-tasks"></i>
				<div>Assignments</div>
			</a>
			<a href="Grade.aspx" class="quick-link-card">
				<i class="fas fa-chart-line"></i>
				<div>Grades</div>
			</a>
			<a href="Schedule.aspx" class="quick-link-card">
				<i class="fas fa-calendar-alt"></i>
				<div>Schedule</div>
			</a>
		</div>

		<!-- Recent Activity -->
		<div class="recent-activity-section animate__animated animate__fadeIn animate__delay-2s">
			<div class="section-title"><i class="fas fa-bolt me-2"></i>Recent Activity</div>
			<ul class="activity-list">
				<li class="activity-item">
					<div class="activity-icon bg-success text-white"><i class="fas fa-check"></i></div>
					<div class="activity-content">
						<div class="activity-title">Assignment submitted: Calculus I Homework 2</div>
						<div class="activity-date">Today, 10:15 AM</div>
					</div>
				</li>
				<li class="activity-item">
					<div class="activity-icon bg-warning text-white"><i class="fas fa-exclamation"></i></div>
					<div class="activity-content">
						<div class="activity-title">Upcoming quiz: Physics II - Chapter 3</div>
						<div class="activity-date">Tomorrow, 9:00 AM</div>
					</div>
				</li>
				<li class="activity-item">
					<div class="activity-icon bg-primary text-white"><i class="fas fa-book"></i></div>
					<div class="activity-content">
						<div class="activity-title">New material uploaded: World History - Lecture 5</div>
						<div class="activity-date">Yesterday, 4:30 PM</div>
					</div>
				</li>
				<li class="activity-item">
					<div class="activity-icon bg-info text-white"><i class="fas fa-calendar-alt"></i></div>
					<div class="activity-content">
						<div class="activity-title">Class rescheduled: English Literature</div>
						<div class="activity-date">2 days ago</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
    $.ajax({
        type: "POST",
        url: "Home.aspx/GetRecentActivity",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            if (res.d) {
                var activities = JSON.parse(res.d);
                var $list = $('.activity-list').empty();
                if (activities.length === 0) {
                    $list.append('<li class="activity-item"><div class="activity-content"><div class="activity-title">No recent activity found.</div></div></li>');
                } else {
                    activities.forEach(function(a) {
                        $list.append(
                            `<li class="activity-item">
                                <div class="activity-icon ${a.color} text-white"><i class="fas ${a.icon}"></i></div>
                                <div class="activity-content">
                                    <div class="activity-title">${a.title}</div>
                                    <div class="activity-date">${a.date}</div>
                                </div>
                            </li>`
                        );
                    });
                }
            }
        }
    });
});
</script>

</asp:Content>
