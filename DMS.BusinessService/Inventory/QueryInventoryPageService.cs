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
using DMS.Business;

namespace DMS.BusinessService.Inventory
{
    public class QueryInventoryPageService : ABaseQueryService, IQueryExport
    {
        #region Ajax Method

        public QueryInventoryPageVO Init(QueryInventoryPageVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer;
                model.DealerId = context.User.CorpId.ToString();
                model.DealerType = context.User.CorpType;
                model.LstProductLine = GetProductLine();
                Permissions pers = context.User.GetPermissions();
                model.IsShowQuery = pers.IsPermissible(Business.QueryInventoryBiz.Action_DealerInventoryQuery, PermissionType.Read);
                
                model.LstDealer = JsonHelper.DataTableToArrayList(GetDealerSource().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        
        public string Query(QueryInventoryPageVO model)
        {
            try
            {
                QueryInventoryDao inventory = new QueryInventoryDao();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DealerId", model.QryDealer.Key.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryProductModel))
                {
                    param.Add("CustomerFaceNbr", model.QryProductModel.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QrySNQrCode))
                {
                    param.Add("LotNumber", model.QrySNQrCode.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryWarehouse.Key))
                {
                    param.Add("WhmId", model.QryWarehouse.Key.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryValidityDate.StartDate))
                {
                    param.Add("ExpiredDateFrom", model.QryValidityDate.StartDate.ToSafeString());
                }

                if (!string.IsNullOrEmpty(model.QryValidityDate.EndDate))
                {
                    param.Add("ExpiredDateTo", model.QryValidityDate.EndDate.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryProductName))
                {
                    param.Add("CfnName", model.QryProductName.ToSafeString());
                }

                if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(Model.Data.DealerType.LP.ToString()))
                {
                    param.Add("LPId", RoleModelContext.Current.User.CorpId);
                }
                if (!string.IsNullOrEmpty(model.QryStockdays))
                {
                    param.Add("Stockdays", model.QryStockdays.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryProductLine.Key))
                {
                    param.Add("cbProductLine", model.QryProductLine.Key.ToSafeString());
                }
                param = BaseService.AddCommonFilterCondition(param);

                int start = (model.Page - 1) * model.PageSize;
                model.RstResultList = JsonHelper.DataTableToArrayList(inventory.SelectByFilterDataSet(param, start, model.PageSize, out totalCount).Tables[0]);

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

        public QueryInventoryPageVO DealerChange(QueryInventoryPageVO model)
        {
            try
            {
                WarehouseDao dao = new WarehouseDao();
                Guid dealerID = new Guid(model.QryDealer.Key);
                model.LstWarehouse = JsonHelper.DataTableToArrayList(dao.GetAllByDealer(dealerID).ToDataSet().Tables[0]);
                model.IsSuccess = true;
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }

            return model;
        }
        
        public void Export(NameValueCollection Parameters, string DownloadCookie)
        {
            
            Hashtable param = new Hashtable();

            if (!string.IsNullOrEmpty(Parameters["QryDealer"]))
            {
                param.Add("DealerId", Parameters["QryDealer"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryProductModel"]))
            {
                param.Add("CustomerFaceNbr", Parameters["QryProductModel"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QrySNQrCode"]))
            {
                param.Add("LotNumber", Parameters["QrySNQrCode"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryWarehouse"]))
            {
                param.Add("WhmId", Parameters["QryWarehouse"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryValidityDateStartDate"]))
            {
                param.Add("ExpiredDateFrom", Parameters["QryValidityDateStartDate"].ToSafeString());
            }

            if (!string.IsNullOrEmpty(Parameters["QryValidityDateEndDate"]))
            {
                param.Add("ExpiredDateTo", Parameters["QryValidityDateEndDate"].ToSafeString());
            }
            if (!string.IsNullOrEmpty(Parameters["QryProductName"]))
            {
                param.Add("CfnName", Parameters["QryProductName"].ToSafeString());
            }
            if (IsDealer && RoleModelContext.Current.User.CorpType.Equals(Model.Data.DealerType.LP.ToString()))
            {
                param.Add("LPId", RoleModelContext.Current.User.CorpId);
            }
            IRoleModelContext context = RoleModelContext.Current;
            param.Add("OwnerIdentityType", context.User.IdentityType);
            param.Add("OwnerOrganizationUnits", context.User.GetOrganizationUnits());
            param.Add("OwnerId", new Guid(context.User.Id));
            param = BaseService.AddCommonFilterCondition(param);
            QueryInventoryDao inventory = new QueryInventoryDao();
            DataSet Invds = new DataSet();
            DataSet ds = new DataSet("经销商库存数据");

            if (Parameters["QueryInventoryExportType"].ToSafeString() == "ExportByDealer")
            {
                if (!string.IsNullOrEmpty(Parameters["QryStockdays"]))
                {
                    param.Add("Stockdays", Parameters["QryStockdays"].ToSafeString());
                }
                if (!string.IsNullOrEmpty(Parameters["QryProductLine"]))
                {
                    param.Add("cbProductLine", Parameters["QryProductLine"].ToSafeString());
                }
                Invds = inventory.SelectNPOIDataSetByFilter(param);
                DataTable dt = Invds.Tables[0].Copy();

                #region 构造导出Table
                DataTable dtData = dt;
                dtData.TableName = "经销商库存数据";
                if (null != dtData)
                {
                    #region 调整列的顺序,并重命名列名

                    Dictionary<string, string> dict = new Dictionary<string, string>
                    {
                        {"ChineseName", "经销商中文名"},
                        {"DealerType", "经销商类型"},
                        {"ParentChineseName", "上级经销商"},
                        {"ProductLineName", "产品线中文名"},
                        {"ProductLineEnglishName", "产品线英文名"},
                        {"SubCompanyName", "分子公司"},
                        {"BrandName", "品牌"},
                        {"WarehouseType", "仓库类型"},
                        {"WHMCode", "仓库编号"},
                        {"WHMName", "仓库名称"},
                        {"CustomerFaceNbr", "产品型号"},
                        {"LotNumber", "序列号/批号"},
                        {"QrCode", "二维码"},
                        {"OnHandQty", "库存数量"},
                        {"LTMType", "产品生产日期"},
                        {"ExpiredDate", "有效期"},
                        {"UnitOfMeasure", "单位"},
                        {"CFNChineseName", "产品中文名"},
                        {"CFNEnglishName", "产品英文名"},
                        {"Registration", "注册证号"},
                        {"GTIN", "GTIN条码"},
                        {"Company", "生产厂商"},
                        {"SourceWhmName", "原仓库名称"}
                    };

                    CommonFunction.SetColumnIndexAndRemoveColumn(dtData, dict);

                    #endregion 调整列的顺序,并重命名列名

                    ds.Tables.Add(dtData);

                }
                #endregion 构造导出Table
            }
            else if(Parameters["QueryInventoryExportType"].ToSafeString() == "ExportByCategory")
            {
                BaseService.AddCommonFilterCondition(param);
                ds = inventory.ExportLPInventoryABCDataSetByFilter(param);
            }
            
            
            DataSet[] result = new DataSet[1];
            result[0] = ds;

            Hashtable ht = new Hashtable();
            XlsExport xlsExport = new XlsExport("QueryInventoryPage");
            xlsExport.Export(ht, result, DownloadCookie);

        }

        #endregion
    }
}
