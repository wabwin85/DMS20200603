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
    public partial class OrderAudit : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = null;

        [Dependency]
        public IPurchaseOrderBLL business
        {
            get { return _business; }
            set { _business = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {
                this.Bind_ProductLine(this.ProductLineStore);
                this.Bind_DealerList(this.DealerStore);
                this.Bind_OrderStatus(this.OrderStatusStore, SR.Consts_Order_Status);
                this.Bind_OrderTypeForLP(this.OrderTypeStore, SR.Consts_Order_Type);
                
                //if (IsDealer)
                //{
                    
                //    this.cbDealer.Disabled = true;
                //    this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                //    //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ORDERNEW);
                //}
                //else
                //{
                //}
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderAudit, PermissionType.Read);
                
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                param.Add("OrderNo", this.txtOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCfn.Text))
            {
                param.Add("Cfn", this.txtCfn.Text);
            }
            if (!string.IsNullOrEmpty(this.Remark.Text))
            {
                param.Add("Remark", this.Remark.Text);
            }

            DataSet ds = business.QueryPurchaseOrderHeaderForAudit(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }
               
       
        protected internal virtual void Bind_OrderStatus(Store store, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            store.DataSource = dicts.ToList().FindAll(item => item.Key == PurchaseOrderStatus.Submitted.ToString() ||
                                                              item.Key == PurchaseOrderStatus.Uploaded.ToString() ||
                                                              item.Key == PurchaseOrderStatus.Confirmed.ToString() ||                                                             
                                                              item.Key == PurchaseOrderStatus.Delivering.ToString() ||
                                                              item.Key == PurchaseOrderStatus.Completed.ToString() ||
                                                              item.Key == PurchaseOrderStatus.ApplyComplete.ToString() ||
                                                              item.Key == PurchaseOrderStatus.Approved.ToString() ||
                                                              item.Key == PurchaseOrderStatus.Revoked.ToString() || 
                                                              item.Key == PurchaseOrderStatus.Revoking.ToString());
            store.DataBind();
        }

        protected internal virtual void Bind_OrderTypeForLP(Store store, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            store.DataSource = (from t in dicts where (t.Key == PurchaseOrderType.Normal.ToString() || 
                                                       t.Key == PurchaseOrderType.EEGoodsReturn.ToString() || 
                                                       t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                       t.Key == PurchaseOrderType.Consignment.ToString() || 
                                                       t.Key == PurchaseOrderType.Borrow.ToString() || 
                                                       t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                       t.Key == PurchaseOrderType.SpecialPrice.ToString() || 
                                                       t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                                       t.Key == PurchaseOrderType.ClearBorrow.ToString() || 
                                                       t.Key == PurchaseOrderType.BOM.ToString() ||
                                                       t.Key == PurchaseOrderType.PRO.ToString() || 
                                                       t.Key == PurchaseOrderType.CRPO.ToString() || 
                                                       t.Key == PurchaseOrderType.SampleApply.ToString() || 
                                                       t.Key == PurchaseOrderType.ZTKB.ToString() ||
                                                       t.Key == PurchaseOrderType.ZTKA.ToString() ||
                                                       t.Key == PurchaseOrderType.ConsignmentReturn.ToString() ||
                                                       t.Key == PurchaseOrderType.Return.ToString())
                                select t);
            store.DataBind();

        }

        protected void ExportExcel(object sender, EventArgs e)
        {

            int totalCount = 0;

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                param.Add("ProductLineBumId", this.cbProductLine.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbDealer.SelectedItem.Value))
            {
                param.Add("DmaId", this.cbDealer.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!this.txtSubmitDateStart.IsNull)
            {
                param.Add("SubmitDateStart", this.txtSubmitDateStart.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!this.txtSubmitDateEnd.IsNull)
            {
                param.Add("SubmitDateEnd", this.txtSubmitDateEnd.SelectedDate.ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(this.txtOrderNo.Text))
            {
                param.Add("OrderNo", this.txtOrderNo.Text);
            }
            if (!string.IsNullOrEmpty(this.txtCfn.Text))
            {
                param.Add("Cfn", this.txtCfn.Text);
            }

            DataTable dt = business.ExportPurchaseOrderLogForLPDealerForAudit(param).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTableForPurchaseOrderLogForLPDealer(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }
    }
}
