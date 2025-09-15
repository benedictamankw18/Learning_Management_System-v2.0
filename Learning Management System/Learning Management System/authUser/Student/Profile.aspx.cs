using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;


namespace Learning_Management_System.authUser.Student
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
    public static string GetStudentProfile()
    {
        var profile = new Dictionary<string, string>();
        int studentId = 1; // fallback
        if (System.Web.HttpContext.Current != null && System.Web.HttpContext.Current.Session["UserID"] != null)
        {
            int.TryParse(System.Web.HttpContext.Current.Session["UserID"].ToString(), out studentId);
        }
        string connStr = ConfigurationManager.ConnectionStrings["LMSConnectionString"].ConnectionString;
        using (var conn = new SqlConnection(connStr))
        {
            conn.Open();
            string sql = @"SELECT UserID, FullName, Email, Phone, CreatedDate, ProfilePicture FROM Users WHERE UserID = @StudentID";
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@StudentID", studentId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        profile["StudentID"] = reader["UserID"].ToString();
                        profile["Name"] = reader["FullName"].ToString();
                        profile["Email"] = reader["Email"].ToString();
                        profile["Phone"] = reader["Phone"].ToString();
                        profile["ProfilePicture"] = reader["ProfilePicture"].ToString();
                        profile["CreatedDate"] = Convert.ToDateTime(reader["CreatedDate"]).ToString("MMM yyyy");
                    }
                }
            }
        }
        return new JavaScriptSerializer().Serialize(profile);
    }
    }
}