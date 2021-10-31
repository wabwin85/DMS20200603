using DMS.ViewModel.Shipment;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DMS.Common.Extention;
using Lafite.RoleModel.Security;
using System.Data;
using DMS.DataAccess;
using DMS.Common;
using DMS.Common.Common;
using DMS.ViewModel.Shipment.Extense;
using DMS.BusinessService.Util.DealerFilter;
using DMS.BusinessService.Util.DealerFilter.Impl;
using DMS.ViewModel.Common;
using DMS.Model;

namespace DMS.BusinessService.Shipment
{
    public class ReconcileRuleService : ABaseQueryService, IDealerFilterFac
    { 

        public ADealerFilter CreateDealerFilter()
        {
            return new AllDealerFilter();
        }

        public ReconcileRuleVO Init(ReconcileRuleVO model)
        {
            try
            {
                IRoleModelContext context = RoleModelContext.Current;
                model.IsDealer = IsDealer; 

                ReconcileRuleDao dao = new ReconcileRuleDao();
                DataSet ds = dao.SelectSubCompanyAll();
                var subcompanies = from p in ds.Tables[0].AsEnumerable()
                                   select new KeyValue
                                   {
                                       Key = p.Field<string>("SubCompanyId").ToString(),
                                       Value = p.Field<string>("SubCompanyName")
                                   };
                model.SubCompanies = subcompanies.ToList();
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            return model;
        }

        public string Query(ReconcileRuleVO model)
        {
            try
            {
                ReconcileRuleDao dao = new ReconcileRuleDao();
                int totalCount = 0;

                Hashtable param = new Hashtable();
                if (model.SubCompany != null && !string.IsNullOrEmpty(model.SubCompany.Key))
                {
                    param.Add("SubCompanyId", model.SubCompany.Key.ToSafeString());
                }
                int start = (model.Page - 1) * model.PageSize;
                param.Add("start", start);
                param.Add("limit", model.PageSize);
                DataSet ds = dao.SelectReconcileRuleBySubCompany(param,start,model.PageSize,out totalCount);
                model.RstResultList = JsonHelper.DataTableToArrayList(ds.Tables[0]);
                model.DataCount = totalCount;
                model.IsSuccess = true;
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message);
            }
            var data = new { data = model.RstResultList, total = model.DataCount };
            var result = new { success = model.IsSuccess, data = data };
            return JsonHelper.Serialize(result);
        }

        public ReconcileRuleVO Update(ReconcileRuleVO model)
        {
            try
            {
                ReconcileRuleDao dao = new ReconcileRuleDao();
                ReconcileRule obj = new ReconcileRule() { SubCompanyId = model.SubCompanyId, Rules = model.ReconcileRule};
                int cnt = dao.UpdateReconcileRule(obj);
                model.IsSuccess = true;
            }
            catch(Exception ex)
            {
                LogHelper.Error(ex);

                model.IsSuccess = false;
                model.ExecuteMessage.Add(ex.Message); 
            }
            return model;
        }
    }
}
