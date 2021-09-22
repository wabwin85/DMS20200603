using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace DMS.Website.Pages.MasterDatas
{
    using DMS.Model;
    using DMS.Business;
    using DMS.Business.Cache;
    using DMS.Common;
    using DMS.Website.Common;
    using Coolite.Ext.Web;
    using Lafite.RoleModel.Security;
    using System.Data;
    public partial class DealerLicenseEditor : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;

        private IDealerContracts _dealerContractBiz = Global.ApplicationContainer.Resolve<IDealerContracts>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if ((!IsPostBack) && (!Ext.IsAjaxRequest))
            {
               
            }
        }

    
    }
}
