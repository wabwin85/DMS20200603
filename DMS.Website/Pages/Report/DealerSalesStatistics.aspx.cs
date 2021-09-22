using Coolite.Ext.Web;
using DMS.Business;
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

namespace DMS.Website.Pages.Report
{
    public partial class DealerSalesStatistics : BasePage
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        private IReportBLL _businessReport = new ReportBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_DealerListByFilter(DealerStore, true);
                this.Bind_ProductLine(ProductLineStore);
                if (IsDealer)
                {

                    if (RoleModelContext.Current.User.CorpType == DealerType.T1.ToString())
                    {
                        this.cbDealer.Disabled = true;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();

                    }
                    else if (RoleModelContext.Current.User.CorpType == DealerType.T2.ToString())
                    {
                        this.cbDealer.Disabled = true;
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, false);

                    }
                }
            }
        }


        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("cbDealer", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("cbProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!this.StartbeginTime.IsNull)
            {
                param.Add("StartbeginTime", this.StartbeginTime.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.StartstopTime.IsNull)
            {
                param.Add("StartstopTime", this.StartstopTime.SelectedDate.ToString("yyyyMMdd"));
            } 
            if (!this.EndbeginTime.IsNull)
            {
                param.Add("EndbeginTime", this.EndbeginTime.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.EndstopTime.IsNull)
            {
                param.Add("EndstopTime", this.EndstopTime.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.InDueTime.SelectedItem.Value))
            {
                param.Add("InDueTime", this.InDueTime.SelectedItem.Text);
            }
            if (!string.IsNullOrEmpty(this.IsPurchased.SelectedItem.Value))
            {
                param.Add("IsPurchased", this.IsPurchased.SelectedItem.Value);
            }
            DataTable dt = _businessReport.DealerSalesStatistics(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount).Tables[0];
            e.TotalCount = totalCount;
            this.ResultStore.DataSource = dt;
            this.ResultStore.DataBind();
        }


    }
}