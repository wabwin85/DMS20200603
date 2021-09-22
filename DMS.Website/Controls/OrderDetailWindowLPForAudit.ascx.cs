using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DMS.Website.Common;
using Coolite.Ext.Web;
using DMS.Business;
using System.Collections;
using System.Data;
using DMS.Model.Data;
using DMS.Model;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using DMS.Common;
using Microsoft.Practices.Unity;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderDetailWindowLP")]
    public partial class OrderDetailWindowLPForAudit : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IWarehouses _warehouse = new DMS.Business.Warehouses();
        private IVirtualDC _virtualdc = new DMS.Business.VirtualDC();
        private ISpecialPriceBLL _speicalPrice = new SpecialPriceBLL();
        private IConsignmentApplyHeaderBLL hearerBll = new ConsignmentApplyHeaderBLL();
        private IAttachmentBLL _attachBll = new AttachmentBLL();
        #endregion

        #region 公开属性
        public bool IsPageNew
        {
            get
            {
                return (this.hidIsPageNew.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsPageNew.Text = value.ToString();
            }
        }

        public bool IsModified
        {
            get
            {
                return (this.hidIsModified.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsModified.Text = value.ToString();
            }
        }

        public bool IsSaved
        {
            get
            {
                return (this.hidIsSaved.Text == "True" ? true : false);
            }
            set
            {
                this.hidIsSaved.Text = value.ToString();
            }
        }

        public Guid InstanceId
        {
            get
            {
                return new Guid(this.hidInstanceId.Text);
            }
            set
            {
                this.hidInstanceId.Text = value.ToString();
            }
        }

        public Guid DealerId
        {
            get
            {
                return new Guid(this.hidDealerId.Text);
            }
            set
            {
                this.hidDealerId.Text = value.ToString();
            }
        }

        public PurchaseOrderStatus PageStatus
        {
            get
            {
                return (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), this.hidOrderStatus.Text, true);
            }
            set
            {
                this.hidOrderStatus.Text = value.ToString();
            }
        }

        public DateTime LatestAuditDate
        {
            get
            {
                return string.IsNullOrEmpty(this.hidLatestAuditDate.Text) ? DateTime.MaxValue : DateTime.Parse(this.hidLatestAuditDate.Text);
            }
        }
        #endregion

        #region 数据绑定
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && !Ext.IsAjaxRequest)
            {

            }
        }

        protected void DetailStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _business.QueryLPPurchaseOrderDetailByHeaderId(this.InstanceId, this.txtVirtualDC.Text, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

            CaculateFormValue();
        }

        protected void OrderTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {

            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Order_Type);
            //LP、T1当前支持的订单类型包括：特殊价格订单、寄售订单、普通订单、借货订单、交接订单、清指定批号订单、手工清指定批号订单
            this.OrderTypeStore.DataSource = (from t in dicts where (t.Key == PurchaseOrderType.Normal.ToString() || t.Key == PurchaseOrderType.PEGoodsReturn.ToString() || t.Key == PurchaseOrderType.EEGoodsReturn.ToString() || t.Key == PurchaseOrderType.Consignment.ToString() || t.Key == PurchaseOrderType.Borrow.ToString() || t.Key == PurchaseOrderType.Transfer.ToString() || t.Key == PurchaseOrderType.SpecialPrice.ToString() || t.Key == PurchaseOrderType.ClearBorrow.ToString() || t.Key == PurchaseOrderType.ClearBorrowManual.ToString()) select t);
            this.OrderTypeStore.DataBind();

        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _business.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }


        protected void SpecialPriceStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            //取得经销商可用的特殊价格政策
            IList<SpecialPriceMaster> list = _speicalPrice.GetSpecialPriceMasterByDealer(this.DealerId, new Guid(this.hidProductLine.Text));
            this.SpecialPriceStore.DataSource = list;
            this.SpecialPriceStore.DataBind();

        }

        protected void PointTypeStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //获取积分类型
            IDictionary<string, string> PointType = DictionaryHelper.GetDictionary(SR.PRO_PointType);
            PointTypeStore.DataSource = PointType;
            PointTypeStore.DataBind();
        }

        protected void ConsignmentStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = hearerBll.SelectConsignmentApplyProSumList(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar3.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.ConsignmentStore.DataSource = ds;
            this.ConsignmentStore.DataBind();
        }
        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = this.InstanceId;
            int totalCount = 0;

            DataSet ds = _attachBll.GetAttachmentByMainId(tid, AttachmentType.ReturnAdjust, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        #endregion

        #region Ajax Method
        [AjaxMethod]
        public void Show(string id)
        {

            this.IsPageNew = (id == Guid.Empty.ToString());
            this.IsModified = false;
            this.IsSaved = false;
            this.InstanceId = (id == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(id));

            this.InitDetailWindow();
            this.DetailWindow.Show();
            //绑定Store
            this.Bind_OrderTypeForLP(this.OrderTypeStore, SR.Consts_Order_Type);
        }



        //[AjaxMethod]
        //public void ProductLineInit()
        //{
        //    if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
        //    {
        //        //产品组初始化
        //        if (IsPageNew)
        //        {
        //            //新增单据时，更新VirtualDC
        //            IList<Virtualdc> virtualdc = _virtualdc.QueryForPlant(this.DealerId, new Guid(this.hidProductLine.Text));
        //            if (virtualdc.Count > 0)
        //            {
        //                this.txtVirtualDC.Text = virtualdc[0].Plant;
        //            }
        //        }

        //        //更新特殊价格
        //        //this.txtSpecialPrice.Clear();
        //        this.Bind_SpecialPrice(this.SpecialPriceStore);
        //        SetSpecialPrice();
        //    }
        //}

        [AjaxMethod]
        public void SetSpecialPriceHidden()
        {
            //根据选择的订单类型不同,确定是否显示特殊价格选择控件            
            SetSpecialPrice();
        }

        [AjaxMethod]
        public void SetLotNumberHidden()
        {
            //根据选择的订单类型不同,确定是否显示产品批号
            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.Transfer.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()) ||
                this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ClearBorrow.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ClearBorrowManual.ToString()) ||
                this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ConsignmentSales.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.Return.ToString()))
            {
                this.gpDetail.ColumnModel.SetHidden(9, false);
            }
            else
            {
                this.gpDetail.ColumnModel.SetHidden(9, true);
            }
        }

        [AjaxMethod]
        public void Agree()
        {
            bool result = _business.Agree(this.InstanceId);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("Agree.Alert.Body").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Agree.Alert.ErrorBody").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void Reject()
        {
            bool result = _business.Reject(this.InstanceId, this.txtRejectReason.Text);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("Reject.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Agree.Alert.ErrorBody").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void RevokeConfirm()
        {
            bool result = _business.RevokeConfirm(this.InstanceId, this.txtRejectReason.Text);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("RevokeConfirm.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("RevokeConfirm.Alert.ErrorBody").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void CompleteOrder()
        {
            bool result = _business.CompleteOrder(this.InstanceId, this.txtRejectReason.Text);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("OrderComplete.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("OrderComplete.Alert.ErrorBody").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void RejectRevoke()
        {
            bool result = _business.RejectRevoke(this.InstanceId, this.txtRejectReason.Text);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("Reject.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Reject.Alert.ErrorBody").ToString()).Show();
            }
        }

        [AjaxMethod]
        public void RejectComplete()
        {
            bool result = _business.RejectComplete(this.InstanceId, this.txtRejectReason.Text);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("Reject.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Reject.Alert.ErrorBody").ToString()).Show();
            }
        }
        #endregion

        #region 页面私有方法
        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.cbProductLine.Disabled = false;
            this.cbOrderType.Disabled = false;
            this.cbWarehouse.Disabled = false;
            this.cbPointType.Disabled = false;
            //this.cbTerritory.Disabled = false;
            //经销商始终不可编辑
            this.cbDealer.Disabled = true;

            //表头
            this.txtOrderNo.ReadOnly = true;
            this.txtSubmitDate.ReadOnly = true;
            this.txtOrderStatus.ReadOnly = true;
            this.txtOrderTo.ReadOnly = true;

            //汇总信息
            this.txtTotalAmount.ReadOnly = true;
            this.txtTotalQty.ReadOnly = true;
            this.txtRemark.ReadOnly = false;
            this.txtVirtualDC.ReadOnly = true;

            //订单信息
            this.cbSpecialPrice.Disabled = false;
            this.txtContactPerson.ReadOnly = false;
            this.txtContact.ReadOnly = false;
            this.txtContactMobile.ReadOnly = false;
            this.txt6MonthsExpProduct.ReadOnly = false;
            this.lbRejectReason.HideLabel = true;
            //this.txtRejectReason.Hidden = false;
            this.txtSpecialPrice.ReadOnly = true;

            //收货信息
            this.txtShipToAddress.ReadOnly = false;
            this.txtConsignee.ReadOnly = false;
            this.txtConsigneePhone.ReadOnly = false;
            this.dtRDD.Disabled = false;
            this.txtCarrier.ReadOnly = false;

            //切换到第一个面板
            this.TabPanel1.ActiveTabIndex = 0;

            //所有面板都可见
            this.TabDetail.Disabled = false;
            this.TabLog.Disabled = false;

            //特殊价格政策不可见
            this.cbSpecialPrice.Hidden = true;
            this.txtSpecialPrice.Hidden = true;
            this.pPolicyContent.Hide();

            //积分订单
            this.cbPointType.Hidden = true;

            //短期寄售订单汇总结果
            this.tabConsDetail.Disabled = true;

            this.gpDetail.ColumnModel.SetEditable(3, false);
            this.gpDetail.ColumnModel.SetEditable(6, false);
            this.gpDetail.ColumnModel.SetEditable(9, false);
            this.gpDetail.ColumnModel.SetHidden(16, true);
            this.gpDetail.ColumnModel.SetHidden(17, true);
            this.gpDetail.ColumnModel.SetHidden(18, true);


            this.ReceivingWay.Enabled = false;
            this.Texthospitalname.ReadOnly = true;
            this.HospitalAddress.ReadOnly = true;
        }

        /// <summary>
        /// 设置页面控件状态
        /// </summary>
        private void SetDetailWindow(PurchaseOrderHeader header)
        {

            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {



                if (header.OrderStatus.Equals(PurchaseOrderStatus.Approved.ToString()) || header.OrderStatus.Equals(PurchaseOrderStatus.Submitted.ToString()) || header.OrderStatus.Equals(PurchaseOrderStatus.Uploaded.ToString()))
                {
                    this.btnAgree.Show();
                    this.lbRejectReason.HideLabel = true;
                    this.txtRejectReason.Hidden = true;
                }
                else
                {
                    this.btnAgree.Hide();
                }

                if (header.OrderStatus.Equals(PurchaseOrderStatus.Revoking.ToString()))
                {
                    this.btnRevokeConfirm.Show();
                    this.btnRejectRevoke.Show();
                    this.lbRejectReason.HideLabel = false;
                    this.txtRejectReason.Hidden = false;

                }
                else
                {
                    this.btnRevokeConfirm.Hide();
                    this.btnRejectRevoke.Hide();
                }

                if (header.OrderStatus.Equals(PurchaseOrderStatus.ApplyComplete.ToString()))
                {
                    this.btnOrderComplete.Show();
                    this.btnRejectComplete.Show();
                    this.lbRejectReason.HideLabel = false;
                    this.txtRejectReason.Hidden = false;
                }
                else
                {
                    this.btnOrderComplete.Hide();
                    this.btnRejectComplete.Hide();
                }





            }
            else
            {
                this.btnAgree.Hide();
                //this.btnReject.Hide();
                this.btnRevokeConfirm.Hide();
                this.btnOrderComplete.Hide();
                this.lbRejectReason.HideLabel = true;
                this.txtRejectReason.Hidden = true;
            }

            this.cbProductLine.Disabled = true;
            this.cbOrderType.Disabled = true;
            this.cbWarehouse.Disabled = true;
            this.cbSpecialPrice.Disabled = true;
            this.cbPointType.Disabled = true;

            this.txtRemark.ReadOnly = true;
            this.txtContactPerson.ReadOnly = true;
            this.txtContact.ReadOnly = true;
            this.txtContactMobile.ReadOnly = true;
            this.txt6MonthsExpProduct.ReadOnly = true;
            this.txtConsignee.ReadOnly = true;
            this.txtConsigneePhone.ReadOnly = true;
            this.dtRDD.Disabled = true;
            this.txtCarrier.ReadOnly = true;

            this.gpDetail.ColumnModel.SetHidden(7, true);
            this.gpDetail.ColumnModel.SetHidden(8, true);

            if (header.OrderType.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                this.cbPointType.Hidden = false;
                this.gpDetail.ColumnModel.SetHidden(16, false);
            }
            if (header.OrderType.Equals(PurchaseOrderType.ClearBorrowManual.ToString()))
            {
                this.gpDetail.ColumnModel.SetHidden(17, false);
                this.gpDetail.ColumnModel.SetHidden(18, false);
            }

            if (header != null && header.OrderType == PurchaseOrderType.Consignment.ToString())
            {
                this.tabConsDetail.Disabled = false;
            }
        }

        /// <summary>
        /// 初始化页面
        /// </summary>
        private void InitDetailWindow()
        {
            PurchaseOrderHeader header = null;
            if (IsPageNew)
            {
                header = GetNewPurchaseOrderHeader();
            }
            else
            {
                header = _business.GetPurchaseOrderHeaderById(this.InstanceId);
            }
            //页面赋值
            ClearFormValue();
            SetFormValue(header);
            //页面控件状态
            ClearDetailWindow();
            SetDetailWindow(header);
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            //
            this.Deliver.Checked = false;
            this.PickUp.Checked = false;
            this.hidDealerId.Clear();
            this.hidProductLine.Clear();
            this.hidOrderStatus.Clear();
            this.hidEditItemId.Clear();
            this.hidTerritoryCode.Clear();
            this.hidLatestAuditDate.Clear();

            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            this.hidRtnRegMsg.Clear();

            this.hidOrderType.Clear();
            this.hidWarehouse.Clear();
            this.hidWareHouseType.Clear();
            this.hidPriceType.Clear();
            this.hidSpecialPrice.Clear();
            this.hidUpdateDate.Clear();


            this.cbDealer.SelectedItem.Value = "";
            this.cbProductLine.SelectedItem.Value = "";
            this.txtOrderNo.Clear();
            this.txtOrderStatus.Clear();
            this.txtSubmitDate.Clear();

            this.txtOrderTo.Clear();
            this.cbOrderType.SelectedItem.Value = "";
            this.cbWarehouse.SelectedItem.Value = "";

            this.hidPointType.Clear();
            this.cbPointType.SelectedItem.Value = "";

            this.txtTotalAmount.Clear();
            this.txtTotalQty.Clear();
            this.txtRemark.Clear();
            this.txtVirtualDC.Clear();

            this.cbSpecialPrice.SelectedItem.Value = "";
            this.txtSpecialPrice.Clear();
            this.taPolicyContent.Clear();
            this.txtContactPerson.Clear();
            this.txtContact.Clear();
            this.txtContactMobile.Clear();
            this.txt6MonthsExpProduct.Clear();
            this.txtRejectReason.Clear();

            this.txtShipToAddress.Clear();
            this.txtConsignee.Clear();
            this.txtConsigneePhone.Clear();
            this.dtRDD.Clear();
            this.txtCarrier.Clear();
            //订单币种维护
            this.txtCurrency.Text = "";

            this.txtMHD.Clear();
        }

        private void SetFormValue(PurchaseOrderHeader header)
        {
            //表头信息
            this.DealerId = header.DmaId.Value;
            this.hidProductLine.Text = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "";
            this.PageStatus = (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), header.OrderStatus, true);

            this.hidLatestAuditDate.Text = header.LatestAuditDate.HasValue ? header.LatestAuditDate.Value.ToString() : "";

            this.txtOrderNo.Text = header.OrderNo;
            this.txtOrderStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Order_Status, header.OrderStatus);

            this.hidOrderType.Text = header.OrderType;
            if (string.IsNullOrEmpty(header.Vendorid))
            {

                this.txtOrderTo.Text = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).ChineseName;

            }
            else
            {
                this.txtOrderTo.Text = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).ChineseName;
            }

            this.txtSubmitDate.Text = header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd HH:mm:ss") : "";

            //汇总信息
            this.txtRemark.Text = header.Remark;
            this.txtVirtualDC.Text = header.Virtualdc;
            //订单信息            
            this.hidSpecialPrice.Text = header.SpecialPriceid.HasValue ? header.SpecialPriceid.Value.ToString() : "";
            //if (header.SpecialPriceid.HasValue)
            //{
            //    this.txtSpecialPrice.Text = _speicalPrice.GetSpecialPriceMasterByID(header.SpecialPriceid.Value).Code;
            //}
            this.txtContactPerson.Text = header.ContactPerson;
            this.txtContact.Text = header.Contact;
            this.txtContactMobile.Text = header.ContactMobile;
            this.txt6MonthsExpProduct.Text = header.InvoiceComment;

            //收货信息
            this.hidWarehouse.Text = header.WhmId.HasValue ? header.WhmId.Value.ToString() : "";
            this.txtShipToAddress.Text = header.ShipToAddress;
            this.txtConsignee.Text = header.Consignee;
            this.txtConsigneePhone.Text = header.ConsigneePhone;
            this.Texthospitalname.Text = header.SendHospital;
            this.HospitalAddress.Text = header.SendAddress;
            if (header.DcType == "PickUp")
            {
                this.PickUp.Checked = true;
                this.Deliver.Checked = false;
            }
            if (header.DcType == "Deliver" || header.DcType == null)
            {
                this.Deliver.Checked = true;
                this.PickUp.Checked = false;
            }
            this.txtCarrier.Text = header.TerritoryCode;//将区域代码字段用作承运商信息
            this.hidTerritoryCode.Text = header.TerritoryCode; //承运商信息
            if (header.Rdd.HasValue)
            {
                this.dtRDD.SelectedDate = header.Rdd.Value;
            }
            //设定期望到货日期只能选取当前时间之后的日期
            this.dtRDD.MinDate = DateTime.Now.AddDays(1);

            this.hidPohId.Text = header.PohId.HasValue ? header.PohId.Value.ToString() : "";
            this.hidCreateType.Text = header.CreateType;
            this.hidUpdateDate.Text = header.UpdateDate.ToString();

            //如果是组套设备订单，则获取一个百分比
            if (header.OrderType.Equals(PurchaseOrderType.BOM.ToString()) || header.OrderType.Equals(PurchaseOrderType.SpecialPrice.ToString()))
            {
                this.txtMHD.Hidden = false;
                this.txtMHD.Text = _speicalPrice.GetBOMOrderManHeaderDisc(header.Id.ToString()).ToString();
            }
            else
            {
                this.txtMHD.Hidden = true;
            }
            if (header.OrderType.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                this.hidPointType.Text = header.PointType;
            }

            Hashtable objCurrency = new Hashtable();
            objCurrency.Add("SubmintDate", header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd") : DateTime.Now.ToShortDateString());
            objCurrency.Add("DealerId", header.DmaId.Value);
            this.txtCurrency.Text = _business.GetPurchaseOrderCarrierById(objCurrency);
        }

        private PurchaseOrderHeader GetNewPurchaseOrderHeader()
        {
            PurchaseOrderHeader header = new PurchaseOrderHeader();
            header.Id = this.InstanceId;
            header.DmaId = _context.User.CorpId.Value;
            header.OrderStatus = PurchaseOrderStatus.Draft.ToString();
            header.CreateUser = new Guid(_context.User.Id);
            header.CreateDate = DateTime.Now;
            header.CreateType = PurchaseOrderCreateType.Manual.ToString();
            header.LastVersion = 0;

            //取得订单联系人和收货信息
            DealerMaster dm = _business.GetDealerMasterByDealer(header.DmaId.Value);
            if (dm != null)
            {
                header.TerritoryCode = dm.Certification; //承运商信息
            }
            DealerShipTo dsh = _business.GetDealerShipToByUser(new Guid(_context.User.Id));
            if (dsh != null)
            {
                header.ContactPerson = dsh.ContactPerson;
                header.Contact = dsh.Contact;
                header.ContactMobile = dsh.ContactMobile;
                header.Consignee = dsh.Consignee;
                header.ConsigneePhone = dsh.ConsigneePhone;
            }


            _business.InsertPurchaseOrderHeader(header);
            return header;
        }

        private PurchaseOrderHeader GetFormValue()
        {
            PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(this.InstanceId);
            header.ProductLineBumId = string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value) ? null as Guid? : new Guid(this.cbProductLine.SelectedItem.Value);
            header.OrderType = string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value) ? "" : this.cbOrderType.SelectedItem.Value;
            //header.TerritoryCode = this.cbTerritory.SelectedItem.Value;
            //汇总信息
            header.Remark = this.txtRemark.Text;
            header.Virtualdc = this.txtVirtualDC.Text;
            //订单信息
            //如果OrderType不是特殊价格订单，则Header表中的SpecialPriceid为空
            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
            {
                header.SpecialPriceid = string.IsNullOrEmpty(this.cbSpecialPrice.SelectedItem.Value) ? null as Guid? : new Guid(this.cbSpecialPrice.SelectedItem.Value);
            }
            else
            {
                header.SpecialPriceid = null as Guid?;
            }
            header.ContactPerson = this.txtContactPerson.Text;
            header.Contact = this.txtContact.Text;
            header.ContactMobile = this.txtContactMobile.Text;
            header.InvoiceComment = this.txt6MonthsExpProduct.Text;
            //收货信息
            header.WhmId = string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value) ? null as Guid? : new Guid(this.cbWarehouse.SelectedItem.Value);
            header.ShipToAddress = this.txtShipToAddress.Text;
            header.Consignee = this.txtConsignee.Text;
            header.ConsigneePhone = this.txtConsigneePhone.Text;
            if (this.dtRDD.SelectedDate > DateTime.MinValue)
            {
                header.Rdd = this.dtRDD.SelectedDate;
            }
            else
            {
                header.Rdd = null;
            }
            //承运商信息
            header.TerritoryCode = this.txtCarrier.Text;

            header.PohId = string.IsNullOrEmpty(this.hidPohId.Text) ? null as Guid? : new Guid(this.hidPohId.Text);
            header.CreateType = this.hidCreateType.Text;

            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                header.PointType = string.IsNullOrEmpty(this.cbPointType.SelectedItem.Value) ? "" : this.cbSpecialPrice.SelectedItem.Value;
            }
            else
            {
                header.PointType = "";
            }
            return header;
        }

        private void CaculateFormValue()
        {
            DataSet ds = _business.SumPurchaseOrderByHeaderId(this.InstanceId);
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                this.txtTotalQty.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2");
                //Edit By Songweiming on 2013-11-18 如果是近效期退换货或者是非近效期退换货订单，则金额为0
                if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.PEGoodsReturn.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.EEGoodsReturn.ToString()) ||
                    this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.PRO.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.Return.ToString()))
                {
                    this.txtTotalAmount.Text = Convert.ToDecimal(0).ToString("F2");
                    this.txtTotalAmountNoTax.Text = Convert.ToDecimal(0).ToString("F2");
                }
                else if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    this.txtTotalAmount.Text = (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"])).ToString("F2");
                    this.txtTotalAmountNoTax.Text = (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmountNoTax"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmountNoTax"])).ToString("F2");
                }
                else
                {
                    this.txtTotalAmount.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2");
                    this.txtTotalAmountNoTax.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmountNoTax"]).ToString("F2");
                }


            }
        }

        //
        protected void Bind_SpecialPrice(Store store)
        {
            //if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            //{
            //    IList<SpecialPriceMaster> list = _speicalPrice.GetSpecialPriceMasterByDealer(this.DealerId, new Guid(this.cbProductLine.SelectedItem.Value));
            //    store.DataSource = list;
            //    store.DataBind();
            //}

            DataSet ds = null;
            ds = _speicalPrice.GetPromotionPolicyById(this.InstanceId);
            store.DataSource = ds;
            store.DataBind();
        }

        protected void SetSpecialPrice()
        {
            //更新特殊价格
            this.txtSpecialPrice.Clear();
            this.Bind_SpecialPrice(this.SpecialPriceStore);


            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
            {
                this.cbSpecialPrice.Hidden = false;
                this.txtSpecialPrice.Hidden = false;
                this.pPolicyContent.Show();
            }
            else
            {
                this.cbSpecialPrice.Hidden = true;
                this.txtSpecialPrice.Hidden = true;
                this.pPolicyContent.Hide();
            }
        }


        protected internal virtual void Bind_OrderTypeForLP(Store store, string type)
        {
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            //如果单据状态是草稿状态或订单的类型是Temporary，则只显示特殊价格订单、普通订单、交接订单
            if (this.PageStatus.ToString().Equals(PurchaseOrderStatus.Draft.ToString()) || this.hidCreateType.Text.Equals(PurchaseOrderCreateType.Temporary.ToString()))
            {
                store.DataSource = (from t in dicts
                                    where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                           t.Key == PurchaseOrderType.Transfer.ToString() ||
                                           t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                           t.Key == PurchaseOrderType.ClearBorrow.ToString() ||
                                           t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                           t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                           t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                           t.Key == PurchaseOrderType.CRPO.ToString() ||
                                           t.Key == PurchaseOrderType.PRO.ToString() ||
                                           t.Key == PurchaseOrderType.Return.ToString()
                                           )
                                    select t);

            }
            else
            {
                store.DataSource = (from t in dicts select t);
            }
            store.DataBind();
        }

        #endregion

        [AjaxMethod]
        public void DoAddItems(string cfnstring)
        {
            _business.AddNoticeCfn(this.InstanceId, cfnstring);
        }
    }
}