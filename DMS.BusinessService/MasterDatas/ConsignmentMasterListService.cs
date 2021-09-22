using DMS.Business;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.DataAccess.ContractElectronic;
using DMS.ViewModel.Common;
using DMS.ViewModel.MasterDatas;
using Lafite.RoleModel.Security;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.MasterDatas
{
    public class ConsignmentMasterListService : ABaseQueryService
    {
        #region Ajax Method
        private IConsignmentMasterBLL business = new ConsignmentMasterBLL();
        public ConsignmentMasterListVO Init(ConsignmentMasterListVO model)
        {
            try
            {
                IRoleModelContext _context = RoleModelContext.Current;
                model.SearchEnabled = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                model.InsertEnable = _context.IsInRole("Administrators") || _context.IsInRole("经销商短期寄售管理员");
                model.LstDealer = new ArrayList(DealerList().ToList());
                model.IsDealer = IsDealer;
                model.LstBu = base.GetProductLine();
                model.LstType = new ArrayList(DictionaryHelper.GetDictionary(SR.Const_Consignment_Rule).ToArray());
                model.LstStatus = new ArrayList(DictionaryHelper.GetDictionary(SR.Const_Consignment_Type).ToArray());
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(ConsignmentMasterListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryBu.ToSafeString()))
                    if (model.QryBu.Value != "全部" && model.QryBu.Key != "")
                        param.Add("ProductLineId", model.QryBu.Key.ToSafeString());
                if (!string.IsNullOrEmpty(model.QryDealer.ToSafeString()))
                    if (model.QryDealer.Value != "全部" && model.QryDealer.Key != "")
                        param.Add("DealerId", model.QryDealer.Key);
                if (!string.IsNullOrEmpty(model.QryType.ToSafeString()))
                    if (model.QryType.Value != "全部" && model.QryType.Key != "")
                        param.Add("OrderType", model.QryType.Key);
                if (!string.IsNullOrEmpty(model.QryApplyDate.StartDate))
                    param.Add("StartDate", model.QryApplyDate.StartDate);
                if (!string.IsNullOrEmpty(model.QryApplyDate.EndDate.ToSafeString()))
                    param.Add("EndDate", model.QryApplyDate.EndDate);
                if (!string.IsNullOrEmpty(model.QryOrderNo.ToSafeString()))
                    param.Add("OrderNo", model.QryOrderNo);
                if (!string.IsNullOrEmpty(model.QryStatus.ToSafeString()))
                    if (model.QryStatus.Value != "全部" && model.QryStatus.Key != "")
                        param.Add("OrderStatus", model.QryStatus.Key);
                if (!string.IsNullOrEmpty(model.QryProductType.ToSafeString()))
                    param.Add("Cfn", model.QryProductType);
                if (!string.IsNullOrEmpty(model.QryConsignmentName.ToSafeString()))
                    param.Add("ConsignmentName", model.QryConsignmentName);


                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.SelectConsignmentMasterByFilter(param, start, model.PageSize, out totalCount);
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
    }
}
