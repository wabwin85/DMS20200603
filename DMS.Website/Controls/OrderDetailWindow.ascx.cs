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
using System.IO;

namespace DMS.Website.Controls
{
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderDetailWindow")]
    public partial class OrderDetailWindow : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IWarehouses _warehouse = new DMS.Business.Warehouses();
        private IContractMaster _contractMaster = new ContractMaster();
        private IInventoryAdjustBLL _invAdjBiz = new InventoryAdjustBLL();
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
                string aa = RoleModelContext.Current.User.LoginId.ToString();
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

        protected void OrderTypeStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {

            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_Order_Type);
            //如果单据状态是草稿状态,则只显示普通订单、寄售订单
            if (this.PageStatus.ToString().Equals(PurchaseOrderStatus.Draft.ToString()))
            {
                this.OrderTypeStore.DataSource = (from t in dicts
                                                  where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                         t.Key == PurchaseOrderType.Consignment.ToString() ||
                                                         t.Key == PurchaseOrderType.Exchange.ToString() ||
                                                         t.Key == PurchaseOrderType.BOM.ToString() ||
                                                         t.Key == PurchaseOrderType.SCPO.ToString() ||
                                                         t.Key == PurchaseOrderType.PRO.ToString() ||
                                                         t.Key == PurchaseOrderType.CRPO.ToString())
                                                  select t);

            }
            else
            {
                this.OrderTypeStore.DataSource = (from t in dicts select t);
            }
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

        //DMS不需要区域
        //protected void TerritoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    DataSet ds = _business.QueryTerritoryMaster(this.DealerId, string.IsNullOrEmpty(this.hidProductLine.Text) ? Guid.Empty : new Guid(this.hidProductLine.Text));

        //    this.TerritoryStore.DataSource = ds;
        //    this.TerritoryStore.DataBind();
        //}

        //protected void SalesStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    Hashtable ht = new Hashtable();
        //    DataSet ds = new DataSet();
        //    //ht.Add("ProductLineBumId", this.hidProductLine.Value);
        //    ht.Add("ProductLineId", this.hidProductLine.Value);
        //    ht.Add("DealerID", this.DealerId);
        //    //DataSet ds = _business.SelectSalesByDealerAndProductLine(ht);
        //    if (IsPageNew || this.PageStatus == PurchaseOrderStatus.Draft)
        //    {
        //        //如果是新添加的订单则在SelectT_I_QV_SalesRepDealer取RSM
        //        ds = _invAdjBiz.SelectT_I_QV_SalesRepDealerByProductLine(ht);              
        //    }
        //    else
        //    {
        //        //如果是历史订单则在interface.T_I_QV_SalesRep 取
        //        ds = _invAdjBiz.SelectT_I_QV_SalesRepByProductLine(ht);

        //    }
                      
        //    //改用退货中选RSM的方法，此方法不再使用
        //    //if (ds.Tables[0].Rows.Count > 0 && this.PageStatus == PurchaseOrderStatus.Draft)
        //    //{
        //    //    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        //    //    {
        //    //        if (ds.Tables[0].Rows[i]["SapCode"].ToString() == "0")
        //    //        {
        //    //            ds.Tables[0].Rows.Remove(ds.Tables[0].Rows[i]);
        //    //            i = i - 1;
        //    //        }
        //    //    }
        //    //}

        //    this.SalesStore.DataSource = ds;
        //    this.SalesStore.DataBind();
        //}
        protected void PointTypeStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            //获取积分类型
            IDictionary<string, string> PointType = DictionaryHelper.GetDictionary(SR.PRO_PointType);
            PointTypeStore.DataSource = PointType;
            PointTypeStore.DataBind();
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

        [AjaxMethod]
        public void SaveDraft()
        {
            PurchaseOrderHeader header = this.GetFormValue();
            bool result = _business.SaveDraft(header);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void DeleteDraft()
        {
            bool result = _business.DeleteDraft(this.InstanceId);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void CheckSubmit()
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;
            string rtnval1 = string.Empty;
            string rtnMsg1 = string.Empty;

            if (cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.PRO.ToString()) || cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                _business.CheckSubmit(this.InstanceId, this.DealerId, "", this.hidPriceType.Text, this.hidOrderType.Text, out rtnVal, out rtnMsg);

                if (rtnVal == "Success" || rtnVal == "Warn")
                {
                    // _business.RedInvoice_SumbitChecked(this.InstanceId.ToString(), this.DealerId.ToString(), cbProductLine.SelectedItem.Value, this.hidPointType.Text, this.hidOrderType.Text, out rtnval1, out rtnMsg1);
                    this.hidRtnVal.Text = "Success";
                }
                else
                {
                    this.hidRtnVal.Text = "Error";
                }

                //if (rtnVal == "Warn" && rtnval1 == "Success")
                //{
                //    this.hidRtnVal.Text = "Warn";
                //}
                //else if (rtnVal == "Success" && rtnval1 == "Success")
                //{
                //    this.hidRtnVal.Text = "Success";
                //}
                //else
                //{
                //    this.hidRtnVal.Text = "Error";
                //}
                this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>") + rtnMsg1;
            }
            else
            {
                bool result = _business.CheckSubmit(this.InstanceId, this.DealerId, "00000000-0000-0000-0000-000000000000", this.hidPriceType.Text, "", out rtnVal, out rtnMsg);
                this.hidRtnVal.Text = rtnVal;
                this.hidRtnMsg.Text = rtnMsg;
                //Deleted By Song Yuqi On 2016-05-31 

                //DealerMasters dm = new DealerMasters();
                //DataSet dsp = dm.GetProductLineByDealer(RoleModelContext.Current.User.CorpId.Value);

                //Hashtable ht = new Hashtable();
                //ht.Add("Dma_id", this.DealerId);
                //ht.Add("Productline_id", string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value) ? dsp.Tables[0].Rows[0]["Id"].ToString() : this.cbProductLine.SelectedItem.Value);

                //DataSet ds = _contractMaster.SelectActiveContractCount(ht);
                //if (ds.Tables.Count > 0 && ds.Tables[0].Rows[0]["CNT"].ToString() == "0")
                //{
                //    rtnVal = "Error";
                //    rtnMsg = "该产品线的合同已到期，请重新修改！！";
                //}
            }
        }

        [AjaxMethod]
        public void Submit()
        {
            PurchaseOrderHeader header = this.GetFormValue();
            bool result = _business.Submit(header, "");
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void ChangeProductLine()
        {
            //更换产品组，删除订单原产品组下的所有产品
            bool result = _business.DeleteDetail(this.InstanceId);
        }

        [AjaxMethod]
        public void DeleteItem(string id)
        {
            bool result = _business.DeleteCfn(new Guid(id));
        }

        [AjaxMethod]
        public void UpdateItem(string qty, string amt)
        {
            Guid detailId = new Guid(this.hidEditItemId.Text);
            PurchaseOrderDetail detail = _business.GetPurchaseOrderDetailById(detailId);

            if (!string.IsNullOrEmpty(qty))
            {
                detail.RequiredQty = Convert.ToDecimal(qty);
                detail.Amount = detail.RequiredQty * detail.CfnPrice;
                //不需要计算税率
                //detail.Tax = detail.RequiredQty * detail.CfnPrice * (SR.Consts_TaxRate - 1);
                detail.Tax = detail.RequiredQty * detail.CfnPrice * 0;
            }
            //不可修改金额
            //if (!string.IsNullOrEmpty(amt))
            //{
            //    detail.Amount = Convert.ToDecimal(amt);
            //}

            bool result = _business.UpdateCfn(detail);
        }

        [AjaxMethod]
        public void ChangeOrderType()
        {
            //更换订单类型，删除订单原产品组下的所有产品
            bool result = _business.DeleteDetail(this.InstanceId);
            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                int i = _business.DeleteOrderPointByOrderHeaderId(this.InstanceId);
            }
            SetAddCfnSetBtnHidden();
            IsShowpaymentType();
        }

        [AjaxMethod]
        public void InitBtnCfnAdd()
        {
            SetAddCfnSetBtnHidden();
        }
        [AjaxMethod]
        public string CaculateFormValuePoint()
        {
            this.hidPointCheckErr.Text = "0";
            //预提积分
            this.CheckPointOrder();
            //返回预提结果
            string masg = "";
            DataSet ds = _business.SumPurchaseOrderByHeaderId(this.InstanceId);
            
            //预提额度
            //this.CheckRedInvoicesOrder();
            //DataSet dsrev = _business.SumPurchaseOrderByRedInvoicesHeaderId(this.InstanceId.ToString()); 
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    masg = "总金额：" + Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2") + ", ";
                    masg += "积分抵用：" + Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"]).ToString("F2") + ", ";
                    masg += "还需现金支付：" + (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"])).ToString("F2") + ", ";
                    if (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"]) > 0)
                    {
                        this.hidPointCheckErr.Text = "1";
                    }
                }
            }
            //if (dsrev != null && ds.Tables != null && dsrev.Tables[0].Rows.Count > 0)
            //{
            //    if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
            //    {
            //        masg += "本次使用红票额度：" + Convert.ToDecimal(dsrev.Tables[0].Rows[0]["PointAmount"]).ToString("F2") + "";
            //    }
            //}
            return masg;
        }
        [AjaxMethod]
        public void ChangePointType()
        {
            //更新积分类型，删除订单原产品组下的所有产品
            //bool result = _business.DeleteDetail(this.InstanceId);

            //更换产品组，删除订单原使用积分
            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                int i = _business.DeleteOrderPointByOrderHeaderId(this.InstanceId);
                _business.DeleteOrderRedInvoicesByOrderHeaderId(this.InstanceId.ToString());
            }
        }
        private string CheckPointOrder()
        {
            Hashtable obj = new Hashtable();
            obj.Add("POH_ID", this.InstanceId);
            obj.Add("DMA_ID", this.DealerId);
            if (!string.IsNullOrEmpty(this.hidProductLine.Text))
            {
                obj.Add("ProductLineId", this.hidProductLine.Text);
            }
            if (!string.IsNullOrEmpty(this.hidPointType.Text))
            {
                obj.Add("PointType", this.hidPointType.Text);
            }
            string retValue = "";
            _business.OrderPointCheck(obj, out retValue);
            return retValue;
        }
        private string CheckRedInvoicesOrder()
        {
            string Rtnval = string.Empty;
            string Rtnmesg = string.Empty;
            _business.RedInvoice_RedInvoicesCheck(this.InstanceId.ToString(), this.DealerId.ToString(), this.hidProductLine.Text, out Rtnval, out Rtnmesg);
            return Rtnmesg;
        }
        public void SetAddCfnSetBtnHidden()
        {

            try
            {
                if (this.PageStatus == PurchaseOrderStatus.Draft)
                {

                    //如果选择了成套设备类型的订单，则显示“添加成套设备”按钮
                    if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.BOM.ToString()))
                    {

                        if (this.TabPanel1.ActiveTabIndex == 1)
                        {
                         
                            this.btnAddCfn.Hide();
                            this.btnAddCfnSet.Show();
                        }
                        Renderer r = new Renderer();
                        r.Fn = "SetCellCssNonEditable";
                        this.gpDetail.ColumnModel.SetRenderer(3, r);
                        this.gpDetail.ColumnModel.SetEditable(3, false);
                        this.gpDetail.ColumnModel.SetHidden(8, true);

                    }
                    else
                    {
                      
                        if (this.TabPanel1.ActiveTabIndex == 1)
                        {
                            
                            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
                            {
                                this.btnUserPoint.Show();
                            }
                            else
                            {
                                this.btnUserPoint.Hide();
                            }
                            
                            this.btnAddCfn.Show();
                            this.btnAddCfnSet.Hide();
                        }
                        Renderer r = new Renderer();
                        r.Fn = "SetCellCssEditable";
                        this.gpDetail.ColumnModel.SetRenderer(3, r);
                        this.gpDetail.ColumnModel.SetEditable(3, true);
                        this.gpDetail.ColumnModel.SetHidden(8, false);
                    }
                }
            }
            catch (Exception ex)
            {


            }
            finally
            {

            }
        }

        [AjaxMethod]
        public void ChangeWarehouseAddress()
        {
            //更改选择的仓库后，自动更新收货地址
            //获取收货仓库Id，然后根据Id，获取地址
            if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
            {
                String warehouseId = this.cbWarehouse.SelectedItem.Value;
                Warehouse wh = _warehouse.GetWarehouse(new Guid(warehouseId));
                this.txtShipToAddress.Text = wh.Address;
            }
        }

        [AjaxMethod]
        public void Copy()
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            bool result = _business.Copy(this.InstanceId, this.DealerId, this.hidPriceType.Text, out rtnVal, out rtnMsg);

            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void Revoke()
        {
            bool result = _business.RevokeT2Order(this.InstanceId);
            if (result)
            {
                Ext.MessageBox.Alert("Message", GetLocalResourceObject("Revoke.Alert.Title").ToString()).Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", GetLocalResourceObject("Revoke.Alert.ErrorBody").ToString()).Show();
            }
        }
        [AjaxMethod]
        public void IsShowpaymentType()
        {

            bool bl = _business.SelectDealerPaymentTypBYDmaId(this.hidDealerId.Text);
            if (bl && this.cbOrderType.SelectedItem.Value == PurchaseOrderType.Normal.ToString())
            {
                //如果是普通订单，且经销商在表中有记录，要选择付款方式
               // this.cbpaymentTpype.Hidden = false;
                //this.cbpaymentTpype.LabelStyle = "color:red";
                cbpaymentTpype.Hidden = false;
                cbpaymentTpype1.Hidden = true;
                hidpaymentType.Text = "true";
            }
            else {
                //this.cbpaymentTpype.Hidden = true;
                //this.cbpaymentTpype.LabelStyle. = "color:black";
                cbpaymentTpype.Hidden = true;
                cbpaymentTpype1.Hidden = false;
                cbpaymentTpype1.SelectedItem.Value = "经销商付款";
                hidpayment.Text = "经销商付款";
                hidpaymentType.Text = "false";
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

            //订单信息
            this.txtContactPerson.ReadOnly = false;
            this.txtContact.ReadOnly = false;
            this.txtContactMobile.ReadOnly = false;
            this.lbRejectReason.HideLabel = true;
            this.txtRejectReason.Hidden = true;

            //收货信息
            this.txtShipToAddress.ReadOnly = false;
            this.txtConsignee.ReadOnly = false;
            this.txtConsigneePhone.ReadOnly = false;
            this.dtRDD.Disabled = false;
            this.txtCarrier.ReadOnly = false;

            //切换到第一个面板
            this.TabPanel1.ActiveTabIndex = 0;

            //所有按钮都有效
            ////--this.btnAddCfn.Disabled = false;
            this.Toolbar1.Disabled = false;
            //this.btnAddCfnSet.Disabled = false;          
            //this.btnAvaiableProduct.Disabled = false;
            this.btnSaveDraft.Disabled = false;
            this.btnDeleteDraft.Disabled = false;
            this.btnSubmit.Disabled = false;
            this.btnCopy.Disabled = false;
            this.btnRevoke.Disabled = false;
            this.btnSaveDraft.Disabled = false;
            this.btnSaveDraft.Show();
            this.btnDeleteDraft.Show();
            this.btnSubmit.Show();
            this.btnCopy.Show();
            this.btnRevoke.Show();
            //所有面板都可见
            this.TabDetail.Disabled = false;
            this.TabLog.Disabled = false;

            this.gpDetail.ColumnModel.SetEditable(3, true);
            this.gpDetail.ColumnModel.SetEditable(4, false);//不可修改金额
            this.gpDetail.ColumnModel.SetEditable(6, false);//不可修改金额
            this.gpDetail.ColumnModel.SetHidden(6, false);
            this.gpDetail.ColumnModel.SetHidden(9, true);
            this.cbPointType.Hidden = true;
            //付款方式
            this.cbpaymentTpype.Hidden =false;
            this.cbpaymentTpype.ReadOnly = true;
            this.cbpaymentTpype1.Hidden = true;
            this.cbpaymentTpype1.ReadOnly = true;
            this.cbpaymentTpype.Disabled = false;
            this.cbpaymentTpype1.Disabled = false;
        }

        /// <summary>
        /// 设置页面控件状态
        /// </summary>
        private void SetDetailWindow(PurchaseOrderHeader header)
        {
            //如果是二级经销商，且单据状态是“草稿”，则可以修改
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) && this.PageStatus == PurchaseOrderStatus.Draft)
            {
                this.btnCopy.Hide();
                this.btnRevoke.Hide();
                Renderer r = new Renderer();
                r.Fn = "SetCellCssEditable";
                this.gpDetail.ColumnModel.SetRenderer(3, r);
                this.gpDetail.ColumnModel.SetHidden(8, false);
                this.gpAttachment.ColumnModel.SetHidden(7, false);

                //Edit By SongWeiming on 2017-04-18 去除RSM的选择
                //this.cbSales.Disabled = false;
                //this.cbSales.Hidden = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() != "8f15d92a-47e4-462f-a603-f61983d61b7b" : true;
                if (header.OrderType == PurchaseOrderType.CRPO.ToString())
                {
                    this.cbPointType.Hidden = false;
                    this.gpDetail.ColumnModel.SetHidden(14, false);
                    //this.gpDetail.ColumnModel.SetHidden(15, false);

                }
            }
            else
            {

                Renderer r = new Renderer();
                r.Fn = "SetCellCssNonEditable";
                this.gpDetail.ColumnModel.SetRenderer(3, r);

                //this.cbPointType.Disabled = true;
                this.cbProductLine.Disabled = true;
                this.cbOrderType.Disabled = true;
                this.cbWarehouse.Disabled = true;
                //this.cbTerritory.Disabled = true;
                //Endo产品线才显示RSM选择
                //this.cbSales.Hidden = header.ProductLineBumId.Value.ToString() != "8f15d92a-47e4-462f-a603-f61983d61b7b";

                this.cbpaymentTpype.Disabled = true;
                this.cbpaymentTpype1.Disabled = true;
                this.txtRemark.ReadOnly = true;
                this.txtContactPerson.ReadOnly = true;
                this.txtContact.ReadOnly = true;
                this.txtContactMobile.ReadOnly = true;
                this.txtConsignee.ReadOnly = true;
                this.txtConsigneePhone.ReadOnly = true;
                this.dtRDD.Disabled = true;
                this.txtCarrier.ReadOnly = true;

                ////--this.btnAddCfn.Disabled = true;
                this.Toolbar1.Disabled = true;
                //this.btnAddCfnSet.Disabled = true;
                //this.btnAvaiableProduct.Disabled = true;

                this.gpDetail.ColumnModel.SetEditable(3, false);
                //this.gpDetail.ColumnModel.SetEditable(4, false);
                this.gpDetail.ColumnModel.SetHidden(6, true);
                this.gpDetail.ColumnModel.SetHidden(8, true);
                this.gpDetail.ColumnModel.SetHidden(9, false);
                this.gpAttachment.ColumnModel.SetHidden(7, true);

                this.btnSaveDraft.Hide();
                this.btnDeleteDraft.Hide();
                this.btnSubmit.Hide();
                if (header.OrderType == PurchaseOrderType.CRPO.ToString())
                {
                    this.cbPointType.Hidden = false;
                    this.gpDetail.ColumnModel.SetHidden(14, false);
                    //this.gpDetail.ColumnModel.SetHidden(15, false);
                }
                //如果不是二级经销商，则隐藏复制按钮
                if (!IsDealer || !RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                {
                    this.btnCopy.Hide();
                    this.btnRevoke.Hide();
                }
                else
                {
                    //如果是二级经销商，但单据的类型是“寄售销售订单”，则隐藏复制按钮 & 隐藏撤销按钮
                    //防止由于时间差导致订单尚未进入SAP OR ERP，寄售销售订单均不允许撤销
                    if (header.OrderType.ToString().Equals(PurchaseOrderType.ConsignmentSales.ToString()))
                    {
                        this.btnCopy.Hide();
                        this.btnRevoke.Hide();
                    }

                    if (header.OrderType.ToString().Equals(PurchaseOrderType.BOM.ToString()))
                    {
                        this.btnCopy.Hide();
                    }

                    //单据状态不是“已提交”、“已同意”，则不能撤销
                    if (header.OrderStatus != PurchaseOrderStatus.Submitted.ToString() && header.OrderStatus != PurchaseOrderStatus.Approved.ToString())
                    {
                        this.btnRevoke.Hide();
                    }
                }
            }
            //如果是促销订单，汇总价格为0lijie add 20161023
            if (header.OrderType == PurchaseOrderType.PRO.ToString())
            {
                this.txtTotalAmount.Text = "0";
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
            this.hidDealerId.Clear();
            this.hidProductLine.Clear();
            this.hidOrderStatus.Clear();
            this.hidEditItemId.Clear();
            this.hidTerritoryCode.Clear();
            this.hidLatestAuditDate.Clear();
            this.hidOrderType.Clear();
            this.hidWarehouse.Clear();
            this.hidWareHouseType.Clear();
            this.hidPriceType.Clear();

            this.hidRtnVal.Clear();
            this.hidRtnMsg.Clear();
            this.hidRtnRegMsg.Clear();

            this.cbDealer.SelectedItem.Value = "";
            this.cbProductLine.SelectedItem.Value = "";
            this.cbOrderType.SelectedItem.Value = "";
            this.cbWarehouse.SelectedItem.Value = "";
            this.cbpaymentTpype.SelectedItem.Value = "";
            this.cbpaymentTpype1.SelectedItem.Value = "";
            this.txtOrderNo.Clear();
            this.txtOrderStatus.Clear();
            this.txtOrderTo.Clear();
            this.txtSubmitDate.Clear();
            //this.cbTerritory.SelectedItem.Value = "";

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
            this.txtCarrier.Clear();
            this.hidVenderId.Clear();
            this.hidPointType.Clear();
            this.cbPointType.SelectedItem.Value = "";
            hidpaymentType.Clear();
        }

        private void SetFormValue(PurchaseOrderHeader header)
        {
            //表头信息
            this.DealerId = header.DmaId.Value;
            this.hidProductLine.Text = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "";
            this.PageStatus = (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), header.OrderStatus, true);
            this.hidTerritoryCode.Text = header.TerritoryCode;
            this.hidLatestAuditDate.Text = header.LatestAuditDate.HasValue ? header.LatestAuditDate.Value.ToString() : "";

            this.hidOrderType.Text = header.OrderType;
            this.txtOrderNo.Text = header.OrderNo;
            this.hidWarehouse.Text = header.WhmId.HasValue ? header.WhmId.Value.ToString() : "";
            this.txtOrderStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Order_Status, header.OrderStatus);

            if (string.IsNullOrEmpty(header.Vendorid))
            {
                this.txtOrderTo.Text = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).ChineseName;
                this.hidVenderId.Text = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).Id.ToString();

            }
            else
            {
                this.txtOrderTo.Text = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).ChineseName;
                this.hidVenderId.Text = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).Id.ToString();
            }





            this.txtSubmitDate.Text = header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd HH:mm:ss") : "";

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
            this.txtCarrier.Text = header.TerritoryCode;//将区域代码字段用作承运商信息
            if (header.Rdd.HasValue)
            {
                this.dtRDD.SelectedDate = header.Rdd.Value;
            }
            //设定期望到货日期只能选取当前时间之后的日期
            this.dtRDD.MinDate = DateTime.Now.AddDays(1);


            this.hidPointType.Text = header.PointType;
            this.cbpaymentTpype.SelectedItem.Value = header.SapOrderNo==null?"":header.SapOrderNo;
            this.cbpaymentTpype1.SelectedItem.Value = header.SapOrderNo == null ? "" : header.SapOrderNo;
            //Edit By SongWeiming on 2017-04-18 去除RSM的选择
            //this.cbSales.SelectedItem.Value = header.SalesAccount == null ? "" : header.SalesAccount;

            //this.hidpayment.Text = header.SalesAccount == null ? "" : header.SalesAccount;
            this.hidpayment.Text = header.SapOrderNo == null ? "" : header.SapOrderNo;
            //this.hidSalesAccount.Text = header.SalesAccount == null ? "" : header.SalesAccount; 
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
                //header.ShipToAddress = dm.ShipToAddress;
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
            //订单信息
            header.ContactPerson = this.txtContactPerson.Text;
            header.Contact = this.txtContact.Text;
            header.ContactMobile = this.txtContactMobile.Text;
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
            header.Vendorid = string.IsNullOrEmpty(this.hidVenderId.Text) ? null : this.hidVenderId.Text;
            //Edit By SongWeiming on 2017-04-18 去除RSM的选择
            //header.SalesAccount = this.cbSales.SelectedItem.Value;
            header.SapOrderNo = hidpayment.Text;
            header.PointType = this.cbPointType.SelectedItem.Value.ToString();
            return header;
        }

        private void CaculateFormValue()
        {
            DataSet ds = _business.SumPurchaseOrderByHeaderId(this.InstanceId);
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                if (cbOrderType.SelectedItem.Value == PurchaseOrderType.PRO.ToString()|| cbOrderType.SelectedItem.Value == PurchaseOrderType.CRPO.ToString())
                {
                    this.txtTotalAmount.Text = "0";
                }
                else
                {

                    this.txtTotalAmount.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2");
                }
                this.txtTotalQty.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2");
            }
        }

        #endregion

        #region Added By huyong On 2019-07-04 For 附件
        protected void AttachmentStore_Refresh(object sender, StoreRefreshDataEventArgs e)
        {
            Guid tid = this.InstanceId;
            int totalCount = 0;

            DataSet ds = _attachBll.GetAttachmentByMainId(tid, AttachmentType.ReturnAdjust, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBarAttachement.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            AttachmentStore.DataSource = ds;
            AttachmentStore.DataBind();
        }

        protected void ShowAttachmentWindow(object sender, AjaxEventArgs e)
        {
            this.AttachmentWindow.Show();
        }

        protected void UploadClick(object sender, AjaxEventArgs e)
        {
            if (this.FileUploadField1.HasFile)
            {

                bool error = false;

                string fileName = FileUploadField1.PostedFile.FileName;
                string fileExtention = string.Empty;
                string fileExt = string.Empty;
                if (fileName.LastIndexOf(".") < 0)
                {
                    error = true;
                }
                else
                {
                    fileExtention = fileName.Substring(fileName.LastIndexOf("\\") + 1);
                    fileExt = fileName.Substring(fileName.LastIndexOf(".") + 1).ToLower();
                }

                if (error)
                {
                    Ext.Msg.Show(new MessageBox.Config
                    {
                        Buttons = MessageBox.Button.OK,
                        Icon = MessageBox.Icon.INFO,
                        Title = "文件错误",
                        Message = "请上传正确的文件！"
                    });

                    return;
                }

                //构造文件名称

                string newFileName = DateTime.Now.ToFileTime().ToString() + "." + fileExt;

                //上传文件在Upload文件夹

                string file = Server.MapPath("\\Upload\\UploadFile\\AdjustAttachment\\" + newFileName);


                //文件上传
                FileUploadField1.PostedFile.SaveAs(file);

                this.hiddenFileName.Text = newFileName;

                Attachment attach = new Attachment();
                attach.Id = Guid.NewGuid();
                attach.MainId = this.InstanceId;
                attach.Name = fileExtention;
                attach.Url = newFileName;
                attach.Type = AttachmentType.ReturnAdjust.ToString();
                attach.UploadDate = DateTime.Now;
                attach.UploadUser = new Guid(_context.User.Id);

                _attachBll.AddAttachment(attach);

                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.INFO,
                    Title = "上传成功",
                    Message = "已成功上传文件！"
                });
            }
            else
            {
                Ext.Msg.Show(new MessageBox.Config
                {
                    Buttons = MessageBox.Button.OK,
                    Icon = MessageBox.Icon.ERROR,
                    Title = "上传失败",
                    Message = "文件未被成功上传！"
                });
            }
        }

        [AjaxMethod]
        public void DeleteAttachment(string id, string fileName)
        {
            try
            {
                _attachBll.DelAttachment(new Guid(id));
                string uploadFile = Server.MapPath("..\\..\\Upload\\UploadFile\\AdjustAttachment");
                File.Delete(uploadFile + "\\" + fileName);

            }
            catch (Exception ex)
            {
                Ext.Msg.Alert("Error", "删除附件失败，请联系DMS技术支持").Show();
            }
        }

        [AjaxMethod]
        public void InitBtnAddAttach()
        {
            try
            {
                PurchaseOrderHeader mainData = _business.GetPurchaseOrderHeaderById(this.InstanceId);
                //判断当前状态是不是为草稿状态，如果为草稿状态，则可以更新
                if (mainData.OrderStatus == ShipmentOrderStatus.Draft.ToString())
                {
                    this.btnAddAttach.Disabled = false;
                }
                else
                {
                    this.btnAddAttach.Disabled = true;
                }
            }
            catch (Exception ex)
            {


            }
            finally
            {

            }
        }
        #endregion
    }
}