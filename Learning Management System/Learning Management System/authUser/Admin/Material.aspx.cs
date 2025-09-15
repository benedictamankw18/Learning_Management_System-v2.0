using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Services;

namespace Learning_Management_System.authUser.Admin
{
    public partial class Material : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

[WebMethod]
[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
public static object GetCourses()
{
    var courses = new List<object>();
    string connectionString = ConfigurationManager.ConnectionStrings["LMSConnection"].ConnectionString;

    using (SqlConnection conn = new SqlConnection(connectionString))
    {
        conn.Open();
        string query = @"SELECT CourseID, CourseCode, CourseName, Description, 
                                (SELECT COUNT(*) FROM CourseSections WHERE CourseId = c.CourseID) AS Sections,
                                (SELECT COUNT(*) FROM CourseMaterials WHERE CourseId = c.CourseID) AS Materials,
                                (SELECT FullName FROM Users WHERE UserID = c.UserID) AS Instructor
                         FROM Courses c";
        using (SqlCommand cmd = new SqlCommand(query, conn))
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                courses.Add(new
                {
                    id = Convert.ToInt32(reader["CourseID"]),
                    code = reader["CourseCode"].ToString(),
                    name = reader["CourseName"].ToString(),
                    description = reader["Description"].ToString(),
                    instructor = reader["Instructor"].ToString(),
                    sections = Convert.ToInt32(reader["Sections"]),
                    materials = Convert.ToInt32(reader["Materials"])
                });
            }
        }
    }
    return new { success = true, data = courses };
}

    }
}