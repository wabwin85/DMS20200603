using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.DataInterface;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.DataInterface;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.DataInterface
{
    public class InterfaceDataListService : ABaseQueryService
    {
        #region Ajax Method
        InterfaceDataBLL business = new InterfaceDataBLL();
        IRoleModelContext context = RoleModelContext.Current;
        public InterfaceDataListVO Init(InterfaceDataListVO model)
        {
            try
            {
                model.IsDealer = IsDealer;
                model.QryInterfaceDate = new DatePickerRange(DateTime.Now.AddMonths(-1).AddDays(1).ToString("yyyy-MM-dd"), "");
                var listDealer = GetDealerSource();
                listDealer = (from t in listDealer where (t.DealerType == "LP") select t).ToList<DealerMaster>();
                model.LstClient = JsonHelper.DataTableToArrayList(listDealer.ToDataSet().Tables[0]);
                if (IsDealer)
                {
                    DealerMasterDao dao = new DealerMasterDao();
                    DealerMaster dealer = dao.GetObject(context.User.CorpId.Value);
                    model.QryClient = new KeyValue(context.User.CorpId.Value.ToString(), dealer.ChineseShortName);
                }
                IDictionary<string, string> dictStatus = DictionaryHelper.GetDictionary("CONST_MakeOrder_Status");
                if (dictStatus != null && dictStatus.ContainsKey("Invalid"))
                {
                    dictStatus.Remove("Invalid");
                }
                if (dictStatus != null && dictStatus.ContainsKey("Processing"))
                {
                    dictStatus.Remove("Processing");
                }
                model.LstInterfaceStatus = JsonHelper.DataTableToArrayList(dictStatus.ToList().ToDataSet().Tables[0]);
                model.LstInterfaceType = JsonHelper.DataTableToArrayList(business.SelectInterfaceDataType("CONST_InterfaceDataDataType").Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }
        
        public string Query(InterfaceDataListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                int start = (model.Page - 1) * model.PageSize;

                if (!string.IsNullOrEmpty(model.QryInterfaceType.ToSafeString()) && !string.IsNullOrEmpty(model.QryInterfaceType.Key.ToSafeString()))
                {
                    param.Add("DataType", model.QryInterfaceType.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryInterfaceStatus.ToSafeString()) && !string.IsNullOrEmpty(model.QryInterfaceStatus.Key.ToSafeString()))
                {
                    param.Add("DataStatus", model.QryInterfaceStatus.Key.ToSafeString());
                }
                else
                {
                    param.Add("DataStatus", "");
                }
                if (!string.IsNullOrEmpty(model.QryClient.ToSafeString()) && !string.IsNullOrEmpty(model.QryClient.Key.ToSafeString()))
                {
                    param.Add("DealerId", model.QryClient.Key.ToSafeString());
                }
                else
                {
                    param.Add("DealerId", Guid.Empty);
                }
                if (!string.IsNullOrEmpty(model.QryInterfaceDate.StartDate))
                {
                    param.Add("StareData", model.QryInterfaceDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                else
                {
                    param.Add("StareData", "");
                }
                if (!string.IsNullOrEmpty(model.QryInterfaceDate.EndDate))
                {
                    param.Add("EndDate", model.QryInterfaceDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                else
                {
                    param.Add("EndDate", "");
                }
                if (!string.IsNullOrEmpty(model.QryBatchNbr))
                {
                    param.Add("BatchNbr", model.QryBatchNbr.ToSafeString());
                }
                else
                {
                    param.Add("BatchNbr", "");
                }
                if (!string.IsNullOrEmpty(model.QryHeaderNo))
                {
                    param.Add("OrderNo", model.QryHeaderNo.ToSafeString());
                }
                else
                {
                    param.Add("OrderNo", "");
                }
                param.Add("start", start);
                param.Add("limit", model.PageSize);
                
                DataSet ds = business.QueryInterfaceData(param);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);

                model.DataCount = Convert.ToInt32(ds.Tables[1].Rows[0]["TotalCount"].ToString());
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
        
        public InterfaceDataListVO SetRecordStatus(InterfaceDataListVO model)
        {
            try
            {
                string RtnVal = string.Empty;
                string RtnMsg = string.Empty;
                
                business.UpdateInterfaceData(model.ParamID, new Guid(context.User.Id), model.ExecStatus, model.QryInterfaceType.Key.ToSafeString(), out RtnVal, out RtnMsg);
                if (RtnVal == "Success")
                {
                    model.ExecuteMessage.Add("Success");
                }
                else
                {
                    model.ExecuteMessage.Add(RtnMsg);
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
