using Lafite.RoleModel.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Revolution.Pages
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IRoleModelContext context = RoleModelContext.Current;
            if (context != null)
                context.User.FlushCache();
            HttpContext.Current.Session.Abandon();
            FormsAuthentication.SignOut();
            this.Response.Redirect(FormsAuthentication.LoginUrl);
        }
    }
}