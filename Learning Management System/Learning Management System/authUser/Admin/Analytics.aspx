<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Analytics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Analytics Dashboard - Learning Management System</title>
    
    <!-- Chart.js for analytics charts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"></script>
    
    <!-- Date Range Picker -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    
    <!-- PDF Export Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    
    <style>
        /* Analytics Dashboard Custom Theme */
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
            
            /* Chart Colors */
            --chart-blue: #3498db;
            --chart-green: #2ecc71;
            --chart-orange: #f39c12;
            --chart-purple: #9b59b6;
            --chart-teal: #1abc9c;
        }

        body {
            background-color: var(--background-color);
            color: var(--text-color);
            font-family: 'Inter', sans-serif;
        }

        /* Page Header */
        .analytics-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: var(--white);
            box-shadow: 0 8px 32px rgba(44, 43, 124, 0.15);
        }

        .analytics-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: var(--white);
        }

        .analytics-header p {
            margin: 0.75rem 0 0 0;
            opacity: 0.9;
            font-size: 1.1rem;
            color: var(--white);
        }

        /* Controls Section */
        .analytics-controls {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
        }

        .controls-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .date-picker-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .date-range-picker {
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-gray);
            border-radius: 8px;
            background: var(--white);
            color: var(--text-color);
            cursor: pointer;
            min-width: 250px;
            font-size: 0.9rem;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=utf-8,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 0.5rem center;
            background-repeat: no-repeat;
            background-size: 1.5em 1.5em;
            padding-right: 2.5rem;
            transition: all 0.3s ease;
        }

        .date-range-picker:hover {
            border-color: var(--primary-color);
        }

        .date-range-picker:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(44, 43, 124, 0.1);
        }

        .refresh-btn {
            background: linear-gradient(135deg, var(--accent-color) 0%, var(--accent-light) 100%);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            color: var(--white);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .refresh-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(238, 28, 36, 0.3);
        }

        .export-btn {
            background: var(--primary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            color: var(--white);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .export-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-color);
        }

        .stat-card.accent::before { background: var(--accent-color); }
        .stat-card.success::before { background: var(--success-color); }
        .stat-card.warning::before { background: var(--warning-color); }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: var(--white);
        }

        .stat-icon.primary { background: var(--primary-color); }
        .stat-icon.accent { background: var(--accent-color); }
        .stat-icon.success { background: var(--success-color); }
        .stat-icon.warning { background: var(--warning-color); }

        .stat-value {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: var(--medium-gray);
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stat-change {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.75rem;
            font-size: 0.875rem;
        }

        .stat-change.positive { color: var(--success-color); }
        .stat-change.negative { color: var(--danger-color); }

        /* Chart Containers */
        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .chart-container {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-gray);
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-color);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .chart-period {
            color: var(--medium-gray);
            font-size: 0.875rem;
        }

        .chart-canvas {
            position: relative;
            height: 300px;
        }

        .doughnut-chart {
            height: 250px;
        }

        /* Tables */
        .analytics-table {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 0;
            overflow: hidden;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
        }

        .table-header {
            background: var(--light-gray);
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-gray);
        }

        .table-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-color);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .custom-table {
            width: 100%;
            margin: 0;
        }

        .custom-table th {
            background: var(--light-gray);
            color: var(--dark-gray);
            font-weight: 600;
            padding: 1rem 1.5rem;
            border: none;
            font-size: 0.875rem;
        }

        .custom-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-gray);
            color: var(--text-color);
        }

        .custom-table tr:last-child td {
            border-bottom: none;
        }

        .custom-table tbody tr:hover {
            background: var(--light-gray);
        }

        /* Progress Bars */
        .progress-container {
            margin: 0.5rem 0;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .progress-bar-custom {
            height: 8px;
            background: var(--border-gray);
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        .progress-fill.primary { background: var(--primary-color); }
        .progress-fill.accent { background: var(--accent-color); }
        .progress-fill.success { background: var(--success-color); }
        .progress-fill.warning { background: var(--warning-color); }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .charts-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .analytics-header {
                padding: 1.5rem;
            }

            .analytics-header h1 {
                font-size: 2rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .controls-row {
                flex-direction: column;
                align-items: stretch;
            }

            .date-range-picker {
                min-width: auto;
                width: 100%;
            }
        }

        /* Loading State */
        .loading-chart {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 300px;
            color: var(--medium-gray);
        }

        .loading-spinner {
            width: 40px;
            height: 40px;
            border: 4px solid var(--border-gray);
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 1rem;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Filter Pills */
        .filter-pills {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-bottom: 1rem;
        }

        .filter-pill {
            padding: 0.5rem 1rem;
            border: 2px solid var(--border-gray);
            border-radius: 20px;
            background: var(--white);
            color: var(--text-color);
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.875rem;
        }

        .filter-pill.active {
            background: var(--primary-color);
            border-color: var(--primary-color);
            color: var(--white);
        }

        .filter-pill:hover:not(.active) {
            border-color: var(--primary-color);
            color: var(--primary-color);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Analytics Header -->
    <div class="analytics-header">
        <h1>
            <i class="fas fa-chart-line"></i>
            Analytics Dashboard
        </h1>
        <p>Comprehensive insights and performance metrics for your learning management system</p>
    </div>

    <!-- Controls Section -->
    <div class="analytics-controls">
        <div class="controls-row">
            <div class="date-picker-container">
                <i class="fas fa-calendar-alt text-muted me-2"></i>
                <select id="dateRangePicker" class="date-range-picker">
                    <option value="today">Today</option>
                    <option value="last7days">Last 7 Days</option>
                    <option value="last30days" selected>Last 30 Days</option>
                    <option value="lastmonth">Last Month</option>
                    <option value="lastyear">Last Year</option>
                </select>
            </div>
            <div class="d-flex gap-2">
                <button class="refresh-btn" onclick="refreshData()">
                    <i class="fas fa-sync-alt me-2"></i>
                    Refresh Data
                </button>
                <button class="export-btn" onclick="exportData()">
                    <i class="fas fa-download me-2"></i>
                    Export Report
                </button>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-value" id="totalStudents">1,247</div>
                    <div class="stat-label">Total Students</div>
                </div>
                <div class="stat-icon primary">
                    <i class="fas fa-user-graduate"></i>
                </div>
            </div>
            <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i>
                <span>+12% from last month</span>
            </div>
        </div>

        <div class="stat-card accent">
            <div class="stat-header">
                <div>
                    <div class="stat-value" id="activeCourses">89</div>
                    <div class="stat-label">Active Courses</div>
                </div>
                <div class="stat-icon accent">
                    <i class="fas fa-graduation-cap"></i>
                </div>
            </div>
            <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i>
                <span>+5% from last month</span>
            </div>
        </div>

        <div class="stat-card success">
            <div class="stat-header">
                <div>
                    <div class="stat-value" id="completionRate">87.3%</div>
                    <div class="stat-label">Avg. Completion Rate</div>
                </div>
                <div class="stat-icon success">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
            <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i>
                <span>+3.2% from last month</span>
            </div>
        </div>

        <div class="stat-card warning">
            <div class="stat-header">
                <div>
                    <div class="stat-value" id="totalRevenue">₵45,230</div>
                    <div class="stat-label">Total Revenue</div>
                </div>
                <div class="stat-icon warning">
                    <i class="fas fa-money-bill-wave"></i>
                </div>
            </div>
            <div class="stat-change negative">
                <i class="fas fa-arrow-down"></i>
                <span>-2.1% from last month</span>
            </div>
        </div>
    </div>

    <!-- Charts Section -->
    <div class="charts-grid">
        <!-- Main Chart -->
        <div class="chart-container">
            <div class="chart-header">
                <h3 class="chart-title">
                    <i class="fas fa-chart-area"></i>
                    Student Enrollment Trends
                </h3>
                <div class="filter-pills">
                    <div class="filter-pill active" onclick="setChartPeriod('7d')">7 Days</div>
                    <div class="filter-pill" onclick="setChartPeriod('30d')">30 Days</div>
                    <div class="filter-pill" onclick="setChartPeriod('90d')">90 Days</div>
                    <div class="filter-pill" onclick="setChartPeriod('1y')">1 Year</div>
                </div>
            </div>
            <div class="chart-canvas">
                <canvas id="enrollmentChart"></canvas>
            </div>
        </div>

        <!-- Side Charts -->
        <div>
            <div class="chart-container mb-3">
                <div class="chart-header">
                    <h3 class="chart-title">
                        <i class="fas fa-chart-pie"></i>
                        Course Categories
                    </h3>
                </div>
                <div class="chart-canvas doughnut-chart">
                    <canvas id="categoriesChart"></canvas>
                </div>
            </div>

            <div class="chart-container">
                <div class="chart-header">
                    <h3 class="chart-title">
                        <i class="fas fa-users"></i>
                        User Activity
                    </h3>
                </div>
                <div class="chart-canvas doughnut-chart">
                    <canvas id="activityChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Performance Table -->
    <div class="row">
        <div class="col-lg-8">
            <div class="analytics-table">
                <div class="table-header">
                    <h3 class="table-title">
                        <i class="fas fa-trophy"></i>
                        Top Performing Courses
                    </h3>
                </div>
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Course Name</th>
                            <th>Students</th>
                            <th>Completion Rate</th>
                            <th>Avg. Score</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong>Introduction to Computer Science</strong>
                                <br><small class="text-muted">CS101</small>
                            </td>
                            <td>156</td>
                            <td>
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span>94%</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill success" style="width: 94%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>88.5%</td>
                            <td><span class="badge bg-success">Excellent</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Calculus II</strong>
                                <br><small class="text-muted">MATH201</small>
                            </td>
                            <td>89</td>
                            <td>
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span>87%</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill primary" style="width: 87%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>82.3%</td>
                            <td><span class="badge bg-primary">Good</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>English Composition</strong>
                                <br><small class="text-muted">ENG101</small>
                            </td>
                            <td>203</td>
                            <td>
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span>91%</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill success" style="width: 91%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>85.7%</td>
                            <td><span class="badge bg-success">Excellent</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Business Ethics</strong>
                                <br><small class="text-muted">BUS205</small>
                            </td>
                            <td>67</td>
                            <td>
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span>76%</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill warning" style="width: 76%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>78.2%</td>
                            <td><span class="badge bg-warning">Needs Attention</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Educational Psychology</strong>
                                <br><small class="text-muted">EDU301</small>
                            </td>
                            <td>124</td>
                            <td>
                                <div class="progress-container">
                                    <div class="progress-label">
                                        <span>89%</span>
                                    </div>
                                    <div class="progress-bar-custom">
                                        <div class="progress-fill primary" style="width: 89%"></div>
                                    </div>
                                </div>
                            </td>
                            <td>84.1%</td>
                            <td><span class="badge bg-primary">Good</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="analytics-table">
                <div class="table-header">
                    <h3 class="table-title">
                        <i class="fas fa-clock"></i>
                        Recent Activity
                    </h3>
                </div>
                <div class="p-3">
                    <div class="activity-item mb-3 pb-3 border-bottom">
                        <div class="d-flex align-items-start">
                            <div class="stat-icon primary me-3" style="width: 32px; height: 32px; font-size: 0.875rem;">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div>
                                <div><strong>25 new students enrolled</strong></div>
                                <small class="text-muted">2 hours ago</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item mb-3 pb-3 border-bottom">
                        <div class="d-flex align-items-start">
                            <div class="stat-icon success me-3" style="width: 32px; height: 32px; font-size: 0.875rem;">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div>
                                <div><strong>12 courses completed</strong></div>
                                <small class="text-muted">4 hours ago</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item mb-3 pb-3 border-bottom">
                        <div class="d-flex align-items-start">
                            <div class="stat-icon accent me-3" style="width: 32px; height: 32px; font-size: 0.875rem;">
                                <i class="fas fa-book"></i>
                            </div>
                            <div>
                                <div><strong>New course published</strong></div>
                                <small class="text-muted">6 hours ago</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item mb-3 pb-3 border-bottom">
                        <div class="d-flex align-items-start">
                            <div class="stat-icon warning me-3" style="width: 32px; height: 32px; font-size: 0.875rem;">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div>
                                <div><strong>3 courses need attention</strong></div>
                                <small class="text-muted">8 hours ago</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="d-flex align-items-start">
                            <div class="stat-icon primary me-3" style="width: 32px; height: 32px; font-size: 0.875rem;">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div>
                                <div><strong>Monthly report generated</strong></div>
                                <small class="text-muted">1 day ago</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Analytics JavaScript -->
    <script>
        // Fixed Custom Theme - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Fixed custom theme applied to Analytics.aspx');
            initializeAnalytics();
        });

        function initializeAnalytics() {
            // Initialize date range dropdown
            initializeDateRangeDropdown();
            
            // Initialize charts
            initializeEnrollmentChart();
            initializeCategoriesChart();
            initializeActivityChart();
            
            // Start auto-refresh
            setInterval(updateStatistics, 30000); // Update every 30 seconds
        }

        function initializeDateRangeDropdown() {
            const dropdown = document.getElementById('dateRangePicker');
            
            dropdown.addEventListener('change', function() {
                const selectedPeriod = this.value;
                console.log('Date range changed to:', selectedPeriod);
                
                // Update charts and data based on selected period
                updateDataForPeriod(selectedPeriod);
                refreshData();
            });
            
            // Set initial period
            updateDataForPeriod('last30days');
        }

        function updateDataForPeriod(period) {
            let startDate, endDate, displayText;
            
            switch(period) {
                case 'today':
                    startDate = moment();
                    endDate = moment();
                    displayText = 'Today';
                    break;
                case 'last7days':
                    startDate = moment().subtract(6, 'days');
                    endDate = moment();
                    displayText = 'Last 7 Days';
                    break;
                case 'last30days':
                    startDate = moment().subtract(29, 'days');
                    endDate = moment();
                    displayText = 'Last 30 Days';
                    break;
                case 'lastmonth':
                    startDate = moment().subtract(1, 'month').startOf('month');
                    endDate = moment().subtract(1, 'month').endOf('month');
                    displayText = 'Last Month';
                    break;
                case 'lastyear':
                    startDate = moment().subtract(1, 'year').startOf('year');
                    endDate = moment().subtract(1, 'year').endOf('year');
                    displayText = 'Last Year';
                    break;
                default:
                    startDate = moment().subtract(29, 'days');
                    endDate = moment();
                    displayText = 'Last 30 Days';
            }
            
            console.log(`Period: ${displayText} - From: ${startDate.format('YYYY-MM-DD')} To: ${endDate.format('YYYY-MM-DD')}`);
            
            // Here you would typically update charts with new data based on the date range
            // For now, we'll just log the change
        }

        function initializeEnrollmentChart() {
            const ctx = document.getElementById('enrollmentChart').getContext('2d');
            
            const enrollmentData = {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                datasets: [{
                    label: 'New Enrollments',
                    data: [85, 92, 78, 115, 103, 87, 94, 108, 125, 98, 87, 102],
                    borderColor: '#2c2b7c',
                    backgroundColor: 'rgba(44, 43, 124, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }, {
                    label: 'Completions',
                    data: [72, 81, 65, 98, 89, 76, 82, 95, 108, 85, 76, 89],
                    borderColor: '#ee1c24',
                    backgroundColor: 'rgba(238, 28, 36, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            };

            new Chart(ctx, {
                type: 'line',
                data: enrollmentData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                usePointStyle: true,
                                padding: 20
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: '#e0e0e0'
                            }
                        },
                        x: {
                            grid: {
                                color: '#e0e0e0'
                            }
                        }
                    },
                    elements: {
                        point: {
                            radius: 4,
                            hoverRadius: 6
                        }
                    }
                }
            });
        }

        function initializeCategoriesChart() {
            const ctx = document.getElementById('categoriesChart').getContext('2d');
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Computer Science', 'Mathematics', 'English', 'Business', 'Education'],
                    datasets: [{
                        data: [35, 25, 20, 12, 8],
                        backgroundColor: [
                            '#2c2b7c',
                            '#ee1c24',
                            '#28a745',
                            '#ffc107',
                            '#3498db'
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
                            labels: {
                                padding: 15,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });
        }

        function initializeActivityChart() {
            const ctx = document.getElementById('activityChart').getContext('2d');
            
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Active Users', 'Inactive Users', 'New Users'],
                    datasets: [{
                        data: [68, 22, 10],
                        backgroundColor: [
                            '#28a745',
                            '#ffc107',
                            '#2c2b7c'
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
                            labels: {
                                padding: 15,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });
        }

        function setChartPeriod(period) {
            // Remove active class from all pills
            document.querySelectorAll('.filter-pill').forEach(pill => {
                pill.classList.remove('active');
            });
            
            // Add active class to clicked pill
            event.target.classList.add('active');
            
            // Update chart data based on period
            console.log('Chart period changed to:', period);
            // Here you would typically fetch new data and update the chart
        }

        function refreshData() {
            // Show loading state
            showLoadingState();
            
            // Simulate data refresh
            setTimeout(() => {
                updateStatistics();
                hideLoadingState();
                showSuccessMessage('Data refreshed successfully!');
            }, 1500);
        }

        function updateStatistics() {
            // Simulate real-time updates
            const totalStudents = Math.floor(Math.random() * 100) + 1200;
            const activeCourses = Math.floor(Math.random() * 20) + 80;
            const completionRate = (Math.random() * 10 + 85).toFixed(1);
            const totalRevenue = Math.floor(Math.random() * 5000) + 40000;
            
            document.getElementById('totalStudents').textContent = totalStudents.toLocaleString();
            document.getElementById('activeCourses').textContent = activeCourses;
            document.getElementById('completionRate').textContent = completionRate + '%';
            document.getElementById('totalRevenue').textContent = '₵' + totalRevenue.toLocaleString();
        }

        function exportData() {
            showSuccessMessage('Generating PDF report...');
            
            // Show loading state
            const exportBtn = document.querySelector('.export-btn');
            const originalContent = exportBtn.innerHTML;
            exportBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Generating PDF...';
            exportBtn.disabled = true;
            
            // Wait a moment for UI update, then generate PDF
            setTimeout(() => {
                generatePDFReport().then(() => {
                    // Restore button
                    exportBtn.innerHTML = originalContent;
                    exportBtn.disabled = false;
                    showSuccessMessage('PDF report downloaded successfully!');
                }).catch(error => {
                    console.error('PDF generation failed:', error);
                    exportBtn.innerHTML = originalContent;
                    exportBtn.disabled = false;
                    showErrorMessage('Failed to generate PDF report. Please try again.');
                });
            }, 500);
        }

        async function generatePDFReport() {
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');
            
            // Set default font to avoid encoding issues
            pdf.setFont('helvetica');
            
            // PDF dimensions
            const pageWidth = pdf.internal.pageSize.getWidth();
            const pageHeight = pdf.internal.pageSize.getHeight();
            const margin = 20;
            const contentWidth = pageWidth - (margin * 2);
            
            // Colors matching the theme
            const primaryColor = [44, 43, 124];
            const accentColor = [238, 28, 36];
            const textColor = [51, 51, 51];
            const lightGray = [248, 249, 250];
            
            let yPosition = margin;
            
            // Header
            pdf.setFillColor(...primaryColor);
            pdf.rect(0, 0, pageWidth, 40, 'F');
            
            pdf.setTextColor(255, 255, 255);
            pdf.setFontSize(24);
            pdf.setFont(undefined, 'bold');
            pdf.text('Analytics Dashboard Report', margin, 25);
            
            pdf.setFontSize(12);
            pdf.setFont(undefined, 'normal');
            const currentDate = new Date().toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
            pdf.text(`Generated on: ${currentDate}`, margin, 35);
            
            yPosition = 50;
            
            // Report Period
            const selectedPeriod = document.getElementById('dateRangePicker').selectedOptions[0].text;
            pdf.setTextColor(...textColor);
            pdf.setFontSize(14);
            pdf.setFont(undefined, 'bold');
            pdf.text(`Report Period: ${selectedPeriod}`, margin, yPosition);
            yPosition += 15;
            
            // Key Statistics Section
            pdf.setFillColor(...lightGray);
            pdf.rect(margin, yPosition, contentWidth, 10, 'F');
            pdf.setTextColor(...primaryColor);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('KEY PERFORMANCE INDICATORS', margin + 5, yPosition + 7);
            yPosition += 18;
            
            // Statistics data
            const stats = [
                { label: 'Total Students', value: document.getElementById('totalStudents').textContent, symbol: '[STUDENTS]' },
                { label: 'Active Courses', value: document.getElementById('activeCourses').textContent, symbol: '[COURSES]' },
                { label: 'Avg. Completion Rate', value: document.getElementById('completionRate').textContent, symbol: '[COMPLETION]' },
                { label: 'Total Revenue', value: document.getElementById('totalRevenue').textContent, symbol: '[REVENUE]' }
            ];
            
            pdf.setTextColor(...textColor);
            pdf.setFontSize(11);
            
            stats.forEach((stat, index) => {
                const xPos = margin + (index % 2) * (contentWidth / 2);
                const yPos = yPosition + Math.floor(index / 2) * 25;
                
                // Draw background box for each stat
                pdf.setFillColor(252, 253, 255);
                pdf.rect(xPos, yPos - 8, (contentWidth / 2) - 5, 20, 'F');
                pdf.setDrawColor(...primaryColor);
                pdf.setLineWidth(0.5);
                pdf.rect(xPos, yPos - 8, (contentWidth / 2) - 5, 20, 'S');
                
                // Draw bullet point
                pdf.setFillColor(...primaryColor);
                pdf.circle(xPos + 4, yPos - 1, 1.5, 'F');
                
                pdf.setFont('helvetica', 'normal');
                pdf.text(stat.label + ':', xPos + 10, yPos);
                pdf.setFont('helvetica', 'bold');
                pdf.setFontSize(13);
                pdf.text(stat.value, xPos + 10, yPos + 8);
                pdf.setFontSize(11);
            });
            
            yPosition += 60;
            
            // Top Performing Courses Section
            if (yPosition > pageHeight - 80) {
                pdf.addPage();
                yPosition = margin;
            }
            
            pdf.setFillColor(...lightGray);
            pdf.rect(margin, yPosition, contentWidth, 10, 'F');
            pdf.setTextColor(...primaryColor);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('TOP PERFORMING COURSES', margin + 5, yPosition + 7);
            yPosition += 18;
            
            // Table headers
            pdf.setTextColor(...textColor);
            pdf.setFontSize(10);
            pdf.setFont('helvetica', 'bold');
            
            const tableHeaders = ['Course Name', 'Students', 'Completion', 'Avg. Score', 'Status'];
            const colWidths = [65, 22, 30, 25, 28];
            let xPos = margin;
            
            pdf.setFillColor(...primaryColor);
            pdf.rect(margin, yPosition, contentWidth, 10, 'F');
            pdf.setTextColor(255, 255, 255);
            
            tableHeaders.forEach((header, index) => {
                pdf.text(header, xPos + 2, yPosition + 7);
                xPos += colWidths[index];
            });
            
            yPosition += 12;
            
            // Table data
            const courseData = [
                ['Introduction to Computer Science', '156', '94%', '88.5%', 'Excellent'],
                ['Calculus II', '89', '87%', '82.3%', 'Good'],
                ['English Composition', '203', '91%', '85.7%', 'Excellent'],
                ['Business Ethics', '67', '76%', '78.2%', 'Needs Attention'],
                ['Educational Psychology', '124', '89%', '84.1%', 'Good']
            ];
            
            pdf.setTextColor(...textColor);
            pdf.setFont('helvetica', 'normal');
            pdf.setFontSize(9);
            
            courseData.forEach((row, rowIndex) => {
                xPos = margin;
                const rowY = yPosition + (rowIndex * 14);
                
                // Alternate row background
                if (rowIndex % 2 === 0) {
                    pdf.setFillColor(248, 249, 250);
                    pdf.rect(margin, rowY - 3, contentWidth, 12, 'F');
                }
                
                row.forEach((cell, colIndex) => {
                    if (colIndex === 0) {
                        pdf.setFont('helvetica', 'bold');
                    } else {
                        pdf.setFont('helvetica', 'normal');
                    }
                    
                    // Truncate long text
                    let displayText = cell;
                    if (colIndex === 0 && cell.length > 28) {
                        displayText = cell.substring(0, 25) + '...';
                    }
                    
                    pdf.text(displayText, xPos + 2, rowY + 6);
                    xPos += colWidths[colIndex];
                });
            });
            
            yPosition += courseData.length * 14 + 25;
            
            // Charts Section
            if (yPosition > pageHeight - 100) {
                pdf.addPage();
                yPosition = margin;
            }
            
            pdf.setFillColor(...lightGray);
            pdf.rect(margin, yPosition, contentWidth, 10, 'F');
            pdf.setTextColor(...primaryColor);
            pdf.setFontSize(14);
            pdf.setFont('helvetica', 'bold');
            pdf.text('VISUAL ANALYTICS', margin + 5, yPosition + 7);
            yPosition += 18;
            
            pdf.setTextColor(...textColor);
            pdf.setFontSize(11);
            pdf.setFont('helvetica', 'normal');
            pdf.text('- Interactive charts and visualizations are available in the web dashboard.', margin, yPosition);
            yPosition += 12;
            pdf.text('- For detailed trend analysis, please refer to the online analytics portal.', margin, yPosition);
            yPosition += 12;
            pdf.text('- Real-time data updates are accessible through the LMS interface.', margin, yPosition);
            yPosition += 25;
            
            // Footer with timestamp and system info
            pdf.setFontSize(8);
            pdf.setTextColor(128, 128, 128);
            pdf.setFont('helvetica', 'normal');
            pdf.text('Learning Management System - Analytics Report', margin, pageHeight - 15);
            pdf.text('Generated: ' + new Date().toLocaleString(), pageWidth - margin - 60, pageHeight - 15);
            
            // Save the PDF
            const fileName = 'LMS_Analytics_Report_' + new Date().toISOString().split('T')[0] + '.pdf';
            pdf.save(fileName);
        }

        function showErrorMessage(message) {
            // Create an error toast notification
            const toast = document.createElement('div');
            toast.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #dc3545;
                color: white;
                padding: 1rem 1.5rem;
                border-radius: 8px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.2);
                z-index: 1000;
                animation: slideInRight 0.3s ease;
            `;
            toast.innerHTML = `<i class="fas fa-exclamation-circle me-2"></i>${message}`;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 4000);
        }

        function showLoadingState() {
            // Add loading indicators to charts
            document.querySelectorAll('.chart-canvas').forEach(canvas => {
                if (!canvas.querySelector('.loading-chart')) {
                    const loading = document.createElement('div');
                    loading.className = 'loading-chart';
                    loading.innerHTML = '<div class="loading-spinner"></div> Updating data...';
                    canvas.appendChild(loading);
                }
            });
        }

        function hideLoadingState() {
            // Remove loading indicators
            document.querySelectorAll('.loading-chart').forEach(loading => {
                loading.remove();
            });
        }

        function showSuccessMessage(message) {
            // Create a toast notification
            const toast = document.createElement('div');
            toast.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #28a745;
                color: white;
                padding: 1rem 1.5rem;
                border-radius: 8px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.2);
                z-index: 1000;
                animation: slideInRight 0.3s ease;
            `;
            toast.innerHTML = `<i class="fas fa-check-circle me-2"></i>${message}`;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        // Add CSS animations for toast
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideInRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutRight {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    </script>
</asp:Content>
