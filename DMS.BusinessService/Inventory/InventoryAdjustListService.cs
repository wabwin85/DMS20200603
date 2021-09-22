using DMS.Business;
using DMS.Business.Excel;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.DataAccess.Consignment;
using DMS.DataAccess.ContractElectronic;
using DMS.Model.Data;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Domain;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryAdjustListService : ABaseQueryService, IDealerFilterFac, IQueryExport
    {
        #region Ajax Method
        public IShipmentBLL spbusiness = new ShipmentBLL();
        IRoleModelContext _context = RoleModelContext.Current;

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public InventoryAdjustListVO Init(InventoryAdjustListVO model)
        {
            try
            {
                model.InsertVisible = IsDealer;
                model.ImportVisible = spbusiness.IsAdminRole();
                model.IsDealer = IsDealer;
                model.LstDealer = new ArrayList(DealerList().ToList());
                model.LstBu = base.GetProductLine();

                IList<DictionaryDomain> dictsType = DictionaryHelper.GetAllKeyValueList(SR.Consts_AdjustQty_Type);
                IList<DictionaryDomain> r = dictsType.Where(item => item.DictKey == AdjustType.StockIn.ToString() || item.DictKey == AdjustType.StockOut.ToString()).ToList();
                model.LstType = DictionaryHelper.GetKeyValueListByParams(r);
                //  model.LstStatus = DictionaryHelper.GetKeyValueList(SR.Consts_AdjustQty_Status);
                IList<DictionaryDomain> dicts = DictionaryHelper.GetAllKeyValueList(SR.Consts_AdjustQty_Status);
                IList<DictionaryDomain> list = dicts.Where(item => item.DictKey != AdjustStatus.Reject.ToString() && item.DictKey != AdjustStatus.Submitted.ToString() && item.DictKey != AdjustStatus.Accept.ToString()            
                && item.DictKey != "EWFApprove"//20191218，其他出入库状态：草稿、审批中、完成
                && item.DictKey != AdjustStatus.Submit.ToString()
                && item.DictKey != AdjustStatus.Cancelled.ToString()
                && item.DictKey != AdjustStatus.RsmApproval.ToString()
                ).ToList();
                model.LstStatus = DictionaryHelper.GetKeyValueListByParams(list);

                if (IsDealer)
                {
                    if (_context.User.CorpType == DealerType.HQ.ToString())
                    {
                        model.InsertVisible = false;
                    }
                    model.DealerDisabled = true;
                    model.DealerId = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ADJUST);
                }
                else
                {

                }
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                model.SearchVisible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryAdjust, PermissionType.Read);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(InventoryAdjustListVO model)
        {
            try
            {
                InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLine", model.QryBu.Key.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DealerId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.QryType.ToSafeString()))
                    if (model.QryType.Value != "全部" && model.QryType.Key != "")
                        param.Add("Type", model.QryType.Key);
                if (!string.IsNullOrEmpty(model.QryBeginDate.ToSafeString()))
                    param.Add("CreateDateStart", model.QryBeginDate);
                if (!string.IsNullOrEmpty(model.QryEndDate.ToSafeString()))
                    param.Add("CreateDateEnd", model.QryEndDate);
                if (!string.IsNullOrEmpty(model.QryOrderNo.ToSafeString()))
                    param.Add("AdjustNumber", model.QryOrderNo);
                if (!string.IsNullOrEmpty(model.QryStatus.ToSafeString()))
                    if (model.QryStatus.Value != "全部" && model.QryStatus.Key != "")
                        param.Add("Status", model.QryStatus.Key);
                if (!string.IsNullOrEmpty(model.QryProductType.ToSafeString()))
                    param.Add("Cfn", model.QryProductType);
                //if (!string.IsNullOrEmpty(model.QryBu.Key.ToSafeString()))
                //    param.Add("Upn", "");//条形码
                if (!string.IsNullOrEmpty(model.QryLotNumber.ToSafeString()))
                    param.Add("LotNumber", model.QryLotNumber);
                param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
                param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
                param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);
                int totalRowCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                BaseService.AddCommonFilterCondition(param);
                DataSet ds = ContractHeader.QueryInventoryAdjustHeader(param, start, model.PageSize, out totalRowCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = totalRowCount;
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
            return JsonConvert.SerializeObject(result);
        }

        #endregion

        #region 下载明细
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            InventoryAdjustHeaderDao ContractHeader = new InventoryAdjustHeaderDao();
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["ProductLine"].ToSafeString()))
            {
                param.Add("ProductLine", Parameters["ProductLine"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["DealerId"].ToSafeString()))
            {
                param.Add("DealerId", Parameters["DealerId"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Type"].ToSafeString()))
            {
                param.Add("Type", Parameters["Type"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CreateDateStart"].ToSafeString()))
            {
                param.Add("CreateDateStart", Parameters["CreateDateStart"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["CreateDateEnd"].ToSafeString()))
            {
                param.Add("CreateDateEnd", Parameters["CreateDateEnd"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["AdjustNumber"].ToSafeString()))
            {
                param.Add("AdjustNumber", Parameters["AdjustNumber"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Status"].ToSafeString()))
            {
                param.Add("Status", Parameters["Status"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["Cfn"].ToSafeString()))
            {
                param.Add("Cfn", Parameters["Cfn"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["LotNumber"].ToSafeString()))
            {
                param.Add("LotNumber", Parameters["LotNumber"].ToSafeString());
            }
            param.Add("OwnerIdentityType", RoleModelContext.Current.User.IdentityType);
            param.Add("OwnerOrganizationUnits", RoleModelContext.Current.User.GetOrganizationUnits());
            param.Add("OwnerId", new Guid(RoleModelContext.Current.User.Id));
            param.Add("OwnerCorpId", RoleModelContext.Current.User.CorpId);

            BaseService.AddCommonFilterCondition(param);
            DataSet ds = ContractHeader.QueryInventoryAdjustExport(param);
            if (ds != null)
            {
                DataTable dt = ds.Tables[0];
                DataSet[] result = new DataSet[1];
                result[0] = new DataSet();
                result[0].Tables.Add(dt.Copy());

                Hashtable ht = new Hashtable();
                XlsExport xlsExport = new XlsExport("InventoryAdjustList");
                xlsExport.Export(ht, result, DownloadCookie);
            }

        }
        #endregion

    }
}
