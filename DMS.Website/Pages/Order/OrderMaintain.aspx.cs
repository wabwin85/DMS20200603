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
    public partial class OrderMaintain : BasePage
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        IPOReceipt PORbusiness = new DMS.Business.POReceipt();
        IShipmentBLL Shbll = new ShipmentBLL();
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
            if (!IsPostBack)
            {
                this.Bind_Dictionary(this.OrderStatusStore, SR.Consts_Order_Status);
            }
        }

        protected void ResultStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            if (!string.IsNullOrEmpty(txtSchOrderNo.Text))
            {

                int totalCount = 0;
                Hashtable ht = new Hashtable();
                ht.Add("OrderNo", txtSchOrderNo.Text);
                if (!string.IsNullOrEmpty(txtUpn.Text))
                {
                    ht.Add("UPN", txtUpn.Text);
                }
                if (!string.IsNullOrEmpty(txtLot.Text))
                {
                    ht.Add("lot", txtLot.Text);
                }
                DataSet ds = Shbll.GetShipmentlpConfirmHeaderInfoByOrderUpnLot(ht, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
                e.TotalCount = totalCount;
                ResultStore.DataSource = ds;
                ResultStore.DataBind();
            }
        }
        #region 私有方法
        private PurchaseOrderHeader GetPurchaseOrderHeader(string OrderNo)
        {
            PurchaseOrderHeader Header = _business.GetOrderByOrderNoManual(OrderNo);
            return Header;
        }
        private PoReceiptHeader GetPOReceiptHeader(string OrderNo)
        {
            PoReceiptHeader Heade = PORbusiness.GetPoReceiptHeaderByOrderNo(OrderNo);
            return Heade;
        }
        private ShipmentlpConfirmHeader GetShipmentlpConfirmHeader(string OrderNo)
        {
            ShipmentlpConfirmHeader Header = Shbll.GetShipmentlpConfirmHeaderByOrderNo(OrderNo);
            return Header;
        }
        #endregion
        #region AJAX
        [AjaxMethod] //获取订单状态
        public void GetOrderStatus()
        {
            PurchaseOrderHeader Header = this.GetPurchaseOrderHeader(this.txtOrderNo.Text);
            if (Header != null)
            {
                CbOldOrderSataus.SelectedItem.Value = Header.OrderStatus;
                BtnOrderUpdate.Disabled = false;
                lbMessing.Text = "查询完成";
            }
            else
            {
                BtnOrderUpdate.Disabled = true;
                lbMessing.Text = "订单号输入错误，没有该订单号";
            }
        }
        [AjaxMethod] //更新订单状态
        public void UpdateOrderSatatus()
        {
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            ht.Add("OperationType", "订单状态修改");
            ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了编号为" + txtOrderNo.Text + "的订单状态");
            ht.Add("OrderNo", txtOrderNo.Text);
            PurchaseOrderHeader Header = this.GetPurchaseOrderHeader(this.txtOrderNo.Text);
            if (Header != null)
            {
                Header.OrderStatus = cbOrderSatus.SelectedItem.Value;
                _business.UpdateOrderByOrder(Header);
                _business.InsertOrderOperationLog(ht);
                GetOrderStatus();
            }
            else
            {
                BtnOrderUpdate.Disabled = true;
                lbMessing.Text = "订单号输入错误，没有该订单号";
            }

        }
        [AjaxMethod] //获取发货单时间
        public void GetPoReceiptHeader()
        {
            PoReceiptHeader Head = this.GetPOReceiptHeader(txtProOrderNo.Text);
            if (Head != null)
            {
                txtOldShipmentDate.Value = Head.SapShipmentDate;
                txtOldlsiveryDate.Value = Head.SapDeliveryDate;
                BtnProUpdate.Disabled = false;
                Label1.Text = "查询完成";
            }
            else
            {
                BtnProUpdate.Disabled = true;
                Label1.Text = "发货单号输入错误，没有发货单号";
            }
        }
        [AjaxMethod]//修改发货时间和接口时间
        public void UpdatePoReceipHeaderDate()
        {
            PoReceiptHeader Head = this.GetPOReceiptHeader(txtProOrderNo.Text);
            Hashtable ht = new Hashtable();
            ht.Add("ContractUser", _context.User.Id);
            ht.Add("OperationType", "发货单发货时间、接口时间修改");
            ht.Add("Remarks", _context.UserName + "在" + DateTime.Now + "修改了编号为" + txtOrderNo.Text + "的发货单时间");
            ht.Add("OrderNo", txtOrderNo.Text);
            if (Head != null)
            {
                if (!txthiSpmentDate.IsNull)
                {
                    Head.SapShipmentDate = txthiSpmentDate.SelectedDate;
                }
                if (!txtsliveryDate.IsNull)
                {
                    Head.SapDeliveryDate = txtsliveryDate.SelectedDate;
                }
                PORbusiness.UpdatePoReceipHeaderDate(Head);
                _business.InsertOrderOperationLog(ht);
                GetPoReceiptHeader();
            }
            else
            {
                BtnProUpdate.Disabled = true;
                Label1.Text = "发货单号输入错误，没有发货单号";
            }
        }
        [AjaxMethod]//获取退货及寄售销售单确认时间
        public void GetSCHConfirmDate()
        {
            ShipmentlpConfirmHeader Header = this.GetShipmentlpConfirmHeader(txtSchOrderNo.Text);


            Renderer r = new Renderer();
            r.Fn = "SetCellCssEditable";
            GridPanel1.ColumnModel.SetRenderer(4, r);
            if (Header != null)
            {

                DataOldConfirmDate.SelectedDate = Header.ConfirmDate.Value;
                ResultStore.DataBind();
                BtnUPdateConfirmDate.Disabled = false;
                lb3.Text = "查询完成";
            }
            else
            {
                lb3.Text = "退货或寄售单号不存在";
                BtnUPdateConfirmDate.Disabled = true;
            }
        }
        [AjaxMethod]//编辑退货及寄售销售单确认时间
        public void UpdateSCHConfirmDate()
        {
            Hashtable ht = new Hashtable();
            ht.Add("ConfirmDate", DataConfirmDate.SelectedDate);
            ht.Add("OrderNo", txtSchOrderNo.Text);
            Shbll.UpdateSCHConfirmDate(ht);

            GetSCHConfirmDate();
        }
        [AjaxMethod]//修改产品价格
        public void SaveAdjustItem(string Id, string Price)
        {
            if (!string.IsNullOrEmpty(Price))
            {
                Hashtable ht = new Hashtable();
                ht.Add("Price", Price);
                ht.Add("Id", Id);
                Shbll.SaveAdjustItemPrice(ht);
                ResultStore.DataBind();
            }
            else
            {
                Ext.Msg.Alert("提示", "请输入产品价格").Show();
            }
        }
        #endregion

    }
}
