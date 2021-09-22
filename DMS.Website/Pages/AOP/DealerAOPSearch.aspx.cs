using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DMS.Website.Pages.AOP
{
    using DMS.Website.Common;
    using Lafite.RoleModel.Security;
    using Coolite.Ext.Web;
    using DMS.Model.Data;
    using System.Collections;
    using System.Data;
    using DMS.Business;
    using DMS.Common;

    public partial class DealerAOPSearch : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IAopDealerBLL _aopDealerBll = new AopDealerBLL();

        #endregion
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerList(this.DealerStore);

                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                        {
                            this.cbDealer.Disabled = true;
                        }
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                }
            }
        }

        protected void MarketTypeStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("MarketTypeId");
            dt.Columns.Add("MarketTypeName");
            dt.Rows.Add("0", "普通市场");
            dt.Rows.Add("1", "新兴市场");
            dt.Rows.Add("2", "全部市场");
            this.MarketTypeStore.DataSource = dt;
            this.MarketTypeStore.DataBind();
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            int start= e.Start;
            int limit=e.Limit;
            Hashtable param= RefreshData();
            DataTable query = _aopDealerBll.GetAopDealersByFiller(param, (start == -1 ? 0 : start), (limit == -1 ? this.PagingToolBar1.PageSize : limit), out totalCount).Tables[0];

            (this.ResultStore.Proxy[0] as DataSourceProxy).TotalCount = totalCount;

            this.ResultStore.DataSource = query;
            this.ResultStore.DataBind();
        }

        private Hashtable RefreshData()
        {
            Hashtable param = new Hashtable();
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DealerDmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbMarketType.SelectedItem.Value))
            {
                param.Add("MarketType", this.cbMarketType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.tfYear.Text))
            {
                param.Add("Year", this.tfYear.Text);
            }
            param.Add("OwnerIdentityType", this._context.User.IdentityType);
            param.Add("OwnerCorpId", this._context.User.CorpId);
            return param;
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            Hashtable param = RefreshData();
            DataTable dt = _aopDealerBll.ExporAopDealersByFiller(param).Tables[0];//dt是从后台生成的要导出的datatable
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
    }
}
