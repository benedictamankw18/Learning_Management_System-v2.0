using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;

namespace Learning_Management_System.Accounts
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("~/Accounts/Login.aspx");
        }
        [System.Web.Services.WebMethod]
        public static object PerformLogout()
        {
            try
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();
                ActivityLogger.Log("AdminLogout", "Success");
                return new { success = true };
            }
            catch (Exception ex)
            {
                ActivityLogger.Log("AdminLogout", $"Error: {ex.Message}");
                return new { success = false, message = ex.Message };
            }
        }

    }
}