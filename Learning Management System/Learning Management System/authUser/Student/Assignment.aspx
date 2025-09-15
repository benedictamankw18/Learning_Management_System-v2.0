<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Assignment.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Assignment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
		<!-- Bootstrap 5 CSS -->
			<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

	<style>
	   .cancel-btn {
		   background: #d32f2f;
		   color: #fff;
		   border: none;
		   border-radius: 6px;
		   padding: 0.45rem 1.2rem;
		   font-size: 1rem;
		   font-weight: 600;
		   cursor: pointer;
		   transition: background 0.2s;
		   margin-left: 1rem;
	   }
	   .cancel-btn:hover {
		   background: #b71c1c;
	   }
	   /* Custom file input styling */
	   #assignmentFile[type='file'] {
		   display: none;
	   }
	   .custom-file-label {
		   display: inline-block;
		   background: #f5f5f5;
		   color: #1976d2;
		   border: 2px solid #1976d2;
		   border-radius: 6px;
		   padding: 0.5rem 1.2rem;
		   font-size: 1rem;
		   font-weight: 600;
		   cursor: pointer;
		   transition: background 0.2s, color 0.2s;
		   margin-bottom: 1rem;
	   }
	   .custom-file-label:hover {
		   background: #1976d2;
		   color: #fff;
	   }
	   #assignmentFileName {
		   display: block;
		   margin-bottom: 1rem;
		   color: #333;
		   font-size: 1rem;
	   }
		.assignment-heading {
			background: linear-gradient(90deg, #1976d2 60%, #43a047 100%);
			color: #fff;
			border-radius: 14px 14px 0 0;
			padding: 2rem 2.5rem 1.5rem 2.5rem;
			margin: 2.5rem auto 0 auto;
			max-width: 800px;
			box-shadow: 0 2px 12px rgba(25, 118, 210, 0.10);
			font-size: 2rem;
			font-weight: 700;
			text-align: center;
			letter-spacing: 1px;
		}
		.assignment-submit-btn {
			background: #43a047;
			color: #fff;
			border: none;
			border-radius: 6px;
			padding: 0.45rem 1.2rem;
			font-size: 1rem;
			font-weight: 600;
			cursor: pointer;
			transition: background 0.2s;
			margin-top: 0.5rem;
		}
		.assignment-submit-btn:hover {
			background: #1976d2;
		}
		.assignment-list {
			background: #fff;
			border-radius: 0 0 14px 14px;
			box-shadow: 0 2px 12px rgba(25, 118, 210, 0.10);
			margin: 0 auto 2rem auto;
			max-width: 800px;
			padding: 2rem 2.5rem 2rem 2.5rem;
		}
		.assignment-item {
			border-bottom: 1px solid #e3e3e3;
			padding-bottom: 1.2rem;
			margin-bottom: 1.2rem;
			display: flex;
			gap: 1.2rem;
			align-items: flex-start;
		}
		.assignment-icon {
			font-size: 2.1rem;
			color: #1976d2;
			margin-top: 0.2rem;
			flex-shrink: 0;
		}
		.assignment-content {
			flex: 1;
		}
		.assignment-item:last-child {
			border-bottom: none;
			margin-bottom: 0;
		}
		.assignment-title {
			font-size: 1.6rem;
			font-weight: 600;
			color: #1976d2;
			margin-bottom: 0.3rem;
			display: flex;
			align-items: center;
			gap: 0.5rem;
		}
		.assignment-meta {
			color: #888;
			font-size: 1rem;
			margin-bottom: 0.5rem;
			display: flex;
			gap: 1.2rem;
			align-items: center;
		}
		.assignment-due {
			color: #d32f2f;
			font-weight: 600;
		}
		.assignment-status {
			font-weight: 600;
			color: #388e3c;
			display: flex;
			align-items: center;
			gap: 0.3rem;
		}
		.assignment-status.overdue {
			color: #d32f2f;
		}
		.assignment-file {
			margin-bottom: 0.7rem;
		}
		.assignment-file a {
			color: #1976d2;
			font-weight: 600;
			text-decoration: none;
		}
		.assignment-file a:hover {
			text-decoration: underline;
		}
		.assignment-desc {
			color: #333;
			font-size: 1.08rem;
			margin-bottom: 0.7rem;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div id="submitModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.4);z-index:1000;align-items:center;justify-content:center;">
	<div style="background:#fff;padding:2rem 2.5rem;border-radius:12px;max-width:400px;width:90vw;box-shadow:0 2px 12px rgba(25,118,210,0.15);position:relative;">
		<h2 style="font-size:1.3rem;margin-bottom:1.2rem;">Submit Assignment</h2>
		<form id="assignmentUploadForm" enctype="multipart/form-data">
			<input type="hidden" id="modalAssignmentId" name="assignmentId" />
			   <label for="assignmentFile" class="custom-file-label"><i class="fa-solid fa-upload"></i> Choose file</label>
			   <input type="file" id="assignmentFile" name="file" accept=".pdf,.doc,.docx" required />
			   <span id="assignmentFileName"></span>
			<br />
			<button type="submit" class="assignment-submit-btn">Upload</button>
			   <button type="button" id="closeModalBtn" class="cancel-btn">Cancel</button>
		</form>
		<div id="uploadStatus" style="margin-top:1rem;font-size:1rem;"></div>
	</div>
</div>
<div class="assignment-heading" id="courseHeading">Loading Course...</div>
<%-- <div class="assignment-heading" style="font-size:1.4rem;padding:1.2rem 2.5rem 1.2rem 2.5rem;margin-top:0;"></div> --%>
<div class="assignment-list" id="assignmentListContainer">
	<!-- Assignment items will be loaded here -->
</div>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<!-- Bootstrap 5 JS Bundle (includes Popper) -->
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		// Example: get courseId from query string or set statically for demo
		var courseId = new URLSearchParams(window.location.search).get('courseId') || '1';
		$(document).ready(function() {
			// AJAX file upload for assignment submission
			$('#assignmentUploadForm').on('submit', function(e) {
				e.preventDefault();
				var formData = new FormData(this);
				$('#uploadStatus').text('Uploading...');
				$.ajax({
					url: 'AssignmentUploadHandler.ashx',
					type: 'POST',
					data: formData,
					contentType: false,
					processData: false,
					success: function(res) {
						if (typeof res === 'string') {
							try { res = JSON.parse(res); } catch (e) { res = {}; }
						}
						$('#uploadStatus').text(res && res.success ? 'Upload successful!' : (res && res.error ? res.error : 'Upload failed.'));
						if (res && res.success) {
							// Disable the submit button and show submitted message for the relevant assignment
							var assignmentId = $('#modalAssignmentId').val();
							var btn = $('.assignment-submit-btn[data-assignment-id="' + assignmentId + '"]');
							btn.prop('disabled', true).css({'opacity':0.6, 'cursor':'not-allowed'}).text('Submitted');
							if (btn.next('.submitted-msg').length === 0) {
								btn.after('<div class="submitted-msg" style="color:#388e3c;font-weight:600;margin-top:0.5rem;">You have already submitted.</div>');
							}
							setTimeout(function() { $('#submitModal').hide(); }, 1200);
						}
					},
					error: function(xhr) {
						var msg = 'Upload failed.';
						if (xhr && xhr.responseText) {
							try {
								var resp = JSON.parse(xhr.responseText);
								if (resp && resp.error) msg += ' ' + resp.error;
							} catch (e) {
								msg += ' ' + xhr.responseText;
							}
						}
						$('#uploadStatus').text(msg);
					}
				});
			});
			// Show selected file name
			$('#assignmentFile').on('change', function() {
				var fileName = $(this).val().split('\\').pop();
				$('#assignmentFileName').text(fileName ? 'Selected: ' + fileName : '');
			});
			// Show modal when submit button is clicked
			$(document).on('click', '.assignment-submit-btn', function() {
				var assignmentId = $(this).data('assignment-id');
				if (assignmentId) {
					$('#modalAssignmentId').val(assignmentId);
					$('#assignmentFile').val('');
					$('#uploadStatus').text('');
					$('#submitModal').css('display', 'flex');
				}
			});
			// Hide modal when cancel is clicked
			$('#closeModalBtn').on('click', function() {
				$('#submitModal').hide();
			});
			// Load course name
			$.ajax({
				type: 'POST',
				url: 'Assignment.aspx/GetCourseName',
				data: JSON.stringify({ courseId: courseId }),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function(res) {
					var courseName = res.d ? res.d : 'Course';
					$('#courseHeading').text(courseName + ' Assignments');
				},
				error: function() {
					$('#courseHeading').text('Assignments');
				}
			});
			// Load assignments
			$.ajax({
				type: 'POST',
				url: 'Assignment.aspx/GetAssignments',
				data: JSON.stringify({ courseId: courseId }),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function(res) {
					var assignments = res.d ? (typeof res.d === 'string' ? JSON.parse(res.d) : res.d) : [];
					var html = '';
					   if (assignments.length === 0) {
						   html = '<div>No assignments found for this course.</div>';
					   } else {
						   assignments.forEach(function(a) {
							   html += '<div class="assignment-item">';
							   html += '<div class="assignment-icon"><i class="fa-solid fa-file-lines"></i></div>';
							   html += '<div class="assignment-content">';
							   html += '<div class="assignment-title">' + a.Title + '</div>';
							   html += '<div class="assignment-meta">';
							   html += '<span class="assignment-due"><i class="fa-regular fa-calendar"></i> ' + (a.DueDate || '-') + '</span>';
							   html += '<span class="assignment-status' + (a.Status === 'Overdue' ? ' overdue' : '') + '"><i class="fa-solid fa-circle-' + (a.Status === 'Overdue' ? 'xmark' : 'check') + '"></i> ' + a.Status + '</span>';
							   html += '</div>';
							   if (a.FilePath) {
								   html += '<div class="assignment-file"><i class="fa-solid fa-file-pdf"></i> <a href="' + a.FilePath + '" target="_blank">Download PDF</a></div>';
							   }
							   if (a.Description) {
								   html += '<div class="assignment-desc">' + a.Description + '</div>';
							   }
							   if (a.AssignmentID) {
								   var isClosed = a.Status && a.Status.toLowerCase() === 'closed';
								   var isSubmitted = a.HasSubmitted === true || a.HasSubmitted === 'true';
								   var dueDate = a.DueDate ? new Date(a.DueDate) : null;
								   var now = new Date();
								   var isDue = false;
								   if (dueDate && dueDate.setHours(23,59,59,999) < now) {
									   isDue = true;
								   }
								   if (isClosed || isDue) {
									   html += '<button class="assignment-submit-btn" disabled style="opacity:0.6;cursor:not-allowed;">Closed</button>';
									   html += '<div style="color:#d32f2f;font-weight:600;margin-top:0.5rem;">This assignment is closed.</div>';
								   } else if (isSubmitted) {
									   html += '<button class="assignment-submit-btn" disabled style="opacity:0.6;cursor:not-allowed;">Submitted</button>';
									   html += '<div style="color:#388e3c;font-weight:600;margin-top:0.5rem;">You have already submitted.</div>';
								   } else {
									   html += '<button class="assignment-submit-btn" data-assignment-id="' + a.AssignmentID + '"><i class="fa-solid fa-upload"></i> Submit Assignment</button>';
								   }
							   }
							   html += '</div>';
							   html += '</div>';
						   });
					   }
					$('#assignmentListContainer').html(html);
				}
			});
		});
	</script>
</asp:Content>
