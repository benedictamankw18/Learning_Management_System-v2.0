using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;

namespace Learning_Management_System.authUser.Student
{
    public partial class Student : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Student"] == null)
            {
                Response.Redirect("~/Accounts/Login.aspx");
                return;
            }
            //if (!IsPostBack)
            //{
            //    if (Session["UserType"] != null)
            //    {
            //        if (!Session["UserType"].ToString().ToLower().Equals("student"))
            //        {
            //            Response.Redirect("~/Accounts/Login.aspx");
            //            return;
            //        }
            //    }
            //}
        }


        [System.Web.Services.WebMethod]
        public static object PerformLogout()
        {
            try
            {
                // Log logout activity

                string email = HttpContext.Current.Session["Email"].ToString();
                string name = HttpContext.Current.Session["FullName"].ToString();
                string userid = HttpContext.Current.Session["UserID"].ToString();

                // Clear session
                HttpContext.Current.Session["Teacher"] = null;
                HttpContext.Current.Session["UserID"] = null;
                HttpContext.Current.Session["FullName"] = null;
                HttpContext.Current.Session["Email"] = null;
                HttpContext.Current.Session["UserType"] = null;
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();

                ActivityLogger.LogLoginActivity(email + " (" + userid + ") ", "SuccessS");
                ActivityLogger.Log("UserLogout", name + " (" + userid + ") " + " Logout on " + DateTime.Now.ToShortDateString());
                return new { success = true };
            }
            catch (Exception ex)
            {
                ActivityLogger.LogError("Error during logout", ex);
                return new { success = false, message = ex.Message };
            }
        }

    }
}