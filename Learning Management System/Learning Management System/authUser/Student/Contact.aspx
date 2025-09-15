<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Contact" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Contact - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.contact-container {
			padding: 2rem;
			background: #f8f9fa;
			min-height: 100vh;
		}
		.page-header {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			padding: 2.2rem 2rem 2rem 2rem;
			border-radius: 16px;
			margin-bottom: 2.5rem;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13);
			position: relative;
			overflow: hidden;
		}
		.page-header .fa {
			font-size: 2.2rem;
			margin-right: 1rem;
			opacity: 0.85;
		}
		.contact-grid {
			display: grid;
			grid-template-columns: 1fr 1fr;
			gap: 2rem;
		}
		.contact-info-card, .contact-form-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.08);
			padding: 2rem 1.5rem;
		}
		.contact-info-title {
			font-size: 1.15rem;
			font-weight: 600;
			color: #2c3e50;
			margin-bottom: 1.2rem;
		}
		.contact-info-list {
			list-style: none;
			padding: 0;
			margin: 0;
		}
		.contact-info-list li {
			display: flex;
			align-items: center;
			margin-bottom: 1.1rem;
			font-size: 1.05rem;
		}
		.contact-info-list .fa {
			color: #007bff;
			font-size: 1.3rem;
			margin-right: 0.8rem;
		}
		.contact-social {
			margin-top: 1.5rem;
		}
		.contact-social a {
			color: #007bff;
			font-size: 1.4rem;
			margin-right: 1.2rem;
			transition: color 0.18s, transform 0.18s;
		}
		.contact-social a:hover {
			color: #0056b3;
			transform: scale(1.15);
		}
		.contact-form-title {
			font-size: 1.15rem;
			font-weight: 600;
			color: #2c3e50;
			margin-bottom: 1.2rem;
		}
		.form-label {
			font-weight: 500;
			color: #2c3e50;
		}
		.form-control, .form-select {
			border-radius: 8px;
			font-size: 1rem;
		}
		.btn-primary {
			background: linear-gradient(135deg, #007bff, #0056b3);
			border: none;
			border-radius: 8px;
			font-weight: 500;
			transition: background 0.18s;
		}
		.btn-primary:hover {
			background: #0056b3;
		}
		@media (max-width: 900px) {
			.contact-grid { grid-template-columns: 1fr; }
		}
		@media (max-width: 768px) {
			.contact-container { padding: 1rem; }
			.page-header { padding: 1.2rem 0.7rem; }
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="contact-container">
		<!-- Page Header -->
		<div class="page-header animate__animated animate__fadeInDown">
			<h1 class="mb-2">
				<i class="fas fa-envelope me-3"></i>
				Contact Us
			</h1>
			<p class="mb-0 opacity-75">Reach out for support, feedback, or inquiries</p>
		</div>

		<div class="contact-grid">
			<!-- Contact Info -->
			<div class="contact-info-card animate__animated animate__fadeInLeft" style="background: linear-gradient(135deg, #f5f7fa 60%, #e3e7ff 100%); border-radius: 20px; box-shadow: 0 8px 32px rgba(44,43,124,0.10); padding: 2.5rem 2rem 2rem 2rem; border-left: 6px solid #2c2b7c;">
				<div class="contact-info-title" style="font-size:1.25rem;font-weight:700;color:#2c2b7c;margin-bottom:1.5rem;letter-spacing:0.5px;">
					<i class="fas fa-info-circle me-2" style="color:#2c2b7c;"></i>Contact Information
				</div>
				<ul class="contact-info-list" style="margin-bottom:2rem;">
					<li style="margin-bottom:1.3rem;"><i class="fas fa-map-marker-alt" style="color:#2c2b7c;"></i> <span style="font-weight:500;">University of Education, Winneba, Ghana</span></li>
					<li style="margin-bottom:1.3rem;"><i class="fas fa-phone" style="color:#2c2b7c;"></i> <span style="font-weight:500;">+233 302 123 456</span></li>
					<li style="margin-bottom:1.3rem;"><i class="fas fa-envelope" style="color:#2c2b7c;"></i> <span style="font-weight:500;">support@uew.edu.gh</span></li>
					<li><i class="fas fa-clock" style="color:#2c2b7c;"></i> <span style="font-weight:500;">Mon - Fri: 8:00am - 5:00pm</span></li>
				</ul>
				<div class="contact-social" style="margin-top:1.8rem;display:flex;gap:1.2rem;">
					<a href="#" title="Facebook" style="background:#2c2b7c;color:#fff;width:38px;height:38px;display:flex;align-items:center;justify-content:center;border-radius:50%;font-size:1.3rem;transition:background 0.18s,transform 0.18s;"><i class="fab fa-facebook-f"></i></a>
					<a href="#" title="Twitter" style="background:#2c2b7c;color:#fff;width:38px;height:38px;display:flex;align-items:center;justify-content:center;border-radius:50%;font-size:1.3rem;transition:background 0.18s,transform 0.18s;"><i class="fab fa-twitter"></i></a>
					<a href="#" title="Instagram" style="background:#2c2b7c;color:#fff;width:38px;height:38px;display:flex;align-items:center;justify-content:center;border-radius:50%;font-size:1.3rem;transition:background 0.18s,transform 0.18s;"><i class="fab fa-instagram"></i></a>
					<a href="#" title="LinkedIn" style="background:#2c2b7c;color:#fff;width:38px;height:38px;display:flex;align-items:center;justify-content:center;border-radius:50%;font-size:1.3rem;transition:background 0.18s,transform 0.18s;"><i class="fab fa-linkedin-in"></i></a>
				</div>
			</div>
			<!-- Contact Form -->
			<div class="contact-form-card animate__animated animate__fadeInRight animate__delay-1s" style="background: linear-gradient(135deg, #f7faff 60%, #e3e7ff 100%); border-radius: 20px; box-shadow: 0 8px 32px rgba(44,43,124,0.10); padding: 2.5rem 2rem 2rem 2rem; border-right: 6px solid #2c2b7c;">
				<div class="contact-form-title" style="font-size:1.25rem;font-weight:700;color:#2c2b7c;margin-bottom:1.5rem;letter-spacing:0.5px;">
					<i class="fas fa-paper-plane me-2" style="color:#2c2b7c;"></i>Send a Message
				</div>
				<form id="contactForm">
					<div class="mb-3">
						<label class="form-label" style="color:#2c2b7c;font-weight:600;">Your Name</label>
						<input type="text" name="name" class="form-control" style="border-radius:10px;border:1.5px solid #bfc0e6;box-shadow:none;" placeholder="Enter your name" required />
					</div>
					<div class="mb-3">
						<label class="form-label" style="color:#2c2b7c;font-weight:600;">Your Email</label>
						<input type="email" name="email" class="form-control" style="border-radius:10px;border:1.5px solid #bfc0e6;box-shadow:none;" placeholder="Enter your email" required />
					</div>
					<div class="mb-3">
						<label class="form-label" style="color:#2c2b7c;font-weight:600;">Subject</label>
						<input type="text" name="subject" class="form-control" style="border-radius:10px;border:1.5px solid #bfc0e6;box-shadow:none;" placeholder="Subject" required />
					</div>
					<div class="mb-3">
						<label class="form-label" style="color:#2c2b7c;font-weight:600;">Message</label>
						<textarea name="message" class="form-control" rows="4" style="border-radius:10px;border:1.5px solid #bfc0e6;box-shadow:none;" placeholder="Type your message here..." required></textarea>
					</div>
					<button type="submit" class="btn btn-primary px-4 mt-2" style="background:#2c2b7c;border:none;border-radius:8px;font-weight:600;">
						<i class="fas fa-paper-plane me-2"></i>Send Message
					</button>
				</form>
				<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
				<script>
				$('#contactForm').on('submit', function(e) {
					e.preventDefault();
					var name = $(this).find('input[name="name"]').val().trim();
					var email = $(this).find('input[name="email"]').val().trim();
					var subject = $(this).find('input[name="subject"]').val().trim();
					var message = $(this).find('textarea[name="message"]').val().trim();
					if (!name || !email || !subject || !message) {
						Swal.fire('Validation Error', 'All fields are required.', 'warning');
						return;
					}
					if (!/^[\w\.-]+@[\w\.-]+\.\w{2,}$/.test(email)) {
						Swal.fire('Validation Error', 'Please enter a valid email address.', 'warning');
						return;
					}
					$.ajax({
						type: "POST",
						url: "Contact.aspx/SendContactEmail",
						contentType: "application/json; charset=utf-8",
						dataType: "json",
						data: JSON.stringify({ name: name, email: email, subject: subject, message: message }),
						success: function(res) {
							if (res.d && JSON.parse(res.d).success) {
								Swal.fire('Sent!', 'Your message has been sent. We will get back to you soon.', 'success');
								$('#contactForm')[0].reset();
							} else {
								Swal.fire('Error', (res.d && JSON.parse(res.d).message) || 'Failed to send message.', 'error');
							}
						},
						error: function() {
							Swal.fire('Error', 'Failed to send message.', 'error');
						}
					});
				});
				</script>
			</div>
		</div>
	</div>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
</asp:Content>
