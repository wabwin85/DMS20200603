using Coolite.Ext.Web;
using DMS.Business;
using DMS.Common;
using DMS.Model.Data;
using DMS.Website.Common;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.Order
{
    public partial class PurchasingForecastReport : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();        
        private IPurchaseOrderBLL pob = new PurchaseOrderBLL();

        public string ProductLine
        {
            get
            {
                return this.hidcbProductLine.Text;
            }
            set
            {
                this.hidcbProductLine.Text = value.ToString();
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(ProductLineStore);
                string yera = DateTime.Now.Year.ToString();
                string month = DateTime.Now.ToString("MM");
                this.ForecastVersion.Text = yera + month;
            }
        }
        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshData(e.Start, e.Limit);
        }

        private void RefreshData(int start, int limit)
        {
            int totalCount = 0;
            DataTable query = pob.PurchasingForecastReport(GetQueryList(), (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount).Tables[0];
            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;      
            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }       
        private Hashtable GetQueryList()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.ForecastVersion.Text))
            {
                param.Add("PFA_ForecastVersion", this.ForecastVersion.Value);
            }
            if (!string.IsNullOrEmpty(this.UPNID.Text))
            {
                param.Add("PFA_UPN", this.UPNID.Value);
            }
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }
            if (IsDealer)
            {
                param.Add("DealerId", _context.User.CorpId);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("cbProductLine", this.cbProductLine.SelectedItem.Value);
            }
            return param;
        }
    }
}