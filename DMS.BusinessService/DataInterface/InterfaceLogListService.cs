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
    public class InterfaceLogListService : ABaseQueryService
    {
        #region Ajax Method
        InterfaceLogBLL business = new InterfaceLogBLL();
        IRoleModelContext context = RoleModelContext.Current;
        public InterfaceLogListVO Init(InterfaceLogListVO model)
        {
            try
            {
                model.IsDealer = IsDealer;
                model.QryIlDate = new DatePickerRange(DateTime.Now.AddMonths(-1).AddDays(1).ToString("yyyy-MM-dd"), "");
                var listDealer = GetDealerSource();
                listDealer = (from t in listDealer where (t.DealerType == "LP") select t).ToList<DealerMaster>();
                model.LstDealer = JsonHelper.DataTableToArrayList(listDealer.ToDataSet().Tables[0]);
                if (IsDealer)
                {
                    model.QryDealer = new KeyValue(context.User.CorpId.Value.ToString(), context.User.CorpName);
                }
                IDictionary<string, string> dictsName = DictionaryHelper.GetDictionary("CONST_DataInterfaceType");
                model.LstIlName = JsonHelper.DataTableToArrayList(dictsName.ToList().ToDataSet().Tables[0]);
                IDictionary<string, string> dictsStatus = DictionaryHelper.GetDictionary("CONST_MakeOrder_Status");
                model.LstIlStatus = JsonHelper.DataTableToArrayList(dictsStatus.ToList().ToDataSet().Tables[0]);
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public InterfaceLogListVO InitDetail(InterfaceLogListVO model)
        {
            try
            {
                Hashtable header = business.GetInterfaceLogById(model.IlId.ToSafeGuid());

                model.WinIlName = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_DataInterfaceType, header["IL_Name"].ToString());
                model.WinIlStartTime = header["IL_StartTime"].ToString();
                model.WinIlEndTime = header["IL_EndTime"].ToString();
                model.WinIlStatus = DictionaryCacheHelper.GetDictionaryNameById(SR.Consts_MakeOrder_Status, header["IL_Status"].ToString());
                model.WinIlDealerName = header["DMA_ChineseName"].ToString();
                model.WinIlBatchNbr = header["IL_BatchNbr"].ToString();
                model.WinIlMessage = header["Il_Message"].ToString();
            }
            catch (Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(InterfaceLogListVO model)
        {
            try
            {
                Hashtable param = new Hashtable();

                if (!string.IsNullOrEmpty(model.QryIlName.Key))
                {
                    param.Add("IlName", model.QryIlName.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryIlStatus.Key))
                {
                    param.Add("IlStatus", model.QryIlStatus.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("IlCorpId", model.QryDealer.Key.ToSafeString());
                }
                if (!string.IsNullOrEmpty(model.QryIlDate.StartDate))
                {
                    param.Add("StartDate", model.QryIlDate.StartDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryIlDate.EndDate))
                {
                    param.Add("EndDate", model.QryIlDate.EndDate.ToSafeDateTime().ToString("yyyyMMdd"));
                }
                if (!string.IsNullOrEmpty(model.QryIlBatchNbr))
                {
                    param.Add("IlBatchNbr", model.QryIlBatchNbr.ToSafeString());
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                DataSet ds = business.QueryInterfaceLog(param, start, model.PageSize, out totalCount);
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
