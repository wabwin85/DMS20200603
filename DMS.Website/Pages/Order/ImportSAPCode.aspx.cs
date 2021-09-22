using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using Lafite.RoleModel.Security;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;

namespace DMS.Website.Pages.Order
{
    public partial class ImportSAPCode : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.ImportButton.Disabled = true;

            }
        }

        public void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
        }
        protected void UploadClick(object sender, AjaxEventArgs e)
        {
        }

        protected void UploadConfirm(object sender, AjaxEventArgs e)
        {
        }
    }
}
