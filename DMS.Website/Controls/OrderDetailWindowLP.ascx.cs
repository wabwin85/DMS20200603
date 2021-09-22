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
    [AjaxMethodProxyID(IDMode = AjaxMethodProxyIDMode.Alias, Alias = "OrderDetailWindowLP")]
    public partial class OrderDetailWindowLP : BaseUserControl
    {
        #region 公用
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IWarehouses _warehouse = new DMS.Business.Warehouses();
        private IVirtualDC _virtualdc = new DMS.Business.VirtualDC();
        private ISpecialPriceBLL _speicalPrice = new SpecialPriceBLL();
        private IContractMaster _contractMaster = new ContractMaster();
        private IDealerMasters _Masts = new DealerMasters();
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
            //如果单据状态是草稿状态或订单的类型是Temporary，则只显示特殊价格订单、普通订单、交接订单
            if (this.PageStatus.ToString().Equals(PurchaseOrderStatus.Draft.ToString()) || this.hidCreateType.Text.Equals(PurchaseOrderCreateType.Temporary.ToString()))
            {
                this.OrderTypeStore.DataSource = (from t in dicts
                                                  where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                         t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                         t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                         t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                         t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                         t.Key == PurchaseOrderType.BOM.ToString())
                                                  select t);

            }
            else
            {
                Hashtable obj = new Hashtable();
                obj.Add("DMA_ID", this.DealerId.ToString());
                obj.Add("PermissionsType", "PromotionOrder");
                //促销、积分订单不能使用
                if (_business.CheckDealerPermissions(obj).Equals("0"))
                {
                    this.OrderTypeStore.DataSource = (from t in dicts
                                                      where (t.Key != PurchaseOrderType.CRPO.ToString() &&
                                                             t.Key != PurchaseOrderType.PRO.ToString())
                                                      select t);
                }
                else
                {
                    this.OrderTypeStore.DataSource = (from t in dicts select t);
                }
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

        protected void InvoiceStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        {
            int totalCount = 0;
            DataSet ds = _business.QueryInvoiceByHeaderId(this.InstanceId, (e.Start == -1 ? 0 : e.Start), (e.Limit == -1 ? this.PagingToolBar1.PageSize : e.Limit), out totalCount);
            e.TotalCount = totalCount;

            this.InvoiceStore.DataSource = ds;
            this.InvoiceStore.DataBind();
        }

        protected void SpecialPriceStore_RefreshData(object sender, StoreRefreshDataEventArgs e)
        {
            //取得经销商可用的特殊价格政策
            //IList<SpecialPriceMaster> list = _speicalPrice.GetSpecialPriceMasterByDealer(this.DealerId, new Guid(this.hidProductLine.Text));
            Hashtable param = new Hashtable();

            if (!(this.DealerId == null))
            {
                param.Add("DealerId", this.DealerId.ToString());
            }

            if (!string.IsNullOrEmpty(this.hidProductLine.Text))
            {
                param.Add("ProductLineId", this.hidProductLine.Text);
            }

            DataSet ds = null;
            ds = _speicalPrice.GetPromotionPolicyByCondition(param);

            this.SpecialPriceStore.DataSource = ds;
            this.SpecialPriceStore.DataBind();

        }

        //Edit By SongWeiming on 2017-04-18 去除RSM的选择
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


        //    //if (this.PageStatus == PurchaseOrderStatus.Draft && ds.Tables[0].Rows.Count > 0)
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
        //DMS不需要区域
        //protected void TerritoryStore_RefershData(object sender, StoreRefreshDataEventArgs e)
        //{
        //    DataSet ds = _business.QueryTerritoryMaster(this.DealerId, string.IsNullOrEmpty(this.hidProductLine.Text) ? Guid.Empty : new Guid(this.hidProductLine.Text));

        //    this.TerritoryStore.DataSource = ds;
        //    this.TerritoryStore.DataBind();
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
        public void Show(string id, string dealerId, string dealerName)
        {

            this.IsPageNew = (id == Guid.Empty.ToString());
            this.IsModified = false;
            this.IsSaved = false;
            this.InstanceId = (id == Guid.Empty.ToString()) ? Guid.NewGuid() : (new Guid(id));
            this.hidDealerId.Value = dealerId;


            this.InitDetailWindow();
            this.DetailWindow.Show();

            //绑定Store
            this.Bind_OrderTypeForLP(this.OrderTypeStore, SR.Consts_Order_Type);
            //base.Bind_ProductLine(this.ProductLineStore);
            base.Bind_SAPWarehouseAddress(this.SAPWarehouseAddressStore, new Guid(dealerId));

            this.Bind_SpecialPrice(this.SpecialPriceStore);


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
        public void DiscardModify()
        {
            bool result = _business.DiscardModify(this.InstanceId);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void CheckSubmit(string createType, string updateDate, string promotionPolicyId)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            //需要根据update时间来判断是否单据已经被修改了
            if (createType.Equals(PurchaseOrderCreateType.Temporary.ToString()))
            {
                //获取系统中原有单据的系统更新时间
                PurchaseOrderHeader header = null;
                header = _business.GetPurchaseOrderHeaderById(this.InstanceId);
                if (header.UpdateDate.ToString().Equals(updateDate))
                {
                    //Edit by Songweiming on 2015-2-3 特殊价格选择暂时先不使用
                    //bool result = _business.CheckSubmit(this.InstanceId, this.DealerId, this.hidPriceType.Text, this.hidOrderType.Text, out rtnVal, out rtnMsg);

                    //if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value) && this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
                    //{
                    //    bool result = _business.CheckSubmitSpecial(this.InstanceId, this.DealerId, new Guid(this.cbSpecialPrice.SelectedItem.Value), out rtnVal, out rtnMsg);
                    //}
                    //else
                    //{
                    bool result = _business.CheckSubmit(this.InstanceId, this.DealerId, promotionPolicyId, this.hidPriceType.Text, this.hidOrderType.Text, out rtnVal, out rtnMsg);
                    //}

                }
                else
                {
                    rtnVal = "Error";
                    rtnMsg = "单据已被改变，请重新修改！";
                }

            }
            else
            {
                //Edit by Songweiming on 2015-2-3 特殊价格选择暂时先不使用
                //bool result = _business.CheckSubmit(this.InstanceId, this.DealerId, this.hidPriceType.Text, this.hidOrderType.Text, out rtnVal, out rtnMsg);

                //if (!string.IsNullOrEmpty(this.cbOrderType.SelectedItem.Value) && this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
                //{
                //    bool result = _business.CheckSubmitSpecial(this.InstanceId, this.DealerId, new Guid(this.cbSpecialPrice.SelectedItem.Value), out rtnVal, out rtnMsg);
                //}
                //else
                //{
                bool result = _business.CheckSubmit(this.InstanceId, this.DealerId, promotionPolicyId, this.hidPriceType.Text, this.hidOrderType.Text, out rtnVal, out rtnMsg);
                //}
            }

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

            this.hidRtnVal.Text = rtnVal;
            this.hidRtnMsg.Text = rtnMsg.Replace("$$", "<BR/>");
        }

        [AjaxMethod]
        public void Submit()
        {
            String corpType = RoleModelContext.Current.User.CorpType;
            String crossDockingNo = "";
            if (corpType.Equals(DealerType.LP.ToString()) || corpType.Equals(DealerType.LS.ToString()))
            {
                crossDockingNo = this.txtCrossDock.Text;
            }
            PurchaseOrderHeader header = this.GetFormValue();
            bool result = _business.Submit(header, crossDockingNo);
            if (result)
            {
                IsSaved = true;
            }
        }

        [AjaxMethod]
        public void DeleteItem(string id)
        {
            bool result = _business.DeleteCfn(new Guid(id));
        }

        [AjaxMethod]
        public void UpdateItem(string qty, string lot, string cfnPrice, string upn)
        {
            string rtnVal = string.Empty;
            string rtnMsg = string.Empty;

            Guid detailId = new Guid(this.hidEditItemId.Text);
            PurchaseOrderDetail detail = new PurchaseOrderDetail();

            //判断lotnumber是否超过长度
            //Edit By Songweiming on 2013-11-21，不需要判断是哪种类型的申请单
            //if (this.hidOrderType.Text.Equals(PurchaseOrderType.Transfer.ToString()) && !string.IsNullOrEmpty(lot) && lot.Length > 30)
            if (!string.IsNullOrEmpty(lot) && lot.Length > 30)
            {
                rtnVal = "LotTooLong";

            }

            //判断lotNumber是否存在
            //if (!string.IsNullOrEmpty(lot) && !_business.CheckLotNumberByUPN(lot, upn))
            if (!string.IsNullOrEmpty(lot) && !_business.CheckLotNumberByUPNQRCode(lot, upn))
            {
                rtnVal = "LotNotExists";
            }
            //Edit By Songweiming on 2013-11-21，不需要判断是哪种类型的申请单
            //else if (this.hidOrderType.Text.Equals(PurchaseOrderType.Transfer.ToString()) && _business.QueryLotNumberCount(detailId, lot) > 0)
            else if (_business.QueryLotNumberCount(detailId, lot) > 0 && !this.hidOrderType.Text.Equals(PurchaseOrderType.ClearBorrowManual.ToString()))
            {
                //先判断Detail表中是否存在修改后的lot号，如果已存在，则抛错（已存在此lotnumber的记录）
                rtnVal = "LotExisted";
            }
            else if (_business.QueryLotPriceCount(detailId, upn, lot, cfnPrice) > 0 && this.hidOrderType.Value.ToString() == "SpecialPrice")
            {
                //先判断Detail表中是否存在修改后的价格，如果已存在，则抛错（已存在此价格的记录）
                rtnVal = "LotPriceExisted";
            }
            else
            {
                detail = _business.GetPurchaseOrderDetailById(detailId);

                if (!string.IsNullOrEmpty(qty))
                {
                    detail.RequiredQty = Convert.ToDecimal(qty);
                }
                if (!string.IsNullOrEmpty(cfnPrice))
                {

                    detail.CfnPrice = Convert.ToDecimal(cfnPrice);

                }

                detail.Amount = detail.RequiredQty * detail.CfnPrice;
                //不需要计算税率
                //detail.Tax = detail.RequiredQty * detail.CfnPrice * (SR.Consts_TaxRate - 1);
                detail.Tax = detail.RequiredQty * detail.CfnPrice * 0;


                if (string.IsNullOrEmpty(lot))
                {
                    detail.LotNumber = null;
                }
                else
                {
                    detail.LotNumber = lot.Trim();
                }
                //不可修改金额
                //if (!string.IsNullOrEmpty(amt))
                //{
                //    detail.Amount = Convert.ToDecimal(amt);
                //}

                bool result = _business.UpdateCfn(detail);

                //积分订单并能产品明细信息时删除当前绑定积分
                if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    int i = _business.DeleteOrderPointByOrderHeaderId(this.InstanceId);
                }

                rtnVal = "Success";
            }
            this.hidRtnVal.Text = rtnVal;
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

            //cbSAPWarehouseAddress.Disabled = false;
            //cbWarehouse.Disabled = false;
            SetAddCfnSetBtnHidden();
        }

        [AjaxMethod]
        public void InitBtnCfnAdd()
        {
            SetAddCfnSetBtnHidden();
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
                        this.gpDetail.ColumnModel.SetHidden(12, true);

                    }
                    else
                    {
                        Renderer r = new Renderer();
                        //Edit By Song Weiming on 2018-10-10 清指定批号订单不能删除明细行,且不可修改批号，不可修改任何内容
                        if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ClearBorrowManual.ToString()))
                        {

                            r.Fn = "SetCellCssNonEditable";
                            this.gpDetail.ColumnModel.SetRenderer(3, r);
                            this.gpDetail.ColumnModel.SetRenderer(4, r);
                            this.gpDetail.ColumnModel.SetRenderer(7, r);
                            this.gpDetail.ColumnModel.SetRenderer(10, r);
                            this.gpDetail.ColumnModel.SetEditable(3, false);
                            this.gpDetail.ColumnModel.SetEditable(4, false);
                            this.gpDetail.ColumnModel.SetEditable(7, false);
                            this.gpDetail.ColumnModel.SetEditable(10, false);
                            this.gpDetail.ColumnModel.SetHidden(12, true);


                        }
                        else
                        {
                            r.Fn = "SetCellCssEditable";
                            this.gpDetail.ColumnModel.SetRenderer(3, r);
                            this.gpDetail.ColumnModel.SetEditable(3, true);
                            //this.gpDetail.ColumnModel.SetEditable(4, true);
                            this.gpDetail.ColumnModel.SetHidden(12, false);
                        }



                        if (this.TabPanel1.ActiveTabIndex == 1)
                        {

                            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ClearBorrowManual.ToString()))
                            {
                                this.btnAddCfn.Disabled = true;
                                this.btnAddCfnSet.Hide();
                            }
                            else
                            {
                                this.btnAddCfn.Show();
                                this.btnAddCfnSet.Hide();
                            }

                            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
                            {
                                this.btnUserPoint.Show();
                            }
                            else
                            {
                                this.btnUserPoint.Hide();
                            }
                            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
                            {
                                if (cbSpecialPrice.SelectedItem.Text == "满额打折")
                                {
                                    //this.gpDetail.ColumnModel.SetEditable(3, false);
                                    this.gpDetail.ColumnModel.SetEditable(4, false);
                                }

                                if (this.hidIsUsePro.Text == "0")
                                {
                                    this.btnUsePro.Show();
                                    this.btnUsePro.Disabled = false;
                                    this.btnAddCfn.Disabled = false;
                                }
                                else
                                {
                                    this.gpDetail.ColumnModel.SetEditable(3, false);
                                    this.btnUsePro.Hide();
                                    this.btnAddCfn.Disabled = true;
                                }
                            }
                        }

                        else
                        {
                            this.btnUsePro.Hide();
                        }
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
        public void SetSpecialPriceEdit()
        {
            //Edit By SongWeiming on 2018-10-10 清指定批号订单不可修改价格，不可删除明细记录 
            //如果是特殊价格订单、交接订单、特殊清指定批号订单，则可以修改价格
            //if (this.hidOrderType.Value.ToString() == PurchaseOrderType.SpecialPrice.ToString() || this.hidOrderType.Value.ToString() == PurchaseOrderType.Transfer.ToString() || this.hidOrderType.Value.ToString() == PurchaseOrderType.ClearBorrowManual.ToString())
            if (this.hidOrderType.Value.ToString() == PurchaseOrderType.SpecialPrice.ToString() || this.hidOrderType.Value.ToString() == PurchaseOrderType.Transfer.ToString())
            {
                Renderer r = new Renderer();
                r.Fn = "SetCellCssEditable";
                this.gpDetail.ColumnModel.SetRenderer(4, r);
                this.gpDetail.ColumnModel.SetEditable(4, true);
            }
            else
            {
                Renderer r = new Renderer();
                r.Fn = "SetCellCssNonEditable";
                this.gpDetail.ColumnModel.SetRenderer(4, r);
                this.gpDetail.ColumnModel.SetEditable(4, false);
            }
        }

        //Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用(ChangeSpecialPrice注释不使用)
        [AjaxMethod]
        public void ChangeSpecialPrice()
        {
            //更特殊价格政策，删除订单原产品组下的所有产品
            bool result = _business.DeleteDetail(this.InstanceId);

            //若选择的政策是“满额送赠品”或"一次性特殊价格",可以修改价格，否则不能修改
            if (this.cbSpecialPrice.SelectedItem.Value == "满额打折")
            {
                this.gpDetail.ColumnModel.SetEditable(3, false);
                this.gpDetail.ColumnModel.SetEditable(4, false);
            }
            else
            {
                this.gpDetail.ColumnModel.SetEditable(3, true);
                this.gpDetail.ColumnModel.SetEditable(4, true);
            }
        }

        //[AjaxMethod]
        //public void ChangeWarehouse()
        //{
        //    //更改选择的仓库后，自动更新收货地址
        //    //获取收货仓库Id，然后根据Id，获取地址
        //    if (!string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value))
        //    {
        //        String warehouseId = this.cbWarehouse.SelectedItem.Value;
        //        Warehouse wh = _warehouse.GetWarehouse(new Guid(warehouseId));
        //        this.txtShipToAddress.Text = wh.Address;
        //    }
        //}

        [AjaxMethod]
        public void ChangeProductLine()
        {
            //更换产品组，删除订单原产品组下的所有产品
            bool result = _business.DeleteDetail(this.InstanceId);

            //更新Virtual DC          
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                IList<Virtualdc> virtualdc = _virtualdc.QueryForPlant(this.DealerId, new Guid(this.cbProductLine.SelectedItem.Value));
                if (virtualdc.Count > 0)
                {
                    this.txtVirtualDC.Text = virtualdc[0].Plant;
                }
                //SetSpecialPrice();
            }

            //更换产品组，删除订单原使用积分
            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
            {
                int i = _business.DeleteOrderPointByOrderHeaderId(this.InstanceId);
            }
        }

        [AjaxMethod]
        public void ProductLineInit()
        {
            this.cbProductLine.Disabled = true;
            if (!string.IsNullOrEmpty(this.cbProductLine.SelectedItem.Value))
            {
                //产品组初始化
                if (IsPageNew)
                {
                    //新增单据时，更新VirtualDC
                    IList<Virtualdc> virtualdc = _virtualdc.QueryForPlant(this.DealerId, new Guid(this.hidProductLine.Text));
                    if (virtualdc.Count > 0)
                    {
                        this.txtVirtualDC.Text = virtualdc[0].Plant;
                    }
                }

                //更新特殊价格

                SetSpecialPrice();
            }
        }

        //Edit by Songweiming on 2013-11-4 特殊价格选择暂时先不使用
        [AjaxMethod]
        public void SetSpecialPriceHidden()
        {
            //根据选择的订单类型不同,确定是否显示特殊价格选择控件            
            SetSpecialPrice();
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
            }
        }

        //[AjaxMethod]
        //public void SetLotNumberHidden()
        //{
        //    //Edit by Songweiming on 2013-11-4 特殊价格允许输入批号
        //    //根据选择的订单类型不同,确定是否显示产品批号
        //    if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.Transfer.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ClearBorrow.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.ConsignmentSales.ToString()))
        //    {
        //        this.gpDetail.ColumnModel.SetHidden(10, false);
        //    }
        //    else
        //    {
        //        this.gpDetail.ColumnModel.SetHidden(10, true);
        //    }
        //}

        //[AjaxMethod]
        //public void SetCanOrderNumberHidden()
        //{
        //    //根据选择的订单类型不同,确定是否显示可订数量
        //    if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
        //    {
        //        this.gpDetail.ColumnModel.SetHidden(7, false);
        //    }
        //    else
        //    {
        //        this.gpDetail.ColumnModel.SetHidden(7, true);
        //    }
        //}

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
            bool result = _business.RevokeLPOrder(this.InstanceId);
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
        public void Close()
        {
            bool result = _business.CloseLPOrder(this.InstanceId);
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
        public string CaculateFormValuePoint()
        {
            this.hidPointCheckErr.Text = "0";
            //预提积分
            this.CheckPointOrder();
            //返回预提结果
            string masg = "";
            DataSet ds = _business.SumPurchaseOrderByHeaderId(this.InstanceId);
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
            return masg;
        }

        [AjaxMethod]
        public string ValidateBOMQty()
        {
            string masg = "0";
            Hashtable obj = new Hashtable();
            obj.Add("PohId", this.InstanceId);
            if (_business.CheckBomOrderQty(obj))
            {
                masg = "1";
            }
            return masg;
        }

        [AjaxMethod]
        public void UsePro()
        {
            //调用Proc_Interface_Imm_PolicyFit，如果返回Success，控制界面操作，只能提交订单，不可让用户再修改订单了
            string Result = "";
            string RtnMsg = "";
            _business.PolicyFit(this.InstanceId, this.cbSpecialPrice.SelectedItem.Value, out Result, out RtnMsg);
            if (RtnMsg == "")
            {
                this.cbProductLine.Disabled = true;
                this.cbOrderType.Disabled = true;
                this.cbWarehouse.Disabled = true;
                this.cbSAPWarehouseAddress.Disabled = true;
                //this.cbTerritory.Disabled = false;
                //经销商始终不可编辑
                //this.cbDealer.Disabled = true;
                //积分类型不隐藏
                this.cbPointType.Hidden = true;

                //表头
                this.txtOrderNo.ReadOnly = true;
                this.txtSubmitDate.ReadOnly = true;
                this.txtOrderStatus.ReadOnly = true;
                this.txtOrderTo.ReadOnly = true;
                this.txtDealer.ReadOnly = true;

                //汇总信息
                this.txtTotalAmount.ReadOnly = true;
                this.txtTotalQty.ReadOnly = true;
                this.txtRemark.ReadOnly = true;
                this.txtVirtualDC.ReadOnly = true;

                //订单信息
                this.cbSpecialPrice.Disabled = true;
                this.txtContactPerson.ReadOnly = true;
                this.txtContact.ReadOnly = true;
                this.txtContactMobile.ReadOnly = true;
                this.lbRejectReason.HideLabel = true;
                this.txtRejectReason.Hidden = true;
                this.txtSpecialPrice.ReadOnly = true;

                //收货信息
                //this.txtShipToAddress.ReadOnly = false;
                this.txtConsignee.ReadOnly = true;
                this.txtConsigneePhone.ReadOnly = true;
                this.dtRDD.Disabled = true;
                this.txtCarrier.ReadOnly = true;

                //所有按钮,除了提交都无效
                this.Toolbar1.Disabled = true;
                //this.btnAddCfnSet.Disabled = false;
                this.btnSaveDraft.Disabled = true;
                this.btnDeleteDraft.Disabled = false;
                this.btnDiscardModify.Disabled = true;
                this.btnSubmit.Disabled = false;
                this.btnCopy.Disabled = true;
                this.btnRevoke.Disabled = true;
                this.btnClose.Disabled = true;
                this.btnSaveDraft.Disabled = true;
                this.btnUsePro.Disabled = true;

                PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(this.InstanceId);
                header.IsUsePro = "1";
                _business.UpdateOrderByOrder(header);

                this.hidIsUsePro.Text = "1";

                if (cbSpecialPrice.SelectedItem.Text == "满额打折")
                {
                    this.gpDetail.ColumnModel.SetEditable(3, false);
                    this.gpDetail.ColumnModel.SetEditable(4, false);
                }

                Ext.MessageBox.Alert("Success", "促销政策使用成功，请提交单据").Show();
            }
            else
            {
                Ext.MessageBox.Alert("Error", Result + RtnMsg).Show();
            }
        }
        [AjaxMethod]
        public void GetcbSAPWarehouseAddress()
        {

            cbWarehouse.Disabled = true;
            cbSAPWarehouseAddress.Disabled = true;
            hidDealerTaxpayer.Text = "直销医院";

            if (!string.IsNullOrEmpty(hidWarehouse.Text))
            {
                DataSet wds = _business.SelectSAPWarehouseAddressByWhmId(hidWarehouse.Text);
                cbWarehouse.SelectedItem.Value = hidWarehouse.Text;
                if (wds.Tables[0].Rows[0]["SWA_WH_Address"] != DBNull.Value)
                {
                    hidSAPWarehouseAddress.Text = wds.Tables[0].Rows[0]["SWA_WH_Address"].ToString();
                    cbSAPWarehouseAddress.SelectedItem.Value = hidSAPWarehouseAddress.Text;
                }
            }
        }
        ////获取产品是否可订购的信息 lijie add 20160824
        //[AjaxMethod]
        //public void GetCfnInfo()
        //{
        //    Hashtable ht = new Hashtable();
        //    ht.Add("DealerId", hidDealerId.Text);
        //    ht.Add("Upn", txtUpn.Text);
        //   DataSet ds= _business.GetCfnIsorderByUpn(ht);
        //   CfnInfoStore.DataSource = ds;
        //   CfnInfoStore.DataBind();
        //}
        #endregion

        #region 页面私有方法
        /// <summary>
        /// 清除页面控件状态
        /// </summary>
        private void ClearDetailWindow()
        {
            //产品线
            this.ReceivingWay.Enabled = false;
            this.btnhospital.Enabled = false;
            this.cbProductLine.Disabled = false;
            this.cbOrderType.Disabled = false;
            this.cbWarehouse.Disabled = false;
            this.cbSAPWarehouseAddress.Disabled = false;
            //this.cbTerritory.Disabled = false;
            //经销商始终不可编辑
            //this.cbDealer.Disabled = true;
            //积分类型不隐藏
            this.cbPointType.Disabled = false;
            this.cbPointType.Hidden = true;
            this.Texthospitalname.Enabled = false;

            if (!this.HospitalAddress.Text.Equals(""))
            {
                this.HospitalAddress.Enabled = true;
            }
            else
            {
                this.HospitalAddress.Enabled = false;
            }
            //表头
            this.txtOrderNo.ReadOnly = true;
            this.txtSubmitDate.ReadOnly = true;
            this.txtOrderStatus.ReadOnly = true;
            this.txtOrderTo.ReadOnly = true;
            this.txtDealer.ReadOnly = true;

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
            this.lbRejectReason.HideLabel = false;
            this.txtRejectReason.Hidden = false;
            this.txtSpecialPrice.ReadOnly = true;
            //this.ttClearBorrowRemark.Hidden = true;

            //收货信息
            //this.txtShipToAddress.ReadOnly = false;
            this.txtConsignee.ReadOnly = false;
            this.txtConsigneePhone.ReadOnly = false;
            this.dtRDD.Disabled = false;
            this.txtCarrier.ReadOnly = false;

            //特殊价格 Edit by SongWeiming on 2015-01-19 
            //this.cbSpecialPrice.Hidden = true;
            //this.txtSpecialPrice.Hidden = true;

            //切换到第一个面板
            this.TabPanel1.ActiveTabIndex = 0;

            //所有按钮都有效
            this.Toolbar1.Disabled = false;
            //this.btnAddCfnSet.Disabled = false;
            this.btnSaveDraft.Disabled = false;
            this.btnDeleteDraft.Disabled = false;
            this.btnDiscardModify.Disabled = false;
            this.btnSubmit.Disabled = false;
            this.btnCopy.Disabled = false;
            this.btnRevoke.Disabled = false;
            this.btnClose.Disabled = false;
            //this.btnAddAttach.Disabled = false;
            this.btnSaveDraft.Show();
            this.btnDeleteDraft.Show();
            this.btnSubmit.Show();
            this.btnCopy.Show();
            this.btnRevoke.Show();
            this.btnClose.Show();
            this.btnDiscardModify.Show();
            //this.btnAddAttach.Show();

            //所有面板都可见
            this.TabDetail.Disabled = false;
            this.TabLog.Disabled = false;


            this.gpDetail.ColumnModel.SetEditable(3, true);
            this.gpDetail.ColumnModel.SetEditable(4, false);//不可修改金额
            this.gpDetail.ColumnModel.SetHidden(6, false);
            this.gpDetail.ColumnModel.SetEditable(6, false);
            this.gpDetail.ColumnModel.SetEditable(10, true);
            this.gpDetail.ColumnModel.SetHidden(7, true);
            this.gpDetail.ColumnModel.SetHidden(12, false);
            this.gpDetail.ColumnModel.SetHidden(9, true);
            this.gpDetail.ColumnModel.SetHidden(17, true);//隐藏使用积分
            this.gpDetail.ColumnModel.SetHidden(18, true);//隐藏折扣率

            Renderer r = new Renderer();
            r.Fn = "SetCellCssNonEditable";
            
            this.gpDetail.ColumnModel.SetRenderer(4, r);
        }

        /// <summary>
        /// 设置页面控件状态
        /// </summary>
        private void SetDetailWindow(PurchaseOrderHeader header)
        {

            String corpType = RoleModelContext.Current.User.CorpType;
            hidDealerType.Value = corpType;
            if (header.OrderType == PurchaseOrderType.CRPO.ToString())
            {
                this.gpDetail.ColumnModel.SetHidden(17, false);
                this.cbPointType.Hidden = false;
            }
            if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
            {
                this.gpDetail.ColumnModel.SetHidden(18, false);
                //this.ttClearBorrowRemark.Hidden = false;
                this.cbOrderType.Disabled = true;
            }
            else
            {
                this.cbOrderType.Disabled = false;
            }            

            //如果是T1或LP，且单据是“草稿”，则可以修改
            if (IsDealer && (corpType.Equals(DealerType.T1.ToString()) || corpType.Equals(DealerType.LP.ToString()) || corpType.Equals(DealerType.LS.ToString())) && this.PageStatus == PurchaseOrderStatus.Draft)
            {
                //隐藏复制、放弃修改按钮
                this.btnCopy.Hide();
                this.btnRevoke.Hide();
                this.btnClose.Hide();
                this.btnUsePro.Hide();
                this.lbRejectReason.HideLabel = true;
                this.txtRejectReason.Hidden = true;
                this.btnDiscardModify.Hide();
                //产品数量可编辑
                Renderer r = new Renderer();
                r.Fn = "SetCellCssEditable";
                this.gpDetail.ColumnModel.SetRenderer(3, r);
                this.gpDetail.ColumnModel.SetRenderer(10, r);
                this.gpAttachment.ColumnModel.SetHidden(7, false);
                this.btnhospital.Enabled = true;
                this.ReceivingWay.Enabled = true;

                //Edit By Song Weiming on 2018-10-10 清指定批号订单不能修改价格
                //如果是特殊价格订单或交接订单、特殊清指定批号订单，则可以修改价格
                if ((header.OrderType == PurchaseOrderType.SpecialPrice.ToString() && (header.IsUsePro == "0" || string.IsNullOrEmpty(header.IsUsePro)) && (this.cbSpecialPrice.SelectedItem.Value == "满额送赠品" || this.cbSpecialPrice.SelectedItem.Value == "一次性特殊价格")))
                {
                    this.btnUsePro.Show();
                    this.btnAddCfn.Show();
                    this.gpDetail.ColumnModel.SetRenderer(4, r);
                    this.gpDetail.ColumnModel.SetEditable(4, true);
                }
                if (header.OrderType == PurchaseOrderType.Transfer.ToString())
                {
                    this.btnUsePro.Show();
                    this.gpDetail.ColumnModel.SetRenderer(4, r);
                    this.gpDetail.ColumnModel.SetEditable(4, true);
                }

                //if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString() && header.ProductLineBumId.ToString().ToUpper() == "97A4E135-74C7-4802-AF23-9D6D00FCB2CC")
                //{
                //    this.gpDetail.ColumnModel.SetRenderer(4, r);
                //    this.gpDetail.ColumnModel.SetEditable(4, true);
                //}

                //已发货数量信息不显示
                //this.gpDetail.ColumnModel.SetHidden(11, true);
                //this.gpDetail.ColumnModel.SetHidden(7, true);
                //this.TabFinance.Disabled = false;
                //this.TabFinance.Visible = true;
                this.txtCarrier.ReadOnly = true;
                //this.cbSales.Disabled = false;
                //this.txtShipToAddress.ReadOnly = true;


                //如果订单时BOM订单，则不允许删除明细行
                if (header.OrderType == PurchaseOrderType.BOM.ToString())
                {
                    r.Fn = "SetCellCssNonEditable";
                    this.gpDetail.ColumnModel.SetRenderer(3, r);
                    this.gpDetail.ColumnModel.SetEditable(3, false);
                    this.gpDetail.ColumnModel.SetHidden(12, true);
                }


                if (corpType.Equals(DealerType.LP.ToString()) || corpType.Equals(DealerType.LS.ToString()))
                {
                    this.txtCrossDock.ReadOnly = false;
                    this.txtCrossDock.Show();

                    //this.cbSales.Hide();
                }
                else
                {
                    this.txtCrossDock.ReadOnly = true;
                    this.txtCrossDock.Hide();

                    //this.cbSales.Show();
                }
                //如果是清指定批号订单，且经销商为直销医院，仓库和收货地址不能更改。且收货地址要根据收货仓库获取
                DealerMaster Dealer = _Masts.GetDealerMaster(header.DmaId.Value);
                hidDealerTaxpayer.Text = Dealer.Taxpayer;
                if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString() && Dealer.Taxpayer == "直销医院")
                {

                    cbWarehouse.Disabled = true;
                    cbSAPWarehouseAddress.Disabled = true;


                    if (!string.IsNullOrEmpty(hidWarehouse.Text))
                    {
                        DataSet wds = _business.SelectSAPWarehouseAddressByWhmId(hidWarehouse.Text);
                        if (wds.Tables[0].Rows[0]["SWA_WH_Address"] != DBNull.Value)
                        {
                            hidSAPWarehouseAddress.Text = wds.Tables[0].Rows[0]["SWA_WH_Address"].ToString();
                        }
                    }
                }

                //Edit By Song Weiming on 2018-10-10 清指定批号订单不能删除明细行,且不可修改批号，不可修改任何内容
                if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
                {
                    r.Fn = "SetCellCssNonEditable";
                    this.gpDetail.ColumnModel.SetRenderer(3, r);
                    this.gpDetail.ColumnModel.SetRenderer(4, r);
                    this.gpDetail.ColumnModel.SetRenderer(7, r);
                    this.gpDetail.ColumnModel.SetRenderer(10, r);
                    this.gpDetail.ColumnModel.SetEditable(3, false);
                    this.gpDetail.ColumnModel.SetEditable(4, false);
                    this.gpDetail.ColumnModel.SetEditable(7, false);
                    this.gpDetail.ColumnModel.SetEditable(10, false);
                    this.gpDetail.ColumnModel.SetHidden(12, true);
                    this.btnDeleteDraft.Hide();
                    this.btnSaveDraft.Hide();
                }
            }
            //如果是T1或LP或LS，且单据创建类型是临时
            else if (IsDealer && (corpType.Equals(DealerType.T1.ToString()) || corpType.Equals(DealerType.LP.ToString()) || corpType.Equals(DealerType.LS.ToString())) && header.CreateType.Equals(PurchaseOrderCreateType.Temporary.ToString()))
            {
                //隐藏复制、保存草稿、删除草稿、申请关闭的按钮、显示提交、放弃修改按钮
                this.btnCopy.Hide();
                this.btnRevoke.Hide();
                this.btnClose.Hide();
                this.lbRejectReason.HideLabel = true;
                this.txtRejectReason.Hidden = true;
                this.btnDeleteDraft.Hide();
                this.btnSaveDraft.Hide();
                //产品数量可编辑
                Renderer r = new Renderer();
                r.Fn = "SetCellCssEditable";
                this.gpDetail.ColumnModel.SetRenderer(3, r);
                this.gpDetail.ColumnModel.SetRenderer(10, r);
                this.gpAttachment.ColumnModel.SetHidden(7, false);
                this.btnhospital.Enabled = true;
                this.ReceivingWay.Enabled = true;
                //如果是特殊价格订单或交接订单、则可以修改价格
                if (header.OrderType == PurchaseOrderType.SpecialPrice.ToString() || header.OrderType == PurchaseOrderType.Transfer.ToString())
                {
                    this.gpDetail.ColumnModel.SetRenderer(4, r);
                    this.gpDetail.ColumnModel.SetEditable(4, true);
                }
                //已发货数量信息不显示
                //this.gpDetail.ColumnModel.SetHidden(11, true);
                //this.TabFinance.Disabled = false;
                //this.TabFinance.Visible = true;
                this.txtCarrier.ReadOnly = true;
                //this.cbSales.Disabled = false;
                //this.txtShipToAddress.ReadOnly = true;

                if (header.OrderType == PurchaseOrderType.BOM.ToString())
                {
                    r.Fn = "SetCellCssNonEditable";
                    this.gpDetail.ColumnModel.SetRenderer(3, r);
                    this.gpDetail.ColumnModel.SetEditable(3, false);
                    this.gpDetail.ColumnModel.SetHidden(12, true);

                }

                if (corpType.Equals(DealerType.LP.ToString()) || corpType.Equals(DealerType.LS.ToString()))
                {
                    this.txtCrossDock.ReadOnly = false;
                    this.txtCrossDock.Show();
                    //this.cbSales.Hide();
                }
                else
                {
                    this.txtCrossDock.ReadOnly = true;
                    this.txtCrossDock.Hide();
                    //this.cbSales.Show();
                }

            }
            else
            {
                //产品数量不可编辑
                Renderer r = new Renderer();
                r.Fn = "SetCellCssNonEditable";
                this.gpDetail.ColumnModel.SetRenderer(3, r);
                this.gpDetail.ColumnModel.SetRenderer(10, r);
                this.gpDetail.ColumnModel.SetRenderer(4, r);


                this.cbProductLine.Disabled = true;
                this.cbOrderType.Disabled = true;
                this.cbWarehouse.Disabled = true;
                this.cbSAPWarehouseAddress.Disabled = true;
                this.cbPointType.Disabled = true;
                //this.cbTerritory.Disabled = true;

                this.txtRemark.ReadOnly = true;
                this.cbSpecialPrice.Disabled = true;

                this.txtContactPerson.ReadOnly = true;
                this.txtContact.ReadOnly = true;
                this.txtContactMobile.ReadOnly = true;
                this.txtConsignee.ReadOnly = true;
                this.txtConsigneePhone.ReadOnly = true;
                this.dtRDD.Disabled = true;
                this.txtCarrier.ReadOnly = true;
                //this.txtShipToAddress.ReadOnly = true;

                this.Toolbar1.Disabled = true;
                //this.btnAddCfnSet.Disabled = true;

                this.gpDetail.ColumnModel.SetEditable(3, false);
                this.gpDetail.ColumnModel.SetEditable(4, false);
                this.gpDetail.ColumnModel.SetEditable(10, false);
                //this.gpDetail.ColumnModel.SetHidden(6, true);
                this.gpDetail.ColumnModel.SetHidden(7, true);
                this.gpDetail.ColumnModel.SetHidden(12, true);
                this.gpAttachment.ColumnModel.SetHidden(7, true);

                this.btnSaveDraft.Hide();
                this.btnDeleteDraft.Hide();
                this.btnSubmit.Hide();
                this.btnDiscardModify.Hide();
                this.btnUsePro.Hide();

                //this.btnAddAttach.Disabled = true;

                //如果不是物流平台和一级经销商
                if (!IsDealer || (!corpType.Equals(DealerType.T1.ToString()) && !corpType.Equals(DealerType.LP.ToString()) && !corpType.Equals(DealerType.LS.ToString())))
                {
                    this.btnCopy.Hide();
                    this.btnRevoke.Hide();
                    this.btnClose.Hide();
                    this.lbRejectReason.HideLabel = true;
                    this.txtRejectReason.Hidden = true;

                    //if (!string.IsNullOrEmpty(header.SalesAccount))
                    //{
                    //    this.cbSales.Show();
                    //}
                    //else
                    //{
                    //    this.cbSales.Hide();
                    //}
                }
                else
                {
                    //如果单据类型不是交接订单、普通订单、特殊价格订单、近效期退换货订单、非近效期退换货订单、特殊清指定批号订单，则不能复制、不能撤销订单
                    if (header.OrderType == PurchaseOrderType.Normal.ToString() || header.OrderType == PurchaseOrderType.SpecialPrice.ToString() || header.OrderType == PurchaseOrderType.Transfer.ToString() || header.OrderType == PurchaseOrderType.PEGoodsReturn.ToString() || header.OrderType == PurchaseOrderType.EEGoodsReturn.ToString() || header.OrderType == PurchaseOrderType.BOM.ToString() || header.OrderType == PurchaseOrderType.PRO.ToString() || header.OrderType == PurchaseOrderType.CRPO.ToString())
                    {

                        //单据状态不是“已提交”、“已同意”、“已进入SAP”，则不能撤销
                        if (header.OrderStatus != PurchaseOrderStatus.Submitted.ToString() && header.OrderStatus != PurchaseOrderStatus.Approved.ToString() && header.OrderStatus != PurchaseOrderStatus.Uploaded.ToString())
                        {
                            this.btnRevoke.Hide();
                            this.lbRejectReason.HideLabel = true;
                            this.txtRejectReason.Hidden = true;
                        }
                        if (header.OrderStatus != PurchaseOrderStatus.Delivering.ToString())
                        {
                            this.btnClose.Hide();
                            this.lbRejectReason.HideLabel = true;
                            this.txtRejectReason.Hidden = true;
                        }
                    }
                    //Edited By Song Yuqi On 2015-12-18 For 针对T1经销商短期寄售订单可以撤销和关闭 Begin
                    else if (header.OrderType == PurchaseOrderType.Consignment.ToString())
                    {
                        //单据状态不是“已提交”、“已同意”、“已进入SAP”，则不能撤销
                        if (header.OrderStatus != PurchaseOrderStatus.Submitted.ToString() && header.OrderStatus != PurchaseOrderStatus.Approved.ToString() && header.OrderStatus != PurchaseOrderStatus.Uploaded.ToString())
                        {
                            this.btnRevoke.Hide();
                            this.lbRejectReason.HideLabel = true;
                            this.txtRejectReason.Hidden = true;
                        }
                        if (header.OrderStatus != PurchaseOrderStatus.Delivering.ToString())
                        {
                            this.btnClose.Hide();
                            this.lbRejectReason.HideLabel = true;
                            this.txtRejectReason.Hidden = true;
                        }
                    }
                    else if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString())
                    {
                        this.btnRevoke.Hide();
                    }
                    //Edited By Song Yuqi On 2015-12-18 For 针对T1经销商短期寄售订单可以撤销和关闭 End
                    //Edited By huyong 样品订单和短期寄售转移 可以撤销和修改，不能关闭↓
                    else if (header.OrderType == PurchaseOrderType.SampleApply.ToString() || header.OrderType == PurchaseOrderType.ZTKB.ToString())
                    {
                        this.btnClose.Hide();
                    }
                    else
                    {
                        this.btnRevoke.Hide();
                        this.btnCopy.Hide();
                        this.btnClose.Hide();
                        this.lbRejectReason.HideLabel = true;
                        this.txtRejectReason.Hidden = true;

                    }
                    if (header.OrderType == PurchaseOrderType.PRO.ToString() || header.OrderType == PurchaseOrderType.CRPO.ToString() || header.OrderType == PurchaseOrderType.BOM.ToString())
                    {
                        this.btnCopy.Hide();
                    }

                }
                //this.TabFinance.Disabled = true;
                //this.TabFinance.Visible = false;

                //this.cbSales.Disabled = true;
                this.txtCrossDock.ReadOnly = true;
                this.txtCrossDock.Hide();


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
            this.hidSAPWarehouseAddress.Clear();
            this.hidWareHouseType.Clear();
            this.hidPriceType.Clear();
            this.hidSpecialPrice.Clear();
            this.hidUpdateDate.Clear();
            this.hidVenderId.Clear();
            this.hidDealerTaxpayer.Clear();

            //this.cbDealer.SelectedItem.Value = "";
            this.cbProductLine.SelectedItem.Value = "";
            this.txtOrderNo.Clear();
            this.txtOrderStatus.Clear();
            this.txtSubmitDate.Clear();
            //this.cbTerritory.SelectedItem.Value = "";

            this.txtOrderTo.Clear();
            this.txtDealer.Clear();
            this.cbOrderType.SelectedItem.Value = "";
            this.cbWarehouse.SelectedItem.Value = "";
            this.cbSAPWarehouseAddress.SelectedItem.Value = "";

            this.txtTotalAmount.Clear();
            this.txtTotalQty.Clear();
            this.txtRemark.Clear();
            this.txtVirtualDC.Clear();

            this.cbSpecialPrice.SelectedItem.Value = "";
            this.txtSpecialPrice.Clear();
            this.txtContactPerson.Clear();
            this.txtContact.Clear();
            this.txtContactMobile.Clear();
            this.txtRejectReason.Clear();

            //this.txtShipToAddress.Clear();
            this.txtConsignee.Clear();
            this.txtConsigneePhone.Clear();
            this.dtRDD.Clear();
            this.txtCarrier.Clear();
            this.txtCrossDock.Clear();

            //使用积分汇总信息
            this.cbPointType.SelectedItem.Value = "";
            this.hidPointType.Clear();

            //订单币种维护
            this.txtCurrency.Text = "";

            this.Texthospitalname.Clear();
            this.HospitalAddress.Clear();
            this.Deliver.Checked = false;
            this.PickUp.Checked = false;
        }

        private void SetFormValue(PurchaseOrderHeader header)
        {
            //表头信息
            this.DealerId = header.DmaId.Value;
            this.txtDealer.Text = DealerCacheHelper.GetDealerById(header.DmaId.Value).ChineseName;

            this.hidProductLine.Text = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "";
            this.PageStatus = (PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), header.OrderStatus, true);

            this.hidLatestAuditDate.Text = header.LatestAuditDate.HasValue ? header.LatestAuditDate.Value.ToString() : "";

            this.txtOrderNo.Text = header.OrderNo;
            this.txtOrderStatus.Text = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Order_Status, header.OrderStatus);

            this.hidOrderType.Text = header.OrderType;

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
            this.txtVirtualDC.Text = header.Virtualdc;
            //订单信息            
            this.hidSpecialPrice.Text = header.PointType;
            //if (header.SpecialPriceid.HasValue)
            //{
            //    this.txtSpecialPrice.Text = _speicalPrice.GetSpecialPriceMasterByID(header.SpecialPriceid.Value).Code;
            //}

            this.txtContactPerson.Text = header.ContactPerson;
            this.txtContact.Text = header.Contact;
            this.txtContactMobile.Text = header.ContactMobile;

            //收货信息
            this.hidWarehouse.Text = header.WhmId.HasValue ? header.WhmId.Value.ToString() : "";
            this.hidSAPWarehouseAddress.Text = header.ShipToAddress;
            //this.txtShipToAddress.Text = header.ShipToAddress;
            this.txtConsignee.Text = header.Consignee;
            this.txtConsigneePhone.Text = header.ConsigneePhone;
            this.Texthospitalname.Text = header.SendHospital;
            this.HospitalAddress.Text = header.SendAddress;

            this.txtCarrier.Text = header.TerritoryCode;//将区域代码字段用作承运商信息
            this.hidTerritoryCode.Text = header.TerritoryCode; //承运商信息
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
            if (header.Rdd.HasValue)
            {
                this.dtRDD.SelectedDate = header.Rdd.Value;
            }
            //设定期望到货日期只能选取当前时间之后的日期
            this.dtRDD.MinDate = DateTime.Now.AddDays(1);

            this.hidPohId.Text = header.PohId.HasValue ? header.PohId.Value.ToString() : "";
            this.hidCreateType.Text = header.CreateType;
            this.hidUpdateDate.Text = header.UpdateDate.ToString();
            //hidSalesAccount.Text = header.SalesAccount;
            this.hidPointType.Text = header.PointType;

            this.hidIsUsePro.Text = string.IsNullOrEmpty(header.IsUsePro) ? "0" : header.IsUsePro;

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
            header.IsUsePro = "0";

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
                header.Contact = dsh.Email;
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
            header.OrderType = string.IsNullOrEmpty(this.hidOrderType.Text) ? "" : this.hidOrderType.Text;

            //汇总信息
            header.Remark = this.txtRemark.Text;
            header.Virtualdc = this.txtVirtualDC.Text;
            //订单信息
            //如果OrderType不是特殊价格订单，则Header表中的SpecialPriceid为空
            if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.SpecialPrice.ToString()))
            {
                //促销政策改为保存在PointType字段中
                header.SpecialPriceid = null as Guid?;//string.IsNullOrEmpty(this.cbSpecialPrice.SelectedItem.Value) ? null as Guid? : new Guid(this.cbSpecialPrice.SelectedItem.Value);
                header.IsUsePro = string.IsNullOrEmpty(this.hidIsUsePro.Text) ? "0" : this.hidIsUsePro.Text;
            }
            else
            {
                header.SpecialPriceid = null as Guid?;
            }
            header.Vendorid = string.IsNullOrEmpty(this.hidVenderId.Text) ? null : this.hidVenderId.Text;
            header.ContactPerson = this.txtContactPerson.Text;
            header.Contact = this.txtContact.Text;
            header.ContactMobile = this.txtContactMobile.Text;
            //收货信息
            // header.WhmId = string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value) ? null as Guid? : new Guid(this.cbWarehouse.SelectedItem.Value);
            header.WhmId = string.IsNullOrEmpty(this.hidWarehouse.Text) ? null as Guid? : new Guid(this.cbWarehouse.SelectedItem.Value);
            // header.ShipToAddress = this.cbSAPWarehouseAddress.SelectedItem.Value;
            header.ShipToAddress = this.hidSAPWarehouseAddress.Text;

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
            //header.SalesAccount = this.cbSales.SelectedItem.Value;
            header.PointType = this.cbOrderType.SelectedItem.Value.ToString().Equals(PurchaseOrderType.CRPO.ToString()) ? this.cbPointType.SelectedItem.Value : this.cbOrderType.SelectedItem.Value.ToString().Equals(PurchaseOrderType.SpecialPrice.ToString()) ? this.cbSpecialPrice.SelectedItem.Value : "";
            if (this.Deliver.Checked)
            {
                header.DcType = "Deliver";
            }
            else
                header.DcType = "PickUp";
            header.SendAddress = this.HospitalAddress.Text;
            header.SendHospital = this.Texthospitalname.Text;
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
                    this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.Consignment.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.PRO.ToString()) || this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.Return.ToString()))
                {
                    this.txtTotalAmount.Text = Convert.ToDecimal(0).ToString("F2");
                }
                else if (this.cbOrderType.SelectedItem.Value.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    this.txtTotalAmount.Text = (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"])).ToString("F2");
                }
                else
                {
                    this.txtTotalAmount.Text = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2");
                }


            }
        }

        //
        protected void Bind_SpecialPrice(Store store)
        {

            //取得经销商可用的特殊价格政策            
            Hashtable param = new Hashtable();

            if (!(this.DealerId == null))
            {
                param.Add("DealerId", this.DealerId.ToString());
            }

            if (!string.IsNullOrEmpty(this.hidProductLine.Text))
            {
                param.Add("ProductLineId", this.hidProductLine.Text);
            }

            DataSet ds = null;
            if (IsDealer && (this.PageStatus == PurchaseOrderStatus.Draft || this.hidCreateType.Text.Equals(PurchaseOrderCreateType.Temporary.ToString())))
            {
                //获取可选择的特殊价格政策
                ds = _speicalPrice.GetPromotionPolicyByCondition(param);
            }
            else
            {
                //获取单据选择的特殊价格政策
                ds = _speicalPrice.GetPromotionPolicyById(this.InstanceId);
            }
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
                //this.lbPolicyDetail.Hidden = false;
                this.pPolicyContent.Show();

                if (this.txtOrderStatus.Text == PurchaseOrderStatus.Draft.ToString())
                {
                    this.btnUsePro.Hidden = false;
                }
                else
                {
                    this.btnUsePro.Hidden = true;
                }
            }
            else
            {
                this.cbSpecialPrice.Hidden = true;
                this.txtSpecialPrice.Hidden = true;
                //this.lbPolicyDetail.Hidden = true;
                this.pPolicyContent.Hide();
                this.btnUsePro.Hidden = true;
            }
        }


        protected internal virtual void Bind_OrderTypeForLP(Store store, string type)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DMA_ID", this.DealerId.ToString());
            obj.Add("PermissionsType", "PromotionOrder");
            string CheckPolicy = _business.CheckDealerPermissions(obj).ToString();


            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            //如果单据状态是草稿状态或订单的类型是Temporary，则只显示特殊价格订单、普通订单、交接订单
            if (this.PageStatus.ToString().Equals(PurchaseOrderStatus.Draft.ToString()) || this.hidCreateType.Text.Equals(PurchaseOrderCreateType.Temporary.ToString()))
            {
                if (CheckPolicy.Equals("0"))
                {
                    if (IsPageNew)
                    {
                        store.DataSource = (from t in dicts
                                            where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                   t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                   t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                   t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.BOM.ToString())
                                            select t);

                    }
                    else
                    {

                        store.DataSource = (from t in dicts
                                            where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                   t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                   t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                   t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                                   t.Key == PurchaseOrderType.BOM.ToString())
                                            select t);
                    }

                }

                else
                {
                    if (IsPageNew)
                    {
                        store.DataSource = (from t in dicts
                                            where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                   t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                   t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                   t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.BOM.ToString() ||
                                                   t.Key == PurchaseOrderType.PRO.ToString() ||
                                                   t.Key == PurchaseOrderType.CRPO.ToString())
                                            select t);
                    }
                    else
                    {
                        store.DataSource = (from t in dicts
                                            where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                   t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                   t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                   t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                   t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                                   t.Key == PurchaseOrderType.BOM.ToString() ||
                                                   t.Key == PurchaseOrderType.PRO.ToString() ||
                                                   t.Key == PurchaseOrderType.CRPO.ToString())
                                            select t);
                    }
                }

            }
            else
            {
                if (CheckPolicy.Equals("0"))
                {
                    store.DataSource = (from t in dicts
                                        where (
                                               t.Key != PurchaseOrderType.PRO.ToString() &&
                                               t.Key != PurchaseOrderType.CRPO.ToString())
                                        select t);
                }
                else
                {
                    store.DataSource = (from t in dicts select t);
                }
            }
            store.DataBind();
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
        #endregion
        [AjaxMethod]
        public void DoAddItems(string param1, string param2)
        {

            this.Texthospitalname.Text = param1;
            this.HospitalAddress.Text = param2;
            this.HospitalAddress.Enabled = true;
        }
        [AjaxMethod]
        public void ChanageRadio()
        {
            if (this.PickUp.Checked)
            {

                this.btnhospital.Enabled = false;
                this.HospitalAddress.Enabled = false;
                this.Texthospitalname.Text = "";
                this.HospitalAddress.Text = "";

            }
            else
            {
                this.btnhospital.Enabled = true;
                this.Texthospitalname.Text = "";
                this.HospitalAddress.Text = "";

            }

        }

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