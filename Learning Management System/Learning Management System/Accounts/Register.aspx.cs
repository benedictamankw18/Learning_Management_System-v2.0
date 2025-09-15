using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Learning_Management_System.Helpers;

namespace Learning_Management_System
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Log the page load activity
                ActivityLogger.Log("PageLoaded", "Register page loaded successfully.");
            }
        }
    }
}