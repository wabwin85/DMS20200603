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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "ConsignmenCfnSet")]
    public partial class ConsignmenCfnSet : BaseUserControl
    {
        ICfns Basebll = new Cfns();
        ICfnSetBLL CfnSetbl = new CfnSetBLL();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        #region 
        [AjaxMethod]
        public void Show(string hid, string pid, string did, string ptid, string spid, string otype)
        {
            ClearWindowFrom();
            this.hidHeaderId.Text = hid;
            this.hidProductLine.Text = pid;
            this.hidDealerId.Text = did;
            this.hidOrderTypeId.Text = otype;
            CfnSetWindow.Show();
        }
        [AjaxMethod]
        public void DoAddCfnSet(string Param)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            (new ConsignmentApplyDetailsBLL()).AddCfnSet(new Guid(this.hidHeaderId.Text), new Guid(this.hidDealerId.Text), Param.Substring(0, Param.Length - 1), "", out rtnVal, out rtnMsg);
            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");
        }
        #endregion 

        protected void CfnSetStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = Basebll.QueryConsignmentCfnSetBy(hidProductLine.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.CfnSetStore.DataSource = ds;
            this.CfnSetStore.DataBind();
        }
        public void CfnSetDetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            string id = e.Parameters["CfnSetId"];
            int totalCount = 0;
            DataSet ds =CfnSetbl.QueryConsignmenCfnSetDetailByCFNSID(id, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            CfnSetDetailStore.DataSource = ds;
            CfnSetDetailStore.DataBind();

        }
        /// <summary>
        /// 清除页面控件值
        /// </summary>
        public void ClearWindowFrom()
        {
            this.hidHeaderId.Clear();
            this.hidProductLine.Clear();
            this.hidDealerId.Clear();
            this.hidCfnSetId.Clear();
            this.hidOrderTypeId.Clear();
            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
        }
       
    }
}