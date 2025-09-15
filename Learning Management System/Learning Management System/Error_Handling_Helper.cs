using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace Learning_Management_System
{
    /// <summary>
    /// Helper class for handling errors in the application
    /// </summary>
    public static class ErrorHandler
    {
        private static bool _isDebugMode = true; // Set to false in production
        
        /// <summary>
        /// Logs an exception and returns a formatted error object
        /// </summary>
        public static object LogAndReturnError(Exception ex, string methodName)
        {
            // Log the error
            Debug.WriteLine($"[ERROR] {DateTime.Now} - Error in {methodName}: {ex.Message}");
            Debug.WriteLine($"[ERROR] Stack trace: {ex.StackTrace}");
            
            if (ex.InnerException != null)
            {
                Debug.WriteLine($"[ERROR] Inner exception: {ex.InnerException.Message}");
                Debug.WriteLine($"[ERROR] Inner stack trace: {ex.InnerException.StackTrace}");
            }
            
            // Return a standardized error response
            var errorResponse = new { 
                success = false, 
                message = $"An error occurred while processing your request.",
                errorCode = GenerateErrorCode(methodName),
                errorDetails = _isDebugMode ? ex.ToString() : null
            };
            
            return errorResponse;
        }
        
        /// <summary>
        /// Logs the request details for debugging purposes
        /// </summary>
        public static void LogRequest(string methodName, Dictionary<string, object> parameters)
        {
            if (!_isDebugMode) return;
            
            Debug.WriteLine($"[REQUEST] {DateTime.Now} - Method: {methodName}");
            
            if (parameters != null && parameters.Count > 0)
            {
                Debug.WriteLine("[REQUEST] Parameters:");
                foreach (var param in parameters)
                {
                    string value = param.Value?.ToString() ?? "null";
                    if (value.Length > 100) value = value.Substring(0, 100) + "...";
                    Debug.WriteLine($"[REQUEST]   {param.Key}: {value}");
                }
            }
        }
        
        /// <summary>
        /// Logs the response details for debugging purposes
        /// </summary>
        public static void LogResponse(string methodName, object response)
        {
            if (!_isDebugMode) return;
            
            Debug.WriteLine($"[RESPONSE] {DateTime.Now} - Method: {methodName}");
            
            if (response != null)
            {
                try
                {
                    var serializer = new JavaScriptSerializer();
                    string json = serializer.Serialize(response);
                    if (json.Length > 200) json = json.Substring(0, 200) + "...";
                    Debug.WriteLine($"[RESPONSE] Result: {json}");
                }
                catch
                {
                    Debug.WriteLine($"[RESPONSE] Result: {response.ToString()}");
                }
            }
        }
        
        /// <summary>
        /// Generates a unique error code for tracking
        /// </summary>
        private static string GenerateErrorCode(string methodName)
        {
            string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
            string methodCode = methodName.GetHashCode().ToString("X8");
            return $"ERR-{timestamp}-{methodCode}";
        }
    }
}
