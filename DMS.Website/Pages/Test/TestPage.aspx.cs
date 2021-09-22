using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Collections;

namespace DMS.Website.Pages.Test
{
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using Microsoft.Practices.Unity;
    using DMS.Website.Common;
    using DMS.Business;
    using DMS.Model;
    using DMS.Common;
    using DMS.Model.Data;
    using DMS.Business.Cache;

    public partial class TestPage : BasePage
    {
        #region 公共

        IRoleModelContext _context = RoleModelContext.Current;

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

        }

    }
}
