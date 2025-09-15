<%@ Page Title="Responsive Design Test" Language="C#" MasterPageFile="~/authUser/Admin/Admin.Master" AutoEventWireup="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .test-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid var(--gray-200);
        }
        
        .test-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .breakpoint-indicator {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: var(--primary-blue);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: bold;
            z-index: 1000;
            display: none;
        }
        
        .feature-test {
            border: 2px solid var(--gray-200);
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            transition: all 0.3s ease;
        }
        
        .feature-test:hover {
            border-color: var(--primary-blue);
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .breakpoint-indicator {
                display: block;
            }
            .breakpoint-indicator::before {
                content: "📱 Mobile View";
            }
        }
        
        @media (min-width: 769px) and (max-width: 1024px) {
            .breakpoint-indicator {
                display: block;
            }
            .breakpoint-indicator::before {
                content: "📟 Tablet View";
            }
        }
        
        @media (min-width: 1025px) {
            .breakpoint-indicator {
                display: block;
            }
            .breakpoint-indicator::before {
                content: "🖥️ Desktop View";
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Breakpoint Indicator -->
    <div class="breakpoint-indicator"></div>
    
    <div class="container-fluid">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="h2 mb-3">
                    <i class="fas fa-mobile-alt text-primary"></i>
                    Responsive Design Test
                </h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="Dashboard.aspx">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Responsive Test</li>
                    </ol>
                </nav>
            </div>
        </div>
        
        <!-- Responsive Grid Test -->
        <div class="test-grid">
            <div class="test-card">
                <h5><i class="fas fa-desktop text-primary"></i> Desktop Layout</h5>
                <p>This layout adapts to large screens with sidebar expanded and full navigation visible.</p>
                <div class="feature-test">
                    <strong>Features:</strong>
                    <ul class="mb-0 mt-2">
                        <li>Full sidebar with text labels</li>
                        <li>Global search visible</li>
                        <li>User profile dropdown</li>
                        <li>Wide content area</li>
                    </ul>
                </div>
            </div>
            
            <div class="test-card">
                <h5><i class="fas fa-tablet-alt text-success"></i> Tablet Layout</h5>
                <p>Optimized for tablet devices with adaptive navigation and touch-friendly interfaces.</p>
                <div class="feature-test">
                    <strong>Features:</strong>
                    <ul class="mb-0 mt-2">
                        <li>Collapsible sidebar</li>
                        <li>Touch-optimized buttons</li>
                        <li>Responsive tables</li>
                        <li>Adaptive grid system</li>
                    </ul>
                </div>
            </div>
            
            <div class="test-card">
                <h5><i class="fas fa-mobile text-info"></i> Mobile Layout</h5>
                <p>Mobile-first design with hamburger menu and optimized for small screens.</p>
                <div class="feature-test">
                    <strong>Features:</strong>
                    <ul class="mb-0 mt-2">
                        <li>Hamburger menu toggle</li>
                        <li>Hidden search (can be shown)</li>
                        <li>Stacked navigation</li>
                        <li>Full-width content</li>
                    </ul>
                </div>
            </div>
        </div>
        
        <!-- Interactive Test Buttons -->
        <div class="row">
            <div class="col-12">
                <div class="test-card">
                    <h5><i class="fas fa-cogs text-warning"></i> Interactive Tests</h5>
                    <p>Test the responsive features and interactions:</p>
                    
                    <div class="row">
                        <div class="col-md-6 col-lg-3 mb-3">
                            <button class="btn btn-primary w-100" onclick="testSidebarToggle()">
                                <i class="fas fa-bars"></i> Test Sidebar Toggle
                            </button>
                        </div>
                        <div class="col-md-6 col-lg-3 mb-3">
                            <button class="btn btn-success w-100" onclick="testResponsiveTable()">
                                <i class="fas fa-table"></i> Test Responsive Table
                            </button>
                        </div>
                        <div class="col-md-6 col-lg-3 mb-3">
                            <button class="btn btn-info w-100" onclick="testModalResponsive()">
                                <i class="fas fa-window-maximize"></i> Test Modal
                            </button>
                        </div>
                        <div class="col-md-6 col-lg-3 mb-3">
                            <button class="btn btn-warning w-100" onclick="testThemeToggle()">
                                <i class="fas fa-palette"></i> Test Theme Toggle
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Responsive Table Test -->
        <div class="row">
            <div class="col-12">
                <div class="test-card">
                    <h5><i class="fas fa-table text-secondary"></i> Responsive Table Test</h5>
                    <div class="table-responsive" id="testTableContainer">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>Device</th>
                                    <th>Screen Size</th>
                                    <th>Breakpoint</th>
                                    <th>Sidebar</th>
                                    <th>Navigation</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><i class="fas fa-mobile text-info"></i> Mobile</td>
                                    <td>&lt; 768px</td>
                                    <td>xs</td>
                                    <td>Hidden/Overlay</td>
                                    <td>Hamburger Menu</td>
                                    <td><span class="badge bg-success">Active</span></td>
                                </tr>
                                <tr>
                                    <td><i class="fas fa-tablet-alt text-warning"></i> Tablet</td>
                                    <td>768px - 1024px</td>
                                    <td>sm/md</td>
                                    <td>Collapsible</td>
                                    <td>Full Menu</td>
                                    <td><span class="badge bg-success">Active</span></td>
                                </tr>
                                <tr>
                                    <td><i class="fas fa-desktop text-primary"></i> Desktop</td>
                                    <td>&gt; 1024px</td>
                                    <td>lg/xl</td>
                                    <td>Expanded</td>
                                    <td>Full Navigation</td>
                                    <td><span class="badge bg-success">Active</span></td>
                                </tr>
                                <tr>
                                    <td><i class="fas fa-tv text-secondary"></i> Large Display</td>
                                    <td>&gt; 1400px</td>
                                    <td>xxl</td>
                                    <td>Wide Sidebar</td>
                                    <td>Enhanced UI</td>
                                    <td><span class="badge bg-success">Active</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Device Simulation -->
        <div class="row">
            <div class="col-12">
                <div class="test-card">
                    <h5><i class="fas fa-devices text-dark"></i> Device Simulation</h5>
                    <p>Click buttons to simulate different screen sizes:</p>
                    
                    <div class="btn-group" role="group" aria-label="Device simulation">
                        <button type="button" class="btn btn-outline-primary" onclick="simulateDevice('mobile')">
                            <i class="fas fa-mobile"></i> Mobile (375px)
                        </button>
                        <button type="button" class="btn btn-outline-success" onclick="simulateDevice('tablet')">
                            <i class="fas fa-tablet-alt"></i> Tablet (768px)
                        </button>
                        <button type="button" class="btn btn-outline-info" onclick="simulateDevice('laptop')">
                            <i class="fas fa-laptop"></i> Laptop (1024px)
                        </button>
                        <button type="button" class="btn btn-outline-secondary" onclick="simulateDevice('desktop')">
                            <i class="fas fa-desktop"></i> Desktop (1440px)
                        </button>
                        <button type="button" class="btn btn-outline-dark" onclick="simulateDevice('reset')">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                    </div>
                    
                    <div class="mt-3">
                        <small class="text-muted">
                            Current viewport: <span id="currentViewport">Loading...</span>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Test Modal -->
    <div class="modal fade" id="testModal" tabindex="-1" aria-labelledby="testModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="testModalLabel">
                        <i class="fas fa-test-tube text-primary"></i> Responsive Modal Test
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h6>Modal Responsive Features:</h6>
                    <ul>
                        <li>Adapts to screen size automatically</li>
                        <li>Full-width on mobile devices</li>
                        <li>Proper spacing and padding</li>
                        <li>Touch-friendly close buttons</li>
                    </ul>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">Mobile Optimization</h6>
                                    <p class="card-text">This modal adjusts its width and spacing for mobile devices.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">Desktop Features</h6>
                                    <p class="card-text">On larger screens, the modal maintains optimal reading width.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Responsive test functions
        function testSidebarToggle() {
            if (typeof toggleSidebar === 'function') {
                toggleSidebar();
                showToast('Sidebar toggle tested!', 'success');
            } else {
                showToast('Sidebar toggle function not found', 'error');
            }
        }

        function testResponsiveTable() {
            const table = document.getElementById('testTableContainer');
            table.scrollIntoView({ behavior: 'smooth' });
            table.style.border = '3px solid var(--primary-blue)';
            setTimeout(() => {
                table.style.border = '';
            }, 2000);
            showToast('Responsive table highlighted!', 'info');
        }

        function testModalResponsive() {
            const modal = new bootstrap.Modal(document.getElementById('testModal'));
            modal.show();
        }

        function testThemeToggle() {
            if (typeof toggleTheme === 'function') {
                toggleTheme();
            } else {
                showToast('Theme toggle function not found', 'warning');
            }
        }

        function simulateDevice(deviceType) {
            const body = document.body;
            const viewport = document.getElementById('currentViewport');
            
            // Remove any existing simulation classes
            body.classList.remove('simulate-mobile', 'simulate-tablet', 'simulate-laptop', 'simulate-desktop');
            
            switch(deviceType) {
                case 'mobile':
                    body.style.maxWidth = '375px';
                    body.style.margin = '0 auto';
                    viewport.textContent = '375px (Mobile)';
                    showToast('Simulating mobile device (375px)', 'info');
                    break;
                case 'tablet':
                    body.style.maxWidth = '768px';
                    body.style.margin = '0 auto';
                    viewport.textContent = '768px (Tablet)';
                    showToast('Simulating tablet device (768px)', 'info');
                    break;
                case 'laptop':
                    body.style.maxWidth = '1024px';
                    body.style.margin = '0 auto';
                    viewport.textContent = '1024px (Laptop)';
                    showToast('Simulating laptop screen (1024px)', 'info');
                    break;
                case 'desktop':
                    body.style.maxWidth = '1440px';
                    body.style.margin = '0 auto';
                    viewport.textContent = '1440px (Desktop)';
                    showToast('Simulating desktop screen (1440px)', 'info');
                    break;
                case 'reset':
                    body.style.maxWidth = '';
                    body.style.margin = '';
                    viewport.textContent = window.innerWidth + 'px (Natural)';
                    showToast('Reset to natural viewport', 'success');
                    break;
            }
        }

        function updateViewportInfo() {
            const viewport = document.getElementById('currentViewport');
            if (viewport) {
                viewport.textContent = window.innerWidth + 'px × ' + window.innerHeight + 'px';
            }
        }

        // Initialize viewport info
        document.addEventListener('DOMContentLoaded', function() {
            updateViewportInfo();
            window.addEventListener('resize', updateViewportInfo);
            
            // Auto-test on load
            setTimeout(() => {
                showToast('Responsive design test page loaded!', 'success');
            }, 1000);
        });

        // Utility function for notifications
        function showToast(message, type = 'info') {
            if (typeof Swal !== 'undefined') {
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true
                });

                Toast.fire({
                    icon: type,
                    title: message
                });
            } else {
                console.log(`${type.toUpperCase()}: ${message}`);
            }
        }
    </script>
</asp:Content>
