<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Teacher/Teacher.Master" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="Learning_Management_System.authUser.Teacher.Schedule" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
body {
  background: #f4f6fb;
  font-family: 'Roboto', sans-serif;
}
.schedule-container {
  width: 100%;
  margin: 32px auto;
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 6px 32px rgba(44,43,124,0.10);
  padding: 18px 18px 24px 18px;
}
h2, h3 {
  color: #2c2b7c;
  font-weight: 700;
  letter-spacing: 0.5px;
}
#scheduleForm, #editScheduleForm {
  background: #f2f3ff;
  border-radius: 12px;
  padding: 16px 12px 12px 12px;
  margin-bottom: 28px;
  box-shadow: 0 2px 10px rgba(44,43,124,0.07);
}
#scheduleForm input, #scheduleForm select, #scheduleForm textarea,
#editScheduleForm input, #editScheduleForm select, #editScheduleForm textarea {
  margin-bottom: 10px;
  font-size: 15px;
}
#scheduleForm button, #editScheduleForm button {
  min-width: 110px;
  background: #2c2b7c;
  color: #fff;
  border: none;
  border-radius: 6px;
  padding: 7px 0;
  font-weight: 500;
  transition: background 0.2s;
}
#scheduleForm button:hover, #editScheduleForm button:hover {
  background: #1a1960;
}
#scheduleTable {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 10px rgba(44,43,124,0.07);
  overflow: hidden;
  justify-content: center;
  align-items: center;
  width: 100%;
  margin-top: 10px;
}
#scheduleTable th, #scheduleTable td {
  padding: 10px 10px;
  vertical-align: middle;
}
#scheduleTable th {
  background: #e6e7fa;
  color: #2c2b7c;
  font-weight: 700;
  border-bottom: 2px solid #bfc0e6;
}
#scheduleTable tr:not(:last-child) td {
  border-bottom: 1px solid #f1f3f4;
}
#scheduleTable tbody tr {
  transition: background 0.18s;
}
#scheduleTable tbody tr:nth-child(even) {
  background: #f7f8fd;
}
#scheduleTable tbody tr:hover {
  background: #e0e1f7;
}
.edit-btn, .delete-btn {
  margin-right: 6px;
  border-radius: 5px;
  font-size: 14px;
  padding: 4px 12px;
}
.edit-btn {
  background: #e6e7fa;
  color: #2c2b7c;
  border: none;
}
.edit-btn:hover {
  background: #bfc0e6;
  color: #fff;
}
.delete-btn {
  background: #ffeaea;
  color: #b71c1c;
  border: none;
}
.delete-btn:hover {
  background: #ffbdbd;
  color: #fff;
}
.modal-content {
  border-radius: 16px;
}
.modal-header {
  background: linear-gradient(135deg, #2c2b7c, #4e4dc7);
  color: #fff;
  border-radius: 16px 16px 0 0;
}
.btn-close {
  filter: brightness(0) invert(1);
}
/* Card-style for each schedule row */
#scheduleTable tbody tr {
  box-shadow: 0 2px 8px rgba(44,43,124,0.06);
  border-radius: 10px;
  margin-bottom: 8px;
  display: table-row;
}
@media (max-width: 700px) {
  .schedule-container { padding: 4px; }
  #scheduleForm, #editScheduleForm { padding: 6px; }
  #scheduleTable th, #scheduleTable td { padding: 7px 4px; font-size: 13px; }
}
/* Subtle animation for table row hover */
#scheduleTable tbody tr {
  transition: background 0.18s, box-shadow 0.18s;
}
#scheduleTable tbody tr:hover {
  box-shadow: 0 4px 16px rgba(44,43,124,0.13);
}
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="container-fluid schedule-container">

<h2>Create Schedule</h2>
  <form id="scheduleForm" class="row g-2 align-items-end">
    <div class="col-md-3 col-12">
      <label for="courseSelect" class="form-label fw-semibold text-primary">Course</label>
      <select id="courseSelect" class="form-select form-select-sm" required></select>
    </div>
    <div class="col-md-3 col-12">
      <label for="title" class="form-label fw-semibold text-primary">Title</label>
      <input type="text" id="title" class="form-control form-control-sm" placeholder="Title" required />
    </div>
    <div class="col-md-2 col-6">
      <label for="eventDate" class="form-label fw-semibold text-primary">Date</label>
      <input type="date" id="eventDate" class="form-control form-control-sm" required />
    </div>
    <div class="col-md-2 col-6">
      <label for="startTime" class="form-label fw-semibold text-primary">Start</label>
      <input type="time" id="startTime" class="form-control form-control-sm" required />
    </div>
    <div class="col-md-2 col-6">
      <label for="endTime" class="form-label fw-semibold text-primary">End</label>
      <input type="time" id="endTime" class="form-control form-control-sm" required />
    </div>
    <div class="col-md-3 col-12">
      <label for="location" class="form-label fw-semibold text-primary">Location</label>
      <input type="text" id="location" class="form-control form-control-sm" placeholder="Location" />
    </div>
    <div class="col-md-5 col-12">
      <label for="description" class="form-label fw-semibold text-primary">Description</label>
      <textarea id="description" class="form-control form-control-sm" placeholder="Description" rows="1"></textarea>
    </div>
    <div class="col-md-2 col-12 d-grid">
      <button type="submit" class="btn btn-primary btn-sm mt-3" style="background:#2c2b7c;border:none;">Create</button>
    </div>
  </form>
    <h3>My Schedules</h3>
    <table id="scheduleTable" border="1">
        <thead>
            <tr>
                <th>Course</th><th>Title</th><th>Date</th><th>Time</th><th>Location</th><th>Description</th><th>Action</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>

    <!-- Edit Schedule Modal -->
<div class="modal fade" id="editScheduleModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Edit Schedule</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="editScheduleForm">
          <input type="hidden" id="editScheduleId" />
          <div class="mb-2">
            <label for="editCourseSelect" class="form-label">Course</label>
            <select id="editCourseSelect" class="form-select" required></select>
          </div>
          <div class="mb-2">
            <label for="editTitle" class="form-label">Title</label>
            <input type="text" id="editTitle" class="form-control" required />
          </div>
          <div class="mb-2">
            <label for="editEventDate" class="form-label">Date</label>
            <input type="date" id="editEventDate" class="form-control" required />
          </div>
          <div class="mb-2">
            <label for="editStartTime" class="form-label">Start Time</label>
            <input type="time" id="editStartTime" class="form-control" required />
          </div>
          <div class="mb-2">
            <label for="editEndTime" class="form-label">End Time</label>
            <input type="time" id="editEndTime" class="form-control" required />
          </div>
          <div class="mb-2">
            <label for="editLocation" class="form-label">Location</label>
            <input type="text" id="editLocation" class="form-control" />
          </div>
          <div class="mb-2">
            <label for="editDescription" class="form-label">Description</label>
            <textarea id="editDescription" class="form-control"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="saveEditBtn">Save Changes</button>
      </div>
    </div>
  </div>
</div>
</div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
    // Load courses for the teacher
    $(function() {
        $.ajax({
            type: "POST",
            url: "Grades.aspx/GetTeacherCourses",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(res) {
                var courses = res.d ? JSON.parse(res.d) : res;
                courses.forEach(function(c) {
                    $('#courseSelect').append(`<option value="${c.CourseID}">${c.CourseName}</option>`);
                    $('#editCourseSelect').append(`<option value="${c.CourseID}">${c.CourseName}</option>`);
                });
            }
        });

        // Load schedules
        function loadSchedules() {
            $.ajax({
                type: "POST",
                url: "Schedule.aspx/GetTeacherSchedules",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(res) {
                    var schedules = res.d ? JSON.parse(res.d) : res;
                    renderSchedules(schedules);
                }
            });
        }
        loadSchedules();


// Handle form submit
$('#scheduleForm').on('submit', function(e) {
    e.preventDefault();

    // Validation: Date and time must not be in the past
    var eventDate = $('#eventDate').val();
    var startTime = $('#startTime').val();
    var endTime = $('#endTime').val();

    var now = new Date();
    var selectedDate = new Date(eventDate + 'T' + startTime);

    if (!eventDate || !startTime || !endTime) {
        Swal.fire('Missing Fields', 'Please fill in all required fields.', 'warning');
        return;
    }

    if (selectedDate < now) {
        Swal.fire('Invalid Date/Time', 'Schedule date and time cannot be in the past.', 'error');
        return;
    }

    if (endTime <= startTime) {
        Swal.fire('Invalid Time', 'End time must be after start time.', 'error');
        return;
    }

    $.ajax({
        type: "POST",
        url: "Schedule.aspx/CreateSchedule",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({
            courseId: $('#courseSelect').val(),
            title: $('#title').val(),
            description: $('#description').val(),
            eventDate: eventDate,
            startTime: startTime,
            endTime: endTime,
            location: $('#location').val()
        }),
        success: function(res) {
            Swal.fire({
                icon: 'success',
                title: 'Schedule created!',
                showConfirmButton: false,
                timer: 1400
            });
            loadSchedules();
            $('#scheduleForm')[0].reset();
        }
    });
});

    });

// Edit and Delete buttons to each row
function renderSchedules(schedules) {
  var tbody = $('#scheduleTable tbody').empty();
  schedules.forEach(function(s) {
    tbody.append(`<tr data-id="${s.ScheduleID}">
      <td>${s.CourseName}</td>
      <td>${s.Title}</td>
      <td>${s.EventDate}</td>
      <td>${s.StartTime} - ${s.EndTime}</td>
      <td>${s.Location}</td>
      <td>${s.Description}</td>
      <td>
        <button class="btn btn-sm btn-primary edit-btn" data-id="${s.ScheduleID}">Edit</button> <button class="btn btn-sm btn-danger delete-btn" data-id="${s.ScheduleID}">Delete</button>
      </td>
    </tr>`);
  });
}

// Load courses for edit modal
function loadCoursesForEdit(callback) {
  $.ajax({
    type: "POST",
    url: "Grades.aspx/GetTeacherCourses",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function(res) {
      var courses = res.d ? JSON.parse(res.d) : res;
      var $select = $('#editCourseSelect').empty();
      courses.forEach(function(c) {
        $select.append(`<option value="${c.CourseID}">${c.CourseName}</option>`);
      });
      if (typeof callback === 'function') callback();
    }
  });
}

// Edit button click
$('#scheduleTable').on('click', '.edit-btn', function() {
  var id = $(this).data('id');
  var row = $(this).closest('tr');
  // Prefill modal
  $('#editScheduleId').val(id);
  var courseName = row.find('td').eq(0).text();
  $('#editTitle').val(row.find('td').eq(1).text());
  $('#editEventDate').val(row.find('td').eq(2).text());
  var times = row.find('td').eq(3).text().split(' - ');
  $('#editStartTime').val(times[0]);
  $('#editEndTime').val(times[1]);
  $('#editLocation').val(row.find('td').eq(4).text());
  $('#editDescription').val(row.find('td').eq(5).text());
  loadCoursesForEdit(function() {
    // After loading, select the correct course by name
    $('#editCourseSelect option').each(function() {
      if ($(this).text() === courseName) {
        $(this).prop('selected', true);
        return false;
      }
    });
  });
  var modal = new bootstrap.Modal(document.getElementById('editScheduleModal'));
  modal.show();
});

// Save changes
$('#saveEditBtn').on('click', function() {
  var id = $('#editScheduleId').val();
  var courseId = $('#editCourseSelect').val();
  var title = $('#editTitle').val();
  var eventDate = $('#editEventDate').val();
  var startTime = $('#editStartTime').val();
  var endTime = $('#editEndTime').val();
  var location = $('#editLocation').val();
  var description = $('#editDescription').val();

  // Validation: Date and time must not be in the past
  var now = new Date();
  var selectedDate = new Date(eventDate + 'T' + startTime);

  if (!courseId || !title || !eventDate || !startTime || !endTime) {
    Swal.fire('Missing Fields', 'Please fill in all required fields.', 'warning');
    return;
  }

  if (selectedDate < now) {
    Swal.fire('Invalid Date/Time', 'Schedule date and time cannot be in the past.', 'error');
    return;
  }

  if (endTime <= startTime) {
    Swal.fire('Invalid Time', 'End time must be after start time.', 'error');
    return;
  }

  $.ajax({
    type: "POST",
    url: "Schedule.aspx/UpdateSchedule",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    data: JSON.stringify({
      scheduleId: id,
      courseId: courseId,
      title: title,
      description: description,
      eventDate: eventDate,
      startTime: startTime,
      endTime: endTime,
      location: location
    }),
    success: function(res) {
      if (res.d && JSON.parse(res.d).success) {
        $('#editScheduleModal').modal('hide');
        // Update the row in-place
        var row = $('#scheduleTable tbody tr[data-id="' + id + '"]');
        var courseName = $('#editCourseSelect option:selected').text();
        row.find('td').eq(0).text(courseName);
        row.find('td').eq(1).text(title);
        row.find('td').eq(2).text(eventDate);
        row.find('td').eq(3).text(startTime + ' - ' + endTime);
        row.find('td').eq(4).text(location);
        row.find('td').eq(5).text(description);
        Swal.fire('Success', 'Schedule updated!', 'success');
      }
    }
  });
});

// Delete button click
$('#scheduleTable').on('click', '.delete-btn', function() {
  var id = $(this).data('id');
  Swal.fire({
    title: 'Are you sure?',
    text: 'This will permanently delete the schedule.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes, delete it!',
    cancelButtonText: 'Cancel'
  }).then((result) => {
    if (result.isConfirmed) {
      $.ajax({
        type: "POST",
        url: "Schedule.aspx/DeleteSchedule",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ scheduleId: id }),
        success: function(res) {
          Swal.fire('Deleted!', 'Schedule deleted!', 'success');
          // Remove the row in-place
          $('#scheduleTable tbody tr[data-id="' + id + '"]').remove();
        }
      });
    }
  });
});



    </script>


</asp:Content>
