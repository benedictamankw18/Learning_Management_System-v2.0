<%@ Page Title="" Language="C#" MasterPageFile="~/authUser/Student/Student.Master" AutoEventWireup="true" CodeBehind="Material.aspx.cs" Inherits="Learning_Management_System.authUser.Student.Material" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<title>Course Materials - Learning Management System</title>
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />
	<style>
		body { font-family: 'Roboto', sans-serif; background: #f8f9fa; }
		.materials-container { max-width: 1100px; margin: 0 auto; padding: 2rem; }
		.page-header { background: linear-gradient(135deg, #007bff, #0056b3); color: white; padding: 2rem; border-radius: 16px; margin-bottom: 2.5rem; box-shadow: 0 8px 25px rgba(0, 123, 255, 0.13); }
		.section-row { background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.07); margin-bottom: 1.2rem; padding: 1.2rem 1.5rem; display: flex; align-items: center; cursor: pointer; transition: box-shadow 0.2s, transform 0.2s; border-left: 6px solid #1976d2; }
		.section-row:hover { box-shadow: 0 6px 18px rgba(25, 118, 210, 0.13); transform: translateY(-2px) scale(1.01); background: #f1f7ff; }
		.section-title { font-size: 1.15rem; font-weight: 600; color: #1976d2; flex: 1; }
		.section-meta { color: #6c757d; font-size: 0.98rem; margin-left: 1.2rem; }
		.material-list { display: none; margin-top: 0.7rem; margin-left: 2.5rem; }
		.material-list.active { display: block; }
		.material-item { background: #f8f9fa; border-radius: 8px; padding: 0.7rem 1.2rem; margin-bottom: 0.5rem; display: flex; align-items: center; }
		.material-icon { color: #1976d2; margin-right: 0.8rem; font-size: 1.2rem; }
		.material-title { font-weight: 500; color: #2c3e50; flex: 1; }
		.material-actions a { margin-left: 1rem; color: #007bff; text-decoration: none; font-size: 1.1rem; }
		.material-actions a:hover { color: #0056b3; }
		.course-actions { display: flex; gap: 1.2rem; margin-bottom: 2rem; }
		.course-actions .btn { border-radius: 8px; font-weight: 500; font-size: 1.05rem; padding: 0.7rem 1.5rem; }
		.btn-quiz { background: #46ce3c; color: white; border: none; }
		.btn-quiz:hover { background: #32a10d; }
		.btn-assignment { background: #ffc107; color: #212529; border: none; }
		.btn-assignment:hover { background: #e0a800; color: #212529; }
	</style>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<div class="materials-container">
		<div class="page-header mb-4">
			<h1 class="mb-2"><i class="fas fa-book-open me-3"></i>Course Materials</h1>
			<p class="mb-0 opacity-75">Browse all sections and resources for this course</p>
		</div>
		<div class="course-actions mb-4">
			<button class="btn btn-quiz" onclick="goToQuiz()"><i class="fas fa-question-circle me-2"></i>View Quizzes</button>
			<button class="btn btn-assignment" onclick="goToAssignment()"><i class="fas fa-tasks me-2"></i>View Assignments</button>
		</div>
		<asp:Repeater ID="rptSections" runat="server">
			<ItemTemplate>
				<div class="section-row" onclick="toggleMaterials('<%# Eval("SectionID") %>')">
					<span class="section-title"><i class="fas fa-layer-group me-2"></i><%# Eval("SectionTitle") %></span>
					<span class="section-meta"><i class="fas fa-file-alt me-1"></i><%# Eval("MaterialCount") %> materials</span>
				</div>
				<div class="material-list" id="materials-<%# Eval("SectionID") %>">
					<asp:Repeater ID="rptMaterials" runat="server" DataSource='<%# Eval("Materials") %>'>
						<ItemTemplate>
							<div class="material-item">
								<span class="material-icon">
									<%# GetMaterialIcon(Eval("MaterialType"), Eval("FileName")) %>
								</span>
								<span class="material-title"><%# Eval("Title") %></span>
								<div class="material-actions">
									<a href="<%# Eval("FilePath") %>" target="_blank"><i class="fas fa-eye"></i> View</a>
									<a href="<%# Eval("FilePath") %>" download><i class="fas fa-download"></i> Download</a>
								</div>
							</div>
						</ItemTemplate>
					</asp:Repeater>
				</div>
			</ItemTemplate>
		</asp:Repeater>
	<%-- Helper function for icon selection --%>
	<script runat="server">
	protected string GetMaterialIcon(object materialTypeObj, object fileNameObj)
	{
		string materialType = "";
		string fileName = "";
		if (materialTypeObj != null)
			materialType = materialTypeObj.ToString().ToLower();
		if (fileNameObj != null)
			fileName = fileNameObj.ToString().ToLower();
		string ext = System.IO.Path.GetExtension(fileName);
		if (materialType.Contains("pdf") || ext == ".pdf")
			return "<i class='fas fa-file-pdf text-danger'></i>";
		if (materialType.Contains("video") || ext == ".mp4" || ext == ".avi" || ext == ".mov" || ext == ".wmv")
			return "<i class='fas fa-file-video text-info'></i>";
		if (materialType.Contains("presentation") || ext == ".ppt" || ext == ".pptx")
			return "<i class='fas fa-file-powerpoint text-warning'></i>";
		if (materialType.Contains("image") || ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".gif" || ext == ".bmp")
			return "<i class='fas fa-file-image text-success'></i>";
		if (materialType.Contains("document") || ext == ".doc" || ext == ".docx" || ext == ".txt" || ext == ".rtf")
			return "<i class='fas fa-file-word text-primary'></i>";
		if (materialType.Contains("spreadsheet") || ext == ".xls" || ext == ".xlsx" || ext == ".csv")
			return "<i class='fas fa-file-excel text-success'></i>";
		return "<i class='fas fa-file-alt text-secondary'></i>";
	}
	</script>
	</div>
	<script>
		function toggleMaterials(sectionId) {
			var el = document.getElementById('materials-' + sectionId);
			if (el) el.classList.toggle('active');
		}
		function goToQuiz() {
			const urlParams = new URLSearchParams(window.location.search);
			const courseId = urlParams.get('courseId');
			if (courseId) window.location.href = 'Quiz.aspx?courseId=' + courseId;
		}
		function goToAssignment() {
			const urlParams = new URLSearchParams(window.location.search);
			const courseId = urlParams.get('courseId');
			if (courseId) window.location.href = 'Assignment.aspx?courseId=' + courseId;
		}
	</script>
</asp:Content>
