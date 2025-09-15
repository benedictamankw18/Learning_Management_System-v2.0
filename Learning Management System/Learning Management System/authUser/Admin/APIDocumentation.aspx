<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="APIDocumentation.aspx.cs" Inherits="Learning_Management_System.authUser.Admin.APIDocumentation" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User API Documentation</title>
    <link href="../../Assest/css/bootstrap-5.2.3-dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="../../Assest/css/bootstrap-5.2.3-dist/js/bootstrap.bundle.min.js"></script>
    <link href="../../Assest/fontawesome-free-6.7.2-web/css/all.min.css" rel="stylesheet" />
    <link href="../../Assest/css/AdminMaster.css" rel="stylesheet" />
    <style>
        body {
            padding: 20px;
        }
        .endpoint {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .method {
            font-weight: bold;
            color: #0d6efd;
        }
        .url {
            font-family: monospace;
            background-color: #e9ecef;
            padding: 5px 10px;
            border-radius: 3px;
            margin-left: 10px;
        }
        .param-table {
            margin-top: 15px;
        }
        .code-block {
            background-color: #272822;
            color: #f8f8f2;
            border-radius: 5px;
            padding: 15px;
            font-family: monospace;
            overflow-x: auto;
        }
        .response-container {
            margin-top: 15px;
        }
        .nav-pills .nav-link.active {
            background-color: #2c2b7c;
        }
        .btn-try {
            background-color: #2c2b7c;
            color: white;
        }
        .btn-try:hover {
            background-color: #1f1e5a;
            color: white;
        }
        h1, h2, h3, h4 {
            color: #2c2b7c;
        }
        pre {
            margin: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row mb-4">
                <div class="col">
                    <h1 class="display-5">
                        <i class="fas fa-code"></i> User API Documentation
                    </h1>
                    <p class="lead">
                        This API provides access to user data with entity IDs.
                    </p>
                    <div class="d-flex mb-3">
                        <a href="Dashboard.aspx" class="btn btn-secondary me-2">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <div class="sticky-top pt-4">
                        <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                            <button class="nav-link active" id="overview-tab" data-bs-toggle="pill" data-bs-target="#overview" type="button" role="tab" aria-controls="overview" aria-selected="true">Overview</button>
                            <button class="nav-link" id="all-users-tab" data-bs-toggle="pill" data-bs-target="#all-users" type="button" role="tab" aria-controls="all-users" aria-selected="false">Get All Users</button>
                            <button class="nav-link" id="user-by-id-tab" data-bs-toggle="pill" data-bs-target="#user-by-id" type="button" role="tab" aria-controls="user-by-id" aria-selected="false">Get User By ID</button>
                            <button class="nav-link" id="search-users-tab" data-bs-toggle="pill" data-bs-target="#search-users" type="button" role="tab" aria-controls="search-users" aria-selected="false">Search Users</button>
                            <button class="nav-link" id="filtering-tab" data-bs-toggle="pill" data-bs-target="#filtering" type="button" role="tab" aria-controls="filtering" aria-selected="false">Filtering</button>
                            <button class="nav-link" id="response-formats-tab" data-bs-toggle="pill" data-bs-target="#response-formats" type="button" role="tab" aria-controls="response-formats" aria-selected="false">Response Formats</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-9">
                    <div class="tab-content" id="v-pills-tabContent">
                        <!-- Overview -->
                        <div class="tab-pane fade show active" id="overview" role="tabpanel" aria-labelledby="overview-tab">
                            <div class="card">
                                <div class="card-body">
                                    <h2 class="card-title">Overview</h2>
                                    <p>
                                        The User API provides a RESTful interface to access user data including entity IDs.
                                        This API is designed to be easy to use and provides data in both JSON and XML formats.
                                    </p>
                                    <h3>Base URL</h3>
                                    <p>
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx</span>
                                    </p>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> Note: The legacy endpoint <code>/authUser/Admin/UserAPI.ashx</code> is still supported but is being replaced with the more efficient SimpleUserAPI handler.
                                    </div>
                                    <h3>Authentication</h3>
                                    <p>
                                        Authentication is handled by the web application session. You must be logged in with appropriate permissions to access this API.
                                    </p>
                                    <h3>Common Parameters</h3>
                                    <table class="table param-table">
                                        <thead>
                                            <tr>
                                                <th>Parameter</th>
                                                <th>Description</th>
                                                <th>Required</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>action</code></td>
                                                <td>The action to perform. Valid values: <code>all</code>, <code>byid</code>, <code>search</code></td>
                                                <td>Yes</td>
                                                <td><code>action=all</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>format</code></td>
                                                <td>Response format. Valid values: <code>json</code>, <code>xml</code></td>
                                                <td>No (defaults to <code>json</code>)</td>
                                                <td><code>format=xml</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>fields</code></td>
                                                <td>Comma-separated list of fields to include in the response</td>
                                                <td>No (defaults to all fields)</td>
                                                <td><code>fields=id,fullName,email</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>type</code></td>
                                                <td>Filter by user type</td>
                                                <td>No</td>
                                                <td><code>type=student</code></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <h3>Available Fields</h3>
                                    <table class="table param-table">
                                        <thead>
                                            <tr>
                                                <th>Field</th>
                                                <th>Description</th>
                                                <th>Data Type</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>id</code> or <code>userId</code></td>
                                                <td>Unique identifier for the user</td>
                                                <td>Integer</td>
                                            </tr>
                                            <tr>
                                                <td><code>fullName</code></td>
                                                <td>Full name of the user</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>email</code></td>
                                                <td>Email address of the user</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>phone</code></td>
                                                <td>Phone number of the user</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>userType</code></td>
                                                <td>Type of user (admin, teacher, student)</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>department</code></td>
                                                <td>Department the user belongs to</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>level</code></td>
                                                <td>Academic level for students</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>programme</code></td>
                                                <td>Programme the user is enrolled in</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>profilePic</code></td>
                                                <td>URL to the user's profile picture</td>
                                                <td>String (URL)</td>
                                            </tr>
                                            <tr>
                                                <td><code>employeeId</code></td>
                                                <td>Employee ID for staff members</td>
                                                <td>String</td>
                                            </tr>
                                            <tr>
                                                <td><code>createdDate</code></td>
                                                <td>Date when the user was created</td>
                                                <td>String (YYYY-MM-DD)</td>
                                            </tr>
                                            <tr>
                                                <td><code>isActive</code></td>
                                                <td>Whether the user account is active</td>
                                                <td>Boolean</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Get All Users -->
                        <div class="tab-pane fade" id="all-users" role="tabpanel" aria-labelledby="all-users-tab">
                            <div class="card">
                                <div class="card-body">
                                    <h2 class="card-title">Get All Users</h2>
                                    <div class="endpoint">
                                        <span class="method">GET</span>
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=all</span>
                                    </div>
                                    <p>Returns a list of all users in the system.</p>
                                    <h3>Parameters</h3>
                                    <table class="table param-table">
                                        <thead>
                                            <tr>
                                                <th>Parameter</th>
                                                <th>Description</th>
                                                <th>Required</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>action</code></td>
                                                <td>Must be set to <code>all</code></td>
                                                <td>Yes</td>
                                                <td><code>action=all</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>type</code></td>
                                                <td>Filter by user type (admin, student, teacher)</td>
                                                <td>No</td>
                                                <td><code>type=student</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>fields</code></td>
                                                <td>Comma-separated list of fields to include</td>
                                                <td>No</td>
                                                <td><code>fields=id,fullName,email</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>format</code></td>
                                                <td>Response format (json, xml)</td>
                                                <td>No</td>
                                                <td><code>format=json</code></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <h3>Example Request</h3>
                                    <div class="input-group mb-3">
                                        <input type="text" id="getAllUsersUrl" class="form-control" value="/authUser/Admin/SimpleUserAPI.ashx?action=all" readonly />
                                        <button class="btn btn-try" type="button" onclick="tryApi('getAllUsersUrl', 'getAllUsersResponse')">Try It</button>
                                    </div>
                                    <h3>Example Response</h3>
                                    <div class="response-container">
                                        <div class="code-block">
                                            <pre id="getAllUsersResponse">{
  "success": true,
  "data": [
    {
      "id": 1001,
      "fullName": "John Doe",
      "email": "john.doe@example.com",
      "phone": "+233 20 123 4567",
      "userType": "admin",
      "department": "IT Department",
      "level": "",
      "programme": "Administration",
      "profilePic": "/authUser/Admin/ProfileImageHandler.ashx?UserID=1001&t=637860982345123456",
      "employeeId": "ADMIN001",
      "createdDate": "2023-01-15",
      "isActive": true
    },
    // More users...
  ]
}</pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Get User By ID -->
                        <div class="tab-pane fade" id="user-by-id" role="tabpanel" aria-labelledby="user-by-id-tab">
                            <div class="card">
                                <div class="card-body">
                                    <h2 class="card-title">Get User By ID</h2>
                                    <div class="endpoint">
                                        <span class="method">GET</span>
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=byid&id={userId}</span>
                                    </div>
                                    <p>Returns details for a specific user by ID.</p>
                                    <h3>Parameters</h3>
                                    <table class="table param-table">
                                        <thead>
                                            <tr>
                                                <th>Parameter</th>
                                                <th>Description</th>
                                                <th>Required</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>action</code></td>
                                                <td>Must be set to <code>byid</code></td>
                                                <td>Yes</td>
                                                <td><code>action=byid</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>id</code></td>
                                                <td>The user ID to retrieve</td>
                                                <td>Yes</td>
                                                <td><code>id=1001</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>fields</code></td>
                                                <td>Comma-separated list of fields to include</td>
                                                <td>No</td>
                                                <td><code>fields=id,fullName,email</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>format</code></td>
                                                <td>Response format (json, xml)</td>
                                                <td>No</td>
                                                <td><code>format=json</code></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <h3>Example Request</h3>
                                    <div class="input-group mb-3">
                                        <input type="text" id="getUserByIdUrl" class="form-control" value="/authUser/Admin/SimpleUserAPI.ashx?action=byid&id=1001" />
                                        <button class="btn btn-try" type="button" onclick="tryApi('getUserByIdUrl', 'getUserByIdResponse')">Try It</button>
                                    </div>
                                    <h3>Example Response</h3>
                                    <div class="response-container">
                                        <div class="code-block">
                                            <pre id="getUserByIdResponse">{
  "success": true,
  "data": {
    "id": 1001,
    "fullName": "John Doe",
    "email": "john.doe@example.com",
    "phone": "+233 20 123 4567",
    "userType": "admin",
    "department": "IT Department",
    "level": "",
    "programme": "Administration",
    "profilePic": "/authUser/Admin/ProfileImageHandler.ashx?UserID=1001&t=637860982345123456",
    "employeeId": "ADMIN001",
    "createdDate": "2023-01-15",
    "isActive": true
  }
}</pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Search Users -->
                        <div class="tab-pane fade" id="search-users" role="tabpanel" aria-labelledby="search-users-tab">
                            <div class="card">
                                <div class="card-body">
                                    <h2 class="card-title">Search Users</h2>
                                    <div class="endpoint">
                                        <span class="method">GET</span>
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=search&q={searchTerm}</span>
                                    </div>
                                    <p>Searches for users based on the provided search term.</p>
                                    <h3>Parameters</h3>
                                    <table class="table param-table">
                                        <thead>
                                            <tr>
                                                <th>Parameter</th>
                                                <th>Description</th>
                                                <th>Required</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>action</code></td>
                                                <td>Must be set to <code>search</code></td>
                                                <td>Yes</td>
                                                <td><code>action=search</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>q</code></td>
                                                <td>The search term</td>
                                                <td>Yes</td>
                                                <td><code>q=john</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>type</code></td>
                                                <td>Filter by user type (admin, student, teacher)</td>
                                                <td>No</td>
                                                <td><code>type=student</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>fields</code></td>
                                                <td>Comma-separated list of fields to include</td>
                                                <td>No</td>
                                                <td><code>fields=id,fullName,email</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>format</code></td>
                                                <td>Response format (json, xml)</td>
                                                <td>No</td>
                                                <td><code>format=json</code></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <h3>Example Request</h3>
                                    <div class="input-group mb-3">
                                        <input type="text" id="searchUsersUrl" class="form-control" value="/authUser/Admin/SimpleUserAPI.ashx?action=search&q=john" />
                                        <button class="btn btn-try" type="button" onclick="tryApi('searchUsersUrl', 'searchUsersResponse')">Try It</button>
                                    </div>
                                    <h3>Example Response</h3>
                                    <div class="response-container">
                                        <div class="code-block">
                                            <pre id="searchUsersResponse">{
  "success": true,
  "data": [
    {
      "id": 1001,
      "fullName": "John Doe",
      "email": "john.doe@example.com",
      "phone": "+233 20 123 4567",
      "userType": "admin",
      "department": "IT Department",
      "level": "",
      "programme": "Administration",
      "profilePic": "/authUser/Admin/ProfileImageHandler.ashx?UserID=1001&t=637860982345123456",
      "employeeId": "ADMIN001",
      "createdDate": "2023-01-15",
      "isActive": true
    },
    // More matching users...
  ]
}</pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Filtering -->
                        <div class="tab-pane fade" id="filtering" role="tabpanel" aria-labelledby="filtering-tab">
                            <div class="card">
                                <div class="card-body">
                                    <h2 class="card-title">Filtering Options</h2>
                                    <p>
                                        The API provides several ways to filter and customize the response:
                                    </p>
                                    <h3>Field Selection</h3>
                                    <p>
                                        You can specify which fields to include in the response using the <code>fields</code> parameter.
                                        This is useful to reduce the payload size when you only need specific fields.
                                    </p>
                                    <div class="endpoint">
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=all&fields=id,fullName,email</span>
                                    </div>
                                    <h3>User Type Filtering</h3>
                                    <p>
                                        You can filter users by their type using the <code>type</code> parameter.
                                    </p>
                                    <div class="endpoint">
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=all&type=student</span>
                                    </div>
                                    <h3>Combined Filtering</h3>
                                    <p>
                                        You can combine different filters to narrow down the results.
                                    </p>
                                    <div class="endpoint">
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=search&q=john&type=admin&fields=id,fullName,email</span>
                                    </div>
                                    <h3>Example Request</h3>
                                    <div class="input-group mb-3">
                                        <input type="text" id="filteringUrl" class="form-control" value="/authUser/Admin/SimpleUserAPI.ashx?action=all&type=student&fields=id,fullName,email" />
                                        <button class="btn btn-try" type="button" onclick="tryApi('filteringUrl', 'filteringResponse')">Try It</button>
                                    </div>
                                    <h3>Example Response</h3>
                                    <div class="response-container">
                                        <div class="code-block">
                                            <pre id="filteringResponse">{
  "success": true,
  "data": [
    {
      "id": 1002,
      "fullName": "Jane Smith",
      "email": "jane.smith@example.com"
    },
    {
      "id": 1004,
      "fullName": "Michael Johnson",
      "email": "michael.johnson@example.com"
    },
    // More student users...
  ]
}</pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Response Formats -->
                        <div class="tab-pane fade" id="response-formats" role="tabpanel" aria-labelledby="response-formats-tab">
                            <div class="card">
                                <div class="card-body">
                                    <h2 class="card-title">Response Formats</h2>
                                    <p>
                                        The API supports both JSON and XML response formats. You can specify the format using the <code>format</code> parameter.
                                    </p>
                                    <h3>JSON Format (Default)</h3>
                                    <div class="endpoint">
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=byid&id=1001&format=json</span>
                                    </div>
                                    <div class="code-block">
                                        <pre>{
  "success": true,
  "data": {
    "id": 1001,
    "fullName": "John Doe",
    "email": "john.doe@example.com",
    // Other fields...
  }
}</pre>
                                    </div>
                                    <h3>XML Format</h3>
                                    <div class="endpoint">
                                        <span class="url">/authUser/Admin/SimpleUserAPI.ashx?action=byid&id=1001&format=xml</span>
                                    </div>
                                    <div class="code-block">
                                        <pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;response&gt;
  &lt;success&gt;true&lt;/success&gt;
  &lt;data&gt;
    &lt;user&gt;
      &lt;id&gt;1001&lt;/id&gt;
      &lt;fullName&gt;John Doe&lt;/fullName&gt;
      &lt;email&gt;john.doe@example.com&lt;/email&gt;
      &lt;!-- Other fields... --&gt;
    &lt;/user&gt;
  &lt;/data&gt;
&lt;/response&gt;</pre>
                                    </div>
                                    <h3>Example Request</h3>
                                    <div class="input-group mb-3">
                                        <input type="text" id="xmlFormatUrl" class="form-control" value="/authUser/Admin/SimpleUserAPI.ashx?action=byid&id=1001&format=xml" />
                                        <button class="btn btn-try" type="button" onclick="tryApi('xmlFormatUrl', 'xmlFormatResponse')">Try It</button>
                                    </div>
                                    <h3>Example Response</h3>
                                    <div class="response-container">
                                        <div class="code-block">
                                            <pre id="xmlFormatResponse">&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;response&gt;
  &lt;success&gt;true&lt;/success&gt;
  &lt;data&gt;
    &lt;user&gt;
      &lt;id&gt;1001&lt;/id&gt;
      &lt;fullName&gt;John Doe&lt;/fullName&gt;
      &lt;email&gt;john.doe@example.com&lt;/email&gt;
      &lt;phone&gt;+233 20 123 4567&lt;/phone&gt;
      &lt;userType&gt;admin&lt;/userType&gt;
      &lt;department&gt;IT Department&lt;/department&gt;
      &lt;level&gt;&lt;/level&gt;
      &lt;programme&gt;Administration&lt;/programme&gt;
      &lt;profilePic&gt;/authUser/Admin/ProfileImageHandler.ashx?UserID=1001&amp;t=637860982345123456&lt;/profilePic&gt;
      &lt;employeeId&gt;ADMIN001&lt;/employeeId&gt;
      &lt;createdDate&gt;2023-01-15&lt;/createdDate&gt;
      &lt;isActive&gt;True&lt;/isActive&gt;
    &lt;/user&gt;
  &lt;/data&gt;
&lt;/response&gt;</pre>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function tryApi(inputId, outputId) {
            const url = document.getElementById(inputId).value;
            const outputElement = document.getElementById(outputId);
            
            outputElement.innerHTML = "Loading...";
            
            fetch(url)
                .then(response => {
                    if (url.includes('format=xml')) {
                        return response.text();
                    } else {
                        return response.json().then(data => JSON.stringify(data, null, 2));
                    }
                })
                .then(data => {
                    outputElement.innerHTML = data;
                })
                .catch(error => {
                    outputElement.innerHTML = `Error: ${error.message}`;
                });
        }
    </script>
</body>
</html>
