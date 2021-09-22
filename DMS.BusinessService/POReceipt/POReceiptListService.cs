using DMS.Business;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.Model.Data;
using DMS.ViewModel.POReceipt;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.POReceipt
{
    public class POReceiptListService : ABaseQueryService, IQueryExport, IDealerFilterFac
    {
        #region Ajax Method
        IRoleModelContext _context = RoleModelContext.Current;
        public IPOReceipt business = new DMS.Business.POReceipt();
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public POReceiptListVO Init(POReceiptListVO model)
        {
            try
            {
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
                model.SerchVisibile = true;
                if (IsDealer)
                {
                    model.btnImportHidden = true;
                    if (RoleModelContext.Current.User.CorpType.Equals(DealerType.T2.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.DealerDisabled = true;
                        model.hidDealer = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //model.btnImportHidden = true;
                    }
                    else if (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString()))
                    {
                        model.DealerListType = "3";
                        model.LstDealer = new ArrayList(DealerListByFilter(true).ToList());
                        model.DealerDisabled = false;
                        model.hidDealer = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //this.hidInitDealerId.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                        //如果为平台导入按钮开放
                        //model.btnImportHidden = false;
                    }
                    else
                    {
                        model.LstDealer = new ArrayList(DealerList().ToList());
                        model.DealerDisabled = false;
                        model.hidDealer = RoleModelContext.Current.User.CorpId.Value.ToString();
                    }
                    model.DealerType = RoleModelContext.Current.User.CorpType;
                }
                else
                {
                    model.DealerType = "";
                    if (_context.IsInRole("渠道管理员") || _context.IsInRole("Administrators"))
                    {
                        model.btnImportHidden = false;
                    }
                    model.LstDealer = new ArrayList(DealerList().ToList());
                    model.DealerDisabled = false;
                    //控制查询按钮
                    Permissions pers = this._context.User.GetPermissions();
                    model.SerchVisibile = pers.IsPermissible(Business.POReceipt.Action_DealerReceipt, PermissionType.Read);
                }
                model.IsDealer = IsDealer;
                Hashtable htbu = new Hashtable();
                htbu.Add("SubCompanyId", BaseService.CurrentSubCompany?.Key);
                htbu.Add("BrandId", BaseService.CurrentBrand?.Key);
                model.LstBu = base.GetProductLine();
                model.LstType = DictionaryHelper.GetKeyValueList(SR.Consts_Receipt_Type); ;
                model.LstStatus = DictionaryHelper.GetKeyValueList(SR.Consts_Receipt_Status);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(POReceiptListVO model)
        {
            try
            {
                PoReceiptHeaderDao ContractHeader = new PoReceiptHeaderDao();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLine", model.QryBu.Key.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DealerDmaId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.QryType.ToSafeString()))
                    if (model.QryType.Value != "全部" && model.QryType.Key != "")
                        param.Add("Type", model.QryType.Key);
                if (!string.IsNullOrEmpty(model.QryBeginDate.ToSafeString()))
                    param.Add("SapShipmentDateStart", model.QryBeginDate);
                if (!string.IsNullOrEmpty(model.QryEndDate.ToSafeString()))
                    param.Add("SapShipmentDateEnd", model.QryEndDate);
                if (!string.IsNullOrEmpty(model.QryDeliveryOrderNo.ToSafeString()))
                    param.Add("SapShipmentid", model.QryDeliveryOrderNo);
                if (!string.IsNullOrEmpty(model.QryStatus.ToSafeString()))
                    if (model.QryStatus.Value != "全部" && model.QryStatus.Key != "")
                        param.Add("Status", model.QryStatus.Key);
                if (!string.IsNullOrEmpty(model.QryProductType.ToSafeString()))
                    param.Add("Cfn", model.QryProductType);
                //if (!string.IsNullOrEmpty(this.txtUPN.Text))
                //{
                //    param.Add("Upn", this.txtUPN.Text);
                //}
                if (!string.IsNullOrEmpty(model.QryPurchaseOrderNo.ToSafeString()))
                    param.Add("PurchaseOrderNbr", model.QryPurchaseOrderNo);//采购单号
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                    param.Add("LotNumber", model.QryLotNumber);
                if (!string.IsNullOrEmpty(model.QryERPNbr.ToSafeString()))
                    param.Add("ERPNbr", model.QryERPNbr);
                if (!string.IsNullOrEmpty(model.QryERPLineNbr.ToSafeString()))
                    param.Add("ERPLineNbr", model.QryERPLineNbr);

                //BSC用户可以看所有发货单，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商的发货单
                if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
                {
                    param.Add("LPId", RoleModelContext.Current.User.CorpId);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryPoReceipt(param, start, model.PageSize, out totalCount);
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
            var result = new { success = model.IsSuccess, data = data, ExecuteMessage = model.ExecuteMessage };
            return JsonConvert.SerializeObject(result);
        }

        #endregion

        #region 下载
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["Bu"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["Bu"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            {
                param.Add("DealerDmaId", Parameters["Dealer"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Type"].ToSafeString()))
            {
                param.Add("Type", Parameters["Type"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Status"].ToSafeString()))
            {
                param.Add("Status", Parameters["Status"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["BeginDate"].ToSafeString()))
            {
                param.Add("SapShipmentDateStart", Parameters["BeginDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["EndDate"].ToSafeString()))
            {
                param.Add("SapShipmentDateEnd", Parameters["EndDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["OrderNo"].ToSafeString()))
            {
                param.Add("SapShipmentid", Parameters["OrderNo"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ProductType"].ToSafeString()))
            {
                param.Add("Cfn", Parameters["ProductType"].ToSafeString());
            }
            //if (!string.IsNullOrEmpty(Parameters["Dealer"].ToSafeString()))
            //{
            //    param.Add("Upn", Parameters["PurchaseOrderNo"].ToSafeString());
            //}
            if (!string.IsNullOrEmpty(Parameters["LotNumber"].ToSafeString()))
            {
                param.Add("LotNumber", Parameters["LotNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["PurchaseOrderNo"].ToSafeString()))
            {
                param.Add("PurchaseOrderNbr", Parameters["PurchaseOrderNo"].ToSafeString());
            }

            //BSC用户可以看所有发货单，T1、T2经销商用户只能看自己的发货单,LP可以看自己的以及下属经销商的发货单
            if (IsDealer && (RoleModelContext.Current.User.CorpType.Equals(DealerType.LP.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.LS.ToString())))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            if (!string.IsNullOrEmpty(Parameters["ERPLineNbr"].ToSafeString()))
            {
                param.Add("ERPLineNbr", Parameters["ERPLineNbr"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["ERPNbr"].ToSafeString()))
            {
                param.Add("ERPNbr", Parameters["ERPNbr"].ToSafeString());
            }
            DataSet ds = business.QueryPoReceiptForExport(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("POReceiptList");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion

    }
}
