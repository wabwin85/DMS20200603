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
using DMS.Common.Common;

namespace DMS.Website.Pages.Promotion
{
    public partial class PromotionSettlement : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IGiftMaintainBLL _business = new GiftMaintainBLL();

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(this.ProductLineStore);
            }
        }

        protected void PeriodStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> proPeriod = DictionaryHelper.GetDictionary(SR.PRO_Period);
            PeriodStore.DataSource = proPeriod;
            PeriodStore.DataBind();
        }

        protected void CalPeriodStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dtCalPeriod = _business.GetApprovalCalPeriodByPeriod(this.hidPeriod.Value.ToString()).Tables[0];
            CalPeriodStore.DataSource = dtCalPeriod;
            CalPeriodStore.DataBind();
        }


        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("Bu", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbCalPeriod.SelectedItem.Value))
            {
                param.Add("CalPeriod", this.cbCalPeriod.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbPeriod.SelectedItem.Value))
            {
                param.Add("Period", this.cbPeriod.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtPolicyNo.Text))
            {
                param.Add("PolicyNo", this.txtPolicyNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtPolicyName.Text))
            {
                param.Add("PolicyName", this.txtPolicyName.Text);
            }
            if (!string.IsNullOrEmpty(this.cbProType.SelectedItem.Value))
            {
                param.Add("PolicyStyle", this.cbProType.SelectedItem.Value);
            }

            DataTable query = _business.QueryPromotionSettlementList(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        [AjaxMethod]
        public void Submint(string param)
        {
            try
            {
                Hashtable obj = new Hashtable();
                obj.Add("StingPolicyId", param);
                _business.SubmintPolicySettlement(obj);
                GridPanel1.Reload();
            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("错误", ex.ToString()).Show();
            }
        }
    }
}