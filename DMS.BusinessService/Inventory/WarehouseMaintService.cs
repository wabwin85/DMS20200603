using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.Inventory;
using DMS.DataAccess;
using DMS.Common.Extention;
using DMS.DataAccess.ContractElectronic;
using DMS.DataAccess.Consignment;
using Lafite.RoleModel.Security;
using DMS.Business.Cache;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using DMS.Business.Excel;
using System.Collections.Specialized;
using Newtonsoft.Json;

namespace DMS.BusinessService.Inventory
{
    public class WarehouseMaintService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method

        public WarehouseMaintVO Init(WarehouseMaintVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                Permissions pers = context.User.GetPermissions();
                model.IsShowSave = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Write);
                model.IsShowAdd = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Write);
                model.IsShowDelete = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Delete);
                model.IsShowQuery = pers.IsPermissible(Business.Warehouses.Action_DealerWarehouseMaint, PermissionType.Read);

                model.DealerId = context.User.CorpId.ToString();
                model.LstDealer = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);
                model.IsDealer = IsDealer;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        
        public string Query(WarehouseMaintVO model)
        {
            try
            {
                WarehouseDao warehouse = new WarehouseDao();

                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DmaId", model.QryDealer.Key.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryWarehouse))
                {
                    param.Add("Name", model.QryWarehouse.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryAddress))
                {
                    param.Add("Address", model.QryAddress.ToSafeString());
                }

                IRoleModelContext context = RoleModelContext.Current;
                param.Add("OwnerIdentityType", context.User.IdentityType);
                param.Add("OwnerOrganizationUnits", context.User.GetOrganizationUnits());
                param.Add("OwnerId", new Guid(context.User.Id));

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                model.RstResultList = JsonHelper.DataTableToArrayList(warehouse.GetWarehouseByHashtable(param, start, model.PageSize, out totalCount).ToDataSet().Tables[0]);

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
            return JsonConvert.SerializeObject(result);
        }

        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {

            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["QryDealer"]))
            {
                param.Add("DmaId", Parameters["QryDealer"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryWarehouse"]))
            {
                param.Add("Name", Parameters["QryWarehouse"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryAddress"]))
            {
                param.Add("Address", Parameters["QryAddress"].ToSafeString());
            }

            IRoleModelContext context = RoleModelContext.Current;
            param.Add("OwnerIdentityType", context.User.IdentityType);
            param.Add("OwnerOrganizationUnits", context.User.GetOrganizationUnits());
            param.Add("OwnerId", new Guid(context.User.Id));
            WarehouseDao warehouse = new WarehouseDao();
            DataSet Invds = warehouse.GetWarehouseForExport(param);
            
            DataSet[] result = new DataSet[1];
            result[0] = Invds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("WarehouseMaint");
            xlsExport.Export(ht, result, DownloadCookie);

        }

        #endregion
    }
}
