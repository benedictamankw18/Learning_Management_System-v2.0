<%@ Page Title="Admin Notifications" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .notifications-header {
            background: linear-gradient(135deg, #2c2b7c 0%, #3498db 100%);
            color: white;
            padding: 2rem 0;
            margin: -20px -20px 2rem -20px;
            border-radius: 0 0 15px 15px;
        }

        .notification-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: none;
            transition: all 0.3s ease;
            position: relative;
            border-left: 4px solid transparent;
        }

        .notification-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }

        .notification-card.unread {
            border-left-color: #3498db;
            background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
        }

        .notification-card.high-priority {
            border-left-color: #e74c3c;
        }

        .notification-card.medium-priority {
            border-left-color: #f39c12;
        }

        .notification-card.low-priority {
            border-left-color: #27ae60;
        }

        .notification-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: white;
            margin-right: 1rem;
            flex-shrink: 0;
        }

        .notification-icon.system {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }

        .notification-icon.user {
            background: linear-gradient(135deg, #27ae60, #229954);
        }

        .notification-icon.security {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }

        .notification-icon.update {
            background: linear-gradient(135deg, #f39c12, #e67e22);
        }

        .notification-icon.warning {
            background: linear-gradient(135deg, #f39c12, #d68910);
        }

        .notification-content {
            flex: 1;
            position: relative;
        }

        .notification-title {
            font-weight: 600;
            font-size: 1.1rem;
            color: #2c2b7c;
            margin-bottom: 0.5rem;
            width: 22%;
        }

        .notification-message {
            color: #666;
            line-height: 1.5;
            margin-bottom: 0.75rem;
            width: 47%
        }

        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.85rem;
            color: #999;
            right: 0;
            position: absolute;
        }

        .notification-time {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .notification-actions {
            display: flex;
            gap: 0.5rem;
        }

        .notification-actions .btn {
            padding: 0.25rem 0.75rem;
            font-size: 0.8rem;
            border-radius: 6px;
        }

        .filter-tabs {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 1rem;
            margin-bottom: 2rem;
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .filter-tab {
            background: #f8f9fa;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            color: #666;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-tab:hover {
            background: #e9ecef;
            color: #495057;
        }

        .filter-tab.active {
            background: linear-gradient(135deg, #2c2b7c, #3498db);
            color: white;
        }

        .notification-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 1.5rem;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #2c2b7c;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        .search-container-notification {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .search-input-notification {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem 1rem 0.75rem 3rem;
            font-size: 1rem;
            width: 100%;
            transition: border-color 0.3s ease;
        }

        .search-input-notification:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .search-icon-notification {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .bulk-actions {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.08);
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #2c2b7c, #3498db);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(44, 43, 124, 0.3);
        }

        .btn-danger-custom {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-danger-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #999;
        }

        .empty-state-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #dee2e6;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 2rem;
        }

        .pagination {
            display: flex;
            gap: 0.5rem;
        }

        .page-btn {
            background: white;
            border: 2px solid #e9ecef;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            color: #666;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .page-btn:hover {
            border-color: #3498db;
            color: #3498db;
        }

        .page-btn.active {
            background: #3498db;
            border-color: #3498db;
            color: white;
        }

        .page-btn.disabled {
            background: transparent;
            color: #ccc;
            cursor: default;
            pointer-events: none;
            border-color: transparent;
        }

        .page-btn i {
            font-size: 0.8rem;
        }

        @media (max-width: 768px) {
            .filter-tabs {
                justify-content: center;
            }
            
            .notification-stats {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .bulk-actions {
                flex-direction: column;
                gap: 1rem;
            }
            
            .notification-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Notifications Header -->
    <div class="notifications-header text-center">
        <div class="container">
            <h1><i class="fas fa-bell me-2"></i>Notification Center</h1>
            <p class="mb-0">Stay updated with system activities and important alerts</p>
        </div>
    </div>

    <!-- Notification Statistics -->
    <div class="notification-stats">
        <div class="stat-card">
            <div class="stat-value" id="totalNotifications">24</div>
            <div class="stat-label">Total Notifications</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" id="unreadNotifications">8</div>
            <div class="stat-label">Unread</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" id="highPriorityNotifications">3</div>
            <div class="stat-label">High Priority</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" id="todayNotifications">12</div>
            <div class="stat-label">Today</div>
        </div>
    </div>

    <!-- Search and Filters -->
    <div class="search-container-notification">
        <div class="position-relative">
            <i class="fas fa-search search-icon-notification"></i>
            <input type="text" class="search-input-notification" id="searchInput" placeholder="Search notifications...">
        </div>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs">
        <button type="button" class="filter-tab active" onclick="filterNotifications('all')">
            <i class="fas fa-list"></i>All Notifications
        </button>
        <button type="button" class="filter-tab" onclick="filterNotifications('unread')">
            <i class="fas fa-envelope"></i>Unread
        </button>
        <button type="button" class="filter-tab" onclick="filterNotifications('system')">
            <i class="fas fa-cog"></i>System
        </button>
        <button type="button" class="filter-tab" onclick="filterNotifications('user')">
            <i class="fas fa-users"></i>User Activity
        </button>
        <button type="button" class="filter-tab" onclick="filterNotifications('security')">
            <i class="fas fa-shield-alt"></i>Security
        </button>
        <button type="button" class="filter-tab" onclick="filterNotifications('updates')">
            <i class="fas fa-download"></i>Updates
        </button>
    </div>

    <!-- Bulk Actions -->
    <div class="bulk-actions">
        <div class="d-flex align-items-center gap-3">
            <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
            <label for="selectAll" class="mb-0">Select All</label>
            <span id="selectedCount" class="text-muted">0 selected</span>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-primary-custom" onclick="markSelectedAsRead()">
                <i class="fas fa-eye me-1"></i>Mark as Read
            </button>
            <button type="button" class="btn btn-danger-custom" onclick="deleteSelected()">
                <i class="fas fa-trash me-1"></i>Delete Selected
            </button>
        </div>
    </div>

    <!-- Notifications List -->
    <div id="notificationsList">
        <!-- Notifications will be loaded dynamically from the database -->
    </div>

    <!-- Loading Spinner -->
    <div id="loadingSpinner" class="text-center p-5" style="display: none;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading notifications...</span>
        </div>
        <p class="mt-3">Loading notifications...</p>
    </div>

    <!-- Empty State (Hidden by default) -->
    <div id="emptyState" class="empty-state" style="display: none;">
        <div class="empty-state-icon">
            <i class="fas fa-bell-slash"></i>
        </div>
        <h3>No Notifications Found</h3>
        <p>There are no notifications matching your current filters.</p>
    </div>

    <!-- Pagination -->
    <div class="pagination-container">
        <div class="pagination" id="paginationContainer">
            <!-- Pagination buttons will be dynamically generated -->
        </div>
    </div>

    <script>
        // Notification Management Functions
        let selectedNotifications = new Set();
        let currentFilter = 'all';
        
        // Pagination variables
        let currentPage = 1;
        let totalPages = 1; // Will be updated based on actual data
        let itemsPerPage = 10;

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // First load the notification statistics
            fetchNotificationStats();
            
            // Then load the actual notifications
            fetchNotifications('all', 1);
            
            // Set up search functionality
            setupSearch();
            
            // Initialize pagination
            initializePagination();
            
            // Set up keyboard navigation
            setupKeyboardNavigation();
            
            // Set up checkbox event listeners
            setupCheckboxListeners();
        });
        
        // Set up checkbox event listeners
        function setupCheckboxListeners() {
            document.addEventListener('change', function(e) {
                if (e.target.classList.contains('notification-checkbox')) {
                    updateSelection(e.target);
                }
            });
        }
        
        // Fetch notification statistics from the server
        function fetchNotificationStats() {
            // Call the WebMethod to get notification statistics
            $.ajax({
                type: "POST",
                url: "Notifications.aspx/GetNotificationStats",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response && response.d) {
                        try {
                            const stats = JSON.parse(response.d);
                            // Update the statistics on the page
                            document.getElementById('totalNotifications').textContent = stats.Total || 0;
                            document.getElementById('unreadNotifications').textContent = stats.Unread || 0;
                            document.getElementById('highPriorityNotifications').textContent = stats.HighPriority || 0;
                            document.getElementById('todayNotifications').textContent = stats.Today || 0;
                        } catch (e) {
                            console.error("Error parsing notification stats:", e);
                        }
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error fetching notification stats:", error);
                }
            });
        }
        
        // Fetch notifications from the server
        function fetchNotifications(filter, page) {
            currentFilter = filter;
            currentPage = page;
            
            // Show loading indicator
            document.getElementById('loadingSpinner').style.display = 'block';
            document.getElementById('notificationsList').style.display = 'none';
            document.getElementById('emptyState').style.display = 'none';
            
            console.log(`Fetching notifications with filter: ${filter}, page: ${page}`);
            
            // Call the WebMethod to get notifications
            $.ajax({
                type: "POST",
                url: "Notifications.aspx/GetNotifications",
                data: JSON.stringify({ filter: filter, page: page, pageSize: itemsPerPage }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    // Hide loading spinner
                    document.getElementById('loadingSpinner').style.display = 'none';
                    
                    console.log('Received response:', response);
                    
                    if (response && response.d) {
                        try {
                            console.log('Response data:', response.d);
                            const notifications = JSON.parse(response.d);
                            console.log('Parsed notifications:', notifications);
                            
                            if (notifications && notifications.length > 0) {
                                renderNotifications(notifications);
                            } else {
                                console.log('No notifications found or empty array');
                                showEmptyState("No notifications found matching your criteria.");
                            }
                        } catch (e) {
                            console.error("Error parsing notifications:", e);
                            showEmptyState("Error loading notifications. Please try again. Parse error: " + e.message);
                        }
                    } else {
                        console.log('Empty or invalid response');
                        showEmptyState("No notifications found.");
                    }
                },
                error: function(xhr, status, error) {
                    // Hide loading spinner
                    document.getElementById('loadingSpinner').style.display = 'none';
                    
                    console.error("Error fetching notifications:", xhr, status, error);
                    showEmptyState("Error loading notifications. Please try again. Error: " + error);
                }
            });
        }

        // Keyboard navigation for pagination
        function setupKeyboardNavigation() {
            document.addEventListener('keydown', function(event) {
                // Only handle if not typing in an input field
                if (event.target.tagName !== 'INPUT' && event.target.tagName !== 'TEXTAREA') {
                    if (event.key === 'ArrowLeft' && currentPage > 1) {
                        changePage('prev');
                        event.preventDefault();
                    } else if (event.key === 'ArrowRight' && currentPage < totalPages) {
                        changePage('next');
                        event.preventDefault();
                    }
                }
            });
        }

        // Filter notifications
        function filterNotifications(type) {
            currentFilter = type;
            
            // Update active tab
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            event.target.closest('.filter-tab').classList.add('active');
            
            // Call fetchNotifications with the filter type
            fetchNotifications(type, 1);
        }

        // Search functionality
        function setupSearch() {
            const searchInput = document.getElementById('searchInput');
            let searchTimeout;
            
            searchInput.addEventListener('input', function() {
                // Clear any existing timeout
                clearTimeout(searchTimeout);
                
                // Set a timeout to avoid sending too many requests
                searchTimeout = setTimeout(() => {
                    const searchTerm = this.value.trim().toLowerCase();
                    
                    // Call server with search term
                    if (searchTerm.length >= 2 || searchTerm.length === 0) {
                        // Show loading indicator
                        document.getElementById('loadingSpinner').style.display = 'block';
                        document.getElementById('notificationsList').style.display = 'none';
                        document.getElementById('emptyState').style.display = 'none';
                        
                        // Use the SearchNotifications method
                        $.ajax({
                            type: "POST",
                            url: "Notifications.aspx/SearchNotifications",
                            data: JSON.stringify({ 
                                searchTerm: searchTerm,
                                filter: currentFilter,
                                page: 1,
                                pageSize: itemsPerPage
                            }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function(response) {
                                // Hide loading spinner
                                document.getElementById('loadingSpinner').style.display = 'none';
                                
                                if (response && response.d) {
                                    try {
                                        const notifications = JSON.parse(response.d);
                                        renderNotifications(notifications);
                                        
                                        // Reset current page to 1 since we're doing a new search
                                        currentPage = 1;
                                        
                                        // Update pagination
                                        updatePagination(notifications.length);
                                    } catch (e) {
                                        console.error("Error parsing search results:", e);
                                        showEmptyState("Error processing search results.");
                                    }
                                } else {
                                    showEmptyState("No notifications found matching your search.");
                                }
                            },
                            error: function(xhr, status, error) {
                                // Hide loading spinner
                                document.getElementById('loadingSpinner').style.display = 'none';
                                
                                console.error("Error searching notifications:", error);
                                showEmptyState("Error searching notifications.");
                            }
                        });
                    }
                }, 500); // 500ms delay
            });
        }
        
        // Update pagination based on total notifications
        function updatePagination(totalItems) {
            // Get the total count from the server if not provided
            if (totalItems === undefined) {
                $.ajax({
                    type: "POST",
                    url: "Notifications.aspx/GetNotificationCount",
                    data: JSON.stringify({ filter: currentFilter }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        if (response && response.d) {
                            updatePaginationUI(parseInt(response.d));
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error getting notification count:", error);
                    }
                });
            } else {
                updatePaginationUI(totalItems);
            }
        }
        
        // Update pagination UI based on total items
        function updatePaginationUI(totalItems) {
            totalPages = Math.ceil(totalItems / itemsPerPage);
            renderPagination();
        }

        // Mark notification as read
        function markAsRead(notificationId) {
            // Call the WebMethod to mark notification as read
            $.ajax({
                type: "POST",
                url: "Notifications.aspx/MarkNotificationAsRead",
                data: JSON.stringify({ notificationId: notificationId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response && response.d === "success") {
                        // Update UI
                        const notification = document.querySelector(`[data-id="${notificationId}"]`);
                        if (notification) {
                            notification.classList.remove('unread');
                            notification.setAttribute('data-read', 'true');
                            
                            // Hide the mark as read button
                            const button = notification.querySelector('.btn-outline-success');
                            if (button) {
                                button.style.display = 'none';
                            }
                            
                            // Update statistics
                            fetchNotificationStats();
                            
                            Swal.fire({
                                title: 'Marked as Read',
                                text: 'Notification has been marked as read.',
                                icon: 'success',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        }
                    } else {
                        Swal.fire({
                            title: 'Error',
                            text: 'Failed to mark notification as read: ' + (response.d || 'Unknown error'),
                            icon: 'error'
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error marking notification as read:", error);
                    Swal.fire({
                        title: 'Error',
                        text: 'Failed to mark notification as read. Please try again.',
                        icon: 'error'
                    });
                }
            });
        }

        // View notification details
        function viewDetails(notificationId) {
            // Find the notification in the DOM
            const notification = document.querySelector(`[data-id="${notificationId}"]`);
            
            if (notification) {
                // Get data from the element
                const title = notification.querySelector('.notification-title').textContent;
                const message = notification.querySelector('.notification-message').textContent;
                const type = notification.getAttribute('data-type');
                const priority = notification.getAttribute('data-priority');
                const isRead = notification.getAttribute('data-read') === 'true';
                const createdDate = notification.querySelector('.notification-time span').textContent;
                
                // Display details in a modal
                Swal.fire({
                    title: title,
                    html: `
                        <div class="text-start">
                            <div class="mb-3">
                                <div class="d-flex align-items-center mb-2">
                                    <span class="badge bg-${getPriorityColor(priority)} me-2">${priority.toUpperCase()} Priority</span>
                                    <span class="badge bg-${getTypeColor(type)} me-2">${type.toUpperCase()}</span>
                                    <span class="badge bg-${isRead ? 'secondary' : 'primary'} me-2">${isRead ? 'Read' : 'Unread'}</span>
                                </div>
                                <p><small class="text-muted">Created: ${createdDate}</small></p>
                            </div>
                            <hr>
                            <div class="notification-detail-message">
                                ${message}
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between">
                                <div>
                                    <p><strong>ID:</strong> ${notificationId}</p>
                                </div>
                                <div>
                                    ${!isRead ? `<button class="btn btn-sm btn-success mark-read-btn" onclick="markAsReadAndCloseModal(${notificationId})">Mark as Read</button>` : ''}
                                </div>
                            </div>
                        </div>
                    `,
                    width: 600,
                    confirmButtonColor: '#2c2b7c',
                    confirmButtonText: 'Close'
                });
            } else {
                // Notification not found in DOM, could be from another page
                Swal.fire({
                    title: 'Notification Details',
                    text: 'Could not find details for this notification.',
                    icon: 'info',
                    confirmButtonColor: '#2c2b7c'
                });
            }
        }
        
        // Mark as read and close modal
        function markAsReadAndCloseModal(notificationId) {
            markAsRead(notificationId);
            Swal.close();
        }
        
        // Helper function to get priority color
        function getPriorityColor(priority) {
            switch(priority.toLowerCase()) {
                case 'high': return 'danger';
                case 'medium': return 'warning';
                case 'low': return 'success';
                default: return 'secondary';
            }
        }
        
        // Helper function to get type color
        function getTypeColor(type) {
            switch(type.toLowerCase()) {
                case 'system': return 'info';
                case 'user': return 'primary';
                case 'security': return 'danger';
                case 'update': return 'warning';
                case 'warning': return 'warning';
                default: return 'secondary';
            }
        }

        // Toggle select all
        function toggleSelectAll() {
            const selectAllCheckbox = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.notification-checkbox');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
                updateSelection(checkbox);
            });
            
            updateSelectedCount();
        }

        // Update selection
        function updateSelection(checkbox) {
            const notificationCard = checkbox.closest('.notification-card');
            const notificationId = notificationCard.getAttribute('data-id') || 
                                 Array.from(document.querySelectorAll('.notification-card')).indexOf(notificationCard);
            
            if (checkbox.checked) {
                selectedNotifications.add(notificationId);
            } else {
                selectedNotifications.delete(notificationId);
            }
            
            updateSelectedCount();
        }

        // Update selected count
        function updateSelectedCount() {
            document.getElementById('selectedCount').textContent = `${selectedNotifications.size} selected`;
        }

        // Mark selected as read
        function markSelectedAsRead() {
            if (selectedNotifications.size === 0) {
                Swal.fire({
                    title: 'No Selection',
                    text: 'Please select notifications to mark as read.',
                    icon: 'warning',
                    confirmButtonColor: '#f39c12'
                });
                return;
            }

            // Show loading indicator
            Swal.fire({
                title: 'Marking Notifications as Read',
                html: 'Please wait while your notifications are being updated...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            let markedCount = 0;
            let errorCount = 0;
            let totalToMark = selectedNotifications.size;
            let processed = 0;
            
            // Process each notification ID
            selectedNotifications.forEach(id => {
                // Call the WebMethod to mark notification as read
                $.ajax({
                    type: "POST",
                    url: "Notifications.aspx/MarkNotificationAsRead",
                    data: JSON.stringify({ notificationId: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(response) {
                        processed++;
                        
                        if (response && response.d === "success") {
                            markedCount++;
                            
                            // Update UI
                            const notification = document.querySelector(`[data-id="${id}"]`);
                            if (notification) {
                                notification.classList.remove('unread');
                                notification.setAttribute('data-read', 'true');
                                
                                // Hide the mark as read button
                                const button = notification.querySelector('.btn-outline-success');
                                if (button) {
                                    button.style.display = 'none';
                                }
                            }
                        } else {
                            errorCount++;
                            console.error("Failed to mark notification as read:", response.d);
                        }
                        
                        // Check if all have been processed
                        if (processed === totalToMark) {
                            finishMarkReadProcess(markedCount, errorCount);
                        }
                    },
                    error: function(xhr, status, error) {
                        processed++;
                        errorCount++;
                        console.error("Error marking notification as read:", error);
                        
                        // Check if all have been processed
                        if (processed === totalToMark) {
                            finishMarkReadProcess(markedCount, errorCount);
                        }
                    }
                });
            });
        }
        
        // Helper function to finish the mark as read process
        function finishMarkReadProcess(markedCount, errorCount) {
            // Clear selections
            selectedNotifications.clear();
            document.getElementById('selectAll').checked = false;
            document.querySelectorAll('.notification-checkbox').forEach(cb => cb.checked = false);
            updateSelectedCount();
            
            // Update statistics
            fetchNotificationStats();
            
            // Show result message
            if (errorCount === 0) {
                Swal.fire({
                    title: 'Marked as Read',
                    text: `${markedCount} notification(s) have been marked as read.`,
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false
                });
            } else {
                Swal.fire({
                    title: 'Partially Completed',
                    text: `${markedCount} notification(s) marked as read, ${errorCount} failed.`,
                    icon: 'warning'
                });
            }
        }

        // Delete selected notifications
        function deleteSelected() {
            if (selectedNotifications.size === 0) {
                Swal.fire({
                    title: 'No Selection',
                    text: 'Please select notifications to delete.',
                    icon: 'warning',
                    confirmButtonColor: '#f39c12'
                });
                return;
            }

            Swal.fire({
                title: 'Delete Notifications?',
                text: `Are you sure you want to delete ${selectedNotifications.size} notification(s)?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e74c3c',
                cancelButtonColor: '#95a5a6',
                confirmButtonText: 'Yes, delete them!'
            }).then((result) => {
                if (result.isConfirmed) {
                    let deletedCount = 0;
                    let errorCount = 0;
                    let totalToDelete = selectedNotifications.size;
                    let processed = 0;
                    
                    // Show loading indicator
                    Swal.fire({
                        title: 'Deleting Notifications',
                        html: 'Please wait while your notifications are being deleted...',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });
                    
                    // Process each notification ID
                    selectedNotifications.forEach(id => {
                        // Call the WebMethod to delete notification
                        $.ajax({
                            type: "POST",
                            url: "Notifications.aspx/DeleteNotification",
                            data: JSON.stringify({ notificationId: id }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function(response) {
                                processed++;
                                
                                if (response && response.d === "success") {
                                    deletedCount++;
                                    
                                    // Remove from UI
                                    const notification = document.querySelector(`[data-id="${id}"]`);
                                    if (notification) {
                                        notification.remove();
                                    }
                                } else {
                                    errorCount++;
                                    console.error("Failed to delete notification:", response.d);
                                }
                                
                                // Check if all have been processed
                                if (processed === totalToDelete) {
                                    finishDeleteProcess(deletedCount, errorCount);
                                }
                            },
                            error: function(xhr, status, error) {
                                processed++;
                                errorCount++;
                                console.error("Error deleting notification:", error);
                                
                                // Check if all have been processed
                                if (processed === totalToDelete) {
                                    finishDeleteProcess(deletedCount, errorCount);
                                }
                            }
                        });
                    });
                }
            });
        }
        
        // Helper function to finish the delete process
        function finishDeleteProcess(deletedCount, errorCount) {
            // Clear selections
            selectedNotifications.clear();
            document.getElementById('selectAll').checked = false;
            updateSelectedCount();
            
            // Update statistics
            fetchNotificationStats();
            
            // Show result message
            if (errorCount === 0) {
                Swal.fire({
                    title: 'Deleted!',
                    text: `${deletedCount} notification(s) have been deleted.`,
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false
                });
            } else {
                Swal.fire({
                    title: 'Partially Completed',
                    text: `${deletedCount} notification(s) deleted, ${errorCount} failed.`,
                    icon: 'warning'
                });
            }
            
            // If all notifications were deleted, check if we need to show empty state
            if (document.querySelectorAll('.notification-card').length === 0) {
                showEmptyState();
            }
        }

        // Update statistics
        function updateStats() {
            // Now handled by fetchNotificationStats()
            fetchNotificationStats();
        }

        // Render notifications from the database
        function renderNotifications(notifications) {
            console.log('Rendering notifications:', notifications);
            
            const notificationsContainer = document.getElementById('notificationsList');
            
            if (!notifications || notifications.length === 0) {
                console.log('No notifications to render');
                showEmptyState();
                return;
            }
            
            let html = '';
            
            try {
                notifications.forEach(notification => {
                    console.log('Processing notification:', notification);
                    
                    // Check if notification has required properties
                    if (!notification.Id || !notification.Title || !notification.Type || !notification.Priority) {
                        console.error('Notification missing required properties:', notification);
                        return; // Skip this notification
                    }
                    
                    const isRead = notification.IsRead;
                    const priority = (notification.Priority || 'medium').toLowerCase();
                    const type = (notification.Type || 'system').toLowerCase();
                    
                    // Determine CSS classes
                    const readClass = isRead ? '' : 'unread';
                    const priorityClass = `${priority}-priority`;
                    
                    // Determine icon based on type
                    let iconClass = 'fas fa-bell';
                    switch(type) {
                        case 'system':
                            iconClass = 'fas fa-cog';
                            break;
                        case 'user':
                            iconClass = 'fas fa-user';
                            break;
                        case 'security':
                            iconClass = 'fas fa-shield-alt';
                            break;
                        case 'update':
                            iconClass = 'fas fa-download';
                            break;
                        case 'warning':
                            iconClass = 'fas fa-exclamation-triangle';
                            break;
                    }
                    
                    try {
                        // Format date to relative time (e.g., "2 hours ago")
                        const createdDate = new Date(notification.CreatedDate);
                        const relativeTime = getRelativeTime(createdDate);
                        
                        html += `
                        <div class="notification-card ${readClass} ${priorityClass}" data-id="${notification.Id}" data-type="${type}" data-priority="${priority}" data-read="${isRead}">
                            <div class="d-flex">
                                <input type="checkbox" class="notification-checkbox me-3 mt-2">
                                <div class="notification-icon ${type}">
                                    <i class="${iconClass}"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">${notification.Title}</div>
                                    <div class="notification-message">${notification.Message}</div>
                                    <div class="notification-meta">
                                        <div class="notification-time">
                                            <i class="fas fa-clock"></i>
                                            <span>${relativeTime}</span>
                                        </div>
                                        <div class="notification-actions">
                                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="viewDetails(${notification.Id})">View Details</button>
                                            ${!isRead ? `<button type="button" class="btn btn-outline-success btn-sm" onclick="markAsRead(${notification.Id})">Mark Read</button>` : ''}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        `;
                    } catch (dateError) {
                        console.error('Error processing date for notification:', dateError, notification);
                    }
                });
                
                if (html === '') {
                    console.log('No notifications were rendered successfully');
                    showEmptyState("Could not render any notifications. Please try again.");
                    return;
                }
                
                notificationsContainer.innerHTML = html;
                
                // Show the notifications list and hide empty state
                document.getElementById('notificationsList').style.display = 'block';
                document.getElementById('emptyState').style.display = 'none';
                
                // Update pagination based on total
                updatePagination(notifications.length);
                
                console.log('Notifications rendered successfully');
            } catch (renderError) {
                console.error('Error rendering notifications:', renderError);
                showEmptyState("Error rendering notifications: " + renderError.message);
            }
        }
        
        // Helper function to convert date to relative time
        function getRelativeTime(date) {
            const now = new Date();
            const diffMs = now - date;
            const diffSec = Math.round(diffMs / 1000);
            const diffMin = Math.round(diffSec / 60);
            const diffHour = Math.round(diffMin / 60);
            const diffDays = Math.round(diffHour / 24);
            
            if (diffSec < 60) {
                return 'Just now';
            } else if (diffMin < 60) {
                return `${diffMin} minute${diffMin > 1 ? 's' : ''} ago`;
            } else if (diffHour < 24) {
                return `${diffHour} hour${diffHour > 1 ? 's' : ''} ago`;
            } else if (diffDays < 7) {
                return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`;
            } else {
                return date.toLocaleDateString();
            }
        }
        
        // Show empty state when no notifications are found
        function showEmptyState(message) {
            const emptyState = document.getElementById('emptyState');
            const notificationsList = document.getElementById('notificationsList');
            
            // Update empty state message if provided
            if (message) {
                emptyState.querySelector('p').textContent = message;
            } else {
                emptyState.querySelector('p').textContent = 'There are no notifications matching your current filters.';
            }
            
            emptyState.style.display = 'block';
            notificationsList.style.display = 'none';
        }

        // Pagination Functions
        function initializePagination() {
            renderPagination();
        }

        function renderPagination() {
            const container = document.getElementById('paginationContainer');
            let paginationHTML = '';

            // Previous button
            if (currentPage > 1) {
                paginationHTML += `<a href="#" class="page-btn" onclick="changePage('prev')">
                    <i class="fas fa-chevron-left me-1"></i>Prev
                </a>`;
            }

            // Page numbers
            let startPage = Math.max(1, currentPage - 2);
            let endPage = Math.min(totalPages, currentPage + 2);

            // Always show first page
            if (startPage > 1) {
                paginationHTML += `<a href="#" class="page-btn" onclick="changePage(1)">1</a>`;
                if (startPage > 2) {
                    paginationHTML += `<span class="page-btn disabled">...</span>`;
                }
            }

            // Page numbers around current page
            for (let i = startPage; i <= endPage; i++) {
                const activeClass = i === currentPage ? 'active' : '';
                paginationHTML += `<a href="#" class="page-btn ${activeClass}" onclick="changePage(${i})">${i}</a>`;
            }

            // Always show last page
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    paginationHTML += `<span class="page-btn disabled">...</span>`;
                }
                paginationHTML += `<a href="#" class="page-btn" onclick="changePage(${totalPages})">${totalPages}</a>`;
            }

            // Next button
            if (currentPage < totalPages) {
                paginationHTML += `<a href="#" class="page-btn" onclick="changePage('next')">
                    Next<i class="fas fa-chevron-right ms-1"></i>
                </a>`;
            }

            container.innerHTML = paginationHTML;
        }

        function changePage(page) {
            let newPage = currentPage;

            if (page === 'prev' && currentPage > 1) {
                newPage = currentPage - 1;
            } else if (page === 'next' && currentPage < totalPages) {
                newPage = currentPage + 1;
            } else if (typeof page === 'number' && page >= 1 && page <= totalPages) {
                newPage = page;
            } else {
                return; // Invalid page
            }

            // Show loading indicator
            Swal.fire({
                title: 'Loading Page ' + newPage,
                html: `
                    <div class="text-center">
                        <div class="spinner-border text-primary mb-3" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <p>Loading notifications for page ${newPage}...</p>
                    </div>
                `,
                allowOutsideClick: false,
                showConfirmButton: false,
                timer: 1500
            });
            
            // Update current page
            currentPage = newPage;
            
            // Load the data for this page
            fetchNotifications(currentFilter, currentPage);
        }

        // Show page info in a toast
        function showPageInfo() {
            // Show a toast notification about the current page
            const toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 2000,
                timerProgressBar: true
            });

            toast.fire({
                icon: 'success',
                title: `Page ${currentPage} of ${totalPages}`,
                text: `Showing notifications ${((currentPage - 1) * itemsPerPage) + 1} - ${Math.min(currentPage * itemsPerPage, totalPages * itemsPerPage)}`
            });
        }
    </script>
</asp:Content>
