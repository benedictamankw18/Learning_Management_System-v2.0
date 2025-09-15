// User Management Functions

/**
 * Toggle user fields based on selected user type
 */
function toggleUserFields() {
    const userType = document.getElementById('userType').value;
    const levelField = document.getElementById('levelField');
    const employeeIdField = document.getElementById('employeeIdField');
    
    if (userType === 'student') {
        levelField.style.display = 'block';
        employeeIdField.style.display = 'none';
        document.getElementById('level').required = true;
        document.getElementById('employeeId').required = false;
    } else if (userType === 'teacher') {
        levelField.style.display = 'none';
        employeeIdField.style.display = 'block';
        document.getElementById('level').required = false;
        document.getElementById('employeeId').required = true;
    } else {
        levelField.style.display = 'none';
        employeeIdField.style.display = 'none';
        document.getElementById('level').required = false;
        document.getElementById('employeeId').required = false;
    }
}

/**
 * Validate phone number
 * @param {HTMLInputElement} input - The phone input element
 * @returns {boolean} - Whether the phone number is valid
 */
function validatePhoneNumber(input) {
    // Check if input is null or undefined
    if (!input) {
        console.error('Phone input is null or undefined');
        return false;
    }
    
    const phoneValue = input.value ? input.value.trim() : '';
    const phoneIcon = document.getElementById('phoneIcon');
    const phoneFeedback = document.getElementById('phoneFeedback');
    
    // Handle case where DOM elements don't exist
    if (!phoneIcon || !phoneFeedback) {
        console.warn('Phone validation UI elements not found');
        // Just do basic validation without UI updates
        if (phoneValue === '') {
            return false;
        }
        
        // Phone validation patterns
        const phonePatterns = {
            ghana: /^(\+233|0)(20|23|24|26|27|28|50|53|54|55|56|57|59)\d{7}$/,
            international: /^\+[1-9]\d{1,14}$/
        };
        
        return phonePatterns.ghana.test(phoneValue) || phonePatterns.international.test(phoneValue);
    }
    
    // Clear previous states
    input.classList.remove('phone-valid', 'phone-invalid');
    phoneIcon.classList.remove('valid', 'invalid');
    phoneIcon.style.display = 'none';
    phoneFeedback.textContent = '';
    phoneFeedback.classList.remove('valid', 'invalid');
    
    if (phoneValue === '') {
        return false;
    }
    
    // Phone validation patterns
    const phonePatterns = {
        ghana: /^(\+233|0)(20|23|24|26|27|28|50|53|54|55|56|57|59)\d{7}$/,
        international: /^\+[1-9]\d{1,14}$/,
        us: /^(\+1|1)?[-.\s]?\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}$/,
        uk: /^(\+44|0)[1-9]\d{8,9}$/
    };
    
    // Check against different patterns
    let isValid = false;
    let feedbackMessage = '';
    
    if (phonePatterns.ghana.test(phoneValue)) {
        isValid = true;
        feedbackMessage = 'Valid Ghana phone number';
    } else if (phonePatterns.international.test(phoneValue)) {
        isValid = true;
        feedbackMessage = 'Valid international phone number';
    } else {
        // Try to suggest correct format
        if (phoneValue.length < 10) {
            feedbackMessage = 'Phone number too short. Use format: +233 50 123 4567';
        } else if (phoneValue.length > 15) {
            feedbackMessage = 'Phone number too long. Use format: +233 50 123 4567';
        } else if (!phoneValue.startsWith('+') && !phoneValue.startsWith('0')) {
            feedbackMessage = 'Phone number should start with + or 0. Use format: +233 50 123 4567';
        } else {
            feedbackMessage = 'Invalid phone number format. Use: +233 50 123 4567';
        }
    }
    
    // Apply validation styles
    if (isValid) {
        input.classList.add('phone-valid');
        phoneIcon.className = 'fas fa-check-circle phone-validation-icon valid';
        phoneFeedback.className = 'phone-feedback valid';
        phoneIcon.style.display = 'block';
    } else {
        input.classList.add('phone-invalid');
        phoneIcon.className = 'fas fa-times-circle phone-validation-icon invalid';
        phoneFeedback.className = 'phone-feedback invalid';
        phoneIcon.style.display = 'block';
    }
    
    phoneFeedback.textContent = feedbackMessage;
    return isValid;
}

/**
 * Assign a course to the current user
 */
function assignCourse() {
    const courseSelect = document.getElementById('courseSelect');
    const courseCode = courseSelect.value;
    
    if (!courseCode) {
        showError('Please select a course to assign');
        return;
    }
    
    // Get global assignedCourses array or initialize it
    if (typeof assignedCourses === 'undefined') {
        window.assignedCourses = [];
    }
    
    if (assignedCourses.includes(courseCode)) {
        showError('Course already assigned');
        return;
    }
    
    assignedCourses.push(courseCode);
    updateCourseDisplay();
    courseSelect.value = '';
}

/**
 * Update the display of assigned courses
 */
function updateCourseDisplay() {
    const container = document.getElementById('assignedCourses');
    
    // Get global assignedCourses array or initialize it
    if (typeof assignedCourses === 'undefined') {
        window.assignedCourses = [];
    }
    
    container.innerHTML = assignedCourses.map(courseCode => `
        <span class="course-tag">
            ${courseCode}
            <span class="remove-course" onclick="removeCourse('${courseCode}')">
                <i class="fas fa-times"></i>
            </span>
        </span>
    `).join('');
}

/**
 * Remove a course from the assigned courses
 * @param {string} courseCode - The course code to remove
 */
function removeCourse(courseCode) {
    // Get global assignedCourses array or initialize it
    if (typeof assignedCourses === 'undefined') {
        window.assignedCourses = [];
    }
    
    assignedCourses = assignedCourses.filter(code => code !== courseCode);
    updateCourseDisplay();
}

/**
 * Preview the uploaded profile picture
 * @param {HTMLInputElement} input - The file input element
 */
function previewProfile(input) {
    if (input.files && input.files[0]) {
        // Validate file size (limit to 2MB)
        const maxSize = 2 * 1024 * 1024; // 2MB in bytes
        if (input.files[0].size > maxSize) {
            showError('Profile picture is too large. Please select an image under 2MB.');
            input.value = '';
            return;
        }
        // Validate file type
        const fileType = input.files[0].type;
        if (!fileType.startsWith('image/')) {
            showError('Please select a valid image file (JPEG, PNG, GIF, etc.)');
            input.value = '';
            return;
        }
        // Upload and set preview
        uploadProfilePicture(input, function(url) {
            const previewEl = document.getElementById('profilePreview');
            if (previewEl) {
                previewEl.src = url;
            }
        });
    }
}

function uploadProfilePicture(input, callback) {
    if (input.files && input.files[0]) {
        const file = input.files[0];
        const reader = new FileReader();
        reader.onload = function(e) {
            // Send base64 to server for saving
            $.ajax({
                type: "POST",
                url: "User.aspx/UploadProfilePicture",
                data: JSON.stringify({ imageData: e.target.result, fileName: file.name }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    const result = response.d ? JSON.parse(response.d) : {};
                    if (result.success) {
                        // Use only the returned filePath as profilePic
                        callback(result.filePath.replace('~', '')); // Remove ~ for client-side use
                    } else {
                        showError(result.message || "Failed to upload image");
                    }
                },
                error: function(xhr, status, error) {
                    showError("Error uploading image: " + error);
                }
            });
        };
        reader.readAsDataURL(file);
    }
}


/**
 * Save user form data
 */
function saveUser() {
    // Get form and other elements with null checks
    const form = document.getElementById('userForm');
    if (!form) {
        console.error('User form not found!');
        showError('Form not found. Please try again or reload the page.');
        return;
    }
    
    const phoneInput = document.getElementById('phone');
    if (!phoneInput) {
        console.error('Phone input not found!');
        showError('Form elements missing. Please try again or reload the page.');
        return;
    }
    
    // Validate phone number
    const isPhoneValid = validatePhoneNumber(phoneInput);
    
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    
    if (!isPhoneValid) {
        showError('Please enter a valid phone number in the format: +233 50 123 4567');
        phoneInput.focus();
        return;
    }
    
    // Get required elements with null checks
    const userActionEl = document.getElementById('userAction');
    const userIdEl = document.getElementById('userId');
    const fullNameEl = document.getElementById('fullName');
    const emailEl = document.getElementById('email');
    const userTypeEl = document.getElementById('userType');
    const departmentEl = document.getElementById('department');
    const levelEl = document.getElementById('level');
    const programmeEl = document.getElementById('programme');
    const profilePicEl = document.getElementById('profilePreview');
    let profilePic = profilePicEl ? profilePicEl.src : '../../../Assest/Images/user.png';
    // This will now be the uploaded URL, not base64!
    const employeeIdEl = document.getElementById('employeeId');

    if (!userActionEl || !fullNameEl || !emailEl || !userTypeEl || !departmentEl) {
        console.error('Essential form elements missing!');
        showError('Some form elements are missing. Please try again or reload the page.');
        return;
    }
    
    const action = userActionEl.value;
    const userData = {
        id: action === 'edit' && userIdEl ? parseInt(userIdEl.value || '0') : 0,
        fullName: fullNameEl.value,
        email: emailEl.value,
        phone: phoneInput.value,
        userType: userTypeEl.value,
        department: departmentEl.value,
        level: levelEl ? levelEl.value : '',
        programme: programmeEl ? programmeEl.value : '',
        profilePic: profilePicEl ? profilePicEl.src : '',
        employeeId: employeeIdEl ? employeeIdEl.value : '',
        courses: assignedCourses || []
    };
    
    // Show loading state
    const saveButton = document.querySelector('#addUserModal .btn-primary');
    if (!saveButton) {
        console.error('Save button not found!');
        showError('Save button not found. Please try again or reload the page.');
        return;
    }
    
    const originalText = saveButton.innerHTML;
    saveButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
    saveButton.disabled = true;
    
    // Call server-side method with proper error handling
    try {
        $.ajax({
            type: "POST",
            url: "User.aspx/SaveUser",
            data: JSON.stringify({ userData: JSON.stringify(userData) }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(response) {
                try {
                    const result = response.d ? JSON.parse(response.d) : {success: false, message: 'Invalid response from server'};
                    if (result.success) {
                        showSuccess(result.message || 'User saved successfully');
                        const modal = bootstrap.Modal.getInstance(document.getElementById('addUserModal'));
                        if (modal) modal.hide();
                        if (typeof loadUsers === 'function') {
                            loadUsers();
                        } else {
                            console.warn('loadUsers function not found, cannot refresh user list');
                            // Fallback - reload the page after a short delay
                            setTimeout(() => {
                                window.location.reload();
                            }, 1500);
                        }
                    } else {
                        showError(result.message || 'Error saving user');
                    }
                } catch (parseError) {
                    console.error('Error parsing AJAX response:', parseError);
                    showError('Error processing server response');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX error:', status, error);
                showError('Error saving user: ' + (error || 'Unknown error'));
            },
            complete: function() {
                // Restore button state
                if (saveButton) {
                    saveButton.innerHTML = originalText;
                    saveButton.disabled = false;
                }
            }
        });
    } catch (ajaxError) {
        console.error('Error making AJAX call:', ajaxError);
        showError('Error connecting to server. Please check your connection and try again.');
        if (saveButton) {
            saveButton.innerHTML = originalText;
            saveButton.disabled = false;
        }
    }
}

/**
 * Show success message
 * @param {string} message - Success message to display
 */
function showSuccess(message) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: message,
            confirmButtonColor: '#2c2b7c',
            background: '#ffffff',
            color: '#333333'
        });
    } else {
        // Fallback to bootstrap modal
        document.getElementById('successMessage').textContent = message;
        const successModal = new bootstrap.Modal(document.getElementById('successModal'));
        successModal.show();
    }
}

/**
 * Reset user form for adding new user
 */
function resetUserForm() {
    const form = document.getElementById('userForm');
    form.reset();
    
    // Reset phone validation
    const phoneInput = document.getElementById('phone');
    const phoneIcon = document.getElementById('phoneIcon');
    const phoneFeedback = document.getElementById('phoneFeedback');
    
    phoneInput.classList.remove('phone-valid', 'phone-invalid');
    phoneIcon.style.display = 'none';
    phoneIcon.classList.remove('valid', 'invalid');
    phoneFeedback.textContent = '';
    phoneFeedback.classList.remove('valid', 'invalid');
    
    // Reset other form elements
    document.getElementById('modalTitle').textContent = 'Add New User';
    document.getElementById('saveButtonText').textContent = 'Save User';
    document.getElementById('userAction').value = 'add';
    document.getElementById('userId').value = '';
    
    // Reset profile picture to placeholder
    document.getElementById('profilePreview').src = 'https://placehold.co/120x120/3498db/ffffff?text=User';
    
    // Reset file input
    const profileInput = document.getElementById('profileInput');
    if (profileInput) {
        profileInput.value = '';
    }
    
    // Reset assigned courses
    assignedCourses = [];
    updateCourseDisplay();
    
    // Reset field visibility
    toggleUserFields();
}

/**
 * Reset form function (alias)
 */
function resetForm() {
    resetUserForm();
}

/**
 * Show error message
 * @param {string} message - Error message to display
 */
function showError(message) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            icon: 'error',
            title: 'Error!',
            text: message,
            confirmButtonColor: '#ee1c24',
            background: '#ffffff',
            color: '#333333'
        });
    } else {
        // Fallback to bootstrap modal
        document.getElementById('errorMessage').textContent = message;
        const errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
        errorModal.show();
    }
}

// Initialize assignedCourses global variable if not already defined
if (typeof assignedCourses === 'undefined') {
    window.assignedCourses = [];
}

// Add CSS for the animation effect
document.addEventListener('DOMContentLoaded', function() {
    // Create a style element
    const style = document.createElement('style');
    style.textContent = `
        .profile-updated {
            transform: scale(1.05);
            box-shadow: 0 0 15px rgba(44, 43, 124, 0.7);
            transition: all 0.3s ease;
        }
        
        .profile-preview {
            transition: all 0.3s ease;
        }
    `;
    
    // Append the style to the head
    document.head.appendChild(style);
});
