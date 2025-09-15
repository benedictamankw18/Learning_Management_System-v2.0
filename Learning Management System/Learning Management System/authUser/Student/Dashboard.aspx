<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Dashboard" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Student Dashboard - Learning Management System</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        .dashboard-container {
            padding: 2rem;
            background: #f8f9fa;
            min-height: 100vh;
        }
        .page-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
        }
        .welcome-section {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border-left: 4px solid #007bff;
            transition: box-shadow 0.3s, transform 0.3s;
        }
        .stat-card:hover {
            box-shadow: 0 10px 30px rgba(0,123,255,0.13);
            transform: translateY(-2px);
        }
        .stat-card .icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        .stat-card h3 {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }
        .stat-card p {
            color: #666;
            margin-bottom: 0;
        }
        .courses-stat { border-left-color: #007bff; }
        .assignments-stat { border-left-color: #ffc107; }
        .grades-stat { border-left-color: #28a745; }
        .progress-stat { border-left-color: #17a2b8; }
        .courses-stat .icon { color: #007bff; }
        .assignments-stat .icon { color: #ffc107; }
        .grades-stat .icon { color: #28a745; }
        .progress-stat .icon { color: #17a2b8; }
        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        .chart-section{
            width: 750px;
            height: 900px;
        }
        .Upcoming-DeadLine{
        }
.upcoming-list{
    width: 100%;
    max-height: 800px;
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: #007bff #f8f9fa;
}
         .upcoming-section {
            position: relative;
            width: 450px;
            height: 900px;
         }

        .chart-section, .upcoming-section {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: box-shadow 0.3s, transform 0.3s;
        }
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #2c3e50;
            border-bottom: 2px solid #007bff;
            padding-bottom: 0.5rem;
        }
        .upcoming-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            transition: all 0.3s ease;
        }
        .upcoming-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.10);
            transform: translateY(-2px);
        }
        .upcoming-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 1.2rem;
        }
        .upcoming-content {
            flex: 1;
        }
        .upcoming-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.25rem;
        }
        .upcoming-course {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0.25rem;
        }
        .upcoming-date {
            font-size: 0.85rem;
            color: #ee1c24;
            font-weight: 500;
        }
        .progress-bar-custom {
            width: 100%;
            height: 20px;
            background-color: #e0e0e0;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 0.5rem;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #28a745, #17a2b8);
            transition: width 0.3s ease;
        }
        .courses-section {
            background: white;
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        .course-card {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            background: white;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
        }
        .course-header {
            background: linear-gradient(135deg, #007bff, #ee1c24);
            color: white;
            padding: 1rem;
        }
        .course-body {
            padding: 1rem;
        }
        .course-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .course-instructor {
            opacity: 0.9;
            font-size: 0.9rem;
        }
        .course-progress {
            margin-top: 1rem;
        }
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }
        .action-btn {
            background: white;
            border: 2px solid #007bff;
            color: #007bff;
            padding: 1rem;
            border-radius: 12px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .action-btn:hover {
            background: #007bff;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,123,255,0.13);
        }
        .action-btn i {
            display: block;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        @media (max-width: 900px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
        }
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 1rem;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .course-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h1><i class="fas fa-graduation-cap me-3"></i>Welcome Back, <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label>!</h1>
            <p class="mb-0">Ready to continue your learning journey? Let's see what's new today.</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card courses-stat">
                <div class="icon">
                    <i class="fas fa-book-open"></i>
                </div>
                <h3><asp:Label ID="lblEnrolledCourses" runat="server" Text="0"></asp:Label></h3>
                <p>Enrolled Courses</p>
            </div>

            <div class="stat-card assignments-stat">
                <div class="icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h3><asp:Label ID="lblPendingAssignments" runat="server" Text="0"></asp:Label></h3>
                <p>Pending Assignments</p>
            </div>

            <div class="stat-card grades-stat">
                <div class="icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3><asp:Label ID="lblAverageGrade" runat="server" Text="0"></asp:Label>%</h3>
                <p>Average Grade</p>
            </div>

            <div class="stat-card progress-stat">
                <div class="icon">
                    <i class="fas fa-trophy"></i>
                </div>
                <h3><asp:Label ID="lblCompletionRate" runat="server" Text="0"></asp:Label>%</h3>
                <p>Course Progress</p>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Chart Section -->
            <div class="chart-section">
                <h3 class="section-title"><i class="fas fa-chart-area me-2"></i>Academic Performance</h3>
                <canvas id="performanceChart" width="100" height="100"></canvas>
            </div>

            <!-- Upcoming Deadlines -->
            <div class="upcoming-section">
                <div class="section-title Upcoming-DeadLine"><i class="fas fa-calendar-alt me-2"></i><h3 style="display: inline;">Upcoming Deadlines</h3></div>
                <div id="upcomingList" class="upcoming-list">
                    <div class="upcoming-item">
                        <%--  --%>
                    </div>
                </div>
            </div>
        </div>

        <!-- My Courses Section -->
        <div class="courses-section">
            <h3 class="section-title"><i class="fas fa-book me-2"></i>My Courses</h3>
            <div id="courseGrid" class="course-grid">
                <!-- Courses will be loaded here dynamically -->
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="Course.aspx" class="action-btn">
                <i class="fas fa-book-open"></i>
                View Courses
            </a>
            <a href="Assignments.aspx" class="action-btn">
                <i class="fas fa-tasks"></i>
                Assignments
            </a>
            <a href="Grade.aspx" class="action-btn">
                <i class="fas fa-chart-bar"></i>
                View Grades
            </a>
            <a href="Schedule.aspx" class="action-btn">
                <i class="fas fa-calendar"></i>
                My Schedule
            </a>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

        // Performance Chart (Dynamic)
        document.addEventListener('DOMContentLoaded', function() {
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetPerformanceScores",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(res) {
                    var scores = [];
                    if (res.d) {
                        scores = JSON.parse(res.d);
                    }
                    // Group by course/title, average if multiple
                    var courseScores = {};
                    scores.forEach(function(s) {
                        var key = s.course + ' - ' + s.title;
                        if (!courseScores[key]) courseScores[key] = [];
                        courseScores[key].push(Number(s.score));
                    });
                    var labels = [], data = [], bgColors = [];
                    var colorList = [
                        'rgb(44, 43, 124)',
                        'rgb(238, 28, 36)',
                        'rgb(40, 167, 69)',
                        'rgb(255, 193, 7)',
                        'rgb(23, 162, 184)',
                        'rgb(0, 123, 255)',
                        'rgb(23, 162, 184)',
                        'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(255, 206, 86)'
                    ];
                    var i = 0;
                    for (var key in courseScores) {
                        labels.push(key);
                        var avg = courseScores[key].reduce((a,b)=>a+b,0) / courseScores[key].length;
                        data.push(Math.round(avg));
                        bgColors.push(colorList[i % colorList.length]);
                        i++;
                    }
                    if (labels.length === 0) {
                        labels = ["No Data"];
                        data = [0];
                        bgColors = ["#e0e0e0"];
                    }
                    var ctx = document.getElementById('performanceChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: labels,
                            datasets: [{
                                data: data,
                                backgroundColor: bgColors,
                                borderWidth: 2,
                                borderColor: '#fff'
                            }]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                }
                            }
                        }
                    });
                }
            });
        });


$(function() {
    // Load Upcoming Deadlines
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetUpcomingDeadlines",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            if (res.d) {
                var deadlines = JSON.parse(res.d);
                var $list = $('#upcomingList').empty();
                if (deadlines.length === 0) {
                    $list.append('<div class="upcoming-item"><div class="upcoming-content"><div class="upcoming-title">No upcoming deadlines.</div></div></div>');
                } else {
                    deadlines.forEach(function(d) {
                        $list.append(
                            `<div class="upcoming-item">
                                <div class="upcoming-icon" style="background-color: ${d.color};">
                                    <i class="fas ${d.icon}"></i>
                                </div>
                                <div class="upcoming-content">
                                    <div class="upcoming-title">${d.title}</div>
                                    <div class="upcoming-course">${d.course}</div>
                                    <div class="upcoming-date">Due: ${d.date}</div>
                                </div>
                            </div>`
                        );
                    });
                }
            }
        }
    });

    // Load My Courses
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetStudentCourses",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            var $grid = $('#courseGrid').empty();
            var courses = [];
            if (res.d) {
                courses = JSON.parse(res.d);
            }
            if (courses.length === 0) {
                $grid.append('<div>No enrolled courses found.</div>');
            } else {
                courses.forEach(function(c) {
                    $grid.append(
                        `<div class="course-card">
                            <div class="course-header">
                                <div class="course-title">${c.title}</div>
                                <div class="course-instructor">${c.instructor}</div>
                            </div>
                            <div class="course-body">
                                <div class="course-progress">
                                    <small>Progress: ${c.progress}%</small>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill" style="width: ${c.progress}%;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>`
                    );
                });
            }
        }
    });
});

    </script>
</asp:Content>
