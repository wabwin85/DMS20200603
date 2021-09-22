using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;

namespace DMS.Website.Controls
{
    using DMS.Common;
    using DMS.Website.Common;
    using DMS.Model;
    using DMS.Business;
    using Coolite.Ext.Web;

    public partial class StocktakingDialog : BaseUserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Store1_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshData(e.Start, e.Limit);
        }
        
        private void RefreshData(int start, int limit)
        {
            ICurrentInvBLL bll = new CurrentInvBLL();

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (this.cbCatories.SelectedItem.Value != "" && this.cbCatories.SelectedItem.Text.Trim() != "")
            {
                param.Add("ProductLine", new Guid(this.cbCatories.SelectedItem.Value));
            }           
            if (!string.IsNullOrEmpty(this.txtCFN.Text.Trim()))
            {
                param.Add("ProductCFN", this.txtCFN.Text.Trim());
            }

            DataSet ds = bll.QueryCurrentCfnProduct(param, start, limit, out totalCount);

            (this.Store1.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.Store1.DataSource = ds;
            this.Store1.DataBind();

        }
        
        protected void SubmitSelection(object sender, AjaxEventArgs e)
        {
            string json = e.ExtraParams["Values"];

            if (string.IsNullOrEmpty(json))
            {
                return;
            }

            if (AfterSelectedHandler != null)
            {
                AfterSelectedHandler(new SelectedEventArgs(json));
            }

            e.Success = true;

        }

        public AfterSelectedRow AfterSelectedHandler;
    }
}