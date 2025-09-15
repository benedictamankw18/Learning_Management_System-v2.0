<%@ Page Title="Teacher Dashboard" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Teacher Dashboard - Learning Management System</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root {
            --primary-color: #2c2b7c;
            --accent-color: #ee1c24;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-bg: #f8f9fa;
            --white: #ffffff;
            --border-color: #e0e0e0;
            --text-color: #333333;
            --shadow: rgba(0, 0, 0, 0.1);
        }

        .dashboard-container {
            padding: 2rem;
            background: var(--light-bg);
            min-height: 100vh;
        }

        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px var(--shadow);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px var(--shadow);
            border-left: 4px solid var(--primary-color);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px var(--shadow);
        }

        .stat-card .icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .stat-card h3 {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        .stat-card p {
            color: #666;
            margin-bottom: 0;
        }

        .courses-stat { border-left-color: var(--primary-color); }
        .students-stat { border-left-color: var(--success-color); }
        .assignments-stat { border-left-color: var(--warning-color); }
        .submissions-stat { border-left-color: var(--info-color); }

        .courses-stat .icon { color: var(--primary-color); }
        .students-stat .icon { color: var(--success-color); }
        .assignments-stat .icon { color: var(--warning-color); }
        .submissions-stat .icon { color: var(--info-color); }

        .content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

 .recent-activity{
            <%-- overflow-y: auto;  --%>
        }

        .activity-list {
            width: 100%;
            max-height: 375px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #007bff #f8f9fa;
        }

        .chart-section, .recent-activity {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px var(--shadow);
            height: 460px;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--text-color);
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 0.5rem;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            color: var(--text-color);
            margin-bottom: 0.25rem;
        }

        .activity-time {
            font-size: 0.85rem;
            color: #666;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .action-btn {
            background: var(--white);
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
            padding: 1rem;
            border-radius: 10px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .action-btn:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px var(--shadow);
        }

        .action-btn i {
            display: block;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .activity-icon {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin-right: 0.75rem;
            flex-shrink: 0;
        }
        .list-group-item {
            border: none;
            border-bottom: 1px solid #e0e0e0;
            padding: 1rem 1rem;
        }
        .list-group-item:last-child {
            border-bottom: none;
        }
        .badge {
            font-size: 1rem;
            padding: 0.5em 0.8em;
        }

        @media (max-width: 768px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
            
            .dashboard-container {
                padding: 1rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="dashboard-container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h1><i class="fas fa-chalkboard-teacher me-3"></i>Welcome back, <asp:Label ID="lblTeacherName" runat="server" Text="Teacher"></asp:Label>!</h1>
            <p class="mb-0">Here's what's happening with your classes today.</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card courses-stat">
                <div class="icon">
                    <i class="fas fa-book"></i>
                </div>
                <h3><asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label></h3>
                <p>Total Courses</p>
            </div>

            <div class="stat-card students-stat">
                <div class="icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3><asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label></h3>
                <p>Total Students</p>
            </div>

            <div class="stat-card assignments-stat">
                <div class="icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h3><asp:Label ID="lblActiveAssignments" runat="server" Text="0"></asp:Label></h3>
                <p>Active Assignments</p>
            </div>

            <div class="stat-card submissions-stat">
                <div class="icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h3><asp:Label ID="lblPendingSubmissions" runat="server" Text="0"></asp:Label></h3>
                <p>Pending Reviews</p>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Chart Section -->
            <div class="chart-section">
                <h3 class="section-title"><i class="fas fa-chart-bar me-2"></i>Student Performance Overview</h3>
                <canvas id="performanceChart" width="400" height="200"></canvas>
            </div>
          
        <!-- Recent Activity -->
        <div class="recent-activity">
            <div class="activity-header">
                <h3 class="section-title"><i class="fas fa-clock me-2"></i>Recent Activity</h3>
            </div>
            <ul class="list-group activity-list" id="recentActivityList">
                <li class="list-group-item text-muted">Loading...</li>
            </ul>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <a href="Courses.aspx" class="action-btn">
                <i class="fas fa-book"></i>
                Manage Courses
            </a>
            <a href="Assignments.aspx" class="action-btn">
                <i class="fas fa-tasks"></i>
                Create Assignment
            </a>
            <a href="Students.aspx" class="action-btn">
                <i class="fas fa-users"></i>
                View Students
            </a>
            <a href="Grades.aspx" class="action-btn">
                <i class="fas fa-chart-line"></i>
                Grade Book
            </a>
        </div>
    </div>
    </div>

    <script>

        // Performance Chart
        document.addEventListener('DOMContentLoaded', function() {
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetPerformanceChartData",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            const data = JSON.parse(res.d);
            const labels = data.map(d => d.week);
            const avgScores = data.map(d => d.avgScore);
            const submissionRates = data.map(d => d.submissionRate);

            const ctx = document.getElementById('performanceChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Average Score',
                        data: avgScores,
                        borderColor: 'rgb(44, 43, 124)',
                        backgroundColor: 'rgba(44, 43, 124, 0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Submission Rate',
                        data: submissionRates,
                        borderColor: 'rgb(40, 167, 69)',
                        backgroundColor: 'rgba(40, 167, 69, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { position: 'top' }
                    },
                    scales: {
                        y: { beginAtZero: true, max: 100 }
                    }
                }
            });
        }
    });
});

document.addEventListener('DOMContentLoaded', function() {
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetRecentActivity",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(res) {
            const activities = JSON.parse(res.d);
            const $list = $('#recentActivityList');
            $list.empty();
            if (activities.length === 0) {
                $list.append('<li class="list-group-item text-muted">No recent activity.</li>');
            } else {
                activities.forEach(a => {
                let html = "";
                if (a.type === "submission") {
                    html = `<li class="list-group-item d-flex align-items-center">
                        <span class="activity-icon bg-primary text-white me-3"><i class="fas fa-upload"></i></span>
                        <div class="flex-fill">
                            <strong>${a.student}</strong> submitted <em>${a.assignment}</em> for <span class="text-primary">${a.course}</span>
                            <br><small class="text-muted">${a.submittedAt}</small>
                        </div>
                        <span class="badge ms-2 bg-${a.score === 'Ungraded' ? 'warning text-dark' : 'success'}">${a.score}</span>
                    </li>`;
                } else if (a.type === "enrollment") {
                    html = `<li class="list-group-item d-flex align-items-center">
                        <span class="activity-icon bg-success text-white me-3"><i class="fas fa-user-plus"></i></span>
                        <div class="flex-fill">
                            <strong>${a.student}</strong> enrolled in <span class="text-primary">${a.course}</span>
                            <br><small class="text-muted">${a.enrolledAt}</small>
                        </div>
                    </li>`;
                } else if (a.type === "quiz_post") {
                    html = `<li class="list-group-item d-flex align-items-center">
                        <span class="activity-icon bg-info text-white me-3"><i class="fas fa-question-circle"></i></span>
                        <div class="flex-fill">
                            New quiz <em>${a.quiz}</em> posted for <span class="text-primary">${a.course}</span>
                            <br><small class="text-muted">${a.createdAt}</small>
                        </div>
                    </li>`;
                } else if (a.type === "quiz_submission") {
                    html = `<li class="list-group-item d-flex align-items-center">
                        <span class="activity-icon bg-secondary text-white me-3"><i class="fas fa-file-alt"></i></span>
                        <div class="flex-fill">
                            <strong>${a.student}</strong> submitted quiz <em>${a.quiz}</em> for <span class="text-primary">${a.course}</span>
                            <br><small class="text-muted">${a.submittedAt}</small>
                        </div>
                        <span class="badge ms-2 bg-${a.score === 'Ungraded' ? 'warning text-dark' : 'success'}">${a.score}</span>
                    </li>`;
                } else if (a.type === "deadline") {
                    html = `<li class="list-group-item d-flex align-items-center">
                        <span class="activity-icon bg-warning text-dark me-3"><i class="fas fa-exclamation-triangle"></i></span>
                        <div class="flex-fill">
                            Assignment <em>${a.assignment}</em> for <span class="text-primary">${a.course}</span> is due soon
                            <br><small class="text-muted">${a.dueDate}</small>
                        </div>
                    </li>`;
                }
                $list.append(html);
            });
            }
        }
    });
});

</script>
</asp:Content>
