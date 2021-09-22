using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Coolite.Ext.Web;
using DMS.Website.Common;
using DMS.Business;
using DMS.Model;
using DMS.Common;
using System.Collections;
using System.Data;
using DMS.Business.Cache;
using DMS.Model.Data;
using Lafite.RoleModel.Security;
using System.Xml;
using System.Xml.Xsl;
using Microsoft.Practices.Unity;
using DMS.Business.DP;

namespace DMS.Website.Pages.DP
{
    public partial class DPPermissionsSet : BasePage
    {
        #region 公共
        private IDealerInfoService _DealerInfo = null;
        private IDealerInfoService DealerInfo
        {
            get
            {
                if (_DealerInfo == null)
                {
                    _DealerInfo = new DealerInfoService();
                }
                return _DealerInfo;
            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void RoleStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable obj = new Hashtable();
            if (!String.IsNullOrEmpty(this.tfRoleName.Text)) 
            {
                obj.Add("RoleName", this.tfRoleName.Text);
            }
            DataSet ds = DealerInfo.GetRoleList(obj, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            (this.RoleStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;
            this.RoleStore.DataSource = ds;
            this.RoleStore.DataBind();
        }


        [AjaxMethod]
        public void BindIFrameUrl(string id, string name)
        {
            WindowPermissionsSet.AutoLoad.Url = "DPPermissionsInfo.aspx?RoleID=" + id + "&RoleName=" + name;
            this.WindowPermissionsSet.LoadContent();
            this.WindowPermissionsSet.Show();
        }
    }
}
