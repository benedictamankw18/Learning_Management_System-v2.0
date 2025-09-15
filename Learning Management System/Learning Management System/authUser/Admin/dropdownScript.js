/**
 * This script handles dynamic loading of dropdown data and form submission with proper IDs
 */

// Function to load dropdown data from database
function loadDropdownData() {
    // Load departments
    $.ajax({
        type: "POST",
        url: "User.aspx/GetDepartments",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            const result = JSON.parse(response.d);
            if (result.success) {
                populateDropdown('department', result.data);
            } else {
                console.error('Error loading departments:', result.message);
            }
        },
        error: function(error) {
            console.error('Error loading departments:', error);
        }
    });
    
    // Load levels
    $.ajax({
        type: "POST",
        url: "User.aspx/GetLevels",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            const result = JSON.parse(response.d);
            if (result.success) {
                populateDropdown('level', result.data);
            } else {
                console.error('Error loading levels:', result.message);
            }
        },
        error: function(error) {
            console.error('Error loading levels:', error);
        }
    });
    
    // Load programmes
    $.ajax({
        type: "POST",
        url: "User.aspx/GetProgrammes",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(response) {
            const result = JSON.parse(response.d);
            if (result.success) {
                populateDropdown('programme', result.data);
            } else {
                console.error('Error loading programmes:', result.message);
            }
        },
        error: function(error) {
            console.error('Error loading programmes:', error);
        }
    });
}

// Helper function to populate dropdowns
function populateDropdown(dropdownId, data) {
    const dropdown = document.getElementById(dropdownId);
    if (!dropdown) {
        console.error(`Dropdown with ID ${dropdownId} not found`);
        return;
    }
    
    // Keep the first "Select..." option
    const firstOption = dropdown.options[0];
    
    // Clear existing options except the first one
    dropdown.innerHTML = '';
    dropdown.appendChild(firstOption);
    
    // Add new options from database data
    data.forEach(item => {
        const option = document.createElement('option');
        option.value = item.name; // Using name as value for backward compatibility
        option.text = item.name;
        option.dataset.id = item.id; // Store ID as data attribute for reference
        
        // For programmes, store department ID for filtering
        if (dropdownId === 'programme' && item.departmentId) {
            option.dataset.departmentId = item.departmentId;
        }
        
        dropdown.appendChild(option);
    });
    
    // Set up department-programme filtering if this is the department dropdown
    if (dropdownId === 'department') {
        setupDepartmentProgrammeFilter();
    }
}

// Function to set up filtering of programmes based on selected department
function setupDepartmentProgrammeFilter() {
    const departmentDropdown = document.getElementById('department');
    const programmeDropdown = document.getElementById('programme');
    
    if (!departmentDropdown || !programmeDropdown) {
        console.error('Department or Programme dropdown not found');
        return;
    }
    
    // Add change event listener to department dropdown
    departmentDropdown.addEventListener('change', function() {
        const selectedDepartment = this.options[this.selectedIndex];
        if (!selectedDepartment || !selectedDepartment.dataset.id) {
            // Reset programme dropdown if no department selected
            resetProgrammeDropdown();
            return;
        }
        
        const departmentId = parseInt(selectedDepartment.dataset.id);
        filterProgrammesByDepartment(departmentId);
    });
}

// Function to filter programmes by department
function filterProgrammesByDepartment(departmentId) {
    const programmeDropdown = document.getElementById('programme');
    if (!programmeDropdown) return;
    
    // Get all options (including hidden ones)
    const allProgrammes = Array.from(programmeDropdown.querySelectorAll('option'));
    
    // Keep the first option
    const firstOption = allProgrammes[0];
    
    // Filter programmes by department ID
    const filteredProgrammes = allProgrammes.filter(option => {
        if (option === firstOption) return true; // Always keep the first option
        
        const optionDepartmentId = option.dataset.departmentId ? parseInt(option.dataset.departmentId) : null;
        return optionDepartmentId === departmentId;
    });
    
    // Clear and repopulate dropdown
    programmeDropdown.innerHTML = '';
    filteredProgrammes.forEach(option => {
        programmeDropdown.appendChild(option);
    });
    
    // Reset selection to first option
    programmeDropdown.selectedIndex = 0;
}

// Function to reset programme dropdown to show all options
function resetProgrammeDropdown() {
    // This could be extended if needed
    const programmeDropdown = document.getElementById('programme');
    if (programmeDropdown) {
        programmeDropdown.selectedIndex = 0; // Select the first option
    }
}

// Function to get dropdown element ID values
function getDropdownIdValues() {
    // Get dropdown elements
    const departmentElement = document.getElementById('department');
    const levelElement = document.getElementById('level');
    const programmeElement = document.getElementById('programme');
    
    // Get selected options
    const selectedDepartment = departmentElement.options[departmentElement.selectedIndex];
    const selectedLevel = levelElement.options[levelElement.selectedIndex];
    const selectedProgramme = programmeElement.options[programmeElement.selectedIndex];
    
    // Get values and IDs
    return {
        departmentId: selectedDepartment && selectedDepartment.dataset.id ? parseInt(selectedDepartment.dataset.id) : null,
        departmentName: departmentElement.value,
        levelId: selectedLevel && selectedLevel.dataset.id ? parseInt(selectedLevel.dataset.id) : null,
        levelName: levelElement.value,
        programmeId: selectedProgramme && selectedProgramme.dataset.id ? parseInt(selectedProgramme.dataset.id) : null,
        programmeName: programmeElement.value
    };
}

// Function to set dropdown values for edit mode
function setDropdownValues(user, callback) {
    // Wait for dropdown data to load before setting selected values
    function setSelectedValues() {
        // Set department based on ID
        const departmentDropdown = document.getElementById('department');
        for (let i = 0; i < departmentDropdown.options.length; i++) {
            if (departmentDropdown.options[i].dataset.id == user.departmentId) {
                departmentDropdown.selectedIndex = i;
                break;
            }
        }
        
        // Set level based on ID
        const levelDropdown = document.getElementById('level');
        for (let i = 0; i < levelDropdown.options.length; i++) {
            if (levelDropdown.options[i].dataset.id == user.levelId) {
                levelDropdown.selectedIndex = i;
                break;
            }
        }
        
        // Filter programmes by department and then set programme
        if (user.departmentId) {
            filterProgrammesByDepartment(user.departmentId);
            
            // Set programme based on ID
            setTimeout(() => {
                const programmeDropdown = document.getElementById('programme');
                for (let i = 0; i < programmeDropdown.options.length; i++) {
                    if (programmeDropdown.options[i].dataset.id == user.programmeId) {
                        programmeDropdown.selectedIndex = i;
                        break;
                    }
                }
                
                if (callback) callback();
            }, 100); // Small delay to ensure filtering is complete
        } else if (callback) {
            callback();
        }
    }
    
    // Load dropdown data if not already loaded
    if (document.getElementById('department').options.length <= 1) {
        loadDropdownData();
        setTimeout(setSelectedValues, 500); // Wait for dropdowns to populate
    } else {
        setSelectedValues();
    }
}
