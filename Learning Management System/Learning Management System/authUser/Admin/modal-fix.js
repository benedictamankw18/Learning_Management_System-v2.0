// Modal.js fix for Bootstrap 5
// This script fixes the "Cannot read properties of null (reading 'hide')" error
// and adds additional modal functionality fixes

document.addEventListener('DOMContentLoaded', function() {
    console.log('Modal fix script initialized');
    
    // Fix for ASP.NET Web Forms - Create virtual forms in modals
    createVirtualForms();
    
    // Fix for modal.js error: Uncaught TypeError: Cannot read properties of null (reading 'hide')
    // The error happens when a button tries to close a modal that isn't initialized properly
    
    // Get all buttons that dismiss modals
    const dismissButtons = document.querySelectorAll('[data-bs-dismiss="modal"]');
    
    dismissButtons.forEach(button => {
        button.addEventListener('click', function(event) {
            const modalElement = this.closest('.modal');
            if (modalElement) {
                const modalInstance = bootstrap.Modal.getInstance(modalElement);
                if (modalInstance) {
                    modalInstance.hide();
                } else {
                    // If the modal instance doesn't exist, just hide it manually
                    modalElement.style.display = 'none';
                    modalElement.classList.remove('show');
                    document.body.classList.remove('modal-open');
                    const backdrops = document.querySelectorAll('.modal-backdrop');
                    backdrops.forEach(backdrop => backdrop.remove());
                }
            }
            event.preventDefault();
        });
    });
    
    // Fix for modals that might be missing proper initialization
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        if (!bootstrap.Modal.getInstance(modal)) {
            new bootstrap.Modal(modal);
        }
        
        // Add shown.bs.modal event listener to each modal
        modal.addEventListener('shown.bs.modal', function() {
            // Reinitialize virtual forms when modal is shown
            createVirtualForm(this);
        });
    });
});

// Create virtual forms for all modals
function createVirtualForms() {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        createVirtualForm(modal);
    });
}

// Create virtual form for a specific modal
function createVirtualForm(modal) {
    const modalId = modal.id;
    console.log('Creating virtual form for modal:', modalId);
    
    // Find the form element in the modal
    let formElement = modal.querySelector('form');
    let existingUserForm = modal.querySelector('#userForm');
    
    // If the form doesn't exist, create a virtual one
    if (!formElement && !existingUserForm) {
        const modalBody = modal.querySelector('.modal-body');
        if (modalBody) {
            // Check if modalBody already has a form or form-like div
            const existingForm = modalBody.querySelector('form') || modalBody.querySelector('.virtual-form');
            if (!existingForm) {
                console.log('Creating new virtual form for', modalId);
                // Create a div that acts like a form
                const virtualForm = document.createElement('div');
                virtualForm.className = 'virtual-form';
                virtualForm.id = modalId + '-form';
                
                // Move all content inside the virtualForm
                const bodyContent = Array.from(modalBody.childNodes);
                bodyContent.forEach(node => virtualForm.appendChild(node.cloneNode(true)));
                
                // Clear modal body and add the virtual form
                modalBody.innerHTML = '';
                modalBody.appendChild(virtualForm);
                
                // Add reset method to the virtual form
                virtualForm.reset = function() {
                    // Find all inputs in the form and reset them
                    const inputs = this.querySelectorAll('input, select, textarea');
                    inputs.forEach(input => {
                        if (input.type === 'checkbox' || input.type === 'radio') {
                            input.checked = input.defaultChecked;
                        } else if (input.type !== 'hidden') {
                            input.value = input.defaultValue;
                        }
                    });
                    console.log('Virtual form reset completed');
                };
                
                // Add form validation methods
                virtualForm.checkValidity = function() {
                    let isValid = true;
                    const requiredInputs = this.querySelectorAll('input[required], select[required], textarea[required]');
                    requiredInputs.forEach(input => {
                        if (!input.value.trim()) {
                            isValid = false;
                        }
                    });
                    return isValid;
                };
                
                virtualForm.reportValidity = function() {
                    this.checkValidity();
                    // Focus on the first invalid field
                    const firstInvalid = this.querySelector('input[required]:invalid, select[required]:invalid, textarea[required]:invalid');
                    if (firstInvalid) {
                        firstInvalid.focus();
                    }
                };
                
                console.log('Virtual form created:', virtualForm);
                
                // Make it globally available
                window.virtualForms = window.virtualForms || {};
                window.virtualForms[modalId] = virtualForm;
            }
        }
    }
}

// Add a global helper function to find forms in modals reliably
window.findFormInModal = function(modalId, formId) {
    // First, check if we have a virtual form for this modal
    if (window.virtualForms && window.virtualForms[modalId]) {
        console.log('Using virtual form for', modalId);
        return window.virtualForms[modalId];
    }
    
    // Try finding the actual form
    const modal = document.getElementById(modalId);
    if (!modal) return null;
    
    // Check if the modal has a data-form-id attribute
    const dataFormId = modal.getAttribute('data-form-id');
    if (dataFormId) {
        formId = dataFormId; // Use the data-form-id as the primary form ID
    }
    
    // Try by direct ID first
    let form = document.getElementById(formId);
    if (form) return form;
    
    // Try by modal > form
    form = modal.querySelector('form') || modal.querySelector('#' + formId);
    if (form) return form;
    
    // Try by class
    form = modal.querySelector('.virtual-form');
    if (form) return form;
    
    // Last resort - form in modal body
    form = modal.querySelector('.modal-body > form');
    if (form) return form;
    
    // For ASP.NET, we might need to look outside normal DOM hierarchy
    form = document.querySelector('form#' + formId);
    return form;
};
