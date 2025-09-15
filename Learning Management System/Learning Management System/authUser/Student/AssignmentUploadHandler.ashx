<%@ WebHandler Language="C#" Class="AssignmentUploadHandler" %>
using System;
using System.Web;
using System.IO;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

public class AssignmentUploadHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        try
        {
            var request = context.Request;
            if (request.Files.Count == 0 || string.IsNullOrEmpty(request.Form["assignmentId"]))
            {
                context.Response.Write(new JavaScriptSerializer().Serialize(new { success = false, error = "Missing file or assignment ID." }));
                context.Response.End();
                return;
            }
            var file = request.Files[0];
            var assignmentId = request.Form["assignmentId"];
            // You may want to get the student ID from session or auth
            var studentId = context.Session["UserID"] != null ? context.Session["UserID"].ToString() : "1";
            var uploadsFolder = context.Server.MapPath("~/Uploads/AssignmentSubmissions/");
            if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);
            var ext = Path.GetExtension(file.FileName);
            var fileName = Guid.NewGuid().ToString("N") + ext;
            var savePath = Path.Combine(uploadsFolder, fileName);
            file.SaveAs(savePath);
            var dbFilePath = "/Uploads/AssignmentSubmissions/" + fileName;
            // Optionally get CourseID from request or lookup from Assignments table
            string courseId = request.Form["courseId"];
            if (string.IsNullOrEmpty(courseId))
            {
                // Try to get CourseID from Assignments table
                var connStrLookup = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
                using (var conn = new SqlConnection(connStrLookup))
                {
                    conn.Open();
                    var cmd = new SqlCommand("SELECT CourseID FROM Assignments WHERE AssignmentID = @AssignmentID", conn);
                    cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    var result = cmd.ExecuteScalar();
                    courseId = result != null ? result.ToString() : null;
                }
            }
            // Save submission to DB with all columns
            var connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                var cmd = new SqlCommand("INSERT INTO AssignmentSubmissions (AssignmentID, StudentID, CourseID, SubmissionFile, SubmittedAt, Status) VALUES (@AssignmentID, @StudentID, @CourseID, @SubmissionFile, @SubmittedAt, @Status)", conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                cmd.Parameters.AddWithValue("@StudentID", studentId);
                cmd.Parameters.AddWithValue("@CourseID", (object)courseId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@SubmissionFile", dbFilePath);
                cmd.Parameters.AddWithValue("@SubmittedAt", DateTime.Now);
                cmd.Parameters.AddWithValue("@Status", "Submitted");
                cmd.ExecuteNonQuery();
            }
            context.Response.Write(new JavaScriptSerializer().Serialize(new { success = true, filePath = dbFilePath }));
        }
        catch (Exception ex)
        {
            context.Response.Write(new JavaScriptSerializer().Serialize(new { success = false, error = ex.ToString() }));
            context.Response.End();
            return;
        }
    }
    public bool IsReusable { get { return false; } }
}
