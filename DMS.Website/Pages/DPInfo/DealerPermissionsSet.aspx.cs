using System;
using System.Collections.Generic;
using System.Linq;
using System.Collections;
using System.Data;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using DMS.Business.Cache;
using DMS.Model;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using DMS.Common;

namespace DMS.Website.Pages.DPInfo
{
    public partial class DealerPermissionsSet : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Response.Redirect("/BSCDp/Pages/Logon.aspx?UserId=" + _context.User.Id + "&Action=DPRole");
                //Response.Redirect("http://localhost:8818/Pages/Logon.aspx?UserId=" + _context.User.Id + "&Action=DPRole");
            }
        }
    }
}