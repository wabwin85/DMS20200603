using DMS.Business;
using DMS.Business.Cache;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Order;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Order
{
    public class OrderApplyLPInfoService : ABaseQueryService, IDealerFilterFac
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _business = new PurchaseOrderBLL();
        private IWarehouses _warehouse = new DMS.Business.Warehouses();
        private IContractMaster _contractMaster = new ContractMaster();
        private IInventoryAdjustBLL _invAdjBiz = new InventoryAdjustBLL();
        private IAttachmentBLL _attachBll = new AttachmentBLL();

        private IVirtualDC _virtualdc = new DMS.Business.VirtualDC();
        private ISpecialPriceBLL _speicalPrice = new SpecialPriceBLL();
        private IDealerMasters _Masts = new DealerMasters();

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public OrderApplyLPInfoVO Init(OrderApplyLPInfoVO model)
        {
            try
            {
                string DealerId = string.Empty;
                DealerId = model.hidDealerId;//coolite修改采用的是上次 HeadId?
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                PurchaseOrderHeader header = new PurchaseOrderHeader();
                if (model.IsNewApply)
                {
                    header = GetNewPurchaseOrderHeader(InstanceId);
                }
                else
                {
                    header = _business.GetPurchaseOrderHeaderById(InstanceId);
                }
                model.InstanceId = header.Id.ToSafeString();
                model.IsDealer = IsDealer;
                model.DealerType = RoleModelContext.Current.User.CorpType;
                model.EntityModel = JsonHelper.Serialize(header);
                model.LstBu = base.GetProductLine();

                int totalCount = 0;
                SetFormValue(model, header);
                CaculateFormValue(model, InstanceId);

                //订单类型
                model.LstOrderType = OrderTypeStore_RefreshData(header.OrderStatus, model.hidDealerId, model.hidCreateType, model.IsNewApply, SR.Consts_Order_Type);
                //获取积分类型
                model.LstPointType = new ArrayList(DictionaryHelper.GetDictionary(SR.PRO_PointType).ToList());
                //经销商
                List<DealerMaster> dealerList = DealerList().ToList();
                DealerMaster dealer = dealerList.Where(s => s.Id == new Guid(model.hidDealerId)).FirstOrDefault();
                dealerList = new List<DealerMaster>();
                dealerList.Add(dealer);
                model.QryDealer = new KeyValue(model.hidDealerId, dealer.ChineseName);
                model.LstDealer = new ArrayList(dealerList);
                //经销商对应的仓库
                //  model.LstWarehouse = new ArrayList(WarehouseByDealer(model.hidDealerId, model.hidWareHouseType).ToList());
                //收货仓库对应地址
                model.LstShipToAddress = new ArrayList(Bind_SAPWarehouseAddress(new Guid(DealerId)).ToList());
                //产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                //发货明细
                dsDetail = new PurchaseOrderBLL().QueryPoReceiptOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstShipDetail = JsonHelper.DataTableToArrayList(dtProduct);
                //发票明细
                InvoiceStore_RefershData(model);
                //政策相关数据
                Bind_SpecialPrice(model, InstanceId);
                //附件
                AttachmentStore_Refresh(model);
                //日志
                DataTable dtLog = _business.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
                model.RstLogDetail = JsonHelper.DataTableToArrayList(dtLog);


            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        private void SetFormValue(OrderApplyLPInfoVO model, PurchaseOrderHeader header)
        {
            //表头信息  
            model.hidDealerId = header.DmaId.HasValue ? header.DmaId.Value.ToString() : Guid.Empty.ToSafeString();
            model.Dealer = DealerCacheHelper.GetDealerById(header.DmaId.Value).ChineseName;
            model.hidProductLine = header.ProductLineBumId.HasValue ? header.ProductLineBumId.Value.ToString() : "";
            model.hidOrderStatus = ((PurchaseOrderStatus)Enum.Parse(typeof(PurchaseOrderStatus), header.OrderStatus, true)).ToString();
            model.hidLatestAuditDate = header.LatestAuditDate.HasValue ? header.LatestAuditDate.Value.ToString() : "";

            model.QryOrderNO = header.OrderNo;
            model.QryOrderStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_Order_Status, header.OrderStatus);
            model.hidOrderType = header.OrderType;

            if (string.IsNullOrEmpty(header.Vendorid))
            {
                model.QryOrderTo = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).ChineseName;
                model.hidVenderId = DealerCacheHelper.GetDealerById(DealerCacheHelper.GetDealerById(header.DmaId.Value).ParentDmaId.Value).Id.ToString();
            }
            else
            {
                model.QryOrderTo = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).ChineseName;
                model.hidVenderId = DealerCacheHelper.GetDealerById(new Guid(header.Vendorid.ToString())).Id.ToString();
            }

            model.QrySubmitDate = header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd HH:mm:ss") : "";

            //汇总信息
            model.QryRemark = header.Remark;
            model.QryVirtualDC = header.Virtualdc;
            //订单信息            
            model.hidSpecialPrice = header.PointType;

            model.QryContactPerson = header.ContactPerson;
            model.QryContact = header.Contact;
            model.QryContactMobile = header.ContactMobile;

            //收货信息
            model.hidWarehouse = header.WhmId.HasValue ? header.WhmId.Value.ToString() : "";
            model.hidSAPWarehouseAddress = header.ShipToAddress;
            //this.txtShipToAddress.Text = header.ShipToAddress;
            model.QryConsignee = header.Consignee;
            model.QryConsigneePhone = header.ConsigneePhone;
            model.QryTexthospitalname = header.SendHospital;
            model.QryHospitalAddress = header.SendAddress;

            model.QryCarrier = header.TerritoryCode;//将区域代码字段用作承运商信息
            model.hidTerritoryCode = header.TerritoryCode; //承运商信息

            if (header.DcType == "PickUp")
            {
                //this.PickUp.Checked = true;
                //this.Deliver.Checked = false;
                model.QryPickUp = true;
                model.QryDeliver = false;
            }
            if (header.DcType == "Deliver" || header.DcType == null)
            {
                //this.Deliver.Checked = true;
                //this.PickUp.Checked = false;
                model.QryPickUp = false;
                model.QryDeliver = true;
            }
            if (header.Rdd.HasValue)
            {
                model.QryRDD = header.Rdd.Value.ToString("yyyy-MM-dd");
            }
            //设定期望到货日期只能选取当前时间之后的日期
            //this.dtRDD.MinDate = DateTime.Now.AddDays(1);

            model.hidPohId = header.PohId.HasValue ? header.PohId.Value.ToString() : "";
            model.hidCreateType = header.CreateType;
            model.hidUpdateDate = header.UpdateDate.ToString();
            model.hidPointType = header.PointType;

            model.hidIsUsePro = string.IsNullOrEmpty(header.IsUsePro) ? "0" : header.IsUsePro;

            Hashtable objCurrency = new Hashtable();
            objCurrency.Add("SubmintDate", header.SubmitDate.HasValue ? header.SubmitDate.Value.ToString("yyyy-MM-dd") : DateTime.Now.ToShortDateString());
            objCurrency.Add("DealerId", header.DmaId.Value);
            model.QryCurrency = _business.GetPurchaseOrderCarrierById(objCurrency);

        }
        public OrderApplyLPInfoVO GetLstWarehouse(OrderApplyLPInfoVO model)
        {
            try
            {
                //查询产品明细
                model.LstWarehouse = new ArrayList(WarehouseByDealer(model.hidDealerId, model.hidWareHouseType).ToList());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        public OrderApplyLPInfoVO GetBorrowManual(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                PurchaseOrderHeader header = new PurchaseOrderHeader();
                header = _business.GetPurchaseOrderHeaderById(InstanceId);

                //如果是清指定批号订单，且经销商为直销医院，仓库和收货地址不能更改。且收货地址要根据收货仓库获取
                DealerMaster Dealer = _Masts.GetDealerMaster(header.DmaId.Value);
                model.hidDealerTaxpayer = Dealer.Taxpayer;
                if (header.OrderType == PurchaseOrderType.ClearBorrowManual.ToString() && Dealer.Taxpayer == "直销医院")
                {
                    if (!string.IsNullOrEmpty(model.hidWarehouse))
                    {
                        DataSet wds = _business.SelectSAPWarehouseAddressByWhmId(model.hidWarehouse);
                        if (wds.Tables[0].Rows[0]["SWA_WH_Address"] != DBNull.Value)
                        {
                            model.hidSAPWarehouseAddress = wds.Tables[0].Rows[0]["SWA_WH_Address"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        private void CaculateFormValue(OrderApplyLPInfoVO model, Guid InstanceId)
        {
            DataSet ds = _business.SumPurchaseOrderByHeaderId(InstanceId);
            if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
            {
                model.QryTotalQty = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalQty"]).ToString("F2");
                model.QryTotalReceiptQty = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalReceiptQty"]).ToString("F2");
                //Edit By Songweiming on 2013-11-18 如果是近效期退换货或者是非近效期退换货订单，则金额为0
                if (model.QryOrderType.Key.Equals(PurchaseOrderType.PEGoodsReturn.ToString()) || model.QryOrderType.Key.Equals(PurchaseOrderType.EEGoodsReturn.ToString()) ||
                    model.QryOrderType.Key.Equals(PurchaseOrderType.Consignment.ToString()) || model.QryOrderType.Key.Equals(PurchaseOrderType.PRO.ToString()) || model.QryOrderType.Key.Equals(PurchaseOrderType.Return.ToString()))
                {
                    model.QryTotalAmount = Convert.ToDecimal(0).ToString("F2");
                }
                else if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    model.QryTotalAmount = (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"])).ToString("F2");
                }
                else
                {
                    model.QryTotalAmount = Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2");
                }
            }
        }

        /// <summary>
        /// 修改dropdownlist重新计算表头信息，可扩展查询产品明细
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO RefershHeadData(OrderApplyLPInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //查询产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
                CaculateFormValue(model, InstanceId);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }

        /// <summary>
        /// 订单类型
        /// </summary>
        /// <param name="PageStatus">单据状态</param>
        protected ArrayList OrderTypeStore_RefreshData(string PageStatus, string DealerId, string hidCreateType, bool IsPageNew, string type)
        {
            Hashtable obj = new Hashtable();
            obj.Add("DMA_ID", DealerId);
            obj.Add("PermissionsType", "PromotionOrder");
            string CheckPolicy = _business.CheckDealerPermissions(obj).ToString();


            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            //如果单据状态是草稿状态或订单的类型是Temporary，则只显示特殊价格订单、普通订单、交接订单
            if (PageStatus.ToString().Equals(PurchaseOrderStatus.Draft.ToString()) || hidCreateType.Equals(PurchaseOrderCreateType.Temporary.ToString()))
            {
                if (CheckPolicy.Equals("0"))
                {
                    if (IsPageNew)
                    {
                        var resultType = (from t in dicts
                                          where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                 t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                 t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                 //t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                 //t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                 t.Key == PurchaseOrderType.BOM.ToString())
                                          select t);
                        return new ArrayList(resultType.ToList());

                    }
                    else
                    {

                        var resultType = (from t in dicts
                                          where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                 t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                 t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                 //t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                 //t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                 t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                                 t.Key == PurchaseOrderType.BOM.ToString())
                                          select t);
                        return new ArrayList(resultType.ToList());
                    }

                }

                else
                {
                    if (IsPageNew)
                    {
                        var resultType = (from t in dicts
                                          where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                 t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                 t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                 //t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                 //t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                 t.Key == PurchaseOrderType.BOM.ToString() ||
                                                 t.Key == PurchaseOrderType.PRO.ToString() ||
                                                 t.Key == PurchaseOrderType.CRPO.ToString())
                                          select t);
                        return new ArrayList(resultType.ToList());
                    }
                    else
                    {
                        var resultType = (from t in dicts
                                          where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                                 t.Key == PurchaseOrderType.Transfer.ToString() ||
                                                 t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                                 //t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                                 //t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                                 t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                                 t.Key == PurchaseOrderType.BOM.ToString() ||
                                                 t.Key == PurchaseOrderType.PRO.ToString() ||
                                                 t.Key == PurchaseOrderType.CRPO.ToString())
                                          select t);
                        return new ArrayList(resultType.ToList());
                    }
                }

            }
            else
            {
                if (CheckPolicy.Equals("0"))
                {
                    var resultType = (from t in dicts
                                      where (
                                             t.Key != PurchaseOrderType.PRO.ToString() &&
                                             t.Key != PurchaseOrderType.CRPO.ToString())
                                      select t);
                    return new ArrayList(resultType.ToList());
                }
                else
                {
                    var resultType = (from t in dicts select t);
                    return new ArrayList(resultType.ToList());
                }
            }

        }
        /// <summary>
        /// 政策数据绑定
        /// </summary>
        /// <param name="model"></param>
        /// <param name="InstanceId"></param>
        public void Bind_SpecialPrice(OrderApplyLPInfoVO model, Guid InstanceId)
        {

            //取得经销商可用的特殊价格政策            
            Hashtable param = new Hashtable();

            if (!(string.IsNullOrEmpty(model.QryDealer.ToSafeString())))
            {
                param.Add("DealerId", model.QryDealer.Key.ToString());
            }

            if (!string.IsNullOrEmpty(model.hidProductLine))
            {
                param.Add("ProductLineId", model.hidProductLine);
            }

            DataSet ds = null;
            if (IsDealer && (model.hidOrderStatus == PurchaseOrderStatus.Draft.ToString() || model.hidCreateType.Equals(PurchaseOrderCreateType.Temporary.ToString())))
            {
                //获取可选择的特殊价格政策
                ds = _speicalPrice.GetPromotionPolicyByCondition(param);
            }
            else
            {
                //获取单据选择的特殊价格政策
                ds = _speicalPrice.GetPromotionPolicyById(InstanceId);
            }
            DataTable dtSlp = ds == null ? new DataTable() : ds.Tables[0];
            model.LstSpecialPrice = JsonHelper.DataTableToArrayList(dtSlp);
        }

        /// <summary>
        /// 初始化产品线
        /// </summary>
        public OrderApplyLPInfoVO ProductLineInit(OrderApplyLPInfoVO model)
        {
            try
            {
                if (!string.IsNullOrEmpty(model.QryProductLine.ToSafeString()))
                {
                    if (!string.IsNullOrEmpty(model.QryProductLine.Key))
                    {
                        //产品组初始化
                        if (model.IsNewApply)
                        {
                            //新增单据时，更新VirtualDC
                            Guid DealerId = new Guid(model.QryDealer.Key);
                            IList<Virtualdc> virtualdc = _virtualdc.QueryForPlant(DealerId, new Guid(model.hidProductLine));
                            if (virtualdc.Count > 0)
                            {
                                model.QryVirtualDC = virtualdc[0].Plant;
                            }
                        }

                        //更新特殊价格

                        SetSpecialPrice(model);
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 修改产品线
        /// </summary>
        public OrderApplyLPInfoVO ChangeProductLine(OrderApplyLPInfoVO model)
        {
            try
            {
                //更换产品组，删除订单原产品组下的所有产品
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.DeleteDetail(InstanceId);

                //更新Virtual DC                  
                if (!string.IsNullOrEmpty(model.QryProductLine.ToSafeString()))
                {
                    Guid DealerId = new Guid(model.QryDealer.Key);
                    IList<Virtualdc> virtualdc = _virtualdc.QueryForPlant(DealerId, new Guid(model.QryProductLine.Key));
                    if (virtualdc.Count > 0)
                    {
                        model.QryVirtualDC = virtualdc[0].Plant;
                    }
                    //SetSpecialPrice();
                }

                //更换产品组，删除订单原使用积分
                string orderType = string.IsNullOrEmpty(model.QryOrderType.ToSafeString()) ? "" : model.QryOrderType.Key;
                if (orderType.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    int i = _business.DeleteOrderPointByOrderHeaderId(InstanceId);
                }
                SetSpecialPrice(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        protected void SetSpecialPrice(OrderApplyLPInfoVO model)
        {
            //更新特殊价格
            // this.txtSpecialPrice.Clear();
            Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
            Bind_SpecialPrice(model, InstanceId);
            string orderType = string.IsNullOrEmpty(model.QryOrderType.ToSafeString()) ? "" : model.QryOrderType.Key;
            //if (orderType.Equals(PurchaseOrderType.SpecialPrice.ToString()))
            //{
            //    this.cbSpecialPrice.Hidden = false;
            //    this.txtSpecialPrice.Hidden = false;
            //    //this.lbPolicyDetail.Hidden = false;
            //    this.pPolicyContent.Show();

            //    if (model.QryOrderStatus == PurchaseOrderStatus.Draft.ToString())
            //    {
            //        this.btnUsePro.Hidden = false;
            //    }
            //    else
            //    {
            //        this.btnUsePro.Hidden = true;
            //    }
            //}
            //else
            //{
            //    this.cbSpecialPrice.Hidden = true;
            //    this.txtSpecialPrice.Hidden = true;
            //    //this.lbPolicyDetail.Hidden = true;
            //    this.pPolicyContent.Hide();
            //    this.btnUsePro.Hidden = true;
            //}
        }
        /// <summary>
        /// 修改促销政策
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO ChangeSpecialPrice(OrderApplyLPInfoVO model)
        {
            try
            {
                //更特殊价格政策，删除订单原产品组下的所有产品
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.DeleteDetail(InstanceId);

                //若选择的政策是“满额送赠品”或"一次性特殊价格",可以修改价格，否则不能修改
                //if (this.cbSpecialPrice.SelectedItem.Value == "满额打折")
                //{
                //    this.gpDetail.ColumnModel.SetEditable(3, false);
                //    this.gpDetail.ColumnModel.SetEditable(4, false);
                //}
                //else
                //{
                //    this.gpDetail.ColumnModel.SetEditable(3, true);
                //    this.gpDetail.ColumnModel.SetEditable(4, true);
                //}
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 更新产品明细
        /// </summary>
        /// <param name="model"></param>
        public OrderApplyLPInfoVO UpdateItem(OrderApplyLPInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid detailId = new Guid(model.EditItemId);
                PurchaseOrderDetail detail = new PurchaseOrderDetail();

                //判断lotnumber是否超过长度
                //Edit By Songweiming on 2013-11-21，不需要判断是哪种类型的申请单
                //if (this.hidOrderType.Text.Equals(PurchaseOrderType.Transfer.ToString()) && !string.IsNullOrEmpty(lot) && lot.Length > 30)
                if (!string.IsNullOrEmpty(model.EditLot) && model.EditLot.Length > 30)
                {
                    rtnVal = "LotTooLong";
                }

                //判断lotNumber是否存在
                //if (!string.IsNullOrEmpty(lot) && !_business.CheckLotNumberByUPN(lot, upn))
                if (!string.IsNullOrEmpty(model.EditLot) && !_business.CheckLotNumberByUPNQRCode(model.EditLot, model.EditUpn))
                {
                    rtnVal = "LotNotExists";
                }
                //Edit By Songweiming on 2013-11-21，不需要判断是哪种类型的申请单
                //else if (this.hidOrderType.Text.Equals(PurchaseOrderType.Transfer.ToString()) && _business.QueryLotNumberCount(detailId, lot) > 0)
                else if (_business.QueryLotNumberCount(detailId, model.EditLot) > 0 && !model.hidOrderType.Equals(PurchaseOrderType.ClearBorrowManual.ToString()))
                {
                    //先判断Detail表中是否存在修改后的lot号，如果已存在，则抛错（已存在此lotnumber的记录）
                    rtnVal = "LotExisted";
                }
                else if (_business.QueryLotPriceCount(detailId, model.EditUpn, model.EditLot, model.EditCfnPrice) > 0 && model.hidOrderType.ToString() == "SpecialPrice")
                {
                    //先判断Detail表中是否存在修改后的价格，如果已存在，则抛错（已存在此价格的记录）
                    rtnVal = "LotPriceExisted";
                }
                else
                {
                    detail = _business.GetPurchaseOrderDetailById(detailId);

                    if (!string.IsNullOrEmpty(model.EditQty))
                    {
                        detail.RequiredQty = Convert.ToDecimal(model.EditQty);
                    }
                    if (!string.IsNullOrEmpty(model.EditCfnPrice))
                    {

                        detail.CfnPrice = Convert.ToDecimal(model.EditCfnPrice);

                    }

                    detail.Amount = detail.RequiredQty * detail.CfnPrice;
                    //不需要计算税率
                    //detail.Tax = detail.RequiredQty * detail.CfnPrice * (SR.Consts_TaxRate - 1);
                    detail.Tax = detail.RequiredQty * detail.CfnPrice * 0;


                    if (string.IsNullOrEmpty(model.EditLot))
                    {
                        detail.LotNumber = null;
                    }
                    else
                    {
                        detail.LotNumber = model.EditLot.Trim();
                    }
                    //不可修改金额
                    //if (!string.IsNullOrEmpty(amt))
                    //{
                    //    detail.Amount = Convert.ToDecimal(amt);
                    //}

                    bool result = _business.UpdateCfn(detail);

                    //积分订单并能产品明细信息时删除当前绑定积分
                    if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                    {
                        int i = _business.DeleteOrderPointByOrderHeaderId(InstanceId);
                    }

                    rtnVal = "Success";
                }
                model.hidRtnVal = rtnVal;
            }
            catch (Exception ex)
            {
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
                LogHelper.Error(ex);
            }
            return model;
        }
        /// <summary>
        /// 发票信息
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void InvoiceStore_RefershData(OrderApplyLPInfoVO model)
        {
            int totalCount = 0;
            DataTable dtInvoince = new DataTable();
            Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
            DataSet ds = _business.QueryInvoiceByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);

            if (ds != null)
                dtInvoince = ds.Tables[0];
            model.RstInvoiceDetail = JsonHelper.DataTableToArrayList(dtInvoince);
        }


        #region 按钮事件

        /// <summary>
        /// 删除产品线
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DeleteItem(OrderApplyLPInfoVO model)
        {
            try
            {
                bool result = false;
                try
                {
                    result = _business.DeleteCfn(new Guid(model.LotId));
                }
                catch (Exception e)
                {
                    throw new Exception(e.Message);
                }

                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除异常");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }


        /// <summary>
        /// 保存草稿
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO SaveDraft(OrderApplyLPInfoVO model)
        {
            try
            {

                PurchaseOrderHeader header = this.GetFormValue(model);
                bool result = _business.SaveDraft(header);
                if (result)
                {
                    //  Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.True.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.True.Alert.Body").ToString()).Show();
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("保存成功");
                }
                else
                {
                    // Ext.Msg.Alert(GetLocalResourceObject("SaveDraft.False.Alert.Title").ToString(), GetLocalResourceObject("SaveDraft.False.Alert.Body").ToString()).Show();
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("保存失败");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 推送ERP
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO PushToERP(OrderApplyLPInfoVO model)
        {
            try
            {
                string msg = "";
                PurchaseOrderHeader header = this.GetFormValue(model);
                bool result = _business.PushToERP(header,out msg);
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("推送成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("推送失败:"+ msg);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 删除草稿
        /// </summary>
        public OrderApplyLPInfoVO DeleteDraft(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.DeleteDraft(InstanceId);
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("删除成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除草稿失败");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DoRevoke(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.RevokeLPOrder(InstanceId);
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("订单已撤销");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("订单无法撤销<BR/>可能订单状态已经改变，请刷新！");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 复制订单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DoCopy(OrderApplyLPInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid DealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);
                bool result = _business.Copy(InstanceId, DealerId, model.hidPriceType, out rtnVal, out rtnMsg);
                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("复制订单成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("复制订单失败！");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 放弃修改订单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DoDiscardModify(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.DiscardModify(InstanceId);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 申请关闭订单操作
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DoClose(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                bool result = _business.CloseLPOrder(InstanceId);
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("订单无法关闭，可能订单状态已经改变，请刷新！");
                    return model;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        /// <summary>
        /// 使用促销
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO UsePro(OrderApplyLPInfoVO model)
        {
            try
            {
                //调用Proc_Interface_Imm_PolicyFit，如果返回Success，控制界面操作，只能提交订单，不可让用户再修改订单了
                string Result = "";
                string RtnMsg = "";
                model.UseProStatus = false;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                _business.PolicyFit(InstanceId, model.QrySpecialPrice.Key, out Result, out RtnMsg);
                if (RtnMsg == "")
                {
                    model.UseProStatus = true;
                    PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(InstanceId);
                    header.IsUsePro = "1";
                    _business.UpdateOrderByOrder(header);

                    model.ExecuteMessage.Add("促销政策使用成功，请提交单据");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("促销政策使用失败");
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 提交
        /// </summary>
        public OrderApplyLPInfoVO Submit(OrderApplyLPInfoVO model)
        {
            try
            {
                String corpType = RoleModelContext.Current.User.CorpType;
                String crossDockingNo = "";
                if (corpType.Equals(DealerType.LP.ToString()) || corpType.Equals(DealerType.LS.ToString()))
                {
                    crossDockingNo = model.QryCrossDock;
                }
                PurchaseOrderHeader header = this.GetFormValue(model);
                bool result = _business.Submit(header, "");
                if (result)
                {
                    model.ExecuteMessage.Add("提交成功");
                }
                else
                {
                    // Ext.Msg.Alert(GetLocalResourceObject("DoSubmit.False.Alert.Title").ToString(), GetLocalResourceObject("DoSubmit.False.Alert.Body").ToString()).Show();
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("提交失败(可能为库存数量不足等情况，请联系管理员)");
                    return model;
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        private bool IsGuid(string strSrc)
        {
            if (String.IsNullOrEmpty(strSrc)) { return false; }

            bool _result = false;
            try
            {
                Guid _t = new Guid(strSrc);
                _result = true;
            }

            catch { }
            return _result;
        }
        /// <summary>
        /// 提交表单验证表单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO CheckSubmit(OrderApplyLPInfoVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                string promotionPolicyId = model.QrySpecialPrice.Key;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid DealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);
                //需要根据update时间来判断是否单据已经被修改了
                if (model.hidCreateType.Equals(PurchaseOrderCreateType.Temporary.ToString()))
                {
                    //获取系统中原有单据的系统更新时间
                    PurchaseOrderHeader header = null;
                    header = _business.GetPurchaseOrderHeaderById(InstanceId);
                    if (header.UpdateDate.ToString().Equals(model.hidUpdateDate))
                    {
                        bool result = _business.CheckSubmit(InstanceId, DealerId, promotionPolicyId, model.hidPriceType, model.hidOrderType, out rtnVal, out rtnMsg);
                    }
                    else
                    {
                        rtnVal = "Error";
                        rtnMsg = "单据已被改变，请重新修改！";
                    }
                }
                else
                {
                    bool result = _business.CheckSubmit(InstanceId, DealerId, promotionPolicyId, model.hidPriceType, model.hidOrderType, out rtnVal, out rtnMsg);
                }


                model.hidRtnVal = rtnVal;
                model.hidRtnMsg = rtnMsg.Replace("$$", "<BR/>");
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public OrderApplyLPInfoVO ValidateBOMQty(OrderApplyLPInfoVO model)
        {
            try
            {
                string masg = "0";
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Hashtable obj = new Hashtable();
                obj.Add("PohId", InstanceId);
                if (_business.CheckBomOrderQty(obj))
                {
                    masg = "1";
                }
                model.BOMQtyMsg = masg;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public OrderApplyLPInfoVO CaculateFormValuePoint(OrderApplyLPInfoVO model)
        {
            try
            {
                model.hidPointCheckErr = "0";
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                //预提积分
                this.CheckPointOrder(model);
                //返回预提结果
                string masg = "";
                DataSet ds = _business.SumPurchaseOrderByHeaderId(InstanceId);

                //预提额度
                //this.CheckRedInvoicesOrder();
                //DataSet dsrev = _business.SumPurchaseOrderByRedInvoicesHeaderId(this.InstanceId.ToString()); 
                if (ds != null && ds.Tables != null && ds.Tables[0].Rows.Count > 0)
                {
                    if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                    {
                        masg = "总金额：" + Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]).ToString("F2") + ", ";
                        masg += "积分抵用：" + Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"]).ToString("F2") + ", ";
                        masg += "还需现金支付：" + (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"])).ToString("F2") + ", ";
                        if (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalAmount"]) - Convert.ToDecimal(ds.Tables[0].Rows[0]["PointAmount"]) > 0)
                        {
                            model.hidPointCheckErr = "1";
                        }
                        model.ExecuteMessage.Add(masg);
                    }
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        private string CheckPointOrder(OrderApplyLPInfoVO model)
        {
            Hashtable obj = new Hashtable();
            obj.Add("POH_ID", model.InstanceId);
            obj.Add("DMA_ID", model.hidDealerId);
            if (!string.IsNullOrEmpty(model.hidProductLine))
            {
                obj.Add("ProductLineId", model.hidProductLine);
            }
            if (!string.IsNullOrEmpty(model.hidPointType))
            {
                obj.Add("PointType", model.hidPointType);
            }
            string retValue = "";
            _business.OrderPointCheck(obj, out retValue);
            return retValue;
        }
        /// <summary>
        /// 订单类型修改后台逻辑
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO ChangeOrderType(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                //更换订单类型，删除订单原产品组下的所有产品
                bool result = _business.DeleteDetail(InstanceId);
                if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    int i = _business.DeleteOrderPointByOrderHeaderId(InstanceId);
                }
                SetSpecialPrice(model);
                //model.IsExistsPaymentTypBYDma = _business.SelectDealerPaymentTypBYDmaId(model.hidDealerId);
                //model.LstWarehouse = new ArrayList(WarehouseByDealer(model.hidDealerId, model.hidWareHouseType).ToList());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 积分修改删除原有订单
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO ChangePointType(OrderApplyLPInfoVO model)
        {
            try
            {
                //更新积分类型，删除订单原产品组下的所有产品
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                //更换产品组，删除订单原使用积分
                if (model.QryOrderType.Key.Equals(PurchaseOrderType.CRPO.ToString()))
                {
                    int i = _business.DeleteOrderPointByOrderHeaderId(InstanceId);
                }
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        #endregion

        #region 私有方法

        private PurchaseOrderHeader GetNewPurchaseOrderHeader(Guid InstanceId)
        {
            PurchaseOrderHeader header = new PurchaseOrderHeader();
            header.Id = InstanceId;
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
        private PurchaseOrderHeader GetFormValue(OrderApplyLPInfoVO model)
        {
            Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
            PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(InstanceId);
            header.ProductLineBumId = string.IsNullOrEmpty(model.hidProductLine) ? null as Guid? : new Guid(model.hidProductLine);
            header.OrderType = string.IsNullOrEmpty(model.hidOrderType) ? "" : model.hidOrderType;

            //汇总信息
            header.Remark = model.QryRemark;
            header.Virtualdc = model.QryVirtualDC;
            //订单信息
            //如果OrderType不是特殊价格订单，则Header表中的SpecialPriceid为空
            var orderType = string.IsNullOrEmpty(model.QryOrderType.ToSafeString()) ? model.QryOrderType.Key : "";
            if (orderType.Equals(PurchaseOrderType.SpecialPrice.ToString()))
            {
                //促销政策改为保存在PointType字段中
                header.SpecialPriceid = null as Guid?;//string.IsNullOrEmpty(this.cbSpecialPrice.SelectedItem.Value) ? null as Guid? : new Guid(this.cbSpecialPrice.SelectedItem.Value);
                header.IsUsePro = string.IsNullOrEmpty(model.hidIsUsePro) ? "0" : model.hidIsUsePro;
            }
            else
            {
                header.SpecialPriceid = null as Guid?;
            }
            header.Vendorid = string.IsNullOrEmpty(model.hidVenderId) ? null : model.hidVenderId;
            header.ContactPerson = model.QryContactPerson;
            header.Contact = model.QryContact;
            header.ContactMobile = model.QryContactMobile;
            //收货信息
            // header.WhmId = string.IsNullOrEmpty(this.cbWarehouse.SelectedItem.Value) ? null as Guid? : new Guid(this.cbWarehouse.SelectedItem.Value);
            header.WhmId = string.IsNullOrEmpty(model.hidWarehouse) ? null as Guid? : new Guid(model.QryWarehouse.Key);
            // header.ShipToAddress = this.cbSAPWarehouseAddress.SelectedItem.Value;
            header.ShipToAddress = model.hidSAPWarehouseAddress;

            header.Consignee = model.QryConsignee;
            header.ConsigneePhone = model.QryConsigneePhone;
            if (!string.IsNullOrEmpty(model.QryRDD))
            {
                try
                {
                    if (Convert.ToDateTime(model.QryRDD) > DateTime.MinValue)
                    {
                        header.Rdd = Convert.ToDateTime(model.QryRDD);
                    }
                }
                catch { }
            }
            else
            {
                header.Rdd = null;
            }
            //承运商信息
            header.TerritoryCode = model.QryCarrier;

            header.PohId = string.IsNullOrEmpty(model.hidPohId) ? null as Guid? : new Guid(model.hidPohId);
            header.CreateType = model.hidCreateType;
            //header.SalesAccount = this.cbSales.SelectedItem.Value;
            header.PointType = model.QryOrderType.Key.ToString().Equals(PurchaseOrderType.CRPO.ToString()) ? model.QryPointType.Key : model.QryOrderType.Key.ToString().Equals(PurchaseOrderType.SpecialPrice.ToString()) ? model.QrySpecialPrice.Key : "";
            if (model.QryDeliver)
            {
                header.DcType = "Deliver";
            }
            else
                header.DcType = "PickUp";
            header.SendAddress = model.QryHospitalAddress;
            header.SendHospital = model.QryTexthospitalname;
            return header;
        }
        #endregion

        #region 弹窗页面添加

        //增加产品
        public OrderApplyLPInfoVO DoAddProductItems(OrderApplyLPInfoVO model)
        {
            try
            {
                int totalCount = 0;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid hidDealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);
                if (model.IscfnDialog)
                {
                    string param = model.PickerParams;
                    string checkparam = model.CheckpickearrParams;
                    (new PurchaseOrderBLL()).AddSpecialCfnPromotion(InstanceId, hidDealerId, param.Substring(0, param.Length - 1), checkparam.Substring(0, checkparam.Length - 1), model.hidSpecialPrice, model.hidOrderType, out rtnVal, out rtnMsg);
                }
                else
                {
                    //特殊价格产品添加
                    string param = model.PickerParams;
                    (new PurchaseOrderBLL()).AddSpecialCfn(InstanceId, hidDealerId, param.Substring(0, param.Length - 1), model.hidSpecialPrice, model.hidOrderType, out rtnVal, out rtnMsg);
                }
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                //查询产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 增加组套产品
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DoAddProductSetItems(OrderApplyLPInfoVO model)
        {
            try
            {
                int totalCount = 0;
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                Guid hidDealerId = string.IsNullOrEmpty(model.hidDealerId) ? Guid.Empty : new Guid(model.hidDealerId);

                string param = model.PickerParams;
                string checkparam = model.CheckpickearrParams;
                (new PurchaseOrderBLL()).AddBSCCfnSet(InstanceId, hidDealerId, param.Substring(0, param.Length - 1), model.hidPriceType, out rtnVal, out rtnMsg);
                if (rtnMsg.Length > 0 || rtnVal != "Success")
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(rtnMsg);
                }
                //查询产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                dsDetail = _business.QueryPurchaseOrderDetailByHeaderId(InstanceId, 0, int.MaxValue, out totalCount);
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        #endregion

        #region 附件处理
        /// <summary>
        /// 附件列表
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO AttachmentStore_Refresh(OrderApplyLPInfoVO model)
        {
            try
            {
                DataTable dt = new DataTable();
                Guid tid = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                int totalCount = 0;
                DataSet ds = _attachBll.GetAttachmentByMainId(tid, AttachmentType.ReturnAdjust, 0, int.MaxValue, out totalCount);
                if (ds != null)
                {
                    dt = ds.Tables[0];
                }
                model.LstAttachmentList = JsonHelper.DataTableToArrayList(dt);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        /// <summary>
        /// 删除附件
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPInfoVO DeleteAttachment(OrderApplyLPInfoVO model)
        {
            try
            {
                Guid id = string.IsNullOrEmpty(model.AttachmentId) ? Guid.Empty : new Guid(model.AttachmentId);
                _attachBll.DelAttachment(id);
                string uploadFile = Server.MapPath("..\\..\\..\\Upload\\UploadFile\\AdjustAttachment");
                File.Delete(uploadFile + "\\" + model.AttachmentName);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add("删除附件失败，请联系DMS技术支持");
            }
            return model;
        }
        #endregion

    }
}
