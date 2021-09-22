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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderDetailWindow")]
    public partial class OrderDetailWindowForMake : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
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
            DataSet ds = _business.QueryPurchaseOrderDetailByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar2.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.DetailStore.DataSource = ds;
            this.DetailStore.DataBind();

            CaculateFormValue();
        }

        protected void OrderLogStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _business.QueryPurchaseOrderLogByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.OrderLogStore.DataSource = ds;
            this.OrderLogStore.DataBind();
        }

        protected void TerritoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            DataSet ds = _business.QueryTerritoryMaster(this.DealerId, string.IsNullOrEmpty(this.hidProductLine.Text) ? Guid.Empty : new Guid(this.hidProductLine.Text));

            this.TerritoryStore.DataSource = ds;
            this.TerritoryStore.DataBind();
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
        }
        #endregion

        #region 页面私有方法
        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.cbProductLine.Disabled = true;
            this.cbTerritory.Disabled = true;
            //经销商始终不可编辑
            this.cbDealer.Disabled = true;
            //表头
            this.txtOrderNo.ReadOnly = true;
            this.txtSubmitDate.ReadOnly = true;
            this.txtOrderStatus.ReadOnly = true;

            //汇总信息
            this.txtTotalAmount.ReadOnly = true;
            this.txtTotalQty.ReadOnly = true;
            this.txtRemark.ReadOnly = true;

            //订单信息
            this.txtContactPerson.ReadOnly = true;
            this.txtContact.ReadOnly = true;
            this.txtContactMobile.ReadOnly = true;
            this.panelRejectReason.Hidden = true;
            this.txtRejectReason.Hidden = true;

            //收货信息
            this.txtShipToAddress.ReadOnly = true;
            this.txtConsignee.ReadOnly = true;
            this.txtConsigneePhone.ReadOnly = true;
            this.dtRDD.Disabled = true;

            //切换到第一个面板
            this.TabPanel1.ActiveTabIndex = 0;

            //所有按钮都有效
            this.btnAddCfn.Disabled = true;
            this.btnAddCfnSet.Disabled = true;

            //所有面板都可见
            this.TabDetail.Disabled = false;
            this.TabLog.Disabled = false;

            this.gpDetail.ColumnModel.SetEditable(3, false);
            this.gpDetail.ColumnModel.SetEditable(4, false);
            this.gpDetail.ColumnModel.SetHidden(6, true);
        }

        /// <summary>
        /// 设置页面控件状态
        /// </summary>
        private void SetDetailWindow()
        {

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
            SetDetailWindow();
        }

        /// <summary>
        /// 清除页面控件的值
        /// </summary>
        private void ClearFormValue()
        {
            this.hidDealerId.Clear();
            this.hidProductLine.Clear();
            this.hidOrderStatus.Clear();
            this.hidEditItemId.Clear();
            this.hidTerritoryCode.Clear();
            this.hidLatestAuditDate.Clear();

            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            this.hidRtnRegMsg.Clear();

            this.cbDealer.SelectedItem.Value = "";
            this.cbProductLine.SelectedItem.Value = "";
            this.txtOrderNo.Clear();
            this.txtOrderStatus.Clear();
            this.txtSubmitDate.Clear();
            this.cbTerritory.SelectedItem.Value = "";

            this.txtTotalAmount.Clear();
            this.txtTotalQty.Clear();
            this.txtRemark.Clear();

            this.txtContactPerson.Clear();
            this.txtContact.Clear();
            this.txtContactMobile.Clear();
            this.txtRejectReason.Clear();

            this.txtShipToAddress.Clear();
            this.txtConsignee.Clear();
            this.txtConsigneePhone.Clear();
            this.dtRDD.Clear();
        }

        private void SetFormValue(PurchaseOrderHeader header)
        {
            this.DealerId = header.DmaId.Value;
            this.hidProductLine.Text = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "";
            this.PageStatus = (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), header.OrderStatus, true);
            this.hidTerritoryCode.Text = header.TerritoryCode;
            this.hidLatestAuditDate.Text = header.LatestAuditDate.HasValue ? header.LatestAuditDate.Value.ToString() : "";

            this.txtOrderNo.Text = header.OrderNo;
            this.txtOrderStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Order_Status, header.OrderStatus);
            this.txtSubmitDate.Text = header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd") : "";
            //汇总信息
            this.txtRemark.Text = header.Remark;
            //订单信息
            this.txtContactPerson.Text = header.ContactPerson;
            this.txtContact.Text = header.Contact;
            this.txtContactMobile.Text = header.ContactMobile;
            //收货信息
            this.txtShipToAddress.Text = header.ShipToAddress;
            this.txtConsignee.Text = header.Consignee;
            this.txtConsigneePhone.Text = header.ConsigneePhone;
            if (header.Rdd.HasValue)
            {
                this.dtRDD.SelectedDate = header.Rdd.Value;
            }
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
                header.ShipToAddress = dm.ShipToAddress;
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
            header.TerritoryCode = this.cbTerritory.SelectedItem.Value;
            //汇总信息
            header.Remark = this.txtRemark.Text;
            //订单信息
            header.ContactPerson = this.txtContactPerson.Text;
            header.Contact = this.txtContact.Text;
            header.ContactMobile = this.txtContactMobile.Text;
            //收货信息
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
            return header;
        }

        private void CaculateFormValue()
        {
            DataSet ds = _business.SumPurchaseOrderByHeaderId(this.InstanceId);
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                this.txtTotalQty.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2");
                this.txtTotalAmount.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2");
            }
        }

        #endregion
    }
}