using DMS.Business;
using DMS.Business.Cache;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryReturnInfoService : ABaseQueryService, IDealerFilterFac
    {
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        // private IDealerMasters _dealers = Global.ApplicationContainer.Resolve<IDealerMasters>();
        IDealerMasters _dealers = new DealerMasters();
        private IInventoryAdjustBLL business = new InventoryAdjustBLL();
        public IAttachmentBLL attachBll = new AttachmentBLL();

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public InventoryReturnInfoVO Init(InventoryReturnInfoVO model)
        {
            try
            {
                model.DdsHidden = false;
                string DealerId = string.Empty;
                InventoryReturnInfoVO header = new InventoryReturnInfoVO();
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                #region 初始化表单
                //初始化detail窗口,因为只有dealer才可以新增，因此打开页面默认选中session中的经销商
                InventoryAdjustHeader mainData = null;
                model.ReturnReasonHidden = true;
                model.UserIdentityType = _context.User.IdentityType;
                model.UserCorpType = RoleModelContext.Current.User.CorpType;
                model.CorpId = RoleModelContext.Current.User.CorpId.ToString();
                //若id为空，说明为新增，则生成新的id，并新增一条记录
                if (_context.User.IdentityType == IdentityType.User.ToString())
                {
                    string hiddenDealerId = "";
                    this.BindDealerWin(model.hiddenReturnType, out hiddenDealerId);
                    model.hiddenDealerId = hiddenDealerId;
                }
                else
                {
                    model.LstBu = new ArrayList(base.GetProductLine().ToList());
                }
                //隐藏RSM下拉框
                if (InstanceId == Guid.Empty)
                {
                    //model.IsNewApply = true;
                    InstanceId = Guid.NewGuid();
                    model.InstanceId = InstanceId.ToString();
                    mainData = new InventoryAdjustHeader();
                    mainData.Id = InstanceId;
                    mainData.CreateDate = DateTime.Now;
                    mainData.CreateUser = new Guid(RoleModelContext.Current.User.Id);
                    if (_context.User.IdentityType == IdentityType.User.ToString())
                    {
                        mainData.DmaId = new Guid(model.hiddenDealerId);
                        //model.hiddenDealerType = model.hiddenDealerType;//不变
                    }
                    else
                    {
                        mainData.DmaId = RoleModelContext.Current.User.CorpId.Value;
                        model.hiddenDealerType = _context.User.CorpType; // Added By Song Yuqi On 20140317
                    }
                    mainData.Status = AdjustStatus.Draft.ToString();

                    //Edited By Song Yuqi On 20140319 Begin
                    //由用户新增的类型（点击普通OR寄售新增按钮）判断是普通退货单还是寄售退货单
                    mainData.WarehouseType = model.hiddenReturnType;//AdjustWarehouseType.Normal.ToString();
                    model.hiddenDealerType = _context.User.CorpType; // Added By Song Yuqi On 20140317
                                                                     //Edited By Song Yuqi On 20140319 End

                    // mainData.Reason = AdjustType.Return.ToString();
                    //lijie edit 2016-06-21 判断是寄售转移还是退货
                    mainData.Reason = model.QryAdjustType;
                    //新增的单据
                    //IsPageNew = true;
                    business.InsertInventoryAdjustHeader(mainData);
                }
                //根据ID查询主表数据，并初始化页面
                mainData = business.GetInventoryAdjustById(InstanceId);
                if(mainData.Status== "EWFApprove" && _context.IsInRole("Administrators"))
                {
                    model.IsShowPushERP = true;
                }
                model.hiddenDealerId = mainData.DmaId.ToString();
                model.InstanceId = mainData.Id.ToString();
                if (_context.User.IdentityType == IdentityType.User.ToString())
                {
                    string hiddenProductLineId = "";
                    model.LstBu = new ArrayList(GetProductLineStoreDataSourceWin(new Guid(model.hiddenDealerId), out hiddenProductLineId).ToList());
                    model.hiddenProductLineId = hiddenProductLineId;
                }
                if (!string.IsNullOrEmpty(mainData.ApplyType))
                {
                    model.hiddApplyType = mainData.ApplyType;
                }
                //Added By Song Yuqi On 20140319 Begin
                //获得明细单中经销商的类型
                DealerMaster dma = new DealerMasters().GetDealerMaster(new Guid(model.hiddenDealerId));
                model.hiddenDealerType = dma.DealerType;
                //Added By Song Yuqi On 20140319 End

                if (!string.IsNullOrEmpty(mainData.Reason))
                {
                    model.hiddenAdjustTypeId = String.IsNullOrEmpty(model.QryAdjustType.ToString()) ? mainData.Reason : model.QryAdjustType.ToString();
                }
                if (mainData.ProductLineBumId != null)
                {
                    model.hiddenProductLineId = mainData.ProductLineBumId.Value.ToString();
                }
                model.QryAdjustNumberWin = mainData.InvAdjNbr;
                if (mainData.CreateDate != null)
                {
                    model.QryAdjustDateWin = mainData.CreateDate.Value.ToString("yyyyMMdd");
                }
                if (!string.IsNullOrEmpty(mainData.Rsm))
                {
                    model.hidSalesAccount = mainData.Rsm;
                }
                else
                {
                    model.hidSalesAccount = "return_user1";
                }
                if (mainData.ProductLineBumId.HasValue)
                {
                    model.hiddenProductLineId = mainData.ProductLineBumId.ToString();
                }
                model.QrytAdjustStatusWin = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_AdjustQty_Status, mainData.Status);
                model.QryAdjustReasonWin = mainData.UserDescription;
                model.QryAduitNoteWin = mainData.AuditorNotes;

                //Added By Song Yuqi On 20140319 Begin
                if (mainData.WarehouseType != null)
                {
                    model.hiddenReturnType = mainData.WarehouseType;
                }
                if (!string.IsNullOrEmpty(mainData.RetrunReason))
                {
                    model.hiddenReason = mainData.RetrunReason;
                }

                //退货要求与原因联动
                #region 退货类型与退货要求的联动
                Hashtable ht = new Hashtable();
                ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                DataSet ds = new DataSet();
                if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString()) && model.hiddenReturnType == AdjustWarehouseType.Borrow.ToString() && model.QryAdjustType == AdjustType.Transfer.ToString())
                {
                    model.ReturnReasonHidden = true;
                    //如果是寄售转移
                    ht.Add("DmaType", "LTC");
                    DataTable dt = new DataTable();
                    ds = business.SelectAdjustRenturn_Reason(ht);
                    List<object> list = new List<object>
                       {
                            new { Value = "转移给其他经销商", Key = "Transfer" }
                       };

                    model.LstAdjustType = new ArrayList(list);
                    if (ds != null)
                        dt = ds.Tables[0];
                    model.LstReturnType = JsonHelper.DataTableToArrayList(dt);
                    model.QryApplyType = new KeyValue(ds.Tables[0].Rows[0]["Key"].ToString(), "");
                    model.QryReturnTypeWin = new KeyValue("Transfer", "");
                    model.hiddApplyType = ds.Tables[0].Rows[0]["Key"].ToString();
                    model.hiddenWhmType = "Consignment";
                }
                else if (model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString())
                {
                    model.ReturnReasonHidden = false;
                    DataTable dt = new DataTable();
                    //投诉退换货生成退货单
                    if (mainData.ApplyType == "ZLReturn")
                    {
                        List<object> list = new List<object>
                            {
                                new {Value = "质量退货", Key = "ZLReturn"}

                            };
                        model.QryApplyType = new KeyValue(mainData.ApplyType, "");
                        model.QryReturnReason = new KeyValue(mainData.RetrunReason, "");
                        model.QryReturnTypeWin = new KeyValue(mainData.Reason, "");
                        model.LstReturnType = new ArrayList(list);
                        model.LstReturnReason = new ArrayList(list);
                        model.LstAdjustType = new ArrayList(list);
                    }
                    else
                    {
                        //如果是T1或品台平台普通退货
                        ht.Add("DmaType", "LT");
                        ds = business.SelectAdjustRenturn_Reason(ht);
                        if (ds != null)
                            dt = ds.Tables[0];
                        model.LstReturnType = JsonHelper.DataTableToArrayList(dt);
                        if (!string.IsNullOrEmpty(mainData.ApplyType))
                        {
                            model.QryApplyType = new KeyValue(mainData.ApplyType, "");
                            ht.Add("Key", mainData.ApplyType);
                            DataSet Dds = business.SelectAdjustRenturn_Reason(ht);
                            if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "1")
                            {

                                if (mainData.RetrunReason == "5")
                                {
                                    //1代表可选退货和换货
                                    List<object> list = new List<object>
                                    {
                                        new {Value = "退款(寄售产品仅退货)", Key = "Return"}

                                    };
                                    model.LstAdjustType = new ArrayList(list);
                                }
                                else
                                {

                                    //1代表可选退货和换货
                                    List<object> list = new List<object>
                                    {
                                        new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                                        new {Value = "换货", Key = "Exchange"}

                                    };
                                    model.LstAdjustType = new ArrayList(list);
                                }

                                model.QryReturnTypeWin = new KeyValue(mainData.Reason, "");
                            }
                            else if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "2")
                            {
                                //2代表只可选退货
                                List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                        };
                                model.LstAdjustType = new ArrayList(list);
                                model.QryReturnTypeWin = new KeyValue(mainData.Reason, "");
                            }

                            if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Consignment")
                            {
                                //如果限制的仓库为寄售
                                model.DdsHidden = true;
                            }
                            model.hiddenWhmType = Dds.Tables[0].Rows[0]["REV3"].ToString();

                        }
                    }
                }
                else if (model.hiddenDealerType == DealerType.T2.ToString())
                {
                    model.ReturnReasonHidden = true;
                    ht.Add("DmaType", "T2");
                    ht.Add("Rev3", model.hiddenReturnType);
                    ds = business.SelectAdjustRenturn_Reason(ht);
                    if (model.hiddenReturnType == AdjustWarehouseType.Consignment.ToString())
                    {
                        List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},

                        };
                        model.LstAdjustType = new ArrayList(list);
                    }
                    else
                    {
                        List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                        model.LstAdjustType = new ArrayList(list);
                    }
                    DataTable dt = new DataTable();
                    if (ds != null)
                        dt = ds.Tables[0];
                    model.LstReturnType = JsonHelper.DataTableToArrayList(dt);

                    model.QryApplyType = new KeyValue(ds.Tables[0].Rows[0]["Key"].ToString(), "");
                    model.QryReturnTypeWin = new KeyValue(mainData.Reason, "");
                    model.hiddApplyType = ds.Tables[0].Rows[0]["Key"].ToString();
                    model.hiddenWhmType = ds.Tables[0].Rows[0]["REV3"].ToString();

                }
                //cbApplyType.SelectedItem.Value = hiddApplyType.Text;


                #endregion
                model.lblInvSum = DisplayRetrunPrcie(mainData.Id.ToString(), model.hiddenWhmType);

                model.LPGoodsReturnApprove = business.QueryLPGoodsReturnApprove(model.InstanceId.ToString()).Tables[0].Rows.Count == 0 ? true : false;
                #endregion
                //表头信息
                model.EntityModel = JsonHelper.Serialize(mainData);
                model.IsDealer = IsDealer;
                //获取经销商
                model.LstDealer = new ArrayList(DealerList().ToList());

                //Rsm
                if (IsDealer || _context.User.IdentityType == IdentityType.User.ToString())
                {
                    if (mainData.Status == AdjustStatus.Draft.ToString())
                    {
                        model.IsNewApply = true;
                    }
                    else
                    {
                        model.IsNewApply = false;
                    }
                }

                //获取Rsm
                bool RsmHidden = false;
                string Bu = model.hiddenProductLineId;
                if (string.IsNullOrEmpty(model.hiddenProductLineId))
                {
                    if (model.LstBu != null)
                    {
                        if (model.LstBu.Count > 0)
                        {
                            Bu = model.hiddenProductLineId = ((KeyValue)(model.LstBu.ToArray()[0])).Key;
                        }
                    }
                }
                //model.LstRsm = JsonHelper.DataTableToArrayList(RsmStore_RefershData(InstanceId.ToString(), Bu, model.IsNewApply, out RsmHidden));
                List<object> listRsm = new List<object>
                        {
                            new {Name = "return_user1", UserCode = "return_user1"},
                            new {Name = "陈静英", UserCode = "chenjingying"}
                        };
                model.LstRsm = new ArrayList(listRsm);
                model.RsmHidden = RsmHidden;
                model.hiddenIsRsm = RsmHidden ? "false" : "true";
                //刷新选择原因
                model.LstReturnReason = JsonHelper.DataTableToArrayList(RetrunReasonStore_RefershData(model.hiddApplyType ?? ""));
                //销售，来源待定
                string DivisionCode = string.Empty;
                string ProductLineId = model.hiddenProductLineId;
                model.LstSalesRepStor = JsonHelper.DataTableToArrayList(DealerConsignmentStoreBindata(ProductLineId, out DivisionCode));

                int totalCount = 0;
                //产品明细
                DetailStore_RefershData(model);
                //附件
                DataTable dtAttachment = new DataTable();
                DataSet dsAttachment = attachBll.GetAttachmentByMainId(InstanceId, AttachmentType.ReturnAdjust, 0, int.MaxValue, out totalCount);
                if (dsAttachment != null)
                {
                    dtAttachment = dsAttachment.Tables[0];
                }
                model.LstAttachmentList = JsonHelper.DataTableToArrayList(dtAttachment);
                //日志
                DataTable dtLog = _logbll.QueryPurchaseOrderLogByHeaderId(InstanceId, 0, int.MaxValue, out totalCount).Tables[0];
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
        /// <summary>
        /// 获取销售人员，来源待定
        /// </summary>
        /// <param name="ProlineId"></param>
        /// <param name="DivisionCode"></param>
        /// <returns></returns>
        public DataTable DealerConsignmentStoreBindata(string ProlineId, out string DivisionCode)
        {
            DivisionCode = "";
            DataSet ds = new ConsignmentApplyHeaderBLL().GetProductLineVsDivisionCode(ProlineId);
            DataSet SalesRepDs;
            string code = string.Empty;
            if (ds.Tables[0].Rows.Count > 0)
            {

                code = ds.Tables[0].Rows[0]["DivisionCode"].ToString();
                DivisionCode = code;
            }

            SalesRepDs = new ConsignmentApplyHeaderBLL().GetDealerSale(code);
            if (SalesRepDs != null)
                return SalesRepDs.Tables[0];
            else
                return new DataTable();
        }
        /// <summary>
        /// 获取产品明细,
        /// </summary>
        /// <param name="model"></param>
        public void DetailStore_RefershData(InventoryReturnInfoVO model)
        {
            int totalCount = 0;
            //产品明细
            DataTable dtProduct = new DataTable();
            DataSet dsDetail = new DataSet();
            Hashtable param = new Hashtable();
            param.Add("AdjustId", model.InstanceId);
            if (model.hiddenReturnType == AdjustWarehouseType.Borrow.ToString())
            {
                dsDetail = business.SelectByFilterInventoryAdjustLotTransfer(param, 0, int.MaxValue, out totalCount);
            }
            else
            {
                dsDetail = business.QueryInventoryAdjustLot(param, 0, int.MaxValue, out totalCount);
            }
            if (dsDetail != null)
                dtProduct = dsDetail.Tables[0];
            model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            model.lblInvSum = DisplayRetrunPrcie(model.InstanceId, model.hiddenWhmType);
        }
        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO RefershHeadData(InventoryReturnInfoVO model)
        {
            try
            {
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                model.InstanceId = InstanceId.ToSafeString();
                DetailStore_RefershData(model);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }
        /// <summary>
        /// 寄售产品明细，被隐藏
        /// </summary>
        /// <param name="model"></param>
        public void ConsignmentDetailStore_RefershData(InventoryReturnInfoVO model)
        {
            int totalCount = 0;
            DataTable dtProduct = new DataTable();
            DataSet dsDetail = new DataSet();
            Hashtable param = new Hashtable();
            Guid tid = new Guid(model.InstanceId);
            param.Add("AdjustId", tid);
            //二级经销商、寄售、退货
            if ((model.hiddenAdjustTypeId == AdjustType.Return.ToString() || model.hiddenAdjustTypeId == AdjustType.Exchange.ToString())
                && model.hiddenDealerType == DealerType.T2.ToString()
                && model.hiddenReturnType == AdjustWarehouseType.Consignment.ToString())
            {
                param.Add("DealerId", model.QryDealerWin.Key);
                param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Consignment.ToString(), WarehouseType.LP_Consignment.ToString()).Split(','));
                DataSet ds = business.QueryInventoryAdjustConsignment(param, 0, int.MaxValue, out totalCount);
            }
            //转移给其他经销商
            else if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString())
                && model.hiddenReturnType == AdjustWarehouseType.Borrow.ToString())
            {
                param.Add("DealerId", model.QryDealerWin.Key);
                param.Add("WarehouseTypes", string.Format("{0},{1}", WarehouseType.Borrow.ToString(), WarehouseType.LP_Borrow.ToString()).Split(','));
                DataSet ds = business.GetInventoryAdjustBorrowById(param, 0, int.MaxValue, out totalCount);
            }
            if (dsDetail != null)
                dtProduct = dsDetail.Tables[0];
            model.RstConsignmentDetail = JsonHelper.DataTableToArrayList(dtProduct);
        }
        //LstRsm
        protected DataTable RsmStore_RefershData(string InstanceId, string hiddenProductLineId, bool IsPageNew, out bool RsmHidden)
        {
            RsmHidden = false;
            DataTable dt = new DataTable();
            //add lijie 20160510
            if (!string.IsNullOrEmpty(InstanceId))
            {
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(InstanceId));
                DealerMaster dmst = _dealers.SelectDealerMasterParentTypebyId(mainData.DmaId);

                if (dmst.DealerType == "T1" || dmst.DealerType == "LP" || dmst.DealerType == "LS")
                {
                    DataSet ds = new DataSet();
                    Hashtable ht = new Hashtable();
                    ht.Add("ProductLineId", hiddenProductLineId);
                    //ht.Add("DealerCode", dmst.SapCode);
                    ht.Add("DealerID", mainData.DmaId);

                    //Added By Song Yuqi On 2017-08-24 For 普通退换货对接EKP Begin
                    if (IsPageNew)
                    {
                        //如果是新添加的订单则在SelectT_I_QV_SalesRepDealer取RSM
                        ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);
                    }
                    else
                    {
                        //如果是历史订单则在interface.T_I_QV_SalesRep 取
                        ds = business.SelectT_I_QV_SalesRepDealerByProductLine(ht);//SelectT_I_QV_SalesRepByProductLine

                    }
                    if (ds != null)
                        dt = ds.Tables[0];
                }
                else
                {
                    RsmHidden = true;
                }
            }
            return dt;
        }
        public string DisplayRetrunPrcie(string IahId, string hiddenWhmType)
        {
            string lblInvSum = string.Empty;
            //获取产品总数量和总价格
            DataSet Pds = business.SelectReturnProductQtyorPrice(IahId);

            if (Pds.Tables[0].Rows.Count > 0)
            {
                decimal SumQty = 0;
                decimal SumPrice = 0;
                decimal SumPriceTax = 0;
                if (Pds.Tables[0].Rows[0]["SumQty"] != DBNull.Value)
                {
                    SumQty = decimal.Parse(Pds.Tables[0].Rows[0]["SumQty"].ToString());
                }
                if (Pds.Tables[0].Rows[0]["SumPrice"] != DBNull.Value)
                {
                    SumPrice = decimal.Parse(Pds.Tables[0].Rows[0]["SumPrice"].ToString());
                }
                if (Pds.Tables[0].Rows[0]["SumQtyTax"] != DBNull.Value)
                {
                    SumPriceTax = decimal.Parse(Pds.Tables[0].Rows[0]["SumQtyTax"].ToString());
                }
                if (hiddenWhmType == "Normal")
                {
                    lblInvSum = "退货总数量:" + SumQty + ";不含税总金额(CNY):" + SumPriceTax + ";含税总金额(CNY):" + SumPrice;
                }
                else
                {
                    lblInvSum = "退货总数量:" + SumQty;
                }
            }
            return lblInvSum;
        }
        /// <summary>
        /// 刷新数据
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO RefershHeadData_old(InventoryReturnInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                //产品明细
                DataTable dtProduct = new DataTable();
                DataSet dsDetail = new DataSet();
                Hashtable param = new Hashtable();
                param.Add("AdjustId", InstanceId);
                if (model.hiddenReturnType == AdjustWarehouseType.Borrow.ToString())
                {
                    dsDetail = business.SelectByFilterInventoryAdjustLotTransfer(param, 0, int.MaxValue, out totalCount);
                }
                else
                {
                    dsDetail = business.QueryInventoryAdjustLot(param, 0, int.MaxValue, out totalCount);
                }
                if (dsDetail != null)
                    dtProduct = dsDetail.Tables[0];
                model.RstProductDetail = JsonHelper.DataTableToArrayList(dtProduct);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);
            }
            return model;
        }
        #region add lijie on 2016-07-19
        public IList<DealerMaster> BindDealerWin(string hiddenReturnType, out string hiddenDealerId)
        {
            hiddenDealerId = "";
            IRoleModelContext context = RoleModelContext.Current;
            IList<DealerMaster> dataSource = DealerCacheHelper.GetDealers();
            //如果是普通用户则检查过滤该用户是否能够看到该Dealer
            if (context.User.IdentityType == IdentityType.User.ToString())
            {
                IList<OrganizationUnit> list = GetCurrentProductLines();
                Guid[] lines = (from p in list select new Guid(p.Id)).ToArray<Guid>();
                IDealerMasters dealerbiz = new DealerMasters();
                IList<Guid> dealers = dealerbiz.GetDealersBySales(context.User.Id, lines);
                var query = from p in dataSource
                            where dealers.Contains(p.Id.Value)
                            select p;
                dataSource = query.OrderBy(d => d.ChineseName).ToList<DealerMaster>();

                //dataSource = query.ToList<DealerMaster>();

                if (hiddenReturnType == "Normal")
                {
                    dataSource = query.Where(d => d.DealerType != DealerType.HQ.ToString()).ToList<DealerMaster>(); ;
                }
                else if (hiddenReturnType == "Consignment")
                {
                    dataSource = query.Where(d => d.DealerType != DealerType.LP.ToString() && d.DealerType != DealerType.LS.ToString() && d.DealerType != DealerType.T1.ToString() && d.DealerType != DealerType.HQ.ToString()).ToList<DealerMaster>(); ;
                }
                else if (hiddenReturnType == "Borrow")
                {
                    dataSource = query.Where(d => d.DealerType != DealerType.T2.ToString() && d.DealerType != DealerType.HQ.ToString()).ToList<DealerMaster>(); ;
                }

                DealerMaster dms = dataSource.OrderBy(p => p.ChineseName).First();
                hiddenDealerId = dms.Id.ToString();

            }
            return dataSource;
        }

        private IList<KeyValue> GetProductLineStoreDataSourceWin(Guid DealreId, out string hiddenProductLineId)
        {
            hiddenProductLineId = "";
            IList<Lafite.RoleModel.Domain.AttributeDomain> datasource = null;

            IDealerContracts dealers = new DealerContracts();

            DealerAuthorization param = new DealerAuthorization();
            param.DmaId = DealreId;
            IList<DealerAuthorization> auths = dealers.GetAuthorizationListByDealer(param);

            IList<Lafite.RoleModel.Domain.AttributeDomain> dataSet = OrganizationHelper.GetAttributeListByType(SR.Organization_ProductLine);

            var lines = from p in dataSet
                        where auths.FirstOrDefault<DealerAuthorization>(c => c.ProductLineBumId.Value == new Guid(p.Id)) != null
                        select p;


            datasource = lines.ToList<Lafite.RoleModel.Domain.AttributeDomain>();
            Lafite.RoleModel.Domain.AttributeDomain Des = lines.First();
            if (Des.Id != null)
            {
                hiddenProductLineId = Des.Id.ToString();
            }

            IList<KeyValue> rtn = new List<KeyValue>();
            bool isFilterBySubCompanyAndBrand = true;
            foreach (AttributeDomain item in datasource)
            {
                rtn.Add(new KeyValue(item.Id, item.AttributeName));
            }

            return isFilterBySubCompanyAndBrand ? BaseService.FilterProductLine(rtn) : rtn;

        }

        /// <summary>
        /// 选择原因绑定
        /// </summary>
        /// <param name="hiddApplyType"></param>
        /// <returns></returns>
        protected DataTable RetrunReasonStore_RefershData(string hiddApplyType)
        {
            DataTable dt = new DataTable();
            Hashtable ht = new Hashtable();
            ht.Add("TypeName", "CONST_AdjustRenturn_Reason");
            ht.Add("Value2", hiddApplyType);
            if (!string.IsNullOrEmpty(hiddApplyType.ToString()))
            {
                DataSet ds = business.SelectAdjustRenturn_Reason(ht);
                if (ds != null)
                    dt = ds.Tables[0];
            }
            return dt;
        }
        #endregion
        /// <summary>
        /// 修改选择原因
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO OnChangcbReturnReason(InventoryReturnInfoVO model)
        {
            try
            {
                model.DdsHidden = false;
                string ReturnReason = string.IsNullOrEmpty(model.QryReturnReason.ToSafeString()) ? "" : model.QryReturnReason.Key;

                if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString()) && model.hiddenReturnType == AdjustWarehouseType.Normal.ToString())
                {
                    //cbReturnTypeWin.SelectedItem.Value = "";//清空退换货要求
                    //cbReturnTypeWin.SelectedItem.Text = "";
                    model.ReturnReasonHidden = false;

                    DataSet ds = new DataSet();
                    //如果是T1或品台平台普通退货
                    Hashtable ht = new Hashtable();
                    ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                    ht.Add("DmaType", "LT");
                    //ds = _business.SelectAdjustRenturn_Reason(ht);
                    //AdjustReturnTypeStore.DataSource = ds;
                    //AdjustReturnTypeStore.DataBind();
                    if (!string.IsNullOrEmpty(model.QryApplyType.ToSafeString()))
                    {

                        ht.Add("Key", model.QryApplyType.Key);
                        DataSet Dds = business.SelectAdjustRenturn_Reason(ht);
                        if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "1")
                        {
                            //1代表可选退货和换货

                            if (ReturnReason == "5")
                            {
                                List<object> list = new List<object>
                          {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"}

                          };
                                model.LstAdjustType = new ArrayList(list);
                            }
                            else
                            {
                                List<object> list = new List<object>
                          {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                          };
                                model.LstAdjustType = new ArrayList(list);
                            }



                        }
                        else if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "2")
                        {
                            //2代表只可选退货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                        };
                            model.LstAdjustType = new ArrayList(list);

                        }

                        if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Consignment")
                        {
                            //如果限制的仓库为寄售
                            model.DdsHidden = true;
                        }
                        model.hiddenWhmType = Dds.Tables[0].Rows[0]["REV3"].ToString();
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
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO OnProductLineChange(InventoryReturnInfoVO model)
        {
            try
            {
                //Edited By Song Yuqi On 20140320 Begin
                //二级经销商、退货、寄售
                if (model.hiddenDealerType == DealerType.T2.ToString()
                    && (model.QryAdjustType == AdjustType.Return.ToString() || model.QryAdjustType == AdjustType.Exchange.ToString())
                    && model.hiddenReturnType == AdjustWarehouseType.Consignment.ToString())
                {
                    business.DeleteConsignmentItemByHeaderId(new Guid(model.InstanceId));
                }
                //一级经销商及物流平台短期寄售产品退货
                else if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString())
                && model.QryAdjustType == AdjustType.Transfer.ToString()
                && model.hiddenReturnType == AdjustWarehouseType.Consignment.ToString())
                {
                    business.DeleteConsignmentItemByHeaderId(new Guid(model.InstanceId));
                }
                else
                {
                    business.DeleteDetail(new Guid(model.InstanceId));
                }
                //Edited By Song Yuqi On 20140320 End
                // RsmStore.DataBind();

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
        /// 刷新RSM
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO RefreshRsm(InventoryReturnInfoVO model)
        {
            try
            {
                bool RsmHidden = true;
                model.RsmHidden = RsmHidden;
                model.LstRsm = JsonHelper.DataTableToArrayList(RsmStore_RefershData(model.InstanceId, model.hiddenProductLineId, model.IsNewApply, out RsmHidden));
                model.RsmHidden = RsmHidden;
                model.hiddenIsRsm = RsmHidden ? "false" : "true";
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
        /// 退货类型修改
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO OnCbApplyChange(InventoryReturnInfoVO model)
        {
            try
            {
                model.DdsHidden = false;
                Hashtable ht = new Hashtable();
                ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                DataSet ds = new DataSet();
                //hiddApplyType.Text = cbApplyType.SelectedItem.Value;//TODO
                //cbReturnTypeWin.SelectedItem.Value = "";
                //cbReturnTypeWin.SelectedItem.Text = "";
                if (model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString())
                {

                    if (!string.IsNullOrEmpty(model.QryApplyType.ToSafeString()))
                    {

                        ht.Add("Key", model.QryApplyType.Key);
                        DataSet Dds = business.SelectAdjustRenturn_Reason(ht);
                        if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "1")
                        {
                            //1代表可选退货和换货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                            model.LstAdjustType = new ArrayList(list);
                        }
                        else if (Dds.Tables[0].Rows[0]["VALUE2"].ToString() == "2")
                        {
                            //2代表只可选退货
                            List<object> list = new List<object>
                        {
                            new {Value = "退款(寄售产品仅退货)", Key = "Return"},
                        };
                            model.LstAdjustType = new ArrayList(list);

                        }
                        if (Dds.Tables[0].Rows[0]["REV3"].ToString() == "Consignment")
                        {
                            //如果限制仓库类型为寄售，隐藏价格，显示关联订单
                            //GridPanel2.ColumnModel.SetHidden(12, false);
                            //GridPanel2.ColumnModel.SetHidden(15, true);
                            model.DdsHidden = true;
                        }
                        else
                        {
                            //移除关联订单，显示价格
                            //GridPanel2.ColumnModel.SetHidden(12, true);
                            //GridPanel2.ColumnModel.SetHidden(15, false);
                            model.DdsHidden = false;
                        }
                        model.hiddenWhmType = Dds.Tables[0].Rows[0]["REV3"].ToString();
                    }
                }
                //business.DeleteDetail(new Guid(this.hiddenAdjustId.Text));

                //刷新选择原因
                model.LstReturnReason = JsonHelper.DataTableToArrayList(RetrunReasonStore_RefershData(model.hiddApplyType));
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
        ///  退/换货要求改变触发
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO OnAdjustTypeChange(InventoryReturnInfoVO model)
        {
            try
            {
                business.DeleteDetail(new Guid(model.InstanceId));
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        #region 按钮事件
        /// <summary>
        /// 变更经销商删除原有产品
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO CbDealerWinChanaeg(InventoryReturnInfoVO model)
        {
            try
            {
                if (model.hiddenDealerType == DealerType.T2.ToString()
                           && (model.QryAdjustType == AdjustType.Return.ToString() || model.QryAdjustType == AdjustType.Exchange.ToString())
                           && model.hiddenReturnType == AdjustWarehouseType.Consignment.ToString())
                {
                    business.DeleteConsignmentItemByHeaderId(new Guid(model.InstanceId));
                }
                //一级经销商及物流平台短期寄售产品退货
                else if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString())
                       && model.QryAdjustType == AdjustType.Transfer.ToString()
                       && model.hiddenReturnType == AdjustWarehouseType.Consignment.ToString())
                {
                    business.DeleteConsignmentItemByHeaderId(new Guid(model.InstanceId));
                }
                else
                {
                    business.DeleteDetail(new Guid(model.InstanceId));
                }
                string hiddenProductLineId = "";
                model.hiddenDealerId = string.IsNullOrEmpty(model.QryDealerWin.ToSafeString()) ? "" : model.QryDealerWin.Key;
                model.LstBu = new ArrayList(GetProductLineStoreDataSourceWin(new Guid(model.hiddenDealerId), out hiddenProductLineId).ToList());
                model.hiddenProductLineId = hiddenProductLineId;
                //ReturnReasonApply();
                #region 退货类型与退货要求的联动
                Hashtable ht = new Hashtable();
                ht.Add("TypeName", "CONST_AdjustRenturn_Type");
                DataSet ds = new DataSet();
                if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString()) && model.hiddenReturnType == AdjustWarehouseType.Borrow.ToString() && model.QryAdjustType == AdjustType.Transfer.ToString())
                {
                    DataTable dt = new DataTable();
                    //如果是寄售转移
                    ht.Add("DmaType", "LTC");
                    ds = business.SelectAdjustRenturn_Reason(ht);
                    List<object> list = new List<object>
                       {
                            new { Value = "转移给其他经销商", Key = "Transfer" }
                       };
                    model.LstAdjustType = new ArrayList(list);//要求
                    if (ds != null)
                        dt = ds.Tables[0];
                    model.LstReturnType = JsonHelper.DataTableToArrayList(dt);//退货类型
                    model.QryApplyType = new KeyValue(ds.Tables[0].Rows[0]["Key"].ToString(), "");
                    model.QryReturnTypeWin = new KeyValue("Transfer", "");
                    model.hiddApplyType = ds.Tables[0].Rows[0]["Key"].ToString();
                    model.hiddenWhmType = "Consignment";
                }
                else if (model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString())
                {
                    DataTable dt = new DataTable();
                    //如果是T1或品台平台普通退货
                    ht.Add("DmaType", "LT");
                    ds = business.SelectAdjustRenturn_Reason(ht);
                    if (ds != null)
                        dt = ds.Tables[0];
                    model.LstReturnType = JsonHelper.DataTableToArrayList(dt);//退货类型
                    model.LstAdjustType = null;//要求
                }
                else if (model.hiddenDealerType == DealerType.T2.ToString())
                {
                    ht.Add("DmaType", "T2");
                    ht.Add("Rev3", model.hiddenReturnType);
                    ds = business.SelectAdjustRenturn_Reason(ht);
                    List<object> list = new List<object>
                        {
                            new {Value = "退货", Key = "Return"},
                            new {Value = "换货", Key = "Exchange"}

                        };
                    DataTable dt = new DataTable();
                    if (ds != null)
                        dt = ds.Tables[0];
                    model.LstReturnType = JsonHelper.DataTableToArrayList(dt);
                    model.LstAdjustType = new ArrayList(list);//要求
                    model.QryApplyType = new KeyValue(ds.Tables[0].Rows[0]["Key"].ToString(), "");
                    model.hiddApplyType = ds.Tables[0].Rows[0]["Key"].ToString();
                    model.hiddenWhmType = ds.Tables[0].Rows[0]["REV3"].ToString();
                }

                #endregion

                if ((model.hiddenDealerType == DealerType.T1.ToString() || model.hiddenDealerType == DealerType.LP.ToString() || model.hiddenDealerType == DealerType.LS.ToString()))
                {
                    model.ReturnReasonHidden = false;
                }
                else
                {
                    model.ReturnReasonHidden = true;
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
        /// 单行删除产品明细
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO DeleteItem(InventoryReturnInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteItem(new Guid(model.LotId));

                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("删除出错");
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
        /// 
        /// </summary>
        /// <param name="hiddenCurrentEdit"></param>
        /// <param name="InstanceId"></param>
        /// <param name="hiddenReturnType"></param>
        /// <param name="cbReturnType">退换货要求</param>
        /// <param name="lotNumber"></param>
        /// <param name="expiredDate"></param>
        /// <param name="adjustQty"></param>
        /// <param name="PurchaseOrderId"></param>
        /// <param name="QRCode"></param>
        /// <param name="QRCodeEdit"></param>
        /// <param name="ToDealer"></param>
        /// <param name="Upn"></param>
        public InventoryReturnInfoVO SaveItem(InventoryReturnInfoVO model)
        {
            try
            {
                if (model.hiddenReturnType == AdjustWarehouseType.Borrow.ToString())
                {
                    //如果是寄售转销售
                    InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(model.LotId));
                    lot.LotQty = Convert.ToDouble(model.AdjustQty);

                    if (IsGuid(model.PurchaseOrderId))
                    {
                        Hashtable param = new Hashtable();

                        param.Add("PrhId", model.PurchaseOrderId);
                        param.Add("Upn", model.UPN);
                        DataSet ds = new DataSet();
                        if (model.QryReturnTypeWin.Key == AdjustType.Transfer.ToString())
                        {
                            //转移给其他经销商,选择短期寄售申请单号
                            ds = business.ExistsConsignmentIsUpn(param);
                        }
                        else
                        {
                            ds = business.ExistsPOReceiptHeaderIsUpn(param);
                        }
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            lot.PrhId = new Guid(model.PurchaseOrderId);
                        }
                    }
                    if (IsGuid(model.ToDealer))
                    {
                        lot.DmaId = new Guid(model.ToDealer);

                    }

                    bool result = business.SaveItem(lot);

                    if (result)
                    {
                        //  this.DetailStore.DataBind();
                    }
                    else
                    {
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("保存出错");
                    }
                }
                else
                {
                    //判断NoQR时退货数量
                    if (model.QRCode != "NoQR" && !string.IsNullOrEmpty(model.QRCode))
                    {
                        if (Convert.ToDouble(model.AdjustQty) > 1)
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("二维码不为空时，退货数量不能大于1");
                            return model;
                        }
                    }
                    if (string.IsNullOrEmpty(model.EditQrCode))
                    {
                        InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(model.LotId));
                        lot.LotQty = Convert.ToDouble(model.AdjustQty);
                        if (IsGuid(model.PurchaseOrderId))
                        {
                            lot.PrhId = new Guid(model.PurchaseOrderId);
                        }
                        bool result = business.SaveItem(lot);

                        if (result)
                        {
                            //  this.DetailStore.DataBind();
                        }
                        else
                        {
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("保存出错");
                        }
                    }
                    else if (model.QRCode == "NoQR" && !string.IsNullOrEmpty(model.EditQrCode))
                    {
                        //校验二维码库中是否存在这个二维码
                        if (business.QueryQrCodeIsExist(model.EditQrCode))
                        {
                            //校验二维码库中是否填写重复
                            if (business.QueryQrCodeIsDouble(new Guid(model.InstanceId), model.EditQrCode, new Guid(model.LotId)))
                            {
                                //this.DetailStore.DataBind();
                                model.IsSuccess = false;
                                model.ExecuteMessage.Add("此二维码已填写过");
                            }
                            else
                            {
                                InventoryAdjustLot lot = business.GetInventoryAdjustLotById(new Guid(model.LotId));

                                lot.QrLotNumber = model.LotNumber + "@@" + model.EditQrCode;
                                lot.LotQty = Convert.ToDouble(model.AdjustQty);
                                if (IsGuid(model.PurchaseOrderId))
                                {
                                    lot.PrhId = new Guid(model.PurchaseOrderId);
                                }

                                bool result = business.SaveItem(lot);

                                if (result)
                                {
                                    // this.DetailStore.DataBind();
                                }
                                else
                                {
                                    model.IsSuccess = false;
                                    model.ExecuteMessage.Add("此二维码已填写过");
                                }
                            }
                        }
                        else
                        {
                            // this.DetailStore.DataBind();
                            model.IsSuccess = false;
                            model.ExecuteMessage.Add("不存在此二维码");
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

        /// <summary>
        /// 关联订单绑定
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO PurchaseOrderStore_RefershData(InventoryReturnInfoVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                param.Add("DealerId", model.hiddenDealerId);
                param.Add("ProductLineId", model.QryProductLineWin.Key);
                param.Add("PmaId", model.PmaId);

                DataSet ds = new DataSet();
                if (model.QryReturnTypeWin.Key == AdjustType.Transfer.ToString())
                {
                    param.Add("LotNumber", model.LotNumber + "@@" + model.QRCode);
                    //转移给其他经销商,选择短期寄售申请单号
                    ds = business.GetConsignmentOrderNbr(param);
                }
                else
                {
                    param.Add("LotNumber", model.LotNumber + "@@" + model.QRCode);
                    ds = business.GetPurchaseOrderNbr(param);
                }
                DataTable dt = new DataTable();
                if (ds != null)
                    dt = ds.Tables[0];
                model.LstPurchase = JsonHelper.DataTableToArrayList(dt);
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
        /// 转移经销商下拉绑定
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO ToDealerStore_RefershData(InventoryReturnInfoVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                param.Add("ProductLineId", model.QryProductLineWin.Key);
                param.Add("DmaId", model.hiddenDealerId);

                DataSet ds = business.GetReturnDealerListByFilter(param);
                DataTable dt = new DataTable();
                if (ds != null)
                    dt = ds.Tables[0];
                model.LstToDealer = JsonHelper.DataTableToArrayList(dt);
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
        public InventoryReturnInfoVO SaveDraft(InventoryReturnInfoVO model)
        {
            try
            {
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(model.InstanceId));
                if (!string.IsNullOrEmpty(model.QryProductLineWin.ToSafeString()))
                {
                    mainData.ProductLineBumId = new Guid(model.QryProductLineWin.Key);
                }
                if (!string.IsNullOrEmpty(model.QryAdjustReasonWin))
                {
                    mainData.UserDescription = model.QryAdjustReasonWin;
                }
                if (!string.IsNullOrEmpty(model.QryReturnTypeWin.ToSafeString()))
                {
                    mainData.Reason = model.QryReturnTypeWin.Key;
                }

                if (!string.IsNullOrEmpty(model.QryRsm.ToSafeString()))
                {
                    mainData.Rsm = model.QryRsm.Key;
                }
                if (!string.IsNullOrEmpty(model.QryApplyType.ToSafeString()))
                {
                    mainData.ApplyType = model.QryApplyType.Key;
                }
                if (!string.IsNullOrEmpty(model.hiddenDealerId))
                {
                    mainData.DmaId = new Guid(model.hiddenDealerId);
                }
                if (!string.IsNullOrEmpty(model.QryReturnReason.ToSafeString()))
                {
                    mainData.RetrunReason = model.QryReturnReason.Key;
                }
                bool result = false;
                result = business.SaveDraft(mainData);

                if (result)
                {
                    model.ExecuteMessage.Add("保存草稿成功");
                }
                else
                {
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
        /// 删除草稿
        /// </summary>
        public InventoryReturnInfoVO DeleteDraft(InventoryReturnInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.DeleteDraft(new Guid(model.InstanceId));

                if (result)
                {
                    model.IsSuccess = true;
                    model.ExecuteMessage.Add("删除草稿成功");
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
        public InventoryReturnInfoVO DoRevoke(InventoryReturnInfoVO model)
        {
            try
            {
                bool result = false;
                result = business.Revoke(new Guid(model.InstanceId));
                if (result)
                {
                    model.ExecuteMessage.Add("撤销成功");
                }
                else
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("提交失败(可能为库存数量不足等情况，请联系管理员)");
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
        public InventoryReturnInfoVO Submit(InventoryReturnInfoVO model)
        {
            try
            {
                string hiddenresult = "true";
                InventoryAdjustHeader mainData = business.GetInventoryAdjustById(new Guid(model.InstanceId));
                string Messinge = string.Empty;
                if (!string.IsNullOrEmpty(model.QryProductLineWin.ToSafeString()))
                {
                    mainData.ProductLineBumId = new Guid(model.QryProductLineWin.Key);
                }
                if (!string.IsNullOrEmpty(model.QryAdjustReasonWin))
                {
                    mainData.UserDescription = model.QryAdjustReasonWin;
                }
                if (!string.IsNullOrEmpty(model.QryReturnTypeWin.ToSafeString()))
                {
                    mainData.Reason = model.QryReturnTypeWin.Key;
                }
                if (!string.IsNullOrEmpty(model.QryRsm.ToSafeString()))
                {
                    mainData.Rsm = model.QryRsm.Key;
                }
                if (!string.IsNullOrEmpty(model.QryReturnReason.ToSafeString()))
                {
                    mainData.RetrunReason = model.QryReturnReason.Key;
                }
                if (!string.IsNullOrEmpty(model.QryApplyType.ToSafeString()))
                {
                    mainData.ApplyType = model.QryApplyType.Key;
                }
                bool result = false;

                //Added By Song Yuqi On 2016-06-06 Begin
                //校验经销商退换货的UPN是否满足经销商授权
                if (mainData.Reason == AdjustType.Return.ToString()
                    || mainData.Reason == AdjustType.Exchange.ToString())
                {
                    Messinge = business.CheckProductAuth(new Guid(model.InstanceId), _context.User.CorpId.Value, mainData.ProductLineBumId.Value);

                    if (!string.IsNullOrEmpty(Messinge))
                    {
                        Messinge = Messinge.Replace("@@", "<br/>");
                        hiddenresult = "false";
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add(Messinge);
                        return model;
                    }
                }

                //Added By Song Yuqi On 2016-06-06 End
                if (mainData.Reason == AdjustType.Return.ToString())
                {

                    DataSet ds = business.SelectInventoryAdjustLotQrCodeBYDmIdHeadId(model.InstanceId, _context.User.CorpId.Value.ToString());
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        Messinge = ds.Tables[0].Rows[0][0].ToString();
                        hiddenresult = "false";
                    }
                    if (hiddenresult == "false")
                    {
                        Messinge = Messinge.Replace(",", "<br/>");
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add(Messinge);
                        return model;
                    }
                }
                DealerMaster dma = _dealers.GetDealerMaster(mainData.DmaId);
                if (dma.Taxpayer == "直销医院")
                {
                    //如果经销商为直销医院不能包含多个仓库的记录
                    DataSet Whmtb = business.GetInventoryDtBYIahId(mainData.Id.ToString());
                    if (Whmtb.Tables[0].Rows.Count > 1)
                    {
                        hiddenresult = "false";
                        model.IsSuccess = false;
                        model.ExecuteMessage.Add("直销医院的退货单不能包含多个仓库的记录");
                        return model;
                    }
                }
                //平台及一级判断是否取到价格及行号
                if(dma.DealerType == DealerType.LP.ToString()|| dma.DealerType == DealerType.T1.ToString()|| dma.DealerType == DealerType.LS.ToString())
                {
                    InventoryAdjustLotDao detailDao = new InventoryAdjustLotDao();
                    IList<InventoryAdjustLot> orderDetailList = detailDao.SelectInventoryAdjustLotByAdjustId(new Guid(model.InstanceId));
                    bool isSuccess = true;
                    string strMsg = "";
                    foreach(var invertory in orderDetailList)
                    {
                        if (invertory.UnitPrice == null)
                        {
                            isSuccess = false;
                            strMsg += "产品"+ invertory.LotQRCode + "(二维码)退货价格未获取到;";
                        }
                        //if(string.IsNullOrEmpty(invertory.ERPNbr))
                        //{
                        //    isSuccess = false;
                        //    strMsg += "产品" + invertory.LotQRCode + "(二维码)ERP主单行号未获取到;";
                        //}
                        //if (string.IsNullOrEmpty(invertory.ERPLineNbr))
                        //{
                        //    isSuccess = false;
                        //    strMsg += "产品" + invertory.LotQRCode + "(二维码)ERP明细行行号未获取到;";
                        //}
                        if (string.IsNullOrEmpty(invertory.DOM))
                        {
                            isSuccess = false;
                            strMsg += "产品" + invertory.LotQRCode + "(二维码)生产日期为空;";
                        }
                        if (invertory.ExpiredDate == null)
                        {
                            isSuccess = false;
                            strMsg += "产品" + invertory.LotQRCode + "(二维码)有效期为空;";
                        }
                    }
                    if (!isSuccess)
                    {
                        model.IsSuccess = isSuccess;
                        model.ExecuteMessage.Add(strMsg);
                        return model;
                    }
                }
                
                if (string.IsNullOrEmpty(Messinge))
                {
                    result = business.Submit(mainData);
                }

                if (result)
                {
                    if (this._context.User.CorpType == DealerType.T1.ToString() || this._context.User.CorpType == DealerType.LP.ToString() || this._context.User.CorpType == DealerType.LS.ToString())
                    {
                        model.ExecuteMessage.Add("您已成功提交退换货申请，请将此退换货申请单编号提供给波科对应的销售助理，由销售助理在波科Workflow中进行审批流程，谢谢！");
                        return model;
                    }
                    else
                    {
                        model.ExecuteMessage.Add("提交成功");
                        return model;
                    }
                }
                else
                {
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
        #endregion


        #region 弹窗页面添加

        //增加产品
        public InventoryReturnInfoVO DoAddProductItems(InventoryReturnInfoVO model)
        {
            try
            {
                int totalCount = 0;
                Guid InstanceId = string.IsNullOrEmpty(model.InstanceId) ? Guid.NewGuid() : new Guid(model.InstanceId);
                string param = model.DealerParams;
                System.Diagnostics.Debug.WriteLine("AddItems : Param = " + param);
                param = param.Substring(0, param.Length - 1);
                IInventoryAdjustBLL business = new InventoryAdjustBLL();
                //Edited By Song Yuqi On 20140319 Begin
                bool result = false;
                if ((model.hiddenDialogAdjustType == AdjustType.Return.ToString() || model.hiddenDialogAdjustType == AdjustType.Exchange.ToString())
                       && _context.User.CorpType == DealerType.T2.ToString()
                       && model.hiddenWarehouseType == AdjustWarehouseType.Consignment.ToString())
                {
                    result = business.AddItems(model.hiddenDialogAdjustType, new Guid(model.InstanceId), new Guid(model.hiddenDialogDealerId), model.cbWarehouse1, param.Split(','), model.hiddenReturnApplyType);
                }
                else if (model.hiddenDialogAdjustType == AdjustType.Transfer.ToString() && model.hiddenWarehouseType == AdjustWarehouseType.Borrow.ToString())
                {
                    result = business.AddConsignmentItemsInv(new Guid(model.InstanceId), new Guid(model.hiddenDialogDealerId), param.Split(','));
                }
                else
                {
                    result = business.AddItems(model.hiddenDialogAdjustType, new Guid(model.InstanceId), new Guid(model.hiddenDialogDealerId), model.cbWarehouse2, param.Split(','), model.hiddenReturnApplyType);
                }
                //Edited By Song Yuqi On 20140319 End

                if (result)
                {
                    if ((model.hiddenDialogAdjustType == AdjustType.Return.ToString() || model.hiddenDialogAdjustType == AdjustType.Exchange.ToString())
                        && _context.User.CorpType == DealerType.T2.ToString()
                        && model.hiddenWarehouseType == AdjustWarehouseType.Consignment.ToString())
                    {
                        // this.GridStore.DataBind();
                    }
                    else if (model.hiddenDialogAdjustType == AdjustType.Transfer.ToString() && model.hiddenWarehouseType == AdjustWarehouseType.Borrow.ToString())
                    {
                        // this.GridStore.DataBind();
                    }
                    else
                    {
                        //  this.GridStore.DataBind();
                    }


                }
                else
                {
                    //Ext.Msg.Alert(GetLocalResourceObject("DoYes.Alert.false.title").ToString(), GetLocalResourceObject("DoYes.Alert.false.body").ToString()).Show();
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add("添加产品失败");
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

        #region 附件处理
        /// <summary>
        /// 附件列表
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO AttachmentStore_Refresh(InventoryReturnInfoVO model)
        {
            try
            {
                DataTable dt = new DataTable();
                Guid tid = string.IsNullOrEmpty(model.InstanceId) ? Guid.Empty : new Guid(model.InstanceId);
                int totalCount = 0;
                DataSet ds = attachBll.GetAttachmentByMainId(tid, AttachmentType.ReturnAdjust, 0, int.MaxValue, out totalCount);
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
        public InventoryReturnInfoVO DeleteAttachment(InventoryReturnInfoVO model)
        {
            try
            {
                Guid id = string.IsNullOrEmpty(model.AttachmentId) ? Guid.Empty : new Guid(model.AttachmentId);
                attachBll.DelAttachment(id);
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

        /// <summary>
        /// 推送ERP
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public InventoryReturnInfoVO PushToERP(InventoryReturnInfoVO model)
        {
            try
            {
                string msg = "";
                bool result = false;
                result = business.PushReturnToERP(new Guid(model.InstanceId),out msg);
                if (result)
                {
                    business.ReturnAutoCreateOrder(model.InstanceId, out msg);
                }
                if (!result)
                {
                    model.IsSuccess = false;
                    model.ExecuteMessage.Add(msg);
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

    }
}
