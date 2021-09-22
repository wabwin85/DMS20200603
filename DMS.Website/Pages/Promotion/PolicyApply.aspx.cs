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
using Microsoft.Practices.Unity;

namespace DMS.Website.Pages.Promotion
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "PolicyApply")]
    public partial class PolicyApply : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    this.btnInsert.Hidden = true;
                    this.GridPanel1.ColumnModel.SetHidden(9, true);
                    this.GridPanel1.ColumnModel.SetHidden(10, true);
                }
                this.hidUserId.Value = _context.User.Id;
                this.Bind_ProductLine(this.ProductLineStore);
            }
        }

        [AjaxMethod]
        public void DeleteProPolicy(string policyId)
        {
            _business.DeletePolicy(policyId);
        }

        protected void StatusStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(SR.PRO_Status);
            StatusStore.DataSource = contractStatus;
            StatusStore.DataBind();
        }

        protected void TimeStatusStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(SR.PRO_TimeStatus);
            TimeStatusStore.DataSource = contractStatus;
            TimeStatusStore.DataBind();
        }
        protected void WindowProTypeSubStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Key");
            dt.Columns.Add("Value");
            if (this.hidWindowPromotionType.Value.ToString().Equals("赠品")) 
            {
                dt.Rows.Add("促销赠品", "促销赠品");
            }
            else if (this.hidWindowPromotionType.Value.ToString().Equals("积分"))
            {
                dt.Rows.Add("满额送固定积分", "满额送固定积分");
                dt.Rows.Add("金额百分比积分", "金额百分比积分");
                dt.Rows.Add("促销赠品转积分", "买减/价格补偿");
            }
            else if (this.hidWindowPromotionType.Value.ToString().Equals("即时买赠"))
            {
                dt.Rows.Add("满额送赠品", "满额送赠品");
                dt.Rows.Add("满额打折", "满额打折");
            }
            WindowProTypeSubStore.DataSource = dt;
            WindowProTypeSubStore.DataBind();
        }
        

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("BU", this.cbProductLine.SelectedItem.Value);
            }
            else { param.Add("BU", DBNull.Value); }
            if (!string.IsNullOrEmpty(this.cbPolicyStatus.SelectedItem.Value))
            {
                param.Add("Status", this.cbPolicyStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbTimeStatus.SelectedItem.Value))
            {
                param.Add("TimeStatus", this.cbTimeStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtPolicyNo.Text))
            {
                param.Add("PolicyNo", this.txtPolicyNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtPolicyName.Text))
            {
                param.Add("PolicyName", this.txtPolicyName.Text);
            }
            if (!string.IsNullOrEmpty(this.txtYear.Text))
            {
                param.Add("Year", this.txtYear.Text);
            }
            if (!string.IsNullOrEmpty(this.cbProType.SelectedItem.Value))
            {
                param.Add("PolicyStyle", this.cbProType.SelectedItem.Value);
            }
            param.Add("UserId", _context.User.Id);

            DataTable query = _business.QueryPolicyList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

    }
}
