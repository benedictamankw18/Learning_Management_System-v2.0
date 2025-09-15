/**
 * ClientErrorHandler.js - Client-side error handling utilities for the Learning Management System
 */

// Global error handling configuration
window.LMS = window.LMS || {};

LMS.ErrorHandler = {
    // Debug mode flag - set to false in production
    debugMode: true,
    
    // Default error messages by error type
    defaultMessages: {
        network: "Network error occurred. Please check your connection and try again.",
        server: "Server error occurred. Please try again later.",
        validation: "Please check your input and try again.",
        authorization: "You don't have permission to perform this action.",
        notFound: "The requested resource was not found.",
        timeout: "The request timed out. Please try again.",
        unknown: "An unexpected error occurred. Please try again."
    },
    
    /**
     * Initialize error handler
     */
    init: function() {
        // Set up global AJAX error handling
        $(document).ajaxError(function(event, jqXHR, settings, error) {
            console.error("AJAX Error:", {
                status: jqXHR.status,
                statusText: jqXHR.statusText,
                responseText: jqXHR.responseText,
                error: error,
                url: settings.url
            });
            
            // Only show toast for unexpected errors
            if (jqXHR.status >= 500 || jqXHR.status === 0) {
                LMS.ErrorHandler.showErrorToast(
                    jqXHR.status === 0 ? 
                    LMS.ErrorHandler.defaultMessages.network : 
                    LMS.ErrorHandler.defaultMessages.server
                );
            }
        });
        
        // Set up global error handler
        window.onerror = function(message, source, lineno, colno, error) {
            LMS.ErrorHandler.logError("Uncaught", {
                message: message,
                source: source,
                lineno: lineno,
                colno: colno,
                error: error
            });
            
            // Don't show toast for all JS errors to avoid spamming the user
            return false; // Let the default handler run as well
        };
        
        console.log("LMS Error Handler initialized");
    },
    
    /**
     * Handle AJAX errors in a consistent way
     * @param {Object} xhr - The XMLHttpRequest object
     * @param {string} status - The error status
     * @param {string} error - The error message
     * @param {Function} callback - Optional callback to run after handling the error
     */
    handleAjaxError: function(xhr, status, error, callback) {
        let errorMessage = LMS.ErrorHandler.defaultMessages.unknown;
        let errorType = "unknown";
        
        // Determine error type and message
        if (xhr.status === 0) {
            errorType = "network";
            errorMessage = LMS.ErrorHandler.defaultMessages.network;
        } else if (xhr.status === 404) {
            errorType = "notFound";
            errorMessage = LMS.ErrorHandler.defaultMessages.notFound;
        } else if (xhr.status === 403) {
            errorType = "authorization";
            errorMessage = LMS.ErrorHandler.defaultMessages.authorization;
        } else if (xhr.status === 500) {
            errorType = "server";
            errorMessage = LMS.ErrorHandler.defaultMessages.server;
        } else if (status === "timeout") {
            errorType = "timeout";
            errorMessage = LMS.ErrorHandler.defaultMessages.timeout;
        }
        
        // Try to parse more detailed error from response
        try {
            const response = JSON.parse(xhr.responseText);
            if (response && response.message) {
                errorMessage = response.message;
            }
        } catch (e) {
            // Parsing failed, use default message
        }
        
        // Log the error
        this.logError(errorType, {
            status: xhr.status,
            statusText: xhr.statusText,
            error: error,
            response: xhr.responseText
        });
        
        // Show error message to user
        this.showErrorToast(errorMessage);
        
        // Run callback if provided
        if (typeof callback === 'function') {
            callback(errorType, errorMessage);
        }
    },
    
    /**
     * Handle WebMethod response errors
     * @param {Object} response - The response from the WebMethod
     * @param {Function} callback - Optional callback to run after handling the error
     * @returns {boolean} - Whether an error was detected and handled
     */
    handleWebMethodError: function(response, callback) {
        // Check if response indicates an error
        if (!response || !response.d || response.d.success === false) {
            const errorMessage = response && response.d && response.d.message ? 
                response.d.message : 
                this.defaultMessages.unknown;
                
            // Log error
            this.logError("webMethod", {
                response: response,
                message: errorMessage
            });
            
            // Show error message
            this.showErrorToast(errorMessage);
            
            // Run callback if provided
            if (typeof callback === 'function') {
                callback("webMethod", errorMessage);
            }
            
            return true; // Error was detected and handled
        }
        
        return false; // No error detected
    },
    
    /**
     * Log an error to the console
     * @param {string} type - The type of error
     * @param {Object} details - The error details
     */
    logError: function(type, details) {
        if (!this.debugMode) return;
        
        console.error(`[LMS Error - ${type}]`, details);
    },
    
    /**
     * Log client-side errors to the server (if needed)
     * @param {string} page - The page where the error occurred
     * @param {string} message - The error message
     * @param {string} stack - The error stack trace
     */
    logClientError: function(page, message, stack) {
        // For now, just log to console
        // In the future, this could send errors to a server endpoint
        console.error(`[Client Error on ${page}]`, {
            message: message,
            stack: stack,
            timestamp: new Date().toISOString(),
            userAgent: navigator.userAgent,
            url: window.location.href
        });
        
        // Optionally, you could send this to a server endpoint:
        // $.ajax({
        //     url: '/api/log-error',
        //     method: 'POST',
        //     data: JSON.stringify({
        //         page: page,
        //         message: message,
        //         stack: stack,
        //         timestamp: new Date().toISOString(),
        //         userAgent: navigator.userAgent,
        //         url: window.location.href
        //     }),
        //     contentType: 'application/json'
        // });
    },
    
    /**
     * Show an error toast to the user
     * @param {string} message - The error message to show
     */
    showErrorToast: function(message) {
        if (typeof showToast === 'function') {
            showToast(message, 'error');
        } else {
            alert(message);
        }
    },
    
    /**
     * Create an error handler for a specific component
     * @param {string} componentName - The name of the component
     * @returns {Object} - Component-specific error handler
     */
    createComponentHandler: function(componentName) {
        return {
            componentName: componentName,
            
            handleError: function(error, customMessage) {
                const message = customMessage || LMS.ErrorHandler.defaultMessages.unknown;
                
                LMS.ErrorHandler.logError(this.componentName, {
                    error: error,
                    message: message
                });
                
                LMS.ErrorHandler.showErrorToast(message);
            }
        };
    }
};

// Initialize on document ready
$(function() {
    LMS.ErrorHandler.init();
});
