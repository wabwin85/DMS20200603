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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderApplyLP")]
    public partial class OrderApplyLP : BasePage
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
            this.hidCorpType.Text = "";

            if (IsDealer)
            {
                this.hidCorpType.Text = RoleModelContext.Current.User.CorpType;

            }

            if (!IsPostBack && !Ext.IsAjaxRequest)
            {                
                this.btnInsert.Visible = IsDealer;
                this.btnImport.Visible = IsDealer;
               
                this.Bind_ProductLine(this.ProductLineStore);
                //this.Bind_DealerList(this.DealerStore);
                this.Bind_Dictionary(this.OrderStatusStore, SR.Consts_Order_Status);
                this.Bind_OrderTypeForLP(this.OrderTypeStore, SR.Consts_Order_Type);



                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        this.Bind_DealerList(this.DealerStore);
                        this.cbDealer.Disabled = true;
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ORDERNEW);
                    }
                    else
                    {
                        this.Bind_DealerListByFilter(this.DealerStore, false);
                    }
                }
                else
                {
                    this.Bind_DealerList(this.DealerStore);
                   
                }


                //else
                //{
                //}
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                this.btnSearch.Visible = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApplyLP, PermissionType.Read);

                //如果使用此菜单功能的人员不是物流平台或一级经销商，则不可以使用新增和导入功能
                this.btnInsert.Disabled = false;
                this.btnImport.Disabled = false;
                this.btnStockprice.Disabled = false;
                if (!IsDealer)
                {
                    this.btnInsert.Disabled = true;
                    this.btnImport.Disabled = true;
                    
                }
                else if (!RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && !RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) && !RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                {
                    this.btnInsert.Disabled = true;
                    this.btnImport.Disabled = true;
                    this.btnStockprice.Disabled = true;

                }
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
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
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
            if (!string.IsNullOrEmpty(this.txRemark.Text))
            {
                param.Add("Remark", this.txRemark.Text);
            }

            //只能查询自己下的订单
            //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {
                param.Add("IsHQ", "True");
            }
            DataSet ds = business.QueryPurchaseOrderHeaderForLPDealer(param, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);

            e.TotalCount = totalCount;

            this.ResultStore.DataSource = ds;
            this.ResultStore.DataBind();
        }

        protected void AjaxEvents_SubmitToExcel(object sender, AjaxEventArgs e)
        {
            e.Success = true;
        }

        protected void ExportExcel(object sender, EventArgs e)
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
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
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

            //只能查询自己下的订单
            //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {
                param.Add("IsHQ", "True");
            }


            DataTable dt = business.ExportPurchaseOrderLogForLPDealer(param).Tables[0];//dt是从后台生成的要导出的datatable
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

        protected void ExportInvoice(object sender, EventArgs e)
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
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
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

            //只能查询自己下的订单
            //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {
                param.Add("IsHQ", "True");
            }


            DataTable dt = business.ExportPurchaseOrderInvoiceForLPDealer(param).Tables[0];//dt是从后台生成的要导出的datatable
            this.Response.Clear();
            this.Response.Buffer = true;
            this.Response.AppendHeader("Content-Disposition", "attachment;filename=result.xls");
            this.Response.ContentEncoding = System.Text.Encoding.UTF8;
            this.Response.ContentType = "application/vnd.ms-excel";
            this.EnableViewState = false;
            this.Response.Write(ExportHelp.AddExcelHead());//显示excel的网格线
            this.Response.Write(ExportHelp.ExportTableForPurchaseOrderInvoiceForLPDealer(dt));//导出
            this.Response.Write(ExportHelp.AddExcelbottom());//显示excel的网格线
            this.Response.Flush();
            this.Response.End();
        }

        protected void ExportDetail(object sender, EventArgs e)
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
            if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value))
            {
                param.Add("OrderType", this.cbOrderType.SelectedItem.Value);
            }
            if (!string.IsNullOrEmpty(this.cbOrderStatus.SelectedItem.Value))
            {
                param.Add("OrderStatus", this.cbOrderStatus.SelectedItem.Value);
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
            if (!string.IsNullOrEmpty(this.txRemark.Text))
            {
                param.Add("Remark", this.txRemark.Text);
            }

            //只能查询自己下的订单
            //BSC用户可以看所有订单，经销商用户只能看自己创建的订单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString())))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {
                param.Add("IsHQ", "True");
            }
            
            
           

            DataTable dt = business.ExportPurchaseOrderDetailForLPDealer(param).Tables[0];//dt是从后台生成的要导出的datatable

         
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
        protected internal virtual void Bind_OrderTypeForLP(Store store, string type)
        {
            //物流平台、一级经销商可以查看普通订单、特殊价格订单、寄售订单、寄售销售订单、交接订单、清指定批号订单、成套设备订单、虚拟寄售单，虚拟清货单
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            store.DataSource = (from t in dicts where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                       t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                       t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                       t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                       t.Key == PurchaseOrderType.Consignment.ToString() ||
                                                       t.Key == PurchaseOrderType.ConsignmentSales.ToString() ||
                                                       t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                       t.Key == PurchaseOrderType.ClearBorrow.ToString() ||
                                                       t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                                       t.Key == PurchaseOrderType.BOM.ToString() ||
                                                       t.Key == PurchaseOrderType.PRO.ToString()||
                                                       t.Key == PurchaseOrderType.CRPO.ToString() ||
                                                       t.Key == PurchaseOrderType.SampleApply.ToString() ||
                                                       t.Key == PurchaseOrderType.ZTKB.ToString() ||
                                                       t.Key == PurchaseOrderType.ZTKA.ToString() ||
                                                       t.Key == PurchaseOrderType.ConsignmentReturn.ToString() ||
                                                       t.Key == PurchaseOrderType.Return.ToString())
                                select t);
            store.DataBind();

        }

        [AjaxMethod]
        public void CopyForTemporary(string id)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            Guid instanceId = Guid.NewGuid();
            this.hidNewOrderInstanceId.Text = instanceId.ToString();
            //先判断一下单据当前状态，如果已被确认或者订单状态不是“已提交”或“已进入SAP”
            IPurchaseOrderBLL _business = new PurchaseOrderBLL();
            PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(new Guid(id));
            if (header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Uploaded.ToString())
            {
                bool result = _business.CopyForTemporary(new Guid(id), instanceId, out rtnVal, out rtnMsg);
                this.hidRtnVal.Text = rtnVal;
                this.hidRtnMsg.Text = rtnMsg;
            }
            else
            {
                this.hidRtnVal.Text = "statusChange";
                
            }


            
        }

        [AjaxMethod]
        public void BindPrintUrl(string id)
        {
            WindowPrintOrderSet.AutoLoad.Url = "OrderPrint.aspx?OrderID=" + id;
            this.WindowPrintOrderSet.LoadContent();
            this.WindowPrintOrderSet.Show();
        }


    }
}
