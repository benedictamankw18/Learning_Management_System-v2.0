// Enhanced Admin Master JavaScript with Modern Features

// Global variables
let debounceTimer;
const menuItems = document.querySelectorAll('.menu-item');

// Initialize on page load
window.addEventListener('load', () => {
    initializeAdminMaster();
    setActiveMenuItem();
    initializeAnimations();
});

// Main initialization function
function initializeAdminMaster() {
    // Remove active class from all menu items
    menuItems.forEach(item => item.classList.remove('active'));
    
    // Set first menu item as active by default
    const firstMenuItem = document.querySelector('.side-menu a:first-child');
    if (firstMenuItem) {
        firstMenuItem.classList.add('active');
    }
    
    // Initialize event listeners
    initializeEventListeners();
    
    // Initialize responsive behavior
    initializeResponsiveBehavior();
    
    // Initialize search functionality
    initializeSearchFeatures();
}

// Event listeners setup
function initializeEventListeners() {
    // Sidebar toggle functionality
    const toggleButton = document.querySelector('.mobile-menu-toggle');
    if (toggleButton) {
        toggleButton.addEventListener('click', handleSidebarToggle);
    }

    // Menu item click handlers
    menuItems.forEach(item => {
        item.addEventListener('click', function(e) {
            handleMenuItemClick(this);
        });
        
        // Add hover effects
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateX(5px)';
        });
        
        item.addEventListener('mouseleave', function() {
            this.style.transform = 'translateX(0)';
        });
    });
    
    // Global search functionality
    const searchInput = document.getElementById('globalSearch');
    if (searchInput) {
        searchInput.addEventListener('input', handleGlobalSearch);
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch(this.value);
            }
        });
    }
    
    // Profile dropdown functionality
    initializeProfileDropdown();
    
    // Window resize handler
    window.addEventListener('resize', handleWindowResize);
    
    // Scroll behavior
    initializeScrollBehavior();
}

// Enhanced sidebar toggle with animation
function handleSidebarToggle() {
    const sidebar = document.getElementById('sidebar');
    const wholepage = document.getElementById('wholepage');
    const toggleIcon = document.querySelector('.mobile-menu-toggle i');
    
    if (!sidebar) return;
    
    if (window.innerWidth <= 768) {
        // Mobile behavior - slide in/out
        sidebar.classList.toggle('active');
        
        if (sidebar.classList.contains('active')) {
            toggleIcon.className = 'fa fa-times';
            sidebar.style.transform = 'translateX(0)';
            // Add overlay
            addMobileOverlay();
        } else {
            toggleIcon.className = 'fa fa-bars';
            sidebar.style.transform = 'translateX(-100%)';
            removeMobileOverlay();
        }
    } else {
        // Desktop behavior - collapse/expand
        sidebar.classList.toggle('collapsed');
        
        if (sidebar.classList.contains('collapsed')) {
            sidebar.style.width = '70px';
            wholepage.style.marginLeft = '70px';
            toggleIcon.className = 'fa fa-angle-right';
        } else {
            sidebar.style.width = '280px';
            wholepage.style.marginLeft = '280px';
            toggleIcon.className = 'fa fa-angle-left';
        }
    }
    
    // Trigger animation
    sidebar.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
    if (wholepage) {
        wholepage.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
    }
}

// Mobile overlay for sidebar
function addMobileOverlay() {
    const overlay = document.createElement('div');
    overlay.id = 'mobileOverlay';
    overlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.5);
        z-index: 99;
        transition: opacity 0.3s ease;
    `;
    
    overlay.addEventListener('click', () => {
        handleSidebarToggle();
    });
    
    document.body.appendChild(overlay);
    
    setTimeout(() => {
        overlay.style.opacity = '1';
    }, 10);
}

function removeMobileOverlay() {
    const overlay = document.getElementById('mobileOverlay');
    if (overlay) {
        overlay.style.opacity = '0';
        setTimeout(() => {
            overlay.remove();
        }, 300);
    }
}

// Enhanced menu item handling
function handleMenuItemClick(clickedItem) {
    // Remove active class from all items
    menuItems.forEach(item => item.classList.remove('active'));
    
    // Add active class to clicked item
    clickedItem.classList.add('active');
    
    // Add click animation
    clickedItem.style.transform = 'scale(0.95)';
    setTimeout(() => {
        clickedItem.style.transform = '';
    }, 150);
    
    // Close mobile sidebar if open
    if (window.innerWidth <= 768) {
        const sidebar = document.getElementById('sidebar');
        if (sidebar && sidebar.classList.contains('active')) {
            setTimeout(() => {
                handleSidebarToggle();
            }, 300);
        }
    }
    
    // Show loading for navigation
    showNavigationLoading();
}

// Set active menu item based on current page
function setActiveMenuItem() {
    const currentPath = window.location.pathname.toLowerCase();
    
    menuItems.forEach(item => {
        const href = item.getAttribute('href');
        if (href && currentPath.includes(href.toLowerCase())) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
}

// Global search functionality
function handleGlobalSearch(e) {
    clearTimeout(debounceTimer);
    const query = e.target.value.trim();
    
    if (query.length >= 2) {
        debounceTimer = setTimeout(() => {
            performSearch(query);
        }, 300);
    }
}

function performSearch(query) {
    if (!query) return;
    
    // Show search loading
    showSearchLoading();
    
    // Simulate search API call
    setTimeout(() => {
        hideSearchLoading();
        
        // Show search results (placeholder)
        if (typeof showToast === 'function') {
            showToast(`Searching for: "${query}"`, 'info');
        } else {
            console.log(`Search performed for: "${query}"`);
        }
        
        // Here you would implement actual search logic
        // Example: searchResults(query);
    }, 800);
}

// Profile dropdown functionality
function initializeProfileDropdown() {
    const userIcon = document.querySelector('.user-icon');
    const dropProfile = document.querySelector('.drop-profile');
    
    if (!userIcon || !dropProfile) return;
    
    let hoverTimeout;
    
    userIcon.addEventListener('mouseenter', () => {
        clearTimeout(hoverTimeout);
        dropProfile.style.opacity = '1';
        dropProfile.style.visibility = 'visible';
        dropProfile.style.transform = 'translateY(5px)';
    });
    
    userIcon.addEventListener('mouseleave', () => {
        hoverTimeout = setTimeout(() => {
            dropProfile.style.opacity = '0';
            dropProfile.style.visibility = 'hidden';
            dropProfile.style.transform = 'translateY(-10px)';
        }, 300);
    });
    
    dropProfile.addEventListener('mouseenter', () => {
        clearTimeout(hoverTimeout);
    });
    
    dropProfile.addEventListener('mouseleave', () => {
        dropProfile.style.opacity = '0';
        dropProfile.style.visibility = 'hidden';
        dropProfile.style.transform = 'translateY(-10px)';
    });
}

// Window resize handler
function handleWindowResize() {
    const sidebar = document.getElementById('sidebar');
    const wholepage = document.getElementById('wholepage');
    const toggleIcon = document.querySelector('.mobile-menu-toggle i');
    
    if (window.innerWidth > 768) {
        // Desktop mode
        if (sidebar) {
            sidebar.classList.remove('active');
            sidebar.style.transform = '';
        }
        if (toggleIcon) {
            toggleIcon.className = 'fa fa-bars';
        }
        removeMobileOverlay();
        
        // Reset desktop layout
        if (sidebar && !sidebar.classList.contains('collapsed')) {
            sidebar.style.width = '280px';
            if (wholepage) {
                wholepage.style.marginLeft = '280px';
            }
        }
    } else {
        // Mobile mode
        if (sidebar) {
            sidebar.style.width = '';
            sidebar.classList.remove('collapsed');
        }
        if (wholepage) {
            wholepage.style.marginLeft = '0';
        }
    }
}

// Responsive behavior initialization
function initializeResponsiveBehavior() {
    // Handle initial responsive state
    handleWindowResize();
    
    // Add mobile-specific touch gestures
    if ('ontouchstart' in window) {
        initializeTouchGestures();
    }
}

// Touch gestures for mobile
function initializeTouchGestures() {
    let startX = 0;
    let currentX = 0;
    let isDragging = false;
    
    document.addEventListener('touchstart', (e) => {
        startX = e.touches[0].clientX;
        isDragging = true;
    });
    
    document.addEventListener('touchmove', (e) => {
        if (!isDragging) return;
        currentX = e.touches[0].clientX;
    });
    
    document.addEventListener('touchend', () => {
        if (!isDragging) return;
        isDragging = false;
        
        const diffX = currentX - startX;
        const sidebar = document.getElementById('sidebar');
        
        // Swipe right to open sidebar
        if (diffX > 50 && startX < 50 && sidebar && !sidebar.classList.contains('active')) {
            handleSidebarToggle();
        }
        // Swipe left to close sidebar
        else if (diffX < -50 && sidebar && sidebar.classList.contains('active')) {
            handleSidebarToggle();
        }
    });
}

// Search features initialization
function initializeSearchFeatures() {
    const searchInput = document.getElementById('globalSearch');
    if (!searchInput) return;
    
    // Add search suggestions (placeholder)
    const suggestions = [
        'Dashboard', 'Users', 'Courses', 'Materials', 'Quizzes', 'Reports',
        'Settings', 'Analytics', 'Students', 'Instructors'
    ];
    
    // You can implement autocomplete here
    // Example: createSearchSuggestions(searchInput, suggestions);
}

// Animation initialization
function initializeAnimations() {
    // Fade in page elements
    const animateElements = document.querySelectorAll('.menu-item, .header-content, .wholepage');
    
    animateElements.forEach((element, index) => {
        element.style.opacity = '0';
        element.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            element.style.transition = 'all 0.6s ease';
            element.style.opacity = '1';
            element.style.transform = 'translateY(0)';
        }, index * 100);
    });
}

// Scroll behavior
function initializeScrollBehavior() {
    let lastScrollTop = 0;
    const header = document.getElementById('header');
    
    window.addEventListener('scroll', () => {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        if (scrollTop > lastScrollTop && scrollTop > 100) {
            // Scrolling down
            if (header) {
                header.style.transform = 'translateY(-100%)';
            }
        } else {
            // Scrolling up
            if (header) {
                header.style.transform = 'translateY(0)';
            }
        }
        
        lastScrollTop = scrollTop;
    });
}

// Loading states
function showNavigationLoading() {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) {
        overlay.classList.add('active');
        setTimeout(() => {
            overlay.classList.remove('active');
        }, 500);
    }
}

function showSearchLoading() {
    const searchIcon = document.querySelector('.search-icon i');
    if (searchIcon) {
        searchIcon.className = 'fa fa-spinner fa-spin';
    }
}

function hideSearchLoading() {
    const searchIcon = document.querySelector('.search-icon i');
    if (searchIcon) {
        searchIcon.className = 'fa fa-search';
    }
}

// Utility functions
function createRippleEffect(element, event) {
    const ripple = document.createElement('span');
    const rect = element.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = event.clientX - rect.left - size / 2;
    const y = event.clientY - rect.top - size / 2;
    
    ripple.style.cssText = `
        position: absolute;
        width: ${size}px;
        height: ${size}px;
        left: ${x}px;
        top: ${y}px;
        background: rgba(255,255,255,0.3);
        border-radius: 50%;
        transform: scale(0);
        animation: ripple 0.6s ease-out;
        pointer-events: none;
    `;
    
    element.style.position = 'relative';
    element.style.overflow = 'hidden';
    element.appendChild(ripple);
    
    setTimeout(() => {
        ripple.remove();
    }, 600);
}

// Add CSS for ripple animation
const style = document.createElement('style');
style.textContent = `
    @keyframes ripple {
        to {
            transform: scale(2);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Add ripple effect to menu items
document.addEventListener('DOMContentLoaded', () => {
    menuItems.forEach(item => {
        item.addEventListener('click', function(e) {
            createRippleEffect(this, e);
        });
    });
});

// Performance optimization
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Export functions for global use
window.AdminMaster = {
    toggleSidebar: handleSidebarToggle,
    performSearch: performSearch,
    showLoading: showNavigationLoading,
    createRipple: createRippleEffect
};