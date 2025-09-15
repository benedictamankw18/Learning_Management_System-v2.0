using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System.authUser.Student
{
    public partial class Material : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string courseId = Request.QueryString["courseId"];
                if (!string.IsNullOrEmpty(courseId))
                {
                    BindSections(courseId);
                }
            }
        }

        private void BindSections(string courseId)
        {
            var sections = new List<SectionViewModel>();
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string sqlSections = @"SELECT CourseSectionsId, SectionName, Description
                       FROM CourseSections
                       WHERE CourseId = @CourseID AND IsActive = 1
                       ORDER BY OrderIndex";

                using (var cmd = new System.Data.SqlClient.SqlCommand(sqlSections, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            sections.Add(new SectionViewModel
                                {
                                    SectionID = reader["CourseSectionsId"].ToString(),
                                    SectionTitle = reader["SectionName"].ToString(),
                                    Description = reader["Description"].ToString(),
                                    Materials = new List<MaterialViewModel>() // <-- This is required!
                                });
                        }
                    }
                }

                // For each section, get materials
                foreach (var section in sections)
                {
                    string sqlMaterials = @"SELECT CourseMaterialId, Title, FilePath, MaterialType, Description, FileName, ExternalLink
                                                FROM CourseMaterials
                                                WHERE SectionId = @SectionID AND IsActive = 1
                                                ORDER BY OrderIndex";

                    using (var cmd = new System.Data.SqlClient.SqlCommand(sqlMaterials, conn))
                    {
                        cmd.Parameters.AddWithValue("@SectionID", section.SectionID);
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                section.Materials.Add(new MaterialViewModel
                                {
                                    MaterialID = reader["CourseMaterialId"].ToString(),
                                        Title = reader["Title"].ToString(),
                                        FilePath = reader["FilePath"].ToString(),
                                        MaterialType = reader["MaterialType"].ToString(),
                                        Description = reader["Description"].ToString(),
                                        FileName = reader["FileName"].ToString(),
                                        ExternalLink = reader["ExternalLink"].ToString(),

                                });
                            }
                        }
                    }
                }
            }
            // Add material count for display
            foreach (var section in sections)
            {
                section.MaterialCount = section.Materials.Count;
            }
            rptSections.DataSource = sections;
            rptSections.DataBind();
        }

     public class SectionViewModel
{
    public string SectionID { get; set; }
    public string SectionTitle { get; set; }
    public string Description { get; set; }
    public int MaterialCount { get; set; }
    public List<MaterialViewModel> Materials { get; set; }
}
public class MaterialViewModel
{
    public string MaterialID { get; set; }
    public string Title { get; set; }
    public string FilePath { get; set; }
    public string MaterialType { get; set; }
    public string Description { get; set; }
    public string FileName { get; set; }
    public string ExternalLink { get; set; }
}
    }
}