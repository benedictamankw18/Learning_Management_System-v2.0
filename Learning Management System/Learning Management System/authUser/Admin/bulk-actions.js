// Enable bulk actions for course management
function toggleBulkActions() {
    const checkboxes = document.querySelectorAll('.course-row-checkbox');
    const bulkActionBtn = document.getElementById('bulkActionBtn');
    const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
    
    // Check if any checkboxes are checked
    const anyChecked = Array.from(checkboxes).some(cb => cb.checked);
    
    // Enable/disable bulk action buttons
    if (bulkActionBtn) {
        bulkActionBtn.disabled = !anyChecked;
    }
    if (bulkDeleteBtn) {
        bulkDeleteBtn.disabled = !anyChecked;
    }
    
    // Update UI elements to show bulk action state
    updateBulkActionUI(anyChecked);
}

// Update bulk action UI elements
function updateBulkActionUI(showBulkActions) {
    const bulkActionContainer = document.getElementById('bulkActionContainer');
    const selectedCount = Array.from(document.querySelectorAll('.course-row-checkbox:checked')).length;
    
    if (bulkActionContainer) {
        if (showBulkActions) {
            bulkActionContainer.style.display = 'flex';
            const countDisplay = document.getElementById('selectedCount');
            if (countDisplay) {
                countDisplay.textContent = selectedCount;
            }
        } else {
            bulkActionContainer.style.display = 'none';
        }
    }
}

// Execute bulk status update
async function bulkStatusUpdate() {
    const selectedCourses = Array.from(document.querySelectorAll('.course-row-checkbox:checked'))
        .map(cb => cb.closest('tr').querySelector('.course-code-badge').textContent.trim());
    
    if (selectedCourses.length === 0) {
        showToast('Please select courses to update', 'warning');
        return;
    }
    
    try {
        const response = await Swal.fire({
            title: 'Update Course Status',
            text: `Change status for ${selectedCourses.length} selected course(s)`,
            icon: 'question',
            input: 'select',
            inputOptions: {
                'active': 'Active',
                'inactive': 'Inactive',
                'draft': 'Draft'
            },
            inputPlaceholder: 'Select new status',
            showCancelButton: true,
            confirmButtonText: 'Update',
            showLoaderOnConfirm: true,
            preConfirm: (status) => {
                if (!status) {
                    Swal.showValidationMessage('Please select a status');
                }
                return status;
            }
        });
        
        if (response.isConfirmed && response.value) {
            const newStatus = response.value;
            
            // Call server to update status
            const result = await updateCoursesStatus(selectedCourses, newStatus);
            
            if (result.success) {
                showToast(`Successfully updated ${selectedCourses.length} course(s)`, 'success');
                loadCourses(); // Reload table
            } else {
                throw new Error(result.message || 'Failed to update courses');
            }
        }
    } catch (error) {
        console.error('Bulk status update error:', error);
        showToast('Failed to update course status: ' + error.message, 'error');
    }
}

// Execute bulk delete
async function bulkDelete() {
    const selectedCourses = Array.from(document.querySelectorAll('.course-row-checkbox:checked'))
        .map(cb => cb.closest('tr').querySelector('.course-code-badge').textContent.trim());
    
    if (selectedCourses.length === 0) {
        showToast('Please select courses to delete', 'warning');
        return;
    }
    
    try {
        const result = await Swal.fire({
            title: 'Confirm Deletion',
            html: `
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    You are about to delete ${selectedCourses.length} course(s).
                    This action cannot be undone!
                </div>
                <p class="mb-2">Selected courses:</p>
                <ul class="text-start">
                    ${selectedCourses.map(code => `<li>${code}</li>`).join('')}
                </ul>
            `,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, Delete',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#dc3545',
            reverseButtons: true,
            focusCancel: true
        });
        
        if (result.isConfirmed) {
            // Call server to delete courses
            const deleteResult = await deleteSelectedCourses(selectedCourses);
            
            if (deleteResult.success) {
                showToast(`Successfully deleted ${selectedCourses.length} course(s)`, 'success');
                loadCourses(); // Reload table
            } else {
                throw new Error(deleteResult.message || 'Failed to delete courses');
            }
        }
    } catch (error) {
        console.error('Bulk delete error:', error);
        showToast('Failed to delete courses: ' + error.message, 'error');
    }
}

// Function to handle server-side status update
async function updateCoursesStatus(courseIds, newStatus) {
    try {
        const response = await $.ajax({
            type: "POST",
            url: "Course.aspx/UpdateCoursesStatus",
            data: JSON.stringify({
                courseIds: courseIds,
                status: newStatus
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        });
        
        return response.d;
    } catch (error) {
        throw new Error('Server error while updating course status');
    }
}

// Function to handle server-side delete
async function deleteSelectedCourses(courseIds) {
    try {
        const response = await $.ajax({
            type: "POST",
            url: "Course.aspx/DeleteCourses",
            data: JSON.stringify({
                courseIds: courseIds
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json"
        });
        
        return response.d;
    } catch (error) {
        throw new Error('Server error while deleting courses');
    }
}
