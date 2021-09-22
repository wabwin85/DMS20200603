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

namespace DMS.Website.Pages.Report
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "DealerInventoryReport")]
    public partial class DealerInventoryReport : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPromotionPolicyBLL _business = new PromotionPolicyBLL();
        private IReportBLL _businessReport = new ReportBLL();

        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_DealerListByFilter(DealerStore, true);
                this.Bind_ProductLine(ProductLineStore);
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType == DealerType.LP.ToString() || RoleModelContext.Current.User.CorpType == DealerType.LS.ToString())
                    {
                        this.cbDealer.Disabled = false;
                    }
                    else
                    {
                        this.cbDealer.Disabled = true;
                    }
                    this.hidInitDealerId.Text = RoleModelContext.Current.User.CorpId.Value.ToString();
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
            }
        }
        #region 数据绑定
        protected void SubBUStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet dsSubBu = _business.GetSubBU(this.cbProductLine.SelectedItem.Value);
            SubBUStore.DataSource = dsSubBu;
            SubBUStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            RefreshData(e.Start, e.Limit);
        }

        private void RefreshData(int start, int limit)
        {
            int totalCount = 0;

            DataTable query = _businessReport.QueryDealerInventoryDetail(GetQueryList(), (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            DataTable dt = _businessReport.ExportDealerInventoryDetail(GetQueryList()).Tables[0];

            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTable(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        private Hashtable GetQueryList()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerID", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLine", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbSubBu.SelectedItem.Value))
            {
                param.Add("SubBu", this.cbSubBu.SelectedItem.Value);
            }
            return param;
        }
        #endregion
    }
}