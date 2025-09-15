// Admin dashboard notification handling
// This file handles loading and displaying notifications for Admin dashboard

// Global notification state
let notificationState = {
    notifications: [],
    lastFetchTime: null,
    unreadCount: 0,
    isLoading: false
};

// Initialize notifications
function initializeNotifications() {
    try {
        // Check if required elements exist before proceeding
        const notificationDropdown = document.getElementById('notificationDropdown');
        if (!notificationDropdown) {
            console.warn("Notification dropdown element not found, skipping notifications initialization");
            return;
        }
        
        // Set up notification badge and dropdown
        setupNotificationListeners();
        
        // Load initial notifications
        loadNotifications();
        
        // Set up periodic refresh (every 60 seconds)
        setInterval(loadNotifications, 60000);
        
        console.log("Notification system initialized");
    } catch (error) {
        console.error("Error initializing notifications:", error);
    }
}

// Setup event listeners for notifications
function setupNotificationListeners() {
    try {
        // Notification dropdown toggle
        const notificationDropdown = document.getElementById('notificationDropdown');
        if (notificationDropdown) {
            notificationDropdown.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Mark notifications as read when dropdown is opened
                markNotificationsAsRead();
            });
        } else {
            console.warn("Notification dropdown element not found");
        }
        
        // Mark all as read button
        const markAllReadBtn = document.getElementById('markAllReadBtn');
        if (markAllReadBtn) {
            markAllReadBtn.addEventListener('click', function(e) {
                e.preventDefault();
                markAllNotificationsAsRead();
            });
        } else {
            console.warn("Mark all read button not found");
        }
        
        console.log("Notification listeners configured");
    } catch (error) {
        console.error("Error setting up notification listeners:", error);
    }
}

// Load notifications from server
function loadNotifications() {
    // Prevent multiple simultaneous requests
    if (notificationState.isLoading) {
        return;
    }
    
    notificationState.isLoading = true;
    
    // Update UI to show loading state
    updateNotificationLoadingState(true);
    
    console.log("Loading notifications...");
    
    // Make AJAX request to get notifications
    $.ajax({
        type: "GET",
        url: "SimpleNotificationsAPI.ashx", // Use our new handler
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(result) {
            try {
                if (result.success) {
                    // Update notification state
                    updateNotifications(result.data);
                    console.log(`Loaded ${result.data.length} notifications`);
                } else {
                    console.error("Error loading notifications:", result.message);
                }
            } catch (error) {
                console.error("Error parsing notification response:", error);
            }
        },
        error: function(xhr, status, error) {
            console.error("Error loading notifications:", error);
            // Show a discreet error in the notification area
            showNotificationError();
        },
        complete: function() {
            notificationState.isLoading = false;
            updateNotificationLoadingState(false);
            notificationState.lastFetchTime = new Date().toISOString();
        }
    });
}

// Update notifications in UI
function updateNotifications(notifications) {
    notificationState.notifications = notifications;
    notificationState.unreadCount = notifications.filter(n => !n.isRead).length;
    
    // Update notification badge
    updateNotificationBadge();
    
    // Update notification list
    updateNotificationList();
}

// Update notification badge with count
function updateNotificationBadge() {
    const badge = document.getElementById('notificationBadge');
    if (!badge) return;
    
    if (notificationState.unreadCount > 0) {
        badge.textContent = notificationState.unreadCount;
        badge.style.display = 'block';
    } else {
        badge.style.display = 'none';
    }
}

// Update notification list in dropdown
function updateNotificationList() {
    const container = document.getElementById('notificationList');
    if (!container) return;
    
    if (notificationState.notifications.length === 0) {
        container.innerHTML = '<div class="dropdown-item text-center">No notifications</div>';
        return;
    }
    
    container.innerHTML = notificationState.notifications.map(notification => `
        <a href="#" class="dropdown-item notification-item ${notification.isRead ? '' : 'unread'}" 
           data-notification-id="${notification.id}">
            <div class="notification-icon ${getNotificationIconClass(notification.type)}">
                <i class="${getNotificationIcon(notification.type)}"></i>
            </div>
            <div class="notification-content">
                <div class="notification-title">${notification.title}</div>
                <div class="notification-text">${notification.message}</div>
                <div class="notification-time">${formatNotificationTime(notification.createdDate)}</div>
            </div>
        </a>
    `).join('');
    
    // Add click handlers to notification items
    attachNotificationItemHandlers();
}

// Attach click handlers to notification items
function attachNotificationItemHandlers() {
    const items = document.querySelectorAll('.notification-item');
    items.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const notificationId = parseInt(this.getAttribute('data-notification-id'));
            handleNotificationClick(notificationId);
        });
    });
}

// Handle notification item click
function handleNotificationClick(notificationId) {
    // Find notification
    const notification = notificationState.notifications.find(n => n.id === notificationId);
    if (!notification) return;
    
    // Mark as read
    markNotificationAsRead(notificationId);
    
    // Handle notification action based on type
    if (notification.actionUrl) {
        window.location.href = notification.actionUrl;
    }
}

// Mark notification as read
function markNotificationAsRead(notificationId) {
    // Update local state
    const notification = notificationState.notifications.find(n => n.id === notificationId);
    if (notification && !notification.isRead) {
        notification.isRead = true;
        notificationState.unreadCount--;
        updateNotificationBadge();
        updateNotificationList();
    }
    
    // Send to server
    $.ajax({
        type: "POST",
        url: "User.aspx/MarkNotificationAsRead",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ notificationId: notificationId }),
        error: function(xhr, status, error) {
            console.error("Error marking notification as read:", error);
        }
    });
}

// Mark all notifications as read
function markAllNotificationsAsRead() {
    // Update local state
    notificationState.notifications.forEach(n => n.isRead = true);
    notificationState.unreadCount = 0;
    updateNotificationBadge();
    updateNotificationList();
    
    // Send to server
    $.ajax({
        type: "POST",
        url: "User.aspx/MarkAllNotificationsAsRead",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        error: function(xhr, status, error) {
            console.error("Error marking all notifications as read:", error);
        }
    });
}

// Show error in notification area
function showNotificationError() {
    const container = document.getElementById('notificationList');
    if (!container) return;
    
    container.innerHTML = `
        <div class="dropdown-item text-center text-danger">
            <i class="fas fa-exclamation-circle me-2"></i>
            Unable to load notifications
        </div>
        <div class="dropdown-item text-center">
            <button class="btn btn-sm btn-outline-primary" onclick="loadNotifications()">
                <i class="fas fa-sync-alt me-1"></i> Retry
            </button>
        </div>
    `;
}

// Update notification loading state
function updateNotificationLoadingState(isLoading) {
    const loadingIndicator = document.getElementById('notificationLoadingIndicator');
    if (!loadingIndicator) return;
    
    loadingIndicator.style.display = isLoading ? 'block' : 'none';
}

// Helper: Get notification icon based on type
function getNotificationIcon(type) {
    switch (type?.toLowerCase()) {
        case 'success': return 'fas fa-check-circle';
        case 'warning': return 'fas fa-exclamation-triangle';
        case 'error': return 'fas fa-times-circle';
        case 'info': return 'fas fa-info-circle';
        case 'message': return 'fas fa-envelope';
        case 'user': return 'fas fa-user';
        case 'course': return 'fas fa-book';
        default: return 'fas fa-bell';
    }
}

// Helper: Get notification icon class for styling
function getNotificationIconClass(type) {
    switch (type?.toLowerCase()) {
        case 'success': return 'bg-success';
        case 'warning': return 'bg-warning';
        case 'error': return 'bg-danger';
        case 'info': return 'bg-info';
        case 'message': return 'bg-primary';
        case 'user': return 'bg-secondary';
        case 'course': return 'bg-purple';
        default: return 'bg-primary';
    }
}

// Helper: Format notification time
function formatNotificationTime(dateString) {
    try {
        const date = new Date(dateString);
        const now = new Date();
        const diffMs = now - date;
        const diffSec = Math.floor(diffMs / 1000);
        const diffMin = Math.floor(diffSec / 60);
        const diffHour = Math.floor(diffMin / 60);
        const diffDay = Math.floor(diffHour / 24);
        
        if (diffSec < 60) {
            return 'Just now';
        } else if (diffMin < 60) {
            return `${diffMin} minute${diffMin > 1 ? 's' : ''} ago`;
        } else if (diffHour < 24) {
            return `${diffHour} hour${diffHour > 1 ? 's' : ''} ago`;
        } else if (diffDay < 7) {
            return `${diffDay} day${diffDay > 1 ? 's' : ''} ago`;
        } else {
            return date.toLocaleDateString();
        }
    } catch (e) {
        return 'Unknown date';
    }
}

// Expose the functions globally
window.loadNotifications = loadNotifications;
window.markAllNotificationsAsRead = markAllNotificationsAsRead;
