using System;
using System.Collections;
using DMS.Common.Common;
using DMS.Common;
using DMS.ViewModel.MasterDatas;
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
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;
using DMS.Model.Data;
using DMS.DataAccess.DataInterface;
using DMS.Business;
using Grapecity.DataAccess.Transaction;
using System.Reflection;

namespace DMS.BusinessService.MasterDatas
{
    public class InventoryInitService : ABaseQueryService
    {
        public string QueryErrorData(InventoryInitVO model)
        {
            try
            {
                int totalCount = 0;
                IInventoryInitBLL business = new InventoryInitBLL();
                int start = (model.Page - 1) * model.PageSize;

                IList<InventoryInit> list = business.QueryErrorData(start, model.PageSize, out totalCount);

                model.DataCount = totalCount;
                model.IsSuccess = true;

                model.RstInitImportResult = JsonHelper.DataTableToArrayList(list.ToDataSet().Tables[0]);

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstInitImportResult, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonConvert.SerializeObject(result);
        }
        public InventoryInitVO DeleteErrorData(InventoryInitVO model)
        {
            try
            {
                IInventoryInitBLL business = new InventoryInitBLL();
                business.Delete(model.DelErrorId.ToSafeGuid());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InventoryInitVO ImportCorrectData(InventoryInitVO model)
        {
            try
            {
                IInventoryInitBLL business = new InventoryInitBLL();
                //foreach (Newtonsoft.Json.Linq.JObject dtInvInit in model.RstInitImportResult)
                //{
                for (int i = 0; i < model.RstInitImportResult.Count; i++)
                {
                    Newtonsoft.Json.Linq.JObject dtInvInit = Newtonsoft.Json.Linq.JObject.Parse(model.RstInitImportResult[i].ToString());
                    DMS.Model.InventoryInit init = new DMS.Model.InventoryInit();
                    init.Id = dtInvInit["Id"].ToString().Replace("\"", "").ToSafeGuid();
                    init.SapCode = dtInvInit["SapCode"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.WhmName = dtInvInit["WhmName"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.Cfn = dtInvInit["Cfn"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.LtmLotNumber = dtInvInit["LtmLotNumber"].ToString().Replace("\"", "").ToSafeString().Replace("null", "");
                    init.LtmExpiredDate = ParseJsonDate(dtInvInit["LtmExpiredDate"].ToString().Replace("\"", "").ToSafeString()).ToString();
                    init.Qty = dtInvInit["Qty"].ToString().Replace("\"", "").ToSafeString().Replace("null", "0.1");

                    business.Update(init);
                }
                model.RstInitImportResult = null;

                string IsValid = string.Empty;
                
                if (business.Verify(out IsValid))
                {
                    if (IsValid == "Success")
                    {
                        model.ExecuteMessage.Add("数据导入成功！");
                    }
                    else if (IsValid == "Error")
                    {
                        model.ExecuteMessage.Add("数据包含错误！");
                    }
                    else
                    {
                        model.ExecuteMessage.Add("数据导入异常！");
                    }
                }
                else
                {
                    model.ExecuteMessage.Add("数据导入过程发生错误！");
                }

            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            model.RstInitImportResult = null;
            return model;
        }

        protected DateTime? ParseJsonDate(string jsonDate)
        {
            DateTime dt;
            if (!string.IsNullOrEmpty(jsonDate.Replace("null", "")))
            {
                DateTime.TryParse(jsonDate, out dt);
                return dt;
            }
            else
            {
                return null;
            }
        }

    }
    
}
