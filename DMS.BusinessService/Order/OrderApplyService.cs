using DMS.Business;
using DMS.Business.Excel;
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
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Order
{
    public class OrderApplyService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        private IPurchaseOrderBLL business = new PurchaseOrderBLL();
        IRoleModelContext _context = RoleModelContext.Current;
        private IPurchaseOrderBLL _logbll = new PurchaseOrderBLL();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public OrderApplyVO Init(OrderApplyVO model)
        {
            try
            {
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();
                model.LstStatus = OrderStatusForTier(SR.Consts_Order_Status);
                model.LstType = OrderTypeForTier(SR.Consts_Order_Type);
                //借入经销商
                if (IsDealer)
                {
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.cbDealerDisabled = true;
                        model.hidInitDealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                        model.DealerListType = "2";
                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                    }
                }
                else
                {
                    model.LstDealer = new ArrayList(DealerList().ToList());
                }

                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                model.SerchVisibile = pers.IsPermissible(Business.PurchaseOrderBLL.Action_OrderApply, PermissionType.Read);

                //如果使用此菜单功能的人员不是二级经销商，则不可以使用新增和导入功能
                model.InsertDisabled = false;
                model.btnImportDisabled = false;
                model.btnStockpriceDisabled = false;
                if (!IsDealer)
                {
                    model.InsertDisabled = true;
                    model.btnImportDisabled = true;

                }
                else if (!RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
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

        protected ArrayList OrderStatusForTier(string type)
        {
            //二级经销商可以查看普通订单、寄售订单、寄售销售订单
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            var result = (from t in dicts
                          where (t.Key == PurchaseOrderStatus.Draft.ToString() ||
                                 t.Key == PurchaseOrderStatus.Submitted.ToString() ||
                                 t.Key == PurchaseOrderStatus.Uploaded.ToString() ||
                                 t.Key == PurchaseOrderStatus.Revoked.ToString() ||
                                 t.Key == PurchaseOrderStatus.Confirmed.ToString() ||
                                 t.Key == PurchaseOrderStatus.Delivering.ToString() ||
                                 t.Key == PurchaseOrderStatus.Completed.ToString()
                                 )
                          select t);
            return new ArrayList(result.ToList());
        }
        protected ArrayList OrderTypeForTier(string type)
        {
            //二级经销商可以查看普通订单、寄售订单、寄售销售订单、短期借货订单、促销订单
            IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(type);
            var result = (from t in dicts
                          where (t.Key == PurchaseOrderType.Normal.ToString() ||
                                 t.Key == PurchaseOrderType.Consignment.ToString() ||
                                 t.Key == PurchaseOrderType.ConsignmentSales.ToString() ||
                                 t.Key == PurchaseOrderType.Exchange.ToString() ||
                                 t.Key == PurchaseOrderType.BOM.ToString() ||
                                 t.Key == PurchaseOrderType.SCPO.ToString() ||
                                 t.Key == PurchaseOrderType.PRO.ToString() ||
                                 t.Key == PurchaseOrderType.CRPO.ToString())
                          select t);
            return new ArrayList(result.ToList());
        }
        public string Query(OrderApplyVO model)
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
                if (!string.IsNullOrEmpty(model.QryOrderStatus.ToSafeString()))
                    if (model.QryOrderStatus.Value != "全部" && model.QryOrderStatus.Key != "")
                    {
                        param.Add("OrderStatus", model.QryOrderStatus.Key);
                    }
                if (!string.IsNullOrEmpty(model.QryOrderType.ToSafeString()))
                    if (model.QryOrderType.Value != "全部" && model.QryOrderType.Key != "")
                    {
                        param.Add("OrderType", model.QryOrderType.Key);
                    }
                if (!string.IsNullOrEmpty(model.QryApplyDate.ToSafeString()))
                {
                    if (!string.IsNullOrEmpty(model.QryApplyDate.StartDate.ToSafeString()))
                        param.Add("SubmitDateStart", Convert.ToDateTime(model.QryApplyDate.StartDate).ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryApplyDate.ToSafeString()))
                {
                    if (!string.IsNullOrEmpty(model.QryApplyDate.EndDate.ToSafeString()))
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
                //BSC用户可以看所有订单，T2经销商用户只能看自己创建的订单
                if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
                {
                    param.Add("CreateUser", new Guid(_context.User.Id));
                }

                if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
                {
                    param.Add("LPId", RoleModelContext.Current.User.CorpId);
                }

                if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
                {
                    param.Add("IsHQ", "True");
                }
   
                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryPurchaseOrderHeaderForT2Dealer(param, start, model.PageSize, out totalCount);
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

            if (!string.IsNullOrEmpty(Parameters["ProductLineBumId"].ToSafeString()))
            {
                param.Add("ProductLineBumId", Parameters["ProductLineBumId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DealerId"].ToSafeString()))
            {
                param.Add("DmaId", Parameters["DealerId"].ToSafeString());
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
            if (!string.IsNullOrEmpty(Parameters["Remark"].ToSafeString()))
            {
                param.Add("Remark", Parameters["Remark"].ToSafeString());
            }
            //只能查询自己下的订单
            //BSC用户可以看所有订单，T2经销商用户只能看自己创建的订单
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()))
            {
                param.Add("CreateUser", new Guid(_context.User.Id));
            }

            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }

            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(DealerType.HQ.ToString()))
            {
                param.Add("IsHQ", "True");
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

            DataSet ds = business.ExportPurchaseOrderDetailForT2Dealer(param);//dt是从后台生成的要导出的datatable;
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("OrderApply");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion

    }
}
