using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Common;
using Lafite.RoleModel.Security;
using DMS.Model.Data;
using System.Collections;
using System.Data;
using Microsoft.Practices.Unity;
using DMS.Business;

namespace DMS.Website.Pages.Order
{
    public partial class DealerPriceQuery : BasePage
    {
        private ICfnPriceService _cfnPrice = new CfnPriceService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(this.ProductLineStore);
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, true);
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else
                    {
                        this.Bind_DealerList(this.DealerStore);
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = GetQueryConditions();

            DataSet ds = _cfnPrice.QueryDealerPrice(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;
            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void PriceTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            IDictionary<string, string> contractStatus = DictionaryHelper.GetDictionary(SR.Consts_CFN_PriceType);
            PriceTypeStore.DataSource = contractStatus;
            PriceTypeStore.DataBind();
        }

        protected void ExportExcel(object sender, EventArgs e)
        {

            DataTable dt = _cfnPrice.ExportDealerPrice(GetQueryConditions()).Tables[0];
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTableForDealerPrice(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        private Hashtable GetQueryConditions() 
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbPriceType.SelectedItem.Value))
            {
                param.Add("PriceType", this.cbPriceType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtCfn.Text))
            {
                param.Add("CfnCode", this.txtCfn.Text);
            }

            //LP只能查看自己和下属T2价格
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            return param;
        }
    }
}
