<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Schedule" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Schedule - Learning Management System</title>
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body {
			font-family: 'Roboto', sans-serif;
			background-color: #f8f9fa;
		}
		.schedule-container {
			padding: 20px;
			max-width: 1200px;
			margin: 0 auto;
		}
		.page-header {
			background: linear-gradient(135deg, #007bff, #0056b3);
			color: white;
			padding: 30px;
			border-radius: 15px;
			margin-bottom: 30px;
			box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
		}
		.breadcrumb-nav {
			background: white;
			padding: 15px 20px;
			border-radius: 10px;
			margin-bottom: 20px;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		}
		.breadcrumb-nav .breadcrumb {
			margin: 0;
		}
		.breadcrumb-nav .breadcrumb-item a {
			color: #007bff;
			text-decoration: none;
			font-weight: 500;
		}
		.breadcrumb-nav .breadcrumb-item a:hover {
			text-decoration: underline;
		}
		.schedule-card {
			background: white;
			border-radius: 15px;
			box-shadow: 0 5px 15px rgba(0, 0, 0, 0.09);
			padding: 28px 24px 20px 24px;
			margin-bottom: 30px;
			transition: all 0.3s cubic-bezier(.25,.8,.25,1);
			position: relative;
			overflow: hidden;
		}
		.schedule-card h4 {
			color: #2c3e50;
			font-weight: 600;
			margin-bottom: 18px;
		}
		.calendar-table {
			width: 100%;
			border-collapse: separate;
			border-spacing: 0 8px;
		}
		.calendar-table th {
			background: #f8f9fa;
			color: #1976d2;
			font-weight: 600;
			padding: 12px 0;
			border: none;
			text-align: center;
		}
		.calendar-table td {
			background: #fff;
			border-radius: 8px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.04);
			padding: 18px 10px;
			text-align: center;
			vertical-align: middle;
			font-size: 1.05rem;
			color: #333;
			transition: background 0.2s;
		}
		.calendar-table td.today {
			background: #e3f2fd;
			color: #1976d2;
			font-weight: 700;
			border: 2px solid #1976d2;
		}
		.calendar-table td.event {
			background: #e8f5e8;
			color: #2e7d32;
			font-weight: 600;
			border: 2px solid #2e7d32;
		}
		.event-badge {
			display: inline-block;
			background: #1976d2;
			color: #fff;
			border-radius: 12px;
			padding: 2px 10px;
			font-size: 12px;
			margin-top: 6px;
		}
		.event-list {
			margin-top: 18px;
		}
		.event-item {
			background: #f8f9fa;
			border-radius: 10px;
			padding: 14px 18px;
			margin-bottom: 12px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.04);
			display: flex;
			align-items: center;
			gap: 16px;
			transition: box-shadow 0.2s;
		}
		.event-item:hover {
			box-shadow: 0 6px 18px rgba(0,123,255,0.13);
		}
		.event-icon {
			width: 38px;
			height: 38px;
			background: linear-gradient(135deg, #007bff, #0056b3);
			border-radius: 10px;
			display: flex;
			align-items: center;
			justify-content: center;
			color: #fff;
			font-size: 18px;
		}
		.event-details {
			flex: 1;
		}
		.event-title {
			font-weight: 600;
			color: #2c3e50;
			margin-bottom: 2px;
		}
		.event-meta {
			color: #888;
			font-size: 13px;
		}
		.no-events {
			text-align: center;
			color: #888;
			padding: 30px 0 10px 0;
			font-size: 1.1rem;
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="schedule-container animate__animated animate__fadeIn">
		<!-- Page Header -->
		<div class="page-header mb-4 animate__animated animate__fadeInDown">
			<h1 class="mb-2">
				<i class="fas fa-calendar-alt me-3"></i>
				My Schedule
			</h1>
			<p class="mb-0 opacity-75">View your upcoming classes, assignments, and events</p>
		</div>
		<!-- Breadcrumb Navigation -->
		<div class="breadcrumb-nav animate__animated animate__fadeInUp animate__delay-1s">
			<nav aria-label="breadcrumb">
				<ol class="breadcrumb">
					<li class="breadcrumb-item active">Schedule</li>
				</ol>
			</nav>
		</div>
		<!-- Schedule Card -->
		<div class="schedule-card animate__animated animate__fadeInUp animate__delay-2s">
			<h4><i class="fas fa-calendar-week me-2"></i>Weekly Calendar</h4>
			<div class="table-responsive">
				<table class="calendar-table w-100">
					<thead>
						<tr>
							<th>Mon</th>
							<th>Tue</th>
							<th>Wed</th>
							<th>Thu</th>
							<th>Fri</th>
							<th>Sat</th>
							<th>Sun</th>
						</tr>
					</thead>
					<tbody id="calendarBody">
						<!-- Calendar will be loaded here -->
					</tbody>
				</table>
			</div>
		</div>
		<!-- Event List -->
		<div class="schedule-card animate__animated animate__fadeInUp animate__delay-3s">
			<h4><i class="fas fa-list-ul me-2"></i>Upcoming Events</h4>
			<div class="event-list" id="eventList">
				<!-- Events will be loaded here -->
			</div>
			<div class="no-events" id="noEvents" style="display:none;">
				<i class="fas fa-calendar-times fa-2x mb-2 d-block"></i>
				No upcoming events found.
			</div>
		</div>
	</div>
	<!-- Bootstrap JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		// Fetch real student events from backend
		let events = [];
		document.addEventListener('DOMContentLoaded', function() {
			$.ajax({
				type: "POST",
				url: "Schedule.aspx/GetStudentEvents",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(res) {
					events = res.d ? JSON.parse(res.d) : res;
					renderCalendar();
					renderEvents();
				},
				error: function() {
					events = [];
					renderCalendar();
					renderEvents();
				}
			});
		});
		function renderCalendar() {
			const today = new Date();
			const startOfWeek = new Date(today);
			startOfWeek.setDate(today.getDate() - today.getDay() + 1); // Monday
			const calendarBody = document.getElementById('calendarBody');
			let row = '<tr>';
			for (let i = 0; i < 7; i++) {
				const day = new Date(startOfWeek);
				day.setDate(startOfWeek.getDate() + i);
				const dayStr = day.toISOString().slice(0, 10);
				const isToday = dayStr === today.toISOString().slice(0, 10);
				const hasEvent = events.some(e => e.date === dayStr);
				let tdClass = '';
				if (isToday) tdClass = 'today';
				else if (hasEvent) tdClass = 'event';
				row += `<td class="${tdClass}">${day.getDate()}${hasEvent ? '<div class=\'event-badge\'>Event</div>' : ''}</td>`;
			}
			row += '</tr>';
			calendarBody.innerHTML = row;
		}
		function renderEvents() {
			const eventList = document.getElementById('eventList');
			const noEvents = document.getElementById('noEvents');
			eventList.innerHTML = '';
			if (!events || events.length === 0) {
				noEvents.style.display = 'block';
				return;
			}
			noEvents.style.display = 'none';
			// Sort by date ascending
			events.sort((a, b) => new Date(a.date) - new Date(b.date));
			events.forEach(event => {
				const item = document.createElement('div');
				item.className = 'event-item animate__animated animate__fadeInUp';
				item.innerHTML = `
					<div class="event-icon"><i class="fas ${event.icon || 'fa-calendar'}"></i></div>
					<div class="event-details">
						<div class="event-title">${event.title}</div>
						<div class="event-meta">
							<i class="fas fa-calendar-alt me-1"></i> ${event.date} &nbsp; 
							<i class="fas fa-clock me-1"></i> ${event.time}
							${event.location ? `&nbsp; <i class='fas fa-map-marker-alt me-1'></i> ${event.location}` : ''}
						</div>
					</div>
				`;
				eventList.appendChild(item);
			});
		}
	</script>
</asp:Content>
