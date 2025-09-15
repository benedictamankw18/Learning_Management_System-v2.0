using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Learning_Management_System
{
    public partial class _404 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string errorPath = Request.QueryString["aspxerrorpath"];

                if (!string.IsNullOrEmpty(errorPath))
                {
                    // Build a link back to the page they came from
                    lnkBack.NavigateUrl = ResolveUrl("~/Accounts/Login.aspx");
                }
                else
                {
                    // Fallback to homepage if no errorPath provided
                    lnkBack.NavigateUrl = ResolveUrl("~/Accounts/Login.aspx");
                }
            }
        }


    }
}