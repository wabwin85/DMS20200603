using DMS.Business;
using DMS.Business.Cache;
using DMS.Business.DataInterface;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.Common;
using DMS.Common.Common;
using DMS.Common.Extention;
using DMS.DataAccess;
using DMS.Model;
using DMS.Model.Data;
using DMS.ViewModel.Common;
using DMS.ViewModel.Contract;
using Lafite.RoleModel.Security;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace DMS.BusinessService.Contract
{
    public class ContractMainService : ABaseQueryService, IDealerFilterFac
    {
        #region Ajax Method
        IDealerMasters business = new DealerMasters();
        IRoleModelContext context = RoleModelContext.Current;
        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }
        public ContractMainVO Init(ContractMainVO model)
        {
            try
            {
                IDictionary<string, string> dictsCompanyType = DictionaryHelper.GetDictionary(SR.Consts_Dealer_Type);
                var listType = from p in dictsCompanyType where p.Key != "HQ" select p;
                model.LstDealerType = JsonHelper.DataTableToArrayList(listType.ToList().ToDataSet().Tables[0]);
                DealerMasterDao dealerMasterDao = new DealerMasterDao();
                model.LstDealer = dealerMasterDao.SelectFilterListAll("");
                if (IsDealer)
                {
                    if (context.User.CorpType.Equals(DealerType.T2.ToString()))
                    {
                        model.LstDealer = dealerMasterDao.SelectFilterListAll(context.User.CorpName);
                        model.DisableSelect = true;
                        model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                    }
                    else if (context.User.CorpType.Equals(DealerType.LP.ToString()) || context.User.CorpType.Equals(DealerType.LS.ToString()) || RoleModelContext.Current.User.CorpType.Equals(DealerType.T1.ToString()))
                    {
                        model.LstDealer = dealerMasterDao.SelectFilterListAll(context.User.CorpName);
                        model.QryDealer = new KeyValue(context.User.CorpId.ToSafeString(), context.User.CorpName);
                        if (context.User.CorpType.Equals(DealerType.T1.ToString()))
                        {
                            model.DisableSelect = true;
                        }
                    }
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
        
        public string Query(ContractMainVO model)
        {
            try
            {
                Hashtable param = new Hashtable();
                if (!string.IsNullOrEmpty(model.QryDealer.Key))
                {
                    param.Add("DealerId", model.QryDealer.Key);
                }
                if (!string.IsNullOrEmpty(model.QryDealerType.Key))
                {
                    param.Add("DealerType", model.QryDealerType.Key);
                }
                if (IsDealer && (context.User.CorpType.Equals(DealerType.LP.ToString()) || context.User.CorpType.Equals(DealerType.LS.ToString())))
                {
                    param.Add("DealerIdLP", context.User.CorpId);
                }

                int totalCount = 0;
                int start = (model.Page - 1) * model.PageSize;
                var lists = business.QueryForDealerMasterByAllUser(param, start, model.PageSize, out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(lists.ToDataSet().Tables[0]);

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
