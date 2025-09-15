/**
 * Custom Fade Animation Handler
 * Replacement for Bootstrap fade functionality
 * University of Education, Winneba - Learning Management System
 */

(function() {
    'use strict';

    // Custom Modal Handler
    class CustomModal {
        constructor(element) {
            this.element = element;
            this.backdrop = null;
            this.isShown = false;
        }

        show() {
            if (this.isShown) return;
            
            this.isShown = true;
            this.element.style.display = 'block';
            document.body.classList.add('modal-open');
            
            // Create backdrop
            this.createBackdrop();
            
            // Trigger animations
            requestAnimationFrame(() => {
                this.element.classList.add('show');
                if (this.backdrop) {
                    this.backdrop.classList.add('show');
                }
            });

            // Trigger custom event
            this.element.dispatchEvent(new CustomEvent('shown.custom.modal'));
        }

        hide() {
            if (!this.isShown) return;
            
            this.isShown = false;
            this.element.classList.remove('show');
            
            if (this.backdrop) {
                this.backdrop.classList.remove('show');
            }

            setTimeout(() => {
                this.element.style.display = 'none';
                this.removeBackdrop();
                document.body.classList.remove('modal-open');
                
                // Trigger custom event
                this.element.dispatchEvent(new CustomEvent('hidden.custom.modal'));
            }, 300);
        }

        createBackdrop() {
            this.backdrop = document.createElement('div');
            this.backdrop.className = 'modal-backdrop custom-fade';
            this.backdrop.addEventListener('click', () => this.hide());
            document.body.appendChild(this.backdrop);
        }

        removeBackdrop() {
            if (this.backdrop) {
                this.backdrop.remove();
                this.backdrop = null;
            }
        }

        toggle() {
            if (this.isShown) {
                this.hide();
            } else {
                this.show();
            }
        }
    }

    // Custom Tab Handler
    class CustomTab {
        static show(targetId) {
            const target = document.getElementById(targetId);
            if (!target) return;

            // Hide all tab panes
            const tabPanes = target.closest('.tab-content').querySelectorAll('.tab-pane');
            tabPanes.forEach(pane => {
                pane.classList.remove('show', 'active');
            });

            // Show target tab
            setTimeout(() => {
                target.classList.add('show', 'active');
                target.dispatchEvent(new CustomEvent('shown.custom.tab'));
            }, 50);
        }
    }

    // Initialize modal functionality
    function initModals() {
        const modals = document.querySelectorAll('.modal.custom-fade');
        const modalInstances = new Map();

        modals.forEach(modal => {
            const instance = new CustomModal(modal);
            modalInstances.set(modal.id, instance);

            // Handle trigger buttons
            const triggers = document.querySelectorAll(`[data-bs-toggle="modal"][data-bs-target="#${modal.id}"]`);
            triggers.forEach(trigger => {
                trigger.addEventListener('click', (e) => {
                    e.preventDefault();
                    instance.show();
                });
            });

            // Handle close buttons
            const closeBtns = modal.querySelectorAll('[data-bs-dismiss="modal"], .btn-close');
            closeBtns.forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    instance.hide();
                });
            });

            // Handle ESC key
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && instance.isShown) {
                    instance.hide();
                }
            });
        });

        // Global modal access
        window.CustomModal = {
            getInstance: (modalId) => modalInstances.get(modalId),
            show: (modalId) => {
                const instance = modalInstances.get(modalId);
                if (instance) instance.show();
            },
            hide: (modalId) => {
                const instance = modalInstances.get(modalId);
                if (instance) instance.hide();
            }
        };
    }

    // Initialize tab functionality
    function initTabs() {
        const tabButtons = document.querySelectorAll('[data-bs-toggle="pill"], [data-bs-toggle="tab"]');
        
        tabButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                
                const targetId = button.getAttribute('data-bs-target')?.substring(1) || 
                                button.getAttribute('href')?.substring(1);
                
                if (targetId) {
                    // Update active tab button
                    const tabContainer = button.closest('.nav');
                    if (tabContainer) {
                        tabContainer.querySelectorAll('.nav-link').forEach(link => {
                            link.classList.remove('active');
                        });
                        button.classList.add('active');
                    }
                    
                    CustomTab.show(targetId);
                }
            });
        });
    }

    // Animation utilities
    function animateElements() {
        // Animate cards with stagger effect
        const cards = document.querySelectorAll('.card-animate:not(.show)');
        cards.forEach((card, index) => {
            setTimeout(() => {
                card.classList.add('show');
            }, index * 100);
        });

        // Animate forms
        const forms = document.querySelectorAll('.form-animate:not(.show)');
        forms.forEach(form => {
            form.classList.add('show');
        });
    }

    // Loading animation utility
    function showLoading(element) {
        element.classList.add('loading-fade');
        element.style.pointerEvents = 'none';
    }

    function hideLoading(element) {
        element.classList.remove('loading-fade');
        element.style.pointerEvents = 'auto';
    }

    // Initialize everything when DOM is ready
    function init() {
        initModals();
        initTabs();
        animateElements();
        
        // Re-animate elements when new content is added
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.type === 'childList') {
                    setTimeout(animateElements, 50);
                }
            });
        });
        
        observer.observe(document.body, { childList: true, subtree: true });
    }

    // Public API
    window.CustomAnimations = {
        init: function() {
            // Re-initialize everything
            initModals();
            initTabs();
            animateElements();
            console.log('CustomAnimations initialized explicitly');
        },
        showModal: (modalId) => window.CustomModal.show(modalId),
        hideModal: (modalId) => window.CustomModal.hide(modalId),
        showTab: (targetId) => CustomTab.show(targetId),
        animateElements: animateElements,
        showLoading: showLoading,
        hideLoading: hideLoading
    };

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();
