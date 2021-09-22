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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ConsignmenReturnsCfn")]
    public partial class ConsignmenReturnsCfn : System.Web.UI.UserControl
    {
        IConsignmentApplyHeaderBLL Bll = new ConsignmentApplyHeaderBLL();

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [AjaxMethod]
        public void Show(string hid, string pid, string did, string iahdid, string cmid)
        {
            CelareWindowFrom();
            hidProductLine.Text = pid;
            hidHeaderId.Text = hid;
            hidDealerId.Text = did;
            hidIahDmaId.Text = iahdid;
            hidCmId.Text = cmid;
            ReturnsCfnWindow.Show();
        }
        [AjaxMethod]
        public void DoAddCfnSet(string CfnString)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            (new ConsignmentApplyDetailsBLL()).AddConsignmenfnInventCfn(new Guid(hidHeaderId.Text), hidDealerId.Text, CfnString,"", out rtnVal, out rtnMsg);
            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");
        }

        public void CelareWindowFrom()
        {
            hidProductLine.Clear();
            hidHeaderId.Clear();
            hidDealerId.Clear();
            hidIahDmaId.Clear();
        }
        public void CfnSetStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable table = new Hashtable();
            table.Add("IAHDMAId", hidIahDmaId.Text);
            table.Add("LOTDMAId", hidDealerId.Text);
            table.Add("ProductLineId", hidProductLine.Text);
            table.Add("CMID", hidCmId.Text);
            DataSet ds = Bll.QueryInventoryAdjustHeaderList(table, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            CfnSetStore.DataSource = ds;
            CfnSetStore.DataBind();
        }
        public void CfnSetDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            string id = e.Parameters["IAHId"];
            DataSet ds = Bll.QueryInventoryAdjustCfnList(id, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            CfnSetDetailStore.DataSource = ds;
            CfnSetDetailStore.DataBind();
        }
    }
}