<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Learning_Management_System.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin Dashboard - Learning Management System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js for dashboard charts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* Dashboard Custom Theme Variables */
        :root {
            /* Custom Theme Colors */
            --primary-color: #2c2b7c;
            --accent-color: #ee1c24;
            --background-color: #fefefe;
            --text-color: #000000;
            
            /* Derived Theme Colors */
            --primary-light: #3d3c8f;
            --primary-dark: #1f1e5a;
            --accent-light: #f04752;
            --accent-dark: #c41520;
            
            /* Neutral Colors */
            --white: #ffffff;
            --light-gray: #f8f9fa;
            --border-gray: #e0e0e0;
            --medium-gray: #666666;
            --dark-gray: #333333;
            
            /* Status Colors */
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: var(--accent-color);
            --info-color: var(--primary-color);

            --dashboard-bg: var(--background-color);
            --dashboard-text: var(--text-color);
            --dashboard-card-bg: var(--white);
            --dashboard-border: var(--border-gray);
            --dashboard-shadow: rgba(0, 0, 0, 0.1);
            --dashboard-primary: var(--primary-color);
            --dashboard-success: var(--success-color);
            --dashboard-warning: var(--warning-color);
            --dashboard-danger: var(--danger-color);
            --dashboard-info: var(--info-color);
            --dashboard-purple: var(--primary-light);
        }

        /* Remove conflicting body styles - let Admin.Master handle body */
        .wholepage {
            background: var(--dashboard-bg) !important;
            color: var(--dashboard-text) !important;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif !important;
        }

        /* Ensure container doesn't interfere with sidebar */
        .container {
            max-width: 1400px;
            padding: 20px 15px;
            width: 100%;
            margin: 0 auto;
        }

        /* Mobile responsive adjustments for sidebar compatibility */
        @media (max-width: 768px) {
            .container {
                padding: 15px 10px;
                transition: all 0.3s ease;
            }

            /* When mobile sidebar is active, prevent scrolling issues */
            body.mobile-menu-active .container {
                overflow-x: hidden;
            }

            /* Adjust dashboard header for mobile */
            .dashboard-header {
                padding: 20px 15px;
                margin-bottom: 20px;
            }

            .dashboard-title {
                font-size: 1.5rem;
            }

            /* Grid adjustments for mobile */
            .stats-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            /* Chart container mobile optimization */
            .chart-container {
                height: 250px;
            }

            /* Activity list mobile optimization */
            .recent-activity {
                max-height: 300px;
            }

            .activity-item {
                padding: 10px 0;
            }

            .activity-title {
                font-size: 0.8rem;
            }

            .activity-time {
                font-size: 0.7rem;
            }
        }

        .dashboard-header {
            background: var(--dashboard-card-bg);
            border: 1px solid var(--dashboard-border);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px var(--dashboard-shadow);
            transition: all 0.3s ease;
        }

        .dashboard-title {
            color: var(--dashboard-text);
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 2rem;
        }

        .dashboard-subtitle {
            color: var(--gray-500, #6b7280);
            margin-bottom: 0;
            font-size: 1.1rem;
        }

        .dark-theme .dashboard-subtitle {
            color: var(--gray-400, #9ca3af);
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: var(--dashboard-card-bg);
            border: 1px solid var(--dashboard-border);
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 1px 3px var(--dashboard-shadow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--card-color, var(--dashboard-primary));
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px var(--dashboard-shadow);
        }

        .stat-card.primary { --card-color: var(--dashboard-primary); }
        .stat-card.success { --card-color: var(--dashboard-success); }
        .stat-card.warning { --card-color: var(--dashboard-warning); }
        .stat-card.danger { --card-color: var(--dashboard-danger); }
        .stat-card.info { --card-color: var(--dashboard-info); }
        .stat-card.purple { --card-color: var(--dashboard-purple); }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
            margin-bottom: 16px;
            background: var(--card-color, var(--dashboard-primary));
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dashboard-text);
            margin-bottom: 4px;
            line-height: 1;
        }

        .stat-label {
            color: var(--gray-600, #4b5563);
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 0.875rem;
        }

        .dark-theme .stat-label {
            color: var(--gray-400, #9ca3af);
        }

        .stat-change {
            font-size: 0.75rem;
            font-weight: 500;
        }

        .stat-change.positive {
            color: var(--dashboard-success);
        }

        .stat-change.negative {
            color: var(--dashboard-danger);
        }

        .dashboard-card {
            background: var(--dashboard-card-bg);
            border: 1px solid var(--dashboard-border);
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px var(--dashboard-shadow);
            transition: all 0.3s ease;
        }

        .card-title {
            color: var(--dashboard-text);
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1.125rem;
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 16px;
        }

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }

        .action-btn {
            background: var(--dashboard-primary);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 16px;
            text-decoration: none;
            text-align: center;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            color: white;
            text-decoration: none;
        }

        .action-btn.success {
            background: var(--dashboard-success);
        }

        .action-btn.success:hover {
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .action-btn.warning {
            background: var(--dashboard-warning);
        }

        .action-btn.warning:hover {
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
        }

        .action-btn.info {
            background: var(--dashboard-info);
        }

        .action-btn.info:hover {
            box-shadow: 0 4px 12px rgba(6, 182, 212, 0.3);
        }

        .recent-activity {
            max-height: 400px;
            overflow-y: auto;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid var(--dashboard-border);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            color: white;
            flex-shrink: 0;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            color: var(--dashboard-text);
            margin-bottom: 4px;
            font-size: 0.875rem;
        }

        .activity-time {
            font-size: 0.75rem;
            color: var(--gray-500, #6b7280);
        }

        .dark-theme .activity-time {
            color: var(--gray-400, #9ca3af);
        }

        .back-btn {
            background: var(--dashboard-primary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 16px;
        }

        .back-btn:hover {
            background: var(--primary-blue-dark, #5a67d8);
            color: white;
            text-decoration: none;
            transform: translateX(-2px);
        }

        /* Modal styling for dark theme */
        .dark-theme .modal-content {
            background: var(--dark-card, #1f2937);
            border-color: var(--dark-border, #374151);
            color: var(--dark-text, #f9fafb);
        }

        .dark-theme .modal-header {
            border-bottom-color: var(--dark-border, #374151);
        }

        .dark-theme .modal-footer {
            border-top-color: var(--dark-border, #374151);
        }

        .dark-theme .btn-outline-primary {
            color: var(--primary-blue, #667eea);
            border-color: var(--primary-blue, #667eea);
        }

        .dark-theme .btn-outline-success {
            color: var(--success-green, #10b981);
            border-color: var(--success-green, #10b981);
        }

        .dark-theme .btn-outline-warning {
            color: var(--warning-orange, #f59e0b);
            border-color: var(--warning-orange, #f59e0b);
        }

        .dark-theme .btn-outline-info {
            color: var(--info-cyan, #06b6d4);
            border-color: var(--info-cyan, #06b6d4);
        }

        .dark-theme .btn-outline-secondary {
            color: var(--gray-400, #9ca3af);
            border-color: var(--gray-400, #9ca3af);
        }

        .dark-theme .btn-outline-danger {
            color: var(--danger-red, #ef4444);
            border-color: var(--danger-red, #ef4444);
        }

        .dark-theme .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="dashboard-header">
            <h1 class="dashboard-title">
                <i class="fas fa-tachometer-alt"></i>
                Admin Dashboard
            </h1>
            <p class="dashboard-subtitle">Welcome to the Learning Management System Admin Dashboard</p>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-row">
            <div class="stat-card primary">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-number" id="totalUsers">0</div>
                <div class="stat-label">Total Users</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i> +5.2% from last month
                </div>
            </div>

            <div class="stat-card success">
                <div class="stat-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-number" id="totalStudents">0</div>
                <div class="stat-label">Active Students</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i> +3.8% from last month
                </div>
            </div>

            <div class="stat-card warning">
                <div class="stat-icon">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stat-number" id="totalTeachers">0</div>
                <div class="stat-label">Teachers</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i> +2 new this month
                </div>
            </div>

            <div class="stat-card info">
                <div class="stat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-number" id="totalCourses">0</div>
                <div class="stat-label">Active Courses</div>
                <div class="stat-change">
                    <i class="fas fa-minus"></i> No change
                </div>
            </div>

            <div class="stat-card danger">
                <div class="stat-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <div class="stat-number" id="totalQuizzes">0</div>
                <div class="stat-label">Total Quizzes</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i> +8 this week
                </div>
            </div>

            <div class="stat-card purple">
                <div class="stat-icon">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-number" id="avgPerformance">0.0%</div>
                <div class="stat-label">Avg Performance</div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i> +2.3% improvement
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row">
            <div class="col-lg-8">
                <div class="dashboard-card">
                    <h3 class="card-title">
                        <i class="fas fa-chart-area"></i>
                        User Registration Trends
                    </h3>
                    <div class="chart-container">
                        <canvas id="registrationChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="dashboard-card">
                    <h3 class="card-title">
                        <i class="fas fa-chart-pie"></i>
                        Course Distribution
                    </h3>
                    <div class="chart-container">
                        <canvas id="courseChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions and Recent Activity -->
        <div class="row">
            <div class="col-lg-8">
                <div class="dashboard-card">
                    <h3 class="card-title">
                        <i class="fas fa-bolt"></i>
                        Quick Actions
                    </h3>
                    <div class="quick-actions">
                        <a href="Course.aspx" class="action-btn">
                            <i class="fas fa-plus"></i>
                            Add New Course
                        </a>
                        <a href="Quiz.aspx" class="action-btn success">
                            <i class="fas fa-clipboard-list"></i>
                            Manage Quizzes
                        </a>
                        <a href="Reports.aspx" class="action-btn warning">
                            <i class="fas fa-chart-bar"></i>
                            Generate Reports
                        </a>
                        <a href="User.aspx" class="action-btn info">
                            <i class="fas fa-users"></i>
                            Manage Users
                        </a>
                        <a href="Material.aspx" class="action-btn">
                            <i class="fas fa-folder"></i>
                            Course Materials
                        </a>
                        <a href="Analytics.aspx" class="action-btn success">
                            <i class="fas fa-chart-line"></i>
                            Analytics
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="dashboard-card">
                    <h3 class="card-title">
                        <i class="fas fa-clock"></i>
                        Recent Activity
                    </h3>
                    <div class="recent-activity" id="recentActivity">
                        <!-- Activity items will be populated here -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Performance Overview -->
        <div class="row">
            <div class="col-12">
                <div class="dashboard-card">
                    <h3 class="card-title">
                        <i class="fas fa-analytics"></i>
                        Quiz Performance Overview
                    </h3>
                    <div class="chart-container">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Fixed Theme - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize dashboard with fixed custom theme
            console.log('Fixed custom theme applied to Dashboard.aspx');
            
            loadRecentActivity();
            initializeCharts();

            // Initialize mobile menu compatibility
            initializeMobileMenuCompatibility();

            fetch('Dashboard.aspx/GetDashboardStats', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            })
            .then(res => res.json())
            .then(result => {
                if (result.d && result.d.success) {
                    const stats = result.d.data;
                    document.getElementById('totalUsers').textContent = stats.totalUsers;
                    document.getElementById('totalStudents').textContent = stats.totalStudents;
                    document.getElementById('totalTeachers').textContent = stats.totalTeachers;
                    document.getElementById('totalCourses').textContent = stats.totalCourses;
                    document.getElementById('totalQuizzes').textContent = stats.totalQuizzes;
                    document.getElementById('avgPerformance').textContent = stats.avgPerformance + '%';
                }
            });
        });

        // Ensure Dashboard works properly with Admin.Master mobile menu
        function initializeMobileMenuCompatibility() {
            // Listen for mobile menu state changes
            const sidebar = document.getElementById('sidebar');
            const mobileOverlay = document.getElementById('mobileOverlay');
            
            if (sidebar && mobileOverlay) {
                // Watch for sidebar class changes
                const sidebarObserver = new MutationObserver(function(mutations) {
                    mutations.forEach(function(mutation) {
                        if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                            const isActive = sidebar.classList.contains('active');
                            
                            // Add/remove class to body for CSS targeting
                            if (isActive) {
                                document.body.classList.add('mobile-menu-active');
                            } else {
                                document.body.classList.remove('mobile-menu-active');
                            }
                        }
                    });
                });

                sidebarObserver.observe(sidebar, { attributes: true });
                
                console.log('Dashboard: Mobile menu compatibility initialized');
            }

            // Handle window resize to ensure proper mobile behavior
            window.addEventListener('resize', function() {
                if (window.innerWidth > 768) {
                    document.body.classList.remove('mobile-menu-active');
                }
            });
        }

       function performGlobalSearch() {
    const searchInput = document.getElementById('globalSearch');
    if (!searchInput) return;

    const query = searchInput.value.trim();
    if (!query) {
        showToast('Please enter a search term', 'warning');
        return;
    }

    fetch('Dashboard.aspx/PerformGlobalSearch', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query: query })
    })
    .then(response => response.json())
    .then(data => {
        if (data.d && data.d.success) {
            displaySearchResults(data.d.results, query);
        } else {
            showToast('Search failed. Please try again.', 'error');
        }
    })
    .catch(error => {
        console.error('Search error:', error);
        showToast('Search failed. Please try again.', 'error');
    });
}

        // Load recent activity
       function loadRecentActivity() {
    const activityContainer = document.getElementById('recentActivity');
    activityContainer.innerHTML = ''; // Clear previous

    fetch('Dashboard.aspx/GetRecentActivity', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            result.d.data.forEach(activity => {
                const activityItem = document.createElement('div');
                activityItem.className = 'activity-item';
                activityItem.innerHTML = `
                    <div class="activity-icon" style="background-color: ${activity.iconBg}">
                        <i class="fas fa-${activity.icon}"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">${activity.title}</div>
                        <div class="activity-time">${activity.time}</div>
                    </div>
                `;
                activityContainer.appendChild(activityItem);
            });
        }
    });
}
     

     let registrationChartInstance = null;
let courseChartInstance = null;
let performanceChartInstance = null;

function initializeCharts() {
    fetch('Dashboard.aspx/GetDashboardChartData', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(result => {
        if (result.d && result.d.success) {
            const data = result.d.data;
            renderCharts(data);
        }
    });
}

function renderCharts(data) {
    const isDarkTheme = document.body.classList.contains('dark-theme');
    const textColor = isDarkTheme ? '#f9fafb' : '#1f2937';
    const gridColor = isDarkTheme ? '#374151' : '#e5e7eb';

    // Registration Trends Chart
    const ctx = document.getElementById('registrationChart').getContext('2d');
    if (registrationChartInstance) registrationChartInstance.destroy();
    registrationChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: data.registrationLabels,
            datasets: [{
                label: 'Students',
                data: data.studentCounts,
                borderColor: '#667eea',
                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                fill: true,
                tension: 0.4
            }, {
                label: 'Teachers',
                data: data.teacherCounts,
                borderColor: '#10b981',
                backgroundColor: 'rgba(16, 185, 129, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                    labels: { color: textColor }
                }
            },
            scales: {
                x: { ticks: { color: textColor }, grid: { color: gridColor } },
                y: { beginAtZero: true, ticks: { color: textColor }, grid: { color: gridColor } }
            }
        }
    });

    // Course Distribution Chart
    const courseCtx = document.getElementById('courseChart').getContext('2d');
    if (courseChartInstance) courseChartInstance.destroy();
    courseChartInstance = new Chart(courseCtx, {
        type: 'doughnut',
        data: {
            labels: data.courseLabels,
            datasets: [{
                data: data.courseCounts,
                backgroundColor: [
                    '#667eea',
                    '#10b981',
                    '#f59e0b',
                    '#ef4444',
                    '#5cf6b1ff',
                    '#8b5cf6',
                    '#06b6d4'
                ],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: textColor, padding: 15 }
                }
            }
        }
    });

    // Performance Overview Chart
    const performanceCtx = document.getElementById('performanceChart').getContext('2d');
    if (performanceChartInstance) performanceChartInstance.destroy();
    performanceChartInstance = new Chart(performanceCtx, {
        type: 'bar',
        data: {
            labels: data.performanceLabels,
            datasets: [{
                label: 'Average Score (%)',
                data: data.performanceScores,
                backgroundColor: [
                    '#667eea',
                    '#10b981',
                    '#f59e0b',
                    '#ef4444',
                    '#8b5cf6',
                    '#06b6d4'
                ],
                borderRadius: 4,
                borderSkipped: false,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { ticks: { color: textColor }, grid: { color: gridColor } },
                y: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        color: textColor,
                        callback: function(value) { return value + '%'; }
                    },
                    grid: { color: gridColor }
                }
            }
        }
    });
}

        // Auto-refresh data every 5 minutes
        setInterval(function() {
            // In a real application, you would fetch updated data from the server
            console.log('Refreshing dashboard data...');
        }, 300000); // 5 minutes

        // Listen for theme changes and update charts
        window.addEventListener('themeChanged', function() {
            // Reload charts with new theme colors
            setTimeout(initializeCharts, 100);
        });
    </script>
</asp:Content>
