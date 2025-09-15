// Handle individual row checkbox changes
function handleRowCheckboxChange() {
    const checkboxes = document.querySelectorAll('.course-row-checkbox');
    const selectAllCheckbox = document.getElementById('selectAll');
    const bulkActionBtn = document.getElementById('bulkActionBtn');
    const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
    
    // Convert checkboxes NodeList to Array for easier manipulation
    const checkboxArray = Array.from(checkboxes);
    
    // Check if any checkboxes are checked
    const checkedCount = checkboxArray.filter(cb => cb.checked).length;
    const anyChecked = checkedCount > 0;
    
    // Check if all checkboxes are checked
    const allChecked = checkedCount === checkboxArray.length;
    
    // Update the select all checkbox
    if (selectAllCheckbox) {
        selectAllCheckbox.checked = allChecked;
        selectAllCheckbox.indeterminate = anyChecked && !allChecked;
    }
    
    // Enable/disable bulk action buttons
    if (bulkActionBtn) {
        bulkActionBtn.disabled = !anyChecked;
    }
    if (bulkDeleteBtn) {
        bulkDeleteBtn.disabled = !anyChecked;
    }
    
    // Update counters if they exist
    const selectedCountSpan = document.getElementById('selectedCount');
    if (selectedCountSpan) {
        selectedCountSpan.textContent = checkedCount;
    }
    
    // Show/hide bulk action container if it exists
    const bulkActionContainer = document.getElementById('bulkActionContainer');
    if (bulkActionContainer) {
        bulkActionContainer.style.display = anyChecked ? 'flex' : 'none';
    }
}
