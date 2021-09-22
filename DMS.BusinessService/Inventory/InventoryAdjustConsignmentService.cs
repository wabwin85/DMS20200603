using DMS.Business;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.Model.Data;
using DMS.ViewModel.Inventory;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Inventory
{
    public class InventoryAdjustConsignmentService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        IRoleModelContext _context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public InventoryAdjustConsignmentVO Init(InventoryAdjustConsignmentVO model)
        {
            try
            {
                //model.LstDealer = new ArrayList(DealerList().ToList());
                model.LstDealer = new ArrayList(DealerListByFilter(false).ToList());
                model.DealerListType = "2";
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();

                IDictionary<string, string> dicts = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Status);
                var lststatus = dicts.ToList().FindAll(item => item.Key != AdjustStatus.Reject.ToString() && item.Key != AdjustStatus.Submitted.ToString() && item.Key != AdjustStatus.Accept.ToString());
                ArrayList s = new ArrayList();s.AddRange(lststatus);
                model.LstStatus = s;

                IDictionary<string, string> type = DictionaryHelper.GetDictionary(SR.Consts_AdjustQty_Type);
                var lstType = from d in type where d.Key.Equals(AdjustType.StockIn.ToString()) || d.Key.Equals(AdjustType.StockOut.ToString()) select d;
                ArrayList t = new ArrayList(); t.AddRange(lstType.ToList());
                model.LstType = t;

                model.InsertVisible = IsDealer;
                if (IsDealer)
                {
                    //this.cbDealer.Disabled = true;
                    //this.cbDealer.SelectedItem.Value = RoleModelContext.Current.User.CorpId.Value.ToString();
                    DealerOperationLogDLL.instance.writeLog(SR.CONST_MODULE_ADJUST);
                }
                else
                {
                }
                //控制查询按钮
                Permissions pers = this._context.User.GetPermissions();
                model.SearchVisible = pers.IsPermissible(Business.InventoryAdjustBLL.Action_InventoryAdjustConsignment, PermissionType.Read);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        public IInventoryAdjustBLL business = new InventoryAdjustBLL();
        public string Query(InventoryAdjustConsignmentVO model)
        {
            try
            {
                InventoryAdjustConsignmentDao ContractHeader = new InventoryAdjustConsignmentDao();
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
                BaseService.AddCommonFilterCondition(param);
                int totalRowCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = ContractHeader.QueryInventoryAdjustHeaderConsignment(param, start, model.PageSize, out totalRowCount);
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
    }
}
