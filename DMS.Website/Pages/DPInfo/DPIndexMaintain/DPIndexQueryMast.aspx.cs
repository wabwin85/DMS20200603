﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Lafite.RoleModel.Security;

namespace DMS.Website.Pages.DPInfo.DPIndexMaintain
{
    public partial class DPIndexQueryMast : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Response.Redirect("/BSCDp/Pages/Logon.aspx?UserId=" + _context.User.Id + "&Action=QueryMast&DealerId=" + Request.QueryString["DealerId"]);
                //Response.Redirect("http://localhost:8818/Pages/Logon.aspx?UserId=" + _context.User.Id + "&Action=QueryMast&DealerId=" + Request.QueryString["DealerId"]);
            }
        }
    }
}
