using DMS.Business;
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
using System.Linq;
using System.Text;
using System.Collections.Specialized;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Business.Excel;

namespace DMS.BusinessService.Order
{
    public class OrderApplyLPService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        private IPurchaseOrderBLL business = new PurchaseOrderBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public OrderApplyLPVO Init(OrderApplyLPVO model)
        {
            try
            {
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();
                model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Consts_Order_Status).ToArray());
                model.LstType = OrderTypeForLP(SR.Consts_Order_Type);
                model.LstShipToAddress = new ArrayList(Bind_SAPWarehouseAddress(_context.User.CorpId.HasValue ?_context.User.CorpId.Value : Guid.Empty).ToList());
                model.hidCorpType = "";
                //借入经销商
                if (IsDealer)
                {
                    model.hidCorpType = RoleModelContext.Current.User.CorpType;
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.cbDealerDisabled = true;
                        model.hidInitDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();

                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                        model.DealerListType = "2";
                    }
                }
                else
                {
                    model.LstDealer = new ArrayList(DealerList().ToList());
                }
                //控制查询按钮
                Permissions pers = RoleModelContext.Current.User.GetPermissions();
                model.SerchVisibile = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApplyLP, PermissionType.Read);

                //如果使用此菜单功能的人员不是物流平台或一级经销商，则不可以使用新增和导入功能
                model.InsertDisabled = false;
                model.btnImportDisabled = false;
                model.btnStockpriceDisabled = false;
                if (!IsDealer)
                {
                    model.InsertDisabled = true;
                    model.btnImportDisabled = true;

                }
                else if (!RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) && !RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) && !RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                {
                    model.InsertDisabled = true;
                    model.btnImportDisabled = true;
                    model.btnStockpriceDisabled = true;

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
        protected ArrayList OrderTypeForLP(string type)
        {
            //物流平台、一级经销商可以查看普通订单、特殊价格订单、寄售订单、寄售销售订单、交接订单、清指定批号订单、成套设备订单、虚拟寄售单，虚拟清货单
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            var result = (from t in dicts
                          where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                 //t.Key == PurchaseOrderType.PEGoodsReturn.ToString() ||
                                 //t.Key == PurchaseOrderType.EEGoodsReturn.ToString() ||
                                 t.Key == PurchaseOrderType.SpecialPrice.ToString() ||
                                 t.Key == PurchaseOrderType.Consignment.ToString() ||
                                 t.Key == PurchaseOrderType.ConsignmentSales.ToString() ||
                                 t.Key == PurchaseOrderType.Transfer.ToString() ||
                                 t.Key == PurchaseOrderType.ClearBorrow.ToString() ||
                                 t.Key == PurchaseOrderType.ClearBorrowManual.ToString() ||
                                 t.Key == PurchaseOrderType.BOM.ToString() ||
                                 t.Key == PurchaseOrderType.PRO.ToString() ||
                                 t.Key == PurchaseOrderType.CRPO.ToString() ||
                                 t.Key == PurchaseOrderType.SampleApply.ToString() ||
                                 t.Key == PurchaseOrderType.ZTKB.ToString() ||
                                 t.Key == PurchaseOrderType.ZTKA.ToString() ||
                                 t.Key == PurchaseOrderType.ConsignmentReturn.ToString() ||
                                 t.Key == PurchaseOrderType.Return.ToString()||
                                 t.Key == PurchaseOrderType.ZRB.ToString())
                          select t);
            return new ArrayList(result.ToList());
        }
        public string Query(OrderApplyLPVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLineBumId", model.QryBu.Key);

                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                    {
                        param.Add("DmaId", model.QryDealer.Key);
                    }
                if (!string.IsNullOrEmpty(model.QryOrderType.ToSafeString()))
                    if (model.QryOrderType.Value != "全部" && model.QryOrderType.Key != "")
                    {
                        param.Add("OrderType", model.QryOrderType.Key);
                    }
                if (!string.IsNullOrEmpty(model.QryOrderStatus.ToSafeString()))
                    if (model.QryOrderStatus.Value != "全部" && model.QryOrderStatus.Key != "")
                    {
                        param.Add("OrderStatus", model.QryOrderStatus.Key);
                    }

                if (!string.IsNullOrEmpty(model.QryApplyDate.StartDate.ToSafeString()))
                {
                    param.Add("SubmitDateStart", Convert.ToDateTime(model.QryApplyDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryApplyDate.EndDate.ToSafeString()))
                {
                    param.Add("SubmitDateEnd", Convert.ToDateTime(model.QryApplyDate.EndDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryOrderNo.ToSafeString()))
                {
                    param.Add("OrderNo", model.QryOrderNo);
                }
                if (!string.IsNullOrEmpty(model.QryCFN.ToSafeString()))
                {
                    param.Add("Cfn", model.QryCFN);
                }
                if (!string.IsNullOrEmpty(model.QryRemark.ToSafeString()))
                {
                    param.Add("Remark", model.QryRemark);
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

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryPurchaseOrderHeaderForLPDealer(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();
            string ExportType = string.Empty;
            if (!string.IsNullOrEmpty(Parameters["ProductLineBumId"].ToSafeString()))
            {
                param.Add("ProductLineBumId", Parameters["ProductLineBumId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DmaId"].ToSafeString()))
            {
                param.Add("DmaId", Parameters["DmaId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["OrderStatus"].ToSafeString()))
            {
                param.Add("OrderStatus", Parameters["OrderStatus"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["OrderType"].ToSafeString()))
            {
                param.Add("OrderType", Parameters["OrderType"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["SubmitDateStart"].ToSafeString()))
            {
                param.Add("SubmitDateStart", Convert.ToDateTime(Parameters["SubmitDateStart"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["SubmitDateEnd"].ToSafeString()))
            {
                param.Add("SubmitDateEnd", Convert.ToDateTime(Parameters["SubmitDateEnd"].ToSafeString()).ToString("yyyyMMdd"));
            }
            if (!string.IsNullOrEmpty(Parameters["OrderNo"].ToSafeString()))
            {
                param.Add("OrderNo", Parameters["OrderNo"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Cfn"].ToSafeString()))
            {
                param.Add("Cfn", Parameters["Cfn"].ToSafeString());
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
            //tips:发票、操作日志导出原方法sql被编辑为html,目前去除
            DataSet ds = null;
            if (Parameters["DownloadCookie"].ToSafeString() == "OperationLogExport")//导出日志
            {
                ExportType = "OrderApplyLP_OperationLog";
                ds = business.ExportPurchaseOrderLogForLPDealer(param);
            }
            if (Parameters["DownloadCookie"].ToSafeString() == "InvoiceInfoExport")//导出发票
            {
                ExportType = "OrderApplyLP_InvoiceInfo";
                ds = business.ExportPurchaseOrderInvoiceForLPDealer(param);
            }
            if (Parameters["DownloadCookie"].ToSafeString() == "OrderDetailExport")//导出明细
            {
                ExportType = "OrderApplyLP_OrderDetail";
                if (!string.IsNullOrEmpty(Parameters["Remark"].ToSafeString()))
                {
                    param.Add("Remark", Parameters["Remark"].ToSafeString());
                }
                ds = business.ExportPurchaseOrderDetailForLPDealer(param);
            }
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport(ExportType);
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        /// <summary>
        /// 修改操作
        /// </summary>
        /// <param name="id"></param>
        /// <param name="model"></param>
        /// <returns></returns>
        public OrderApplyLPVO CopyForTemporary(OrderApplyLPVO model)
        {
            try
            {
                string rtnVal = string.Empty;
                string rtnMsg = string.Empty;
                Guid instanceId = Guid.NewGuid();
                model.hidNewOrderInstanceId = instanceId.ToString();
                Guid TemporaryId = string.IsNullOrEmpty(model.TemporaryId) ? Guid.Empty : new Guid(model.TemporaryId);
                //先判断一下单据当前状态，如果已被确认或者订单状态不是“已提交”或“已进入SAP”
                IPurchaseOrderBLL _business = new PurchaseOrderBLL();
                PurchaseOrderHeader header = _business.GetPurchaseOrderHeaderById(TemporaryId);
                if (header.OrderStatus == PurchaseOrderStatus.Submitted.ToString() || header.OrderStatus == PurchaseOrderStatus.Uploaded.ToString())
                {
                    bool result = _business.CopyForTemporary(TemporaryId, instanceId, out rtnVal, out rtnMsg);
                    model.hidRtnVal = rtnVal;
                    //this.hidRtnMsg.Text = rtnMsg;
                }
                else
                {
                    model.hidRtnVal = "statusChange";
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
    }
}
