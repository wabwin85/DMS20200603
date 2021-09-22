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

namespace DMS.Website.Pages.Order
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.None)]
    public partial class OrderConfirmation : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                if (IsDealer)
                {
                    this.cbDealer.Disabled = true;
                    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                }
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            IPurchaseOrderBLL business = new PurchaseOrderBLL();
             
                
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProblemDescription.SelectedItem.Value)) //问题描述
            {
                param.Add("ProblemDescription", this.cbProblemDescription.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value)) //经销商
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.txtSapCode.Text)) //SAPCODE
            {
                param.Add("DealerSapCode", this.txtSapCode.Text);
            }
            if (!string.IsNullOrEmpty(this.txtSAPOrderNo.Text)) //SAP订单号
            {
                param.Add("SapOrderNo", this.txtSAPOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text)) //订单号
            {
                param.Add("OrderNo", this.txtOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtArticleNumber.Text)) //产品型号
            {
                param.Add("ArticleNumber", this.txtArticleNumber.Text);
            }
            if (!this.txtStartDate.IsNull)
            {
                param.Add("SapCreateDateStart", this.txtStartDate.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtEndDate.IsNull)
            {
                param.Add("SapCreateDateEnd", this.txtEndDate.SelectedDate.ToString("yyyyMMdd"));
            }

            DataSet ds = business.GetConfirmationByFilter(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
    }
}
