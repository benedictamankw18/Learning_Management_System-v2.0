<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Backup.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Backup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Backup Management - Learning Management System</title>
    
    <!-- SweetAlert2 for notifications -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- Chart.js for analytics -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        /* Backup Page Custom Theme */
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
        }

        body {
            background-color: var(--background-color);
            color: var(--text-color);
            font-family: 'Inter', sans-serif;
        }

        /* Backup Header */
        .backup-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            color: var(--white);
            box-shadow: 0 8px 32px rgba(44, 43, 124, 0.15);
        }

        .backup-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 1rem;
            color: var(--white);
        }

        .backup-header p {
            margin: 0.75rem 0 0 0;
            opacity: 0.9;
            font-size: 1.1rem;
            color: var(--white);
        }

        .header-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1.5rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--white);
        }

        .stat-label {
            font-size: 0.875rem;
            opacity: 0.8;
            color: var(--white);
        }

        /* Status Cards */
        .status-card {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .status-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .status-card.success {
            border-left: 4px solid var(--success-color);
        }

        .status-card.warning {
            border-left: 4px solid var(--warning-color);
        }

        .status-card.danger {
            border-left: 4px solid var(--danger-color);
        }

        .status-card.info {
            border-left: 4px solid var(--info-color);
        }

        .card-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-color);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-color);
        }

        .card-subtitle {
            color: var(--medium-gray);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .btn-primary-custom {
            background: var(--primary-color);
            border: none;
            color: var(--white);
            padding: 0.875rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary-custom:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(44, 43, 124, 0.25);
        }

        .btn-success-custom {
            background: var(--success-color);
            border: none;
            color: var(--white);
            padding: 0.875rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-success-custom:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.25);
        }

        .btn-danger-custom {
            background: var(--danger-color);
            border: none;
            color: var(--white);
            padding: 0.875rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-danger-custom:hover {
            background: var(--accent-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(238, 28, 36, 0.25);
        }

        .btn-warning-custom {
            background: var(--warning-color);
            border: none;
            color: var(--dark-gray);
            padding: 0.875rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-warning-custom:hover {
            background: #e0a800;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 193, 7, 0.25);
        }

        /* Content Sections */
        .content-section {
            background: var(--white);
            border: 1px solid var(--border-gray);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-subtitle {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        /* Backup History Table */
        .backup-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .backup-table th {
            background: var(--light-gray);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--dark-gray);
            border-bottom: 2px solid var(--border-gray);
        }

        .backup-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-gray);
            color: var(--text-color);
        }

        .backup-table tbody tr:hover {
            background: var(--light-gray);
        }

        /* Status Badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.success {
            background: rgba(40, 167, 69, 0.2);
            color: var(--success-color);
        }

        .status-badge.failed {
            background: rgba(238, 28, 36, 0.2);
            color: var(--danger-color);
        }

        .status-badge.running {
            background: rgba(255, 193, 7, 0.2);
            color: var(--warning-color);
        }

        .status-badge.scheduled {
            background: rgba(44, 43, 124, 0.2);
            color: var(--primary-color);
        }

        /* Progress Bars */
        .progress-container {
            margin: 1rem 0;
        }

        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
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
        .progress-fill.success { background: var(--success-color); }
        .progress-fill.warning { background: var(--warning-color); }
        .progress-fill.danger { background: var(--danger-color); }

        /* Form Controls */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control, .form-select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-gray);
            border-radius: 8px;
            background: var(--white);
            color: var(--text-color);
            transition: all 0.3s ease;
            background-repeat: no-repeat;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(44, 43, 124, 0.25);
            outline: none;
        }

        /* Action Buttons in Table */
        .table-actions {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.75rem;
            border-radius: 6px;
        }

        /* Charts Container */
        .chart-container {
            position: relative;
            height: 300px;
            margin: 1.5rem 0;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border: 1px solid transparent;
        }

        .alert-warning {
            background: rgba(255, 193, 7, 0.1);
            border-color: var(--warning-color);
            color: #856404;
        }

        .alert-danger {
            background: rgba(238, 28, 36, 0.1);
            border-color: var(--danger-color);
            color: #721c24;
        }

        .alert-info {
            background: rgba(44, 43, 124, 0.1);
            border-color: var(--primary-color);
            color: var(--primary-dark);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .backup-header {
                padding: 1.5rem;
            }

            .backup-header h1 {
                font-size: 2rem;
            }

            .header-stats {
                flex-direction: column;
                gap: 1rem;
            }

            .action-buttons {
                flex-direction: column;
            }

            .content-section {
                padding: 1.5rem;
            }

            .backup-table {
                font-size: 0.875rem;
            }

            .backup-table th,
            .backup-table td {
                padding: 0.75rem 0.5rem;
            }
        }

        /* Animation */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Loading Spinner */
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: var(--white);
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* File Size Display */
        .file-size {
            font-family: 'Courier New', monospace;
            font-weight: 600;
        }

        /* Backup Type Icons */
        .backup-type {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Backup Header -->
    <div class="backup-header">
        <h1>
            <i class="fas fa-database"></i>
            Backup Management
        </h1>
        <p>Create, schedule, and manage system backups to ensure data protection and recovery</p>
        
        <div class="header-stats">
            <div class="stat-item">
                <div class="stat-value" id="totalBackups">12</div>
                <div class="stat-label">Total Backups</div>
            </div>
            <div class="stat-item">
                <div class="stat-value" id="totalSize">15.8 GB</div>
                <div class="stat-label">Total Size</div>
            </div>
            <div class="stat-item">
                <div class="stat-value" id="lastBackup">2h ago</div>
                <div class="stat-label">Last Backup</div>
            </div>
            <div class="stat-item">
                <div class="stat-value" id="nextBackup">22h</div>
                <div class="stat-label">Next Backup</div>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <button type="button" class="btn-success-custom" onclick="return createBackup(event);">
            <i class="fas fa-plus"></i>Create New Backup
        </button>
        <button type="button" class="btn-primary-custom" onclick="return scheduleBackup(event);">
            <i class="fas fa-clock"></i>Schedule Backup
        </button>
        <button type="button" class="btn-warning-custom" onclick="return uploadBackup(event);">
            <i class="fas fa-upload"></i>Upload Backup
        </button>
        <button type="button" class="btn-danger-custom" onclick="return restoreSystem(event);">
            <i class="fas fa-undo"></i>Restore System
        </button>
    </div>

    <!-- Current Status Cards -->
    <div class="row">
        <div class="col-lg-3 col-md-6">
            <div class="status-card success">
                <div class="card-header">
                    <h6 class="card-title">
                        <i class="fas fa-check-circle"></i>
                        Backup Status
                    </h6>
                </div>
                <div class="card-value">All Systems Healthy</div>
                <div class="card-subtitle">Last check: 5 minutes ago</div>
            </div>
        </div>
        
        <div class="col-lg-3 col-md-6">
            <div class="status-card info">
                <div class="card-header">
                    <h6 class="card-title">
                        <i class="fas fa-hdd"></i>
                        Storage Usage
                    </h6>
                </div>
                <div class="card-value">67.3%</div>
                <div class="progress-container">
                    <div class="progress-bar-custom">
                        <div class="progress-fill primary" style="width: 67%"></div>
                    </div>
                </div>
                <div class="card-subtitle">15.8 GB of 23.5 GB used</div>
            </div>
        </div>
        
        <div class="col-lg-3 col-md-6">
            <div class="status-card warning">
                <div class="card-header">
                    <h6 class="card-title">
                        <i class="fas fa-exclamation-triangle"></i>
                        Retention Policy
                    </h6>
                </div>
                <div class="card-value">3 Expiring Soon</div>
                <div class="card-subtitle">Backups older than 30 days</div>
            </div>
        </div>
        
        <div class="col-lg-3 col-md-6">
            <div class="status-card success">
                <div class="card-header">
                    <h6 class="card-title">
                        <i class="fas fa-shield-alt"></i>
                        Security
                    </h6>
                </div>
                <div class="card-value">Encrypted</div>
                <div class="card-subtitle">AES-256 encryption enabled</div>
            </div>
        </div>
    </div>

    <!-- Backup Configuration -->
    <div class="content-section">
        <h2 class="section-title">
            <i class="fas fa-cogs"></i>
            Backup Configuration
        </h2>
        <p class="section-subtitle">Configure automatic backup settings and preferences</p>
        
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label class="form-label">Backup Frequency</label>
                    <select class="form-select" id="backupFrequency">
                        <option value="daily" selected>Daily</option>
                        <option value="weekly">Weekly</option>
                        <option value="monthly">Monthly</option>
                        <option value="custom">Custom Schedule</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label class="form-label">Backup Time</label>
                    <input type="time" class="form-control" id="backupTime" value="02:00">
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label class="form-label">Retention Period (Days)</label>
                    <input type="number" class="form-control" id="retentionDays" value="30" min="7" max="365">
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label class="form-label">Compression Level</label>
                    <select class="form-select" id="compressionLevel">
                        <option value="none">No Compression</option>
                        <option value="low">Low (Fast)</option>
                        <option value="medium" selected>Medium (Balanced)</option>
                        <option value="high">High (Maximum)</option>
                    </select>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <label class="form-label">Storage Location</label>
                    <select class="form-select" id="storageLocation">
                        <option value="local" selected>Local Server</option>
                        <option value="azure">Azure Blob Storage</option>
                        <option value="aws">AWS S3</option>
                        <option value="google">Google Cloud Storage</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label class="form-label">Max Backup Files</label>
                    <input type="number" class="form-control" id="maxBackupFiles" value="10" min="3" max="50">
                </div>
            </div>
        </div>
        
        <button type="button" class="btn-primary-custom" onclick="return saveBackupConfig(event);">
            <i class="fas fa-save"></i>Save Configuration
        </button>
    </div>

    <!-- Backup Progress (Hidden by default) -->
    <div class="content-section" id="backupProgress" style="display: none;">
        <h2 class="section-title">
            <i class="fas fa-spinner fa-spin"></i>
            Backup in Progress
        </h2>
        
        <div class="alert alert-info">
            <strong>Creating backup...</strong> This process may take several minutes depending on database size.
        </div>
        
        <div class="progress-container">
            <div class="progress-label">
                <span>Database Backup</span>
                <span id="dbProgress">0%</span>
            </div>
            <div class="progress-bar-custom">
                <div class="progress-fill primary" id="dbProgressBar" style="width: 0%"></div>
            </div>
        </div>
        
        <div class="progress-container">
            <div class="progress-label">
                <span>File Backup</span>
                <span id="fileProgress">0%</span>
            </div>
            <div class="progress-bar-custom">
                <div class="progress-fill success" id="fileProgressBar" style="width: 0%"></div>
            </div>
        </div>
        
        <div class="progress-container">
            <div class="progress-label">
                <span>Compression</span>
                <span id="compressionProgress">0%</span>
            </div>
            <div class="progress-bar-custom">
                <div class="progress-fill warning" id="compressionProgressBar" style="width: 0%"></div>
            </div>
        </div>
    </div>

    <!-- Backup History -->
    <div class="content-section">
        <h2 class="section-title">
            <i class="fas fa-history"></i>
            Backup History
        </h2>
        <p class="section-subtitle">View and manage your backup history and files</p>
        
        <div class="table-responsive">
            <table class="backup-table">
                <thead>
                    <tr>
                        <th>Backup Name</th>
                        <th>Type</th>
                        <th>Date Created</th>
                        <th>Size</th>
                        <th>Duration</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="backupHistoryTable">
                    <tr>
                        <td>
                            <div class="backup-type">
                                <i class="fas fa-database text-primary"></i>
                                LMS_Full_20250806_020015
                            </div>
                        </td>
                        <td>Full Backup</td>
                        <td>Aug 6, 2025 02:00:15</td>
                        <td><span class="file-size">2.34 GB</span></td>
                        <td>12m 34s</td>
                        <td><span class="status-badge success">Success</span></td>
                        <td>
                            <div class="table-actions">
                                <button type="button" class="btn-primary-custom btn-sm" onclick="return downloadBackup(event, 'LMS_Full_20250806_020015');">
                                    <i class="fas fa-download"></i>
                                </button>
                                <button type="button" class="btn-info-custom btn-sm" onclick="return viewBackupDetails(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn-success-custom btn-sm" onclick="return restoreBackup(event, 'LMS_Full_20250806_020015');">
                                    <i class="fas fa-undo"></i>
                                </button>
                                <button type="button" class="btn-danger-custom btn-sm" onclick="return deleteBackup(event, 'LMS_Full_20250806_020015');">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="backup-type">
                                <i class="fas fa-database text-warning"></i>
                                LMS_Incremental_20250805_140022
                            </div>
                        </td>
                        <td>Incremental</td>
                        <td>Aug 5, 2025 14:00:22</td>
                        <td><span class="file-size">856 MB</span></td>
                        <td>4m 18s</td>
                        <td><span class="status-badge success">Success</span></td>
                        <td>
                            <div class="table-actions">
                                <button type="button" class="btn-primary-custom btn-sm" onclick="return downloadBackup(event, 'LMS_Incremental_20250805_140022');">
                                    <i class="fas fa-download"></i>
                                </button>
                                <button type="button" class="btn-info-custom btn-sm" onclick="return viewBackupDetails(event, 'LMS_Incremental_20250805_140022');">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn-success-custom btn-sm" onclick="return restoreBackup(event, 'LMS_Incremental_20250805_140022');">
                                    <i class="fas fa-undo"></i>
                                </button>
                                <button type="button" class="btn-danger-custom btn-sm" onclick="return deleteBackup(event, 'LMS_Incremental_20250805_140022');">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="backup-type">
                                <i class="fas fa-database text-success"></i>
                                LMS_Full_20250805_020011
                            </div>
                        </td>
                        <td>Full Backup</td>
                        <td>Aug 5, 2025 02:00:11</td>
                        <td><span class="file-size">2.28 GB</span></td>
                        <td>11m 52s</td>
                        <td><span class="status-badge success">Success</span></td>
                        <td>
                            <div class="table-actions">
                                <button type="button" class="btn-primary-custom btn-sm" onclick="return downloadBackup(event, 'LMS_Full_20250805_020011');">
                                    <i class="fas fa-download"></i>
                                </button>
                                <button type="button" class="btn-info-custom btn-sm" onclick="return viewBackupDetails(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn-success-custom btn-sm" onclick="return restoreBackup(event, 'LMS_Full_20250805_020011');">
                                    <i class="fas fa-undo"></i>
                                </button>
                                <button type="button" class="btn-danger-custom btn-sm" onclick="return deleteBackup(event, 'LMS_Full_20250805_020011');">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="backup-type">
                                <i class="fas fa-database text-danger"></i>
                                LMS_Full_20250804_020008
                            </div>
                        </td>
                        <td>Full Backup</td>
                        <td>Aug 4, 2025 02:00:08</td>
                        <td><span class="file-size">--</span></td>
                        <td>--</td>
                        <td><span class="status-badge failed">Failed</span></td>
                        <td>
                            <div class="table-actions">
                                <button type="button" class="btn-warning-custom btn-sm" onclick="return viewBackupLogs(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-file-alt"></i>
                                </button>
                                <button type="button" class="btn-info-custom btn-sm" onclick="return viewBackupDetails(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn-primary-custom btn-sm" onclick="return retryBackup(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-redo"></i>
                                </button>
                                <button type="button" class="btn-danger-custom btn-sm" onclick="return deleteBackup(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="backup-type">
                                <i class="fas fa-database text-primary"></i>
                                LMS_Full_20250803_020005
                            </div>
                        </td>
                        <td>Full Backup</td>
                        <td>Aug 3, 2025 02:00:05</td>
                        <td><span class="file-size">2.21 GB</span></td>
                        <td>10m 45s</td>
                        <td><span class="status-badge success">Success</span></td>
                        <td>
                            <div class="table-actions">
                                <button type="button" class="btn-primary-custom btn-sm" onclick="return downloadBackup(event, 'LMS_Full_20250803_020005');">
                                    <i class="fas fa-download"></i>
                                </button>
                                 <button type="button" class="btn-info-custom btn-sm" onclick="return viewBackupDetails(event, 'LMS_Full_20250804_020008');">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn-success-custom btn-sm" onclick="return restoreBackup(event, 'LMS_Full_20250803_020005');">
                                    <i class="fas fa-undo"></i>
                                </button>
                                <button type="button" class="btn-danger-custom btn-sm" onclick="return deleteBackup(event, 'LMS_Full_20250803_020005');">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Backup Analytics -->
    <div class="content-section">
        <h2 class="section-title">
            <i class="fas fa-chart-line"></i>
            Backup Analytics
        </h2>
        <p class="section-subtitle">Monitor backup trends and storage usage over time</p>
        
        <div class="row">
            <div class="col-md-6">
                <h5>Backup Size Trends</h5>
                <div class="chart-container">
                    <canvas id="backupSizeChart"></canvas>
                </div>
            </div>
            <div class="col-md-6">
                <h5>Backup Success Rate</h5>
                <div class="chart-container">
                    <canvas id="successRateChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Backup JavaScript -->
    <script>
        // Global function declarations - accessible from HTML onclick handlers
        
        // Backup Management Functions
        <%-- function createBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Create New Backup',
                html: `
                    <div class="text-start">
                        <div class="form-group">
                            <label class="form-label">Backup Type</label>
                            <select class="form-select" id="backupType">
                                <option value="full">Full Backup</option>
                                <option value="incremental">Incremental Backup</option>
                                <option value="differential">Differential Backup</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Backup Name</label>
                            <input type="text" class="form-control" id="backupName" 
                                   value="LMS_Manual_${new Date().toISOString().slice(0,19).replace(/[-:]/g, '').replace('T', '_')}" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Description (Optional)</label>
                            <textarea class="form-control" id="backupDescription" 
                                      placeholder="Enter backup description..."></textarea>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-plus me-2"></i>Create Backup',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    const backupType = document.getElementById('backupType').value;
                    const backupName = document.getElementById('backupName').value;
                    const backupDescription = document.getElementById('backupDescription').value;
                    
                    if (!backupName.trim()) {
                        showErrorAlert('Error', 'Please enter a backup name.');
                        return;
                    }
                    
                    // Show progress modal
                    showBackupProgress(backupName);
                    
                    // Simulate backup process
                    simulateBackupProcess(backupType, backupName, backupDescription);
                }
            });

            return false; // Prevent any form submission
        } --%>

        function scheduleBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Schedule Backup',
                html: `
                    <div class="text-start">
                        <div class="form-group">
                            <label class="form-label">Schedule Type <span class="text-danger">*</span></label>
                            <select class="form-select" id="scheduleType" onchange="updateDateTimeField()">
                                <option value="">Select Schedule Type</option>
                                <option value="once">One-time</option>
                                <option value="daily">Daily</option>
                                <option value="weekly">Weekly</option>
                                <option value="monthly">Monthly</option>
                            </select>
                            <div class="invalid-feedback" id="scheduleTypeError"></div>
                        </div>
                        <div class="form-group" id="dateTimeGroup">
                            <label class="form-label" id="dateTimeLabel">Date & Time <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control" id="scheduleDateTime" />
                            <div class="invalid-feedback" id="scheduleDateTimeError"></div>
                            <div class="form-text" id="dateTimeHelp"></div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Backup Type <span class="text-danger">*</span></label>
                            <select class="form-select" id="scheduledBackupType">
                                <option value="">Select Backup Type</option>
                                <option value="full">Full Backup</option>
                                <option value="incremental">Incremental Backup</option>
                            </select>
                            <div class="invalid-feedback" id="scheduledBackupTypeError"></div>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-clock me-2"></i>Schedule Backup',
                cancelButtonText: 'Cancel',
                didOpen: () => {
                    // Set default datetime to tomorrow at current time
                    const tomorrow = new Date();
                    tomorrow.setDate(tomorrow.getDate() + 1);
                    const isoString = tomorrow.toISOString().slice(0, 16);
                    document.getElementById('scheduleDateTime').value = isoString;
                    
                    // Initialize date/time field
                    updateDateTimeField();
                    
                    // Add event listeners to clear errors on field changes
                    document.getElementById('scheduleType').addEventListener('change', function() {
                        clearFieldValidation('scheduleType');
                        updateDateTimeField();
                    });
                    
                    document.getElementById('scheduleDateTime').addEventListener('change', function() {
                        clearFieldValidation('scheduleDateTime');
                    });
                    
                    document.getElementById('scheduledBackupType').addEventListener('change', function() {
                        clearFieldValidation('scheduledBackupType');
                    });
                },
                preConfirm: () => {
                    return validateScheduleForm();
                }
            }).then((result) => {
                if (result.isConfirmed && result.value) {
                    const scheduleData = result.value;
                    showSuccessAlert(
                        'Backup Scheduled!', 
                        `${scheduleData.scheduleType.charAt(0).toUpperCase() + scheduleData.scheduleType.slice(1)} backup scheduled successfully for ${scheduleData.formattedDateTime}.`
                    );
                }
            });

            return false; // Prevent any form submission
        }

        function uploadBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Upload Backup File',
                html: `
                    <div class="text-start">
                        <div class="form-group">
                            <label class="form-label">Select Backup File</label>
                            <input type="file" class="form-control" id="backupFile" 
                                   accept=".zip,.tar,.gz,.bak" />
                            <div class="form-text">Supported formats: ZIP, TAR, GZ, BAK</div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Description (Optional)</label>
                            <textarea class="form-control" id="uploadDescription" 
                                      placeholder="Enter description for this backup..."></textarea>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#2c2b7c',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-upload me-2"></i>Upload Backup',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    const fileInput = document.getElementById('backupFile');
                    if (!fileInput.files.length) {
                        showErrorAlert('Error', 'Please select a backup file to upload.');
                        return;
                    }
                    showSuccessAlert('Upload Started!', 'Your backup file is being uploaded and processed.');
                }
            });

            return false; // Prevent any form submission
        }

        function restoreSystem(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Restore System',
                html: `
                    <div class="text-start">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Warning:</strong> System restore will overwrite current data. This action cannot be undone.
                        </div>
                        <div class="form-group">
                            <label class="form-label">Select Backup to Restore</label>
                            <select class="form-select" id="restoreBackup">
                                <option value="">Choose a backup...</option>
                                <option value="LMS_Full_20250806_020015">LMS_Full_20250806_020015 (Aug 6, 2025)</option>
                                <option value="LMS_Full_20250805_140022">LMS_Full_20250805_140022 (Aug 5, 2025)</option>
                                <option value="LMS_Full_20250805_020011">LMS_Full_20250805_020011 (Aug 5, 2025)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="confirmRestore">
                                <label class="form-check-label" for="confirmRestore">
                                    I understand this will overwrite all current data
                                </label>
                            </div>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-undo me-2"></i>Restore System',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    const backupSelect = document.getElementById('restoreBackup');
                    const confirmCheck = document.getElementById('confirmRestore');
                    
                    if (!backupSelect.value) {
                        showErrorAlert('Error', 'Please select a backup to restore.');
                        return;
                    }
                    
                    if (!confirmCheck.checked) {
                        showErrorAlert('Error', 'Please confirm that you understand this action will overwrite current data.');
                        return;
                    }
                    
                    showSuccessAlert('Restore Started!', 'System restore process has been initiated. Please wait...');
                }
            });

            return false; // Prevent any form submission
        }

        function saveBackupConfig(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Saving backup configuration...');
            
            setTimeout(() => {
                showSuccessAlert('Configuration Saved!', 'Backup configuration has been updated successfully.');
            }, 1500);

            return false; // Prevent any form submission
        }

        // Fixed Custom Theme - No dynamic switching
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Fixed custom theme applied to Backup.aspx');
            initializeBackupPage();
            initializeCharts();
        });

        function initializeBackupPage() {
            // Initialize backup management functionality
            loadBackupStats();
            
            // Set up real-time updates
            setInterval(updateBackupStats, 30000); // Update every 30 seconds
        }

        function loadBackupStats() {
            // Simulate loading backup statistics
            console.log('Loading backup statistics...');
        }

        function updateBackupStats() {
            // Update backup statistics in real-time
            const nextBackupElement = document.getElementById('nextBackup');
            if (nextBackupElement) {
                const current = parseInt(nextBackupElement.textContent);
                if (current > 0) {
                    nextBackupElement.textContent = (current - 1) + 'h';
                }
            }
        }

        // Backup Management Functions
        function createBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Create New Backup',
                html: `
                    <div class="text-start">
                        <div class="form-group">
                            <label class="form-label">Backup Type</label>
                            <select class="form-select" id="backupType">
                                <option value="full">Full Backup</option>
                                <option value="incremental">Incremental Backup</option>
                                <option value="differential">Differential Backup</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Backup Name</label>
                            <input type="text" class="form-control" id="backupName" 
                                   value="LMS_Manual_${new Date().toISOString().slice(0,19).replace(/[-:]/g, '').replace('T', '_')}" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Description (Optional)</label>
                            <textarea class="form-control" id="backupDescription" 
                                      placeholder="Enter backup description..."></textarea>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-plus me-2"></i>Create Backup',
                cancelButtonText: 'Cancel',
                preConfirm: () => {
                    const type = document.getElementById('backupType').value;
                    const name = document.getElementById('backupName').value;
                    const description = document.getElementById('backupDescription').value;
                    
                    if (!name.trim()) {
                        Swal.showValidationMessage('Backup name is required');
                        return false;
                    }
                    
                    return { type, name, description };
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    startBackupProcess(result.value);
                }
            });

            return false; // Prevent any form submission
        }

        function startBackupProcess(backupData) {
            // Show backup progress section
            const progressSection = document.getElementById('backupProgress');
            progressSection.style.display = 'block';
            progressSection.scrollIntoView({ behavior: 'smooth' });

            // Reset progress bars to 0
            resetProgressBars();

            // Add a small delay to ensure DOM is ready
            setTimeout(() => {
                // Simulate backup progress with realistic timing
                let dbProgress = 0;
                let fileProgress = 0;
                let compressionProgress = 0;

                // Phase 1: Database backup
                const dbInterval = setInterval(() => {
                    dbProgress += Math.random() * 8 + 2; // 2-10% increments
                    
                    if (dbProgress >= 100) {
                        dbProgress = 100;
                        updateProgressBar('dbProgressBar', 'dbProgress', dbProgress);
                        clearInterval(dbInterval);
                        
                        // Phase 2: File backup (start after 1 second delay)
                        setTimeout(() => {
                            const fileInterval = setInterval(() => {
                                fileProgress += Math.random() * 6 + 2; // 2-8% increments
                                
                                if (fileProgress >= 100) {
                                    fileProgress = 100;
                                    updateProgressBar('fileProgressBar', 'fileProgress', fileProgress);
                                    clearInterval(fileInterval);
                                    
                                    // Phase 3: Compression (start after 1 second delay)
                                    setTimeout(() => {
                                        const compressionInterval = setInterval(() => {
                                            compressionProgress += Math.random() * 10 + 3; // 3-13% increments
                                            
                                            if (compressionProgress >= 100) {
                                                compressionProgress = 100;
                                                updateProgressBar('compressionProgressBar', 'compressionProgress', compressionProgress);
                                                clearInterval(compressionInterval);
                                                completeBackup(backupData);
                                            } else {
                                                updateProgressBar('compressionProgressBar', 'compressionProgress', compressionProgress);
                                            }
                                        }, 400);
                                    }, 1000);
                                } else {
                                    updateProgressBar('fileProgressBar', 'fileProgress', fileProgress);
                                }
                            }, 500);
                        }, 1000);
                    } else {
                        updateProgressBar('dbProgressBar', 'dbProgress', dbProgress);
                    }
                }, 800);
            }, 500);
        }

        function updateProgressBar(barId, textId, progress) {
            const progressBar = document.getElementById(barId);
            const progressText = document.getElementById(textId);
            
            // Ensure progress doesn't exceed 100%
            const clampedProgress = Math.min(Math.round(progress), 100);
            
            if (progressBar) {
                progressBar.style.width = clampedProgress + '%';
                progressBar.style.transition = 'width 0.3s ease-in-out';
                console.log(`Updated ${barId} to ${clampedProgress}%`);
            } else {
                console.error(`Progress bar element not found: ${barId}`);
            }
            
            if (progressText) {
                progressText.textContent = clampedProgress + '%';
                console.log(`Updated ${textId} to ${clampedProgress}%`);
            } else {
                console.error(`Progress text element not found: ${textId}`);
            }
        }

        function completeBackup(backupData) {
            setTimeout(() => {
                document.getElementById('backupProgress').style.display = 'none';
                
                showSuccessAlert('Backup Created Successfully!', 
                    `Backup "${backupData.name}" has been created and saved successfully.`);
                
                // Add new backup to history table
                addBackupToHistory(backupData);
                
                // Reset progress bars
                resetProgressBars();
            }, 1000);
        }

        function resetProgressBars() {
            // Reset all progress bars to 0%
            const progressBars = ['dbProgressBar', 'fileProgressBar', 'compressionProgressBar'];
            const progressTexts = ['dbProgress', 'fileProgress', 'compressionProgress'];
            
            console.log('Resetting progress bars...');
            
            progressBars.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.style.width = '0%';
                    element.style.transition = 'none'; // Remove transition for reset
                    console.log(`Reset ${id} to 0%`);
                } else {
                    console.error(`Progress bar element not found: ${id}`);
                }
            });
            
            progressTexts.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.textContent = '0%';
                    console.log(`Reset ${id} text to 0%`);
                } else {
                    console.error(`Progress text element not found: ${id}`);
                }
            });
            
            // Add a small delay to ensure reset is visible before starting animation
            setTimeout(() => {
                progressBars.forEach(id => {
                    const element = document.getElementById(id);
                    if (element) {
                        element.style.transition = 'width 0.3s ease-in-out';
                    }
                });
            }, 100);
        }

        function addBackupToHistory(backupData) {
            const table = document.getElementById('backupHistoryTable');
            const newRow = table.insertRow(0);
            
            const size = (Math.random() * 2 + 1).toFixed(2) + ' GB';
            const duration = Math.floor(Math.random() * 15 + 5) + 'm ' + Math.floor(Math.random() * 60) + 's';
            
            // Format date in the required format: "Aug 6, 2025 02:00:15"
            const formattedDate = formatBackupDate(new Date());
            
            newRow.innerHTML = `
                <td>
                    <div class="backup-type">
                        <i class="fas fa-database text-success"></i>
                        ${backupData.name}
                    </div>
                </td>
                <td>${backupData.type.charAt(0).toUpperCase() + backupData.type.slice(1)} Backup</td>
                <td>${formattedDate}</td>
                <td><span class="file-size">${size}</span></td>
                <td>${duration}</td>
                <td><span class="status-badge success">Success</span></td>
                <td>
                    <div class="table-actions">
                        <button type="button" class="btn-primary-custom btn-sm" onclick="return downloadBackup(event, '${backupData.name}')">
                            <i class="fas fa-download"></i>
                        </button>
                        <button type="button" class="btn-info-custom btn-sm" onclick="return viewBackupDetails(event, '${backupData.name}')">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button type="button" class="btn-success-custom btn-sm" onclick="restoreBackup(event, '${backupData.name}')">
                            <i class="fas fa-undo"></i>
                        </button>
                        <button type="button" class="btn-danger-custom btn-sm" onclick="deleteBackup(event, '${backupData.name}')">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </td>
            `;
        }

        function formatBackupDate(date) {
            // Format date as "Aug 6, 2025 02:00:15"
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            
            const month = months[date.getMonth()];
            const day = date.getDate();
            const year = date.getFullYear();
            
            const hours = date.getHours().toString().padStart(2, '0');
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const seconds = date.getSeconds().toString().padStart(2, '0');
            
            return `${month} ${day}, ${year} ${hours}:${minutes}:${seconds}`;
        }
      

        // Helper Functions (placed after main functions)
        function updateDateTimeField() {
            const scheduleType = document.getElementById('scheduleType').value;
            const dateTimeInput = document.getElementById('scheduleDateTime');
            const dateTimeLabel = document.getElementById('dateTimeLabel');
            const dateTimeHelp = document.getElementById('dateTimeHelp');
            
            // Clear any existing validation errors when field changes
            clearFieldValidation('scheduleType');
            clearFieldValidation('scheduleDateTime');
            
            if (scheduleType === 'once') {
                // One-time: show full datetime picker
                dateTimeInput.type = 'datetime-local';
                dateTimeLabel.innerHTML = 'Date & Time <span class="text-danger">*</span>';
                dateTimeHelp.textContent = 'Select the specific date and time for the backup.';
                
                // Set minimum to current time
                const now = new Date();
                const isoString = now.toISOString().slice(0, 16);
                dateTimeInput.min = isoString;
            } else if (scheduleType === 'daily' || scheduleType === 'weekly' || scheduleType === 'monthly') {
                // Recurring: show time only
                dateTimeInput.type = 'time';
                dateTimeLabel.innerHTML = 'Time <span class="text-danger">*</span>';
                dateTimeHelp.textContent = `Select the time when the ${scheduleType} backup should run.`;
                dateTimeInput.removeAttribute('min');
                
                // Set default time if empty
                if (!dateTimeInput.value) {
                    dateTimeInput.value = '02:00'; // Default to 2 AM
                }
            } else {
                // No selection: reset to datetime-local
                dateTimeInput.type = 'datetime-local';
                dateTimeLabel.innerHTML = 'Date & Time <span class="text-danger">*</span>';
                dateTimeHelp.textContent = '';
                dateTimeInput.removeAttribute('min');
            }
        }

        function clearFieldValidation(fieldId) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + 'Error');
            
            if (field) {
                field.classList.remove('is-invalid');
                field.classList.remove('is-valid');
            }
            
            if (errorElement) {
                errorElement.textContent = '';
            }
        }

        function clearAllValidationErrors() {
            // Clear all validation states
            document.querySelectorAll('.is-invalid').forEach(el => {
                el.classList.remove('is-invalid');
            });
            document.querySelectorAll('.is-valid').forEach(el => {
                el.classList.remove('is-valid');
            });
            document.querySelectorAll('.invalid-feedback').forEach(el => {
                el.textContent = '';
            });
            
            // Hide any existing validation messages
            const validationMessage = document.querySelector('.swal2-validation-message');
            if (validationMessage) {
                validationMessage.style.display = 'none';
            }
        }

        function validateScheduleForm() {
            let isValid = true;
            
            // Clear all previous validation errors first
            clearAllValidationErrors();
            
            // Get form values
            const scheduleType = document.getElementById('scheduleType').value;
            const scheduleDateTime = document.getElementById('scheduleDateTime').value;
            const backupType = document.getElementById('scheduledBackupType').value;
            
            // Validate Schedule Type
            if (!scheduleType) {
                showFieldError('scheduleType', 'Please select a schedule type.');
                isValid = false;
            }
            
            // Validate Date & Time
            if (!scheduleDateTime) {
                showFieldError('scheduleDateTime', 'Please select date and time.');
                isValid = false;
            } else if (scheduleType === 'once') {
                // For one-time backup, check if datetime is in the future
                const selectedDateTime = new Date(scheduleDateTime);
                const now = new Date();
                
                if (selectedDateTime <= now) {
                    showFieldError('scheduleDateTime', 'Please select a future date and time.');
                    isValid = false;
                }
            }
            
            // Validate Backup Type
            if (!backupType) {
                showFieldError('scheduledBackupType', 'Please select a backup type.');
                isValid = false;
            }
            
            if (!isValid) {
                Swal.showValidationMessage('Please fix the errors above.');
                return false;
            }
            
            // Format datetime for display
            let formattedDateTime;
            if (scheduleType === 'once') {
                const dateTime = new Date(scheduleDateTime);
                formattedDateTime = dateTime.toLocaleString();
            } else {
                const [hours, minutes] = scheduleDateTime.split(':');
                const time = new Date();
                time.setHours(parseInt(hours), parseInt(minutes));
                formattedDateTime = time.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
            }
            
            return {
                scheduleType: scheduleType,
                scheduleDateTime: scheduleDateTime,
                backupType: backupType,
                formattedDateTime: formattedDateTime
            };
        }

        function showFieldError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorElement = document.getElementById(fieldId + 'Error');
            
            if (field) {
                field.classList.add('is-invalid');
            }
            
            if (errorElement) {
                errorElement.textContent = message;
            }
        }

        // Additional Helper Functions
        function showBackupProgress(backupName) {
            Swal.fire({
                title: 'Creating Backup',
                html: `
                    <div class="text-start">
                        <p class="mb-3">Creating backup: <strong>${backupName}</strong></p>
                        <div class="progress-container mb-3">
                            <div class="progress-label">
                                <span>Database Backup</span>
                                <span id="dbProgressPercent">0%</span>
                            </div>
                            <div class="progress-bar-custom">
                                <div class="progress-fill primary" id="dbProgressBar" style="width: 0%"></div>
                            </div>
                        </div>
                        <div class="progress-container mb-3">
                            <div class="progress-label">
                                <span>File Backup</span>
                                <span id="fileProgressPercent">0%</span>
                            </div>
                            <div class="progress-bar-custom">
                                <div class="progress-fill success" id="fileProgressBar" style="width: 0%"></div>
                            </div>
                        </div>
                        <div class="progress-container">
                            <div class="progress-label">
                                <span>Compression</span>
                                <span id="compressionProgressPercent">0%</span>
                            </div>
                            <div class="progress-bar-custom">
                                <div class="progress-fill warning" id="compressionProgressBar" style="width: 0%"></div>
                            </div>
                        </div>
                    </div>
                `,
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        function simulateBackupProcess(type, name, description) {
            const phases = ['db', 'file', 'compression'];
            let currentPhase = 0;
            let progress = 0;
            
            const interval = setInterval(() => {
                progress += Math.random() * 15 + 5;
                
                if (progress >= 100) {
                    progress = 100;
                    updateProgressBar(phases[currentPhase], progress);
                    currentPhase++;
                    
                    if (currentPhase >= phases.length) {
                        clearInterval(interval);
                        setTimeout(() => {
                            Swal.close();
                            showSuccessAlert('Backup Created!', `${name} has been created successfully.`);
                            
                            // Add backup to history
                            addBackupToHistory({
                                name: name,
                                type: type,
                                description: description
                            });
                        }, 500);
                        return;
                    }
                    progress = 0;
                }
                
                updateProgressBar(phases[currentPhase], progress);
            }, 200);
        }

        <%-- function addBackupToHistory(backupData) {
            const table = document.getElementById('backupHistoryTable');
            const newRow = table.insertRow(0);
            
            const size = (Math.random() * 2 + 1).toFixed(2) + ' GB';
            const duration = Math.floor(Math.random() * 15 + 5) + 'm ' + Math.floor(Math.random() * 60) + 's';
            
            // Format date in the required format: "Aug 6, 2025 02:00:15"
            const formattedDate = formatBackupDate(new Date());
            
            newRow.innerHTML = `
                <td>
                    <div class="backup-type">
                        <i class="fas fa-database text-success"></i>
                        ${backupData.name}
                    </div>
                </td>
                <td>${backupData.type.charAt(0).toUpperCase() + backupData.type.slice(1)} Backup</td>
                <td>${formattedDate}</td>
                <td><span class="file-size">${size}</span></td>
                <td>${duration}</td>
                <td><span class="status-badge success">Success</span></td>
                <td>
                    <div class="table-actions">
                        <button class="btn-primary-custom btn-sm" onclick="downloadBackup('${backupData.name}')">
                            <i class="fas fa-download"></i>
                        </button>
                        <button class="btn-success-custom btn-sm" onclick="restoreBackup('${backupData.name}')">
                            <i class="fas fa-upload"></i>
                        </button>
                        <button class="btn-secondary-custom btn-sm" onclick="viewBackupLogs('${backupData.name}')">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn-danger-custom btn-sm" onclick="deleteBackup('${backupData.name}')">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </td>
            `;
        } --%>

        function formatBackupDate(date) {
            // Format date as "Aug 6, 2025 02:00:15"
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            
            const month = months[date.getMonth()];
            const day = date.getDate();
            const year = date.getFullYear();
            
            const hours = date.getHours().toString().padStart(2, '0');
            const minutes = date.getMinutes().toString().padStart(2, '0');
            const seconds = date.getSeconds().toString().padStart(2, '0');
            
            return `${month} ${day}, ${year} ${hours}:${minutes}:${seconds}`;
        }

        // Alert Helper Functions
        function showSuccessAlert(title, message) {
            Swal.fire({
                icon: 'success',
                title: title,
                text: message,
                confirmButtonColor: '#2c2b7c'
            });
        }

        function showErrorAlert(title, message) {
            Swal.fire({
                icon: 'error',
                title: title,
                text: message,
                confirmButtonColor: '#dc3545'
            });
        }

        function showLoadingAlert(message) {
            Swal.fire({
                title: message,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        <%-- function uploadBackup(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Upload Backup File',
                html: `
                    <div class="text-start">
                        <div class="form-group">
                            <label class="form-label">Select Backup File</label>
                            <input type="file" class="form-control" id="backupFile" accept=".bak,.sql,.zip" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Backup Description</label>
                            <textarea class="form-control" id="uploadDescription" 
                                      placeholder="Enter description for this backup..."></textarea>
                        </div>
                        <div class="alert alert-info">
                            <small><strong>Note:</strong> Supported formats: .bak, .sql, .zip (max 5GB)</small>
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#ffc107',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-upload me-2"></i>Upload Backup',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    showSuccessAlert('Backup Uploaded!', 'Your backup file has been uploaded successfully.');
                }
            });

            return false; // Prevent any form submission
        } --%>

        function restoreSystem(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Restore System',
                text: 'This will restore the system from a backup. All current data will be replaced. This action cannot be undone.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-undo me-2"></i>Continue with Restore',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    selectBackupForRestore();
                }
            });

            return false; // Prevent any form submission
        }

        function selectBackupForRestore() {
            Swal.fire({
                title: 'Select Backup to Restore',
                html: `
                    <div class="text-start">
                        <div class="form-group">
                            <label class="form-label">Available Backups</label>
                            <select class="form-select" id="restoreBackupSelect">
                                <option value="LMS_Full_20250806_020015">LMS_Full_20250806_020015 (2.34 GB)</option>
                                <option value="LMS_Full_20250805_020011">LMS_Full_20250805_020011 (2.28 GB)</option>
                                <option value="LMS_Full_20250803_020005">LMS_Full_20250803_020005 (2.21 GB)</option>
                            </select>
                        </div>
                        <div class="alert alert-danger">
                            <strong>Warning:</strong> This will overwrite all current data with the selected backup.
                        </div>
                    </div>
                `,
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: '<i class="fas fa-undo me-2"></i>Restore Now',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    const selectedBackup = document.getElementById('restoreBackupSelect').value;
                    showLoadingAlert('Restoring system from backup...');
                    
                    setTimeout(() => {
                        showSuccessAlert('System Restored!', `System has been successfully restored from backup: ${selectedBackup}`);
                    }, 5000);
                }
            });
        }

        // Individual backup actions
        function viewBackupDetails(event, backupName) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Backup Details',
                html: `
                    <div class="text-start">
                        <div class="row">
                            <div class="col-6">
                                <strong>Backup Name:</strong><br>
                                <span class="text-muted">${backupName}</span>
                            </div>
                            <div class="col-6">
                                <strong>Type:</strong><br>
                                <span class="text-muted">Full Backup</span>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-6">
                                <strong>Status:</strong><br>
                                <span class="badge bg-danger">Failed</span>
                            </div>
                            <div class="col-6">
                                <strong>Date Created:</strong><br>
                                <span class="text-muted">Aug 4, 2025 02:00:08</span>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-6">
                                <strong>Size:</strong><br>
                                <span class="text-muted">--</span>
                            </div>
                            <div class="col-6">
                                <strong>Duration:</strong><br>
                                <span class="text-muted">--</span>
                            </div>
                        </div>
                        <hr>
                        <div>
                            <strong>Error Details:</strong><br>
                            <div class="alert alert-danger mt-2">
                                <small>Database connection timeout during backup process. Please check database server status and retry.</small>
                            </div>
                        </div>
                        <div>
                            <strong>Backup Path:</strong><br>
                            <code class="text-muted">C:\\Backups\\Failed\\${backupName}</code>
                        </div>
                    </div>
                `,
                icon: 'info',
                confirmButtonColor: '#2c2b7c',
                confirmButtonText: 'Close',
                width: '600px'
            });

            return false; // Prevent any form submission
        }

        function downloadBackup(event, backupName) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showSuccessAlert('Download Started!', `Download of backup "${backupName}" has been initiated.`);
            return false; // Prevent any form submission
        }

        function restoreBackup(event, backupName) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Restore from Backup',
                text: `Are you sure you want to restore the system from backup "${backupName}"? This will replace all current data.`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, restore!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    showLoadingAlert('Restoring from backup...');
                    
                    setTimeout(() => {
                        showSuccessAlert('Restore Complete!', `System has been restored from backup "${backupName}".`);
                    }, 4000);
                }
            });

            return false; // Prevent any form submission
        }

        function deleteBackup(event, backupName) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Delete Backup',
                text: `Are you sure you want to delete backup "${backupName}"? This action cannot be undone.`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ee1c24',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, delete!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Remove row from table
                    const rows = document.querySelectorAll('#backupHistoryTable tr');
                    rows.forEach(row => {
                        if (row.textContent.includes(backupName)) {
                            row.remove();
                        }
                    });
                    
                    showSuccessAlert('Backup Deleted!', `Backup "${backupName}" has been deleted successfully.`);
                }
            });

            return false; // Prevent any form submission
        }

        function viewBackupLogs(event, backupName) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Backup Logs',
                html: `
                    <div class="text-start" style="max-height: 400px; overflow-y: auto;">
                        <pre style="background: #f8f9fa; padding: 1rem; border-radius: 4px; font-size: 0.875rem;">
[2025-08-04 02:00:08] INFO: Starting backup process...
[2025-08-04 02:00:10] INFO: Connecting to database...
[2025-08-04 02:00:15] ERROR: Connection timeout to database server
[2025-08-04 02:00:16] ERROR: Failed to establish database connection
[2025-08-04 02:00:17] INFO: Retrying connection (attempt 2/3)...
[2025-08-04 02:00:25] ERROR: Connection timeout to database server
[2025-08-04 02:00:26] ERROR: Failed to establish database connection
[2025-08-04 02:00:27] INFO: Retrying connection (attempt 3/3)...
[2025-08-04 02:00:35] ERROR: Connection timeout to database server
[2025-08-04 02:00:36] ERROR: Maximum retry attempts exceeded
[2025-08-04 02:00:37] ERROR: Backup process failed
[2025-08-04 02:00:38] INFO: Cleaning up temporary files...
[2025-08-04 02:00:39] INFO: Backup process terminated
                        </pre>
                    </div>
                `,
                width: '600px',
                confirmButtonColor: '#2c2b7c'
            });

            return false; // Prevent any form submission
        }

        function retryBackup(event, backupName) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            Swal.fire({
                title: 'Retry Backup',
                text: `Do you want to retry the failed backup "${backupName}"?`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#666666',
                confirmButtonText: 'Yes, retry!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    showLoadingAlert('Retrying backup...');
                    
                    setTimeout(() => {
                        showSuccessAlert('Backup Retry Successful!', `Backup "${backupName}" has been completed successfully.`);
                        
                        // Update the status in the table
                        const rows = document.querySelectorAll('#backupHistoryTable tr');
                        rows.forEach(row => {
                            if (row.textContent.includes(backupName)) {
                                const statusCell = row.querySelector('.status-badge');
                                statusCell.className = 'status-badge success';
                                statusCell.textContent = 'Success';
                                
                                const sizeCell = row.cells[3];
                                sizeCell.innerHTML = '<span class="file-size">2.15 GB</span>';
                                
                                const durationCell = row.cells[4];
                                durationCell.textContent = '9m 42s';
                            }
                        });
                    }, 3000);
                }
            });

            return false; // Prevent any form submission
        }

        function saveBackupConfig(event) {
            // Prevent any default behavior
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }

            showLoadingAlert('Saving backup configuration...');
            
            setTimeout(() => {
                showSuccessAlert('Configuration Saved!', 'Backup configuration has been updated successfully.');
            }, 1500);

            return false; // Prevent any form submission
        }

        // Chart initialization
        function initializeCharts() {
            initializeBackupSizeChart();
            initializeSuccessRateChart();
        }

        function initializeBackupSizeChart() {
            const ctx = document.getElementById('backupSizeChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Aug 1', 'Aug 2', 'Aug 3', 'Aug 4', 'Aug 5', 'Aug 6'],
                    datasets: [{
                        label: 'Backup Size (GB)',
                        data: [1.95, 2.05, 2.21, 0, 2.28, 2.34],
                        borderColor: '#2c2b7c',
                        backgroundColor: 'rgba(44, 43, 124, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Size (GB)'
                            }
                        }
                    }
                }
            });
        }

        function initializeSuccessRateChart() {
            const ctx = document.getElementById('successRateChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Successful', 'Failed'],
                    datasets: [{
                        data: [11, 1],
                        backgroundColor: ['#28a745', '#ee1c24'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }

        // Alert Functions
        function showSuccessAlert(title, text) {
            Swal.fire({
                title: title,
                text: text,
                icon: 'success',
                confirmButtonColor: '#2c2b7c'
            });
        }

        function showErrorAlert(title, text) {
            Swal.fire({
                title: title,
                text: text,
                icon: 'error',
                confirmButtonColor: '#ee1c24'
            });
        }

        function showLoadingAlert(title) {
            Swal.fire({
                title: title,
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
        }

        // Table Action Functions
        function downloadBackup(event, backupName) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            showSuccessAlert('Download Started!', `Download of backup "${backupName}" has been initiated.`);
            return false;
        }

        function restoreBackup(event, backupName) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            Swal.fire({
                title: 'Restore Backup',
                text: `Are you sure you want to restore from "${backupName}"? This will overwrite current data.`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, restore it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    showSuccessAlert('Restore Started!', `Restoration from "${backupName}" has been initiated.`);
                }
            });
            return false;
        }

        function deleteBackup(event, backupName) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            Swal.fire({
                title: 'Delete Backup',
                text: `Are you sure you want to delete "${backupName}"? This action cannot be undone.`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    showSuccessAlert('Backup Deleted!', `Backup "${backupName}" has been deleted successfully.`);
                }
            });
            return false;
        }

        function viewBackupLogs(event, backupName) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            Swal.fire({
                title: `Backup Logs - ${backupName}`,
                html: `
                    <div class="text-start">
                        <pre style="background: #f8f9fa; padding: 15px; border-radius: 5px; max-height: 300px; overflow-y: auto;">
[2025-08-08 02:00:00] Backup process started
[2025-08-08 02:00:15] Database backup initiated
[2025-08-08 02:05:30] Database backup completed (1.2 GB)
[2025-08-08 02:05:45] File backup initiated
[2025-08-08 02:10:20] File backup completed (856 MB)
[2025-08-08 02:10:35] Compression started
[2025-08-08 02:12:10] Compression completed
[2025-08-08 02:12:15] Backup process completed successfully
                        </pre>
                    </div>
                `,
                confirmButtonText: 'Close'
            });
            return false;
        }

        function retryBackup(event, backupName) {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            Swal.fire({
                title: 'Retry Backup',
                text: `Do you want to retry the failed backup "${backupName}"?`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, retry!'
            }).then((result) => {
                if (result.isConfirmed) {
                    showSuccessAlert('Backup Retrying!', `Retry process for "${backupName}" has been initiated.`);
                }
            });
            return false;
        }
    </script>
</asp:Content>
